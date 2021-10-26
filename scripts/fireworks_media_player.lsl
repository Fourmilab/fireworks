    /*

                        Fourmilab Fireworks
                            Media Player

        This script resides in the launcher hat brim.  It serves to
        play media requested by the Embed command, which can be used
        to play music and other audio content from Web streaming
        sites.  The video content for the media is hidden on the
        black edge of the brim, leaving only audio apparent.  The
        navigation and control panel is suppressed, leaving no user
        control: it is entirely up to the Embed command to manage
        selection and playback of content.

    */

    key owner;                          // Owner UUID
    key whoDat = NULL_KEY;              // Avatar who sent command
    vector oColour;                     // Original media face colour
    integer ticking;                    // Is timer running ?
    float playLatency = 6;              // Latency before play starts, seconds
    integer trace = FALSE;              // Trace operations ?
    float timerStart;                   // Duration start time

    integer FACE_MEDIA = 1;             // Media player prim face

    //  Firework shell messages
    integer LM_FS_MEDIA = 96;           // Control media playback

    //  Snoop on Script Processor messages for housekeeping
    integer LM_SP_RESET = 51;           // Reset script
    integer LM_SP_STAT = 52;            // Print status
    integer LM_SP_SETTINGS = 59;        // Set operating modes

    //  flLastSubStringIndex  --  Index of last occurrence of pattern in source

    integer flLastSubStringIndex(string source, string pattern) {
        integer ix;
        integer lix = -1;
        integer lpat = llStringLength(pattern);
        while ((source != "") && ((ix = llSubStringIndex(source, pattern)) >= 0)) {
            source = llDeleteSubString(source, 0, ix + lpat);
            lix = ix;
        }
        return lix;
    }

    //  parseTime  --  Parse a time specification: HH:MM:SS.dddd

    float parseTime(string s) {
        float t = 0;
        float factor = 1;
        list l = llParseStringKeepNulls(s, [ ":" ], [ ]);
        while (l != [ ]) {
            t += llList2Float(l, -1) * factor;
            factor *= 60;
            l = llDeleteSubList(l, -1, -1);
        }
        return t;
    }

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

    //  resetMedia  --  Halt any media in progress and restore static texture

    resetMedia() {
        integer stat = llClearLinkMedia(LINK_THIS, FACE_MEDIA);
        if (stat != STATUS_OK) {
            tawk("Error status " + (string) stat + " clearing media");
        }
        //  If squelch timer running, cancel it
        if (ticking) {
            ticking = FALSE;
            llSetTimerEvent(0);
        }
        llSetColor(oColour, FACE_MEDIA);
    }

    default {

        on_rez(integer n) {
            llResetScript();
            oColour = llGetColor(FACE_MEDIA);
        }

        state_entry() {
            whoDat = owner = llGetOwner();
            //  Reset any media which might be playing
           resetMedia();
        }

        /*  The link_message() event receives commands from other scripts
            script and passes them on to the script processing functions
            within this script.  */

        link_message(integer sender, integer num, string str, key id) {
            whoDat = id;

            //  Script processor messages (on which we snoop)

            //  LM_SP_RESET (51): Reset script

            if (num == LM_SP_RESET) {
                llResetScript();

            //  LM_SP_STAT (52): Report status

            } else if (num == LM_SP_STAT) {
                string stat = "Media player:\n";
                integer mFree = llGetFreeMemory();
                integer mUsed = llGetUsedMemory();
                stat += "    Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
                list lms = llGetLinkMedia(LINK_THIS, FACE_MEDIA,
                            [   PRIM_MEDIA_CURRENT_URL,
                                PRIM_MEDIA_AUTO_PLAY,
                                PRIM_MEDIA_CONTROLS,
                                PRIM_MEDIA_PERMS_CONTROL,
                                PRIM_MEDIA_PERMS_INTERACT,
                                PRIM_MEDIA_WIDTH_PIXELS,
                                PRIM_MEDIA_HEIGHT_PIXELS,
                                PRIM_MEDIA_AUTO_SCALE ]);
                string mstat = "Idle";
                if (lms != [ ]) {
                    mstat = llList2CSV(lms);
                }
                stat += "\n    Media: " + mstat;
                tawk(stat);

            //  LM_SP_SETTINGS (59): Set processing modes

            } else if (num == LM_SP_SETTINGS) {
                list args = llCSV2List(str);
                trace = llList2Integer(args, 0);

            //  Firework Auxiliary messages

            //  LM_FS_MEDIA (96): Control media playback

            } else if (num == LM_FS_MEDIA) {
                if (str == "") {
                    resetMedia();
                } else {
                    if (llGetLinkMedia(LINK_THIS, FACE_MEDIA,
                            [   PRIM_MEDIA_CURRENT_URL ]) != [ ]) {
                        llClearLinkMedia(LINK_THIS, FACE_MEDIA);
                        //  Have to wait for llClearLinkMedia() to propagate
                        llSleep(0.1);
                    }
                    string s = str;
                    integer tx = flLastSubStringIndex(s, " [");
                    float trt = -1;
                    if (tx >= 0) {
                        s = llDeleteSubString(s, 0, tx + 1);
                        if (llGetSubString(s, -1, -1) == "]") {
                            s = llDeleteSubString(s, -1, -1);
                            str = llStringTrim(llGetSubString(str, 0, tx - 1), STRING_TRIM);
                            trt = parseTime(s);
                        }
                    }
                    if (trace) {
                        string slength = "unknown";
                        if (trt > 0) {
                            slength = (string) trt + " sec.";
                        }
                        tawk("Playing URL " + str + " Length: " + slength);
                    }
                    if (ticking) {
                        ticking = FALSE;
                        llSetTimerEvent(0);
                    }
                    integer stat = llSetLinkMedia(LINK_THIS, FACE_MEDIA,
                        [   PRIM_MEDIA_CURRENT_URL, str,
                            PRIM_MEDIA_AUTO_PLAY, TRUE,
                            PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
                            PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
                            PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE,
                            PRIM_MEDIA_AUTO_SCALE, FALSE ]
                    );
                    if (stat != STATUS_OK) {
                        tawk("Error status " + (string) stat + " playing URL " +
                            str);
                    } else {
                        if (trt > 0) {
                            if (trace) {
                                tawk("Setting timer: " +
                                     (string) (trt + playLatency));
                                timerStart = llGetTime();
                            }
                            llSetTimerEvent(trt + playLatency);
                            ticking = TRUE;
                        }
                    }
                }
            }
        }

        timer() {
            if (ticking) {
                ticking = FALSE;
                llSetTimerEvent(0);
                llClearLinkMedia(LINK_THIS, FACE_MEDIA);
                if (trace) {
                    tawk("Squelch after " +
                        (string) (llGetTime() - timerStart) + " seconds.");
                }
            }
        }
    }
