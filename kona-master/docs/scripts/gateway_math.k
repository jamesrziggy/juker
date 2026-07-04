/ gateway_math.k
/ The numerical protocols inside the traditions covered in
/ research/PSYONICS_RND.md, computed in K:
/   1. Hemi-Sync binaural beat differentials -> brainwave band
/   2. Shamanic drum tempo -> entrainment frequency
/   3. Key of Solomon planetary hours: 24 unequal hours + Chaldean rulers
/
/ Run:  ./k docs/scripts/gateway_math.k

say:{`0:x,"\n"}
mod:{x-y*_ x%y}

/ ---- 1. binaural beats: brain hears |fL - fR| ----
band:{:[x<4.0;"delta";:[x<8.0;"theta";:[x<13.0;"alpha";"beta"]]]}
FL:100.0 200.0 400.0 495.0
FR:104.0 207.0 410.0 495.5
say "==== Hemi-Sync binaural differentials ===="
beat:{[i] d:_abs FL[i]-FR[i]
 say "  L ",($FL[i])," Hz | R ",($FR[i])," Hz -> beat ",($d)," Hz (",(band[d]),")"}
r0:beat'!#FL

/ ---- 2. drum tempo entrainment ----
say ""
say "==== drum tempo -> entrainment frequency ===="
BPM:220.0 240.0 270.0
drum:{[i] hz:BPM[i]%60.0
 say "  ",($BPM[i])," bpm -> ",($hz)," Hz (",(band[hz]),")"}
r1:drum'!#BPM
say "  Maxfield 1990: 4-4.5 beats/sec (theta) increased theta EEG + trance reports"

/ ---- 3. planetary hours (Key of Solomon timing system) ----
/ Day = sunrise..sunset split in 12; night = sunset..next sunrise in 12.
/ Rulers step through the Chaldean order from the weekday ruler.
CHALD:("Saturn ";"Jupiter";"Mars   ";"Sun    ";"Venus  ";"Mercury";"Moon   ")
/ weekday ruler index into CHALD: Sun Mon Tue Wed Thu Fri Sat
WDIX:3 6 2 5 1 4 0
WDN:("Sunday";"Monday";"Tuesday";"Wednesday";"Thursday";"Friday";"Saturday")

/ example: a Sunday with sunrise 05:52 and sunset 20:35 (long summer day)
WD:0
SR:352.0
SS:1235.0
DHL:(SS-SR)%12.0
NHL:((1440.0+SR)-SS)%12.0

pad:{:[x<10;"0",$x;$x]}
hhmm:{m:_ 0.5+mod[x;1440.0];(pad[_ m%60]),":",pad[mod[m;60]]}

say ""
say "==== planetary hours: ",(WDN[WD]),", sunrise ",(hhmm[SR]),", sunset ",(hhmm[SS])," ===="
say "  day-hour length ",($DHL)," min; night-hour length ",($NHL)," min"
hr:{[h] st: :[h<12;SR+DHL*h;SS+NHL*h-12]
 say "  hour ",(pad[1+h])," ",(:[h<12;"day  ";"night"])," ",(hhmm[st]),"  ",CHALD[mod[WDIX[WD]+h;7]]}
r2:hr'!24

/ 24 = 3*7+3, so each dawn the ruler advances 3 places in the Chaldean
/ order: sampling it every 3rd element yields Sun,Moon,Mars,Mercury,
/ Jupiter,Venus,Saturn - the weekday cycle itself.
say ""
say "==== why the week is in that order ===="
say "  Chaldean order every 3rd element (24 mod 7 = 3):"
say "  ",,/CHALD[mod[WDIX[0]+3*!7;7]]," <- the seven weekdays"
\\
