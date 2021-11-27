    /*

                    Fourmilab Fireworks

    */

    key owner;                      // Owner UUID

    integer commandChannel = 1749;  /* Command channel in chat
                                       (Composition of Handel's Music
                                       for the Royal Fireworks [HWV 351)]) */
    integer commandH;               // Handle for command channel
    integer menuChannel = -982449833;   // Menu communications channel
    integer menuListen = 0;         // Menu listener
    float menuTimeout = 0;          // Menu timeout time (llGetTime() value)
    key whoDat = NULL_KEY;          // Avatar who sent command
    integer restrictAccess = 0;     // Access restriction: 0 none, 1 group, 2 owner
    integer echo = TRUE;            // Echo chat and script commands ?

    float angleScale = DEG_TO_RAD;  // Scale factor for angles
    integer trace = FALSE;          // Trace operation ?

    float elevMin;                  // Minimum elevation (set to PI / 4 at state_entry)
    float elevMax = PI_BY_TWO;      // Maximum elevation
    float aziMin = 0;               // Minimum azimuth
    float aziMax = TWO_PI;          // Maximum azimuth
    float radMin = 2;               // Minimum radius
    float radMax = 5;               // Maximum radius
    float intervMin = 0.75;         // Minimum interval
    float intervMax = 2.5;          // Maximum interval

    //  Script processing

    integer scriptActive = FALSE;   // Are we reading from a script ?
    integer scriptSuspend = FALSE;  // Suspend script execution for asynchronous event
    integer waitingShells = FALSE;  // Waiting for all shells to be idle

    //  Group clip play

    integer gloading = 0;           // Group loading in progesss
    integer gloaded = FALSE;        // Is a group of clips loaded ?
    integer gplaying = FALSE;       // Are we playing a sequence of clips ?
    integer gwaiting = FALSE;       // Are we waiting for a load or play to complete ?

    string configScript = "Script: Configuration";
    string helpFileName = "Fourmilab Fireworks User Guide";

    integer lTop;                   // Fireworks top link number
    vector pTop;                    // Fireworks top local position
    vector szTop;                   // Fireworks top size
    integer lBrim;                  // Fireworks bottom link number
    list aShells;                   // Available (ready to launch) shells
    integer nShells;                // Number of firework shells

    list deferLaunch;               // Launch commands awaiting shells

    list dictionary;                // Dictionary of known objects
    integer DTYPE_OPTICAL = 1;          // Optical effect
    integer DTYPE_SOUND = 2;            // Sound clip
    integer DTYPE_GROUP = 3;            // Group
    integer DTYPE_URL = 4;              // Web URL
    list dictvalues;                // Dictionary entry values

    //  Link messages

    //  Command processor messages

    integer LM_CP_COMMAND = 223;        // Process command

    //  Script Processor messages
    integer LM_SP_INIT = 50;            // Initialise
    integer LM_SP_RESET = 51;           // Reset script
//  integer LM_SP_STAT = 52;            // Print status
    integer LM_SP_RUN = 53;             // Enqueue script as input source
    integer LM_SP_GET = 54;             // Request next line from script
    integer LM_SP_INPUT = 55;           // Input line from script
    integer LM_SP_EOF = 56;             // Script input at end of file
    integer LM_SP_READY = 57;           // Script ready to read
    integer LM_SP_ERROR = 58;           // Requested operation failed
    integer LM_SP_SETTINGS = 59;        // Set operating modes

    //  Queued sound player messages
//  integer LM_QP_RESET = 81;           // Reset script
//  integer LM_QP_STAT = 82;            // Print status
    integer LM_QP_LOAD = 83;            // Preload clips to play
    integer LM_QP_PLAY = 84;            // Play clips
    integer LM_QP_STOP = 85;            // Stop current clip
    integer LM_QP_DONE = 86;            // Notify play complete
    integer LM_QP_LOADED = 87;          // Notify clips loaded

    //  Firework shell messages
    integer LM_FS_LAUNCH = 90;          // Launch shell
    integer LM_FS_RESET = 91;           // Reset script
    integer LM_FS_IDLE = 92;            // Notification when shell idle
    integer LM_FS_PLAY = 93;            // Play sound clip
    integer LM_FS_LEGEND = 94;          // Update floating text legend
    integer LM_FS_STAT = 95;            // Display status
    integer LM_FS_MEDIA = 96;           // Control media playback
    integer LM_FS_OPEN = 97;            // Change top open status

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

    /*  Find a linked prim from its name.  Avoids having to slavishly
        link prims in order in complex builds to reference them later
        by link number.  You should only call this once, in state_entry(),
        and then save the link numbers in global variables.  Returns the
        prim number or -1 if no such prim was found.  Caution: if there
        are more than one prim with the given name, the first will be
        returned without warning of the duplication.  */

    integer findLinkNumber(string pname) {
        integer i = llGetLinkNumber() != 0;
        integer n = llGetNumberOfPrims() + i;

        for (; i < n; i++) {
            if (llGetLinkName(i) == pname) {
                return i;
            }
        }
        return -1;
    }

    //  randRange  --  Return a pseudorandom float within the given range

    float randRange(float rmin, float rmax) {
        return rmin + llFrand(rmax - rmin);
    }

    //  dictAdd  --  Add an item to the dictionary

    integer dictAdd(string iname, integer itype, string ivalue) {
        if (llListFindList(dictionary, [ iname ]) < 0) {
            dictionary += [ iname, itype];
            dictvalues += [ ivalue ];
        } else {
            tawk("Item " + iname + " already defined.");
            return FALSE;
        }
        return TRUE;
    }

    //  dictLook  --  Look for an item in the dictionary

    integer dictLook(string iname) {
        integer dx = llListFindList(dictionary, [ iname ]);
        if (dx >= 0) {
            dx /= 2;
        }
        return dx;
    }

    //  dictChoose  -- Choose an item from the dictionary

    string dictValue;               // Hidden return value from dictChoose() to save space

    string dictChoose(string iname) {
        integer dx;
        while ((dx = dictLook(iname)) >= 0) {
            if (llList2Integer(dictionary, (dx * 2) + 1) != DTYPE_GROUP) {
                dictValue = llList2String(dictvalues, dx);   // Sneaky return dictionary value
                return iname;
            }
            list gl = llJson2List(llList2String(dictvalues, dx));
            iname = llList2String(gl, (integer) llFrand(llGetListLength(gl)));
        }
        tawk("Object " + iname + " not found in dictionary.");
        dictValue = "";
        return "";
    }

    //  saveTop  -- Save initial position and size of top

    saveTop() {
        list tl = llGetLinkPrimitiveParams(lTop,
            [ PRIM_POS_LOCAL, PRIM_SIZE ]);
        pTop = llList2Vector(tl, 0);
        szTop = llList2Vector(tl, 1);
    }

    //  tipTop  -- Tip the top of the hat

    tipTop(integer open) {
        llMessageLinked(lTop, LM_FS_OPEN, (string) open, whoDat);
        if (open) {
            llSetLinkPrimitiveParamsFast(lTop,
                [ PRIM_POS_LOCAL, pTop + (<0, -szTop.y, szTop.y> / 2),
                  PRIM_ROT_LOCAL, llEuler2Rot(<PI_BY_TWO, 0, 0>)
                ]);
        } else {
            llSetLinkPrimitiveParamsFast(lTop,
                [ PRIM_POS_LOCAL, pTop,
                  PRIM_ROT_LOCAL, ZERO_ROTATION
                 ]);
        }
    }

    //  salvo  --  Fire a salvo of multiple launches

    integer salvoCount = 0;             // Shots remaining in salvo
    float salvoEnd = 0;                 // Salvo end time (llGetTime() value)
    float salvoTime = 0;                // Time of next shot
    list salvoArgs;                     // Arguments for launch command

    salvo() {
@salvoNext;
        string sct = (string) salvoCount;
        if (salvoEnd > 0) {
            sct = "T=" + (string) (salvoEnd - llGetTime());
        }
        integer ok = processCommand(whoDat,
            "La_Salvo:" + sct, 2);
        //  If we've reached the end of a timed salvo, stop it
        if ((salvoEnd > 0) && (llGetTime() > salvoEnd)) {
            salvoEnd = 0;
            salvoCount = 0;
        }
        salvoCount--;
        float nextTime;
        if (ok && (salvoCount > 0)) {
            nextTime = randRange(intervMin, intervMax);
            if (nextTime <= 0) {
                nextTime = 0.001;
            }
            salvoTime = llGetTime() + nextTime;
        } else {
            salvoTime = -1;
            salvoCount = 0;
            salvoArgs = [ ];
        }
        if ((salvoTime >= 0) && (nextTime < 0.01)) {
            jump salvoNext;
        } else {
            windCat();
        }
    }

    //  windCat  --  Set the timer to the next scheduled event

    integer timerTask;                  // Next task for timer

    windCat() {
        float nextEvent = salvoTime;
        timerTask = 0;
        if (nextEvent > 0) {
            timerTask = 1;              // Next event is salvo
        }
        if ((menuTimeout > 0) &&
            ((nextEvent == 0) || (menuTimeout < nextEvent))) {
            nextEvent = menuTimeout;
            timerTask = 2;              // Mark next event menu timeout
        }
        if (timerTask > 0) {
            llSetTimerEvent(nextEvent - llGetTime());
        } else {
            llSetTimerEvent(0);
        }
    }

    //  sendSettings  --  Send settings to other scripts

    sendSettings() {
        llMessageLinked(LINK_SET, LM_SP_SETTINGS,
            llList2CSV([ trace, echo ]), whoDat);
    }

    //  checkAccess  --  Check if user has permission to send commands

    integer checkAccess(key id) {
        return (restrictAccess == 0) ||
               ((restrictAccess == 1) && llSameGroup(id)) ||
               (id == llGetOwner());
    }

    /*  parseOptical  --  Parse an optical declaration
            Optical name var1 value1 var2 value2...  */


    integer parseOptical(list args, integer argn) {
        integer TYPE_ANGLE = 7;         /* We distinguish angles from floats
                                           in order to apply angleScale to them */
        list keywords = [
            "pf", PSYS_PART_FLAGS, TYPE_INTEGER, "sp", PSYS_SRC_PATTERN, TYPE_INTEGER,
            "sbrad", PSYS_SRC_BURST_RADIUS, TYPE_FLOAT, "sab", PSYS_SRC_ANGLE_BEGIN, TYPE_ANGLE,
            "sae", PSYS_SRC_ANGLE_END, TYPE_ANGLE, "stk", PSYS_SRC_TARGET_KEY, TYPE_KEY,
            "psc", PSYS_PART_START_COLOR, TYPE_VECTOR, "pec", PSYS_PART_END_COLOR, TYPE_VECTOR,
            "psa", PSYS_PART_START_ALPHA, TYPE_FLOAT, "pea", PSYS_PART_END_ALPHA, TYPE_FLOAT,
            "pss", PSYS_PART_START_SCALE, TYPE_VECTOR, "pes", PSYS_PART_END_SCALE, TYPE_VECTOR,
            "st", PSYS_SRC_TEXTURE, TYPE_STRING, "psg", PSYS_PART_START_GLOW, TYPE_FLOAT,
            "peg", PSYS_PART_END_GLOW, TYPE_FLOAT,
            "pbfs", PSYS_PART_BLEND_FUNC_SOURCE, TYPE_INTEGER,
            "pbfd", PSYS_PART_BLEND_FUNC_DEST, TYPE_INTEGER,
            "sma", PSYS_SRC_MAX_AGE, TYPE_FLOAT, "pma", PSYS_PART_MAX_AGE, TYPE_FLOAT,
            "sbrat", PSYS_SRC_BURST_RATE, TYPE_FLOAT,
            "sbpc", PSYS_SRC_BURST_PART_COUNT, TYPE_INTEGER,
            "sa", PSYS_SRC_ACCEL, TYPE_VECTOR, "so", PSYS_SRC_OMEGA, TYPE_VECTOR,
            "sbsmin", PSYS_SRC_BURST_SPEED_MIN, TYPE_FLOAT,
            "sbsmax", PSYS_SRC_BURST_SPEED_MAX, TYPE_FLOAT
        ];
        integer i;
        string bname = llList2String(args, 1);
        list rules;

        for (i = 2; i < argn; i += 2) {
            string kw = llList2String(args, i);
            if ((i + 1) >= argn) {
                tawk("Value missing after keyword " + kw);
                return FALSE;
            }
            string val = llList2String(args, i + 1);
            integer n = llListFindList(keywords, [ kw ]);
            if (n < 0) {
                tawk("Unknown keyword " + kw);
                return FALSE;
            }
            rules += [ llList2Integer(keywords, n + 1) ];
            integer atype = llList2Integer(keywords, n + 2);

            if (atype == TYPE_INTEGER) {
                rules += [ (integer) val ];
            } else if (atype == TYPE_FLOAT) {
                rules += [ (float) val ];
            } else if (atype == TYPE_ANGLE) {
                rules += [ ((float) val) * DEG_TO_RAD ];
            } else if (atype == TYPE_KEY) {
                rules += [ (key) val ];
            } else if (atype == TYPE_VECTOR) {
                if (llGetSubString(val, 0, 0) == "<") {
                    rules += [ (vector) val ];
                } else {
                    //  This is a logical vector specification
                    rules += [ val ];
                }
            } else /* if (atype == TYPE_STRING) */ {
                rules += [ val ];
            }
        }

        /*  We have now assembled the list of rule, value pairs.
            Check whether there is an existing definition of a
            burst with this name and, if so, append the rules in
            this definition to the existing ones.   */

        integer d = dictLook(bname);
        if (d >= 0) {
            dictvalues = llListReplaceList(dictvalues,
                [ llList2Json(JSON_ARRAY,
                    llJson2List(llList2String(dictvalues, d)) + rules) ], d, d);
        } else {
            return dictAdd(bname, DTYPE_OPTICAL, llList2Json(JSON_ARRAY, rules));
        }
        return TRUE;
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

    //  abbrP  --  Test if string matches abbreviation

    integer abbrP(string str, string abbr) {
        return abbr == llGetSubString(str, 0, llStringLength(abbr) - 1);
    }

    //  onOff  --  Parse an on/off parameter

    integer onOff(string param) {
        if (abbrP(param, "on")) {
            return TRUE;
        } else if (abbrP(param, "of")) {
            return FALSE;
        } else {
            tawk("Error: please specify on or off.");
            return -1;
        }
    }

    /*  scriptResume  --  Resume script execution when asynchronous
                          command completes.  */

    scriptResume() {
        if (scriptActive) {
            if (scriptSuspend) {
                scriptSuspend = FALSE;
                llMessageLinked(LINK_THIS, LM_SP_GET, "", NULL_KEY);
                if (trace) {
                    tawk("Script resumed.");
                }
            }
        }
    }

    //  defArg  --  Return argument or default if argument "-" or absent

    //  Hidden arguments to defArg() to save space
    list args;              // Argument list
    integer argn;           // Argument list length

    string defArg(integer argi, string defval) {
        if (argi < argn) {
            string argv = llList2String(args, argi);
            if (argv != "-") {
                return argv;
            }
        }
        return defval;
    }

    //  processCommand  --  Process a command

    integer processCommand(key id, string message, integer fromScript) {

        if (!checkAccess(id)) {
            llRegionSayTo(id, PUBLIC_CHANNEL,
                "You do not have permission to control this object.");
            return FALSE;
        }

        whoDat = id;            // Direct chat output to sender of command

        /*  If echo is enabled, echo command to sender unless
            prefixed with "@".  The command is prefixed with ">>"
            if entered from chat or "++" if from a script.  */

        integer echoCmd = TRUE;
        if (llGetSubString(llStringTrim(message, STRING_TRIM_HEAD), 0, 0) == "@") {
            echoCmd = FALSE;
            message = llGetSubString(llStringTrim(message, STRING_TRIM_HEAD), 1, -1);
        }
        if (echo && echoCmd) {
            string prefix = ">> /" + (string) commandChannel + " ";
            if (fromScript == TRUE) {
                prefix = "++ ";
            } else if (fromScript == 2) {
                prefix = "== ";
            } else if (fromScript == 3) {
                prefix = "<< ";
            }
            tawk(prefix + message);                 // Echo command to sender
        }

        string lmessage = fixArgs(llToLower(message));
        args = llParseString2List(lmessage, [ " " ], []);    // Command and arguments
        argn = llGetListLength(args);               // Number of arguments
        string command = llList2String(args, 0);    // The command
        string sparam = llList2String(args, 1);     // First argument, for convenience

        //  Access who                  Restrict chat command access to public/group/owner

        if (abbrP(command, "ac")) {
            string who = sparam;

            if (abbrP(who, "p")) {          // Public
                restrictAccess = 0;
            } else if (abbrP(who, "g")) {   // Group
                restrictAccess = 1;
            } else if (abbrP(who, "o")) {   // Owner
                restrictAccess = 2;
            } else {
                tawk("Unknown access restriction \"" + who +
                    "\".  Valid: public, group, owner.\n");
                return FALSE;
            }

        //  Audio sound1[=UUID] sound2...     Define sound clips

        } else if (abbrP(command, "au")) {
            integer i;

            for (i = 1; i < argn; i++) {
                string sname = llList2String(args, i);
                integer eqx;
                if ((eqx = llSubStringIndex(sname, "=")) > 0) {
                    string suuid = llGetSubString(sname, eqx + 1, -1);
                    sname = llGetSubString(sname, 0, eqx - 1);
                    if (llGetSubString(suuid, 8, 8) != "-") {
                        tawk("Invalid UUID " + suuid + " for sound " + sname);
                        return FALSE;
                    }
                    if (!dictAdd(sname, DTYPE_SOUND, (key) suuid)) {
                        return FALSE;
                    }
                } else {
                    if (llGetInventoryType(sname) == INVENTORY_SOUND) {
                        if (!dictAdd(sname, DTYPE_SOUND, llGetInventoryKey(sname))) {
                            return FALSE;
                        }
                    } else {
                        tawk("Sound " + sname + " not found in inventory.");
                        return FALSE;
                    }
                }
            }

        //  Boot                    Reset the script to initial settings

        } else if (abbrP(command, "bo")) {
            tipTop(FALSE);
            llSleep(0.25);
            llResetScript();

        /*  Channel n               Change command channel.  Note that
                                    the channel change is lost on a
                                    script reset.  */
        } else if (abbrP(command, "ch")) {
            integer newch = (integer) sparam;
            if ((newch < 2)) {
                tawk("Invalid channel " + (string) newch + ".");
                return FALSE;
            } else {
                llListenRemove(commandH);
                commandChannel = newch;
                commandH = llListen(commandChannel, "", NULL_KEY, "");
                tawk("Listening on /" + (string) commandChannel);
            }

        //  Clear                   Clear chat for debugging

        } else if (abbrP(command, "cl")) {
            tawk("\n\n\n\n\n\n\n\n\n\n\n\n\n");

        //  Delete name...          Delete name from dictionary

        } else if (abbrP(command, "de")) {
            integer i;
            for (i = 1; i < argn; i++) {
                integer di = dictLook(llList2String(args, i));
                if (di >= 0) {
                    integer dx = di * 2;
                    dictionary = llDeleteSubList(dictionary, dx, dx + 1);
                    dictvalues = llDeleteSubList(dictvalues, di, di);
                }
            }

        //  Echo text               Send text to sender

        } else if (abbrP(command, "ec")) {
            integer dindex = llSubStringIndex(lmessage, command);
            integer doff = llSubStringIndex(llGetSubString(lmessage, dindex, -1), " ");
            string emsg = " ";
            if (doff >= 0) {
                emsg = llStringTrim(llGetSubString(message, dindex + doff + 1, -1),
                            STRING_TRIM_TAIL);
            }
            tawk(emsg);

        //  Embed URL               Embed audio content from URL

        } else if (abbrP(command, "em")) {
            if (argn > 1) {
                dictChoose(sparam);
            } else {
                dictValue = "";
            }
            llMessageLinked(lBrim, LM_FS_MEDIA, dictValue, whoDat);

        //  Gload gname             Load a group containing a sequence of audio clips

        } else if (abbrP(command, "gl")) {
            if (gloading || gplaying) {
                tawk("Gload/Gplay busy");
                return FALSE;
            }
            integer di = dictLook(sparam);
            if (di >= 0) {
                list clist = [ ];
                integer i;
                list dl = llJson2List(llList2String(dictvalues, di));
                integer dln = llGetListLength(dl);

                for (i = 0; i < dln; i++) {
                    float ctime = 10;
                    string sname = llList2String(dl, i);

                    if (llGetInventoryType(sname) == INVENTORY_SOUND) {
                        clist += llGetInventoryKey(sname);
                        if ((i + 1) < dln) {
                            string pt = llList2String(dl, i + 1);
                            if ((llGetSubString(pt, 0, 0) == "[") &&
                                (llGetSubString(pt, -1, -1) == "]")) {
                                ctime = (float) llGetSubString(pt, 1, -2);
                                i++;
                            }
                        }
                        clist += ctime;
                    }
                }
                llMessageLinked(lBrim, LM_QP_LOAD,
                    llList2Json(JSON_ARRAY, clist), whoDat);
                gloading = TRUE;                // Mark load in progress
                gloaded = FALSE;                // Load incomplete
            }

        //  Gplay volume/stop           Play the loaded group of clips

        } else if (abbrP(command, "gp")) {
            if (abbrP(sparam, "st")) {
                llMessageLinked(lBrim, LM_QP_STOP, "", whoDat);
            } else {
                if (gplaying) {
                    tawk("Clips already playing.");
                    return FALSE;
                }
                float volume = 10;
                if (argn >= 2) {
                    volume = (float) sparam;
                }
                if (gloaded) {
                    llMessageLinked(lBrim, LM_QP_PLAY, (string) volume, whoDat);
                    gplaying = TRUE;
                } else {
                    tawk("No group of clips loaded.");
                    return FALSE;
                }
            }

        //  Gwait                   Wait for group load or play to complete

        } else if (abbrP(command, "gw")) {
            if (gloading || gplaying) {
                scriptSuspend = TRUE;
                gwaiting = TRUE;
            }

        //  Group gname member1 member2...  Define a group of objects

        } else if (abbrP(command, "gr")) {
            return dictAdd(sparam, DTYPE_GROUP,
                llList2Json(JSON_ARRAY, llList2List(args, 2, -1)));

        //  Help                    Give help information

        } else if (abbrP(command, "he")) {
            llGiveInventory(id, helpFileName);      // Give requester the User Guide notecard

        //  Launch burst_effect burst_sound launch_effect launch_sound
        //         ascent_time hang_time burst_duration

        } else if (abbrP(command, "la")) {
            if (abbrP(command, "la_salvo")) {
                args = [ "la" ] + salvoArgs;
                argn = llGetListLength(args);
            }
            if (llGetListLength(aShells) == 0) {
                deferLaunch += [ message ];
                return TRUE;
            }
            string exburstn = dictChoose(defArg(1, "burst"));
            string exburst = dictValue;
            string sBurst = dictChoose(defArg(2, "explode"));
            if (sBurst != "") {
                sBurst = dictValue;
            }
            string ascentn = dictChoose(defArg(3, "ascent"));
            string ascent = dictValue;
            string sLaunch = dictChoose(defArg(4, "launch"));
            if (sLaunch != "") {
                sLaunch = dictValue;
            }
            float ascTime = (float) defArg(5, "0.5");
            float flightTime = (float) defArg(6, "0.25");
            float burstTime = (float) defArg(7, "1");

            float r = randRange(radMin, radMax);
            float azimuth = randRange(aziMin, aziMax);
            float elevation = randRange(elevMin, elevMax);
            vector target = <r, 0, 0> * (llAxisAngle2Rot(<0, 1, 0>, -elevation) *
                                         llAxisAngle2Rot(<0, 0, 1>, azimuth));
            if (llGetListLength(aShells) > 0) {
                integer slink = llList2Integer(aShells, 0);
                aShells = llDeleteSubList(aShells, 0, 0);
                llMessageLinked(slink, LM_FS_LAUNCH, llList2Json(JSON_ARRAY, [
                        sLaunch,            // 0 Sound to play at launch
                        ascentn,            // 1 Ascent effect name
                        ascent,             // 2 Ascent optical effect
                        ascTime,            // 3 Ascent optical effect duration
                        flightTime,         // 4 Time of flight before detonation
                        target,             // 5 Target in local co-ordinates
                        sBurst,             // 6 Burst sound
                        exburst,            // 7 Burst optical effect parameters
                        burstTime,          // 8 Burst duration
                        exburstn            // 9 Burst optical effect name
                ]), whoDat);
           }

        //  Legend [ <r, g, b> ] Text       Display floating text legend

        } else if (abbrP(command, "le")) {
            llMessageLinked(lTop, LM_FS_LEGEND, (string) commandChannel + "," + message, whoDat);

        //  Menu item1 item2...             Display a menu dialogue

        } else if (abbrP(command, "me")) {
            if (menuListen != 0) {
                llListenRemove(menuListen);
                menuListen = 0;
            }
            menuListen = llListen(menuChannel, "", whoDat, "");
            menuTimeout =  llGetTime() + 60;
            windCat();
            //  Re-parse, preserving case
            args = llParseString2List(message, [ " " ], []);
            llDialog(whoDat, "Fireworks command",
                llList2List(args, 1, -1), menuChannel);

        //  Optical name key1 arg1 key2 arg2...   Declare an optical effect particle system

        } else if (abbrP(command, "op")) {
            parseOptical(args, argn);

        //  Play audio              Play an audio clip

        } else if (abbrP(command, "pl")) {
            if (argn < 2) {
                //  Stop sound if no argument
                llMessageLinked(lTop, LM_FS_PLAY, "", whoDat);
            } else {
                string clipname = sparam;
                string loopy = "";
                if (llGetSubString(clipname, 0, 0) == "+") {
                    clipname = llDeleteSubString(clipname, 0, 0);
                    loopy = "+";
                }
                if (dictChoose(clipname) != "") {
                     llMessageLinked(lTop, LM_FS_PLAY, loopy + dictValue, whoDat);
                }
            }

        //  Salvo n                 Launch a salvo of n shots

        } else if (abbrP(command, "sa")) {
            integer howmany = (integer) sparam;
            if (howmany == 0) {
                //  Argument of zero cancels in-progress salvo
                salvoTime = 0;
                salvoCount = 0;
            } else {
                if ((salvoCount > 0) && (howmany > 0)) {
                    //  If salvo in progress, add argument to count
                    salvoCount += howmany;
                } else {
                    //  No salvo active: start a new one
                    if (argn > 2) {
                        salvoArgs = llList2List(args, 2, -1);
                    } else {
                        salvoArgs = [ ];
                    }
                    if (howmany > 0) {
                        salvoCount = howmany;
                    } else {
                        salvoEnd = llGetTime() - ((float) sparam);
                        salvoCount = (1 << 31) - 1;
                    }
                    salvo();
                }
            }

        //  Set                     Set parameter

        } else if (abbrP(command, "se")) {
            string svalue = llList2String(args, 2);

            //  Set angles degrees/radians  Set angle input to degrees or radians

            if (abbrP(sparam, "an")) {
                if (abbrP(svalue, "d")) {
                    angleScale = DEG_TO_RAD;
                } else if (abbrP(svalue, "r")) {
                    angleScale = 1;
                } else {
                    tawk("Invalid set angle.  Valid: degree, radian.");
                }

                //  Set azimuth min [ max ]

                } else if (abbrP(sparam, "az")) {
                    aziMin = aziMax = ((float) svalue) * angleScale;
                    if (argn > 3) {
                        aziMax = llList2Float(args, 3) * angleScale;
                    }

                //  Set echo on/off

                } else if (abbrP(sparam, "ec")) {
                    echo = onOff(svalue);
                    sendSettings();

                //  Set elevation min [ max ]

                } else if (abbrP(sparam, "el")) {
                    elevMin = elevMax = ((float) svalue) * angleScale;
                    if (argn > 3) {
                        elevMax = llList2Float(args, 3) * angleScale;
                    }

                //  Set interval min [ max ]

                } else if (abbrP(sparam, "in")) {
                    intervMin = intervMax = (float) svalue;
                    if (argn > 3) {
                        intervMax = llList2Float(args, 3);
                    }

                //  Set radius min [ max ]

                } else if (abbrP(sparam, "ra")) {
                    radMin = radMax = (float) svalue;
                    if (argn > 3) {
                        radMax = llList2Float(args, 3);
                    }

                //  Set top on/off

                } else if (abbrP(sparam, "to")) {
                    tipTop(!onOff(svalue));

                //  Set trace on/off

                } else if (abbrP(sparam, "tr")) {
                    trace = onOff(svalue);
                    sendSettings();

                } else {
                    tawk("Setting unknown.");
                    return FALSE;
                }

        //  Status                  Print status

        } else if (abbrP(command, "st")) {
            llMessageLinked(lTop, LM_FS_STAT, llList2CSV(
                [ llGetFreeMemory(), llGetUsedMemory(), llGetScriptName(),
                  aziMin, aziMax, elevMin, elevMax, radMin, radMax,
                  angleScale, nShells, intervMin, intervMax, trace, echo,
                  llList2CSV(dictionary) ]), whoDat);

        //  URL                     Declare URL for embedded audio

        } else if (abbrP(command, "ur")) {
            message = llStringTrim(message, STRING_TRIM);
            integer n = llSubStringIndex(message, " ");
            message = llStringTrim(llGetSubString(message, n + 1, -1), STRING_TRIM);
            n = llSubStringIndex(message, " ");
            message = llStringTrim(llGetSubString(message, n + 1, -1), STRING_TRIM);
            if (!dictAdd(sparam, DTYPE_URL, message)) {
                return FALSE;
            }

        //  Wait                    Wait for all shells to return

        } else if (abbrP(command, "wa")) {
            if (llGetListLength(aShells) < nShells) {
                /*  One or more shells are busy.  Suspend script execution
                    until all are idle.  */
                scriptSuspend = TRUE;
                waitingShells = TRUE;
            }

        //     Handled by other scripts

        //  Script                  Script commands

        } else if (abbrP(command, "sc")) {
            llMessageLinked(LINK_THIS, LM_CP_COMMAND,
                llList2Json(JSON_ARRAY, [ message, lmessage ] + args), whoDat);

        } else {
            tawk("Huh?  \"" + message + "\" undefined.  Chat /" +
                (string) commandChannel + " help for instructions.");
            return FALSE;
        }
        return TRUE;
    }

    default {

        on_rez(integer n) {
            llResetScript();
        }

        state_entry() {

            //  Clear any existing legend
            llSetText("", ZERO_VECTOR, 0);

            whoDat = owner = llGetOwner();

            lTop = findLinkNumber("Fireworks Top");
            saveTop();
            lBrim = findLinkNumber("Fireworks Bottom");

            elevMin = PI / 4;               // Set minimum elevation to 45 degrees

            //  Find the fireworks shells in the launcher
            integer i = 1;
            integer l;
            do {
                l = findLinkNumber("Fireworks Shell " + (string) i);
                if (l > 0) {
                    aShells += [ l ];
                    i++;
                }
            } while (l > 0);
            nShells = llGetListLength(aShells);
            //  Reset all the shell scripts
            llMessageLinked(LINK_THIS, LM_FS_RESET, "", whoDat);

            //  Cancel any orphaned particle system
            llParticleSystem([ ]);

            //  Start listening on the command chat channel
            commandH = llListen(commandChannel, "", NULL_KEY, "");
            llOwnerSay("Listening on /" + (string) commandChannel);

            //  Reset the script processor
            llMessageLinked(LINK_SET, LM_SP_RESET, "", whoDat);
            llSleep(0.1);           // Allow script process to finish reset
            sendSettings();
            if (llGetInventoryType(configScript) == INVENTORY_NOTECARD) {
                llMessageLinked(LINK_THIS, LM_SP_RUN, configScript, whoDat);
            }
        }

        /*  The listen event handler processes messages from
            our chat control channel.  */

        listen(integer channel, string name, key id, string message) {
            if (channel == commandChannel) {
                processCommand(id, message, FALSE);
            } else if (channel == menuChannel) {
                processCommand(id, "Script run " + message, 2);
                menuListen = 0;
            }
        }

        /*  The link_message() event receives commands from other scripts
            script and passes them on to the script processing functions
            within this script.  */

        link_message(integer sender, integer num, string str, key id) {

            //  Firework Shell messages

            //  LM_FS_IDLE (92): Shell idle

            if (num == LM_FS_IDLE) {
                aShells += [ sender ];
                if (llGetListLength(deferLaunch) > 0) {
                    string dl = llList2String(deferLaunch, 0);
                    deferLaunch = llDeleteSubList(deferLaunch, 0, 0);
                    processCommand(whoDat, dl, 3);
                } else {
                    if (waitingShells && (salvoCount == 0) &&
                        (llGetListLength(aShells) == nShells)) {
                        scriptResume();
                    }
                }

            //  Script Processor messages

            //  LM_SP_READY (57): Script ready to read

            } else if (num == LM_SP_READY) {
                scriptActive = TRUE;
                llMessageLinked(LINK_THIS, LM_SP_GET, "", id);  // Get the first line

            //  LM_SP_INPUT (55): Next executable line from script

            } else if (num == LM_SP_INPUT) {
                if (str != "") {                // Process only if not hard EOF
                    scriptSuspend = FALSE;
                    integer stat = processCommand(id, str, TRUE); // Some commands set scriptSuspend
                    if (stat) {
                        if (!scriptSuspend) {
                            llMessageLinked(LINK_THIS, LM_SP_GET, "", id);
                        }
                    } else {
                        //  Error in script command.  Abort script input.
                        scriptActive = scriptSuspend = FALSE;
                        llMessageLinked(LINK_THIS, LM_SP_INIT, "", id);
                        tawk("Script terminated.");
                    }
                }

            //  LM_SP_EOF (56): End of file reading from script

            } else if (num == LM_SP_EOF) {
                scriptActive = FALSE;           // Mark script input complete

            //  LM_SP_ERROR (58): Error processing script request

            } else if (num == LM_SP_ERROR) {
                llRegionSayTo(id, PUBLIC_CHANNEL, "Script error: " + str);
                scriptActive = scriptSuspend = FALSE;
                llMessageLinked(LINK_THIS, LM_SP_INIT, "", id);

            //  LM_QP_LOADED (87): Group sound clips loaded

            } else if (num == LM_QP_LOADED) {
                gloading = FALSE;
                gloaded = TRUE;
                if (gwaiting) {
                    scriptResume();
                }
            } else if (num == LM_QP_DONE) {
                gplaying = FALSE;
                if (gwaiting) {
                    scriptResume();
                }
            }
        }

        /*  The timer is used to cancel any orphaned listeners
            created for menus the chooses to ignore, and also
            for sequencing the shots of a salvo.  This use is
            multiplexed by windCat into a rudimentary event
            sequencer.  */

        timer() {
            if (timerTask == 1) {
                salvo();
            } else if (timerTask == 2) {
                llListenRemove(menuListen);
                menuListen = 0;
                menuTimeout = 0;
            }
            windCat();
        }

        //  The touch event is a short-cut to run the "Touch" script

        touch_start(integer howmany) {
            if (llGetInventoryType("Script: Touch") == INVENTORY_NOTECARD) {
                processCommand(llDetectedKey(0), "Script run Touch", FALSE);
            }
        }

        //  If launcher rescaled, update position and size of top

        changed(integer what) {
            if (what & CHANGED_SCALE) {
                saveTop();
            }
        }
    }
