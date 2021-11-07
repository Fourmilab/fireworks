#Legend <0, 1, 0> /<channel>'
Legend

#   Optical effects

#   Launch

Optical streak sp 4 sbpc 4 sbrat 0.05 pma 0.6 sbsmin 1 sbsmax 7 pss <0, 0.1, 0> pes <0.04, 0.5, 0>
    Optical streak psc <1, 1, 1> pec <0.2, 0.25, 0.25> psa 0.5 pea 0.5 stk self pf 354

#   Burst

Optical ants pf 257 pss <0.25, 0.25, 0> pes <1, 1, 0> psc <1, 1, 1>
    Optical ants pec <1, 1, 1> psa 1 pea 1 sma 1 pma 2 sbrat 0 sbpc 4000 sp 8 sbrad 1 sab 0
    Optical ants sae 180 so <0, 0, 0> sbsmin 1.75 sbsmax 2 sa <0, 0, -0.25>
    Optical ants st 52350394-a031-1ac5-0edc-27bac17c732f
Optical ball pf 291 sp 2 sbrad 0.5 psc <-1, 1, 1> pec <-2, 1, 0> psa 1 pea 0
    Optical ball pss <1, 1, 0> pes <0.5, 0.5, 0> psg 0.2 peg 0 sma 0.2 pma 1 sbrat 20 sbpc 1000
    Optical ball sa <0, 0, 0> sbsmin 0.01 sbsmax 0.01
Optical flames pf 291 sp 2 psa 1 pea 0 psc <1, 1, 1> pec <1, 1, 1>
    Optical flames pss <0.25, 0.25, 0> pes <1, 1, 0> pma 0.8 sma 1.5 sa <0, 0, 0> sab 0
    Optical flames sae 60.16056 sbpc 500 sbrad 0.1 sbrat 1 sbsmin 0 sbsmax 1.5 so <0, 0, 0>
    Optical flames st a96ecd50-96e1-28b4-51ec-96b3112210c0
Optical fountain pf 257 sp 4 pma 2 sma 1.5 sbsmin 2 sbsmax 3 sa <0, 0, -3>
    Optical fountain sbrat 0.05 sbpc 3000 sab 60.00003 sae 0 so <0, 0, 30> pss <0.25, 0.25, 0> psa 1
    Optical fountain pea 0.25 psc <-1, 1, 1> pec <-2, 1, 0.2>
Optical fwork sp 2 sma 0 pma 9 sbrat 20 sbpc 500 sbrad 0.1 sbsmin 3 sbsmax 3
    Optical fwork sa <0, 0, -0.8> psc <0.96471, 0.14902, 0.03529> pec <0.96471, 0.14902, 0.03529>
    Optical fwork psa 0.9 pea 0 pss <0.3, 0.3, 0> pes <0.1, 0.1, 0> pf 291
Optical hearts pf 257 pss <0.25, 0.25, 0> pes <1, 1, 0> psc <1, 1, 1>
    Optical hearts pec <1, 1, 1> psa 1 pea 1 sma 1 pma 2 sbrat 0 sbpc 4000 sp 8 sbrad 1 sab 0
    Optical hearts sae 180 so <0, 0, 0> sbsmin 1.75 sbsmax 2 sa <0, 0, -0.25>
    Optical hearts st 419c3949-3f56-6115-5f1c-1f3aa85a4606
Optical rays sp 2 sma 1.5 sbrat 0 sbpc 300 sbrad 0.2 sbsmin 1 sbsmax 5
    Optical rays sa <0, 0, 0> sab 0 sae 360 pma 1 psc <-1, 1, 1> pec <-2, 1, 0.2> psa 1 pea 1
    Optical rays pss <0.08, 0.8, 0> pes <0.05, 0.1, 0> pf 299
Optical spark sp 2 sma 1.5 pma 5 sbrat 0 sbpc 4500 sbrad 3 sbsmin 0.1 sbsmax 3
    Optical spark sa <0, 0, 0> psc <-1, 1, 1> pec <-2, 1, 0> psa 1 pea 0.5 pss <0.15, 0.15, 0>
    Optical spark pes <0.01, 0.01, 0> pf 307
Optical splodey sp 2 sbrad 0.02 psc <-1, 1, 1> pec <-2, 1, 0.2>
    Optical splodey pss <0.4, 0.4, 0> pes <0.1, 0.1, 0> psg 0.2 peg 0 sma 0.2 pma 1.5 sbrat 20
    Optical splodey sbpc 1000 sa <0, 0, 0> sbsmin 1 sbsmax 5 pf 291

#   Sound effects

Audio launch1 launch2 launch3
Audio burst1 burst2 burst3 burst4 burst5 burst6 burst7 burst8
Audio trombone
Audio handel_hwv_351

#   Ascent optical effects

Group ascent  streak

#   Burst optical effects

Group burst  ball fountain fwork rays spark splodey

#   Sound collections

Group  launch   launch1 launch2 launch3
Group explode  burst1 burst2 burst3 burst4 burst5 burst6 burst7 burst8

#   Media URLs

URL pingu https://www.youtube.com/embed/IAuKHcshJqw?autoplay=1 [1:08]
URL horiz https://www.youtube.com/embed/HK4Jzkx-o3I?autoplay=1 [2:16]
URL othink https://www.youtube.com/embed/1MmyJT-eDmI?autoplay=1 [2:54]
Group songs pingu horiz othink
URL handel https://www.youtube.com/embed/XiTIfH0TpTg?autoplay=1 [22:00]
URL thunder https://www.youtube.com/embed/RhxmVbLSyo0?autoplay=1 [4]
