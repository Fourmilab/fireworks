
#   Load and play Tchaikovsky's 1812 Overture

Set echo on

Audio 1812_1 1812_2 1812_3 1812_4 1812_5
Group 1812 1812_1 1812_2 1812_3 [10]  1812_4 1812_5 [4.26]

Gload 1812
Gwait

Script pause 15

Set top off
Script pause 0.25
Salvo -44.26
Gplay
Gwait

Delete 1812_1 1812_2 1812_3 1812_4 1812_5 1812
Script pause 0.25
Set top on

Echo Done.
