/ kona trainer — fixed: no ::, shapes stay clean
vs: 90; hs: 16; lr: 0.001
w1: (vs;hs)#((_draw[vs*hs;200])%100.0)-1.0; w1: w1%_sqrt vs
w2: (hs;vs)#((_draw[hs*vs;200])%100.0)-1.0; w2: w2%_sqrt hs
raw: 1:`"/tmp/train_seqs"; seqs: (50;64)#raw
oh: {r:vs#0.0;r[x]:1.0;,r}
smax: {e:_exp x-x[*>x];e%+/e}
`0: "training 90->16->90"
ep: 0
while[ep<50;
 s: seqs[ep%50]; tl: 0.0; j: 0
 while[j<60;
  x: oh s[j]; h: (_mul[x;w1])*_mul[x;w1]>0
  o: *_mul[h;w2]; p: smax o
  g: ,p; g[0;s[j+1]]: g[0;s[j+1]]-1
  w2: w2 - lr * _mul[+h;g]
  dh: (_mul[g;+w2]) * h > 0
  w1: w1 - lr * _mul[+x;dh]
  tl: tl - _log 0.0001 + p[s[j+1]]
  j: j+1]
 :[0=5!ep; `0: ($ep)," loss:",($ tl%60); 0]
 ep: ep+1]
p: smax *_mul[(_mul[oh seqs[0;0];w1])*_mul[oh seqs[0;0];w1]>0;w2]
`0: "pred:",(,_ci 32+*>p)," want:",(,_ci 32+seqs[0;1])
`0: "done"
