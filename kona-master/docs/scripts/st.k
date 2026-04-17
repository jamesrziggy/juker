\l json.k
stf: "/home/james/.cache/huggingface/hub/models--Jackedupbruh--PruneHeal-13M/blobs/235bb7f923a39f76e41a20914369d21c181b3a7ea6a24d9febacaf89cae8d7aa"

/ read N floats from safetensors — for large layers, sample every Sth float
rdf: {cmd: "od -A n -t f4 -j ",($x)," -N ",($4*y)," ",stf; raw: ,/`4:cmd; nums: " "\ raw; r: !0; i: 0; n: #nums; while[i<n; v: nums[i]; :[2<#v; r: r,.(v); 0]; i: i+1]; y#r}

/ read with sampling for large layers — read at most 2000 floats
rdfs: {:[y<2001; rdf[x;y]; rdf[x;2000]]}

/ stats on a float vector
mean: {(+/x)%#x}
std: {m: mean x; _sqrt (+/(x-m)*(x-m))%#x}
sprs: {(+/({(0.01)>x*:[x>0;1;-1]}'x))%#x}

`0: "=== PruneHeal-13M — Kona reads safetensors directly ==="
`0: ""

/ Read the layer index
idx: 0:`"/tmp/st_index.txt"
`0: "Layers: ",($#idx)
`0: ""

/ Parse and analyze each layer (sample 2000 floats max)
i: 0
while[i<#idx;
 parts: "|"\(idx[i])
 nm: parts[0]
 off: .(parts[1])
 nf: .(parts[3])
 w: rdfs[off;nf]
 `0: nm
 `0: "  shape: ",($nf)," | mean: ",($mean w)," | std: ",($std w)," | sparse: ",($sprs w)
 i: i+1]

`0: ""
`0: "=== Cosine similarity: Q vs K layer 0 ==="
q: rdfs[39194024;36864]
k: rdfs[39341480;36864]
`0: "  cos(Q,K): ",($ (_dot[q;k]) % (_sqrt _dot[q;q]) * _sqrt _dot[k;k])
`0: ""
`0: "=== All math computed in Kona ==="
