/*
                        Fireworks Shell

        One or more of these objects is linked to the fireworks
        launcher and is normally hidden inside.  When given a
        launch command, it plays the launch sound, moves to the
        specified burst location (given relative to the
        launcher's position), then plays the burst sound and
        particle effect, making itself invisible.  After the
        specified dwell time, it return to the launcher awaiting
        its next mission.
*/

    vector sColour;                     // Shell colour
    integer plink = 0;                  // Sender of active launch command
    integer trace = FALSE;              // Trace operations ?
    key owner;                          // Owner of object
    key whoDat = NULL_KEY;              // Avatar who sent command

    //  Firework shell messages
    integer LM_FS_LAUNCH = 90;          // Launch shell
    integer LM_FS_RESET = 91;           // Reset script
    integer LM_FS_IDLE = 92;            // Notification when shell idle

    //  Snoop on Script Processor messages for housekeeping
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

    /*  psDecode  --  Decode particle system rule set from JSON string

        This is complicated by the fact that JSON doesn't distinguish
        LSL-specific data types such as vectors and keys from strings.
        We have to identify these by their rule type codes and cast
        accordingly when assembling the decoded list.  This is also
        where we implement the gimmick to specify random colour
        specifications.  If any of the components of a colour triple
        is negative, it is taken as a HSV colour specification.  A
        specification of <-1, 1, 1> picks a random hue with full
        saturation and intensity, while <-2, 0.7, 0.25> picks a colour
        with the same hue as the last random specification, saturation
        0.7, and intensity 0.25.

        We also decode logical key specifications here.  For the "stk"
        (PSYS_SRC_TARGET_KEY) rule, we allow either an explicit UUID
        key or "self" or "root" to specify the key of the shell itself
        or the root prim (its launcher).  */

    vector lastHSV;

    list psDecode(string json, vector target) {
        list l = llJson2List(json);
        integer n = llGetListLength(l);
        list o;
        integer i;
        list vectype = [ PSYS_PART_START_COLOR, PSYS_PART_END_COLOR,
                         PSYS_PART_START_SCALE, PSYS_PART_END_SCALE,
                         PSYS_SRC_OMEGA, PSYS_SRC_ACCEL ];

        for (i = 0; i < n; i += 2) {
            integer rule = llList2Integer(l, i);
            o += [ rule ];
            if (llListFindList(vectype, [ rule ]) >= 0) {
                vector v;
                string vs = llList2String(l, i + 1);
                if (vs == "target") {
                    v = llVecNorm(target);
                } else {
                    v = (vector)  llList2String(l, i + 1);
                    if (((rule == PSYS_PART_START_COLOR) ||
                        (rule == PSYS_PART_END_COLOR)) &&
                       ((v.x < 0) || (v.y < 0) || (v.z < 0))) {
                        if (v.x < 0) {
                            if (v.x == -2) {
                                v.x = lastHSV.x;
                            } else {
                                v.x = llFrand(1);
                            }
                        }
                        if (v.y < 0) {
                            if (v.y == -2) {
                                v.y = lastHSV.y;
                            } else {
                                v.y = llFrand(1);
                            }
                        }
                        if (v.z < 0) {
                            if (v.z == -2) {
                                v.z = lastHSV.z;
                            } else {
                                v.z = llFrand(1);
                            }
                        }
                        lastHSV = v;
                        v = hsv_to_rgb(v);
                    }
                    }
                o += [ v ];
            } else {
                integer lty = llGetListEntryType(l, i + 1);
                if (rule == PSYS_SRC_TARGET_KEY) {
                    string ks = llList2String(l, i + 1);
                    key k;
                    if (ks == "self") {
                        k = llGetKey();
                    } else if (ks == "root") {
                        k = llGetLinkKey(LINK_ROOT);
                    } else {
                        k = (key) ks;
                    }
                    o += [ k ];
                } else if (lty == TYPE_INTEGER) {
                    o += [ llList2Integer(l, i + 1) ];
                } else if (lty == TYPE_FLOAT) {
                    o += [ llList2Float(l, i + 1) ];
                } else if (lty == TYPE_STRING) {
                    o += [ llList2String(l, i + 1) ];
                }
            }
        }
        return o;
    }

    //  reload  --  Return to mortar launcher, reappear

    reload() {
        llParticleSystem([ ]);
        llSetLinkPrimitiveParams(LINK_THIS,
            [ PRIM_POS_LOCAL, ZERO_VECTOR ]);
        //  Notify launcher we're ready to launch again
        llMessageLinked(plink, LM_FS_IDLE, "", NULL_KEY);
        llSetAlpha(1, ALL_SIDES);
        plink = 0;
    }

    /*  hsv_to_rgb  --  Convert HSV colour values stored in a vector
                        (H = x, S = y, V = z) to RGB (R = x, G = y, B = z).
                        The Hue is specified as a number from 0 to 1
                        representing the colour wheel angle from 0 to 360
                        degrees, while saturation and value are given as
                        numbers from 0 to 1.  */

    vector hsv_to_rgb(vector hsv) {
        float h = hsv.x;
        float s = hsv.y;
        float v = hsv.z;

        if (s == 0) {
            return < v, v, v >;             // Grey scale
        }

        if (h >= 1) {
            h = 0;
        }
        h *= 6;
        integer i = (integer) llFloor(h);
        float f = h - i;
        float p = v * (1 - s);
        float q = v * (1 - (s * f));
        float t = v * (1 - (s * (1 - f)));
        if (i == 0) {
            return < v, t, p >;
        } else if (i == 1) {
            return < q, v, p >;
        } else if (i == 2) {
            return <p, v, t >;
        } else if (i == 3) {
            return < p, q, v >;
        } else if (i == 4) {
            return < t, p, v >;
        } else if (i == 5) {
            return < v, p, q >;
        }
//llOwnerSay("Blooie!  " + (string) hsv);
        return < 0, 0, 0 >;
    }

    //  Launch state machine

    integer lstate;                 // Launcher state
    vector tgt;                     // Burst location
    key launchSound;                // Launch sound key
    list launchPS;                  // Launch effect particle system
    list explodePS;                 // Burst effect particle system
    float ascentTime;               // Ascent time
    float hangTime;                 // Launch to detonation time
    key burstSound;                 // Burst sound key
    float burstTime;                // Burst duration

    launcher() {
        float ntime;

        if (lstate == 0) {
            //  0:  Start, perform launch actions
            llSetLinkPrimitiveParamsFast(LINK_THIS,
                [ PRIM_GLOW, ALL_SIDES, 0.7,
                  PRIM_POS_LOCAL, tgt * 0.1
                 ]);
            //  Activate launch particle system
            llLinkParticleSystem(plink, launchPS);
            //  Play launch sound, if any
            if (launchSound != NULL_KEY) {
                llPlaySound(launchSound, 10);
            }
            lstate = 1;
            ntime = ascentTime;
        } else if (lstate == 1) {
            //  1:  Fly to detonation location
            llSetLinkPrimitiveParamsFast(LINK_THIS, [ PRIM_POS_LOCAL, tgt ]);
            lstate = 2;
            ntime = hangTime;
        } else if (lstate == 2) {
            //  2:  Burst, perform detonation actions
            //  Turn off glow and hide projectile
            llSetLinkPrimitiveParamsFast(LINK_THIS,
                [ PRIM_COLOR, ALL_SIDES, sColour, 0, PRIM_GLOW, ALL_SIDES, 0 ]);
            //  Activate burst particle system
            llParticleSystem(explodePS);
            //  Play burst sound
            if (burstSound != NULL_KEY) {
                llPlaySound(burstSound, 10);
            }
            lstate = 3;
            ntime = burstTime;
        } else if (lstate == 3) {
            //  3:  Reload, ready for next shot
            llLinkParticleSystem(plink, [ ]);
            reload();
            lstate = 0;
            ntime = 0;
        }
        llSetTimerEvent(ntime);
    }

    default {
        state_entry() {
            whoDat = owner = llGetOwner();
            sColour = llGetColor(ALL_SIDES);
            llSetStatus(STATUS_PHANTOM, TRUE);
            reload();
        }

        link_message(integer sender, integer num, string str, key id) {
            whoDat = id;

            //  LM_FS_LAUNCH (90): Launch shell

            if (num == LM_FS_LAUNCH) {
                list args = llJson2List(str);
                /*  Arguments:
                        0   Launch sound key
                        1   Launch effect name
                        2   Launch effect (JSON)
                        3   Ascent time
                        4   Hang time (launch to detonation)
                        5   Target location in local co-ordinates
                        6   Burst sound key
                        7   Burst effect (JSON)
                        8   Burst duration
                        9   Burst effect name
                */
                if (trace) {
                    tawk("Launch: " + llList2String(args, 1) + " - " +
                         llList2String(args, 9) + " - " + llList2String(args, 5));
                }

                //  Decode arguments into global state
                plink = sender;             // Mark busy on behalf of sender
                tgt = (vector) llList2String(args, 5);
                launchSound = llList2Key(args, 0);
                launchPS = psDecode(llList2String(args, 2), tgt);
                explodePS = psDecode(llList2String(args, 7), tgt);
                ascentTime = llList2Float(args, 3);
                hangTime = llList2Float(args, 4);
                burstSound = llList2Key(args, 6);
                burstTime = llList2Float(args, 8);
                lstate = 0;
                launcher();

            //  LM_FS_RESET (91): Reset script

            } else if (num == LM_FS_RESET) {
                llResetScript();

            //  LM_SP_STAT (52): Report status

            } else if (num == LM_SP_STAT) {
                list states = [ "Idle", "Ascent", "Burst", "Reload" ];
                string stat = "Status: " + llList2String(states, lstate) + "\n";
                integer mFree = llGetFreeMemory();
                integer mUsed = llGetUsedMemory();
                stat += "    Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
                tawk(stat);

            //  LM_SP_SETTINGS (59): Set processing modes

            } else if (num == LM_SP_SETTINGS) {
                trace = llList2Integer(llCSV2List(str), 0);
            }
        }

        timer() {
            launcher();
        }
    }
