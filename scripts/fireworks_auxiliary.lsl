    /*

                        Fourmilab Fireworks
                         Auxiliary Services

        This script resides in the launcher top prim.  Its primary
        purpose is to provide a source for sound clips played by the
        Play command and, by originating in a different prim, not
        conflict with firework sounds from other links.  Since we
        have it, it's also used to offshore some code which would
        otherwise consume script memory in the main script.

    */

    key owner;                          // Owner UUID
    key whoDat = NULL_KEY;              // Avatar who sent command

    float angleScale;                   // Angle scale factor

    //  Firework shell messages
    integer LM_FS_PLAY = 93;            // Play sound clip
    integer LM_FS_LEGEND = 94;          // Update floating text legend
    integer LM_FS_STAT = 95;            // Display status

    //  Snoop on Script Processor messages for housekeeping
    integer LM_SP_STAT = 52;            // Print status

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

    //  ef  --  Edit floats in string to parsimonious representation

    string eff(float f) {
        return ef((string) f);
    }

    string efa(float a) {
        return ef((string) (a / angleScale));
    }

    //  Static constants to avoid costly allocation
    string efkdig = "0123456789";
    string efkdifdec = "0123456789.";

    string ef(string s) {
        integer p = llStringLength(s) - 1;

        while (p >= 0) {
            //  Ignore non-digits after numbers
            while ((p >= 0) &&
                   (llSubStringIndex(efkdig, llGetSubString(s, p, p)) < 0)) {
                p--;
            }
            //  Verify we have a sequence of digits and one decimal point
            integer o = p - 1;
            integer digits = 1;
            integer decimals = 0;
            string c;
            while ((o >= 0) &&
                   (llSubStringIndex(efkdifdec, (c = llGetSubString(s, o, o))) >= 0)) {
                o--;
                if (c == ".") {
                    decimals++;
                } else {
                    digits++;
                }
            }
            if ((digits > 1) && (decimals == 1)) {
                //  Elide trailing zeroes
                integer b = p;
                while ((b >= 0) && (llGetSubString(s, b, b) == "0")) {
                    b--;
                }
                //  If we've deleted all the way to the decimal point, remove it
                if ((b >= 0) && (llGetSubString(s, b, b) == ".")) {
                    b--;
                }
                //  Remove everything we've trimmed from the number
                if (b < p) {
                    s = llDeleteSubString(s, b + 1, p);
                    p = b;
                }
                //  Done with this number.  Skip to next non digit or decimal
                while ((p >= 0) &&
                       (llSubStringIndex(efkdifdec, llGetSubString(s, p, p)) >= 0)) {
                    p--;
                }
            } else {
                //  This is not a floating point number
                p = o;
            }
        }
        return s;
    }

    //  eOnOff  -- Edit an on/off parameter

    string eOnOff(integer p) {
        if (p) {
            return "on";
        }
        return "off";
    }

    /*  inventoryName  --   Extract inventory item name from Set subcmd.
                            This is a horrific kludge which allows
                            names to be upper and lower case.  It finds the
                            subcommand in the lower case command then
                            extracts the text that follows, trimming leading
                            and trailing blanks, from the upper and lower
                            case original command.   */

    string inventoryName(string subcmd, string lmessage, string message) {
        //  Find subcommand in Set subcmd ...
        integer dindex = llSubStringIndex(lmessage, subcmd);
        //  Advance past space after subcmd
        dindex += llSubStringIndex(llGetSubString(lmessage, dindex, -1), " ") + 1;
        //  Note that STRING_TRIM elides any leading and trailing spaces
        return llStringTrim(llGetSubString(message, dindex, -1), STRING_TRIM);
    }

    /*  fixArgs  --  Transform command arguments into canonical form.
                     All white space within vector and rotation brackets
                     is elided so they will be parsed as single arguments.  */

    string fixArgs(string cmd) {
        cmd = llStringTrim(cmd, STRING_TRIM);
        integer l = llStringLength(cmd);
        integer inbrack = FALSE;
        integer i;
        string fcmd = "";

        for (i = 0; i < l; i++) {
            string c = llGetSubString(cmd, i, i);
            if (inbrack && (c == ">")) {
                inbrack = FALSE;
            }
            if (c == "<") {
                inbrack = TRUE;
            }
            if (!((c == " ") && inbrack)) {
                fcmd += c;
            }
        }
        return fcmd;
    }

    default {

        on_rez(integer n) {
            llResetScript();
        }

        state_entry() {
            whoDat = owner = llGetOwner();
        }


        /*  The link_message() event receives commands from other scripts
            script and passes them on to the script processing functions
            within this script.  */

        link_message(integer sender, integer num, string str, key id) {
            whoDat = id;

            //  Firework Auxiliary messages

            //  LM_FS_PLAY (92): Play sound clip

            if (num == LM_FS_PLAY) {
                llPlaySound(str, 10);

            //  LM_FS_LEGEND (94): Update floating text legend

            } else if (num == LM_FS_LEGEND) {
                if (llSubStringIndex(str, " ") < 0) {
                    //  No arguments: clear legend
                    llSetText("", ZERO_VECTOR, 0);
                    llSetLinkPrimitiveParamsFast(LINK_ROOT,
                        [ PRIM_TEXT, "", ZERO_VECTOR, 0 ]);
                } else {
                    integer cp = llSubStringIndex(str, ",");
                    integer commandChannel = (integer) llGetSubString(str, 0, cp - 1);
                    string message = llGetSubString(str, cp + 1, -1);
                    string lmessage = fixArgs(llToLower(message));
                    list args = llParseString2List(lmessage, [ " " ], []);
                    integer argn = llGetListLength(args);
                    string sparam = llList2String(args, 1);
                    string ltext = inventoryName("le", lmessage, message);
                    vector colour = <0, 1, 0>;      // Default colour
                    if (llGetSubString(sparam, 0, 0) == "<") {
                        colour = (vector) sparam;
                        ltext = llStringTrim(llGetSubString(ltext,
                            llSubStringIndex(ltext, ">") + 1, -1), STRING_TRIM);
                    }
                    integer i;
                    if ((i = llSubStringIndex(ltext, "<channel>")) >= 0) {
                        ltext = llDeleteSubString(ltext, i, i + 8);
                        ltext = llInsertString(ltext, i, (string) commandChannel);
                    }
                    llSetText(ltext, colour, 1);
                }

            //  LM_FS_STAT (95): Update floating text legend

            } else if (num == LM_FS_STAT) {
//tawk(str);
                list sta = llCSV2List(str);
                angleScale = llList2Float(sta, 9);
                integer mFree = llList2Integer(sta, 0);
                integer mUsed = llList2Integer(sta, 1);
                tawk(llList2String(sta, 2) + " status:\n" +
                        "  Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string)
                            ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)" + "\n" +
                        "  Fireworks shells installed: " + llList2String(sta, 10) + "\n" +
                        "  Azimuth min " + efa(llList2Float(sta, 3)) +
                        " max " + efa(llList2Float(sta, 4)) + "\n" +
                        "  Elevation min " + efa(llList2Float(sta, 5)) +
                        " max " + efa(llList2Float(sta, 6)) + "\n" +
                        "  Radius min " + eff(llList2Float(sta, 7)) +
                        " max " + eff(llList2Float(sta, 8)) + "\n" +
                        "  Interval min " + eff(llList2Float(sta, 11)) +
                        " max " + eff(llList2Float(sta, 12)) + "\n" +
                        "  Trace: " + eOnOff(llList2Integer(sta, 13)) +
                        "  Echo: " + eOnOff(llList2Integer(sta, 14)) +
                        "  Angles: " + llList2String([ "degrees", "radians" ],
                            angleScale == 1)
                       );
                tawk("  Dictionary: " + llList2CSV(llList2List(sta, 15, -1)));

                //  Report our own status
                string stat = "Auxiliary script status:\n";
                mFree = llGetFreeMemory();
                mUsed = llGetUsedMemory();
                stat += "  Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
                tawk(stat);

                //  Request status of Script Processor and Fireworks Shells
                llMessageLinked(LINK_SET, LM_SP_STAT, "", id);
            }
        }
    }
