import{s as Zr,d as i,a as Lr,i as d,b as J,c as R,e as m,h as xr,f as b,g as Mr,l as Oe,j as Tr,k as Be,m as f,n as h,t as Pe,o as Ir,p as ea,q as ra,r as aa,u as ta,v as lr}from"../chunks/scheduler.6nJNm0Ol.js";import{S as oa,i as _a,d as N,t as y,a as E,c as Le,m as A,b as M,e as H,g as Ce}from"../chunks/index.C7HvIm27.js";import{D as Wr,e as sa,s as la,Q as $e,p as ia,C as sr,a as Yr,r as wr,b as na}from"../chunks/VennDiagram.svelte_svelte_type_style_lang.DD-6bGe2.js";import{w as ua}from"../chunks/entry.CyK2qLHD.js";import{h as W,p as da}from"../chunks/setTrackProxy.DjIbdjlZ.js";import{p as Ea}from"../chunks/stores.BTd8O5Ja.js";import{B as Cr,Q as De}from"../chunks/BigValue.DpH65uWj.js";import{B as Ar}from"../chunks/BarChart.Cw2JpQKt.js";function pa(n){let a,t=T.title+"",r;return{c(){a=h("h1"),r=Pe(t),this.h()},l(s){a=b(s,"H1",{class:!0});var l=Tr(a);r=Be(l,t),l.forEach(i),this.h()},h(){R(a,"class","title")},m(s,l){d(s,a,l),J(a,r)},p:lr,d(s){s&&i(a)}}}function ma(n){return{c(){this.h()},l(a){this.h()},h(){document.title="Evidence"},m:lr,p:lr,d:lr}}function fa(n){let a,t,r,s,l;return document.title=a=T.title,{c(){t=f(),r=h("meta"),s=f(),l=h("meta"),this.h()},l(_){t=m(_),r=b(_,"META",{property:!0,content:!0}),s=m(_),l=b(_,"META",{name:!0,content:!0}),this.h()},h(){var _,p;R(r,"property","og:title"),R(r,"content",((_=T.og)==null?void 0:_.title)??T.title),R(l,"name","twitter:title"),R(l,"content",((p=T.og)==null?void 0:p.title)??T.title)},m(_,p){d(_,t,p),d(_,r,p),d(_,s,p),d(_,l,p)},p(_,p){p&0&&a!==(a=T.title)&&(document.title=a)},d(_){_&&(i(t),i(r),i(s),i(l))}}}function ya(n){var l,_;let a,t,r=(T.description||((l=T.og)==null?void 0:l.description))&&Ra(),s=((_=T.og)==null?void 0:_.image)&&ka();return{c(){r&&r.c(),a=f(),s&&s.c(),t=Mr()},l(p){r&&r.l(p),a=m(p),s&&s.l(p),t=Mr()},m(p,c){r&&r.m(p,c),d(p,a,c),s&&s.m(p,c),d(p,t,c)},p(p,c){var u,S;(T.description||(u=T.og)!=null&&u.description)&&r.p(p,c),(S=T.og)!=null&&S.image&&s.p(p,c)},d(p){p&&(i(a),i(t)),r&&r.d(p),s&&s.d(p)}}}function Ra(n){let a,t,r,s,l;return{c(){a=h("meta"),t=f(),r=h("meta"),s=f(),l=h("meta"),this.h()},l(_){a=b(_,"META",{name:!0,content:!0}),t=m(_),r=b(_,"META",{property:!0,content:!0}),s=m(_),l=b(_,"META",{name:!0,content:!0}),this.h()},h(){var _,p,c;R(a,"name","description"),R(a,"content",T.description??((_=T.og)==null?void 0:_.description)),R(r,"property","og:description"),R(r,"content",((p=T.og)==null?void 0:p.description)??T.description),R(l,"name","twitter:description"),R(l,"content",((c=T.og)==null?void 0:c.description)??T.description)},m(_,p){d(_,a,p),d(_,t,p),d(_,r,p),d(_,s,p),d(_,l,p)},p:lr,d(_){_&&(i(a),i(t),i(r),i(s),i(l))}}}function ka(n){let a,t,r;return{c(){a=h("meta"),t=f(),r=h("meta"),this.h()},l(s){a=b(s,"META",{property:!0,content:!0}),t=m(s),r=b(s,"META",{name:!0,content:!0}),this.h()},h(){var s,l;R(a,"property","og:image"),R(a,"content",Yr((s=T.og)==null?void 0:s.image)),R(r,"name","twitter:image"),R(r,"content",Yr((l=T.og)==null?void 0:l.image))},m(s,l){d(s,a,l),d(s,t,l),d(s,r,l)},p:lr,d(s){s&&(i(a),i(t),i(r))}}}function Br(n){let a,t;return a=new De({props:{queryID:"peak_summary",queryResult:n[0]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&1&&(l.queryResult=r[0]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Pr(n){let a,t;return a=new De({props:{queryID:"peak_hour_summary",queryResult:n[1]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&2&&(l.queryResult=r[1]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Vr(n){let a,t;return a=new De({props:{queryID:"peak_order_type",queryResult:n[2]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&4&&(l.queryResult=r[2]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function qr(n){let a,t;return a=new De({props:{queryID:"besok",queryResult:n[3]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&8&&(l.queryResult=r[3]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Gr(n){let a,t;return a=new De({props:{queryID:"prediksi_besok",queryResult:n[4]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&16&&(l.queryResult=r[4]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Xr(n){let a,t;return a=new De({props:{queryID:"hourly_all",queryResult:n[5]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&32&&(l.queryResult=r[5]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function jr(n){let a,t;return a=new De({props:{queryID:"peak_by_branch",queryResult:n[6]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&64&&(l.queryResult=r[6]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Jr(n){let a,t;return a=new De({props:{queryID:"order_type_hourly",queryResult:n[7]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&128&&(l.queryResult=r[7]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Kr(n){let a,t;return a=new De({props:{queryID:"order_type_by_branch",queryResult:n[8]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&256&&(l.queryResult=r[8]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function Ta(n){let a,t,r,s,l,_,p,c;return a=new sr({props:{id:"branch_name",title:"Cabang"}}),r=new sr({props:{id:"day_part",title:"Periode"}}),l=new sr({props:{id:"order_type",title:"Tipe Order"}}),p=new sr({props:{id:"total_orders",title:"Total Order",fmt:"#,##0"}}),{c(){H(a.$$.fragment),t=f(),H(r.$$.fragment),s=f(),H(l.$$.fragment),_=f(),H(p.$$.fragment)},l(u){M(a.$$.fragment,u),t=m(u),M(r.$$.fragment,u),s=m(u),M(l.$$.fragment,u),_=m(u),M(p.$$.fragment,u)},m(u,S){A(a,u,S),d(u,t,S),A(r,u,S),d(u,s,S),A(l,u,S),d(u,_,S),A(p,u,S),c=!0},p:lr,i(u){c||(E(a.$$.fragment,u),E(r.$$.fragment,u),E(l.$$.fragment,u),E(p.$$.fragment,u),c=!0)},o(u){y(a.$$.fragment,u),y(r.$$.fragment,u),y(l.$$.fragment,u),y(p.$$.fragment,u),c=!1},d(u){u&&(i(t),i(s),i(_)),N(a,u),N(r,u),N(l,u),N(p,u)}}}function Qr(n){let a,t;return a=new De({props:{queryID:"daypart_summary",queryResult:n[9]}}),{c(){H(a.$$.fragment)},l(r){M(a.$$.fragment,r)},m(r,s){A(a,r,s),t=!0},p(r,s){const l={};s[0]&512&&(l.queryResult=r[9]),a.$set(l)},i(r){t||(E(a.$$.fragment,r),t=!0)},o(r){y(a.$$.fragment,r),t=!1},d(r){N(a,r)}}}function ba(n){let a,t,r,s,l,_,p,c;return a=new sr({props:{id:"day_part",title:"Periode"}}),r=new sr({props:{id:"total_orders",title:"Total Order",fmt:"#,##0"}}),l=new sr({props:{id:"total_revenue",title:"Total Revenue (Rp)",fmt:"#,##0"}}),p=new sr({props:{id:"avg_order_value",title:"Rata-rata Nilai Order (Rp)",fmt:"#,##0"}}),{c(){H(a.$$.fragment),t=f(),H(r.$$.fragment),s=f(),H(l.$$.fragment),_=f(),H(p.$$.fragment)},l(u){M(a.$$.fragment,u),t=m(u),M(r.$$.fragment,u),s=m(u),M(l.$$.fragment,u),_=m(u),M(p.$$.fragment,u)},m(u,S){A(a,u,S),d(u,t,S),A(r,u,S),d(u,s,S),A(l,u,S),d(u,_,S),A(p,u,S),c=!0},p:lr,i(u){c||(E(a.$$.fragment,u),E(r.$$.fragment,u),E(l.$$.fragment,u),E(p.$$.fragment,u),c=!0)},o(u){y(a.$$.fragment,u),y(r.$$.fragment,u),y(l.$$.fragment,u),y(p.$$.fragment,u),c=!1},d(u){u&&(i(t),i(s),i(_)),N(a,u),N(r,u),N(l,u),N(p,u)}}}function ha(n){let a,t,r,s,l,_,p='<em class="markdown">Ketahui kapan pelanggan datang dan optimalkan operasional restoranmu.</em>',c,u,S,Y,P,x,G,Ve,ee,qe,K,re,ae,ke,te,X,me,Q=n[3][0].tanggal_besok+"",Te,ir,ve=n[3][0].nama_hari+"",Ge,fe,oe,j,Xe,ye,_e,Re,z=n[3][0].nama_hari+"",be,nr,je,ge,se,w,Je='<a href="#distribusi-order-per-jam--semua-cabang-30-hari-terakhir">Distribusi Order per Jam — Semua Cabang (30 Hari Terakhir)</a>',Ke,he,le,ie,V,Qe='<em class="markdown">Jam dengan order tertinggi adalah momen kritis — pastikan staf penuh dan stok siap di jam-jam ini. Persiapan 30 menit sebelum jam sibuk biasanya sudah cukup untuk menghindari kehabisan menu.</em>',ze,Ue,Ze,B,ce='<a href="#jam-sibuk-per-cabang-30-hari-terakhir">Jam Sibuk per Cabang (30 Hari Terakhir)</a>',Se,Ne,ne,xe,q,Ae='<em class="markdown">Tiap cabang bisa punya jam sibuk yang berbeda tergantung lokasi dan demografi pelanggan. Jadikan data ini dasar penjadwalan staf per cabang — cabang di area perkantoran biasanya peak siang, cabang di area perumahan biasanya peak malam.</em>',Me,Fe,er,Z,He='<a href="#jenis-order-per-jam-30-hari-terakhir">Jenis Order per Jam (30 Hari Terakhir)</a>',ue,de,Ee,rr,pe,k='<em class="markdown">Kalau order jenis delivery yang dominan, pastikan kerjasama dengan platform ojol berjalan lancar di jam tersebut. Sebaliknya, kalau order jenis dine-in yang dominan, fokuskan kapasitas meja dan pelayanan di jam tersebut.</em>',Er,pr,ar,br,tr,$r='<em class="markdown">Detail jenis order per cabang per periode — gunakan ini untuk mengoptimalkan alokasi staf dan kapasitas per tipe layanan di tiap cabang.</em>',hr,fr,cr,Ie,Dr='<a href="#ringkasan-per-periode-30-hari-terakhir">Ringkasan per Periode (30 Hari Terakhir)</a>',Sr,mr,or,Nr,_r,vr='<em class="markdown">Periode dengan rata-rata nilai order tinggi tapi volume rendah adalah peluang — coba dorong traffic di jam tersebut lewat promo atau diskon khusus.</em>',ur,We=typeof T<"u"&&T.title&&T.hide_title!==!0&&pa();function zr(e,o){return typeof T<"u"&&T.title?fa:ma}let yr=zr()(n),Ye=typeof T=="object"&&ya(),O=n[0]&&Br(n),L=n[1]&&Pr(n),C=n[2]&&Vr(n);P=new Cr({props:{data:n[0],value:"periode_tersibuk",title:"Periode Tersibuk (30 Hari Terakhir)"}}),G=new Cr({props:{data:n[1],value:"jam_tersibuk",title:"Jam Tersibuk (30 Hari Terakhir)"}}),ee=new Cr({props:{data:n[2],value:"tipe_terbanyak",title:"Tipe Order Terbanyak"}});let $=n[3]&&qr(n),D=n[4]&&Gr(n);j=new Ar({props:{data:n[4],x:"order_hour",y:"prediksi_order",series:"branch_name",type:"stacked",title:"Prediksi Order per Jam Besok — per Cabang",xAxisTitle:"Jam",yAxisTitle:"Prediksi Total Order"}});let v=n[5]&&Xr(n);le=new Ar({props:{data:n[5],x:"order_hour",y:"total_orders",series:"day_part",title:"Total Order per Jam",xAxisTitle:"Jam",yAxisTitle:"Total Order"}});let g=n[6]&&jr(n);ne=new Ar({props:{data:n[6],x:"day_part",y:"total_orders",series:"branch_name",title:"Distribusi Periode per Cabang",type:"grouped",xAxisTitle:"Periode",yAxisTitle:"Total Order"}});let U=n[7]&&Jr(n);Ee=new Ar({props:{data:n[7],x:"order_hour",y:"total_orders",series:"order_type",type:"stacked",title:"Dine-in vs Delivery vs Takeaway per Jam",xAxisTitle:"Jam",yAxisTitle:"Total Order"}});let F=n[8]&&Kr(n);ar=new Wr({props:{data:n[8],$$slots:{default:[Ta]},$$scope:{ctx:n}}});let I=n[9]&&Qr(n);return or=new Wr({props:{data:n[9],$$slots:{default:[ba]},$$scope:{ctx:n}}}),{c(){We&&We.c(),a=f(),yr.c(),t=h("meta"),r=h("meta"),Ye&&Ye.c(),s=Mr(),l=f(),_=h("p"),_.innerHTML=p,c=f(),O&&O.c(),u=f(),L&&L.c(),S=f(),C&&C.c(),Y=f(),H(P.$$.fragment),x=f(),H(G.$$.fragment),Ve=f(),H(ee.$$.fragment),qe=f(),K=h("hr"),re=f(),$&&$.c(),ae=f(),D&&D.c(),ke=f(),te=h("h2"),X=h("a"),me=Pe("Prediksi Jam Sibuk — "),Te=Pe(Q),ir=Pe(" ("),Ge=Pe(ve),fe=Pe(")"),oe=f(),H(j.$$.fragment),Xe=f(),ye=h("p"),_e=h("em"),Re=Pe("Prediksi berdasarkan rata-rata order di hari "),be=Pe(z),nr=Pe(" dalam 30 hari terakhir. Gunakan ini untuk merencanakan jumlah staf dan persiapan stok sehari sebelumnya — bukan prediksi pasti, tapi pola historis yang cukup andal untuk planning operasional."),je=f(),ge=h("hr"),se=f(),w=h("h2"),w.innerHTML=Je,Ke=f(),v&&v.c(),he=f(),H(le.$$.fragment),ie=f(),V=h("p"),V.innerHTML=Qe,ze=f(),Ue=h("hr"),Ze=f(),B=h("h2"),B.innerHTML=ce,Se=f(),g&&g.c(),Ne=f(),H(ne.$$.fragment),xe=f(),q=h("p"),q.innerHTML=Ae,Me=f(),Fe=h("hr"),er=f(),Z=h("h2"),Z.innerHTML=He,ue=f(),U&&U.c(),de=f(),H(Ee.$$.fragment),rr=f(),pe=h("p"),pe.innerHTML=k,Er=f(),F&&F.c(),pr=f(),H(ar.$$.fragment),br=f(),tr=h("p"),tr.innerHTML=$r,hr=f(),fr=h("hr"),cr=f(),Ie=h("h2"),Ie.innerHTML=Dr,Sr=f(),I&&I.c(),mr=f(),H(or.$$.fragment),Nr=f(),_r=h("p"),_r.innerHTML=vr,this.h()},l(e){We&&We.l(e),a=m(e);const o=xr("svelte-2igo1p",document.head);yr.l(o),t=b(o,"META",{name:!0,content:!0}),r=b(o,"META",{name:!0,content:!0}),Ye&&Ye.l(o),s=Mr(),o.forEach(i),l=m(e),_=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(_)!=="svelte-1vx3vvf"&&(_.innerHTML=p),c=m(e),O&&O.l(e),u=m(e),L&&L.l(e),S=m(e),C&&C.l(e),Y=m(e),M(P.$$.fragment,e),x=m(e),M(G.$$.fragment,e),Ve=m(e),M(ee.$$.fragment,e),qe=m(e),K=b(e,"HR",{class:!0}),re=m(e),$&&$.l(e),ae=m(e),D&&D.l(e),ke=m(e),te=b(e,"H2",{class:!0,id:!0});var Rr=Tr(te);X=b(Rr,"A",{href:!0});var we=Tr(X);me=Be(we,"Prediksi Jam Sibuk — "),Te=Be(we,Q),ir=Be(we," ("),Ge=Be(we,ve),fe=Be(we,")"),we.forEach(i),Rr.forEach(i),oe=m(e),M(j.$$.fragment,e),Xe=m(e),ye=b(e,"P",{class:!0});var kr=Tr(ye);_e=b(kr,"EM",{class:!0});var dr=Tr(_e);Re=Be(dr,"Prediksi berdasarkan rata-rata order di hari "),be=Be(dr,z),nr=Be(dr," dalam 30 hari terakhir. Gunakan ini untuk merencanakan jumlah staf dan persiapan stok sehari sebelumnya — bukan prediksi pasti, tapi pola historis yang cukup andal untuk planning operasional."),dr.forEach(i),kr.forEach(i),je=m(e),ge=b(e,"HR",{class:!0}),se=m(e),w=b(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Oe(w)!=="svelte-1ux35b0"&&(w.innerHTML=Je),Ke=m(e),v&&v.l(e),he=m(e),M(le.$$.fragment,e),ie=m(e),V=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(V)!=="svelte-k2po3d"&&(V.innerHTML=Qe),ze=m(e),Ue=b(e,"HR",{class:!0}),Ze=m(e),B=b(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Oe(B)!=="svelte-vn8l2n"&&(B.innerHTML=ce),Se=m(e),g&&g.l(e),Ne=m(e),M(ne.$$.fragment,e),xe=m(e),q=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(q)!=="svelte-dccf4a"&&(q.innerHTML=Ae),Me=m(e),Fe=b(e,"HR",{class:!0}),er=m(e),Z=b(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Oe(Z)!=="svelte-1vr5v6o"&&(Z.innerHTML=He),ue=m(e),U&&U.l(e),de=m(e),M(Ee.$$.fragment,e),rr=m(e),pe=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(pe)!=="svelte-anif7w"&&(pe.innerHTML=k),Er=m(e),F&&F.l(e),pr=m(e),M(ar.$$.fragment,e),br=m(e),tr=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(tr)!=="svelte-1lldcna"&&(tr.innerHTML=$r),hr=m(e),fr=b(e,"HR",{class:!0}),cr=m(e),Ie=b(e,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Oe(Ie)!=="svelte-15zcy03"&&(Ie.innerHTML=Dr),Sr=m(e),I&&I.l(e),mr=m(e),M(or.$$.fragment,e),Nr=m(e),_r=b(e,"P",{class:!0,"data-svelte-h":!0}),Oe(_r)!=="svelte-q08def"&&(_r.innerHTML=vr),this.h()},h(){R(t,"name","twitter:card"),R(t,"content","summary_large_image"),R(r,"name","twitter:site"),R(r,"content","@evidence_dev"),R(_,"class","markdown"),R(K,"class","markdown"),R(X,"href","#prediksi-jam-sibuk--besok0tanggal_besok-besok0nama_hari"),R(te,"class","markdown"),R(te,"id","prediksi-jam-sibuk--besok0tanggal_besok-besok0nama_hari"),R(_e,"class","markdown"),R(ye,"class","markdown"),R(ge,"class","markdown"),R(w,"class","markdown"),R(w,"id","distribusi-order-per-jam--semua-cabang-30-hari-terakhir"),R(V,"class","markdown"),R(Ue,"class","markdown"),R(B,"class","markdown"),R(B,"id","jam-sibuk-per-cabang-30-hari-terakhir"),R(q,"class","markdown"),R(Fe,"class","markdown"),R(Z,"class","markdown"),R(Z,"id","jenis-order-per-jam-30-hari-terakhir"),R(pe,"class","markdown"),R(tr,"class","markdown"),R(fr,"class","markdown"),R(Ie,"class","markdown"),R(Ie,"id","ringkasan-per-periode-30-hari-terakhir"),R(_r,"class","markdown")},m(e,o){We&&We.m(e,o),d(e,a,o),yr.m(document.head,null),J(document.head,t),J(document.head,r),Ye&&Ye.m(document.head,null),J(document.head,s),d(e,l,o),d(e,_,o),d(e,c,o),O&&O.m(e,o),d(e,u,o),L&&L.m(e,o),d(e,S,o),C&&C.m(e,o),d(e,Y,o),A(P,e,o),d(e,x,o),A(G,e,o),d(e,Ve,o),A(ee,e,o),d(e,qe,o),d(e,K,o),d(e,re,o),$&&$.m(e,o),d(e,ae,o),D&&D.m(e,o),d(e,ke,o),d(e,te,o),J(te,X),J(X,me),J(X,Te),J(X,ir),J(X,Ge),J(X,fe),d(e,oe,o),A(j,e,o),d(e,Xe,o),d(e,ye,o),J(ye,_e),J(_e,Re),J(_e,be),J(_e,nr),d(e,je,o),d(e,ge,o),d(e,se,o),d(e,w,o),d(e,Ke,o),v&&v.m(e,o),d(e,he,o),A(le,e,o),d(e,ie,o),d(e,V,o),d(e,ze,o),d(e,Ue,o),d(e,Ze,o),d(e,B,o),d(e,Se,o),g&&g.m(e,o),d(e,Ne,o),A(ne,e,o),d(e,xe,o),d(e,q,o),d(e,Me,o),d(e,Fe,o),d(e,er,o),d(e,Z,o),d(e,ue,o),U&&U.m(e,o),d(e,de,o),A(Ee,e,o),d(e,rr,o),d(e,pe,o),d(e,Er,o),F&&F.m(e,o),d(e,pr,o),A(ar,e,o),d(e,br,o),d(e,tr,o),d(e,hr,o),d(e,fr,o),d(e,cr,o),d(e,Ie,o),d(e,Sr,o),I&&I.m(e,o),d(e,mr,o),A(or,e,o),d(e,Nr,o),d(e,_r,o),ur=!0},p(e,o){typeof T<"u"&&T.title&&T.hide_title!==!0&&We.p(e,o),yr.p(e,o),typeof T=="object"&&Ye.p(e,o),e[0]?O?(O.p(e,o),o[0]&1&&E(O,1)):(O=Br(e),O.c(),E(O,1),O.m(u.parentNode,u)):O&&(Ce(),y(O,1,1,()=>{O=null}),Le()),e[1]?L?(L.p(e,o),o[0]&2&&E(L,1)):(L=Pr(e),L.c(),E(L,1),L.m(S.parentNode,S)):L&&(Ce(),y(L,1,1,()=>{L=null}),Le()),e[2]?C?(C.p(e,o),o[0]&4&&E(C,1)):(C=Vr(e),C.c(),E(C,1),C.m(Y.parentNode,Y)):C&&(Ce(),y(C,1,1,()=>{C=null}),Le());const Rr={};o[0]&1&&(Rr.data=e[0]),P.$set(Rr);const we={};o[0]&2&&(we.data=e[1]),G.$set(we);const kr={};o[0]&4&&(kr.data=e[2]),ee.$set(kr),e[3]?$?($.p(e,o),o[0]&8&&E($,1)):($=qr(e),$.c(),E($,1),$.m(ae.parentNode,ae)):$&&(Ce(),y($,1,1,()=>{$=null}),Le()),e[4]?D?(D.p(e,o),o[0]&16&&E(D,1)):(D=Gr(e),D.c(),E(D,1),D.m(ke.parentNode,ke)):D&&(Ce(),y(D,1,1,()=>{D=null}),Le()),(!ur||o[0]&8)&&Q!==(Q=e[3][0].tanggal_besok+"")&&Lr(Te,Q),(!ur||o[0]&8)&&ve!==(ve=e[3][0].nama_hari+"")&&Lr(Ge,ve);const dr={};o[0]&16&&(dr.data=e[4]),j.$set(dr),(!ur||o[0]&8)&&z!==(z=e[3][0].nama_hari+"")&&Lr(be,z),e[5]?v?(v.p(e,o),o[0]&32&&E(v,1)):(v=Xr(e),v.c(),E(v,1),v.m(he.parentNode,he)):v&&(Ce(),y(v,1,1,()=>{v=null}),Le());const gr={};o[0]&32&&(gr.data=e[5]),le.$set(gr),e[6]?g?(g.p(e,o),o[0]&64&&E(g,1)):(g=jr(e),g.c(),E(g,1),g.m(Ne.parentNode,Ne)):g&&(Ce(),y(g,1,1,()=>{g=null}),Le());const Ur={};o[0]&64&&(Ur.data=e[6]),ne.$set(Ur),e[7]?U?(U.p(e,o),o[0]&128&&E(U,1)):(U=Jr(e),U.c(),E(U,1),U.m(de.parentNode,de)):U&&(Ce(),y(U,1,1,()=>{U=null}),Le());const Fr={};o[0]&128&&(Fr.data=e[7]),Ee.$set(Fr),e[8]?F?(F.p(e,o),o[0]&256&&E(F,1)):(F=Kr(e),F.c(),E(F,1),F.m(pr.parentNode,pr)):F&&(Ce(),y(F,1,1,()=>{F=null}),Le());const Hr={};o[0]&256&&(Hr.data=e[8]),o[2]&1024&&(Hr.$$scope={dirty:o,ctx:e}),ar.$set(Hr),e[9]?I?(I.p(e,o),o[0]&512&&E(I,1)):(I=Qr(e),I.c(),E(I,1),I.m(mr.parentNode,mr)):I&&(Ce(),y(I,1,1,()=>{I=null}),Le());const Or={};o[0]&512&&(Or.data=e[9]),o[2]&1024&&(Or.$$scope={dirty:o,ctx:e}),or.$set(Or)},i(e){ur||(E(O),E(L),E(C),E(P.$$.fragment,e),E(G.$$.fragment,e),E(ee.$$.fragment,e),E($),E(D),E(j.$$.fragment,e),E(v),E(le.$$.fragment,e),E(g),E(ne.$$.fragment,e),E(U),E(Ee.$$.fragment,e),E(F),E(ar.$$.fragment,e),E(I),E(or.$$.fragment,e),ur=!0)},o(e){y(O),y(L),y(C),y(P.$$.fragment,e),y(G.$$.fragment,e),y(ee.$$.fragment,e),y($),y(D),y(j.$$.fragment,e),y(v),y(le.$$.fragment,e),y(g),y(ne.$$.fragment,e),y(U),y(Ee.$$.fragment,e),y(F),y(ar.$$.fragment,e),y(I),y(or.$$.fragment,e),ur=!1},d(e){e&&(i(a),i(l),i(_),i(c),i(u),i(S),i(Y),i(x),i(Ve),i(qe),i(K),i(re),i(ae),i(ke),i(te),i(oe),i(Xe),i(ye),i(je),i(ge),i(se),i(w),i(Ke),i(he),i(ie),i(V),i(ze),i(Ue),i(Ze),i(B),i(Se),i(Ne),i(xe),i(q),i(Me),i(Fe),i(er),i(Z),i(ue),i(de),i(rr),i(pe),i(Er),i(pr),i(br),i(tr),i(hr),i(fr),i(cr),i(Ie),i(Sr),i(mr),i(Nr),i(_r)),We&&We.d(e),yr.d(e),i(t),i(r),Ye&&Ye.d(e),i(s),O&&O.d(e),L&&L.d(e),C&&C.d(e),N(P,e),N(G,e),N(ee,e),$&&$.d(e),D&&D.d(e),N(j,e),v&&v.d(e),N(le,e),g&&g.d(e),N(ne,e),U&&U.d(e),N(Ee,e),F&&F.d(e),N(ar,e),I&&I.d(e),N(or,e)}}}const T={title:"Analisis Jam Sibuk"};function ca(n,a,t){let r,s;Ir(n,Ea,k=>t(52,r=k)),Ir(n,wr,k=>t(58,s=k));let{data:l}=a,{data:_={},customFormattingSettings:p,__db:c,inputs:u}=l;ea(wr,s="7509ec770158640d951ab2115772e0de",s);let S=sa(ua(u));ra(S.subscribe(k=>u=k)),aa(na,{getCustomFormats:()=>p.customFormats||[]});const Y=(k,Er)=>da(c.query,k,{query_name:Er});la(Y),r.params,ta(()=>!0);let P={initialData:void 0,initialError:void 0},x=W`SELECT
    day_part                                                            AS periode_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1`,G=`SELECT
    day_part                                                            AS periode_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1`;_.peak_summary_data&&(_.peak_summary_data instanceof Error?P.initialError=_.peak_summary_data:P.initialData=_.peak_summary_data,_.peak_summary_columns&&(P.knownColumns=_.peak_summary_columns));let Ve,ee=!1;const qe=$e.createReactive({callback:k=>{t(0,Ve=k)},execFn:Y},{id:"peak_summary",...P});qe(G,{noResolve:x,...P}),globalThis[Symbol.for("peak_summary")]={get value(){return Ve}};let K={initialData:void 0,initialError:void 0},re=W`SELECT
    order_hour                                                          AS jam_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1`,ae=`SELECT
    order_hour                                                          AS jam_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1`;_.peak_hour_summary_data&&(_.peak_hour_summary_data instanceof Error?K.initialError=_.peak_hour_summary_data:K.initialData=_.peak_hour_summary_data,_.peak_hour_summary_columns&&(K.knownColumns=_.peak_hour_summary_columns));let ke,te=!1;const X=$e.createReactive({callback:k=>{t(1,ke=k)},execFn:Y},{id:"peak_hour_summary",...K});X(ae,{noResolve:re,...K}),globalThis[Symbol.for("peak_hour_summary")]={get value(){return ke}};let me={initialData:void 0,initialError:void 0},Q=W`SELECT
    order_type                                                          AS tipe_terbanyak,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1`,Te=`SELECT
    order_type                                                          AS tipe_terbanyak,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1`;_.peak_order_type_data&&(_.peak_order_type_data instanceof Error?me.initialError=_.peak_order_type_data:me.initialData=_.peak_order_type_data,_.peak_order_type_columns&&(me.knownColumns=_.peak_order_type_columns));let ir,ve=!1;const Ge=$e.createReactive({callback:k=>{t(2,ir=k)},execFn:Y},{id:"peak_order_type",...me});Ge(Te,{noResolve:Q,...me}),globalThis[Symbol.for("peak_order_type")]={get value(){return ir}};let fe={initialData:void 0,initialError:void 0},oe=W`SELECT
    DAY(CURRENT_DATE + INTERVAL '1 day') || ' ' ||
    CASE MONTH(CURRENT_DATE + INTERVAL '1 day')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(CURRENT_DATE + INTERVAL '1 day')   AS tanggal_besok,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END                                      AS nama_hari
FROM (SELECT 1) t`,j=`SELECT
    DAY(CURRENT_DATE + INTERVAL '1 day') || ' ' ||
    CASE MONTH(CURRENT_DATE + INTERVAL '1 day')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(CURRENT_DATE + INTERVAL '1 day')   AS tanggal_besok,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END                                      AS nama_hari
FROM (SELECT 1) t`;_.besok_data&&(_.besok_data instanceof Error?fe.initialError=_.besok_data:fe.initialData=_.besok_data,_.besok_columns&&(fe.knownColumns=_.besok_columns));let Xe,ye=!1;const _e=$e.createReactive({callback:k=>{t(3,Xe=k)},execFn:Y},{id:"besok",...fe});_e(j,{noResolve:oe,...fe}),globalThis[Symbol.for("besok")]={get value(){return Xe}};let Re={initialData:void 0,initialError:void 0},z=W`SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS prediksi_order
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name`,be=`SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS prediksi_order
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name`;_.prediksi_besok_data&&(_.prediksi_besok_data instanceof Error?Re.initialError=_.prediksi_besok_data:Re.initialData=_.prediksi_besok_data,_.prediksi_besok_columns&&(Re.knownColumns=_.prediksi_besok_columns));let nr,je=!1;const ge=$e.createReactive({callback:k=>{t(4,nr=k)},execFn:Y},{id:"prediksi_besok",...Re});ge(be,{noResolve:z,...Re}),globalThis[Symbol.for("prediksi_besok")]={get value(){return nr}};let se={initialData:void 0,initialError:void 0},w=W`SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour`,Je=`SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour`;_.hourly_all_data&&(_.hourly_all_data instanceof Error?se.initialError=_.hourly_all_data:se.initialData=_.hourly_all_data,_.hourly_all_columns&&(se.knownColumns=_.hourly_all_columns));let Ke,he=!1;const le=$e.createReactive({callback:k=>{t(5,Ke=k)},execFn:Y},{id:"hourly_all",...se});le(Je,{noResolve:w,...se}),globalThis[Symbol.for("hourly_all")]={get value(){return Ke}};let ie={initialData:void 0,initialError:void 0},V=W`SELECT
    branch_name,
    day_part,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC`,Qe=`SELECT
    branch_name,
    day_part,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC`;_.peak_by_branch_data&&(_.peak_by_branch_data instanceof Error?ie.initialError=_.peak_by_branch_data:ie.initialData=_.peak_by_branch_data,_.peak_by_branch_columns&&(ie.knownColumns=_.peak_by_branch_columns));let ze,Ue=!1;const Ze=$e.createReactive({callback:k=>{t(6,ze=k)},execFn:Y},{id:"peak_by_branch",...ie});Ze(Qe,{noResolve:V,...ie}),globalThis[Symbol.for("peak_by_branch")]={get value(){return ze}};let B={initialData:void 0,initialError:void 0},ce=W`SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour`,Se=`SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour`;_.order_type_hourly_data&&(_.order_type_hourly_data instanceof Error?B.initialError=_.order_type_hourly_data:B.initialData=_.order_type_hourly_data,_.order_type_hourly_columns&&(B.knownColumns=_.order_type_hourly_columns));let Ne,ne=!1;const xe=$e.createReactive({callback:k=>{t(7,Ne=k)},execFn:Y},{id:"order_type_hourly",...B});xe(Se,{noResolve:ce,...B}),globalThis[Symbol.for("order_type_hourly")]={get value(){return Ne}};let q={initialData:void 0,initialError:void 0},Ae=W`SELECT
    branch_name,
    day_part,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type`,Me=`SELECT
    branch_name,
    day_part,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type`;_.order_type_by_branch_data&&(_.order_type_by_branch_data instanceof Error?q.initialError=_.order_type_by_branch_data:q.initialData=_.order_type_by_branch_data,_.order_type_by_branch_columns&&(q.knownColumns=_.order_type_by_branch_columns));let Fe,er=!1;const Z=$e.createReactive({callback:k=>{t(8,Fe=k)},execFn:Y},{id:"order_type_by_branch",...q});Z(Me,{noResolve:Ae,...q}),globalThis[Symbol.for("order_type_by_branch")]={get value(){return Fe}};let He={initialData:void 0,initialError:void 0},ue=W`SELECT
    day_part,
    SUM(total_orders)                                                   AS total_orders,
    SUM(total_revenue)                                                  AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC`,de=`SELECT
    day_part,
    SUM(total_orders)                                                   AS total_orders,
    SUM(total_revenue)                                                  AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC`;_.daypart_summary_data&&(_.daypart_summary_data instanceof Error?He.initialError=_.daypart_summary_data:He.initialData=_.daypart_summary_data,_.daypart_summary_columns&&(He.knownColumns=_.daypart_summary_columns));let Ee,rr=!1;const pe=$e.createReactive({callback:k=>{t(9,Ee=k)},execFn:Y},{id:"daypart_summary",...He});return pe(de,{noResolve:ue,...He}),globalThis[Symbol.for("daypart_summary")]={get value(){return Ee}},n.$$set=k=>{"data"in k&&t(10,l=k.data)},n.$$.update=()=>{n.$$.dirty[0]&1024&&t(11,{data:_={},customFormattingSettings:p,__db:c}=l,_),n.$$.dirty[0]&2048&&ia.set(Object.keys(_).length>0),n.$$.dirty[1]&2097152&&r.params,n.$$.dirty[0]&61440&&(x||!ee?x||(qe(G,{noResolve:x,...P}),t(15,ee=!0)):qe(G,{noResolve:x})),n.$$.dirty[0]&983040&&(re||!te?re||(X(ae,{noResolve:re,...K}),t(19,te=!0)):X(ae,{noResolve:re})),n.$$.dirty[0]&15728640&&(Q||!ve?Q||(Ge(Te,{noResolve:Q,...me}),t(23,ve=!0)):Ge(Te,{noResolve:Q})),n.$$.dirty[0]&251658240&&(oe||!ye?oe||(_e(j,{noResolve:oe,...fe}),t(27,ye=!0)):_e(j,{noResolve:oe})),n.$$.dirty[0]&1879048192|n.$$.dirty[1]&1&&(z||!je?z||(ge(be,{noResolve:z,...Re}),t(31,je=!0)):ge(be,{noResolve:z})),n.$$.dirty[1]&30&&(w||!he?w||(le(Je,{noResolve:w,...se}),t(35,he=!0)):le(Je,{noResolve:w})),n.$$.dirty[1]&480&&(V||!Ue?V||(Ze(Qe,{noResolve:V,...ie}),t(39,Ue=!0)):Ze(Qe,{noResolve:V})),n.$$.dirty[1]&7680&&(ce||!ne?ce||(xe(Se,{noResolve:ce,...B}),t(43,ne=!0)):xe(Se,{noResolve:ce})),n.$$.dirty[1]&122880&&(Ae||!er?Ae||(Z(Me,{noResolve:Ae,...q}),t(47,er=!0)):Z(Me,{noResolve:Ae})),n.$$.dirty[1]&1966080&&(ue||!rr?ue||(pe(de,{noResolve:ue,...He}),t(51,rr=!0)):pe(de,{noResolve:ue}))},t(13,x=W`SELECT
    day_part                                                            AS periode_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1`),t(14,G=`SELECT
    day_part                                                            AS periode_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1`),t(17,re=W`SELECT
    order_hour                                                          AS jam_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1`),t(18,ae=`SELECT
    order_hour                                                          AS jam_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1`),t(21,Q=W`SELECT
    order_type                                                          AS tipe_terbanyak,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1`),t(22,Te=`SELECT
    order_type                                                          AS tipe_terbanyak,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1`),t(25,oe=W`SELECT
    DAY(CURRENT_DATE + INTERVAL '1 day') || ' ' ||
    CASE MONTH(CURRENT_DATE + INTERVAL '1 day')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(CURRENT_DATE + INTERVAL '1 day')   AS tanggal_besok,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END                                      AS nama_hari
FROM (SELECT 1) t`),t(26,j=`SELECT
    DAY(CURRENT_DATE + INTERVAL '1 day') || ' ' ||
    CASE MONTH(CURRENT_DATE + INTERVAL '1 day')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(CURRENT_DATE + INTERVAL '1 day')   AS tanggal_besok,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END                                      AS nama_hari
FROM (SELECT 1) t`),t(29,z=W`SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS prediksi_order
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name`),t(30,be=`SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS prediksi_order
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name`),t(33,w=W`SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour`),t(34,Je=`SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour`),t(37,V=W`SELECT
    branch_name,
    day_part,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC`),t(38,Qe=`SELECT
    branch_name,
    day_part,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC`),t(41,ce=W`SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour`),t(42,Se=`SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour`),t(45,Ae=W`SELECT
    branch_name,
    day_part,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type`),t(46,Me=`SELECT
    branch_name,
    day_part,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type`),t(49,ue=W`SELECT
    day_part,
    SUM(total_orders)                                                   AS total_orders,
    SUM(total_revenue)                                                  AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC`),t(50,de=`SELECT
    day_part,
    SUM(total_orders)                                                   AS total_orders,
    SUM(total_revenue)                                                  AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC`),[Ve,ke,ir,Xe,nr,Ke,ze,Ne,Fe,Ee,l,_,P,x,G,ee,K,re,ae,te,me,Q,Te,ve,fe,oe,j,ye,Re,z,be,je,se,w,Je,he,ie,V,Qe,Ue,B,ce,Se,ne,q,Ae,Me,er,He,ue,de,rr,r]}class Da extends oa{constructor(a){super(),_a(this,a,ca,ha,Zr,{data:10},null,[-1,-1,-1])}}export{Da as component};
