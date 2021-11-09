
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
                PSYS_PART_MAX_AGE, 1.2,
                PSYS_PART_FLAGS, 259,
                PSYS_PART_START_COLOR, <0.73, 0.84, 0.79>,
                PSYS_PART_END_COLOR, <0.61, 0.76, 0.82>,
                PSYS_PART_START_SCALE, <0.1, 0, 0>,
                PSYS_PART_END_SCALE, <0.1, 3.69, 0>,
                PSYS_SRC_PATTERN, 8,
                PSYS_SRC_BURST_RATE, 0.1,
                PSYS_SRC_BURST_PART_COUNT, 25,
                PSYS_SRC_BURST_RADIUS, 5.57,
                PSYS_SRC_BURST_SPEED_MIN, 0.11,
                PSYS_SRC_BURST_SPEED_MAX, 0.64,
                PSYS_SRC_ANGLE_BEGIN, 0,
                PSYS_SRC_ANGLE_END, PI / 4,
                PSYS_SRC_MAX_AGE, 5,
                PSYS_SRC_TEXTURE, "06675bc5-e9b9-0557-7179-fbf7779faed8",
                PSYS_PART_START_ALPHA, 0.2,
                PSYS_PART_END_ALPHA, 0.75,
                PSYS_SRC_ACCEL, <-0.37, 0.45, -12>
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
