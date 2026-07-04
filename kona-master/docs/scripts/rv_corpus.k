/ rv_corpus.k
/ Verifies every derivable number in research/data/psi_corpus.txt and
/ runs the pattern search across its blocks.
/
/ Run:  ./k docs/scripts/rv_corpus.k

say:{`0:x,"\n"}
bz:{[h;n;p] (h-n*p)%_sqrt n*p*1.0-p}
r3:{0.001*_ 0.5+1000.0*x}
ok:{[got;exp;tol] :[tol>_abs got-exp;"OK";"MISMATCH"]}

say "==== corpus verification (derivable values recomputed) ===="
Z1:bz[106.0;329.0;0.25]
Z2:bz[483.0;1498.0;0.25]
ZP:bz[589.0;1827.0;0.25]
ZW:bz[22.0;60.0;0.25]
say "  prl_autoganzfeld   z = ",($r3[Z1]),"  corpus 3.02  ",ok[Z1;3.02;0.02]
say "  storm_db           z = ",($r3[Z2]),"  corpus 6.47  ",ok[Z2;6.47;0.02]
say "  pooled_ganzfeld    z = ",($r3[ZP]),"  corpus 7.15  ",ok[ZP;7.15;0.02]
say "  watt_precog_select z = ",($r3[ZW]),"  (22/60 = 36.7%, one-tail sig) "
Z3:3.99
Z4:7.31
ZV:Z1,Z2,Z3,Z4
S4:(+/ZV)%_sqrt 4.0
say "  stouffer_4db       Z = ",($r3[S4]),"  corpus 10.39  ",ok[S4;10.39;0.02]
/ +MW99 null database enters at its published z = 0.70
ZV5:ZV,0.70
S5:(+/ZV5)%_sqrt 5.0
say "  stouffer_+MW99     Z = ",($r3[S5]),"  corpus 9.61   ",ok[S5;9.61;0.02]
/ +second null database at z = 0
ZV6:ZV5,0.0
S6:(+/ZV6)%_sqrt 6.0
say "  stouffer_+MW+TPP   Z = ",($r3[S6]),"  corpus 8.77   ",ok[S6;8.77;0.02]
/ Rosenthal fail-safe N: ((sum z)^2 / 2.706) - k
SZ:+/ZV
FS:_ 0.5+((SZ*SZ)%2.706)-4.0
say "  failsafe_N         = ",($FS),"        corpus 156    ",ok[1.0*FS;156.0;1.5]
say ""

say "==== pattern: the rate convergence ===="
say "  0.3222  1983-89   (329 sessions)"
say "  0.3224  1997-2008 (1498 sessions)"
say "  0.3224  pooled    (1827 sessions)"
say "  three estimates, two eras, spread 0.0002 around 0.322"
say "  0.3667  selected participants, small n (60) - selection lifts rate"
say ""

say "==== pattern: deprivation drives imagery, imagery is visual ===="
say "  hebb_sensory   14/14 = 1.00 hallucination incidence"
say "  tank_respirator 5/17 = 0.294 full syndrome"
say "  sleep-onset modality: visual 0.90 > somato 0.52 > auditory 0.33"
say "  ganzfeld protocol = mild sensory deprivation + VISUAL target,"
say "  i.e. the psi protocol with the strongest record sits exactly on"
say "  the deprivation condition with the highest imagery incidence"
say ""

say "==== pattern: the conducive window, all corpus blocks stacked ===="
say "  state    : theta entrainment 4-4.5 Hz (gateway_math.k)"
say "  protocol : homogenous field + visual report (ganzfeld block)"
say "  geomag   : quiet field < 10 nT; > 25 nT kills (Persinger block)"
say "  clock    : 13.47h LST +/- 1h (Spottiswoode; sky-referenced timing)"
say "  onset    : 24h stage-1 distortion threshold marks state boundary"
say ""

say "==== sample sizes the corpus effect sets for a live run ===="
/ n for expected z = sig at true rate p1 vs chance p0
need:{[p0;p1;sig] d:p1-p0;_ 0.5+sig*sig*p0*(1.0-p0)%d*d}
say "  at the recorded 0.322 vs 0.25:"
say "  3 sigma: ",($need[0.25;0.322;3.0])," sessions"
say "  5 sigma: ",($need[0.25;0.322;5.0])," sessions"
say "  at selected-participant 0.3667:"
say "  5 sigma: ",($need[0.25;0.3667;5.0])," sessions"
\\
