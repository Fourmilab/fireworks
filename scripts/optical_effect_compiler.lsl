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

    /*  The particle system definition function should
        store the name and the list defining the particle
        system into the following two variables.  */
    string psname;
    list psys;

    integer toggle = FALSE;             // Touch toggle

    splodey() {
        psname = "splodey";
        psys = [
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                PSYS_SRC_BURST_RADIUS, 0.2,
                PSYS_PART_START_COLOR, <1, 0, 1>,
                PSYS_PART_END_COLOR, <0.2, 0.2, 0.2>,
                PSYS_PART_START_SCALE, <0.3, 0.3, 0>,
                PSYS_PART_END_SCALE, <0.1, 0.1, 0>,
                PSYS_PART_START_GLOW, 0.2,
                PSYS_PART_END_GLOW, 0,
                PSYS_SRC_MAX_AGE, 0.2,
                PSYS_PART_MAX_AGE, 0.75,
                PSYS_SRC_BURST_RATE, 20,
                PSYS_SRC_BURST_PART_COUNT, 1000,
                PSYS_SRC_ACCEL, <0, 0, 0>,
                PSYS_SRC_BURST_SPEED_MIN, 2,
                PSYS_SRC_BURST_SPEED_MAX, 2,
                PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK |
                                 PSYS_PART_FOLLOW_VELOCITY_MASK |
                                 PSYS_PART_INTERP_SCALE_MASK |
                                 PSYS_PART_INTERP_COLOR_MASK
               ];
    }

    snow() {
        psname = "snow";                // Name of particle system
        psys = [
                // Define the particle system here
                PSYS_PART_FLAGS, 0,
                PSYS_PART_START_COLOR, <3.10000, 2.30000, 1.70000>,
                PSYS_PART_END_COLOR, <-0.10000, -0.60000, -1.70000>,
                PSYS_PART_START_SCALE, <0.050000, 0.05000, 0.00000>,
                PSYS_PART_END_SCALE, <0.00000, 0.00000, 0.00000>,
                PSYS_SRC_PATTERN, 8,
                PSYS_SRC_BURST_RATE, 0.000000,
                PSYS_SRC_ACCEL, <0.00000, 0.00000, -0.40000>,
                PSYS_SRC_BURST_PART_COUNT, 10,                  // increase for more snow
                PSYS_SRC_BURST_RADIUS, 0.000000,
                PSYS_SRC_BURST_SPEED_MIN, 0.000000,
                PSYS_SRC_BURST_SPEED_MAX, 0.300000,             // increase for longer distance
                PSYS_SRC_TARGET_KEY, NULL_KEY,
                PSYS_SRC_ANGLE_BEGIN, 3.141593,
                PSYS_SRC_ANGLE_END, 6.283185,
                PSYS_SRC_OMEGA, <0.00000, 0.10000, 0.00000>,
                PSYS_SRC_MAX_AGE, 0.00000,
                PSYS_SRC_TEXTURE, "99214e66-0e50-f8b8-142b-9a0b82a480a3",  // change this to any texture name that is also in the prim, or use the UUID. If you use the UUID and want to give it to others, make sure the texture in your inventory has copy on it.
                PSYS_PART_START_ALPHA, 0.300000,                // increase for less transparent snow
                PSYS_PART_END_ALPHA, 0.00000
        ];
    }

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

    smoke() {
        psname = "fire";
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

    gushBlood() {
        psname = "gushblood";
        // MASK FLAGS: set  to "TRUE" to enable
        integer glow = TRUE;                        // Makes the particles glow
        integer bounce = FALSE;                     // Make particles bounce on Z plane of objects
        integer interpColor = TRUE;                 // Color - from start value to end value
        integer interpSize = TRUE;                  // Size - from start value to end value
        integer wind = FALSE;                       // Particles effected by wind
        integer followSource = FALSE;               // Particles follow the source
        integer followVel = TRUE;                   // Particles turn to velocity direction
        // Choose a pattern from the following:
                                                    // PSYS_SRC_PATTERN_EXPLODE
                                                    // PSYS_SRC_PATTERN_DROP
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE
                                                    // PSYS_SRC_PATTERN_ANGLE
        integer pattern = PSYS_SRC_PATTERN_ANGLE;   // PSYS_SRC_PATTERN_EXPLODE;
                                                    // Select a target for particles to go towards
                                                    // "" for no target, "owner will follow object owner
                                                    //    and "self" will target this object
                                                    //    or put the key of an object for particles to go to
        key target = "";
                                                    // PARTICLE PARAMETERS
        float age = 2.4;                            // Life of each particle
        float maxSpeed = 20.0;                      // Max speed each particle is spit out at
        float minSpeed = 10;                        // Min speed each particle is spit out at
        string texture = "0498c309-5306-43cd-82a2-ae31d096cdef";    // Texture used for particles, default used if blank
        float startAlpha = 0.5;                     // Start alpha (transparency) value
        float endAlpha = 0.5;                       // End alpha (transparency) value
        vector startColor = <1,0,0>;                // Start color of particles <R,G,B>
        vector endColor = <0.6,0,0>;                // End color of particles <R,G,B> (if interpColor == TRUE)
        vector startSize = <1.0,2.0,1.0>;           // Start size of particles
        vector endSize = <1,2,1.0>;                 // End size of particles (if interpSize == TRUE)
        vector push = <0.0,0.0,-5.0>;               // Force pushed on particles
                                                    // SYSTEM PARAMETERS
        float rate = 0.1;                           // How fast (rate) to emit particles
        float radius = 0.25;                        // Radius to emit particles for BURST pattern
        integer count = 40;                         // How many particles to emit per BURST
        float outerAngle = 4*PI;                    // Outer angle for all ANGLE patterns   PI/4
        float innerAngle = 0.5;                     // Inner angle for all ANGLE patterns
        vector omega = <0,0,0>;                     // Rotation of ANGLE patterns around the source
        float life = 0;                             // Life in seconds for the system to make particles
                                                    // SCRIPT VARIABLES
        integer flags;
        flags = 0;
        if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
        if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
        if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
        if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
        if (wind) flags = flags | PSYS_PART_WIND_MASK;
        if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
        if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
        if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
        psys = [  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize,
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_ANGLE_BEGIN,innerAngle,
                        PSYS_SRC_ANGLE_END,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
        ];
    }

    sparkler() {
        psname = "sparkler";
        psys = [
                 PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,

                 PSYS_SRC_MAX_AGE, 0.,
                 PSYS_PART_MAX_AGE, .6,

                 PSYS_SRC_BURST_RATE, .05,
                 PSYS_SRC_BURST_PART_COUNT, 50,

                 PSYS_SRC_BURST_RADIUS, 1.,
                 PSYS_SRC_BURST_SPEED_MIN, .1,
                 PSYS_SRC_BURST_SPEED_MAX, 2.,
                 PSYS_SRC_ACCEL, <0.0,0.0,-0.8>,

                 PSYS_PART_START_COLOR, <1,1,1>,
                 PSYS_PART_END_COLOR, <1,0,0>,

                 PSYS_PART_START_ALPHA, 0.9,
                 PSYS_PART_END_ALPHA, 0.0,

                 PSYS_PART_START_SCALE, <.15,.15,0>,
                 PSYS_PART_END_SCALE, <.01,.1,0>,

                 PSYS_PART_FLAGS
                 , 0
                 | PSYS_PART_EMISSIVE_MASK
                 | PSYS_PART_INTERP_COLOR_MASK
                 | PSYS_PART_INTERP_SCALE_MASK
                 | PSYS_PART_FOLLOW_SRC_MASK
                 | PSYS_PART_FOLLOW_VELOCITY_MASK
        ];
    }

    firework() {
        psname = "firework";
        psys = [
                 PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,

                 PSYS_SRC_MAX_AGE, 0.,
                 PSYS_PART_MAX_AGE, 9.,

                 PSYS_SRC_BURST_RATE, 20.,
                 PSYS_SRC_BURST_PART_COUNT, 500,

                 PSYS_SRC_BURST_RADIUS, .1,
                 PSYS_SRC_BURST_SPEED_MIN, 3.,
                 PSYS_SRC_BURST_SPEED_MAX, 3.,
                 PSYS_SRC_ACCEL, <0.0,0.0,-0.8>,

                 PSYS_PART_START_COLOR, <246,38,9>/255.,
                 PSYS_PART_END_COLOR, <246,38,9>/255,

                 PSYS_PART_START_ALPHA, 0.9,
                 PSYS_PART_END_ALPHA, 0.0,

                 PSYS_PART_START_SCALE, <.3,.3,0>,
                 PSYS_PART_END_SCALE, <.1,.1,0>,

                 PSYS_PART_FLAGS
                 , 0
                 | PSYS_PART_EMISSIVE_MASK
                 | PSYS_PART_INTERP_COLOR_MASK
                 | PSYS_PART_INTERP_SCALE_MASK
                 | PSYS_PART_FOLLOW_VELOCITY_MASK
                 //| PSYS_PART_WIND_MASK
        ];

    }

    fireplace() {
        psname = "fireplace";
        psys = [
                PSYS_PART_FLAGS, 291,
                PSYS_SRC_PATTERN, 2,
                PSYS_PART_START_ALPHA, 1.00,
                PSYS_PART_END_ALPHA, 0.00,
                PSYS_PART_START_COLOR, <1.00,1.00,1.00>,
                PSYS_PART_END_COLOR, <1.00,1.00,1.00>,
                PSYS_PART_START_SCALE, <0.25,0.25,0.00>,
                PSYS_PART_END_SCALE, <1.00,1.00,0.00>,
                PSYS_PART_MAX_AGE, 0.80,
                PSYS_SRC_MAX_AGE, 0.00,
                PSYS_SRC_ACCEL, <0.00,0.00,2.00>,
                PSYS_SRC_ANGLE_BEGIN, 0.00,
                PSYS_SRC_ANGLE_END, 1.05,
                PSYS_SRC_BURST_PART_COUNT, 5,
                PSYS_SRC_BURST_RADIUS, 0.10,
                PSYS_SRC_BURST_RATE, 0.00,
                PSYS_SRC_BURST_SPEED_MIN, 0.00,
                PSYS_SRC_BURST_SPEED_MAX, 0.40,
                PSYS_SRC_OMEGA, <0.00,0.00,0.00>,
                PSYS_SRC_TEXTURE, "a96ecd50-96e1-28b4-51ec-96b3112210c0"
        ];
    }

    fwspiral() {
        psname = "fwspiral";
        psys = [
                PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                                 PSYS_PART_EMISSIVE_MASK |
                                 PSYS_PART_FOLLOW_VELOCITY_MASK ,
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
                PSYS_PART_MAX_AGE, 5.0,
                PSYS_SRC_BURST_SPEED_MIN, 1.0,
                PSYS_SRC_BURST_SPEED_MAX, 2.0,
                PSYS_SRC_ACCEL, <0,0,0.2>,
                PSYS_SRC_BURST_RATE, 0.05,
                PSYS_SRC_BURST_PART_COUNT, 10,
                PSYS_SRC_ANGLE_BEGIN,  0*DEG_TO_RAD,
                PSYS_SRC_ANGLE_END, 90*DEG_TO_RAD,
                PSYS_SRC_OMEGA, <0,0,20>,
                PSYS_PART_START_SCALE, <0.25, 0.25, 0.0>,
                PSYS_PART_START_ALPHA, 1.0,
                PSYS_PART_END_ALPHA,   0.5,
                PSYS_SRC_TEXTURE, "181c6b1d-c2d0-70ba-bbf2-52ccc31687c6"
        ];
    }

    yellowspire() {
        psname = "yellowspire";
        psys = [
                PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                                 PSYS_PART_EMISSIVE_MASK,
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
                PSYS_PART_MAX_AGE, 10.0,
                PSYS_SRC_BURST_SPEED_MIN, 1.0,
                PSYS_SRC_BURST_SPEED_MAX, 1.0,
                PSYS_SRC_ACCEL, <0,0,-0.1>,
                PSYS_SRC_BURST_RATE, 0.05,
                PSYS_SRC_BURST_PART_COUNT, 10,
                PSYS_SRC_ANGLE_BEGIN,  90*DEG_TO_RAD,
                PSYS_SRC_ANGLE_END, 90*DEG_TO_RAD,
                PSYS_SRC_OMEGA, <0,0,20>,
                PSYS_PART_START_SCALE, <0.25, 0.25, 0.0>,
                PSYS_PART_START_ALPHA, 1.0,
                PSYS_PART_END_ALPHA,   0.5,
                PSYS_PART_START_COLOR, <1.0, 1.0, 0.0>,
                PSYS_PART_END_COLOR,   <1.0, 0.0, 0.0>
        ];
    }

    float angleScale = DEG_TO_RAD;  // Scale factor for angles

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

    tawk(string s) {
        llOwnerSay(s);
    }

    default {
        state_entry() {
            llSetLinkPrimitiveParamsFast(LINK_THIS,
                [ PRIM_TEXT, "Fourmilab Fireworks\nOptical Effect Compiler", <0, 1, 0>, 1 ]);
            llParticleSystem([ ]);          // Clear any orphaned particle system
splodey();
//snow();
//smoke();
//gushBlood();
//rain();
//sparkler();
//firework();
//fireplace();
//fwspiral();
//yellowspire();
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
                    Vi = llList2Integer(psys, i + 1);
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

        touch_start(integer n) {
            toggle = !toggle;
            if (toggle) {
                llParticleSystem(psys);
            } else {
                llParticleSystem([ ]);
            }
        }
    }
