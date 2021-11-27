
#   Show accompanying embedded audio of Glenn Miller's
#   "In the Mood", played from a 78 RPM recording at the
#   Internet Archive via the Fourmilab Media Player.

URL inmood https://www.fourmilab.ch/mp/?src=https://archive.org/download/78_in-the-mood_glenn-miller-and-his-orchestra-johnson-dash-hawkins_gbia0020402/04%20-%20In%20the%20Mood%20-%20Glenn%20Miller%20and%20his%20Orchestra.mp3&autoplay [3:41]

@Echo Music: Glenn Miller and his Orchestra, "In the Mood"
@Echo RCA Victor (20-1565-A / 20-1565-B), 1939-08-01
@Echo From the Internet Archive collection, GBIA0020402C

Embed inmood

#   Wait for usual amount of time before it starts to play
Script pause 4

Set top off
Set radius 4 7
Salvo -210
Wait

Set interval 0
Salvo 20
Wait

#   Restore salvo/launch defaults

Set interval 0.75 2.5
Set radius 2 5
Script pause 0.5
Set top on

Delete inmood

@echo Done.
