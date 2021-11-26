
#   Load and play Handel's Music for the Royal Fireworks

Set trace on
Set echo on

Audio hwv351_01 hwv351_02 hwv351_03 hwv351_04 hwv351_05 hwv351_06 hwv351_07 hwv351_08 hwv351_09 hwv351_10 hwv351_11
Group hwv351 hwv351_01 hwv351_02 hwv351_03 hwv351_04 hwv351_05 hwv351_06 hwv351_07 hwv351_08 hwv351_09 hwv351_10 hwv351_11 [2.27]

Gload hwv351
Gwait

Script pause 15

Salvo -102.7
Gplay
Gwait

Delete hwv351_01 hwv351_02 hwv351_03 hwv351_04 hwv351_05 hwv351_06 hwv351_07 hwv351_08 hwv351_09 hwv351_10 hwv351_11
Delete hwv351

Echo Done.
