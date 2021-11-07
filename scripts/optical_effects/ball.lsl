
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [

            //  System Behavior
            PSYS_PART_FLAGS,            PSYS_PART_EMISSIVE_MASK |
                                        PSYS_PART_FOLLOW_VELOCITY_MASK |
                                        PSYS_PART_INTERP_SCALE_MASK |
                                        PSYS_PART_INTERP_COLOR_MASK,

            //  System Presentation
            PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_BURST_RADIUS,      0.5,

            //  Particle Appearance
            PSYS_PART_START_COLOR,      <-1, 1, 1>,
            PSYS_PART_END_COLOR,        <-2, 1, 0>,
            PSYS_PART_START_ALPHA,      1.0,
            PSYS_PART_END_ALPHA,        0.0,
            PSYS_PART_START_SCALE,      <1, 1, 0>,
            PSYS_PART_END_SCALE,        <0.5, 0.5, 0>,
            PSYS_PART_START_GLOW,       0.2,
            PSYS_PART_END_GLOW,         0.0,

            //  Particle Flow
            PSYS_SRC_MAX_AGE,           0.2,
            PSYS_PART_MAX_AGE,          1,
            PSYS_SRC_BURST_RATE,        20,
            PSYS_SRC_BURST_PART_COUNT,  1000,

            //  Particle Motion
            PSYS_SRC_ACCEL,             <0, 0, 0>,
            PSYS_SRC_BURST_SPEED_MIN,   0.01,
            PSYS_SRC_BURST_SPEED_MAX,   0.01
        ];
    }

    //  You don't need to change anything below this line

    //  Compiler messages
    integer LM_OC_REQUEST = 300;                // Request effect definition
    integer LM_OC_REPLY = 301;                  // Return effect definition

    default {
        state_entry() {
            effect_name = llGetScriptName();
            integer n = llSubStringIndex(effect_name, ": ");
            effect_name = llStringTrim(llDeleteSubString(effect_name, 0, n), STRING_TRIM);
            effect_def();
        }

        link_message(integer sender, integer num, string str, key id) {
            if ((num == LM_OC_REQUEST) && (str == effect_name)) {
                llMessageLinked(sender, LM_OC_REPLY,
                    llList2Json(JSON_ARRAY, [ effect_name ] + effect_list), id);
            }
        }

    }
