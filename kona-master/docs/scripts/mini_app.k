/ mini_app.k
/ usage: \l mini_app.k ; run[] ; runn[64] ; demo[]

nrand:{[n;m](_draw[n;m])-m%2}
stt:{[x]x:x*1.0;m:(+/x)%#x;v:(+/((x-m)*(x-m)))%#x;.((`n;#x;);(`sum;+/x;);(`mean;m;);(`std;_sqrt v;);(`min;*(x@<x););(`max;*(x@>x););(`l2;_sqrt +/(x*x);))}
sgn:{[x]m:(+/x)%#x;z:(x-m)%(_sqrt((+/((x-m)*(x-m)))%#x));g:>x;l:<x;.((`top5;x@5#g;);(`bot5;x@5#l;);(`sorted;x@l;);(`z;z;))}
app:{[n]v:nrand[n;100];s:stt[v];g:sgn[v];.((`vec;v;);(`stats;s;);(`signal;g;);(`brief;(s@`mean;s@`std;s@`l2);))}
run:{app[32]}
runn:{[x]app[x]}
demo:{r:app[16];g:r@`signal;(r@`brief;g@`top5;g@`bot5)}

`0:"mini_app loaded: run[] | runn[64] | demo[]"
