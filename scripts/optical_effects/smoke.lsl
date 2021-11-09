
    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
                PSYS_PART_MAX_AGE, 2.5,
                PSYS_PART_FLAGS, 259,
                PSYS_PART_START_COLOR, <0.18, 0.16, 0.13>,
                PSYS_PART_END_COLOR, <0.59, 0.65, 0.62>,
                PSYS_PART_START_SCALE, <0.15, 0.15, 0>,
                PSYS_PART_END_SCALE, <0.77, 1.21, 0>,
                PSYS_SRC_MAX_AGE, 2,
                PSYS_SRC_PATTERN, 2,
                PSYS_SRC_BURST_RATE, 0,
                PSYS_SRC_BURST_PART_COUNT, 4,
                PSYS_SRC_BURST_RADIUS, 0,
                PSYS_SRC_BURST_SPEED_MIN, 0.07,
                PSYS_SRC_BURST_SPEED_MAX, 0.35,
                PSYS_SRC_ANGLE_BEGIN, 1.65,
                PSYS_SRC_ANGLE_END, 0,
                PSYS_SRC_TEXTURE, "006d9758-81da-38a9-9be3-b6c941cae931",
                PSYS_PART_START_ALPHA, 0.4,
                PSYS_PART_END_ALPHA, 0,
                PSYS_SRC_ACCEL, <0, 0, 1.14>
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
