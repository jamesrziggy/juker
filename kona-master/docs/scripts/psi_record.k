/ psi_record.k
/ The recorded psyonics experimental record, run through the math.
/ Raw counts are taken from the field's published databases; where a
/ database publishes only its final statistic, that statistic is used
/ as-is and marked. Sources in research/KEYS_ASTROLOGY_PSYONICS.md.
/
/ Run:  ./k docs/scripts/psi_record.k

say:{`0:x,"\n"}

/ binomial z from hits h, trials n, chance rate p
bz:{[h;n;p] (h-n*p)%_sqrt n*p*1.0-p}
rate:{[h;n] (100.0*h)%n}

say "==== the recorded record, computed from published counts ===="
say ""
H1:106.0
N1:329.0
Z1:bz[H1;N1;0.25]
say "PRL autoganzfeld 1983-89 (Bem & Honorton 1994)"
say "  ",($H1)," hits / ",($N1)," sessions, chance 25%"
say "  hit rate ",($rate[H1;N1]),"%   z = ",$Z1
say ""
H2:483.0
N2:1498.0
Z2:bz[H2;N2;0.25]
say "Ganzfeld studies 1997-2008 (Storm, Tressoldi & Di Risio 2010)"
say "  ",($H2)," hits / ",($N2)," sessions, chance 25%"
say "  hit rate ",($rate[H2;N2]),"%   z = ",($Z2)," (published: 6.44)"
say ""
Z3:3.99
say "PEAR benchmark REG 1979-1991, 2.5e6 trials, 91 operators"
say "  published z = ",($Z3)," (hi-lo intention split)"
say ""
Z4:7.31
say "Global Consciousness Project formal series, 500 events, 17 years"
say "  published Stouffer Z = ",$Z4
say ""

/ Stouffer combination across the four independent databases
ZALL:(Z1+Z2+Z3+Z4)%_sqrt 4.0
say "==== combined ===="
say "  Stouffer Z across the four databases = ",$ZALL
say "  (5-sigma threshold = 5.0; each database is an independent"
say "   study population; ganzfeld sets share no studies)"
\\
