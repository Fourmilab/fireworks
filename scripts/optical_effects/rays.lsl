
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_MAX_AGE, 1.5,
            PSYS_SRC_BURST_RATE, 0,
            PSYS_SRC_BURST_PART_COUNT, 300,
            PSYS_SRC_BURST_RADIUS, 0.2,
            PSYS_SRC_BURST_SPEED_MIN, 1,
            PSYS_SRC_BURST_SPEED_MAX, 5,
            PSYS_SRC_ACCEL, ZERO_VECTOR,
            PSYS_SRC_ANGLE_BEGIN,  0 * DEG_TO_RAD,
            PSYS_SRC_ANGLE_END, 360 * DEG_TO_RAD,
            PSYS_PART_MAX_AGE, 1,
            PSYS_PART_START_COLOR, <-1, 1, 1>,
            PSYS_PART_END_COLOR, <-2, 1, 0.2>,
            PSYS_PART_START_ALPHA, 1,
            PSYS_PART_END_ALPHA, 1,
            PSYS_PART_START_SCALE, <0.08, 0.8, 0>,
            PSYS_PART_END_SCALE, <0.05, 0.1, 0>,
            PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                             PSYS_PART_INTERP_SCALE_MASK |
                             PSYS_PART_FOLLOW_VELOCITY_MASK |
                             PSYS_PART_WIND_MASK |
                             PSYS_PART_EMISSIVE_MASK
        ];
    }

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
