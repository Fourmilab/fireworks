
#   Fireworks to accompany the Belize national anthem

URL belize https://www.fourmilab.ch/mp?v=https://www.fourmilab.ch/documents/belize/belize.mp3&autoplay [1:09]
#URL belize https://www.fourmilab.ch/mp/?v=https://archive.org/download/lp_sounds-in-space_various-boston-pops-orchestra-boston-symph/disc1/02.01.%20The%20Rite%20Of%20Spring.mp3&autoplay [5:00]
#URL belize https://www.fourmilab.ch/mp/?v=https://ia802704.us.archive.org/27/items/bestof69soundrec00baxt/06_Hey_Jude.ogg&autoplay&type=audio/ogg [3:18]

Embed belize
Set top off
#   Wait for usual amount of time before it starts to play
Script pause 4
#
#   Fire initial salvo
#
    Set radius 4 7
Salvo 20
Wait
#
#   Release the ants!
#
Script pause 0.5
Launch ants
Wait
#
#   Now launch another, shorter salvo
#
Salvo 10
Wait
Script pause 1
#
#   Launch final blow-out salvo
#
Set interval 0
Set radius 4 7
Salvo 10
Wait
#   Restore salvo/launch defaults
Set interval 0.75 2.5
Set radius 2 5
#
#   Thank the audience
#
Script pause 1
Launch hearts
Wait
Set top on

Delete belize
