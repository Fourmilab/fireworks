    /*

                     Fourmilab Queued Sound Player

        Sound clips in Second Life are limited to ten seconds.
        This script manages playing a sequence of clips which,
        concatenated, represent a longer continuous sound.  The
        script is given a list of clips and their lengths in
        seconds.  It preloads the clips, and using llSetSoundQueueing()
        plays the first two clips, queueing the second.  At the
        estimated time of each clip's conclusion plus an episilon
        in case of lag, we enqueue the next clip in seqience.  When
        all have played, LM_QP_DONE is sent to the requester.
    */

    key owner;                          // Owner UUID
    key whoDat = NULL_KEY;              // Avatar who sent command
    integer trace = TRUE;               // Trace operations ?
    float ttime;                        // Start time for trace
    float volume;                       // Volume to play clips
    float tepsilon = 0.5;               // Safety factor for clip length
    integer prelmax = 3;                // Maximum clips to preload
    integer prelnext;                   // Next clip to preload

    list clips;                         // Clips to play
    integer nclips;                     // Number of clips
    list times;                         // Length of clips in seconds
    integer playing = FALSE;            // Are we playing ?
    integer curclip;                    // Current playing clip
    integer player;                     // Link requesting clip playing

    //  Queued sound player messages
    integer LM_QP_RESET = 81;           // Reset script
    integer LM_QP_STAT = 82;            // Print status
    integer LM_QP_LOAD = 83;            // Preload clips to play
    integer LM_QP_PLAY = 84;            // Play clips
    integer LM_QP_STOP = 85;            // Stop current clip
    integer LM_QP_DONE = 86;            // Notify play complete
    integer LM_QP_LOADED = 87;          // Notify clips loaded

    //  Snoop on Script Processor messages for housekeeping
    integer LM_SP_RESET = 51;           // Reset script
    integer LM_SP_STAT = 52;            // Print status
    integer LM_SP_SETTINGS = 59;        // Set operating modes

    //  tawk  --  Send a message to the interacting user in chat

    tawk(string msg) {
        if (whoDat == NULL_KEY) {
            //  No known sender.  Say in nearby chat.
            llSay(PUBLIC_CHANNEL, msg);
        } else {
            /*  While debugging, when speaking to the owner, use llOwnerSay()
                rather than llRegionSayTo() to avoid the risk of a runaway
                blithering loop triggering the gag which can only be removed
                by a region restart.  */
            if (owner == whoDat) {
                llOwnerSay(msg);
            } else {
                llRegionSayTo(whoDat, PUBLIC_CHANNEL, msg);
            }
        }
    }

    default {
        state_entry() {
            whoDat = owner = llGetOwner();

            clips = [ ];
            times = [ ];
            playing = FALSE;
            llSetSoundQueueing(TRUE);
        }

        link_message(integer sender, integer num, string str, key id) {

            //  LM_QP_RESET (81): Reset script

            if ((num == LM_QP_RESET) || (num == LM_SP_RESET)) {
                llResetScript();

            //  LM_QP_STAT (82): Print status

            } else if ((num == LM_QP_STAT) || (num == LM_SP_STAT)) {
                string stat = "Queued sound player:\n";
                integer mFree = llGetFreeMemory();
                integer mUsed = llGetUsedMemory();
                stat += "    Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
                stat += "\n    Playing: " + (string) playing;
                stat += "\n    Clips: " + llList2CSV(clips);
                stat += "\n    Times: " + llList2CSV(times);
                tawk(stat);

            //  LM_QP_LOAD (83): Load clips

            } else if (num == LM_QP_LOAD) {
                list l = llJson2List(str);
                integer n = llGetListLength(l);
                clips = [ ];
                times = [ ];
                nclips = 0;

                if (trace) {
                    tawk("Loading " + (string) (n / 2) + " clips:");
                    ttime = llGetTime();
                }
                integer i;
                integer npl = n;
                if ((prelmax * 2) < npl) {
                    npl = prelmax * 2;
                }
                prelnext = npl / 2;
                for (i = 0; i < n; i += 2) {
                    string c = llList2String(l, i);
                    if (i < npl) {
                        if (trace) {
                            tawk("    Load " + c);
                        }
                        llPreloadSound(c);
                    } else {
                        if (trace) {
                            tawk("    Defer " + c);
                        }
                    }
                    clips += [ c ];
                    times += [ llList2Float(l, i + 1) ];
                }
                nclips = n / 2;
                if (trace) {
                    tawk("Load complete, " + (string) (llGetTime() - ttime) +
                         " seconds.");
                }
                llMessageLinked(sender, LM_QP_LOADED, "", id);

            //  LM_QP_PLAY (84): Start playing clips

            } else if (num == LM_QP_PLAY) {
                whoDat = id;
                if (playing) {
                    llStopSound();
                    playing = FALSE;
                }
                if (nclips > 0) {
                    volume = (float) str;
                    playing = TRUE;
                    player = sender;
                    //  Start first clip
                    llPlaySound(llList2String(clips, 0), volume);
                    if (trace) {
                        ttime = llGetTime();
                        tawk("Play " + llList2String(clips, 0));
                    }
                    curclip = 0;
                    if (nclips > 1) {
                        //  Two or more clips: pre-queue second clip
                        llPlaySound(llList2String(clips, 1), volume);
                        if (trace) {
                            tawk("Queue " + llList2String(clips, 1));
                        }
                        curclip = 1;
                    }
                    //  Start timer to first when first clip completes
                    llSetTimerEvent(llList2Float(times, 0) + tepsilon);
                }

            //  LM_QP_STOP (85): Stop playing clips

            } else if (num == LM_QP_STOP) {
                if (playing) {
                    llStopSound();
                    curclip = nclips + 1;
                    //  Let timer handle resetting clips
                    llSetTimerEvent(0.01);
                    llMessageLinked(sender, LM_QP_DONE, "", whoDat);
                }

            //  LM_SP_SETTINGS (59): Set processing modes

            } else if (num == LM_SP_SETTINGS) {
                list args = llCSV2List(str);
                trace = llList2Integer(args, 0);
            }
        }

        /*  The timer is used to queue the next clip after the
            play time of the previous has elapsed.  We queue the
            next clip at time tepsilon after the expected end of
            the clip to avoid going too soon if the clip take a
            little longer to complete (perhaps due to a delay
            getting started.  */

        timer() {
            curclip++;
            if (curclip > nclips) {
                //  Last clip has completed.  Turn off timer and send done
                playing = FALSE;
                llSetTimerEvent(0);
                if (trace) {
                    tawk("Timer " + (string) (llGetTime() - ttime) +
                                 "  Done.");
                }
                llMessageLinked(player, LM_QP_DONE, "", whoDat);
                /*  If we have been dynamically preloading clips as
                    we've been playing, the first prelmax clips may
                    now have been unloaded.  Reload them now in case
                    the loaded group is played again.  */
                if (nclips > prelmax) {
                    integer i;

                    for (i = 0; i < prelmax; i++) {
                        string c = llList2String(clips, i);

                        if (trace) {
                            tawk("    Reload " + c);
                        }
                        llPreloadSound(c);
                    }
                    prelnext = prelmax;
                }
            } else {
                if (curclip < nclips) {
                    //  Pre-queue next clip and wait for current to complete
                    llPlaySound(llList2String(clips, curclip), volume);
                    if (trace) {
                        tawk("Timer " + (string) (llGetTime() - ttime) +
                             "  " + llList2String(clips, curclip));
                    }
                    llSetTimerEvent(llList2Float(times, curclip - 1));
                    //  If clips remain to load, start the next one loading
                    if (prelnext < nclips) {
                        string c = llList2String(clips, prelnext);
                        if (trace) {
                            tawk("    Load " + c);
                        }
                        llPreloadSound(c);
                        prelnext++;
                    }
                } else {
                    //  Last clip is playing.  Wait for it to complete
                    if (trace) {
                        tawk("Timer " + (string) (llGetTime() - ttime) +
                             "  last clip.");
                    }
                    llSetTimerEvent(llList2Float(times, nclips - 1));
                }
            }
        }
    }
