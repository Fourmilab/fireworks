
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
            PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                             PSYS_PART_EMISSIVE_MASK,
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
            PSYS_PART_MAX_AGE, 2,
            PSYS_SRC_MAX_AGE, 1.5,
            PSYS_SRC_BURST_SPEED_MIN, 2,
            PSYS_SRC_BURST_SPEED_MAX, 3,
            PSYS_SRC_ACCEL, <0, 0, -3>,
            PSYS_SRC_BURST_RATE, 0.05,
            PSYS_SRC_BURST_PART_COUNT, 3000,
            PSYS_SRC_ANGLE_BEGIN, 60 * DEG_TO_RAD,
            PSYS_SRC_ANGLE_END, 0 * DEG_TO_RAD,
            PSYS_SRC_OMEGA, <0, 0, 30>,
            PSYS_PART_START_SCALE, <0.25, 0.25, 0>,
            PSYS_PART_START_ALPHA, 1,
            PSYS_PART_END_ALPHA, 0.25,
            PSYS_PART_START_COLOR, <-1, 1, 1>,
            PSYS_PART_END_COLOR, <-2, 1, 0.2>
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
