    /*

                        Fourmilab Fireworks
                            Media Player

        This script resides in the launcher hat brim.  It serves to
        play media requested by the Embed command, which can be used
        to play music and other audio content from Web streaming
        sites.  The video content for the media is hidden on the
        black edge of the brim, leaving only audio apparent.  The
        navigation and control panel is suppressed, leaving no user
        control: it is entirely up to the Embed command to manage
        selection and playback of content.

    */

    key owner;                          // Owner UUID
    key whoDat = NULL_KEY;              // Avatar who sent command
    vector oColour;                     // Original media face colour

    integer FACE_MEDIA = 1;             // Media player prim face

    //  Firework shell messages
    integer LM_FS_MEDIA = 96;           // Control media playback

    //  Snoop on Script Processor messages for housekeeping
    integer LM_SP_RESET = 51;           // Reset script
    integer LM_SP_STAT = 52;            // Print status

    //  tawk  --  Send a message to the interacting user in chat

    tawk(string msg) {
        if (whoDat == NULL_KEY) {
            //  No known sender.  Say in nearby chat.
            llSay(PUBLIC_CHANNEL, msg);
        } else {
            /*  While debugging, when speaking to the owner, use llOwnerSay()
                rather than llRegionSayTo() to avoid the risk of a runaway
                blithering loop triggering the gag which can only be removed
                by a region restart.  */
            if (owner == whoDat) {
                llOwnerSay(msg);
            } else {
                llRegionSayTo(whoDat, PUBLIC_CHANNEL, msg);
            }
        }
    }

    //  resetMedia  --  Halt any media in progress and restore static texture

    resetMedia() {
        integer stat = llClearLinkMedia(LINK_THIS, FACE_MEDIA);
        if (stat != STATUS_OK) {
            tawk("Error status " + (string) stat + " clearing media");
        }
        llSetColor(oColour, FACE_MEDIA);
    }

    default {

        on_rez(integer n) {
            llResetScript();
            oColour = llGetColor(FACE_MEDIA);
        }

        state_entry() {
            whoDat = owner = llGetOwner();
            //  Reset any media which might be playing
           resetMedia();
        }

        /*  The link_message() event receives commands from other scripts
            script and passes them on to the script processing functions
            within this script.  */

        link_message(integer sender, integer num, string str, key id) {
            whoDat = id;

            //  Script processor messages (on which we snoop)

            //  LM_SP_RESET (51): Reset script

            if (num == LM_SP_RESET) {
                llResetScript();

            //  LM_SP_STAT (52): Report status

            } else if (num == LM_SP_STAT) {
                string stat = "Media player:\n";
                integer mFree = llGetFreeMemory();
                integer mUsed = llGetUsedMemory();
                stat += "    Script memory.  Free: " + (string) mFree +
                        "  Used: " + (string) mUsed + " (" +
                        (string) ((integer) llRound((mUsed * 100.0) / (mUsed + mFree))) + "%)";
                list lms = llGetLinkMedia(LINK_THIS, FACE_MEDIA,
                            [   PRIM_MEDIA_CURRENT_URL,
                                PRIM_MEDIA_AUTO_PLAY,
                                PRIM_MEDIA_CONTROLS,
                                PRIM_MEDIA_PERMS_CONTROL,
                                PRIM_MEDIA_PERMS_INTERACT,
                                PRIM_MEDIA_WIDTH_PIXELS,
                                PRIM_MEDIA_HEIGHT_PIXELS,
                                PRIM_MEDIA_AUTO_SCALE ]);
                string mstat = "Idle";
                if (lms != [ ]) {
                    mstat = llList2CSV(lms);
                }
                stat += "\n    Media: " + mstat;
                tawk(stat);

            //  Firework Auxiliary messages

            //  LM_FS_MEDIA (96): Control media playback

            } else if (num == LM_FS_MEDIA) {
                if (str == "") {
                    resetMedia();
                } else {
                    integer stat = llSetLinkMedia(LINK_THIS, FACE_MEDIA,
                        [   PRIM_MEDIA_CURRENT_URL, str,
                            PRIM_MEDIA_AUTO_PLAY, TRUE,
                            PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
                            PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
                            PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE,
                            PRIM_MEDIA_WIDTH_PIXELS, 1,
                            PRIM_MEDIA_HEIGHT_PIXELS, 1,
                            PRIM_MEDIA_AUTO_SCALE, FALSE   ]
                    );
                    if (stat != STATUS_OK) {
                        tawk("Error status " + (string) stat + " playing URL " +
                            str);
                    }
                }
            }
        }
    }
