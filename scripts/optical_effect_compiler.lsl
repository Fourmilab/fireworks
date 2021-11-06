/*

                        Fourmilab Fireworks
                       Optical Effect Compiler

    This program takes a list defining a LSL llParticleSystem()
    definition and translates it into equivalent Optical
    declarations for Fourmilab Fireworks.  Simply write a
    function modeled on the ones embedded below to define
    your particle system and recompile the script.  As soon
    as it runs, it will output the Optical declarations for
    the particle system where they can be copied and pasted
    into a configuration notecard.

    You can test the particle system by touching the compiler
    object to start the particle system running and touch it
    again to turn it off.  */

    key owner;                      // Owner UUID

    integer commandChannel = 1750;  /* Command channel in chat */
    integer commandH;               // Handle for command channel
    key whoDat = NULL_KEY;          // Avatar who sent command
    integer restrictAccess = 0;     // Access restriction: 0 none, 1 group, 2 owner
    integer echo = TRUE;            // Echo chat and script commands ?
    float angleScale = DEG_TO_RAD;  // Scale factor for angles

    string helpFileName = "Fourmilab Fireworks User Guide";

    //  Compiler messages
    integer LM_OC_REQUEST = 300;                // Request effect definition
    integer LM_OC_REPLY = 301;                  // Return effect definition

    /*  The particle system definition function should
        store the name and the list defining the particle
        system into the following two variables.  */

    string psname;
    list psys;

    vector lastHSV;

    integer toggle = FALSE;             // Touch toggle

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

    //  checkAccess  --  Check if user has permission to send commands

    integer checkAccess(key id) {
        return (restrictAccess == 0) ||
               ((restrictAccess == 1) && llSameGroup(id)) ||
               (id == llGetOwner());
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

    //  processCommand  --  Process a command

    integer processCommand(key id, string message) {
        list args;              // Argument list
        integer argn;           // Argument list length

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

        //  Boot                    Reset the script to initial settings

        } else if (abbrP(command, "bo")) {
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

        //  Generate patname        Generate patname

        } else if (abbrP(command, "ge")) {
            llMessageLinked(LINK_THIS, LM_OC_REQUEST, sparam, whoDat);
            llSetTimerEvent(0.25);      // Start no-response timeout

        //  Help                    Give help information

        } else if (abbrP(command, "he")) {
            llGiveInventory(id, helpFileName);      // Give requester the User Guide notecard

        //  List                    List defined effects

        } else if (abbrP(command, "li")) {
            integer n = llGetInventoryNumber(INVENTORY_SCRIPT);
            integer i;
            integer j = 0;
            for (i = 0; i < n; i++) {
                string s = llGetInventoryName(INVENTORY_SCRIPT, i);
                if ((s != "") && (llGetSubString(s, 0, 8) == "Optical: ")) {
                    tawk("  " + (string) (++j) + ". " + llGetSubString(s, 9, -1));
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

                //  Set echo on/off

                } else if (abbrP(sparam, "ec")) {
                    echo = onOff(svalue);

                } else {
                    tawk("Setting unknown.");
                    return FALSE;
                }

        //  Status                  Print status

        } else if (abbrP(command, "st")) {
            string stat = "";
            integer mFree = llGetFreeMemory();
            integer mUsed = llGetUsedMemory();
            stat += "    Script memory.  Free: " + (string) mFree +
                    "  Used: " + (string) mUsed + " (" +
                    (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
            tawk(stat);

        } else {
            tawk("Huh?  \"" + message + "\" undefined.  Chat /" +
                (string) commandChannel + " help for instructions.");
            return FALSE;
        }
        return TRUE;
    }

/*
    //  Spiral ejection of crystals, which rise upward

    crystals() {
        psname = "fwspiral";
        psys = [
                PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                                 PSYS_PART_EMISSIVE_MASK |
                                 PSYS_PART_FOLLOW_VELOCITY_MASK ,
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
                PSYS_SRC_MAX_AGE, 1.5,
                PSYS_PART_MAX_AGE, 1.5,
                PSYS_SRC_BURST_SPEED_MIN, 1,
                PSYS_SRC_BURST_SPEED_MAX, 2,
                PSYS_SRC_ACCEL, <0, 0, 0.2>,
                PSYS_SRC_BURST_RATE, 0.05,
                PSYS_SRC_BURST_PART_COUNT, 10,
                PSYS_SRC_ANGLE_BEGIN,  0,
                PSYS_SRC_ANGLE_END, 90 * DEG_TO_RAD,
                PSYS_SRC_OMEGA, <0, 0, 20>,
                PSYS_PART_START_SCALE, <0.25, 0.25, 0.0>,
                PSYS_PART_START_ALPHA, 1.0,
                PSYS_PART_END_ALPHA, 0.5,
                PSYS_SRC_TEXTURE, "181c6b1d-c2d0-70ba-bbf2-52ccc31687c6"
        ];
    }

    //  Rain falling down from above
    rain() {
        psname = "rain";
        psys = [PSYS_PART_MAX_AGE,1.20,
                PSYS_PART_FLAGS, 259,
                PSYS_PART_START_COLOR, <0.73, 0.84, 0.79>,
                PSYS_PART_END_COLOR, <0.61, 0.76, 0.82>,
                PSYS_PART_START_SCALE,<0.10, 0.00, 0.00>,
                PSYS_PART_END_SCALE,<0.10, 3.69, 0.00>,
                PSYS_SRC_PATTERN, 8,
                PSYS_SRC_BURST_RATE,0.10,
                PSYS_SRC_BURST_PART_COUNT,25,
                PSYS_SRC_BURST_RADIUS,5.57,
                PSYS_SRC_BURST_SPEED_MIN,0.11,
                PSYS_SRC_BURST_SPEED_MAX,0.64,
                PSYS_SRC_ANGLE_BEGIN, 0.00,
                PSYS_SRC_ANGLE_END, 0.78,
                PSYS_SRC_MAX_AGE, 0.0,
                PSYS_SRC_TEXTURE, "06675bc5-e9b9-0557-7179-fbf7779faed8",
                PSYS_PART_START_ALPHA, 0.20,
                PSYS_PART_END_ALPHA, 0.75,
                PSYS_SRC_ACCEL, <-0.37, 0.45, -12.00>];
    }

    //  Dark smoke rising from a fire
    smoke() {
        psname = "smoke";
        psys = [PSYS_PART_MAX_AGE,2.50,
                PSYS_PART_FLAGS, 259,
                PSYS_PART_START_COLOR, <0.18, 0.16, 0.13>,
                PSYS_PART_END_COLOR, <0.59, 0.65, 0.62>,
                PSYS_PART_START_SCALE,<0.15, 0.15, 0.00>,
                PSYS_PART_END_SCALE,<0.77, 1.21, 0.00>,
                PSYS_SRC_PATTERN, 2,
                PSYS_SRC_BURST_RATE,0.00,
                PSYS_SRC_BURST_PART_COUNT,4,
                PSYS_SRC_BURST_RADIUS,0.00,
                PSYS_SRC_BURST_SPEED_MIN,0.07,
                PSYS_SRC_BURST_SPEED_MAX,0.35,
                PSYS_SRC_ANGLE_BEGIN, 1.65,
                PSYS_SRC_ANGLE_END, 0.00,
                PSYS_SRC_MAX_AGE, 0.0,
                PSYS_SRC_TEXTURE, "006d9758-81da-38a9-9be3-b6c941cae931",
                PSYS_PART_START_ALPHA, 0.40,
                PSYS_PART_END_ALPHA, 0.00,
                PSYS_SRC_ACCEL, <0.00, 0.00, 1.14>];
    }
*/

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
        "sbsmax", PSYS_SRC_BURST_SPEED_MAX, TYPE_FLOAT,
        "sab", PSYS_SRC_INNERANGLE, "sae", PSYS_SRC_OUTERANGLE  // Deprecated, replaced
    ];

    //  ef  --  Edit floats in string to parsimonious representation

    string efv(vector v) {
        return ef((string) v);
    }

    string eff(float f) {
        return ef((string) f);
    }

    string efa(float a) {
        return ef((string) (a / angleScale));
    }

/*
    string efr(rotation r) {
        return efv(llRot2Euler(r) * RAD_TO_DEG);
    }
*/

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

    /*  psDecodeBasic  --  Decode particle system rule set from JSON string

        This is complicated by the fact that JSON doesn't distinguish
        LSL-specific data types such as vectors and keys from strings.
        We have to identify these by their rule type codes and cast
        accordingly when assembling the decoded list.  */

    list psDecodeBasic(list l) {
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
                v = (vector)  llList2String(l, i + 1);
                o += [ v ];
            } else {
                integer lty = llGetListEntryType(l, i + 1);
                if (rule == PSYS_SRC_TARGET_KEY) {
                    o += [ llList2String(l, i + 1) ];
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

    /*  effEncode  --  Encode the particle system as an Optical
                       declaration.  */

    effEncode() {
        string os = "\n";
        string oe = "Optical " + psname;
        integer n = llGetListLength(psys);
        integer m = llGetListLength(keywords);
        if ((n & 1) != 0) {
            tawk("psys list length is odd");
            return;
        }
        integer i;
        for (i = 0; i < n; i += 2) {
            integer rule = llList2Integer(psys, i);
            integer ty = llGetListEntryType(psys, i + 1);
            integer Vi;
            float Vf;
            string Vs;
            key Vk;
            vector Vv;
            if (ty == TYPE_INTEGER) {
                Vf = Vi = llList2Integer(psys, i + 1);
            } else if (ty == TYPE_FLOAT) {
                Vf = llList2Float(psys, i + 1);
            } else if (ty == TYPE_STRING) {
                Vs = llList2String(psys, i + 1);
            } else if (ty == TYPE_KEY) {
                Vk = llList2Key(psys, i + 1);
            } else if (ty == TYPE_VECTOR) {
                Vv = llList2Vector(psys, i + 1);
            } else {
                tawk("Blooie!  Unknown type " + (string) ty +
                    " for rule " + (string) rule +
                    " at index " + (string) i);
            }

            integer j;
            for (j = 0; j < m; j += 3) {
                if (llList2Integer(keywords, j + 1) == rule) {
                    jump cazart;
                }
            }
            tawk("Cannot find abbreviation for rule " + (string) rule +
                 " at index " + (string) i);
            tawk("\n>> " + llList2CSV(llList2List(psys, 0, i - 1)) + "\n<< " +
                llList2CSV(llList2List(psys, i, -1)));
            return;
@cazart;
            string spec = " " + llList2String(keywords, j) + " ";
            integer tl = llList2Integer(keywords, j + 2);
            string ts;
            if (tl == TYPE_INTEGER) {
                ts = (string) Vi;
            } else if (tl == TYPE_FLOAT) {
                ts = eff(Vf);
            } else if (tl == TYPE_ANGLE) {
                ts = efa(Vf);
            } else if (tl == TYPE_STRING) {
                ts = Vs;
            } else if (tl == TYPE_KEY) {
                ts = Vs;
            } else if (tl == TYPE_VECTOR) {
                ts = efv(Vv);
            }
            spec += ts;
            if ((llStringLength(oe) + llStringLength(spec)) > 80) {
                os += oe + "\n    Optical " + psname ;
                oe = "";
            }
            oe += spec;
        }
        os += oe;
        tawk(os);
    }

    default {
        state_entry() {
            whoDat = owner = llGetOwner();

            llSetTexture("fireworks_512", ALL_SIDES);
            llSetAlpha(1, ALL_SIDES);
            llSetLinkPrimitiveParamsFast(LINK_THIS,
                [ PRIM_TEXT, "Fourmilab Fireworks\nOptical Effect Compiler", <0, 1, 0>, 1 ]);
            llParticleSystem([ ]);          // Clear any orphaned particle system

            //  Start listening on the command chat channel
            commandH = llListen(commandChannel, "", NULL_KEY, "");
            llOwnerSay("Listening on /" + (string) commandChannel);
//crystals();
        }

        /*  The listen event handler processes messages from
            our chat control channel.  */

        listen(integer channel, string name, key id, string message) {
            if (channel == commandChannel) {
                processCommand(id, message);
            }
        }

        /*  The link_message() event receives the particle system
            parameters from the definition script that responds to
            our LM_OC_REQUEST query and generates the Optical
            statements to define it.  */

        link_message(integer sender, integer num, string str, key id) {
            if (num == LM_OC_REPLY) {
                llSetTimerEvent(0);     // Clear no-response timeout
//tawk("Eff: " + str);
                list l = llJson2List(str);
                psname = llList2String(l, 0);
                l = llDeleteSubList(l, 0, 0);
                psys = psDecodeBasic(l);
//tawk("Dec: " + llList2CSV(psys));
                effEncode();
            }
        }

        touch_start(integer ndet) {
            toggle = !toggle;
            if (toggle) {
                llSetAlpha(0.2, ALL_SIDES);
                llSetTexture(TEXTURE_BLANK, ALL_SIDES);
                list ps = psys;
                /*  Scan the particle system and replace colour
                    specifications which have coded negative
                    red channel values (.x) with random or previous
                    HSV values in the same manner the firework shell
                    does.  This allows testing optical effects using
                    this feature within the compiler.  The random
                    selection is made every time the effect is previewed,
                    simulating its behaviour when installed in the
                    launcher.  */
                integer i;
                integer n = llGetListLength(ps);
                for (i = 0; i < n; i += 2) {
                    integer rn = llList2Integer(ps, i);
                    if ((rn == PSYS_PART_START_COLOR) ||
                        (rn == PSYS_PART_END_COLOR)) {
                        vector v = llList2Vector(ps, i + 1);
                        if ((v.x < 0) || (v.y < 0) || (v.z < 0)) {
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
                            ps = llListReplaceList(ps, [ v ], i + 1, i + 1);
                        }
                    }
                }
                llParticleSystem(ps);
                tawk("Particles on");
            } else {
                llParticleSystem([ ]);
                tawk("Particles off");
                llSetTexture("fireworks_512", ALL_SIDES);
                llSetAlpha(1, ALL_SIDES);
            }
        }

        /*  We use the timer to detect failure of a definition
            script to respond to a LM_OC_REQUEST message.  This
            indicates the user has specified an undefined optical
            definition.  Doing it this way means we don't need a
            list of valid definitions, and that new definitions
            can be added simply by adding their scripts to the
            compiler's inventory.  */

        timer() {
            llSetTimerEvent(0);         // Cancel timer
            tawk("Optical effect not defined.\n" +
                 "Use List to see defined effects.");
        }
    }
