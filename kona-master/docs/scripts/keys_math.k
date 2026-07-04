/ keys_math.k
/ Computes the mathematics extracted in research/KEYS_ASTROLOGY_PSYONICS.md:
/   1. zodiac partitions indexing the spirit catalogs of the Keys
/   2. aspect angles as divisors of the circle
/   3. kamea (planetary magic square) constants
/   4. gematria checksums: intelligence/spirit names vs kamea sums
/
/ Run:  ./k docs/scripts/keys_math.k

say:{`0:x,"\n"}

/ ---- 1. circle partitions = the Keys' catalog sizes ----
say "==== zodiac partitions -> spirit catalog sizes ===="
ARC:30 10 5
LBL:("signs    ";"decans   ";"quinances")
CAT:("(12 signs)";"(36 decan-spirits, Testament of Solomon)";"(72 Goetia spirits / 72 Shem angels)")
p:{[i] say "  360 % ",($ARC[i])," = ",($360%ARC[i]),"  ",LBL[i]," ",CAT[i]}
r0:p'!3
say "  sum 1..36 = ",($+/1+!36),"  (= Sun kamea total = Sorath)"

/ ---- 2. aspects: divisor angles of the circle ----
say ""
say "==== aspect angles = 360/n ===="
DIV:2 3 4 6
ANM:("opposition";"trine     ";"square    ";"sextile   ")
a:{[i] say "  360 % ",($DIV[i])," = ",($360%DIV[i]),"   ",ANM[i]}
r1:a'!4

/ ---- 3. kamea constants: n, cells n^2, row n(n^2+1)/2, total n^2(n^2+1)/2 ----
say ""
say "==== planetary square constants ===="
PL:("Saturn ";"Jupiter";"Mars   ";"Sun    ";"Venus  ";"Mercury";"Moon   ")
N:3+!7
ROW:{_ 0.5*x*1+x*x}
TOT:{_ 0.5*x*x*(1+x*x)*1.0}
k:{[i] n:N[i]
 say "  ",PL[i]," n=",($n)," cells=",($n*n)," row=",($ROW[n])," total=",($TOT[n])}
r2:k'!7

/ ---- 4. gematria checksums of the intelligence/spirit names ----
say ""
say "==== name gematria vs square constants ===="
NM:("Agiel   Saturn  int ";"Zazel   Saturn  spr ";"Iophiel Jupiter int ")
NM:NM,("Hismael Jupiter spr ";"Graphiel Mars   int ";"Bartzabel Mars  spr ")
NM:NM,("Nachiel Sun     int ";"Sorath  Sun     spr ";"Hagiel  Venus   int ")
NM:NM,("Kedemel Venus   spr ";"Tiriel  Mercury int ";"Taphthartharath spr ")
NM:NM,,"Chashmodai Moon spr "
GV:(1 3 10 1 30; 7 1 7 30; 10 5 80 10 1 30)
GV:GV,(5 60 40 1 30; 3 200 1 80 10 1 30; 2 200 90 2 1 30)
GV:GV,(50 20 10 1 30; 60 6 200 400; 5 3 10 1 30)
GV:GV,(100 4 40 1 30; 9 10 200 10 1 30; 400 80 400 200 400 200 400)
GV:GV,,8 300 40 6 4 1 10
/ expected value and which constant it matches
EXP:45 45 136 136 325 325 111 666 49 175 260 2080 369
WHAT:("total";"total";"total";"total";"total";"total";"row  ";"total")
WHAT:WHAT,("cells";"row  ";"row  ";"total";"row  ")
c:{[i] s:+/GV[i]
 say "  ",NM[i]," sum=",($s)," = ",WHAT[i]," ",:[s=EXP[i];"OK";"MISMATCH vs ",$EXP[i]]}
r3:c'!13

/ ---- weekday generator (also derived in gateway_math.k) ----
say ""
say "==== 24 mod 7 = ",($24-7*_ 24%7),": Chaldean order every 3rd = weekday order ===="
mod:{x-y*_ x%y}
say "  ",,/PL[mod[3+3*!7;7]]
\\
