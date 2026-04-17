\l json.k

/ state
cnt: 0
hist: ,0
sq: ,_ci 39
cr: (_ci 13),(_ci 10)

/ helpers
resp: {[ct;b] "HTTP/1.0 200 OK",cr,"Content-Type: ",ct,cr,"Content-Length: ",($#b),cr,"Connection: close",cr,cr,b}
jres: {[d] b:jobj d; resp["application/json";b]}

snap: {
  h: hist*1.0;
  r: .();
  r[`count]: cnt;
  r[`n]: #hist;
  r[`last]: *|hist;
  r[`mean]: (+/h)%#h;
  r[`min]: *hist@<hist;
  r[`max]: *hist@>hist;
  r[`hist]: hist;
  r
 }

api: {jres snap[]}
inc: {cnt::cnt+1; hist::hist,cnt; api[]}
dec: {cnt::cnt-1; hist::hist,cnt; api[]}
jog: {s:(*_draw[1;11])-5; cnt::cnt+s; hist::hist,cnt; api[]}
rst: {cnt::0; hist::,0; api[]}

css: "*{margin:0;padding:0;box-sizing:border-box}body{font-family:monospace;background:#0c1117;color:#d4e0ee;padding:24px}h1{color:#6ee7ff;margin-bottom:16px}.row{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px}button{background:#6ee7ff;color:#071017;border:0;border-radius:6px;padding:8px 12px;cursor:pointer;font-weight:bold}button:hover{filter:brightness(1.08)}.card{background:#131b24;border:1px solid #263445;border-radius:8px;padding:14px;max-width:760px}.m{display:grid;grid-template-columns:repeat(5,minmax(80px,1fr));gap:10px;margin-bottom:12px}.k{color:#8aa0b8;font-size:12px}.v{font-size:20px;color:#b8ff9a}.h{font-size:12px;color:#93a8be;line-height:1.35;word-break:break-word}"

bd: "<div class=row><button id=inc>+1</button><button id=dec>-1</button><button id=jog>jog</button><button id=reset>reset</button><button id=refresh>refresh</button></div><div class=card><div class=m><div><div class=k>count</div><div class=v id=count>0</div></div><div><div class=k>mean</div><div class=v id=mean>0</div></div><div><div class=k>min</div><div class=v id=min>0</div></div><div><div class=k>max</div><div class=v id=max>0</div></div><div><div class=k>last</div><div class=v id=last>0</div></div></div><div class=h id=hist>0</div></div>"

js: "function draw(d){document.getElementById(",sq,"count",sq,").textContent=d.count;document.getElementById(",sq,"mean",sq,").textContent=d.mean.toFixed(2);document.getElementById(",sq,"min",sq,").textContent=d.min;document.getElementById(",sq,"max",sq,").textContent=d.max;document.getElementById(",sq,"last",sq,").textContent=d.last;document.getElementById(",sq,"hist",sq,").textContent=d.hist.join(",sq,", ",sq,")}function hit(p){fetch(p).then(function(r){return r.json()}).then(draw)}document.getElementById(",sq,"inc",sq,").onclick=function(){hit(",sq,"/inc",sq,")};document.getElementById(",sq,"dec",sq,").onclick=function(){hit(",sq,"/dec",sq,")};document.getElementById(",sq,"jog",sq,").onclick=function(){hit(",sq,"/jog",sq,")};document.getElementById(",sq,"reset",sq,").onclick=function(){hit(",sq,"/reset",sq,")};document.getElementById(",sq,"refresh",sq,").onclick=function(){hit(",sq,"/api",sq,")};hit(",sq,"/api",sq,");"

page: {
  b: "<!DOCTYPE html><html><head><meta charset=utf-8><title>Kona Counter</title><style>",css,"</style></head><body><h1>kona counter api</h1>",bd,"<script>",js,"</script></body></html>";
  resp["text/html";b]
 }

/ router from raw request line bytes
route: {[x]
  :[4<#x;
      :[("a"=x[5])&("p"=x[6])&("i"=x[7]); api[];
        ("i"=x[5]); inc[];
        ("d"=x[5]); dec[];
        ("j"=x[5]); jog[];
        ("r"=x[5]); rst[];
        page[]];
      page[]]
 }

.m.h: {[x] route x}

`0: "kona counter app: listening"
