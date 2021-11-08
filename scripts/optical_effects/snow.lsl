
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_SRC_BURST_PART_COUNT, 20000,
            PSYS_SRC_BURST_RATE, 0,
            PSYS_SRC_MAX_AGE, 3,
            PSYS_PART_MAX_AGE, 6,
            PSYS_SRC_BURST_RADIUS, 0.1,
//            PSYS_SRC_ANGLE_BEGIN, 0,
//            PSYS_SRC_ANGLE_END, PI_BY_TWO,
PSYS_SRC_ANGLE_BEGIN, (PI * 3) / 8,
PSYS_SRC_ANGLE_END, PI_BY_TWO,
            PSYS_SRC_ACCEL, <0, 0, -0.5>,
            PSYS_SRC_BURST_SPEED_MIN, 0.25,
            PSYS_SRC_BURST_SPEED_MAX, 1,
            PSYS_PART_START_SCALE, <0.1, 0.1, 0>,
            PSYS_PART_END_SCALE, <0.1, 0.1, 0>,
            PSYS_PART_START_COLOR, <1, 1, 1>,
            PSYS_PART_END_COLOR, <1, 1, 1>,
            PSYS_PART_START_ALPHA, 0.5,
            PSYS_PART_END_ALPHA, 0.8,
            PSYS_SRC_TEXTURE, "60ec4bc9-1a36-d9c5-b469-0fe34a8983d4",   // Snowflake
            PSYS_PART_FLAGS,
                 PSYS_PART_EMISSIVE_MASK |
                 PSYS_PART_FOLLOW_VELOCITY_MASK |
                 PSYS_PART_INTERP_COLOR_MASK |
                 PSYS_PART_INTERP_SCALE_MASK
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
