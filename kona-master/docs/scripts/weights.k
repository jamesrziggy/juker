\l json.k
cr: (_ci 13),(_ci 10)
sq: ,_ci 39

/ load weight data extracted from PruneHeal-13M
raw: ,/0:`"/tmp/pruneheal_weights.json"

/ serve the raw JSON on /data endpoint
dataep: {"HTTP/1.0 200 OK",cr,"Content-Type: application/json",cr,"Content-Length: ",($#raw),cr,"Connection: close",cr,cr,raw}

/ CSS
css: "body{background:#0a0a0a;color:#e0e0e0;font-family:monospace;margin:0;padding:20px}h1{color:#00ff88;font-size:22px}h2{color:#00aaff;font-size:13px;text-transform:uppercase;letter-spacing:2px;margin:20px 0 10px}.info{color:#888;font-size:12px;margin-bottom:20px}.cards{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:12px}.card{background:#1a1a1a;border:1px solid #333;border-radius:8px;padding:14px;cursor:pointer;transition:border-color .2s}.card:hover{border-color:#00ff88}.card .n{color:#00aaff;font-size:11px;word-break:break-all}.card .st{color:#00ff88;font-size:20px;font-weight:bold;margin:6px 0}.card .d{color:#666;font-size:10px}.bar{display:flex;gap:1px;align-items:end;height:50px;margin-top:8px}.bar div{background:#00ff88;flex:1;border-radius:1px 1px 0 0;min-width:1px;transition:background .2s}.bar div:hover{background:#00aaff}#detail{background:#111;border:1px solid #00aaff;border-radius:8px;padding:20px;margin:20px 0;display:none}.big-bar{display:flex;gap:1px;align-items:end;height:120px;margin:12px 0}.big-bar div{background:#00ff88;flex:1;border-radius:2px 2px 0 0;min-width:2px}.sp{display:inline-block;width:8px;height:8px;border-radius:50%;margin-right:6px}.tabs{display:flex;gap:8px;margin:16px 0}.tab{background:#222;border:1px solid #444;padding:6px 14px;border-radius:4px;cursor:pointer;font-family:monospace;color:#aaa;font-size:12px}.tab.active{border-color:#00ff88;color:#00ff88}"

/ JavaScript
js: "var D,sel=-1;fetch(",sq,"/data",sq,").then(r=>r.json()).then(d=>{D=d;document.getElementById(",sq,"title",sq,").textContent=d.meta.name+",sq," Weight Explorer",sq,";document.getElementById(",sq,"info",sq,").innerHTML=",sq,"<b>",sq,"+d.meta.params.toLocaleString()+",sq," params</b> | hidden: ",sq,"+d.meta.hidden+",sq," | heads: ",sq,"+d.meta.heads+",sq," | layers: ",sq,"+d.meta.depth+",sq," | vocab: ",sq,"+d.meta.vocab.toLocaleString();renderCards(d.layers)});function renderCards(L){var c=document.getElementById(",sq,"cards",sq,");c.innerHTML=",sq,sq,";L.forEach(function(l,i){var d=document.createElement(",sq,"div",sq,");d.className=",sq,"card",sq,";var mx=Math.max.apply(null,l.hist)||1;var bars=",sq,"<div class=bar>",sq,";l.hist.forEach(function(v){bars+=",sq,"<div style=height:",sq,"+Math.max(1,v/mx*48)+",sq,"px></div>",sq,"});bars+=",sq,"</div>",sq,";var sp=l.sparsity;var spc=sp>0.5?",sq,"#ff4444",sq,":sp>0.2?",sq,"#ffaa00",sq,":",sq,"#00ff88",sq,";d.innerHTML=",sq,"<div class=n>",sq,"+l.name+",sq,"</div><div class=st>",sq,"+l.shape.join(",sq,"x",sq,")+",sq,"</div><div class=d>",sq,"+l.params.toLocaleString()+",sq," params | std: ",sq,"+l.std.toFixed(4)+",sq," | <span class=sp style=background:",sq,"+spc+",sq,"></span>",sq,"+Math.round(sp*100)+",sq,"% sparse</div>",sq,"+bars;d.onclick=function(){showDetail(i)};c.appendChild(d)})}function showDetail(i){sel=i;var l=D.layers[i];var el=document.getElementById(",sq,"detail",sq,");el.style.display=",sq,"block",sq,";var mx=Math.max.apply(null,l.hist)||1;var bars=",sq,"<div class=big-bar>",sq,";l.hist.forEach(function(v){bars+=",sq,"<div style=height:",sq,"+Math.max(1,v/mx*110)+",sq,"px title=",sq,"+v+",sq,"></div>",sq,"});bars+=",sq,"</div>",sq,";el.innerHTML=",sq,"<h2>",sq,"+l.name+",sq,"</h2><div class=info>Shape: ",sq,"+l.shape.join(",sq,"x",sq,")+",sq," | Params: ",sq,"+l.params.toLocaleString()+",sq,"</div><div class=cards style=grid-template-columns:repeat(6,1fr)><div class=card><div class=n>Mean</div><div class=st>",sq,"+l.mean.toFixed(6)+",sq,"</div></div><div class=card><div class=n>Std Dev</div><div class=st>",sq,"+l.std.toFixed(6)+",sq,"</div></div><div class=card><div class=n>Min</div><div class=st>",sq,"+l.min.toFixed(4)+",sq,"</div></div><div class=card><div class=n>Max</div><div class=st>",sq,"+l.max.toFixed(4)+",sq,"</div></div><div class=card><div class=n>L2 Norm</div><div class=st>",sq,"+l.l2.toFixed(2)+",sq,"</div></div><div class=card><div class=n>Sparsity</div><div class=st>",sq,"+Math.round(l.sparsity*100)+",sq,"%</div></div></div>",sq,"+bars+",sq,"<div class=info>Weight distribution (50 bins from min to max)</div>",sq,"}"

/ HTML body
bd: "<div id=detail></div><h2>All Layers</h2><div class=cards id=cards>loading...</div>"

/ page
page: {b: "<!DOCTYPE html><html><head><meta charset=utf-8><title>PruneHeal</title><style>",css,"</style></head><body><h1 id=title>loading...</h1><div class=info id=info></div>",bd,"<script>",js,"</script></body></html>"; "HTTP/1.0 200 OK",cr,"Content-Type: text/html",cr,"Content-Length: ",($#b),cr,"Connection: close",cr,cr,b}

/ router
.m.h: {:[4<#x; :[("d"=x[5])&("a"=x[6])&("t"=x[7])&("a"=x[8]); dataep[]; page[]]; page[]]}

`0: "PruneHeal-13M weight explorer: http://localhost:9090"
