import{s as it,d as o,a as ye,i as E,b as m,c as f,e as M,h as st,f as T,g as Pe,j as ae,k as C,l as Ve,m as H,n as N,t as O,o as Ke,p as ot,q as ut,r as dt,u as Et,v as We}from"../chunks/scheduler.6nJNm0Ol.js";import{S as ct,i as mt,d as V,t as S,a as p,c as Oe,m as j,b as J,e as Q,g as Le}from"../chunks/index.C7HvIm27.js";import{D as ft,e as pt,s as vt,Q as ke,p as gt,C as Be,a as ze,r as Ze,b as yt}from"../chunks/VennDiagram.svelte_svelte_type_style_lang.Bf9m9kvz.js";import{w as bt}from"../chunks/entry.DQnNO6Bx.js";import{h as te,p as Rt}from"../chunks/setTrackProxy.DjIbdjlZ.js";import{p as St}from"../chunks/stores.C2PlGdeW.js";import{B as Ge,Q as Fe}from"../chunks/BigValue.CixT59YN.js";import{L as Tt}from"../chunks/LineChart.BslJsKan.js";function Nt(s){let a,r=L.title+"",e;return{c(){a=N("h1"),e=O(r),this.h()},l(l){a=T(l,"H1",{class:!0});var i=ae(a);e=C(i,r),i.forEach(o),this.h()},h(){f(a,"class","title")},m(l,i){E(l,a,i),m(a,e)},p:We,d(l){l&&o(a)}}}function ht(s){return{c(){this.h()},l(a){this.h()},h(){document.title="Evidence"},m:We,p:We,d:We}}function Mt(s){let a,r,e,l,i;return document.title=a=L.title,{c(){r=H(),e=N("meta"),l=H(),i=N("meta"),this.h()},l(n){r=M(n),e=T(n,"META",{property:!0,content:!0}),l=M(n),i=T(n,"META",{name:!0,content:!0}),this.h()},h(){var n,u;f(e,"property","og:title"),f(e,"content",((n=L.og)==null?void 0:n.title)??L.title),f(i,"name","twitter:title"),f(i,"content",((u=L.og)==null?void 0:u.title)??L.title)},m(n,u){E(n,r,u),E(n,e,u),E(n,l,u),E(n,i,u)},p(n,u){u&0&&a!==(a=L.title)&&(document.title=a)},d(n){n&&(o(r),o(e),o(l),o(i))}}}function Ht(s){var i,n;let a,r,e=(L.description||((i=L.og)==null?void 0:i.description))&&At(),l=((n=L.og)==null?void 0:n.image)&&Ct();return{c(){e&&e.c(),a=H(),l&&l.c(),r=Pe()},l(u){e&&e.l(u),a=M(u),l&&l.l(u),r=Pe()},m(u,v){e&&e.m(u,v),E(u,a,v),l&&l.m(u,v),E(u,r,v)},p(u,v){var d,b;(L.description||(d=L.og)!=null&&d.description)&&e.p(u,v),(b=L.og)!=null&&b.image&&l.p(u,v)},d(u){u&&(o(a),o(r)),e&&e.d(u),l&&l.d(u)}}}function At(s){let a,r,e,l,i;return{c(){a=N("meta"),r=H(),e=N("meta"),l=H(),i=N("meta"),this.h()},l(n){a=T(n,"META",{name:!0,content:!0}),r=M(n),e=T(n,"META",{property:!0,content:!0}),l=M(n),i=T(n,"META",{name:!0,content:!0}),this.h()},h(){var n,u,v;f(a,"name","description"),f(a,"content",L.description??((n=L.og)==null?void 0:n.description)),f(e,"property","og:description"),f(e,"content",((u=L.og)==null?void 0:u.description)??L.description),f(i,"name","twitter:description"),f(i,"content",((v=L.og)==null?void 0:v.description)??L.description)},m(n,u){E(n,a,u),E(n,r,u),E(n,e,u),E(n,l,u),E(n,i,u)},p:We,d(n){n&&(o(a),o(r),o(e),o(l),o(i))}}}function Ct(s){let a,r,e;return{c(){a=N("meta"),r=H(),e=N("meta"),this.h()},l(l){a=T(l,"META",{property:!0,content:!0}),r=M(l),e=T(l,"META",{name:!0,content:!0}),this.h()},h(){var l,i;f(a,"property","og:image"),f(a,"content",ze((l=L.og)==null?void 0:l.image)),f(e,"name","twitter:image"),f(e,"content",ze((i=L.og)==null?void 0:i.image))},m(l,i){E(l,a,i),E(l,r,i),E(l,e,i)},p:We,d(l){l&&(o(a),o(r),o(e))}}}function xe(s){let a,r;return a=new Fe({props:{queryID:"last_date",queryResult:s[0]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&1&&(i.queryResult=e[0]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function et(s){let a,r;return a=new Fe({props:{queryID:"today_summary",queryResult:s[1]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&2&&(i.queryResult=e[1]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function tt(s){let a,r;return a=new Fe({props:{queryID:"pct_change",queryResult:s[2]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&4&&(i.queryResult=e[2]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function at(s){let a,r;return a=new Fe({props:{queryID:"best_branch",queryResult:s[3]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&8&&(i.queryResult=e[3]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function rt(s){let a,r;return a=new Fe({props:{queryID:"top_menu_today",queryResult:s[4]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&16&&(i.queryResult=e[4]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function nt(s){let a,r;return a=new Fe({props:{queryID:"declining_branches",queryResult:s[5]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&32&&(i.queryResult=e[5]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function Ot(s){let a,r,e,l="Halo Owner!",i,n,u=s[3][0].branch_name+"",v,d,b,g=s[4][0].menu_name+"",h,k;return{c(){a=N("p"),r=O("👋 "),e=N("strong"),e.textContent=l,i=O(" Performa kemarin terjaga stabil. Cabang terbaik adalah "),n=N("strong"),v=O(u),d=O(". Menu terlaris kemarin adalah "),b=N("strong"),h=O(g),k=O(". Detail lengkap ada di halaman masing-masing."),this.h()},l(D){a=T(D,"P",{class:!0});var R=ae(a);r=C(R,"👋 "),e=T(R,"STRONG",{class:!0,"data-svelte-h":!0}),Ve(e)!=="svelte-1oivry4"&&(e.textContent=l),i=C(R," Performa kemarin terjaga stabil. Cabang terbaik adalah "),n=T(R,"STRONG",{class:!0});var $=ae(n);v=C($,u),$.forEach(o),d=C(R,". Menu terlaris kemarin adalah "),b=T(R,"STRONG",{class:!0});var X=ae(b);h=C(X,g),X.forEach(o),k=C(R,". Detail lengkap ada di halaman masing-masing."),R.forEach(o),this.h()},h(){f(e,"class","markdown"),f(n,"class","markdown"),f(b,"class","markdown"),f(a,"class","markdown")},m(D,R){E(D,a,R),m(a,r),m(a,e),m(a,i),m(a,n),m(n,v),m(a,d),m(a,b),m(b,h),m(a,k)},p(D,R){R[0]&8&&u!==(u=D[3][0].branch_name+"")&&ye(v,u),R[0]&16&&g!==(g=D[4][0].menu_name+"")&&ye(h,g)},d(D){D&&o(a)}}}function Lt(s){let a,r,e,l="Halo Owner",i,n,u=s[2][0].pct_change_abs+"",v,d,b,g,h=s[5][0].jumlah_cabang+"",k,D,R,$,X=s[5][0].cabang_terparah+"",Y,F;return{c(){a=N("p"),r=O("⚠️ "),e=N("strong"),e.textContent=l,i=O(", ada yang perlu diperhatikan — revenue kemarin turun "),n=N("strong"),v=O(u),d=O("%"),b=O(" dibanding rata-rata 7 hari terakhir. Terdapat "),g=N("strong"),k=O(h),D=O(" cabang"),R=O(" dengan penurunan signifikan, dan "),$=N("strong"),Y=O(X),F=O(" mengalami penurunan paling tajam. Detail bisa dicek di halaman Performa Cabang."),this.h()},l(y){a=T(y,"P",{class:!0});var A=ae(a);r=C(A,"⚠️ "),e=T(A,"STRONG",{class:!0,"data-svelte-h":!0}),Ve(e)!=="svelte-1883qm9"&&(e.textContent=l),i=C(A,", ada yang perlu diperhatikan — revenue kemarin turun "),n=T(A,"STRONG",{class:!0});var z=ae(n);v=C(z,u),d=C(z,"%"),z.forEach(o),b=C(A," dibanding rata-rata 7 hari terakhir. Terdapat "),g=T(A,"STRONG",{class:!0});var re=ae(g);k=C(re,h),D=C(re," cabang"),re.forEach(o),R=C(A," dengan penurunan signifikan, dan "),$=T(A,"STRONG",{class:!0});var P=ae($);Y=C(P,X),P.forEach(o),F=C(A," mengalami penurunan paling tajam. Detail bisa dicek di halaman Performa Cabang."),A.forEach(o),this.h()},h(){f(e,"class","markdown"),f(n,"class","markdown"),f(g,"class","markdown"),f($,"class","markdown"),f(a,"class","markdown")},m(y,A){E(y,a,A),m(a,r),m(a,e),m(a,i),m(a,n),m(n,v),m(n,d),m(a,b),m(a,g),m(g,k),m(g,D),m(a,R),m(a,$),m($,Y),m(a,F)},p(y,A){A[0]&4&&u!==(u=y[2][0].pct_change_abs+"")&&ye(v,u),A[0]&32&&h!==(h=y[5][0].jumlah_cabang+"")&&ye(k,h),A[0]&32&&X!==(X=y[5][0].cabang_terparah+"")&&ye(Y,X)},d(y){y&&o(a)}}}function kt(s){let a,r,e,l="Halo Owner! Kabar baik",i,n,u=s[2][0].pct_change_display+"",v,d,b,g,h=s[3][0].branch_name+"",k,D,R,$=s[4][0].menu_name+"",X,Y;return{c(){a=N("p"),r=O("🎉 "),e=N("strong"),e.textContent=l,i=O(" — revenue kemarin naik "),n=N("strong"),v=O(u),d=O("%"),b=O(" dibanding rata-rata 7 hari terakhir. Cabang terbaik kemarin adalah "),g=N("strong"),k=O(h),D=O(". Menu terlaris adalah "),R=N("strong"),X=O($),Y=O(". Detail lengkap ada di halaman masing-masing."),this.h()},l(F){a=T(F,"P",{class:!0});var y=ae(a);r=C(y,"🎉 "),e=T(y,"STRONG",{class:!0,"data-svelte-h":!0}),Ve(e)!=="svelte-18tg9mw"&&(e.textContent=l),i=C(y," — revenue kemarin naik "),n=T(y,"STRONG",{class:!0});var A=ae(n);v=C(A,u),d=C(A,"%"),A.forEach(o),b=C(y," dibanding rata-rata 7 hari terakhir. Cabang terbaik kemarin adalah "),g=T(y,"STRONG",{class:!0});var z=ae(g);k=C(z,h),z.forEach(o),D=C(y,". Menu terlaris adalah "),R=T(y,"STRONG",{class:!0});var re=ae(R);X=C(re,$),re.forEach(o),Y=C(y,". Detail lengkap ada di halaman masing-masing."),y.forEach(o),this.h()},h(){f(e,"class","markdown"),f(n,"class","markdown"),f(g,"class","markdown"),f(R,"class","markdown"),f(a,"class","markdown")},m(F,y){E(F,a,y),m(a,r),m(a,e),m(a,i),m(a,n),m(n,v),m(n,d),m(a,b),m(a,g),m(g,k),m(a,D),m(a,R),m(R,X),m(a,Y)},p(F,y){y[0]&4&&u!==(u=F[2][0].pct_change_display+"")&&ye(v,u),y[0]&8&&h!==(h=F[3][0].branch_name+"")&&ye(k,h),y[0]&16&&$!==($=F[4][0].menu_name+"")&&ye(X,$)},d(F){F&&o(a)}}}function lt(s){let a,r;return a=new Fe({props:{queryID:"revenue_trend",queryResult:s[6]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&64&&(i.queryResult=e[6]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function _t(s){let a,r;return a=new Fe({props:{queryID:"branch_yesterday",queryResult:s[7]}}),{c(){Q(a.$$.fragment)},l(e){J(a.$$.fragment,e)},m(e,l){j(a,e,l),r=!0},p(e,l){const i={};l[0]&128&&(i.queryResult=e[7]),a.$set(i)},i(e){r||(p(a.$$.fragment,e),r=!0)},o(e){S(a.$$.fragment,e),r=!1},d(e){V(a,e)}}}function Ft(s){let a,r,e,l,i,n,u,v;return a=new Be({props:{id:"branch_name",title:"Cabang"}}),e=new Be({props:{id:"total_revenue",title:"Revenue (Rp)",fmt:"#,##0"}}),i=new Be({props:{id:"total_orders",title:"Pesanan",fmt:"#,##0"}}),u=new Be({props:{id:"pct_change_vs_7d_avg",title:"Tren (7hr)",fmt:"+0.0%;-0.0%;0.0%",contentType:"delta"}}),{c(){Q(a.$$.fragment),r=H(),Q(e.$$.fragment),l=H(),Q(i.$$.fragment),n=H(),Q(u.$$.fragment)},l(d){J(a.$$.fragment,d),r=M(d),J(e.$$.fragment,d),l=M(d),J(i.$$.fragment,d),n=M(d),J(u.$$.fragment,d)},m(d,b){j(a,d,b),E(d,r,b),j(e,d,b),E(d,l,b),j(i,d,b),E(d,n,b),j(u,d,b),v=!0},p:We,i(d){v||(p(a.$$.fragment,d),p(e.$$.fragment,d),p(i.$$.fragment,d),p(u.$$.fragment,d),v=!0)},o(d){S(a.$$.fragment,d),S(e.$$.fragment,d),S(i.$$.fragment,d),S(u.$$.fragment,d),v=!1},d(d){d&&(o(r),o(l),o(n)),V(a,d),V(e,d),V(i,d),V(u,d)}}}function Dt(s){let a,r,e,l,i,n,u,v,d,b,g,h,k,D,R=s[0][0].tanggal_display+"",$,X,Y,F,y,A,z,re,P,Ee,le,Te,ce,Ne,Z,me,ve,he,oe,$e='<a href="#tren-revenue-30-hari-terakhir">Tren Revenue (30 Hari Terakhir)</a>',fe,_e,ie,Me,be,He,x,ne,Re,Se=s[0][0].tanggal_display+"",Ae,Ce,se,ee,pe,ue=typeof L<"u"&&L.title&&L.hide_title!==!0&&Nt();function Ue(t,_){return typeof L<"u"&&L.title?Mt:ht}let de=Ue()(s),K=typeof L=="object"&&Ht(),W=s[0]&&xe(s),w=s[1]&&et(s),U=s[2]&&tt(s),I=s[3]&&at(s),c=s[4]&&rt(s),q=s[5]&&nt(s);function Je(t,_){return t[2][0].kondisi==="naik"?kt:t[2][0].kondisi==="turun"?Lt:Ot}let Ye=Je(s),ge=Ye(s);P=new Ge({props:{data:s[1],value:"total_revenue",title:"Total Revenue (Rp)",fmt:"#,##0"}}),le=new Ge({props:{data:s[1],value:"total_orders",title:"Total Pesanan",fmt:"#,##0"}}),ce=new Ge({props:{data:s[1],value:"active_branches",title:"Cabang Aktif"}}),Z=new Ge({props:{data:s[1],value:"avg_order_value",title:"Rata-rata Nilai Order (Rp)",fmt:"#,##0"}});let B=s[6]&&lt(s);ie=new Tt({props:{data:s[6],x:"order_date",y:"total_revenue",series:"branch_name",title:"Revenue per Cabang (Rp)",yFmt:"#,##0",xAxisTitle:"Tanggal",yAxisTitle:"Revenue (Rp)"}});let G=s[7]&&_t(s);return ee=new ft({props:{data:s[7],rows:"5",$$slots:{default:[Ft]},$$scope:{ctx:s}}}),{c(){ue&&ue.c(),a=H(),de.c(),r=N("meta"),e=N("meta"),K&&K.c(),l=Pe(),i=H(),W&&W.c(),n=H(),w&&w.c(),u=H(),U&&U.c(),v=H(),I&&I.c(),d=H(),c&&c.c(),b=H(),q&&q.c(),g=H(),h=N("p"),k=N("em"),D=O("Data diperbarui otomatis setiap hari. Menampilkan performa "),$=O(R),X=O("."),Y=H(),F=N("hr"),y=H(),ge.c(),A=H(),z=N("hr"),re=H(),Q(P.$$.fragment),Ee=H(),Q(le.$$.fragment),Te=H(),Q(ce.$$.fragment),Ne=H(),Q(Z.$$.fragment),me=H(),ve=N("hr"),he=H(),oe=N("h2"),oe.innerHTML=$e,fe=H(),B&&B.c(),_e=H(),Q(ie.$$.fragment),Me=H(),be=N("hr"),He=H(),x=N("h2"),ne=N("a"),Re=O("Performa Cabang "),Ae=O(Se),Ce=H(),G&&G.c(),se=H(),Q(ee.$$.fragment),this.h()},l(t){ue&&ue.l(t),a=M(t);const _=st("svelte-2igo1p",document.head);de.l(_),r=T(_,"META",{name:!0,content:!0}),e=T(_,"META",{name:!0,content:!0}),K&&K.l(_),l=Pe(),_.forEach(o),i=M(t),W&&W.l(t),n=M(t),w&&w.l(t),u=M(t),U&&U.l(t),v=M(t),I&&I.l(t),d=M(t),c&&c.l(t),b=M(t),q&&q.l(t),g=M(t),h=T(t,"P",{class:!0});var Ie=ae(h);k=T(Ie,"EM",{class:!0});var De=ae(k);D=C(De,"Data diperbarui otomatis setiap hari. Menampilkan performa "),$=C(De,R),X=C(De,"."),De.forEach(o),Ie.forEach(o),Y=M(t),F=T(t,"HR",{class:!0}),y=M(t),ge.l(t),A=M(t),z=T(t,"HR",{class:!0}),re=M(t),J(P.$$.fragment,t),Ee=M(t),J(le.$$.fragment,t),Te=M(t),J(ce.$$.fragment,t),Ne=M(t),J(Z.$$.fragment,t),me=M(t),ve=T(t,"HR",{class:!0}),he=M(t),oe=T(t,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Ve(oe)!=="svelte-1gt9mvl"&&(oe.innerHTML=$e),fe=M(t),B&&B.l(t),_e=M(t),J(ie.$$.fragment,t),Me=M(t),be=T(t,"HR",{class:!0}),He=M(t),x=T(t,"H2",{class:!0,id:!0});var qe=ae(x);ne=T(qe,"A",{href:!0});var we=ae(ne);Re=C(we,"Performa Cabang "),Ae=C(we,Se),we.forEach(o),qe.forEach(o),Ce=M(t),G&&G.l(t),se=M(t),J(ee.$$.fragment,t),this.h()},h(){f(r,"name","twitter:card"),f(r,"content","summary_large_image"),f(e,"name","twitter:site"),f(e,"content","@evidence_dev"),f(k,"class","markdown"),f(h,"class","markdown"),f(F,"class","markdown"),f(z,"class","markdown"),f(ve,"class","markdown"),f(oe,"class","markdown"),f(oe,"id","tren-revenue-30-hari-terakhir"),f(be,"class","markdown"),f(ne,"href","#performa-cabang-last_date0tanggal_display"),f(x,"class","markdown"),f(x,"id","performa-cabang-last_date0tanggal_display")},m(t,_){ue&&ue.m(t,_),E(t,a,_),de.m(document.head,null),m(document.head,r),m(document.head,e),K&&K.m(document.head,null),m(document.head,l),E(t,i,_),W&&W.m(t,_),E(t,n,_),w&&w.m(t,_),E(t,u,_),U&&U.m(t,_),E(t,v,_),I&&I.m(t,_),E(t,d,_),c&&c.m(t,_),E(t,b,_),q&&q.m(t,_),E(t,g,_),E(t,h,_),m(h,k),m(k,D),m(k,$),m(k,X),E(t,Y,_),E(t,F,_),E(t,y,_),ge.m(t,_),E(t,A,_),E(t,z,_),E(t,re,_),j(P,t,_),E(t,Ee,_),j(le,t,_),E(t,Te,_),j(ce,t,_),E(t,Ne,_),j(Z,t,_),E(t,me,_),E(t,ve,_),E(t,he,_),E(t,oe,_),E(t,fe,_),B&&B.m(t,_),E(t,_e,_),j(ie,t,_),E(t,Me,_),E(t,be,_),E(t,He,_),E(t,x,_),m(x,ne),m(ne,Re),m(ne,Ae),E(t,Ce,_),G&&G.m(t,_),E(t,se,_),j(ee,t,_),pe=!0},p(t,_){typeof L<"u"&&L.title&&L.hide_title!==!0&&ue.p(t,_),de.p(t,_),typeof L=="object"&&K.p(t,_),t[0]?W?(W.p(t,_),_[0]&1&&p(W,1)):(W=xe(t),W.c(),p(W,1),W.m(n.parentNode,n)):W&&(Le(),S(W,1,1,()=>{W=null}),Oe()),t[1]?w?(w.p(t,_),_[0]&2&&p(w,1)):(w=et(t),w.c(),p(w,1),w.m(u.parentNode,u)):w&&(Le(),S(w,1,1,()=>{w=null}),Oe()),t[2]?U?(U.p(t,_),_[0]&4&&p(U,1)):(U=tt(t),U.c(),p(U,1),U.m(v.parentNode,v)):U&&(Le(),S(U,1,1,()=>{U=null}),Oe()),t[3]?I?(I.p(t,_),_[0]&8&&p(I,1)):(I=at(t),I.c(),p(I,1),I.m(d.parentNode,d)):I&&(Le(),S(I,1,1,()=>{I=null}),Oe()),t[4]?c?(c.p(t,_),_[0]&16&&p(c,1)):(c=rt(t),c.c(),p(c,1),c.m(b.parentNode,b)):c&&(Le(),S(c,1,1,()=>{c=null}),Oe()),t[5]?q?(q.p(t,_),_[0]&32&&p(q,1)):(q=nt(t),q.c(),p(q,1),q.m(g.parentNode,g)):q&&(Le(),S(q,1,1,()=>{q=null}),Oe()),(!pe||_[0]&1)&&R!==(R=t[0][0].tanggal_display+"")&&ye($,R),Ye===(Ye=Je(t))&&ge?ge.p(t,_):(ge.d(1),ge=Ye(t),ge&&(ge.c(),ge.m(A.parentNode,A)));const Ie={};_[0]&2&&(Ie.data=t[1]),P.$set(Ie);const De={};_[0]&2&&(De.data=t[1]),le.$set(De);const qe={};_[0]&2&&(qe.data=t[1]),ce.$set(qe);const we={};_[0]&2&&(we.data=t[1]),Z.$set(we),t[6]?B?(B.p(t,_),_[0]&64&&p(B,1)):(B=lt(t),B.c(),p(B,1),B.m(_e.parentNode,_e)):B&&(Le(),S(B,1,1,()=>{B=null}),Oe());const Qe={};_[0]&64&&(Qe.data=t[6]),ie.$set(Qe),(!pe||_[0]&1)&&Se!==(Se=t[0][0].tanggal_display+"")&&ye(Ae,Se),t[7]?G?(G.p(t,_),_[0]&128&&p(G,1)):(G=_t(t),G.c(),p(G,1),G.m(se.parentNode,se)):G&&(Le(),S(G,1,1,()=>{G=null}),Oe());const je={};_[0]&128&&(je.data=t[7]),_[1]&536870912&&(je.$$scope={dirty:_,ctx:t}),ee.$set(je)},i(t){pe||(p(W),p(w),p(U),p(I),p(c),p(q),p(P.$$.fragment,t),p(le.$$.fragment,t),p(ce.$$.fragment,t),p(Z.$$.fragment,t),p(B),p(ie.$$.fragment,t),p(G),p(ee.$$.fragment,t),pe=!0)},o(t){S(W),S(w),S(U),S(I),S(c),S(q),S(P.$$.fragment,t),S(le.$$.fragment,t),S(ce.$$.fragment,t),S(Z.$$.fragment,t),S(B),S(ie.$$.fragment,t),S(G),S(ee.$$.fragment,t),pe=!1},d(t){t&&(o(a),o(i),o(n),o(u),o(v),o(d),o(b),o(g),o(h),o(Y),o(F),o(y),o(A),o(z),o(re),o(Ee),o(Te),o(Ne),o(me),o(ve),o(he),o(oe),o(fe),o(_e),o(Me),o(be),o(He),o(x),o(Ce),o(se)),ue&&ue.d(t),de.d(t),o(r),o(e),K&&K.d(t),o(l),W&&W.d(t),w&&w.d(t),U&&U.d(t),I&&I.d(t),c&&c.d(t),q&&q.d(t),ge.d(t),V(P,t),V(le,t),V(ce,t),V(Z,t),B&&B.d(t),V(ie,t),G&&G.d(t),V(ee,t)}}}const L={title:"Ringkasan Performa Bisnis"};function Wt(s,a,r){let e,l;Ke(s,St,c=>r(42,e=c)),Ke(s,Ze,c=>r(48,l=c));let{data:i}=a,{data:n={},customFormattingSettings:u,__db:v,inputs:d}=i;ot(Ze,l="6666cd76f96956469e7be39d750cc7d9",l);let b=pt(bt(d));ut(b.subscribe(c=>d=c)),dt(yt,{getCustomFormats:()=>u.customFormats||[]});const g=(c,q)=>Rt(v.query,c,{query_name:q});vt(g),e.params,Et(()=>!0);let h={initialData:void 0,initialError:void 0},k=te`SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display
FROM restaurant.daily_revenue`,D=`SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display
FROM restaurant.daily_revenue`;n.last_date_data&&(n.last_date_data instanceof Error?h.initialError=n.last_date_data:h.initialData=n.last_date_data,n.last_date_columns&&(h.knownColumns=n.last_date_columns));let R,$=!1;const X=ke.createReactive({callback:c=>{r(0,R=c)},execFn:g},{id:"last_date",...h});X(D,{noResolve:k,...h}),globalThis[Symbol.for("last_date")]={get value(){return R}};let Y={initialData:void 0,initialError:void 0},F=te`SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS active_branches,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)`,y=`SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS active_branches,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)`;n.today_summary_data&&(n.today_summary_data instanceof Error?Y.initialError=n.today_summary_data:Y.initialData=n.today_summary_data,n.today_summary_columns&&(Y.knownColumns=n.today_summary_columns));let A,z=!1;const re=ke.createReactive({callback:c=>{r(1,A=c)},execFn:g},{id:"today_summary",...Y});re(y,{noResolve:F,...Y}),globalThis[Symbol.for("today_summary")]={get value(){return A}};let P={initialData:void 0,initialError:void 0},Ee=te`SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    pct_change,
    CASE
        WHEN pct_change > 0.20  THEN 'naik'
        WHEN pct_change < -0.20 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND(
            (today_rev - avg_7d) / NULLIF(avg_7d, 0)
        , 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                            AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)                         AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)`,le=`SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    pct_change,
    CASE
        WHEN pct_change > 0.20  THEN 'naik'
        WHEN pct_change < -0.20 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND(
            (today_rev - avg_7d) / NULLIF(avg_7d, 0)
        , 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                            AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)                         AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)`;n.pct_change_data&&(n.pct_change_data instanceof Error?P.initialError=n.pct_change_data:P.initialData=n.pct_change_data,n.pct_change_columns&&(P.knownColumns=n.pct_change_columns));let Te,ce=!1;const Ne=ke.createReactive({callback:c=>{r(2,Te=c)},execFn:g},{id:"pct_change",...P});Ne(le,{noResolve:Ee,...P}),globalThis[Symbol.for("pct_change")]={get value(){return Te}};let Z={initialData:void 0,initialError:void 0},me=te`SELECT
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1`,ve=`SELECT
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1`;n.best_branch_data&&(n.best_branch_data instanceof Error?Z.initialError=n.best_branch_data:Z.initialData=n.best_branch_data,n.best_branch_columns&&(Z.knownColumns=n.best_branch_columns));let he,oe=!1;const $e=ke.createReactive({callback:c=>{r(3,he=c)},execFn:g},{id:"best_branch",...Z});$e(ve,{noResolve:me,...Z}),globalThis[Symbol.for("best_branch")]={get value(){return he}};let fe={initialData:void 0,initialError:void 0},_e=te`SELECT menu_name
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1`,ie=`SELECT menu_name
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1`;n.top_menu_today_data&&(n.top_menu_today_data instanceof Error?fe.initialError=n.top_menu_today_data:fe.initialData=n.top_menu_today_data,n.top_menu_today_columns&&(fe.knownColumns=n.top_menu_today_columns));let Me,be=!1;const He=ke.createReactive({callback:c=>{r(4,Me=c)},execFn:g},{id:"top_menu_today",...fe});He(ie,{noResolve:_e,...fe}),globalThis[Symbol.for("top_menu_today")]={get value(){return Me}};let x={initialData:void 0,initialError:void 0},ne=te`SELECT
    COUNT(*)         AS jumlah_cabang,
    MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_7d_avg < -0.20`,Re=`SELECT
    COUNT(*)         AS jumlah_cabang,
    MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_7d_avg < -0.20`;n.declining_branches_data&&(n.declining_branches_data instanceof Error?x.initialError=n.declining_branches_data:x.initialData=n.declining_branches_data,n.declining_branches_columns&&(x.knownColumns=n.declining_branches_columns));let Se,Ae=!1;const Ce=ke.createReactive({callback:c=>{r(5,Se=c)},execFn:g},{id:"declining_branches",...x});Ce(Re,{noResolve:ne,...x}),globalThis[Symbol.for("declining_branches")]={get value(){return Se}};let se={initialData:void 0,initialError:void 0},ee=te`SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date`,pe=`SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date`;n.revenue_trend_data&&(n.revenue_trend_data instanceof Error?se.initialError=n.revenue_trend_data:se.initialData=n.revenue_trend_data,n.revenue_trend_columns&&(se.knownColumns=n.revenue_trend_columns));let ue,Ue=!1;const Xe=ke.createReactive({callback:c=>{r(6,ue=c)},execFn:g},{id:"revenue_trend",...se});Xe(pe,{noResolve:ee,...se}),globalThis[Symbol.for("revenue_trend")]={get value(){return ue}};let de={initialData:void 0,initialError:void 0},K=te`SELECT
    branch_name,
    total_revenue,
    total_orders,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC`,W=`SELECT
    branch_name,
    total_revenue,
    total_orders,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC`;n.branch_yesterday_data&&(n.branch_yesterday_data instanceof Error?de.initialError=n.branch_yesterday_data:de.initialData=n.branch_yesterday_data,n.branch_yesterday_columns&&(de.knownColumns=n.branch_yesterday_columns));let w,U=!1;const I=ke.createReactive({callback:c=>{r(7,w=c)},execFn:g},{id:"branch_yesterday",...de});return I(W,{noResolve:K,...de}),globalThis[Symbol.for("branch_yesterday")]={get value(){return w}},s.$$set=c=>{"data"in c&&r(8,i=c.data)},s.$$.update=()=>{s.$$.dirty[0]&256&&r(9,{data:n={},customFormattingSettings:u,__db:v}=i,n),s.$$.dirty[0]&512&&gt.set(Object.keys(n).length>0),s.$$.dirty[1]&2048&&e.params,s.$$.dirty[0]&15360&&(k||!$?k||(X(D,{noResolve:k,...h}),r(13,$=!0)):X(D,{noResolve:k})),s.$$.dirty[0]&245760&&(F||!z?F||(re(y,{noResolve:F,...Y}),r(17,z=!0)):re(y,{noResolve:F})),s.$$.dirty[0]&3932160&&(Ee||!ce?Ee||(Ne(le,{noResolve:Ee,...P}),r(21,ce=!0)):Ne(le,{noResolve:Ee})),s.$$.dirty[0]&62914560&&(me||!oe?me||($e(ve,{noResolve:me,...Z}),r(25,oe=!0)):$e(ve,{noResolve:me})),s.$$.dirty[0]&1006632960&&(_e||!be?_e||(He(ie,{noResolve:_e,...fe}),r(29,be=!0)):He(ie,{noResolve:_e})),s.$$.dirty[0]&1073741824|s.$$.dirty[1]&7&&(ne||!Ae?ne||(Ce(Re,{noResolve:ne,...x}),r(33,Ae=!0)):Ce(Re,{noResolve:ne})),s.$$.dirty[1]&120&&(ee||!Ue?ee||(Xe(pe,{noResolve:ee,...se}),r(37,Ue=!0)):Xe(pe,{noResolve:ee})),s.$$.dirty[1]&1920&&(K||!U?K||(I(W,{noResolve:K,...de}),r(41,U=!0)):I(W,{noResolve:K}))},r(11,k=te`SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display
FROM restaurant.daily_revenue`),r(12,D=`SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display
FROM restaurant.daily_revenue`),r(15,F=te`SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS active_branches,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)`),r(16,y=`SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS active_branches,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)`),r(19,Ee=te`SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    pct_change,
    CASE
        WHEN pct_change > 0.20  THEN 'naik'
        WHEN pct_change < -0.20 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND(
            (today_rev - avg_7d) / NULLIF(avg_7d, 0)
        , 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                            AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)                         AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)`),r(20,le=`SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    pct_change,
    CASE
        WHEN pct_change > 0.20  THEN 'naik'
        WHEN pct_change < -0.20 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND(
            (today_rev - avg_7d) / NULLIF(avg_7d, 0)
        , 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                            AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)                         AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)`),r(23,me=te`SELECT
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1`),r(24,ve=`SELECT
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1`),r(27,_e=te`SELECT menu_name
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1`),r(28,ie=`SELECT menu_name
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1`),r(31,ne=te`SELECT
    COUNT(*)         AS jumlah_cabang,
    MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_7d_avg < -0.20`),r(32,Re=`SELECT
    COUNT(*)         AS jumlah_cabang,
    MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_7d_avg < -0.20`),r(35,ee=te`SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date`),r(36,pe=`SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date`),r(39,K=te`SELECT
    branch_name,
    total_revenue,
    total_orders,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC`),r(40,W=`SELECT
    branch_name,
    total_revenue,
    total_orders,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC`),[R,A,Te,he,Me,Se,ue,w,i,n,h,k,D,$,Y,F,y,z,P,Ee,le,ce,Z,me,ve,oe,fe,_e,ie,be,x,ne,Re,Ae,se,ee,pe,Ue,de,K,W,U,e]}class Gt extends ct{constructor(a){super(),mt(this,a,Wt,Dt,it,{data:8},null,[-1,-1])}}export{Gt as component};
