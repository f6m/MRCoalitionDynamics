;;By m6f, any comment please write me at hellypoch@gmail.com

;GLOBALES VARIABLES
;------------------
globals[contador contadorAct contadorActNull i j tduni1 tduni2 tduni3 tduni4 blacks a m n
         patche1 patche2 patche3 patche4 propini propfin propiniab propt0
         xi yj personas P1 P2 negro P3 blanco Caux p sum-color1 sum-color2 sum-color3
         sum-color4 col npixel z colorempate2rm colorempate1rm
         t0party_1 t0party_2 t0party_3 t0party_4 t0party_5
         maximum contempate-mr contempate-ab rcolor rpartido
         c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 partidomenor
         menorav mayorav
         ]

;PATCH VARIABLES
patches-own [partido influencia]
;---------------

;SETUP PROCEDURE. System initializatioin, by distributing opinions A,B,C,0
;Opinions A, B, C, 0 are drawed with black respectively.
;------------------------------------------------------------------------

to setup
 ;Resize the work according to netorder value
 resize-world 0 netorder 0 netorder

 ;tparty_1 is the variable associated with entry buttom, also variables tparty_2, tparty_3, tparty_4, tparty_5 has an entry buttom
 ;this variables serves to initialize the world, at the beginning must be 0, and at final inizialitation must be equal to persons_party's variables.
 set tparty_1 0
 set tparty_2 0
 set tparty_3 0
 set tparty_4 0
 set tparty_5 0

 ;porcentA, porcentB and porcentC sets percents for party, i.e., numbers in [0,1] s.t. porcentA + porcentB = 1 - pocentC and porcentC <= 1
 ifelse (porcentC <= 1)
 [
 ;Setting porcentC to 0.5 party C has the half of nodes and AB has the other half
 set porcentB (precision (1 - porcentC - porcentA) 3) ;precision predicate sets the number of decimal digits to use.
 ]
 [ stop ]

 ;Setting number of nodes in totaladistribuir variable
 ;Fixing totaladistribuir, in general it could be variable
 ;set totaladistribuir (netorder + 1) * (netorder + 1)
 set nnodos (netorder + 1) * (netorder + 1)

 ;First erase our world
 clear-all

 ;To each patche we set its party to null party, influencia to 0, color to black
 ask patches [set partido 4 set influencia 0 set pcolor black]

 ;To assign the number of nodes we use porcent variables and totaladistribuir variable.
 set persons_party1 floor (porcentA * totaladistribuir)
 set persons_party2 floor (porcentB * totaladistribuir)
 set persons_party3 floor (porcentC * totaladistribuir)
 set persons_party4 nnodos - persons_party1 - persons_party2 - persons_party3

 ;To have an ordered list of patches
 set npixel []
 set i 0
 set j 0

   repeat netorder + 1   ; Run r times the inner repeat
  [
    repeat netorder + 1 ; Run r times set npixel...
    [
    set npixel sentence npixel patch i j

    set j j + 1 ; Increases j from 0 to 99
    ]
    set i i + 1 ; Increases i from 0 to 99
    set j 0
   ]

;Here npixel is an ordered list o patches pairs, length(npixel)=10000
set Caux npixel

;10000 = N
set N nnodos

;It is distributed patches according to persons_party1, persons_party2, and persons_party3
    ;List to be filled with the patche distribution per party. Initialized to empty list
    set tduni1 []
    set tduni2 []
    set tduni3 []
    set tduni4 []

;If it is required to draw districts lines we draw them
    if districtdraw = true [ draw_district ]

 ;To distribute A nodes
 repeat persons_party1 ;Repeat participante1 times
 [
   set z random N     ; 0 <= z <= 9999
   ask item z npixel [set pcolor 2 set partido 1 set influencia 1] ;Selects a random patch in npixel list then change its attributes
   set npixel replace-item z npixel item (N - 1) npixel ;
   set tduni1 sentence tduni1 item z npixel
   set N N - 1
 ]

 ;To distribute B nodes
 ;Last N value comes in the previous cycle then it has N - persons_party1
 repeat persons_party2
 [
   set z random N
   ask item z npixel [set pcolor 8 set partido 2 set influencia 1]
   set npixel replace-item z npixel item (N - 1) npixel
   set tduni2 sentence tduni2 item z npixel
   set N N - 1
 ]

 ;To distribute C nodes, takint in account if C is or not #V(R)/2
 ;Last N value comes in the previous cycle then it has N - persons_party1 - persons_party2
 ifelse persons_party3 = nnodos / 2
 [
   ask patches with [pcolor = black] [ set pcolor white set partido 3 set influencia 1 ]
   ;set N 0
   ;set i pxcor
   ;set j pycor
   ;set tduni3 sentence tduni3 patch i j ]
 ]
 [
 ; to enter here persons_party3 is less (or more) than #V(R)
 repeat persons_party3
 [
   set z random N
   ask item z npixel [set pcolor white set partido 3 set influencia 1]
   set npixel replace-item z npixel item (N - 1) npixel
   set tduni3 sentence tduni3 item z npixel
   set N N - 1
 ]
 ;stop
 ]

 ;If persons_party1 + persons_party + persons_party3 not equal to network order, by floors and
 ;we have no null nodes, then assign the node to party3
 if N - persons_party4 > 0 and persons_party4 > 0
 [
 ask (patches with [pcolor = black]) [set pcolor white set partido 3 set influencia 1]
 ]

 if persons_party4 > 0
 [
   ask patches with [pcolor = black] [
     set i pxcor
     set j pycor
     set tduni4 sentence tduni4 patch i j
   ]
 ]
 set blacks count patches with [pcolor = black]


 ;Contamos los individuos de cada partido
 set tparty_1 count patches with [partido = 1]
 set tparty_2 count patches with [partido = 2]
 set tparty_3 count patches with [partido = 3]
 set tparty_4 count patches with [partido = 4]
 set tparty_5 count patches with [pcolor = 8 or pcolor = 2]

 ;Before to begin with dynamics, we set up some variables
 ;Following lists are needed by plot procedure
 set P1 []
 set P2 []
 set P3 []
 set negro []
 set blanco []

 ;Variable to count draws under main MR
 set contempate-mr 0

 ;Variables para contar cada actualización realizada
 set contadorAct 0 ;Este contador nos permite contar el numero de pasos de actualizacion y se usa al dibujar la cuadricula
 set contadorActNull 0 ;Este contador nos permita contar el numero de ciclos antes de acabar con indecisos

 ;To know minimum and maximum size party and to fix initial proportion.
 ;I = Im / Ig
 ifelse tparty_1 < tparty_2
 [
   set menorav 2 ;minor is party1
   set mayorav 8 ;mayor is party2
   set propini tparty_1 / (tparty_2)
   set propiniab tparty_1 / (tparty_1 + tparty_2)
 ]
 [
   set menorav 8 ;minor is party2
   set mayorav 2 ;mayor is party1
   set propini tparty_2 / (tparty_1)
   set propiniab tparty_2 / (tparty_1 + tparty_2)
 ]

  set propfin 0 ; initially we set propfin to 0
  reset-ticks  ; reset tick counter variable to count the number of entrances to setup procedure
end

;INICIO PROCEDURE. Apply repetition scheme and inspection of patches
;-------------------------------------------------------------------

to inicio

;A repetition or a cycle is a selection of totaladistribuir nodes with or without repetition, here, following Redner we use 600 as the maximum number of repetitions
repeat 1400 ;Stripe
[
   ;Condicion para terminar el la dinámica del modelo, escencialmente es que se llege al concenso o que se efectuen todos los 600 ciclos
  if (tparty_1 = nnodos) or (tparty_2 = nnodos) or (tparty_3 = nnodos) or (tparty_4 = nnodos) or (tparty_5 = nnodos) [stop]

  set N nnodos
  set npixel Caux ; Return npixel to the previos before modified in setup procedure.

  ;Repeat nnodos - lattice network order - A CYCLE
  repeat nnodos
  [
    ;Choose a random item for patch list
    set z random N ;0 <= z <= nnodos-1

    ;Computations over the 4-neighbourhood for patche (xi,yj)
    ask item z npixel
    [
    ;Choose a patch with coordinates (xi,yj) then save it in personas list
    set personas sentence personas item z npixel
    ;To determinate how is theh neighbourhood of patch (xi,yj) in termos of number of nodes per party
    ask item z npixel [set sum-color1 sum ([influencia] of neighbors4 with [pcolor = 2])]   ;Party 1
    ask item z npixel [set sum-color2 sum ([influencia] of neighbors4 with [pcolor = 8])]   ;Party 2
    ask item z npixel [set sum-color3 sum ([influencia] of neighbors4 with [pcolor = white])]  ;Party 3
    set sum-color4 4 - sum-color1 - sum-color2 - sum-color3 ;Party 4, the null node arround patch xi yj, they has influencia = 0

    ;To count number of inspections we made
    set contadorAct contadorAct  + 1

    ;To know the number of cycles when null nodes desapair
    if tparty_4 > 0
      [
        set contadorActNull contadorActNull + 1
      ]

    ;Party 1 = A color soft black code 2, party 2 = B color gray code 8, party 3 = C color white code white, null = 0 color black code 0

    ;To add central node and take it in account
    if (pcolor = 2)
    [
    set sum-color1 sum-color1 + 1
    ]
    if (pcolor = 8)
    [
    set sum-color2 sum-color2 + 1
    ]
    if (pcolor = white)
    [
    set sum-color3 sum-color3 + 1
    ]
    if (pcolor = black)
    [
    set sum-color4 sum-color4 + 1
    ]

    ;To enter into the 4-neighbourhood analysis excluding cases when only have C's or only have A's and B's
    ;if (sum-color3 > 0 and (sum-color1 > 0 or sum-color2 > 0)) or (sum-color4 > 0 and (sum-color1 > 0 or sum-color2 > 0) or (sum-color4 > 0 and sum-color3 > 0)) [

    ;To enter here, we considering a 4-neighbourhood AB, C excluding C's or only A's and B's
    ;To enter and inspect a group G: we consider a 4-neighbourhood with AB, C, 0 excluding C's or only A's and B's or only 0's
    ;The logic negation is sum-color3=0 or (sum-color1=0 and sum-color2=0) which means only C's and only A's and B's then is correct!
    if(sum-color3 > 0 and (sum-color1 > 0 or sum-color2 > 0) or (sum-color3 > 0 and sum-color4 > 0) or ((sum-color1 > 0 or sum-color2 > 0) and sum-color4 > 0))
    [

    ;Mayority rule for AB VS C and 0
    if (sum-color1 + sum-color2 > sum-color3)
    [
          ;AB wins and exist A's and B's with at least one C or one 0 then use a sedond MR between AB's group.
          ;2rm + aleatorio with central A
            if sum-color1  > sum-color2 ; A's > B's
            [
            ask item z npixel [set pcolor 2 set partido 5 set influencia 1]
            ask neighbors4 [set pcolor 2 set partido 5 set influencia 1]
            ]
            if sum-color1  < sum-color2 ; A's < B's
            [
            ask item z npixel [set pcolor 8 set partido 5 set influencia 1]
            ask neighbors4 [set pcolor 8 set partido 5 set influencia 1]
            ]
            if sum-color1  = sum-color2 ; if A's = B's then do random selection between {A,B}
            [
             ;Empate coalicion bajo regla de mayoria
             ifelse random 2 = 1
             [set colorempate2rm 2] ;
             [set colorempate2rm 8] ;

             ask item z npixel [set pcolor colorempate2rm set partido 5 set influencia 1]
             ask neighbors4 [set pcolor colorempate2rm set partido 5 set influencia 1]
             ;Just delete random rule for the variation
             set contempate-ab contempate-ab + 1
             ;Count cases with 0's here
             if(sum-color1 = 1 and sum-color2 = 1 and sum-color4 = 3) ;AB000
             [set c7 c7 + 1]
             if(sum-color1 = 1 and sum-color2 = 1 and sum-color3 = 1 and sum-color4 = 2) ;ABC00
             [set c8 c8 + 1]
             if(sum-color1 = 2 and sum-color2 = 2 and sum-color4 = 1) ;AABB0
             [set c9 c9 + 1]
             if(sum-color1 = 2 and sum-color2 = 2 and sum-color3 = 1) ;AABBC
             [set c10 c10 + 1]

            ]
    ] ;END coalition AB wins to C in the 4-neighbourhood with central A

    ;If C wins
    if (sum-color3 > sum-color1 + sum-color2)
    [
         ask item z npixel [set pcolor white  set partido 3 set influencia 1]
         ask neighbors4 [set pcolor white  set partido 3 set influencia 1]
    ]

    ;The system has 0's and MR no decides
    if (sum-color3 = sum-color1 + sum-color2)
    [
      ;ifelse random 2 = 1
      ;[set colorempate1rm white
      ; set p 3]
      ;[ ifelse random 2 = 1
      ;  [set colorempate1rm 8
      ;   set p 5]
      ;  [set colorempate1rm 2
      ;   set p 5]
      ;];

      ;ask item z npixel [set pcolor colorempate1rm set partido p set influencia 1]
      ;ask neighbors4 [set pcolor colorempate1rm set partido p set influencia 1]

      set contempate-mr contempate-mr + 1 ;count mr-draw
        if(sum-color4 = 5) ;00000
        [set c1 c1 + 1]
        if(sum-color1 = 1 and sum-color3 = 1 and sum-color4 = 3) ;AC000
        [set c2 c2 + 1]
        if(sum-color2 = 1 and sum-color3 = 1 and sum-color4 = 3) ;BC000
        [set c3 c3 + 1]
        if(sum-color1 = 2 and sum-color3 = 2 and sum-color4 = 1) ;AACC0
        [set c4 c4 + 1]
        if(sum-color2 = 2 and sum-color3 = 2 and sum-color4 = 1) ;BBCC00
        [set c5 c5 + 1]
        if(sum-color1 = 1 and sum-color2 = 1 and sum-color3 = 2 and sum-color4 = 1) ;ABCC0
        [set c6 c6 + 1]
    ]

    ] ;End if, conditions to enter in 4-neighbourhood analysys

        if repeticion = false
       [ set npixel replace-item z npixel item (N - 1) npixel ;remplace item z of npixel list with item N-1 of npixel, puts final npixel's item on z place
          set N N - 1 ]

    ] ;END ask item z npixel

   ] ;END repeat nnodos END 1 CYCLE

   ;To count number of patches per color, after cycle.
   set tparty_1 count patches with [pcolor = 2]
   set tparty_2 count patches with [pcolor = 8]
   set tparty_3 count patches with [pcolor = white ]
   set tparty_4 count patches with [pcolor = black]
   set tparty_5 count patches with [pcolor = 8 or pcolor = 2]

     ;To plotting...
     set a ((count patches with [pcolor = 2]) + (count patches with [pcolor = 8]) + (count patches with [pcolor = white ])
       + (count patches with [pcolor = black]) + (count patches with [partido = 5]))

     ;set-current-plot "grafic"

     ;set-current-plot-pen "party_1"
     set P1 sentence P1 (count(patches with [pcolor = 2]) / a)
     ;plot count ( patches with [pcolor = 2] ) / a
     ;set-plot-pen-color 2

     ;set-current-plot-pen "party_2"
     set P2 sentence P2 (count(patches with [pcolor = 8]) / a)
     ;plot count (patches with [pcolor = 8]) / a
     ;set-plot-pen-color 8

     ;set-current-plot-pen "party_3"
     set P3 sentence P3 (count(patches with [pcolor = white ]) / a)
     ;plot count (patches with [pcolor = white ]) / a
     ;set-plot-pen-color white

     ;set-current-plot-pen "party_4"
     set negro sentence negro (count(patches with [partido = 4]) / a)
     ;plot count (patches with [partido = 4]) / a
     ;set-plot-pen-color black


     ;set-current-plot-pen "party_5"
     set blanco sentence blanco (count(patches with [partido = 5]) / a)
     ;plot count (patches with [partido = 5]) / a
     ;set-plot-pen-color black


     ;When 0's dissapear
     if ((tparty_4 = 0) and (blacks > 0))
     [
       ;We count party cardinallities at T_0, time when 0's dissapear
       set t0party_1 tparty_1
       set t0party_2 tparty_2
       set t0party_3 tparty_3
       set t0party_4 tparty_4
       set t0party_5 tparty_5
       set blacks 0

     ;To stablish final proportion
     if ((menorav = 2) and (t0party_2 != 0)) ;party A is the minimum size party
     [
     set propt0 t0party_1 / t0party_2
     ]

     if ((menorav = 8) and (t0party_1 != 0)) ;party B us the minimum size party
     [
     set propt0 t0party_2 / t0party_1
     ]
      ]


     ;To stablish final proportion
     if ((menorav = 2) and (tparty_2 != 0)) ;party A is the minimum size party
     [
     set propfin tparty_1 / tparty_2
     ]

     if ((menorav = 8) and (tparty_1 != 0)) ;party B us the minimum size party
     [
     set propfin tparty_2 / tparty_1
     ]


   ] ;END repeat 600

stop

end


;Color codes: 45 es white , 55 es 8, 105 es 2, black es 0

; REPORTERS
; proportional report colors 2, 8
to-report proportional
  let h random-float 1
  if menorav = 2 and h <= propiniab
   [report 2]
  if menorav = 2 and h > propiniab
   [report 8]

  if menorav = 8 and h <= propiniab
   [report 8]
  if menorav = 8 and h > propiniab
   [report 2]
end


;Procedure to draw lines into network for districts to draw_district square
;--------------------------------------------------------
to draw_district
set contador  ceiling ((netorder + 1) / 10) ;50 / 10, 75 / 10, 100 / 10, 125 / 10, 150 / 10
   set i 0
   set j 0

   repeat contador
   [ crt 1 [ ;creates one turtle specifying coordinates (x,y)
      setxy i * 10 j * 10 ;(0,0),(10,10),...,(100,100)
      set heading 0 ;angle 0 and 360
      set color green ;color
      set shape "line" ;shape
      set size (world-height + 50) ;size
      stamp ;staping the shape in the world
      rt 90 ;rotate 90 degrees
      set size (world-width + 50)
      stamp
      set i i + 1
      set j j + 1
    ]
  ]

end

;Procedimiento que dibuja una situacion de empate.
;-------------------------------------------------------------
to SetUpDraw

      clear-all
      ask patches [set partido 4 set influencia 0 set pcolor black]

      ;set i random 50
      ;set j random 50


      ;vamos a ponere una situacion de empate AB000
      ;set patche1 patch i j
      ;ask patche1 [set pcolor 2 set partido 1 set influencia 1]

      ;set patche2 patch i (j + 1)
      ;ask patche2 [set pcolor 8 set partido 2 set influencia 1]


      ;vamos a poner una situacion de empate AABBC
      set m random 50
      set n random 50

      set patche1 patch m n
      ask patche1 [set pcolor 2 set partido 1 set influencia 1]
      set patche2 patch (m - 1) n
      ask patche2 [set pcolor 2 set partido 1 set influencia 1]

      set patche3 patch m (n + 1)
      ask patche3 [set pcolor 8 set partido 2 set influencia 1]
      set patche4 patch (m + 1) n
      ask patche4 [set pcolor 8 set partido 2 set influencia 1]

      set patche4 patch m (n - 1)
      ask patche4 [set pcolor white  set partido 3 set influencia 1]

      ;inicio

end
@#$#@#$#@
GRAPHICS-WINDOW
231
10
439
219
-1
-1
1.0
1
10
1
1
1
0
1
1
1
0
199
0
199
0
0
1
ticks
30.0

BUTTON
799
37
862
70
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
862
37
926
70
NIL
inicio\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
801
128
988
161
persons_party1
persons_party1
0
(netorder + 1)*(netorder + 1)
5625.0
1
1
NIL
HORIZONTAL

SLIDER
801
168
988
201
persons_party2
persons_party2
0
(netorder + 1)*(netorder + 1)
5625.0
1
1
NIL
HORIZONTAL

INPUTBOX
222
567
377
627
tparty_1
8524.0
1
0
Number

INPUTBOX
389
567
544
627
tparty_2
13119.0
1
0
Number

INPUTBOX
556
568
711
628
tparty_3
18357.0
1
0
Number

SLIDER
802
207
989
240
persons_party3
persons_party3
0
(netorder + 1)*(netorder + 1)
11250.0
1
1
NIL
HORIZONTAL

INPUTBOX
222
635
377
695
tparty_4
0.0
1
0
Number

INPUTBOX
556
637
711
697
nnodos
40000.0
1
0
Number

INPUTBOX
388
636
545
696
tparty_5
21643.0
1
0
Number

MONITOR
26
75
157
140
2#Draw AC000
c2
17
1
16

MONITOR
26
140
157
205
3#Draw CB000
c3
17
1
16

MONITOR
26
204
157
269
4#Draw AACC0
c4
17
1
16

MONITOR
26
269
157
334
5#Draw BBCC0
c5
17
1
16

MONITOR
725
569
806
614
#Empate MR
contempate-mr
17
1
11

SLIDER
994
87
1175
120
totaladistribuir
totaladistribuir
0
(netorder + 1) * (netorder + 1)
22503.0
1
1
NIL
HORIZONTAL

SLIDER
996
129
1175
162
porcentA
porcentA
0
1
0.25
0.001
1
NIL
HORIZONTAL

SLIDER
997
167
1175
200
porcentB
porcentB
0
1
0.25
0.001
1
NIL
HORIZONTAL

SLIDER
996
206
1175
239
porcentC
porcentC
0
1
0.5
0.001
1
NIL
HORIZONTAL

BUTTON
799
68
926
101
NIL
SetUpDraw\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
25
435
191
500
AB#Draw AB000
c7
17
1
16

MONITOR
25
498
191
563
AB#Draw ABC00
c8
17
1
16

MONITOR
24
563
191
628
AB#Draw AABB0
c9
17
1
16

MONITOR
23
628
191
693
AB#Draw AABBC
c10
17
1
16

MONITOR
1187
128
1349
173
#MINOR ini / #MAYOR ini
propini
17
1
11

MONITOR
1187
218
1349
263
#MINOR fin / #MAYOR fin
propfin
17
1
11

MONITOR
802
295
949
340
MinorPartyAB
menorav
17
1
11

MONITOR
956
295
1107
340
Criterio Propor Inicial
propiniab
17
1
11

MONITOR
975
568
1208
613
Num de actualizaciones A = nnodos x #Ciclos
contadorAct
17
1
11

MONITOR
909
569
965
614
# Ciclos
contadorAct / nnodos
17
1
11

SWITCH
942
37
1054
70
repeticion
repeticion
1
1
-1000

MONITOR
802
344
928
389
GreatPartyAB
mayorav
17
1
11

CHOOSER
1067
37
1159
82
netorder
netorder
49 74 99 114 149 199 249 499 999
5

SWITCH
1169
37
1303
70
districtdraw
districtdraw
1
1
-1000

MONITOR
26
10
183
75
1#Draw 00000 )(
c1
17
1
16

MONITOR
25
333
158
398
6#Draw ABCC0
c6
17
1
16

MONITOR
947
620
1006
673
To
contadorActNull / nnodos
17
1
13

MONITOR
817
569
898
614
#Empate AB
contempate-ab
17
1
11

MONITOR
726
621
796
666
#A at To
t0party_1
17
1
11

MONITOR
805
621
866
666
#B at To
t0party_2
17
1
11

MONITOR
875
621
940
666
# C at To
t0party_3
17
1
11

MONITOR
1188
173
1349
218
# MINOR To / # MAYOR To
propt0
17
1
11

TEXTBOX
806
397
987
482
2 = Soft Black -> tparty1\n8 = Gray -> tparty2\nwhite -> tparty3\n0 = Black -> tnull\n
16
14.0
1

SLIDER
802
247
989
280
persons_party4
persons_party4
0
(netorder + 1) * (netorder + 1)
17500.0
1
1
NIL
HORIZONTAL

MONITOR
1016
621
1172
666
Actualizaciones con Indecisos
contadorActNull
17
1
11

@#$#@#$#@
## WHAT IS IT?

This is a opinion dynamics model evolving in a system composed of a finite toroidal lattice network R, three active parties (A,B,C) and a possibly a set of uncommited
inactive voters (0). Parties A,B form the coalition AB. We are under assumption of no external influence into the system.

R is a square lattice network with 50,75,100,....,10000 nodes per side, its boundary conditions embbed R on a torus and can be modified by NetLogo by editing the world. R has orders 2500,5620,...,1000000.

he model goal is to shows and update rule which statistically led profit to the
party with high initial voters.

## HOW IT WORKS

This is a opinion dynamics model evolving in a system composed of a finite toroidal lattice network R, three active parties (A,B,C) and a possibly a set of uncommited
inactive voters (0). Parties A,B form the coalition AB. We are under assumption of no external influence into the system.

R is a square lattice network with 50,75,100,....,10000 nodes per side, its boundary conditions embbed R on a torus and can be modified by NetLogo by editing the world. R has orders 2500,5620,...,1000000.

The model goal is to shows and update rule which statistically led profit to the
party with high initial voters.

## HOW IT WORKS

The model starts by setting the initial conditions: number of coalition nodes (A nodes plus B nodes), third party C nodes, and uncommited nodes O.

Network size can be selected with netorder global variable through selector button by choosing its number of nodes per side among 49 (50x50 nodes), 74 (75x75), 99 (100x100),
114 (115x115) or 149 (150x150), or even network sizes of 499 (500x500) and
999 (1000000). But this model has a slow behaviour setting randomly party opinions
with network sizes greater than 150x150. After selecting netorder variable the world is resized.

The model needs as entries C value (usually fixed to .5#V(R)). C is a value
in [0,1] to indicate the proportion of nodes to be assigned for party C, then we need to indicate A (party A proportion) value having in account that B=C-A thus 0 <= A <= C. Once we have fixed C,A we have B (party B proportion).

With A,B, and C, SETUP procedure determinates persons_party1 = A*#V(R), persons_party2 = B*#V(R), and persons_party3 = C*#V(R).

The repetition scheme can be: with repetition or without, in this case is the selection scheme is WITHOUT REPETITION. In the former it means the model inspect #V(R) nodes per cycle but may repeat nodes (faster option), in the later is inspected exactly #V(R) nodes per cycle (low speed option).

If global variable totaladistribuir is less than V(R) then initialization process distribute a total of V(R)-totaladistribuir null nodes.

It has two main procedures: SETUP and INICIO

SETUP

Setup procedure initialize the world conditions by distributing active agents
into the network, this with an uniform distribution fashion.

Starts computing an order list of patches npixel starting from (patch 0 1)
and finishing with (patch netorder netorder).

SETUP initialize i=j=0 then creates npixel list by set (netorder + 1)^2 = #V(R)
thus an exterior cycle of (netorder + 1) repetitions for j=0,...,99 each
value for j, enters in a cycle of (netorder + 1) repetitions for i=0,...,99 and
fill list npixel with patch i j, i.e:

npixel = [(0 0) (0 1) ... (0 99) (1 0) (1 1) ... (1 99) ... (99 0) (99 1) ... (99 99)]


Using npixel list SETUP distributes randomly voters for A, by repeating persons_party1
times the selection of a random index z for npixel, this is acomplished by
set z random N (with N<-#V(R)), then setting patch at item z npixel its variables party = 1, pcolor = 2, influencia = 1, after that interchange item z npixel with
item N npixel, and decreasing N  to N-1, with this erasing item z npixel,


After initialize A's N has the value N-persons_party1, then applies same mechanism
for B: repeat a cycle of persons_party2 lenght then, select a random index
set z random N, then change its party, pcolo and influence of patch at item z of npixel.
At this point N has value N - pensons_party1 - persons_party2. Finally, by same
way distribute C patches.

Initialize tparty_1,...,tparty3, with the number of patches with color A,B and C
and tparty_4, tparty_5 with the number of 0's and A+B's respectively.

Initialize variables contempate-mr (mayority rule draws) and contempate-ab (coalition draws) to 0.

Initialize actualization variables contadorAct (number of patches supposed to
be inspected) and contadorActNull (number of patches inspected before 0's disappear).

Initialize list P1,P2,P3, negro, blanco, to empty list.
Those list saves the number of A,B,C,O, and A+B patches
after each cycle.

Decides by comparing cardinalities tparty_1 and tparty_2, who is the minor population party, and saves it in menorav, mayorav variables.

Then compute initial proportion in variable propini: minor party / mayorp party,
and propiniab: minor party / (mayor party + minor party).

INICIO

Then INICIO procedure starts the dynamics on nodes, mainly according to MR.
Exists several monitor buttons which helps to the observer to follow
the evolution of the variables constantly.

Initially set N again to #V(R) and recover npixel list through Caux list

It has a cycle of 1400 out of what the model evolution is consider to be a stripe
configuration. Previous to enter one cycle we recover npixel list trough Caux
and set N to #V(R).

In one cycle, the procedure
selects #V(R) (leading repetition) patches one by one, ask to any patche
to count its 4-neighbourhood G. At the beginning of one cycle we select randomly
a number z between 0 and N-1 (N stores nnodos = #V(R)), then select the patch
z in npixel list and examine it and its neighbourhood G.

 Variables sum-color1, sum-color2, sum-color3, sum-color4 stores A's, B´s and C's in G. Since sum-colori with i=1,...,4
not takes in accout patche itself the procedure looks at patche inspected and its
color then depending the case, sum-colori increases by 1.

set sum-colori sum-colori + 1

After 4-neighbourhood inspection, procedure select if changes to G would be needed,
avoiding to modify G composed only by AB's or only by C's (or possibly 0's). It is decided putting the condition:


    if (sum-color3 > 0 and (sum-color1 > 0 or sum-color2 > 0))

if a patche holds above condition then procedure applies a second mayority rule
to G leaving draw cases untouched, and counting in contador-ab the number of
draws encountered on G.


Each time the coalition AB wins we decide the patch color and the 4-neighbour color according to the initial proportion for A,B. Cases with draw are broken by same
trick.


Main dynamic is governed by MR between AB and C,0 on discussion groups.

MR has two cases.

	MR with 0 nodes:

		-This case may lead a MR DRAWS:

			AC000 (c1),
			BC000 (c2)
			AACC0 (c3),
			BBCC0 (c4),
			ABCC0 (c11),
		        00000 (c12).

			These draws are breaked by do nothing.
			To break AC000 we leave AC000, to break ABCC0
			se simply leve ABC00.

		-If AB wins, we have COALITION DRAWS:

			AB000 (c5),
			ABC00 (c6),
			AABB0 (c7).


			This draws are breaked by do nothing.

		-If C wins, all members of discussion group becomes of C type, with its                    party, pcolor, and influence vables updated.

		-If AB wins and G has A's and B's, possibly with 0's , then we leave G                    unchanged.

		-If AB wins with only A's or only B's we no inspect G then we use                          "it do nothing" rule.

		-If AB wins with A's and B's and exist one C or 0 then we proportional
                 random rule by selecting a random number e in (0,1)  then if e <= 	  		A/(A+B) select A, otherwise select B, this is similar to random(A,B), but 		rando(A,B) is a coin toss A and B. With this rule there is no coalition
		draws, and possibly an entire A group can be changed to B group.

	MR without 0 nodes

		This case not leads MR DRAWS, at each time we have a winner between AB 		                and C. But we have COALITION DRAWS:
			AABBC (c8),

		Same rules as case with 0 nodes:

	        -If C wins, all members of discussion group becomes of C type.

		-If AB wins and G has A's and B's then we leave G unchanged.

		-If AB wins with only A's or only B's then we use proportional rule.

		-If AB wins with A's and B's and exist one C or 0 then we again use 		                  proportional rule.

At the end of one cycle procedure INICIO interchanges item z npixel with item N-1 npixel
then reduce N to N - 1, with this no taking in accout patch at item z npixel and the new cycle entrance with:

set z random N

At the final of one cycle we have N=0, then the last selected patch is item 0 npixel.
The selection scheme is WITHOUT REPETITION.

counterAct variable allocates the number of actualizations, T_c = counter1 / 600 is the mumber of cycles.

counterActNull allocates the number of actualizations before 0 nodes dissapear, T_0 = counter2 / 600.

After one cycle of nnodes actualizations we have:

tparty_1 counts A patches [pcolor = 2]
tparty_2 counts B patches [pcolor = 8]
tparty_3 counts C patches [pcolor = white ]
tparty_4 counts 0 patches [pcolor = black]
tparty_5 counts AB patches [pcolor = 8 or pcolor = 2]

Finally fills list P1,P2,P3, blanco, negro with the proportions:
A actual / #V(R), B actual / #V(R), C actual / #V(R), 0 actual / #V(R), A+B actual / #V(R)

At the end, after arrive to 1400 repetitions for stripes of previous consensus, the propfin proportion is stablished

final minorav / final majorav = propfin

## HOW TO USE IT

fixing variables + setup + inicio

## THINGS TO NOTICE

This section could give some ideas of things for the user to notice while running the model.

Note the inclusion of 0's is good for coalition AB and it has more chance to win C.
Prove this fact statistically? or argument this observation, also this phenomenom
is better for minor party than large party in AB.
--> then if exist a large size of 0  in the system under 2mr this is
favoured to minor party from AB and to coalition AB, perhaps due to the
initial distribution.

Size of 0's exhibe a critical point at which large party in AB is favoured.
but AB continues winning over C.


## THINGS TO TRY

This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.

## EXTENDING THE MODEL

This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.

## NETLOGO FEATURES

This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.

## RELATED MODELS

This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.

## CREDITS AND REFERENCES

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="MenorRemplaincinc0.005rep50" repetitions="1000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>inicio</go>
    <metric>totaladistribuir</metric>
    <metric>persons_party1</metric>
    <metric>persons_party2</metric>
    <metric>persons_party3</metric>
    <metric>tparty_1</metric>
    <metric>tparty_2</metric>
    <metric>tparty_3</metric>
    <metric>tparty_4</metric>
    <metric>tparty_5</metric>
    <metric>c2</metric>
    <metric>c3</metric>
    <metric>c4</metric>
    <metric>c5</metric>
    <metric>c6</metric>
    <metric>c7</metric>
    <metric>c8</metric>
    <metric>c9</metric>
    <metric>c10</metric>
    <metric>contempate-mr</metric>
    <metric>contempate-ab</metric>
    <metric>contadorAct</metric>
    <metric>contadorActNull</metric>
    <metric>propiniab</metric>
    <metric>menorav</metric>
    <metric>propt0</metric>
    <metric>propini</metric>
    <metric>propfin</metric>
    <enumeratedValueSet variable="porcentA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="totaladistribuir">
      <value value="40000"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
