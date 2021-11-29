
#   Demonstrate burst optical effects

set echo off
clear

set interval 2
set top off
script pause 0.25

echo
echo                    ants
salvo 3 ants
wait
script pause 2

echo
echo                    ball
salvo 3 ball
wait
script pause 2

Optical crystals pf 289 sp 4 sma 1.5 pma 1.5 sbsmin 1 sbsmax 2 sa <0, 0, 0.2>
    Optical crystals sbrat 0.05 sbpc 10 sab 0 sae 89.99998 so <0, 0, 20> pss <0.25, 0.25, 0> psa 1
    Optical crystals pea 0.5 st 181c6b1d-c2d0-70ba-bbf2-52ccc31687c6
echo
echo                    crystals
salvo 3 crystals
wait
script pause 2
delete crystals

Optical flames pf 291 sp 2 psa 1 pea 0 psc <1, 1, 1> pec <1, 1, 1>
    Optical flames pss <0.25, 0.25, 0> pes <1, 1, 0> pma 0.8 sma 1.5 sa <0, 0, 0> sab 0
    Optical flames sae 60.16056 sbpc 500 sbrad 0.1 sbrat 1 sbsmin 0 sbsmax 1.5 so <0, 0, 0>
    Optical flames st a96ecd50-96e1-28b4-51ec-96b3112210c0
echo
echo                    flames
salvo 3 flames
wait
script pause 2
delete flames

echo
echo                    fountain
salvo 3 fountain
wait
script pause 2

echo
echo                    fwork
salvo 3 fwork
wait
script pause 2

echo
echo                    hearts
salvo 3 hearts
wait
script pause 2

Optical rain pma 1.2 pf 259 psc <0.73, 0.84, 0.79> pec <0.61, 0.76, 0.82>
    Optical rain pss <0.1, 0, 0> pes <0.1, 3.69, 0> sp 8 sbrat 0.1 sbpc 25 sbrad 5.57
    Optical rain sbsmin 0.11 sbsmax 0.64 sab 0 sae 44.99999 sma 5
    Optical rain st 06675bc5-e9b9-0557-7179-fbf7779faed8 psa 0.2 pea 0.75 sa <-0.37, 0.45, -12>
echo
echo                    rain
salvo 3 rain
wait
script pause 2
delete rain

echo
echo                    rays
salvo 3 rays
wait
script pause 2

Optical smoke pma 2.5 pf 259 psc <0.18, 0.16, 0.13> pec <0.59, 0.65, 0.62>
    Optical smoke pss <0.15, 0.15, 0> pes <0.77, 1.21, 0> sma 2 sp 2 sbrat 0 sbpc 4 sbrad 0
    Optical smoke sbsmin 0.07 sbsmax 0.35 sab 94.53803 sae 0
    Optical smoke st 006d9758-81da-38a9-9be3-b6c941cae931 psa 0.4 pea 0 sa <0, 0, 1.14>
echo
echo                    smoke
salvo 3 smoke
wait
script pause 2
delete smoke

Optical snow sp 8 sbpc 20000 sbrat 0 sma 3 pma 6 sbrad 0.1 sab 67.49998
    Optical snow sae 89.99998 sa <0, 0, -0.5> sbsmin 0.25 sbsmax 1 pss <0.1, 0.1, 0>
    Optical snow pes <0.1, 0.1, 0> psc <1, 1, 1> pec <1, 1, 1> psa 0.5 pea 0.8
    Optical snow st 60ec4bc9-1a36-d9c5-b469-0fe34a8983d4 pf 291
echo
echo                    snow
salvo 3 snow
wait
script pause 2
delete snow

echo
echo                    spark
salvo 3 spark
wait
script pause 2

echo
echo                    splodey
salvo 3 splodey
wait
script pause 2

set interval 0.75 2.5
script pause 0.25
set top on
set echo on

@echo Done.
