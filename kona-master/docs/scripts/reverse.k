/ reverse engineer PruneHeal-13M — kona only
/ read raw weights, find structure, see what the model learned
stf: "/home/james/.cache/huggingface/hub/models--Jackedupbruh--PruneHeal-13M/blobs/235bb7f923a39f76e41a20914369d21c181b3a7ea6a24d9febacaf89cae8d7aa"
rf: {`4:"od -A n -t f4 -j ",($x)," -N ",($4*y)," ",stf}
rd: {raw: ,/rf[x;y]; nums: " "\ raw; r: !0; i: 0; while[i<#nums; v: nums[i]; :[2<#v; r: r,.(v); 0]; i: i+1]; y#r}

`0: "=== PruneHeal-13M reverse engineering ==="
`0: ""

/ layer norm weights tell us what dimensions matter
`0: "--- LAYER NORMS (what dimensions the model amplifies) ---"
ln0: rd[38603432;192]
ln1: rd[38997928;192]
ln2: rd[39392424;192]
ln3: rd[39786920;192]
ln4: rd[40181416;192]
ln5: rd[40575912;192]
fnorm: rd[40970408;192]
`0: "layer 0 norm: min:",($ln0[*<ln0])," max:",($ln0[*>ln0])," mean:",($(+/ln0)%192)
`0: "layer 5 norm: min:",($ln5[*<ln5])," max:",($ln5[*>ln5])," mean:",($(+/ln5)%192)
`0: "final norm:   min:",($fnorm[*<fnorm])," max:",($fnorm[*>fnorm])," mean:",($(+/fnorm)%192)
`0: ""

/ which dimensions does the final norm amplify most?
`0: "--- TOP 10 AMPLIFIED DIMENSIONS (final norm) ---"
top: (10#>fnorm)
i: 0; while[i<10; `0: "  dim ",($top[i]),": ",($ fnorm[top[i]]); i: i+1]
`0: ""

/ which dimensions are suppressed?
`0: "--- TOP 10 SUPPRESSED DIMENSIONS (final norm) ---"
bot: (10#<fnorm)
i: 0; while[i<10; `0: "  dim ",($bot[i]),": ",($ fnorm[bot[i]]); i: i+1]
`0: ""

/ layer norm progression — does the model scale up over depth?
`0: "--- NORM PROGRESSION ACROSS LAYERS ---"
`0: "  L0: ",($(+/ln0)%192)
`0: "  L1: ",($(+/ln1)%192)
`0: "  L2: ",($(+/ln2)%192)
`0: "  L3: ",($(+/ln3)%192)
`0: "  L4: ",($(+/ln4)%192)
`0: "  L5: ",($(+/ln5)%192)
`0: "  FN: ",($(+/fnorm)%192)
`0: ""

/ attention: Q and K similarity per layer — are they learning different things?
`0: "--- Q vs K COSINE SIMILARITY PER LAYER ---"
csim: {a: rd[x;2000]; b: rd[y;2000]; (_dot[a;b]) % (_sqrt _dot[a;a]) * _sqrt _dot[b;b]}
`0: "  L0: ",($ csim[39194024;39341480])
`0: "  L1: ",($ csim[39588520;39735976])
`0: "  L2: ",($ csim[39983016;40130472])
`0: "  L3: ",($ csim[40377512;40524968])
`0: "  L4: ",($ csim[40772008;40919464])
`0: "  L5: ",($ csim[41166504;41313960])
`0: ""

/ attention: Q vs V — should be very different
`0: "--- Q vs V COSINE SIMILARITY PER LAYER ---"
`0: "  L0: ",($ csim[39194024;39488936])
`0: "  L5: ",($ csim[41166504;41461416])
`0: ""

/ O projection sparsity — how much does each layer output?
`0: "--- O PROJECTION ENERGY PER LAYER ---"
oe: {a: rd[x;2000]; _sqrt (+/a*a) % 2000}
`0: "  L0: ",($ oe[39394504])
`0: "  L1: ",($ oe[39789000])
`0: "  L2: ",($ oe[40183496])
`0: "  L3: ",($ oe[40577992])
`0: "  L4: ",($ oe[40972488])
`0: "  L5: ",($ oe[41366984])
`0: ""

/ MLP gate vs up — are they correlated?
`0: "--- MLP GATE vs UP CORRELATION PER LAYER ---"
`0: "  L0: ",($ csim[39187968;39335424])
`0: "  L5: ",($ csim[41160448;41307904])
`0: ""

`0: "=== REVERSE ENGINEERING COMPLETE ==="
