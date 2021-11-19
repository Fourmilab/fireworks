
                        Fourmilab Fireworks User Guide

Fourmilab Fireworks is a fireworks launcher which can be worn by an
avatar (usually as a hat) or rezzed in-world on land where the owner is
permitted to create objects.  When worn as a hat, object creation
permission is not required and it has no land impact.  The fireworks
launcher is controlled by commands in local chat, and complete shows
may be programmed via scripts stored in notecards.  Shows may be
scheduled to run automatically at specified times and repeat at regular
intervals.  The optical effects (particle systems) displayed for
firework bursts are defined in a configuration script and may be
modified or added to by the owner.  Sound effects for firework launches
and detonations are defined in the launcher's inventory and new effects
can be added.  Streaming audio from Web sites may be played to
accompany the show.  Multiple firework shells can be placed in the
inventory, allowing as many simultaneous bursts as desired (each shell
has a land impact of 1 prim).  The randomly chosen azimuth, elevation,
and range of bursts can be set via chat or a notecard script.

WEARING THE FIREWORKS LAUNCHER

To wear the fireworks launcher as a hat, just right click it in your
inventory and select Add to your current outfit.  If it shows up
attached to something other than your head, detach it and use the
Attach selection specifying Skull as the attachment point.  Depending
upon the size and shape of your avatar, you may need to select the
hat and Edit its position to move it up or down on your head.  Wearing
the launcher can be done anywhere on the Second Life grid and has no
land impact—it does not require permission to create objects.  The
launcher only requires that the parcel allows scripts to run, and it
is rare to find one that doesn't.

REZZING THE LAUNCHER IN-WORLD

In addition to wearing the Fireworks launcher on your avatar, you can
use it as an object in-world. The launcher has a land impact of 8 (plus
one more for every additional firework shell you have added to the
default five).  Just drag it from your inventory to the desired
location and you're good to go.  You can create as many launchers as
you wish, limited only by your parcel's prim capacity.  If you create
multiple launchers in proximity to one another, you may want to assign
them different chat channels (see the Channel command below) so you can
control each independently.

CHAT COMMANDS

Fourmilab Fireworks accepts commands submitted on local chat channel
1749 (the date of composition of George Frideric Handel's Music for the
Royal Fireworks, HWV 351) and responds in local chat.  Commands are as
follows.  (Most chat commands and parameters, except those specifying
names from the inventory, may be abbreviated to as few as two
characters and are insensitive to upper and lower case.)

    Access public/group/owner
        Specifies who can send commands to the launcher.  You can
        restrict it to the owner only, members of the owner's group, or
        open to the general public.  Default access is by owner.

    Audio sound[=UUID] ...
        Declare one or more sound clips to be used for launch and burst
        sound effects or the Play command.  An audio clip can either be
        in the inventory of the fireworks launcher or specified as the
        UUID/key of a publicly accessible sound clip elsewhere on the
        Second Life grid.  Sound clips specified by UUID are given a
        name with the UUID followed by an equal sign.  For example, to
        use the built-in thunder sound, you could declare: Audio
        thunder=e95c96a5-293c-bb7a-57ad-ce2e785ad85f and then specify
        “thunder” on a Launch command or in the declaration of a group
        of explosion sounds.  All sound names, whether from the
        inventory or by UUID, must use only lower case letters and
        inventory sound clip names must be identical.

    Boot
        Reset the script.  All settings will be restored to their
        defaults.  If you have changed the chat command channel, this
        will restore it to the default of 1749.

    Channel n
        Set the channel on which the launcher listens for commands in
        local chat to channel n.  If you subsequently reset the script
        with the “Boot” command or manually, the chat channel will
        revert to the default of 1749.

    Clear
        Send vertical white space to local chat to separate output when
        debugging.

    Delete name
        Delete the item (Audio, Group, Optical, or URL) with the given
        name from the dictionary.  This can be used to reclaim space
        when you're loading different sets of effects for shows, and is
        particularly handy when you want to update an Optical
        definition. The old definition must be deleted before the new
        is declared to avoid its items being appended to the previous
        definition.

    Echo text
        Echo the text in local chat.  This allows scripts to send
        messages to those running them to let them know what they're
        doing.

    Embed name
        Start streaming audio from the named URL or, if the name is a
        Group, from a randomly chosen member of it.  You can only have
        one audio source streaming at a time, and there is no way to
        detect whether the source is still playing.  An Embed command
        with no name will stop the currenly playing source.

    Group gname member1 ...
        Define a group named gname consisting of the named members.
        Members may be previously declared Audio, Optical effects,
        URLS, or the name of Groups containing the same kind of effects
        (and, possibly, other Groups).  When a group name is specified
        on an Embed, Launch, Play, or Salvo command, one of the items
        it contains will be chosen at random.

    Help
        Send this notecard to the requester.

    Launch burst_effect burst_sound launch_effect launch_sound ascent_time hang_time burst_duration
        Launch a firework shell using an azimuth, elevation, and radius
        randomly chosen between the limits declared by the
        corresponding Set commands. The arguments specify:
            burst_effect        Name of the Optical effect for the burst of the shell
                                      or Group from which the effect is randomly chosen
                                      (default is the “burst” group)
            burst_sound       Name of the Audio clip to be played at the burst
                                      or Group from which a clip is randomly chosen
                                      (default is the “explode” group)
            launch_effect      Name of the Optical effect for launch of the shell
                                      or Group from which the effect is randomly chosen
                                      (default is the “ascent” group)
            launch_sound      Name of the Audio clip to be played at launch of
                                      the shell or Group from which a clip is randomly chosen
                                      (default is the “launch” group)
            ascent_time        Ascent optical effect duration in seconds (default 0.5)
            hang_time           Time in seconds between launch and detonation
                                      (default 0.25)
            burst_duration     Burst optical effect duration in seconds (default 1)
        Any or all of these arguments may be omitted or the defaults
        chosen by a specification of “-” (without the quotes).

    Legend [ <r, g, b> ] Text
        Sets the floating text legend above the launcher to the
        specified Text or clears the legend if no Text is given.  You
        can set the colour of the Text by prefixing it with an RGB
        colour specification, with a default of green <0,1,0>.

    Menu item1 ...
        Pop up a menu dialogue with the name items, which may use both
        upper and lower case letters.  When an item is selected, the
        script in a notecard in the launcher's inventory named “Script:
        itemname” is run.  The itemname of the script must be spelled
        exactly the same as in the Menu command.

    Optical oname key1 value1 key2 value2 ...
        Declare a Optical effect named oname with the key and value
        pairs that follow on the command line.  Please see the section
        DEFINING OPTICAL EFFECTS below for details.

    Play audio
        Immediately play a sound clip previously declared with an
        Audio command or a clip randomly chosen from a Group of sound
        clips.  Sound can be played with this command simultaneously
        with sounds from fireworks: they will not interfere with one
        another.

    Salvo n burst_effect burst_sound launch_effect launch_sound ascent_time hang_time burst_duration
        Launch a salvo of n shells with the default parameters for the
        Launch command.  If a Salvo command is entered while a previous
        salvo is in progress, if n is 0 the Salvo is cancelled.
        Otherwise, the number is added to the number remaining from the
        in-progress salvo.  If n is negative, it is taken as the
        duration of the salvo in seconds: shells will be continued to
        be launched at the specified “Set interval” range until the
        specified time has elapsed.  Timed salvos are particularly
        useful when you wish to synchronise fireworks with sound clips.
        The optional arguments following the number of shells to launch
        are the same as on the Launch command and will be used for all
        launches in the salvo.

    Script
        These commands control the running of scripts stored in
        notecards in the inventory of the launcher.  Commands in
        scripts are identical to those entered in local chat (but, of
        course, are not preceded by a slash and channel number).  Blank
        lines and those beginning with a “#” character are treated as
        comments and ignored.

        Script list
            Print a list of scripts in the inventory.  Only scripts
            whose names begin with “Script: ” are listed and may be
            run.

        Script run [ Script Name ]
            Run the specified Script Name.  The name must be specified
            exactly as in the inventory, without the leading “Script: ”.
            Scripts may be nested, so the “Script run” command may
            appear within a script.  Entering “Script run” with no
            script name terminates any running script(s).

            The following commands may be used only within scripts.

            Script loop [ n ]
                Begin a loop within the script which will be executed n
                times, or forever if n is omitted.  Loops may be
                nested, and scripts may run other scripts within loops.
                An infinite loop can be terminated by “Script run” with
                no script name or by the “Boot” command.

            Script end
                Marks the end of a “Script loop”.  If the number of
                iterations has been reached, proceeds to the next
                command.  Otherwise, repeats, starting at the top of
                the loop.

            Script pause [ n/touch/region ]
                Pauses execution of the script for n seconds.  If the
                argument is omitted, the script is paused for one
                second.  If “touch” is specified, the script will be
                paused until the object is touched or a “Script resume”
                command is entered from chat.  If “region” is
                specified, the script will be paused until the the user
                wearing the launcher enters a new region.  You can use
                this to herald your arrival in a new region with a
                burst of fireworks, which may get you banned from the
                region.

            Script resume
                Resumes a paused script, whether due to an unexpired
                timed pause or a pause until touched or resumed.

            Script wait n[unit] [ offset[unit] ]
                Pause the script until the start of the next n units of
                time, where unit may be “s”=seconds, “m”=minutes,
                “h“=hours, or ”d”=days, plus the offset time, similarly
                specified.  This can be used in loops to periodically
                run shows at specified intervals.  For example, the
                following script runs a show once an hour at 15 minutes
                after the hour.
                    Script loop
                        Script wait 1h 15m
                        Set top off
                        Script pause 0.5
                        Salvo 12
                        Wait
                        Script pause 0.5
                        Set top on
                    Script end

    Set
        Set a variety of parameters.

        Set angles degrees/radians
            Sets whether angle arguments in the Optical, Set azimuth,
            and Set elevation commands are specified in degrees or
            radians (default degrees).

        Set azimuth min [ max ]
            Set the limits on azimuth (compass point) between which
            firework shells are launched between min and max, in
            degrees or radians according to the Set angles setting.  If
            no max is specified, the min setting will be used,
            resulting in a fixed azimuth.  Default is 0 to 360 degrees
            (all azimuths).  North is 0 degrees, with azimuth
            increasing in the clockwise direction.

        Set echo on/off
            Controls whether commands entered from local chat or a
            script are echoed to local chat as they are executed.

        Set elevation min [ max ]
            Set the limits on elevation  between which firework shells
            are launched between min and max, in degrees or radians
            according to the Set angles setting.  If no max is
            specified, the min setting will be used, setting a fixed
            elevation.  Default is 45 to 90 degrees (all elevations
            above the horizon).

        Set interval min [ max ]
            Sets the limits on the interval, in seconds, between
            launches by the Salvo command.  If no max is specified, the
            min value will be used, setting a fixed time between
            launches.  If the interval is set to zero, salvos will be
            launched as rapidly as availability of shells permits.
            Default min is 0.75 seconds and max is 2.5.

        Set radius min [ max ]
            Sets the minimum and maximum radius (distance of flight)
            for shells, in metres.  If max is omitted, the min value
            will be used and all shells will be launched with the same
            radius.  The default minimum is 2 metres and maximum 5
            metres.

        Set top on/off
            Opens and closes the top of the launcher.  Use “off” to tip
            the top upward to open and “on” to close.  The top starts
            closed.  If you wish to close the top after a sequence of
            launches commanded by a script, don't forget to use the
            Wait command before closing the top so it doesn't close
            until all of the launches have completed.

        Set trace on/off
            Enable or disable output, sent to the owner on local chat,
            describing operations as they occur.  This is generally
            only of interest to developers.

    Status
        Show status of the script, including settings and memory usage.

    URL uname https://... [time]
        Declares the URL for a streaming audio source called uname.
        You can then use uname in an Embed command or place it within a
        Group of other audio sources. The running time of the audio to
        be played is declared after the end of the URL, separated by a
        space, within square brackets.  For example, a song which plays
        for 2 minutes and 25.7 seconds would be specified as
        “[2:25.7]”.  This declaration is used to “squelch” the audio
        source at completion of play to avoid its being replayed if an
        avatar leaves the vicinity of the launcher and subsequently
        returns.  If you don't know the length of the audio (for
        example, if it's a live stream or Internet radio station), omit
        the time specification entirely.  It is then up to user or
        notecard script to explicitly stop the audio at the appropriate
        time with an Embed command specifying no URL.

    Wait
        Pause script execution until all launched fireworks have
        detonated.

SPECIAL GROUP NAMES

When you define a Group containing multiple optical or sound effects
and specify the group name on the Launch command instead of a specific
effect, one of the members of the group will be chosen at random.  If
no effect is specified on the Launch command, it will select effects
from the following special groups.
    launch      Audio effect for shell launch
    ascent      Optical effect for shell ascent
    explode     Audio effect for shell burst
    burst       Optical effect for shell burst
If you define additional effects, simply add them to the appropriate
group and they will automatically be included among the effects
displayed by default.

DEFINING OPTICAL EFFECTS

The optical effects displayed when a firework shell is launched and
bursts are produced by what Second Life calls a “particle system”,
which is created by the function llParticleSystem(), documented in
the Wiki page:
    http://wiki.secondlife.com/wiki/LlParticleSystem
Fourmilab Fireworks can create any particle system that Second Life can
display, allowing a multitude of creative effects.  Optical effects are
declared with the Optical command, which specifies the name of the
effect and a sequence of keywords and values defining the particle
system.  The keywords are abbreviations of the “rule names” defined for
llParticleSystem(), as follows, specifying the abbreviation, the
corresponding rule name, and the type of value that follows it in the
Optical declaration.
     pf         PSYS_PART_FLAGS             integer
     sp         PSYS_SRC_PATTERN            integer
     sbrad      PSYS_SRC_BURST_RADIUS       float
     sab        PSYS_SRC_ANGLE_BEGIN        angle
     sae        PSYS_SRC_ANGLE_END          angle
     stk        PSYS_SRC_TARGET_KEY         key (UUID)
     psc        PSYS_PART_START_COLOR       vector
     pec        PSYS_PART_END_COLOR         vector
     psa        PSYS_PART_START_ALPHA       float
     pea        PSYS_PART_END_ALPHA         float
     pss        PSYS_PART_START_SCALE       vector
     pes        PSYS_PART_END_SCALE         vector
     st         PSYS_SRC_TEXTURE            string
     psg        PSYS_PART_START_GLOW        float
     peg        PSYS_PART_END_GLOW          float
     pbfs       PSYS_PART_BLEND_FUNC_SOURCE integer
     pbfd       PSYS_PART_BLEND_FUNC_DEST   integer
     sma        PSYS_SRC_MAX_AGE            float
     pma        PSYS_PART_MAX_AGE           float
     sbrat      PSYS_SRC_BURST_RATE         float
     sbpc       PSYS_SRC_BURST_PART_COUNT   integer
     sa         PSYS_SRC_ACCEL              vector
     so         PSYS_SRC_OMEGA              vector
     sbsmin     PSYS_SRC_BURST_SPEED_MIN    float
     sbsmax     PSYS_SRC_BURST_SPEED_MAX    float
Some of these items have special values.  Those marked with a type of
“angle” are floating point numbers representing degrees or radians
depending upon the “Set angles” setting.  In the “psc” and “pec”
specifications, the value can either be a <r,g,b> triple representing a
colour with components between 0 and 1 or a triple with one or more
negative numbers that denotes a colour in the HSV (hue, saturation, and
value [brightness]) system where the negative component is chosen at
random.  For example, a value of <-1,1,1> specifies colour with a
randomly chosen hue, full saturation, and maximum brightness.  If the
first component is -2, it denotes the most recently randomly chosen
hue: a specification of <-2,1,0.2> chooses a colour with the same hue
as the last, full saturation, but a brightness one fifth maximum.  The
“stk” specification may name either the explicit key of an object,
“self” to denote the fireworks shell itself, or “root” to refer to the
launcher.  The “st” specification may either name a texture placed in
the inventory of the object or the key (UUID) of a texture elsewhere on
the Second Life grid.

Optical declarations may occupy as many lines as are needed.
Declarations with the same name are concatenated to form a single
optical effect.  For example, here is the declaration for the simple
spherical burst effect from the standard configuration notecard.
    Optical splodey sp 2 sbrad 0.2  psc <-1,1,1>  pec <-2, 1, 0.2>
    Optical splodey pss <0.3,0.3,0>  pes <0..1, 0.1, 0> psg 0.2  peg 0
    Optical splodey sma 0.2  pma 0.75  sbrat 20  sbpc 1000  sa <0, 0, 0>
    Optical splodey sbsmin 2  sbsmax 2  pf 291
Here we use the negative colour trick so bursts will have randomly
chosen hues.

THE OPTICAL EFFECT COMPILER

Developing, debugging, and optimising optical effects can be a fussy,
error-prone, and tedious business.  To expedite the process, a model
called the “Optical Effect Compiler” is included with Fourmilab
Fireworks.  This is a pyramid-shaped object that contains a script
defining a particle effect in Linden Scripting Language.  When the
script is reset, it displays the Optical statements which define the
effect for Fourmilab Fireworks.  Touching the compiler pyramid toggles
the particle effect on and off, allowing you to preview it and, by
editing the script, adjust it to your satisfaction before copying the
Optical statements into the Fireworks configuration notecard.  The
Optical Effect Compiler makes it easy to convert particle effects
you've found in script libraries into Optical declarations for the
fireworks launcher.  The Compiler is supplied with definitions of a
variety of particle systems you may use as starting points for your own
experiments.

The compiler supports the extended HSV colour specifications described
above with negative first components, allowing you to develop and test
them before deploying in the launcher configuration.

CONFIGURATION NOTECARD

When the fireworks launcher is initially rezzed or reset with the Boot
command, if there is a notecard in its inventory named “Script:
Configuration”, the commands it contains will be executed
as if entered via local chat (do not specify the chat channel on the
script lines).  This allows you to automatically preset preferences as
you like.

THE TOUCH SCRIPT

When the launcher is touched, if there is a notecard in its inventory
named “Script: Touch”, the commands in it will be run.  This makes it
easy to create a show which can be run simply by touching the launcher.

ADDING FIREWORK SHELLS

The fireworks launcher launches fireworks shells which are linked to
it.  Each shell is independent, and multiple shells can be in flight
simultaneously, allowing rapidly-bursting salvos.  The launcher comes
with five fireworks shells installed.  If you'd like to have more
shells available for grand displays, you can add them with the
following procedure.  Locate the object named “Fireworks Shell n” in
the Fourmilab Fireworks folder and rez a copy into existence somewhere
near the launcher.  Once the shell appears (it is a small white
sphere), edit it and change its name to the next shell number: if
you're adding shell 6 to a launcher with the standard 5, you'd name it
“Fireworks Shell 6”.  Move the shell so it's inside the launcher, then
hold down the shift key and click the launcher so you've selected both
the shell and it.  Now press the Link button to add the shell as a link
of the launcher.  Finally, restart the launcher with the Boot command
so it will find the new shell.  You can add as many shells as you wish
in this manner, bearing in mind that each shell you add increases the
land impact of the launcher by 1.  If you don't need five shells and
wish to reduce land impact, edit the launcher, check the “Edit linked”
box, press Ctrl and comma to advance to the highest numbered shell,
press Unlink, drag it from the launcher and delete it. Then use the
Boot command so the launcher forgets it.

PERMISSIONS AND THE DEVELOPMENT KIT

Fourmilab Fireworks is delivered with “full permissions”.  Every part
of the object, including the script, may be copied, modified, and
transferred subject only to the license below.  If you find a bug and
fix it, or add a feature, please let me know so I can include it for
others to use.  The distribution includes a “Development Kit”
directory, which includes all of the components (for example, sound
clips and textures) of the model.

The Development Kit directory contains a Logs subdirectory which
includes the development narratives for the project.  If you wonder
“Why does it work that way?” the answer may be there.

Source code for this project is maintained on and available from the
GitHub repository:
    https://github.com/Fourmilab/fireworks

LICENSE

This product (software, documents, and models) is licensed under a
Creative Commons Attribution-ShareAlike 4.0 International License.
    http://creativecommons.org/licenses/by-sa/4.0/
    https://creativecommons.org/licenses/by-sa/4.0/legalcode
You are free to copy and redistribute this material in any medium or
format, and to remix, transform, and build upon the material for any
purpose, including commercially.  You must give credit, provide a link
to the license, and indicate if changes were made.  If you remix,
transform, or build upon this material, you must distribute your
contributions under the same license as the original.

ACKNOWLEDGEMENTS

The sound effects are free clips available from:
    https://www.soundeffectsplus.com/
The launch and burst sounds were extracted from the following clips.
    “Fishing Rod Whoosh 02” (SFX 41498159):
        https://www.soundeffectsplus.com/product/fishing-rod-whoosh-02/
    “Balloon Explode” (SFX 43561988):
        https://www.soundeffectsplus.com/product/balloon-explode-01/
    “Fireworks Exploding 01” (SFX 42885329):
        https://www.soundeffectsplus.com/product/fireworks-exploding-01/
    “Fireworks Exploding 02” (SFX 42885340):
        https://www.soundeffectsplus.com/product/fireworks-exploding-02/
    “Fireworks Exploding 03” (SFX 42885356):
        https://www.soundeffectsplus.com/product/fireworks-exploding-03/
    “Fireworks Exploding 04” (SFX 42885362):
        https://www.soundeffectsplus.com/product/fireworks-exploding-04/
    “Fireworks Exploding 05” (SFX 42885371):
        https://www.soundeffectsplus.com/product/fireworks-exploding-05/
    “Firework Explosion 01” (SFX 42885076):
        https://www.soundeffectsplus.com/product/firework-explosion-01/
    “Firework Explosion 02” (SFX 42885081):
        https://www.soundeffectsplus.com/product/firework-explosion-02/
    “Firework Explosion 03” (SFX 42885085):
        https://www.soundeffectsplus.com/product/firework-explosion-03/
    “Firework Explosion 04” (SFX 42885090)
        https://www.soundeffectsplus.com/product/firework-explosion-04/
All of these effects are © Copyright Finnolia Productions Inc. and
distributed under the Standard License:
    https://www.soundeffectsplus.com/content/license/
The sound clips were prepared for use in this object with the Audacity
sound editor on Linux.

The texture used on the launcher and optical effect compiler is
“Firework boom flame colorful festive seamless pattern vector”
ID 726887620 purchased from Shutterstock under their “unlimited Web
distribution” Standard License.
    https://www.shutterstock.com/image-vector/firework-boom-flame-colorful-festive-seamless-726887620
The Encapsulated PostScript vector image was transformed into the PNG
texture with Ghostscript and GIMP on Linux.
