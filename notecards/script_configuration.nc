#Legend <0, 1, 0> /<channel>'
Legend
#
#   Optical effects
#
#   Launch
Optical streak sp 4 sbpc 4 sbrat 0.05 pma 0.6 sbsmin 1 sbsmax 7 pss <0, 0.1, 0> pes <0.04, 0.5, 0>
    Optical streak psc <1, 1, 1> pec <0.2, 0.25, 0.25> psa 0.5 pea 0.5 stk self pf 354
#   Burst
Optical splodey sp 2 sbrad 0.2  psc <-1,1,1>  pec <-2, 1, 0.2>
    Optical splodey pss <0.3,0.3,0>  pes <0..1, 0.1, 0> psg 0.2  peg 0
    Optical splodey sma 0.2  pma 0.75  sbrat 20  sbpc 1000  sa <0, 0, 0>
    Optical splodey sbsmin 2  sbsmax 2  pf 291
Optical sparkler sp 2 sa <0, 0, 0> pma 0.6 sbrat 0.05 sbpc 50 sbrad 1 sbsmin 0.1 sbsmax 2 sa <0, 0, -0.8>
    Optical sparkler psc <1, 1, 1> pec <1, 0, 0> psa 0.9 pea 0 pss <0.15, 0.15, 0> pes <0.01, 0.1, 0> pf 307
Optical rays sp 2 sma 0 sbrat 0 sbpc 300 sbrad 0.2 sbsmin 1 sbsmax 5 sa <0, 0, 0> sab 0 sae 360
    Optical rays pma 1 psc <-1,1,1>  pec <-2, 1, 0.2> psa 1 pea 1 pss <0.08, 0.8, 0> pes <0.05, 0.1, 0> pf 299
Optical fire pma 2.5 pf 259 psc <0.18, 0.16, 0.13> pec <0.59, 0.65, 0.62> pss <0.15, 0.15, 0> pes <0.77, 1.21, 0> sp 2
    Optical fire sbrat 0 sbpc 4 sbrad 0 sbsmin 0.07 sbsmax 0.35 sab 95 sae 0 stk 006d9758-81da-38a9-9be3-b6c941cae931
    Optical fire psa 0.4 pea 0 sa <0, 0, 1.14>
Optical splash pf 289 pss <0.25, 0.25, 0> pes <1. 1, 0> psc <-1,1,1>  pec <-1,1,1> psa 1 pea 1 sma 0 pma 1 sbrat 0
    Optical splash sbpc 4000 sp 8 sbrad 1 sab 0 sae 180 so <0, 0, 0> sbsmin 1.75 sbsmax 2 sa <0, 0, -0.25> stk self
Optical hearts pf 257 pss <0.25, 0.25, 0> pes <1. 1, 0> psc <1, 1, 1> pec <1, 1, 1> psa 1 pea 1 sma 0 pma 1 sbrat 0
    Optical hearts sbpc 4000 sp 8 sbrad 1 sab 0 sae 180 so <0, 0, 0> sbsmin 1.75 sbsmax 2 sa <0, 0, -0.25>
    Optical hearts st 419c3949-3f56-6115-5f1c-1f3aa85a4606
Optical ants pf 257 pss <0.25, 0.25, 0> pes <1. 1, 0> psc <1, 1, 1> pec <1, 1, 1> psa 1 pea 1 sma 0 pma 1 sbrat 0
    Optical ants sbpc 4000 sp 8 sbrad 1 sab 0 sae 180 so <0, 0, 0> sbsmin 1.75 sbsmax 2 sa <0, 0, -0.25>
    Optical ants st 52350394-a031-1ac5-0edc-27bac17c732f
#
Optical spire pf 257 sp 4 pma 2 sma 1.5 sbsmin 2 sbsmax 3 sa <0, 0, -3>
    Optical spire sbrat 0.05 sbpc 3000 sab 60 sae 0 so <0, 0, 30> pss <0.25, 0.25, 0> psa 1
    Optical spire pea 0.25 psc <-1,1,1>  pec <-2, 1, 0.2>
Optical fireplace pf 291 sp 2 psa 1 pea 0 psc <1, 1, 1> pec <1, 1, 1>
    Optical fireplace pss <0.25, 0.25, 0> pes <1, 1, 0> pma 0.8 sma 1.5 sa <0, 0, 0> sab 0
    Optical fireplace sae 60.16056 sbpc 500 sbrad 0.1 sbrat 1 sbsmin 0 sbsmax 1.5 so <0, 0, 0>
    Optical fireplace st a96ecd50-96e1-28b4-51ec-96b3112210c0
Optical xplodey sp 2 sbrad 0.02 psc <-1,1,1>  pec <-2, 1, 0.2>
    Optical xplodey pss <0.4, 0.4, 0> pes <0.1, 0.1, 0> psg 0.2 peg 0 sma 0.2 pma 1.5 sbrat 20
    Optical xplodey sbpc 1000 sa <0, 0, 0> sbsmin 1 sbsmax 5 pf 291
Optical xpark sp 2 sma 1.5 pma 5 sbrat 0 sbpc 4500 sbrad 3 sbsmin 0.1
    Optical xpark sbsmax 3 sa <0, 0, 0> psc <-1,1,1>  pec <-2, 1, 0.2> psa 1 pea 0.5
    Optical xpark pss <0.15, 0.15, 0> pes <0.01, 0.01, 0> pf 307
Group new spire fireplace xplodey xpark rays

Optical fly pf 275 sp 1 sbrad 0.1 sab 0 sae 90 psc <0, 0.8, 0.85098> pec <0, 0.8, 0.85098> psa 0.25 pea 0
    Optical fly pss <0.03, 0.03, 0.03> pes <0.3, 0.3, 0.3> psg 0 peg 0 pbfs 7 pbfd 9  sma 0 pma 0.5 sbrat 0.02
    Optical fly sbpc 4 sa <0, 0, 0> so <0, 0, 0> sbsmin 1 sbsmax 1
#
#   Sound effects
#
Audio launch1 launch2 launch3
Audio burst1 burst2 burst3 burst4 burst5 burst6 burst7 burst8
Audio trombone
Audio handel_hwv_351
#
#   Ascent optical effects
#
Group ascent streak
#
#   Burst optical effects
#
Group burst splodey sparkler rays splash
#
#   Sound collections
#
Group launch launch1 launch2 launch3
Group explode burst1 burst2 burst3 burst4 burst5 burst6 burst7 burst8
#
#   Media URLs
#
URL pingu https://www.youtube.com/embed/IAuKHcshJqw?autoplay=1 [1:08]
URL horiz https://www.youtube.com/embed/HK4Jzkx-o3I?autoplay=1 [2:16]
URL othink https://www.youtube.com/embed/1MmyJT-eDmI?autoplay=1 [2:54]
Group songs pingu horiz othink
URL handel https://www.youtube.com/embed/XiTIfH0TpTg?autoplay=1 [22:00]
URL thunder https://www.youtube.com/embed/RhxmVbLSyo0?autoplay=1 [4]
