
                        Fourmilab Optical Effect Compiler
                                    User Guide

THE OPTICAL EFFECT COMPILER

Developing, debugging, and optimising optical effects can be a fussy,
error-prone, and tedious business.  To expedite the process, the
“Fourmilab Optical Effect Compiler” is included with this product. This
is a pyramid-shaped object that contains scripts defining particle
effects in Linden Scripting Language.  The compiler object responds to
commands in local chat which compile these scripts into Optical
commands which Fourmilab products use to define particle effects.
These commands may be copied and pasted into configuration notecards
used in other products.  You can also preview optical effects, edit
them, and immediately see the results.  A variety of pre-defined
particle effects are included as well as a general template for
defining your own particle effects.

The compiler supports extended HSV colour specifications that allow you
to specify randomly chosen colour components and/or copy hue
specifications from previously-chosen random colours.

CHAT COMMANDS

The Optical Effect Compiler accepts commands submitted on local chat
channel 1982 (release year of “Star Trek II: The Wrath of Kahn”, the
first movie to use particle effects in computer-generated imagery) and
responds in local chat.  Commands are as follows.  (Most chat commands
and parameters, except those specifying names from the inventory, may
be abbreviated to as few as two characters and are insensitive to upper
and lower case.)

    Access public/group/owner
        Specifies who can send commands to the compiler.  You can
        restrict it to the owner only, members of the owner's group, or
        open to the general public.  Default access is by owner.

    Boot
        Reset the script.  All settings will be restored to their
        defaults.  If you have changed the chat command channel, this
        will restore it to the default of 1982.

    Channel n
        Set the channel on which the compiler listens for commands in
        local chat to channel n.  If you subsequently reset the script
        with the “Boot” command or manually, the chat channel will
        revert to the default of 1982.

    Clear
        Send vertical white space to local chat to separate output when
        debugging.

    Echo text
        Echo the text in local chat.

    Generate effect
        Compile the named effect from its definition in a script in
        the compiler's inventory and display the Optical statements
        which define it in local chat.  The pattern is loaded into
        memory, where it can be previewed by touching the compiler
        object or modified with the Rule command.

    Help
        Send this notecard to the requester.

    List
        List the effects defined by scripts in the compiler's
        inventory.

    Rule mnemonic value
        Define or change the rule with the specified mnemonic in the
        currently loaded rule with the given value, which must be
        compatible with that required by the mnemonic.  The mnemonic
        may be either than used in the Second Life LSL
        llParticleSystem() API call or the abbreviations used in
        Fourmilab Optical declarations.  See the “Optical Effect
        Definitions” section below for a list of abbreviations and rule
        names.  Changes you make to effects loaded by the Generate
        command do not modify their definitions in scripts in the
        compiler's inventory.  Once you're satisfied with a change, be
        sure to apply it to the script so it isn't lost when you reset
        the compiler.


    Set echo on/off
        Controls whether commands entered from local chat are echoed to
        local chat as they are executed.

    Status
        Show status of the script, including settings and memory usage.

GENERATING AN OPTICAL EFFECT

Once you have rezzed the Optical Effect Compiler, you can list the
effects defined by scripts in its inventory with the local chat
command:
    /1982 List
To generate the Optical commands for a given effect, for example the
“splodey” burst effect, use:
    /1982 Generate splodey
The Optical commands for the effect will be generated from its
definition in the script and printed in local chat.  You can copy these
commands (the number of Optical commands generated will depend upon the
complexity of the effect) and paste them into a script run by the
product that generates the effect.

You can preview the effect by touching the compiler object.  The first
touch will start the effect and the second will turn it off.  Depending
on how the effect is defined, it may only run a limited amount of time
or until you stop it by touching the object again.  In either case, you
must stop it before previewing it again.  While the effect is running,
the compiler object is made mostly transparent so it doesn't obscure
the effect.

Once an effect has been loaded, you can modify the rules defining it
with the Rule command.  For example, to set the duration of the source
emitting the particles to 1.5 second, you can use either:
    /1982 Rule PSYS_SRC_MAX_AGE 1.5
    /1982 Rule sma 1.5
as rules can be specified either as their full llParticleSystem() names
or the Optical statement abbreviation of them.  After changing a rule,
touching the compiler to preview the effect will let you see the
change.  Note that this only changes the rule in memory and does not
update the script which defines it in the inventory.  Be sure to note
changes you want to make as you experiment and apply them to the
definition script.

DEFINING YOUR OWN OPTICAL EFFECTS

To add an optical effect to the compiler, you need to add a script
which defines it to the compiler's inventory.  Edit the compiler
object, display its Contents, then copy the script named “Optical:
template” to your inventory, rename it to your effect, for example,
“Optical: myeffect”.  (The effect name must use only lower case
letters.)  Then edit the script and replace the llParticleSystem()
definitions in effect_list with your own definition.  See the wiki
page:
    http://wiki.secondlife.com/wiki/LlParticleSystem
for the meaning of the various “rules” defining the effect.  All of the
rules are included in the template in the same order as in that page,
to make it easier to fill them out for your effect.  Copy your modified
script into the inventory of the compiler, recompile it (fixing any
errors that are reported), and load it with the command:
    /1982 generate myeffect
If all goes well, the Optical commands defining your effect will be
shown in local chat.  Next, test your effect by touching the compiler
to turn it on and again to turn it off.  If the effect isn't
satisfactory, edit the script in the compiler's inventory, adjust its
definition, save it, then re-enter the “generate” command and touch to
test.  “Lather, rinse, repeat” until you're happy with it.  Then copy
the Optical commands from the final version for use in the application
that generates the effect.  Be sure to make a copy of the script
defining the effect before deleting the compiler object lest you lose
the original.

OPTICAL EFFECT DEFINITIONS

Optical effects defined by the compiler are produced by what Second
Life calls a “particle system”, which is created by the function
llParticleSystem(), documented in the Wiki page:
    http://wiki.secondlife.com/wiki/LlParticleSystem
The compiler can create any particle system that Second Life can
display, allowing a multitude of creative effects.  Optical effects are
declared with the Optical command, which specifies the name of the
effect and a sequence of keywords and values defining the particle
system.  The keywords are abbreviations of the “rule names” defined for
llParticleSystem(), as follows, specifying the abbreviation, the
corresponding rule name, and the type of value that follows it in the
Optical declaration.
 Abbreviation      Rule Name                 Type
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
“angle” are floating point numbers representing angles, which are
specified in radians in llParticleSystem() lists but as degrees in
Optical statements.  In the “psc” and “pec” specifications, the value
can either be an <r,g,b> triple representing a colour with components
between 0 and 1 or a triple with one or more negative numbers that
denotes a colour in the HSV (hue, saturation, and value [brightness])
system where the negative component is chosen at random.  For example,
a value of <-1,1,1> specifies colour with a randomly chosen hue, full
saturation, and maximum brightness.  If the first component is -2, it
denotes the most recently randomly chosen hue: a specification of
<-2,1,0.2> chooses a colour with the same hue as the last, full
saturation, but a brightness one fifth maximum.  The “stk”
specification may name either the explicit key of an object, “self” to
denote the effect emitter itself, or “root” to refer to its parent
object.  The “st” specification may either name a texture placed in the
inventory of the object or the key (UUID) of a texture elsewhere on the
Second Life grid (whose permissions must allow you to use it).

Optical declarations may occupy as many lines as needed. Declarations
with the same name are concatenated to form a single optical effect.
For example, here is the declaration for a simple spherical burst
effect.
    Optical splodey sp 2 sbrad 0.02 psc <-1, 1, 1> pec <-2, 1, 0.2>
    Optical splodey pss <0.4, 0.4, 0> pes <0.1, 0.1, 0> psg 0.2 peg 0 sma 0.2 pma 1.5 sbrat 20
    Optical splodey sbpc 1000 sa <0, 0, 0> sbsmin 1 sbsmax 5 pf 291
Here we use the negative colour trick so bursts will have randomly
chosen hues.

LAND IMPACT AND PERMISSIONS

The Optical Effect Compiler is delivered with “full permissions”.
Every part of the object, including the scripts, may be copied,
modified, and transferred subject only to the license below.  If you
find a bug and fix it, or add a feature, please let me know so I can
include it for others to use.  The compiler has a land impact of 1.
Adding effects to its inventory does not increase the land impact.

If you develop products using Fourmilab Optical effects, you are free
to include the compiler with your product to help your users develop
them, subject only to the terms of the license below.

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
