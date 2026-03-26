import{s as Ke,d as s,i as o,b as Ce,c as v,e as c,h as ze,f as C,g as Ue,l as fe,m as d,n as U,o as qe,p as Je,q as Ze,r as xe,u as et,v as ce,j as tt,k as at,t as rt}from"../chunks/scheduler.6nJNm0Ol.js";import{S as nt,i as lt,d as O,t as h,a as b,c as Ee,m as D,b as L,e as w,g as Se}from"../chunks/index.C7HvIm27.js";import{D as _t,e as it,s as ut,Q as Te,p as st,C as ye,a as Ye,r as Pe,b as ot}from"../chunks/VennDiagram.svelte_svelte_type_style_lang.DD-6bGe2.js";import{w as mt}from"../chunks/entry.CyK2qLHD.js";import{h as te,p as ft}from"../chunks/setTrackProxy.DjIbdjlZ.js";import{p as ct}from"../chunks/stores.BTd8O5Ja.js";import{B as ke,Q as $e}from"../chunks/BigValue.DpH65uWj.js";import{B as dt}from"../chunks/BarChart.Cw2JpQKt.js";import{L as bt}from"../chunks/LineChart.DYPYS9M1.js";function vt(m){let a,r=p.title+"",t;return{c(){a=U("h1"),t=rt(r),this.h()},l(_){a=C(_,"H1",{class:!0});var u=tt(a);t=at(u,r),u.forEach(s),this.h()},h(){v(a,"class","title")},m(_,u){o(_,a,u),Ce(a,t)},p:ce,d(_){_&&s(a)}}}function pt(m){return{c(){this.h()},l(a){this.h()},h(){document.title="Evidence"},m:ce,p:ce,d:ce}}function ht(m){let a,r,t,_,u;return document.title=a=p.title,{c(){r=d(),t=U("meta"),_=d(),u=U("meta"),this.h()},l(n){r=c(n),t=C(n,"META",{property:!0,content:!0}),_=c(n),u=C(n,"META",{name:!0,content:!0}),this.h()},h(){var n,f;v(t,"property","og:title"),v(t,"content",((n=p.og)==null?void 0:n.title)??p.title),v(u,"name","twitter:title"),v(u,"content",((f=p.og)==null?void 0:f.title)??p.title)},m(n,f){o(n,r,f),o(n,t,f),o(n,_,f),o(n,u,f)},p(n,f){f&0&&a!==(a=p.title)&&(document.title=a)},d(n){n&&(s(r),s(t),s(_),s(u))}}}function yt(m){var u,n;let a,r,t=(p.description||((u=p.og)==null?void 0:u.description))&&Rt(),_=((n=p.og)==null?void 0:n.image)&&Et();return{c(){t&&t.c(),a=d(),_&&_.c(),r=Ue()},l(f){t&&t.l(f),a=c(f),_&&_.l(f),r=Ue()},m(f,R){t&&t.m(f,R),o(f,a,R),_&&_.m(f,R),o(f,r,R)},p(f,R){var T,N;(p.description||(T=p.og)!=null&&T.description)&&t.p(f,R),(N=p.og)!=null&&N.image&&_.p(f,R)},d(f){f&&(s(a),s(r)),t&&t.d(f),_&&_.d(f)}}}function Rt(m){let a,r,t,_,u;return{c(){a=U("meta"),r=d(),t=U("meta"),_=d(),u=U("meta"),this.h()},l(n){a=C(n,"META",{name:!0,content:!0}),r=c(n),t=C(n,"META",{property:!0,content:!0}),_=c(n),u=C(n,"META",{name:!0,content:!0}),this.h()},h(){var n,f,R;v(a,"name","description"),v(a,"content",p.description??((n=p.og)==null?void 0:n.description)),v(t,"property","og:description"),v(t,"content",((f=p.og)==null?void 0:f.description)??p.description),v(u,"name","twitter:description"),v(u,"content",((R=p.og)==null?void 0:R.description)??p.description)},m(n,f){o(n,a,f),o(n,r,f),o(n,t,f),o(n,_,f),o(n,u,f)},p:ce,d(n){n&&(s(a),s(r),s(t),s(_),s(u))}}}function Et(m){let a,r,t;return{c(){a=U("meta"),r=d(),t=U("meta"),this.h()},l(_){a=C(_,"META",{property:!0,content:!0}),r=c(_),t=C(_,"META",{name:!0,content:!0}),this.h()},h(){var _,u;v(a,"property","og:image"),v(a,"content",Ye((_=p.og)==null?void 0:_.image)),v(t,"name","twitter:image"),v(t,"content",Ye((u=p.og)==null?void 0:u.image))},m(_,u){o(_,a,u),o(_,r,u),o(_,t,u)},p:ce,d(_){_&&(s(a),s(r),s(t))}}}function Ge(m){let a,r;return a=new $e({props:{queryID:"summary_all",queryResult:m[0]}}),{c(){w(a.$$.fragment)},l(t){L(a.$$.fragment,t)},m(t,_){D(a,t,_),r=!0},p(t,_){const u={};_[0]&1&&(u.queryResult=t[0]),a.$set(u)},i(t){r||(b(a.$$.fragment,t),r=!0)},o(t){h(a.$$.fragment,t),r=!1},d(t){O(a,t)}}}function Xe(m){let a,r;return a=new $e({props:{queryID:"best_branch_month",queryResult:m[1]}}),{c(){w(a.$$.fragment)},l(t){L(a.$$.fragment,t)},m(t,_){D(a,t,_),r=!0},p(t,_){const u={};_[0]&2&&(u.queryResult=t[1]),a.$set(u)},i(t){r||(b(a.$$.fragment,t),r=!0)},o(t){h(a.$$.fragment,t),r=!1},d(t){O(a,t)}}}function je(m){let a,r;return a=new $e({props:{queryID:"branch_monthly",queryResult:m[2]}}),{c(){w(a.$$.fragment)},l(t){L(a.$$.fragment,t)},m(t,_){D(a,t,_),r=!0},p(t,_){const u={};_[0]&4&&(u.queryResult=t[2]),a.$set(u)},i(t){r||(b(a.$$.fragment,t),r=!0)},o(t){h(a.$$.fragment,t),r=!1},d(t){O(a,t)}}}function We(m){let a,r;return a=new $e({props:{queryID:"branch_daily_90",queryResult:m[3]}}),{c(){w(a.$$.fragment)},l(t){L(a.$$.fragment,t)},m(t,_){D(a,t,_),r=!0},p(t,_){const u={};_[0]&8&&(u.queryResult=t[3]),a.$set(u)},i(t){r||(b(a.$$.fragment,t),r=!0)},o(t){h(a.$$.fragment,t),r=!1},d(t){O(a,t)}}}function Ve(m){let a,r;return a=new $e({props:{queryID:"branch_summary",queryResult:m[4]}}),{c(){w(a.$$.fragment)},l(t){L(a.$$.fragment,t)},m(t,_){D(a,t,_),r=!0},p(t,_){const u={};_[0]&16&&(u.queryResult=t[4]),a.$set(u)},i(t){r||(b(a.$$.fragment,t),r=!0)},o(t){h(a.$$.fragment,t),r=!1},d(t){O(a,t)}}}function St(m){let a,r,t,_,u,n,f,R,T,N,E,F;return a=new ye({props:{id:"branch_name",title:"Cabang"}}),t=new ye({props:{id:"total_revenue",title:"Total Revenue (Rp)",fmt:"#,##0"}}),u=new ye({props:{id:"total_orders",title:"Total Pesanan",fmt:"#,##0"}}),f=new ye({props:{id:"avg_order_value",title:"Rata-rata Nilai Order (Rp)",fmt:"#,##0"}}),T=new ye({props:{id:"first_date",title:"Mulai Beroperasi"}}),E=new ye({props:{id:"last_date",title:"Data Terakhir"}}),{c(){w(a.$$.fragment),r=d(),w(t.$$.fragment),_=d(),w(u.$$.fragment),n=d(),w(f.$$.fragment),R=d(),w(T.$$.fragment),N=d(),w(E.$$.fragment)},l(i){L(a.$$.fragment,i),r=c(i),L(t.$$.fragment,i),_=c(i),L(u.$$.fragment,i),n=c(i),L(f.$$.fragment,i),R=c(i),L(T.$$.fragment,i),N=c(i),L(E.$$.fragment,i)},m(i,S){D(a,i,S),o(i,r,S),D(t,i,S),o(i,_,S),D(u,i,S),o(i,n,S),D(f,i,S),o(i,R,S),D(T,i,S),o(i,N,S),D(E,i,S),F=!0},p:ce,i(i){F||(b(a.$$.fragment,i),b(t.$$.fragment,i),b(u.$$.fragment,i),b(f.$$.fragment,i),b(T.$$.fragment,i),b(E.$$.fragment,i),F=!0)},o(i){h(a.$$.fragment,i),h(t.$$.fragment,i),h(u.$$.fragment,i),h(f.$$.fragment,i),h(T.$$.fragment,i),h(E.$$.fragment,i),F=!1},d(i){i&&(s(r),s(_),s(n),s(R),s(N)),O(a,i),O(t,i),O(u,i),O(f,i),O(T,i),O(E,i)}}}function Tt(m){let a,r,t,_,u,n,f='<em class="markdown">Analisis revenue dan tren performa per cabang restoran.</em>',R,T,N,E,F,i,S,j,le,W,V,P,Z,G,de='<a href="#revenue-bulanan-per-cabang">Revenue Bulanan per Cabang</a>',_e,q,I,x,Q,be='<em class="markdown">Grafik di atas menunjukkan kontribusi revenue tiap cabang per bulan. Cabang dengan bar tertinggi secara konsisten adalah pemain utama bisnis kamu — pertahankan performa mereka dan jadikan benchmark untuk cabang lainnya.</em>',ie,X,K,B,ve='<a href="#tren-harian-90-hari-terakhir">Tren Harian (90 Hari Terakhir)</a>',ue,ee,H,z,Y,pe='<em class="markdown">Garis yang menurun secara konsisten perlu perhatian lebih — bisa jadi indikasi masalah operasional atau persaingan di area cabang tersebut. Sebaliknya, tren naik yang stabil menandakan cabang sedang dalam momentum yang baik.</em>',se,ae,y,J,De='<a href="#ringkasan-keseluruhan">Ringkasan Keseluruhan</a>',ge,he,oe,Me,me,Le='<em class="markdown">Rata-rata nilai order yang rendah di suatu cabang bisa jadi peluang untuk mendorong upselling atau bundling menu. Bandingkan antar cabang untuk menemukan best practice yang bisa diterapkan di cabang lain.</em>',Ae,re=typeof p<"u"&&p.title&&p.hide_title!==!0&&vt();function Qe(e,l){return typeof p<"u"&&p.title?ht:pt}let Re=Qe()(m),ne=typeof p=="object"&&yt(),$=m[0]&&Ge(m),g=m[1]&&Xe(m);E=new ke({props:{data:m[0],value:"total_revenue_all",title:"Total Revenue Keseluruhan (Rp)",fmt:"#,##0"}}),i=new ke({props:{data:m[0],value:"total_cabang",title:"Total Cabang Aktif"}}),j=new ke({props:{data:m[1],value:"branch_name",title:"Cabang Terbaik Bulan Ini"}}),W=new ke({props:{data:m[1],value:"total_revenue",title:"Revenue Cabang Terbaik (Rp)",fmt:"#,##0"}});let M=m[2]&&je(m);I=new dt({props:{data:m[2],x:"bulan",y:"total_revenue",series:"branch_name",type:"stacked",title:"Revenue Bulanan per Cabang (Rp)",yFmt:"#,##0",xAxisTitle:"Bulan",yAxisTitle:"Revenue (Rp)"}});let A=m[3]&&We(m);H=new bt({props:{data:m[3],x:"order_date",y:"revenue_7d_avg",series:"branch_name",title:"Rata-rata 7 Hari per Cabang (Rp)",yFmt:"#,##0",xAxisTitle:"Tanggal",yAxisTitle:"Revenue 7-Day Avg (Rp)"}});let k=m[4]&&Ve(m);return oe=new _t({props:{data:m[4],$$slots:{default:[St]},$$scope:{ctx:m}}}),{c(){re&&re.c(),a=d(),Re.c(),r=U("meta"),t=U("meta"),ne&&ne.c(),_=Ue(),u=d(),n=U("p"),n.innerHTML=f,R=d(),$&&$.c(),T=d(),g&&g.c(),N=d(),w(E.$$.fragment),F=d(),w(i.$$.fragment),S=d(),w(j.$$.fragment),le=d(),w(W.$$.fragment),V=d(),P=U("hr"),Z=d(),G=U("h2"),G.innerHTML=de,_e=d(),M&&M.c(),q=d(),w(I.$$.fragment),x=d(),Q=U("p"),Q.innerHTML=be,ie=d(),X=U("hr"),K=d(),B=U("h2"),B.innerHTML=ve,ue=d(),A&&A.c(),ee=d(),w(H.$$.fragment),z=d(),Y=U("p"),Y.innerHTML=pe,se=d(),ae=U("hr"),y=d(),J=U("h2"),J.innerHTML=De,ge=d(),k&&k.c(),he=d(),w(oe.$$.fragment),Me=d(),me=U("p"),me.innerHTML=Le,this.h()},l(e){re&&re.l(e),a=c(e);const l=ze("svelte-2igo1p",document.head);Re.l(l),r=C(l,"META",{name:!0,content:!0}),t=C(l,"META",{name:!0,content:!0}),ne&&ne.l(l),_=Ue(),l.forEach(s),u=c(e),n=C(e,"P",{class:!0,"data-svelte-h":!0}),fe(n)!=="svelte-1ect0a"&&(n.innerHTML=f),R=c(e),$&&$.l(e),T=c(e),g&&g.l(e),N=c(e),L(E.$$.fragment,e),F=c(e),L(i.$$.fragment,e),S=c(e),L(j.$$.fragment,e),le=c(e),L(W.$$.fragment,e),V=c(e),P=C(e,"HR",{class:!0}),Z=c(e),G=C(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),fe(G)!=="svelte-1kerp1a"&&(G.innerHTML=de),_e=c(e),M&&M.l(e),q=c(e),L(I.$$.fragment,e),x=c(e),Q=C(e,"P",{class:!0,"data-svelte-h":!0}),fe(Q)!=="svelte-uhq1gx"&&(Q.innerHTML=be),ie=c(e),X=C(e,"HR",{class:!0}),K=c(e),B=C(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),fe(B)!=="svelte-cu6yte"&&(B.innerHTML=ve),ue=c(e),A&&A.l(e),ee=c(e),L(H.$$.fragment,e),z=c(e),Y=C(e,"P",{class:!0,"data-svelte-h":!0}),fe(Y)!=="svelte-b14uox"&&(Y.innerHTML=pe),se=c(e),ae=C(e,"HR",{class:!0}),y=c(e),J=C(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),fe(J)!=="svelte-mbzwod"&&(J.innerHTML=De),ge=c(e),k&&k.l(e),he=c(e),L(oe.$$.fragment,e),Me=c(e),me=C(e,"P",{class:!0,"data-svelte-h":!0}),fe(me)!=="svelte-3ezmqg"&&(me.innerHTML=Le),this.h()},h(){v(r,"name","twitter:card"),v(r,"content","summary_large_image"),v(t,"name","twitter:site"),v(t,"content","@evidence_dev"),v(n,"class","markdown"),v(P,"class","markdown"),v(G,"class","markdown"),v(G,"id","revenue-bulanan-per-cabang"),v(Q,"class","markdown"),v(X,"class","markdown"),v(B,"class","markdown"),v(B,"id","tren-harian-90-hari-terakhir"),v(Y,"class","markdown"),v(ae,"class","markdown"),v(J,"class","markdown"),v(J,"id","ringkasan-keseluruhan"),v(me,"class","markdown")},m(e,l){re&&re.m(e,l),o(e,a,l),Re.m(document.head,null),Ce(document.head,r),Ce(document.head,t),ne&&ne.m(document.head,null),Ce(document.head,_),o(e,u,l),o(e,n,l),o(e,R,l),$&&$.m(e,l),o(e,T,l),g&&g.m(e,l),o(e,N,l),D(E,e,l),o(e,F,l),D(i,e,l),o(e,S,l),D(j,e,l),o(e,le,l),D(W,e,l),o(e,V,l),o(e,P,l),o(e,Z,l),o(e,G,l),o(e,_e,l),M&&M.m(e,l),o(e,q,l),D(I,e,l),o(e,x,l),o(e,Q,l),o(e,ie,l),o(e,X,l),o(e,K,l),o(e,B,l),o(e,ue,l),A&&A.m(e,l),o(e,ee,l),D(H,e,l),o(e,z,l),o(e,Y,l),o(e,se,l),o(e,ae,l),o(e,y,l),o(e,J,l),o(e,ge,l),k&&k.m(e,l),o(e,he,l),D(oe,e,l),o(e,Me,l),o(e,me,l),Ae=!0},p(e,l){typeof p<"u"&&p.title&&p.hide_title!==!0&&re.p(e,l),Re.p(e,l),typeof p=="object"&&ne.p(e,l),e[0]?$?($.p(e,l),l[0]&1&&b($,1)):($=Ge(e),$.c(),b($,1),$.m(T.parentNode,T)):$&&(Se(),h($,1,1,()=>{$=null}),Ee()),e[1]?g?(g.p(e,l),l[0]&2&&b(g,1)):(g=Xe(e),g.c(),b(g,1),g.m(N.parentNode,N)):g&&(Se(),h(g,1,1,()=>{g=null}),Ee());const we={};l[0]&1&&(we.data=e[0]),E.$set(we);const Fe={};l[0]&1&&(Fe.data=e[0]),i.$set(Fe);const Ne={};l[0]&2&&(Ne.data=e[1]),j.$set(Ne);const Ie={};l[0]&2&&(Ie.data=e[1]),W.$set(Ie),e[2]?M?(M.p(e,l),l[0]&4&&b(M,1)):(M=je(e),M.c(),b(M,1),M.m(q.parentNode,q)):M&&(Se(),h(M,1,1,()=>{M=null}),Ee());const He={};l[0]&4&&(He.data=e[2]),I.$set(He),e[3]?A?(A.p(e,l),l[0]&8&&b(A,1)):(A=We(e),A.c(),b(A,1),A.m(ee.parentNode,ee)):A&&(Se(),h(A,1,1,()=>{A=null}),Ee());const Be={};l[0]&8&&(Be.data=e[3]),H.$set(Be),e[4]?k?(k.p(e,l),l[0]&16&&b(k,1)):(k=Ve(e),k.c(),b(k,1),k.m(he.parentNode,he)):k&&(Se(),h(k,1,1,()=>{k=null}),Ee());const Oe={};l[0]&16&&(Oe.data=e[4]),l[1]&2048&&(Oe.$$scope={dirty:l,ctx:e}),oe.$set(Oe)},i(e){Ae||(b($),b(g),b(E.$$.fragment,e),b(i.$$.fragment,e),b(j.$$.fragment,e),b(W.$$.fragment,e),b(M),b(I.$$.fragment,e),b(A),b(H.$$.fragment,e),b(k),b(oe.$$.fragment,e),Ae=!0)},o(e){h($),h(g),h(E.$$.fragment,e),h(i.$$.fragment,e),h(j.$$.fragment,e),h(W.$$.fragment,e),h(M),h(I.$$.fragment,e),h(A),h(H.$$.fragment,e),h(k),h(oe.$$.fragment,e),Ae=!1},d(e){e&&(s(a),s(u),s(n),s(R),s(T),s(N),s(F),s(S),s(le),s(V),s(P),s(Z),s(G),s(_e),s(q),s(x),s(Q),s(ie),s(X),s(K),s(B),s(ue),s(ee),s(z),s(Y),s(se),s(ae),s(y),s(J),s(ge),s(he),s(Me),s(me)),re&&re.d(e),Re.d(e),s(r),s(t),ne&&ne.d(e),s(_),$&&$.d(e),g&&g.d(e),O(E,e),O(i,e),O(j,e),O(W,e),M&&M.d(e),O(I,e),A&&A.d(e),O(H,e),k&&k.d(e),O(oe,e)}}}const p={title:"Performa Cabang"};function $t(m,a,r){let t,_;qe(m,ct,y=>r(27,t=y)),qe(m,Pe,y=>r(33,_=y));let{data:u}=a,{data:n={},customFormattingSettings:f,__db:R,inputs:T}=u;Je(Pe,_="d4ed0e9305b50ba2225e1bef2a0a78ca",_);let N=it(mt(T));Ze(N.subscribe(y=>T=y)),xe(ot,{getCustomFormats:()=>f.customFormats||[]});const E=(y,J)=>ft(R.query,y,{query_name:J});ut(E),t.params,et(()=>!0);let F={initialData:void 0,initialError:void 0},i=te`SELECT
    SUM(total_revenue)              AS total_revenue_all,
    COUNT(DISTINCT branch_id)       AS total_cabang
FROM restaurant.daily_revenue`,S=`SELECT
    SUM(total_revenue)              AS total_revenue_all,
    COUNT(DISTINCT branch_id)       AS total_cabang
FROM restaurant.daily_revenue`;n.summary_all_data&&(n.summary_all_data instanceof Error?F.initialError=n.summary_all_data:F.initialData=n.summary_all_data,n.summary_all_columns&&(F.knownColumns=n.summary_all_columns));let j,le=!1;const W=Te.createReactive({callback:y=>{r(0,j=y)},execFn:E},{id:"summary_all",...F});W(S,{noResolve:i,...F}),globalThis[Symbol.for("summary_all")]={get value(){return j}};let V={initialData:void 0,initialError:void 0},P=te`SELECT
    branch_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.daily_revenue
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', (SELECT MAX(order_date) FROM restaurant.daily_revenue))
GROUP BY branch_name
ORDER BY total_revenue DESC
LIMIT 1`,Z=`SELECT
    branch_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.daily_revenue
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', (SELECT MAX(order_date) FROM restaurant.daily_revenue))
GROUP BY branch_name
ORDER BY total_revenue DESC
LIMIT 1`;n.best_branch_month_data&&(n.best_branch_month_data instanceof Error?V.initialError=n.best_branch_month_data:V.initialData=n.best_branch_month_data,n.best_branch_month_columns&&(V.knownColumns=n.best_branch_month_columns));let G,de=!1;const _e=Te.createReactive({callback:y=>{r(1,G=y)},execFn:E},{id:"best_branch_month",...V});_e(Z,{noResolve:P,...V}),globalThis[Symbol.for("best_branch_month")]={get value(){return G}};let q={initialData:void 0,initialError:void 0},I=te`SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2`,x=`SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2`;n.branch_monthly_data&&(n.branch_monthly_data instanceof Error?q.initialError=n.branch_monthly_data:q.initialData=n.branch_monthly_data,n.branch_monthly_columns&&(q.knownColumns=n.branch_monthly_columns));let Q,be=!1;const ie=Te.createReactive({callback:y=>{r(2,Q=y)},execFn:E},{id:"branch_monthly",...q});ie(x,{noResolve:I,...q}),globalThis[Symbol.for("branch_monthly")]={get value(){return Q}};let X={initialData:void 0,initialError:void 0},K=te`SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 0) AS revenue_7d_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name`,B=`SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 0) AS revenue_7d_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name`;n.branch_daily_90_data&&(n.branch_daily_90_data instanceof Error?X.initialError=n.branch_daily_90_data:X.initialData=n.branch_daily_90_data,n.branch_daily_90_columns&&(X.knownColumns=n.branch_daily_90_columns));let ve,ue=!1;const ee=Te.createReactive({callback:y=>{r(3,ve=y)},execFn:E},{id:"branch_daily_90",...X});ee(B,{noResolve:K,...X}),globalThis[Symbol.for("branch_daily_90")]={get value(){return ve}};let H={initialData:void 0,initialError:void 0},z=te`SELECT
    branch_name,
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value,
    MIN(order_date)                                                     AS first_date,
    MAX(order_date)                                                     AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC`,Y=`SELECT
    branch_name,
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value,
    MIN(order_date)                                                     AS first_date,
    MAX(order_date)                                                     AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC`;n.branch_summary_data&&(n.branch_summary_data instanceof Error?H.initialError=n.branch_summary_data:H.initialData=n.branch_summary_data,n.branch_summary_columns&&(H.knownColumns=n.branch_summary_columns));let pe,se=!1;const ae=Te.createReactive({callback:y=>{r(4,pe=y)},execFn:E},{id:"branch_summary",...H});return ae(Y,{noResolve:z,...H}),globalThis[Symbol.for("branch_summary")]={get value(){return pe}},m.$$set=y=>{"data"in y&&r(5,u=y.data)},m.$$.update=()=>{m.$$.dirty[0]&32&&r(6,{data:n={},customFormattingSettings:f,__db:R}=u,n),m.$$.dirty[0]&64&&st.set(Object.keys(n).length>0),m.$$.dirty[0]&134217728&&t.params,m.$$.dirty[0]&1920&&(i||!le?i||(W(S,{noResolve:i,...F}),r(10,le=!0)):W(S,{noResolve:i})),m.$$.dirty[0]&30720&&(P||!de?P||(_e(Z,{noResolve:P,...V}),r(14,de=!0)):_e(Z,{noResolve:P})),m.$$.dirty[0]&491520&&(I||!be?I||(ie(x,{noResolve:I,...q}),r(18,be=!0)):ie(x,{noResolve:I})),m.$$.dirty[0]&7864320&&(K||!ue?K||(ee(B,{noResolve:K,...X}),r(22,ue=!0)):ee(B,{noResolve:K})),m.$$.dirty[0]&125829120&&(z||!se?z||(ae(Y,{noResolve:z,...H}),r(26,se=!0)):ae(Y,{noResolve:z}))},r(8,i=te`SELECT
    SUM(total_revenue)              AS total_revenue_all,
    COUNT(DISTINCT branch_id)       AS total_cabang
FROM restaurant.daily_revenue`),r(9,S=`SELECT
    SUM(total_revenue)              AS total_revenue_all,
    COUNT(DISTINCT branch_id)       AS total_cabang
FROM restaurant.daily_revenue`),r(12,P=te`SELECT
    branch_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.daily_revenue
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', (SELECT MAX(order_date) FROM restaurant.daily_revenue))
GROUP BY branch_name
ORDER BY total_revenue DESC
LIMIT 1`),r(13,Z=`SELECT
    branch_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.daily_revenue
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', (SELECT MAX(order_date) FROM restaurant.daily_revenue))
GROUP BY branch_name
ORDER BY total_revenue DESC
LIMIT 1`),r(16,I=te`SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2`),r(17,x=`SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2`),r(20,K=te`SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 0) AS revenue_7d_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name`),r(21,B=`SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 0) AS revenue_7d_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name`),r(24,z=te`SELECT
    branch_name,
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value,
    MIN(order_date)                                                     AS first_date,
    MAX(order_date)                                                     AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC`),r(25,Y=`SELECT
    branch_name,
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value,
    MIN(order_date)                                                     AS first_date,
    MAX(order_date)                                                     AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC`),[j,G,Q,ve,pe,u,n,F,i,S,le,V,P,Z,de,q,I,x,be,X,K,B,ue,H,z,Y,se,t]}class Ft extends nt{constructor(a){super(),lt(this,a,$t,Tt,Ke,{data:5},null,[-1,-1])}}export{Ft as component};
