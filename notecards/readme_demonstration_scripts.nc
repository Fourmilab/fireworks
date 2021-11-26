Fourmilab Fireworks is usually driven from commands in notecards which it
refers to as "scripts" (and should not be confused with scripts in Linden
Scripting Language").  The product is supplied with a variety of demonstration
scripts that show various capabilities of the product and can serve as the
starting point for your own custom scripts.

You can list all scripts in the launcher by entering the local chat command:
    /1749 Script list
and run any script from the list with:
    /1749 Script run Script Name
where "Script Name" is the name from the list output , exactly as given (including
spaces and upper and lower case letters).  If you view the Contents of the launcher
in the editor, you'll see that all script notecards have names that begin with
"Script: "; you must not type that then running the script.

SHOWS SET TO MUSIC

These scripts use the Gload/Gplay facility to play a sequence of clips for a longer
musical piece with a fireworks show while it is playing.

    1812
        Tchaikovsky's "1812 Overture", Op. 49

    hwv351
        Handel's "Music for the Royal Fireworks", BWV 351

TOUCH TRIGGERED

This script is run when a user touches the launcher.  It runs a simple show, but you can
configure any show you like, including multiple shows selected from a pop-up menu
to be triggered from a touch.

    Touch
        Simple show run when the launcher is touched.

SCHEDULED SHOW

This script illustrates a show that runs automatically at scheduled times.  Once started,
it puts on a simple show consisting of a salvo of 12 bursts every half hour on the half
hour.  To stop the automatic show, issue a "Script run" command with no script name to
the launcher or use the Boot command to reset it.

    Scheduled Show
        Run show every 30 minutes on the half hour

DEMONSTRATION

    Burst Demonstration
        Shows all of the burst optical effects included by default in the launcher's
        configuration, plus those defined using the Optical Effect Compiler and
        referenced by UUID from the Second Life grid by example shows.

YOUTUBE EXAMPLES

The following scripts were used to create the YouTube video demonstration of the
Fourmilab Fireworks product:
    https://www.youtube.com/watch?v=bzBMy3w8WMU

    YT Belize
        Show set to the Belize national anthem, played from a URL on the Web

    YT Hat Salvo
        Five shot simultaneous salvo launched while wearing the launcher as a hat

    YT Hat Show
        Complicated, multi-segment show with an introductory music clip run while
        wearing the launcher as a hat.

    YT Menu
        Demonstration of selecting three different kinds of bursts interactively
        from a pop-up menu.

    YT Region Announce
        With the launcher worn as a hat, trigger a salvo upon arrival in a new region.

YOUTUBE HELPERS

These brief scripts are used by the TY Menu demonstration to implement an
interactive menu system.  They can be run stand-alone to demonstrate the
individual effects.

    Ants
        Shell explodes into a multitude of ants (eeeew!)

    Burst
        Fireworks burst explosion

    Exit
        Does nothing (used to exit menu system)

    Hearts
        Shell explodes into hearts (awwww!)

    Rays
        Rays radiate out from shell

CONFIGURATION

This is not a demonstration script, but included for completeness.  This is the
standard configuration script which is loaded whenever the launcher is reset.
Add or delete statements to this which you wish to be run before the launcher
begins to accept commands.  You can, for example, start scheduled shows which
will run automatically whenever the launcher is restarted.

    Configuration
        Run automatically whenever the launcher is restarted
