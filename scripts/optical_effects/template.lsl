    /*
                  Optical Effect Script Template

        To create a custom optical effect (particle system),
        make a copy of this file and rename it, replacing
        "template" with the name of your effect (you must keep
        "Optical: " as the first part of the script name.
        Edit the effect_def() function below to set the
        parameters of your particle system in the definition
        of effect_def.  You don't need to change anything
        below that function.

        Save the script and copy to the inventory of the
        Optical Effect Compiler object.  Its List command
        should now show your effect as available.  Now use
        the Generate command, specifying your effect name,
        to load the effect and generate the Optical commands
        to define it for the Firework Launcher.  Test your
        effect by touching the Compiler to turn it on and off.

        When you're satisfied with the effect, copy the
        Optical commands from the chat window to the
        clipboard and paste into the "Script: Configuration"
        notecard of the Firework Launcher.  Now you can test
        it with the Launcher with a Launch command specifying
        your effect name.
    */

    string effect_name = "";
    list effect_list;

    effect_def() {
        effect_list = [
            /*  Here are all llParticleSystem() rule specifications in
                the order they are defined in:
                    http://wiki.secondlife.com/wiki/LlParticleSystem

                Set values to achieve the effect you desire.  Rules
                set to their defaults may be deleted.
            */

            //  System Behavior
            PSYS_PART_FLAGS,            0,

            //  System Presentation
            PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_BURST_RADIUS,      0.0,
            PSYS_SRC_ANGLE_BEGIN,       0.0 * DEG_TO_RAD,
            PSYS_SRC_ANGLE_END,         0.0 * DEG_TO_RAD,
//          PSYS_SRC_TARGET_KEY,        NULL_KEY,       // Uncomment if you use

            //  Particle Appearance
            PSYS_PART_START_COLOR,      <1, 1, 1>,
            PSYS_PART_END_COLOR,        <1, 1, 1>,
            PSYS_PART_START_ALPHA,      1.0,
            PSYS_PART_END_ALPHA,        0.0,
            PSYS_PART_START_SCALE,      <0.1, 0.1, 0>,
            PSYS_PART_END_SCALE,        <0.01, 0.01, 0>,
//          PSYS_SRC_TEXTURE,           NULL_KEY,       // Uncomment if you use
            PSYS_PART_START_GLOW,       0.0,
            PSYS_PART_END_GLOW,         0.0,

            //  Particle Blending
            PSYS_PART_BLEND_FUNC_SOURCE,    0,
            PSYS_PART_BLEND_FUNC_DEST,      0,

            //  Particle Flow
            PSYS_SRC_MAX_AGE,           1.0,
            PSYS_PART_MAX_AGE,          3.0,
            PSYS_SRC_BURST_RATE,        0,
            PSYS_SRC_BURST_PART_COUNT,  1000,

            //  Particle Motion
            PSYS_SRC_ACCEL,             <0, 0, 0>,
            PSYS_SRC_OMEGA,             <0, 0, 0>,
            PSYS_SRC_BURST_SPEED_MIN,   1.0,
            PSYS_SRC_BURST_SPEED_MAX,   1.0
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
