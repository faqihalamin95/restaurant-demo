import{s as vt,w as ma,d as E,x as sa,y as Ea,z as fa,c as T,i as f,f as p,j as Lt,n as U,r as da,J as Kt,o as It,K as ya,v as ze,G as Qt,e as M,m as g,b as Et,h as Ma,g as Ht,l as Te,p as ga,q as ca,u as Aa,k as Ta,t as Na}from"../chunks/scheduler.6nJNm0Ol.js";import{S as Dt,i as pt,t as y,a as d,d as b,m as O,b as C,e as L,c as xe,g as Je}from"../chunks/index.C7HvIm27.js";import{n as ba,o as Oa,j as Sa,t as Ca,u as at,v as Ge,D as Ct,e as La,s as Ha,Q as Ze,p as va,C as ie,a as xt,r as Jt,b as Da}from"../chunks/VennDiagram.svelte_svelte_type_style_lang.CKm9zWeR.js";import{w as pa}from"../chunks/entry.CHXutQtC.js";import{h as Y,p as Ua}from"../chunks/setTrackProxy.DjIbdjlZ.js";import{p as qa}from"../chunks/stores._MuJJx_G.js";import{g as ka,b as ha,C as Ia,B as gt,Q as $e}from"../chunks/BigValue.N9zYMMDb.js";import{B as Zt}from"../chunks/BarChart.De5wJbOC.js";import{L as Fa}from"../chunks/LineChart.DFOLdIfr.js";function wa(l){let t,n,e;const o=l[5].default,_=ma(o,l,l[4],null);return{c(){t=U("div"),_&&_.c(),this.h()},l(r){t=p(r,"DIV",{class:!0});var m=Lt(t);_&&_.l(m),m.forEach(E),this.h()},h(){T(t,"class",n="grid "+l[2][l[0]]+" "+l[3][l[1]])},m(r,m){f(r,t,m),_&&_.m(t,null),e=!0},p(r,[m]){_&&_.p&&(!e||m&16)&&sa(_,o,r,r[4],e?fa(o,r[4],m,null):Ea(r[4]),null),(!e||m&3&&n!==(n="grid "+r[2][r[0]]+" "+r[3][r[1]]))&&T(t,"class",n)},i(r){e||(d(_,r),e=!0)},o(r){y(_,r),e=!1},d(r){r&&E(t),_&&_.d(r)}}}function Wa(l,t,n){let{$$slots:e={},$$scope:o}=t,{cols:_=2}=t,{gapSize:r="md"}=t;const m=Object.freeze({1:"grid-cols-1",2:"grid-cols-1 sm:grid-cols-2",3:"grid-cols-1 sm:grid-cols-2 md:grid-cols-3",4:"grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4",5:"grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5",6:"grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-6"}),c=Object.freeze({none:"gap-0",sm:"gap-2",md:"gap-4",lg:"gap-8"}),A=Object.freeze({none:0,sm:8,md:16,lg:32});let N=`grid-${Date.now()}-${Math.round(Math.random()*1e3)}`,i=A[r];return da("gridConfig",{gridId:N,cols:_,gapWidth:i}),l.$$set=R=>{"cols"in R&&n(0,_=R.cols),"gapSize"in R&&n(1,r=R.gapSize),"$$scope"in R&&n(4,o=R.$$scope)},[_,r,m,c,o,e]}class Ba extends Dt{constructor(t){super(),pt(this,t,Wa,wa,vt,{cols:0,gapSize:1})}}function Va(l,t,n){let e,o,_,r,m,c,A,N,i,R,v,D,I,F,Ne,w=ze,fe=()=>(w(),w=Qt(o,S=>n(27,Ne=S)),o),X,be=ze,pe=()=>(be(),be=Qt(e,S=>n(28,X=S)),e),h;l.$$.on_destroy.push(()=>w()),l.$$.on_destroy.push(()=>be());let W=Kt(ba);It(l,W,S=>n(29,h=S));let Me=Kt(Oa);const{resolveColor:ge}=Sa();let{y:q=void 0}=t;const je=!!q;let{series:G=void 0}=t;const oe=!!G;let{options:P=void 0}=t,{name:B=void 0}=t,{shape:Oe="circle"}=t,{fillColor:ue=void 0}=t,{opacity:Ce=.7}=t,{outlineColor:V=void 0}=t,{outlineWidth:de=void 0}=t,{pointSize:Se=10}=t,{useTooltip:Q=!1}=t,{tooltipTitle:me}=t,{seriesOrder:z=void 0}=t,{seriesLabelFmt:Re=void 0}=t,se,j,ye,Ee;return Q&&(ye={tooltip:{formatter(S){return se?me?j=`<span id="tooltip" style='font-weight:600'>${Ge(S.value[2],"0")}</span><br/>
                            ${at(G)}: <span style='float:right; margin-left: 15px;'>${Ge(S.seriesName)}</span><br/>
                            ${at(r,A)}: <span style='float:right; margin-left: 15px;'>${Ge(S.value[0],A)}</span><br/>
                            ${at(typeof q=="object"?S.seriesName:q,N)}: <span style='float:right; margin-left: 15px;'>${Ge(S.value[1],N)}</span>`:j=`<span id="tooltip" style='font-weight:600'>${Ge(S.seriesName)}</span><br/>
                            ${at(r,A)}: <span style='float:right; margin-left: 15px;'>${Ge(S.value[0],A)}</span><br/>
                            ${at(typeof q=="object"?S.seriesName:q,N)}: <span style='float:right; margin-left: 15px;'>${Ge(S.value[1],N)}</span>`:me?j=`<span id="tooltip" style='font-weight:600;'>${Ge(S.value[2],"0")}</span><br/>
                            <span style='font-weight: 400;'>${at(r,A)}:</span> <span style='float:right; margin-left: 15px;'>${Ge(S.value[0],A)}</span><br/>
                            <span style='font-weight: 400;'>${at(q,N)}:</span> <span style='float:right; margin-left: 15px;'>${Ge(S.value[1],N)}</span>`:j=`<span id="tooltip" style='font-weight: 600;'>${at(r,A)}:</span> <span style='float:right; margin-left: 15px;'>${Ge(S.value[0],A)}</span><br/>
                            <span style='font-weight: 600;'>${at(q,N)}:</span> <span style='float:right; margin-left: 15px;'>${Ge(S.value[1],N)}</span>`,j}}},Ee={tooltip:{trigger:"item"}}),ya(()=>{Me.update(S=>(m?(S.yAxis={...S.yAxis,...F.xAxis},S.xAxis={...S.xAxis,...F.yAxis}):(S.yAxis[0]={...S.yAxis[0],...F.yAxis},S.xAxis={...S.xAxis,...F.xAxis}),Q&&(S.tooltip={...S.tooltip,...Ee.tooltip}),S))}),l.$$set=S=>{"y"in S&&n(3,q=S.y),"series"in S&&n(4,G=S.series),"options"in S&&n(8,P=S.options),"name"in S&&n(5,B=S.name),"shape"in S&&n(9,Oe=S.shape),"fillColor"in S&&n(10,ue=S.fillColor),"opacity"in S&&n(11,Ce=S.opacity),"outlineColor"in S&&n(12,V=S.outlineColor),"outlineWidth"in S&&n(13,de=S.outlineWidth),"pointSize"in S&&n(14,Se=S.pointSize),"useTooltip"in S&&n(6,Q=S.useTooltip),"tooltipTitle"in S&&n(7,me=S.tooltipTitle),"seriesOrder"in S&&n(15,z=S.seriesOrder),"seriesLabelFmt"in S&&n(16,Re=S.seriesLabelFmt)},l.$$.update=()=>{l.$$.dirty[0]&1024&&pe(n(1,e=ge(ue))),l.$$.dirty[0]&4096&&fe(n(0,o=ge(V))),l.$$.dirty[0]&64&&n(6,Q=Ca(Q)),l.$$.dirty[0]&536870912&&n(25,_=h.data),l.$$.dirty[0]&536870912&&n(24,r=h.x),l.$$.dirty[0]&536870912&&n(18,m=h.swapXY),l.$$.dirty[0]&536870912&&n(19,c=h.xType),l.$$.dirty[0]&536870912&&(A=h.xFormat),l.$$.dirty[0]&536870912&&(N=h.yFormat),l.$$.dirty[0]&536870912&&n(22,i=h.xMismatch),l.$$.dirty[0]&536870912&&n(21,R=h.columnSummary),l.$$.dirty[0]&536870920&&n(3,q=je?q:h.y),l.$$.dirty[0]&536870928&&n(4,G=oe?G:h.series),l.$$.dirty[0]&603979776&&n(26,v=v??h.size),l.$$.dirty[0]&536871040&&n(7,me=me??h.tooltipTitle),l.$$.dirty[0]&52428856&&(!G&&typeof q!="object"?(n(5,B=B??at(q,R[q].title)),se=!1):(n(25,_=ka(_,r,q,G)),se=!0)),l.$$.dirty[0]&402811392&&n(23,D={type:"scatter",label:{show:!1},labelLayout:{hideOverlap:!0},emphasis:{focus:"item"},symbol:Oe,symbolSize:Se,itemStyle:{color:X,opacity:Ce,borderColor:Ne,borderWidth:de},...ye}),l.$$.dirty[0]&8388864&&P&&n(23,D={...D,...P}),l.$$.dirty[0]&65372344&&n(20,I=ha(_,r,q,G,m,D,B,i,R,z,void 0,me,void 0,Re)),l.$$.dirty[0]&1048576&&Me.update(S=>(S.series.push(...I),S.legend.data.push(...I.map(K=>K.name.toString())),S)),l.$$.dirty[0]&524288&&(F={yAxis:{scale:!0,boundaryGap:["1%","1%"]},xAxis:{boundaryGap:[c==="time"?"2%":"1%","2%"]}})},[o,e,W,q,G,B,Q,me,P,Oe,ue,Ce,V,de,Se,z,Re,ye,m,c,I,R,i,D,r,_,v,Ne,X,h]}class Pa extends Dt{constructor(t){super(),pt(this,t,Va,null,vt,{y:3,series:4,options:8,name:5,shape:9,fillColor:10,opacity:11,outlineColor:12,outlineWidth:13,pointSize:14,useTooltip:6,tooltipTitle:7,seriesOrder:15,seriesLabelFmt:16},null,[-1,-1])}}function Ya(l){let t,n,e;t=new Pa({props:{shape:l[26],fillColor:l[49],opacity:l[27],outlineColor:l[48],outlineWidth:l[28],pointSize:l[29],useTooltip:za,seriesOrder:l[41],seriesLabelFmt:l[43]}});const o=l[54].default,_=ma(o,l,l[55],null);return{c(){L(t.$$.fragment),n=g(),_&&_.c()},l(r){C(t.$$.fragment,r),n=M(r),_&&_.l(r)},m(r,m){O(t,r,m),f(r,n,m),_&&_.m(r,m),e=!0},p(r,m){const c={};m[0]&67108864&&(c.shape=r[26]),m[1]&262144&&(c.fillColor=r[49]),m[0]&134217728&&(c.opacity=r[27]),m[1]&131072&&(c.outlineColor=r[48]),m[0]&268435456&&(c.outlineWidth=r[28]),m[0]&536870912&&(c.pointSize=r[29]),m[1]&1024&&(c.seriesOrder=r[41]),m[1]&4096&&(c.seriesLabelFmt=r[43]),t.$set(c),_&&_.p&&(!e||m[1]&16777216)&&sa(_,o,r,r[55],e?fa(o,r[55],m,null):Ea(r[55]),null)},i(r){e||(d(t.$$.fragment,r),d(_,r),e=!0)},o(r){y(t.$$.fragment,r),y(_,r),e=!1},d(r){r&&E(n),b(t,r),_&&_.d(r)}}}function Xa(l){let t,n;return t=new Ia({props:{data:l[0],x:l[1],y:l[2],xFmt:l[8],yFmt:l[7],series:l[3],tooltipTitle:l[32],xType:l[4],yLog:l[5],yLogBase:l[6],legend:l[11],xAxisTitle:l[12],yAxisTitle:l[13],xGridlines:l[14],yGridlines:l[15],xAxisLabels:l[16],yAxisLabels:l[17],xBaseline:l[18],yBaseline:l[19],xTickMarks:l[20],yTickMarks:l[21],xMin:l[22],xMax:l[23],yMin:l[24],yMax:l[25],title:l[9],subtitle:l[10],chartType:Ga,sort:l[31],chartAreaHeight:l[30],colorPalette:l[47],echartsOptions:l[33],seriesOptions:l[34],printEchartsConfig:l[35],emptySet:l[36],emptyMessage:l[37],renderer:l[38],downloadableData:l[39],downloadableImage:l[40],connectGroup:l[42],seriesColors:l[46],leftPadding:l[44],rightPadding:l[45],$$slots:{default:[Ya]},$$scope:{ctx:l}}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&1&&(_.data=e[0]),o[0]&2&&(_.x=e[1]),o[0]&4&&(_.y=e[2]),o[0]&256&&(_.xFmt=e[8]),o[0]&128&&(_.yFmt=e[7]),o[0]&8&&(_.series=e[3]),o[1]&2&&(_.tooltipTitle=e[32]),o[0]&16&&(_.xType=e[4]),o[0]&32&&(_.yLog=e[5]),o[0]&64&&(_.yLogBase=e[6]),o[0]&2048&&(_.legend=e[11]),o[0]&4096&&(_.xAxisTitle=e[12]),o[0]&8192&&(_.yAxisTitle=e[13]),o[0]&16384&&(_.xGridlines=e[14]),o[0]&32768&&(_.yGridlines=e[15]),o[0]&65536&&(_.xAxisLabels=e[16]),o[0]&131072&&(_.yAxisLabels=e[17]),o[0]&262144&&(_.xBaseline=e[18]),o[0]&524288&&(_.yBaseline=e[19]),o[0]&1048576&&(_.xTickMarks=e[20]),o[0]&2097152&&(_.yTickMarks=e[21]),o[0]&4194304&&(_.xMin=e[22]),o[0]&8388608&&(_.xMax=e[23]),o[0]&16777216&&(_.yMin=e[24]),o[0]&33554432&&(_.yMax=e[25]),o[0]&512&&(_.title=e[9]),o[0]&1024&&(_.subtitle=e[10]),o[1]&1&&(_.sort=e[31]),o[0]&1073741824&&(_.chartAreaHeight=e[30]),o[1]&65536&&(_.colorPalette=e[47]),o[1]&4&&(_.echartsOptions=e[33]),o[1]&8&&(_.seriesOptions=e[34]),o[1]&16&&(_.printEchartsConfig=e[35]),o[1]&32&&(_.emptySet=e[36]),o[1]&64&&(_.emptyMessage=e[37]),o[1]&128&&(_.renderer=e[38]),o[1]&256&&(_.downloadableData=e[39]),o[1]&512&&(_.downloadableImage=e[40]),o[1]&2048&&(_.connectGroup=e[42]),o[1]&32768&&(_.seriesColors=e[46]),o[1]&8192&&(_.leftPadding=e[44]),o[1]&16384&&(_.rightPadding=e[45]),o[0]&1006632960|o[1]&17175552&&(_.$$scope={dirty:o,ctx:e}),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}let Ga="Scatter Plot",za=!0;function ja(l,t,n){let e,o,_,r,{$$slots:m={},$$scope:c}=t;const{resolveColor:A,resolveColorsObject:N,resolveColorPalette:i}=Sa();let{data:R=void 0}=t,{x:v=void 0}=t,{y:D=void 0}=t,{series:I=void 0}=t,{xType:F=void 0}=t,{yLog:Ne=void 0}=t,{yLogBase:w=void 0}=t,{yFmt:fe=void 0}=t,{xFmt:X=void 0}=t,{title:be=void 0}=t,{subtitle:pe=void 0}=t,{legend:h=void 0}=t,{xAxisTitle:W="true"}=t,{yAxisTitle:Me="true"}=t,{xGridlines:ge=void 0}=t,{yGridlines:q=void 0}=t,{xAxisLabels:je=void 0}=t,{yAxisLabels:G=void 0}=t,{xBaseline:oe=void 0}=t,{yBaseline:P=void 0}=t,{xTickMarks:B=void 0}=t,{yTickMarks:Oe=void 0}=t,{xMin:ue=void 0}=t,{xMax:Ce=void 0}=t,{yMin:V=void 0}=t,{yMax:de=void 0}=t,{shape:Se=void 0}=t,{fillColor:Q=void 0}=t,{opacity:me=void 0}=t,{outlineColor:z=void 0}=t,{outlineWidth:Re=void 0}=t,{pointSize:se=void 0}=t,{chartAreaHeight:j=void 0}=t,{sort:ye=void 0}=t,{tooltipTitle:Ee=void 0}=t,{colorPalette:S="default"}=t,{echartsOptions:K=void 0}=t,{seriesOptions:ke=void 0}=t,{printEchartsConfig:he=!1}=t,{emptySet:Ve=void 0}=t,{emptyMessage:Ke=void 0}=t,{renderer:ce=void 0}=t,{downloadableData:Ie=void 0}=t,{downloadableImage:Le=void 0}=t,{seriesColors:Ae=void 0}=t,{seriesOrder:He=void 0}=t,{connectGroup:Qe=void 0}=t,{seriesLabelFmt:ve=void 0}=t,{leftPadding:Fe=void 0}=t,{rightPadding:De=void 0}=t;return l.$$set=s=>{"data"in s&&n(0,R=s.data),"x"in s&&n(1,v=s.x),"y"in s&&n(2,D=s.y),"series"in s&&n(3,I=s.series),"xType"in s&&n(4,F=s.xType),"yLog"in s&&n(5,Ne=s.yLog),"yLogBase"in s&&n(6,w=s.yLogBase),"yFmt"in s&&n(7,fe=s.yFmt),"xFmt"in s&&n(8,X=s.xFmt),"title"in s&&n(9,be=s.title),"subtitle"in s&&n(10,pe=s.subtitle),"legend"in s&&n(11,h=s.legend),"xAxisTitle"in s&&n(12,W=s.xAxisTitle),"yAxisTitle"in s&&n(13,Me=s.yAxisTitle),"xGridlines"in s&&n(14,ge=s.xGridlines),"yGridlines"in s&&n(15,q=s.yGridlines),"xAxisLabels"in s&&n(16,je=s.xAxisLabels),"yAxisLabels"in s&&n(17,G=s.yAxisLabels),"xBaseline"in s&&n(18,oe=s.xBaseline),"yBaseline"in s&&n(19,P=s.yBaseline),"xTickMarks"in s&&n(20,B=s.xTickMarks),"yTickMarks"in s&&n(21,Oe=s.yTickMarks),"xMin"in s&&n(22,ue=s.xMin),"xMax"in s&&n(23,Ce=s.xMax),"yMin"in s&&n(24,V=s.yMin),"yMax"in s&&n(25,de=s.yMax),"shape"in s&&n(26,Se=s.shape),"fillColor"in s&&n(50,Q=s.fillColor),"opacity"in s&&n(27,me=s.opacity),"outlineColor"in s&&n(51,z=s.outlineColor),"outlineWidth"in s&&n(28,Re=s.outlineWidth),"pointSize"in s&&n(29,se=s.pointSize),"chartAreaHeight"in s&&n(30,j=s.chartAreaHeight),"sort"in s&&n(31,ye=s.sort),"tooltipTitle"in s&&n(32,Ee=s.tooltipTitle),"colorPalette"in s&&n(52,S=s.colorPalette),"echartsOptions"in s&&n(33,K=s.echartsOptions),"seriesOptions"in s&&n(34,ke=s.seriesOptions),"printEchartsConfig"in s&&n(35,he=s.printEchartsConfig),"emptySet"in s&&n(36,Ve=s.emptySet),"emptyMessage"in s&&n(37,Ke=s.emptyMessage),"renderer"in s&&n(38,ce=s.renderer),"downloadableData"in s&&n(39,Ie=s.downloadableData),"downloadableImage"in s&&n(40,Le=s.downloadableImage),"seriesColors"in s&&n(53,Ae=s.seriesColors),"seriesOrder"in s&&n(41,He=s.seriesOrder),"connectGroup"in s&&n(42,Qe=s.connectGroup),"seriesLabelFmt"in s&&n(43,ve=s.seriesLabelFmt),"leftPadding"in s&&n(44,Fe=s.leftPadding),"rightPadding"in s&&n(45,De=s.rightPadding),"$$scope"in s&&n(55,c=s.$$scope)},l.$$.update=()=>{l.$$.dirty[1]&524288&&n(49,e=A(Q)),l.$$.dirty[1]&1048576&&n(48,o=A(z)),l.$$.dirty[1]&2097152&&n(47,_=i(S)),l.$$.dirty[1]&4194304&&n(46,r=N(Ae))},[R,v,D,I,F,Ne,w,fe,X,be,pe,h,W,Me,ge,q,je,G,oe,P,B,Oe,ue,Ce,V,de,Se,me,Re,se,j,ye,Ee,K,ke,he,Ve,Ke,ce,Ie,Le,He,Qe,ve,Fe,De,r,_,o,e,Q,z,S,Ae,m,c]}class Ka extends Dt{constructor(t){super(),pt(this,t,ja,Xa,vt,{data:0,x:1,y:2,series:3,xType:4,yLog:5,yLogBase:6,yFmt:7,xFmt:8,title:9,subtitle:10,legend:11,xAxisTitle:12,yAxisTitle:13,xGridlines:14,yGridlines:15,xAxisLabels:16,yAxisLabels:17,xBaseline:18,yBaseline:19,xTickMarks:20,yTickMarks:21,xMin:22,xMax:23,yMin:24,yMax:25,shape:26,fillColor:50,opacity:27,outlineColor:51,outlineWidth:28,pointSize:29,chartAreaHeight:30,sort:31,tooltipTitle:32,colorPalette:52,echartsOptions:33,seriesOptions:34,printEchartsConfig:35,emptySet:36,emptyMessage:37,renderer:38,downloadableData:39,downloadableImage:40,seriesColors:53,seriesOrder:41,connectGroup:42,seriesLabelFmt:43,leftPadding:44,rightPadding:45},null,[-1,-1])}}function Qa(l){let t,n=k.title+"",e;return{c(){t=U("h1"),e=Na(n),this.h()},l(o){t=p(o,"H1",{class:!0});var _=Lt(t);e=Ta(_,n),_.forEach(E),this.h()},h(){T(t,"class","title")},m(o,_){f(o,t,_),Et(t,e)},p:ze,d(o){o&&E(t)}}}function xa(l){return{c(){this.h()},l(t){this.h()},h(){document.title="Evidence"},m:ze,p:ze,d:ze}}function Ja(l){let t,n,e,o,_;return document.title=t=k.title,{c(){n=g(),e=U("meta"),o=g(),_=U("meta"),this.h()},l(r){n=M(r),e=p(r,"META",{property:!0,content:!0}),o=M(r),_=p(r,"META",{name:!0,content:!0}),this.h()},h(){var r,m;T(e,"property","og:title"),T(e,"content",((r=k.og)==null?void 0:r.title)??k.title),T(_,"name","twitter:title"),T(_,"content",((m=k.og)==null?void 0:m.title)??k.title)},m(r,m){f(r,n,m),f(r,e,m),f(r,o,m),f(r,_,m)},p(r,m){m&0&&t!==(t=k.title)&&(document.title=t)},d(r){r&&(E(n),E(e),E(o),E(_))}}}function Za(l){var _,r;let t,n,e=(k.description||((_=k.og)==null?void 0:_.description))&&$a(),o=((r=k.og)==null?void 0:r.image)&&en();return{c(){e&&e.c(),t=g(),o&&o.c(),n=Ht()},l(m){e&&e.l(m),t=M(m),o&&o.l(m),n=Ht()},m(m,c){e&&e.m(m,c),f(m,t,c),o&&o.m(m,c),f(m,n,c)},p(m,c){var A,N;(k.description||(A=k.og)!=null&&A.description)&&e.p(m,c),(N=k.og)!=null&&N.image&&o.p(m,c)},d(m){m&&(E(t),E(n)),e&&e.d(m),o&&o.d(m)}}}function $a(l){let t,n,e,o,_;return{c(){t=U("meta"),n=g(),e=U("meta"),o=g(),_=U("meta"),this.h()},l(r){t=p(r,"META",{name:!0,content:!0}),n=M(r),e=p(r,"META",{property:!0,content:!0}),o=M(r),_=p(r,"META",{name:!0,content:!0}),this.h()},h(){var r,m,c;T(t,"name","description"),T(t,"content",k.description??((r=k.og)==null?void 0:r.description)),T(e,"property","og:description"),T(e,"content",((m=k.og)==null?void 0:m.description)??k.description),T(_,"name","twitter:description"),T(_,"content",((c=k.og)==null?void 0:c.description)??k.description)},m(r,m){f(r,t,m),f(r,n,m),f(r,e,m),f(r,o,m),f(r,_,m)},p:ze,d(r){r&&(E(t),E(n),E(e),E(o),E(_))}}}function en(l){let t,n,e;return{c(){t=U("meta"),n=g(),e=U("meta"),this.h()},l(o){t=p(o,"META",{property:!0,content:!0}),n=M(o),e=p(o,"META",{name:!0,content:!0}),this.h()},h(){var o,_;T(t,"property","og:image"),T(t,"content",xt((o=k.og)==null?void 0:o.image)),T(e,"name","twitter:image"),T(e,"content",xt((_=k.og)==null?void 0:_.image))},m(o,_){f(o,t,_),f(o,n,_),f(o,e,_)},p:ze,d(o){o&&(E(t),E(n),E(e))}}}function $t(l){let t,n;return t=new $e({props:{queryID:"summary_menu",queryResult:l[0]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&1&&(_.queryResult=e[0]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function ea(l){let t,n;return t=new $e({props:{queryID:"best_menu_30d",queryResult:l[1]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&2&&(_.queryResult=e[1]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function ta(l){let t,n;return t=new $e({props:{queryID:"best_revenue_30d",queryResult:l[2]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&4&&(_.queryResult=e[2]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function aa(l){let t,n;return t=new $e({props:{queryID:"menu_engineering",queryResult:l[3]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&8&&(_.queryResult=e[3]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function na(l){let t,n;return t=new $e({props:{queryID:"menu_engineering_table",queryResult:l[4]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&16&&(_.queryResult=e[4]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function tn(l){let t,n,e,o,_,r,m,c,A,N;return t=new ie({props:{id:"klasifikasi",title:"Klasifikasi"}}),e=new ie({props:{id:"menu_name",title:"Menu"}}),_=new ie({props:{id:"category",title:"Kategori"}}),m=new ie({props:{id:"total_qty",title:"Volume Terjual",fmt:"#,##0"}}),A=new ie({props:{id:"total_revenue",title:"Total Revenue (Rp)",fmt:"#,##0"}}),{c(){L(t.$$.fragment),n=g(),L(e.$$.fragment),o=g(),L(_.$$.fragment),r=g(),L(m.$$.fragment),c=g(),L(A.$$.fragment)},l(i){C(t.$$.fragment,i),n=M(i),C(e.$$.fragment,i),o=M(i),C(_.$$.fragment,i),r=M(i),C(m.$$.fragment,i),c=M(i),C(A.$$.fragment,i)},m(i,R){O(t,i,R),f(i,n,R),O(e,i,R),f(i,o,R),O(_,i,R),f(i,r,R),O(m,i,R),f(i,c,R),O(A,i,R),N=!0},p:ze,i(i){N||(d(t.$$.fragment,i),d(e.$$.fragment,i),d(_.$$.fragment,i),d(m.$$.fragment,i),d(A.$$.fragment,i),N=!0)},o(i){y(t.$$.fragment,i),y(e.$$.fragment,i),y(_.$$.fragment,i),y(m.$$.fragment,i),y(A.$$.fragment,i),N=!1},d(i){i&&(E(n),E(o),E(r),E(c)),b(t,i),b(e,i),b(_,i),b(m,i),b(A,i)}}}function ra(l){let t,n;return t=new $e({props:{queryID:"top_by_volume",queryResult:l[5]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&32&&(_.queryResult=e[5]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function la(l){let t,n;return t=new $e({props:{queryID:"top_by_revenue",queryResult:l[6]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&64&&(_.queryResult=e[6]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function an(l){let t,n,e='<a href="#top-10-by-volume">Top 10 by Volume</a>',o,_,r,m,c,A='<a href="#top-10-by-revenue">Top 10 by Revenue</a>',N,i,R;return _=new Zt({props:{data:l[5],x:"menu_name",y:"total_qty",swapXY:"true",title:"Menu Terlaris",xAxisTitle:"Total Terjual",colorPalette:["#4f86c6"]}}),i=new Zt({props:{data:l[6],x:"menu_name",y:"total_revenue",swapXY:"true",title:"Menu Penggerak Revenue (Rp)",yFmt:"#,##0",xAxisTitle:"Total Revenue (Rp)",colorPalette:["#e07b39"]}}),{c(){t=U("div"),n=U("h3"),n.innerHTML=e,o=g(),L(_.$$.fragment),r=g(),m=U("div"),c=U("h3"),c.innerHTML=A,N=g(),L(i.$$.fragment),this.h()},l(v){t=p(v,"DIV",{});var D=Lt(t);n=p(D,"H3",{class:!0,id:!0,"data-svelte-h":!0}),Te(n)!=="svelte-1lmutg7"&&(n.innerHTML=e),o=M(D),C(_.$$.fragment,D),D.forEach(E),r=M(v),m=p(v,"DIV",{});var I=Lt(m);c=p(I,"H3",{class:!0,id:!0,"data-svelte-h":!0}),Te(c)!=="svelte-1l84rpf"&&(c.innerHTML=A),N=M(I),C(i.$$.fragment,I),I.forEach(E),this.h()},h(){T(n,"class","markdown"),T(n,"id","top-10-by-volume"),T(c,"class","markdown"),T(c,"id","top-10-by-revenue")},m(v,D){f(v,t,D),Et(t,n),Et(t,o),O(_,t,null),f(v,r,D),f(v,m,D),Et(m,c),Et(m,N),O(i,m,null),R=!0},p(v,D){const I={};D[0]&32&&(I.data=v[5]),_.$set(I);const F={};D[0]&64&&(F.data=v[6]),i.$set(F)},i(v){R||(d(_.$$.fragment,v),d(i.$$.fragment,v),R=!0)},o(v){y(_.$$.fragment,v),y(i.$$.fragment,v),R=!1},d(v){v&&(E(t),E(r),E(m)),b(_),b(i)}}}function _a(l){let t,n;return t=new $e({props:{queryID:"andalan_per_cabang",queryResult:l[7]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&128&&(_.queryResult=e[7]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function nn(l){let t,n,e,o,_,r,m,c,A,N;return t=new ie({props:{id:"branch_name",title:"Cabang"}}),e=new ie({props:{id:"top_volume_menu",title:"Menu Terlaris"}}),_=new ie({props:{id:"top_volume_qty",title:"Qty Terjual",fmt:"#,##0"}}),m=new ie({props:{id:"top_revenue_menu",title:"Menu Revenue Terbesar"}}),A=new ie({props:{id:"top_revenue_value",title:"Revenue (Rp)",fmt:"#,##0"}}),{c(){L(t.$$.fragment),n=g(),L(e.$$.fragment),o=g(),L(_.$$.fragment),r=g(),L(m.$$.fragment),c=g(),L(A.$$.fragment)},l(i){C(t.$$.fragment,i),n=M(i),C(e.$$.fragment,i),o=M(i),C(_.$$.fragment,i),r=M(i),C(m.$$.fragment,i),c=M(i),C(A.$$.fragment,i)},m(i,R){O(t,i,R),f(i,n,R),O(e,i,R),f(i,o,R),O(_,i,R),f(i,r,R),O(m,i,R),f(i,c,R),O(A,i,R),N=!0},p:ze,i(i){N||(d(t.$$.fragment,i),d(e.$$.fragment,i),d(_.$$.fragment,i),d(m.$$.fragment,i),d(A.$$.fragment,i),N=!0)},o(i){y(t.$$.fragment,i),y(e.$$.fragment,i),y(_.$$.fragment,i),y(m.$$.fragment,i),y(A.$$.fragment,i),N=!1},d(i){i&&(E(n),E(o),E(r),E(c)),b(t,i),b(e,i),b(_,i),b(m,i),b(A,i)}}}function ia(l){let t,n;return t=new $e({props:{queryID:"menu_wow",queryResult:l[8]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&256&&(_.queryResult=e[8]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function rn(l){let t,n,e,o,_,r,m,c,A,N;return t=new ie({props:{id:"menu_name",title:"Menu"}}),e=new ie({props:{id:"category",title:"Kategori"}}),_=new ie({props:{id:"qty_minggu_ini",title:"Minggu Ini",fmt:"#,##0"}}),m=new ie({props:{id:"qty_minggu_lalu",title:"Minggu Lalu",fmt:"#,##0"}}),A=new ie({props:{id:"pct_change",title:"Perubahan (%)",fmt:"+0.0;-0.0",contentType:"delta"}}),{c(){L(t.$$.fragment),n=g(),L(e.$$.fragment),o=g(),L(_.$$.fragment),r=g(),L(m.$$.fragment),c=g(),L(A.$$.fragment)},l(i){C(t.$$.fragment,i),n=M(i),C(e.$$.fragment,i),o=M(i),C(_.$$.fragment,i),r=M(i),C(m.$$.fragment,i),c=M(i),C(A.$$.fragment,i)},m(i,R){O(t,i,R),f(i,n,R),O(e,i,R),f(i,o,R),O(_,i,R),f(i,r,R),O(m,i,R),f(i,c,R),O(A,i,R),N=!0},p:ze,i(i){N||(d(t.$$.fragment,i),d(e.$$.fragment,i),d(_.$$.fragment,i),d(m.$$.fragment,i),d(A.$$.fragment,i),N=!0)},o(i){y(t.$$.fragment,i),y(e.$$.fragment,i),y(_.$$.fragment,i),y(m.$$.fragment,i),y(A.$$.fragment,i),N=!1},d(i){i&&(E(n),E(o),E(r),E(c)),b(t,i),b(e,i),b(_,i),b(m,i),b(A,i)}}}function oa(l){let t,n;return t=new $e({props:{queryID:"declining_trend",queryResult:l[9]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&512&&(_.queryResult=e[9]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function ua(l){let t,n;return t=new $e({props:{queryID:"declining_by_branch",queryResult:l[10]}}),{c(){L(t.$$.fragment)},l(e){C(t.$$.fragment,e)},m(e,o){O(t,e,o),n=!0},p(e,o){const _={};o[0]&1024&&(_.queryResult=e[10]),t.$set(_)},i(e){n||(d(t.$$.fragment,e),n=!0)},o(e){y(t.$$.fragment,e),n=!1},d(e){b(t,e)}}}function ln(l){let t,n,e,o,_,r,m,c,A,N;return t=new ie({props:{id:"branch_name",title:"Cabang"}}),e=new ie({props:{id:"menu_name",title:"Menu"}}),_=new ie({props:{id:"qty_30_awal",title:"30 Hari Pertama",fmt:"#,##0"}}),m=new ie({props:{id:"qty_30_akhir",title:"30 Hari Terakhir",fmt:"#,##0"}}),A=new ie({props:{id:"pct_change",title:"Perubahan (%)",fmt:"+0.0;-0.0",contentType:"delta"}}),{c(){L(t.$$.fragment),n=g(),L(e.$$.fragment),o=g(),L(_.$$.fragment),r=g(),L(m.$$.fragment),c=g(),L(A.$$.fragment)},l(i){C(t.$$.fragment,i),n=M(i),C(e.$$.fragment,i),o=M(i),C(_.$$.fragment,i),r=M(i),C(m.$$.fragment,i),c=M(i),C(A.$$.fragment,i)},m(i,R){O(t,i,R),f(i,n,R),O(e,i,R),f(i,o,R),O(_,i,R),f(i,r,R),O(m,i,R),f(i,c,R),O(A,i,R),N=!0},p:ze,i(i){N||(d(t.$$.fragment,i),d(e.$$.fragment,i),d(_.$$.fragment,i),d(m.$$.fragment,i),d(A.$$.fragment,i),N=!0)},o(i){y(t.$$.fragment,i),y(e.$$.fragment,i),y(_.$$.fragment,i),y(m.$$.fragment,i),y(A.$$.fragment,i),N=!1},d(i){i&&(E(n),E(o),E(r),E(c)),b(t,i),b(e,i),b(_,i),b(m,i),b(A,i)}}}function _n(l){let t,n,e,o,_,r,m='<em class="markdown">Analisis penjualan, tren, dan potensi menu restoran.</em>',c,A,N,i,R,v,D,I,F,Ne,w,fe,X,be,pe,h,W,Me='<a href="#menu-engineering--klasifikasi-menu-30-hari-terakhir">Menu Engineering — Klasifikasi Menu (30 Hari Terakhir)</a>',ge,q,je='<em class="markdown">Wekadata otomatis mengklasifikasikan menu kamu pakai framework Menu Engineering yang sama yang dipakai restoran bintang lima — tanpa kamu harus hitung manual.</em>',G,oe,P,B,Oe,ue,Ce,V,de='<em class="markdown"><strong class="markdown">Stars</strong> — volume &amp; revenue tinggi, pertahankan kualitas. <strong class="markdown">Puzzles</strong> — revenue tinggi tapi kurang laku, promosikan lebih agresif. <strong class="markdown">Plowhorses</strong> — laris tapi revenue kecil, naikkan harga atau buat bundling. <strong class="markdown">Dogs</strong> — volume &amp; revenue rendah, pertimbangkan hapus dari menu.</em>',Se,Q,me,z,Re='<a href="#volume-terjual-vs-kontribusi-revenue-30-hari-terakhir">Volume Terjual vs Kontribusi Revenue (30 Hari Terakhir)</a>',se,j,ye,Ee,S,K,ke='<em class="markdown">Menu terlaris belum tentu penggerak revenue terbesar. Menu murah yang sering dipesan bisa jadi tidak banyak menggerakkan omset — pertimbangkan strategi upselling atau bundling untuk mendorong revenue dari menu-menu tersebut.</em>',he,Ve,Ke,ce,Ie='<a href="#andalan-per-cabang-30-hari-terakhir">Andalan per Cabang (30 Hari Terakhir)</a>',Le,Ae,He,Qe,ve,Fe='<em class="markdown">Tiap cabang punya karakter pelanggan yang berbeda. Menu andalan yang berbeda antar cabang bisa jadi dasar strategi stok, promo, dan pelatihan staf yang lebih tepat sasaran.</em>',De,s,_t,we,ft='<a href="#tren-menu--perbandingan-minggu-ini-vs-minggu-lalu">Tren Menu — Perbandingan Minggu Ini vs Minggu Lalu</a>',Pe,Ue,qe,it,Ye,dt='<em class="markdown">Perbandingan langsung antara minggu ini dan minggu lalu — menu dengan tanda merah perlu perhatian segera.</em>',Xe,We,et,Be,St='<a href="#menu-dengan-tren-menurun-90-hari-terakhir">Menu dengan Tren Menurun (90 Hari Terakhir)</a>',ot,H,tt,ct,ut,Ft='<em class="markdown">Grafik menunjukkan tren penjualan harian menu dengan penurunan konsisten dalam 90 hari terakhir.</em>',At,yt,Tt,nt,wt='<a href="#detail-penurunan-per-cabang">Detail Penurunan per Cabang</a>',Nt,Rt,mt,bt,st,Wt='<em class="markdown">Menu di atas mengalami penurunan dalam 90 hari terakhir. Cek per cabang untuk tindakan yang lebih tepat sasaran.</em>',Ot,rt=typeof k<"u"&&k.title&&k.hide_title!==!0&&Qa();function Ra(a,u){return typeof k<"u"&&k.title?Ja:xa}let Mt=Ra()(l),lt=typeof k=="object"&&Za(),x=l[0]&&$t(l),J=l[1]&&ea(l),Z=l[2]&&ta(l);R=new gt({props:{data:l[1],value:"menu_name",title:"Menu Terlaris (30 Hari Terakhir)"}}),D=new gt({props:{data:l[1],value:"total_qty",title:"Total Terjual",fmt:"#,##0"}}),F=new gt({props:{data:l[2],value:"menu_name",title:"Menu Penggerak Revenue (30 Hari Terakhir)"}}),w=new gt({props:{data:l[2],value:"total_revenue",title:"Total Revenue Menu Tersebut (Rp)",fmt:"#,##0"}}),X=new gt({props:{data:l[0],value:"total_menu",title:"Total Menu Aktif"}});let $=l[3]&&aa(l),ee=l[4]&&na(l);B=new Ka({props:{data:l[3],x:"total_qty",y:"total_revenue",series:"klasifikasi",pointName:"menu_name",xAxisTitle:"Volume Terjual",yAxisTitle:"Total Revenue (Rp)",title:"Menu Engineering — Volume vs Revenue",yFmt:"#,##0"}}),ue=new Ct({props:{data:l[4],$$slots:{default:[tn]},$$scope:{ctx:l}}});let te=l[5]&&ra(l),ae=l[6]&&la(l);Ee=new Ba({props:{cols:"2",$$slots:{default:[an]},$$scope:{ctx:l}}});let ne=l[7]&&_a(l);He=new Ct({props:{data:l[7],$$slots:{default:[nn]},$$scope:{ctx:l}}});let re=l[8]&&ia(l);qe=new Ct({props:{data:l[8],$$slots:{default:[rn]},$$scope:{ctx:l}}});let le=l[9]&&oa(l);tt=new Fa({props:{data:l[9],x:"order_date",y:"qty_harian",series:"menu_name",title:"Menu dengan Tren Penjualan Menurun (90 Hari)",xAxisTitle:"Tanggal",yAxisTitle:"Qty Terjual per Hari"}});let _e=l[10]&&ua(l);return mt=new Ct({props:{data:l[10],$$slots:{default:[ln]},$$scope:{ctx:l}}}),{c(){rt&&rt.c(),t=g(),Mt.c(),n=U("meta"),e=U("meta"),lt&&lt.c(),o=Ht(),_=g(),r=U("p"),r.innerHTML=m,c=g(),x&&x.c(),A=g(),J&&J.c(),N=g(),Z&&Z.c(),i=g(),L(R.$$.fragment),v=g(),L(D.$$.fragment),I=g(),L(F.$$.fragment),Ne=g(),L(w.$$.fragment),fe=g(),L(X.$$.fragment),be=g(),pe=U("hr"),h=g(),W=U("h2"),W.innerHTML=Me,ge=g(),q=U("p"),q.innerHTML=je,G=g(),$&&$.c(),oe=g(),ee&&ee.c(),P=g(),L(B.$$.fragment),Oe=g(),L(ue.$$.fragment),Ce=g(),V=U("p"),V.innerHTML=de,Se=g(),Q=U("hr"),me=g(),z=U("h2"),z.innerHTML=Re,se=g(),te&&te.c(),j=g(),ae&&ae.c(),ye=g(),L(Ee.$$.fragment),S=g(),K=U("p"),K.innerHTML=ke,he=g(),Ve=U("hr"),Ke=g(),ce=U("h2"),ce.innerHTML=Ie,Le=g(),ne&&ne.c(),Ae=g(),L(He.$$.fragment),Qe=g(),ve=U("p"),ve.innerHTML=Fe,De=g(),s=U("hr"),_t=g(),we=U("h2"),we.innerHTML=ft,Pe=g(),re&&re.c(),Ue=g(),L(qe.$$.fragment),it=g(),Ye=U("p"),Ye.innerHTML=dt,Xe=g(),We=U("hr"),et=g(),Be=U("h2"),Be.innerHTML=St,ot=g(),le&&le.c(),H=g(),L(tt.$$.fragment),ct=g(),ut=U("p"),ut.innerHTML=Ft,At=g(),yt=U("hr"),Tt=g(),nt=U("h3"),nt.innerHTML=wt,Nt=g(),_e&&_e.c(),Rt=g(),L(mt.$$.fragment),bt=g(),st=U("p"),st.innerHTML=Wt,this.h()},l(a){rt&&rt.l(a),t=M(a);const u=Ma("svelte-2igo1p",document.head);Mt.l(u),n=p(u,"META",{name:!0,content:!0}),e=p(u,"META",{name:!0,content:!0}),lt&&lt.l(u),o=Ht(),u.forEach(E),_=M(a),r=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(r)!=="svelte-13futva"&&(r.innerHTML=m),c=M(a),x&&x.l(a),A=M(a),J&&J.l(a),N=M(a),Z&&Z.l(a),i=M(a),C(R.$$.fragment,a),v=M(a),C(D.$$.fragment,a),I=M(a),C(F.$$.fragment,a),Ne=M(a),C(w.$$.fragment,a),fe=M(a),C(X.$$.fragment,a),be=M(a),pe=p(a,"HR",{class:!0}),h=M(a),W=p(a,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Te(W)!=="svelte-1nl2wtc"&&(W.innerHTML=Me),ge=M(a),q=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(q)!=="svelte-yf34q7"&&(q.innerHTML=je),G=M(a),$&&$.l(a),oe=M(a),ee&&ee.l(a),P=M(a),C(B.$$.fragment,a),Oe=M(a),C(ue.$$.fragment,a),Ce=M(a),V=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(V)!=="svelte-17r9nzq"&&(V.innerHTML=de),Se=M(a),Q=p(a,"HR",{class:!0}),me=M(a),z=p(a,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Te(z)!=="svelte-1ekb6ji"&&(z.innerHTML=Re),se=M(a),te&&te.l(a),j=M(a),ae&&ae.l(a),ye=M(a),C(Ee.$$.fragment,a),S=M(a),K=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(K)!=="svelte-1wcz1rt"&&(K.innerHTML=ke),he=M(a),Ve=p(a,"HR",{class:!0}),Ke=M(a),ce=p(a,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Te(ce)!=="svelte-1g68gxc"&&(ce.innerHTML=Ie),Le=M(a),ne&&ne.l(a),Ae=M(a),C(He.$$.fragment,a),Qe=M(a),ve=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(ve)!=="svelte-ghds5m"&&(ve.innerHTML=Fe),De=M(a),s=p(a,"HR",{class:!0}),_t=M(a),we=p(a,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Te(we)!=="svelte-t7h7u2"&&(we.innerHTML=ft),Pe=M(a),re&&re.l(a),Ue=M(a),C(qe.$$.fragment,a),it=M(a),Ye=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(Ye)!=="svelte-irb2tv"&&(Ye.innerHTML=dt),Xe=M(a),We=p(a,"HR",{class:!0}),et=M(a),Be=p(a,"H2",{class:!0,id:!0,"data-svelte-h":!0}),Te(Be)!=="svelte-1gqtk1f"&&(Be.innerHTML=St),ot=M(a),le&&le.l(a),H=M(a),C(tt.$$.fragment,a),ct=M(a),ut=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(ut)!=="svelte-1xp0qbm"&&(ut.innerHTML=Ft),At=M(a),yt=p(a,"HR",{class:!0}),Tt=M(a),nt=p(a,"H3",{class:!0,id:!0,"data-svelte-h":!0}),Te(nt)!=="svelte-1kno4ug"&&(nt.innerHTML=wt),Nt=M(a),_e&&_e.l(a),Rt=M(a),C(mt.$$.fragment,a),bt=M(a),st=p(a,"P",{class:!0,"data-svelte-h":!0}),Te(st)!=="svelte-eol5ig"&&(st.innerHTML=Wt),this.h()},h(){T(n,"name","twitter:card"),T(n,"content","summary_large_image"),T(e,"name","twitter:site"),T(e,"content","@evidence_dev"),T(r,"class","markdown"),T(pe,"class","markdown"),T(W,"class","markdown"),T(W,"id","menu-engineering--klasifikasi-menu-30-hari-terakhir"),T(q,"class","markdown"),T(V,"class","markdown"),T(Q,"class","markdown"),T(z,"class","markdown"),T(z,"id","volume-terjual-vs-kontribusi-revenue-30-hari-terakhir"),T(K,"class","markdown"),T(Ve,"class","markdown"),T(ce,"class","markdown"),T(ce,"id","andalan-per-cabang-30-hari-terakhir"),T(ve,"class","markdown"),T(s,"class","markdown"),T(we,"class","markdown"),T(we,"id","tren-menu--perbandingan-minggu-ini-vs-minggu-lalu"),T(Ye,"class","markdown"),T(We,"class","markdown"),T(Be,"class","markdown"),T(Be,"id","menu-dengan-tren-menurun-90-hari-terakhir"),T(ut,"class","markdown"),T(yt,"class","markdown"),T(nt,"class","markdown"),T(nt,"id","detail-penurunan-per-cabang"),T(st,"class","markdown")},m(a,u){rt&&rt.m(a,u),f(a,t,u),Mt.m(document.head,null),Et(document.head,n),Et(document.head,e),lt&&lt.m(document.head,null),Et(document.head,o),f(a,_,u),f(a,r,u),f(a,c,u),x&&x.m(a,u),f(a,A,u),J&&J.m(a,u),f(a,N,u),Z&&Z.m(a,u),f(a,i,u),O(R,a,u),f(a,v,u),O(D,a,u),f(a,I,u),O(F,a,u),f(a,Ne,u),O(w,a,u),f(a,fe,u),O(X,a,u),f(a,be,u),f(a,pe,u),f(a,h,u),f(a,W,u),f(a,ge,u),f(a,q,u),f(a,G,u),$&&$.m(a,u),f(a,oe,u),ee&&ee.m(a,u),f(a,P,u),O(B,a,u),f(a,Oe,u),O(ue,a,u),f(a,Ce,u),f(a,V,u),f(a,Se,u),f(a,Q,u),f(a,me,u),f(a,z,u),f(a,se,u),te&&te.m(a,u),f(a,j,u),ae&&ae.m(a,u),f(a,ye,u),O(Ee,a,u),f(a,S,u),f(a,K,u),f(a,he,u),f(a,Ve,u),f(a,Ke,u),f(a,ce,u),f(a,Le,u),ne&&ne.m(a,u),f(a,Ae,u),O(He,a,u),f(a,Qe,u),f(a,ve,u),f(a,De,u),f(a,s,u),f(a,_t,u),f(a,we,u),f(a,Pe,u),re&&re.m(a,u),f(a,Ue,u),O(qe,a,u),f(a,it,u),f(a,Ye,u),f(a,Xe,u),f(a,We,u),f(a,et,u),f(a,Be,u),f(a,ot,u),le&&le.m(a,u),f(a,H,u),O(tt,a,u),f(a,ct,u),f(a,ut,u),f(a,At,u),f(a,yt,u),f(a,Tt,u),f(a,nt,u),f(a,Nt,u),_e&&_e.m(a,u),f(a,Rt,u),O(mt,a,u),f(a,bt,u),f(a,st,u),Ot=!0},p(a,u){typeof k<"u"&&k.title&&k.hide_title!==!0&&rt.p(a,u),Mt.p(a,u),typeof k=="object"&&lt.p(a,u),a[0]?x?(x.p(a,u),u[0]&1&&d(x,1)):(x=$t(a),x.c(),d(x,1),x.m(A.parentNode,A)):x&&(Je(),y(x,1,1,()=>{x=null}),xe()),a[1]?J?(J.p(a,u),u[0]&2&&d(J,1)):(J=ea(a),J.c(),d(J,1),J.m(N.parentNode,N)):J&&(Je(),y(J,1,1,()=>{J=null}),xe()),a[2]?Z?(Z.p(a,u),u[0]&4&&d(Z,1)):(Z=ta(a),Z.c(),d(Z,1),Z.m(i.parentNode,i)):Z&&(Je(),y(Z,1,1,()=>{Z=null}),xe());const Bt={};u[0]&2&&(Bt.data=a[1]),R.$set(Bt);const Vt={};u[0]&2&&(Vt.data=a[1]),D.$set(Vt);const Pt={};u[0]&4&&(Pt.data=a[2]),F.$set(Pt);const Yt={};u[0]&4&&(Yt.data=a[2]),w.$set(Yt);const Xt={};u[0]&1&&(Xt.data=a[0]),X.$set(Xt),a[3]?$?($.p(a,u),u[0]&8&&d($,1)):($=aa(a),$.c(),d($,1),$.m(oe.parentNode,oe)):$&&(Je(),y($,1,1,()=>{$=null}),xe()),a[4]?ee?(ee.p(a,u),u[0]&16&&d(ee,1)):(ee=na(a),ee.c(),d(ee,1),ee.m(P.parentNode,P)):ee&&(Je(),y(ee,1,1,()=>{ee=null}),xe());const Gt={};u[0]&8&&(Gt.data=a[3]),B.$set(Gt);const Ut={};u[0]&16&&(Ut.data=a[4]),u[2]&65536&&(Ut.$$scope={dirty:u,ctx:a}),ue.$set(Ut),a[5]?te?(te.p(a,u),u[0]&32&&d(te,1)):(te=ra(a),te.c(),d(te,1),te.m(j.parentNode,j)):te&&(Je(),y(te,1,1,()=>{te=null}),xe()),a[6]?ae?(ae.p(a,u),u[0]&64&&d(ae,1)):(ae=la(a),ae.c(),d(ae,1),ae.m(ye.parentNode,ye)):ae&&(Je(),y(ae,1,1,()=>{ae=null}),xe());const zt={};u[0]&96|u[2]&65536&&(zt.$$scope={dirty:u,ctx:a}),Ee.$set(zt),a[7]?ne?(ne.p(a,u),u[0]&128&&d(ne,1)):(ne=_a(a),ne.c(),d(ne,1),ne.m(Ae.parentNode,Ae)):ne&&(Je(),y(ne,1,1,()=>{ne=null}),xe());const qt={};u[0]&128&&(qt.data=a[7]),u[2]&65536&&(qt.$$scope={dirty:u,ctx:a}),He.$set(qt),a[8]?re?(re.p(a,u),u[0]&256&&d(re,1)):(re=ia(a),re.c(),d(re,1),re.m(Ue.parentNode,Ue)):re&&(Je(),y(re,1,1,()=>{re=null}),xe());const kt={};u[0]&256&&(kt.data=a[8]),u[2]&65536&&(kt.$$scope={dirty:u,ctx:a}),qe.$set(kt),a[9]?le?(le.p(a,u),u[0]&512&&d(le,1)):(le=oa(a),le.c(),d(le,1),le.m(H.parentNode,H)):le&&(Je(),y(le,1,1,()=>{le=null}),xe());const jt={};u[0]&512&&(jt.data=a[9]),tt.$set(jt),a[10]?_e?(_e.p(a,u),u[0]&1024&&d(_e,1)):(_e=ua(a),_e.c(),d(_e,1),_e.m(Rt.parentNode,Rt)):_e&&(Je(),y(_e,1,1,()=>{_e=null}),xe());const ht={};u[0]&1024&&(ht.data=a[10]),u[2]&65536&&(ht.$$scope={dirty:u,ctx:a}),mt.$set(ht)},i(a){Ot||(d(x),d(J),d(Z),d(R.$$.fragment,a),d(D.$$.fragment,a),d(F.$$.fragment,a),d(w.$$.fragment,a),d(X.$$.fragment,a),d($),d(ee),d(B.$$.fragment,a),d(ue.$$.fragment,a),d(te),d(ae),d(Ee.$$.fragment,a),d(ne),d(He.$$.fragment,a),d(re),d(qe.$$.fragment,a),d(le),d(tt.$$.fragment,a),d(_e),d(mt.$$.fragment,a),Ot=!0)},o(a){y(x),y(J),y(Z),y(R.$$.fragment,a),y(D.$$.fragment,a),y(F.$$.fragment,a),y(w.$$.fragment,a),y(X.$$.fragment,a),y($),y(ee),y(B.$$.fragment,a),y(ue.$$.fragment,a),y(te),y(ae),y(Ee.$$.fragment,a),y(ne),y(He.$$.fragment,a),y(re),y(qe.$$.fragment,a),y(le),y(tt.$$.fragment,a),y(_e),y(mt.$$.fragment,a),Ot=!1},d(a){a&&(E(t),E(_),E(r),E(c),E(A),E(N),E(i),E(v),E(I),E(Ne),E(fe),E(be),E(pe),E(h),E(W),E(ge),E(q),E(G),E(oe),E(P),E(Oe),E(Ce),E(V),E(Se),E(Q),E(me),E(z),E(se),E(j),E(ye),E(S),E(K),E(he),E(Ve),E(Ke),E(ce),E(Le),E(Ae),E(Qe),E(ve),E(De),E(s),E(_t),E(we),E(Pe),E(Ue),E(it),E(Ye),E(Xe),E(We),E(et),E(Be),E(ot),E(H),E(ct),E(ut),E(At),E(yt),E(Tt),E(nt),E(Nt),E(Rt),E(bt),E(st)),rt&&rt.d(a),Mt.d(a),E(n),E(e),lt&&lt.d(a),E(o),x&&x.d(a),J&&J.d(a),Z&&Z.d(a),b(R,a),b(D,a),b(F,a),b(w,a),b(X,a),$&&$.d(a),ee&&ee.d(a),b(B,a),b(ue,a),te&&te.d(a),ae&&ae.d(a),b(Ee,a),ne&&ne.d(a),b(He,a),re&&re.d(a),b(qe,a),le&&le.d(a),b(tt,a),_e&&_e.d(a),b(mt,a)}}}const k={title:"Performa Menu"};function on(l,t,n){let e,o;It(l,qa,H=>n(57,e=H)),It(l,Jt,H=>n(63,o=H));let{data:_}=t,{data:r={},customFormattingSettings:m,__db:c,inputs:A}=_;ga(Jt,o="b19b262d80b46c59e99dad7721f5e5d6",o);let N=La(pa(A));ca(N.subscribe(H=>A=H)),da(Da,{getCustomFormats:()=>m.customFormats||[]});const i=(H,tt)=>Ua(c.query,H,{query_name:tt});Ha(i),e.params,Aa(()=>!0);let R={initialData:void 0,initialError:void 0},v=Y`SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance`,D=`SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance`;r.summary_menu_data&&(r.summary_menu_data instanceof Error?R.initialError=r.summary_menu_data:R.initialData=r.summary_menu_data,r.summary_menu_columns&&(R.knownColumns=r.summary_menu_columns));let I,F=!1;const Ne=Ze.createReactive({callback:H=>{n(0,I=H)},execFn:i},{id:"summary_menu",...R});Ne(D,{noResolve:v,...R}),globalThis[Symbol.for("summary_menu")]={get value(){return I}};let w={initialData:void 0,initialError:void 0},fe=Y`SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_qty DESC
LIMIT 1`,X=`SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_qty DESC
LIMIT 1`;r.best_menu_30d_data&&(r.best_menu_30d_data instanceof Error?w.initialError=r.best_menu_30d_data:w.initialData=r.best_menu_30d_data,r.best_menu_30d_columns&&(w.knownColumns=r.best_menu_30d_columns));let be,pe=!1;const h=Ze.createReactive({callback:H=>{n(1,be=H)},execFn:i},{id:"best_menu_30d",...w});h(X,{noResolve:fe,...w}),globalThis[Symbol.for("best_menu_30d")]={get value(){return be}};let W={initialData:void 0,initialError:void 0},Me=Y`SELECT
    menu_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_revenue DESC
LIMIT 1`,ge=`SELECT
    menu_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_revenue DESC
LIMIT 1`;r.best_revenue_30d_data&&(r.best_revenue_30d_data instanceof Error?W.initialError=r.best_revenue_30d_data:W.initialData=r.best_revenue_30d_data,r.best_revenue_30d_columns&&(W.knownColumns=r.best_revenue_30d_columns));let q,je=!1;const G=Ze.createReactive({callback:H=>{n(2,q=H)},execFn:i},{id:"best_revenue_30d",...W});G(ge,{noResolve:Me,...W}),globalThis[Symbol.for("best_revenue_30d")]={get value(){return q}};let oe={initialData:void 0,initialError:void 0},P=Y`SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Stars'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plowhorses'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzles'
        ELSE 'Dogs'
    END AS klasifikasi
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category`,B=`SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Stars'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plowhorses'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzles'
        ELSE 'Dogs'
    END AS klasifikasi
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category`;r.menu_engineering_data&&(r.menu_engineering_data instanceof Error?oe.initialError=r.menu_engineering_data:oe.initialData=r.menu_engineering_data,r.menu_engineering_columns&&(oe.knownColumns=r.menu_engineering_columns));let Oe,ue=!1;const Ce=Ze.createReactive({callback:H=>{n(3,Oe=H)},execFn:i},{id:"menu_engineering",...oe});Ce(B,{noResolve:P,...oe}),globalThis[Symbol.for("menu_engineering")]={get value(){return Oe}};let V={initialData:void 0,initialError:void 0},de=Y`SELECT
    klasifikasi,
    menu_name,
    category,
    total_qty,
    total_revenue
FROM (
    SELECT
        menu_name,
        category,
        SUM(total_qty_sold)  AS total_qty,
        SUM(total_revenue)   AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Stars'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plowhorses'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzles'
            ELSE 'Dogs'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Stars'       THEN 1
        WHEN 'Puzzles'     THEN 2
        WHEN 'Plowhorses'  THEN 3
        WHEN 'Dogs'        THEN 4
    END,
    total_revenue DESC`,Se=`SELECT
    klasifikasi,
    menu_name,
    category,
    total_qty,
    total_revenue
FROM (
    SELECT
        menu_name,
        category,
        SUM(total_qty_sold)  AS total_qty,
        SUM(total_revenue)   AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Stars'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plowhorses'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzles'
            ELSE 'Dogs'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Stars'       THEN 1
        WHEN 'Puzzles'     THEN 2
        WHEN 'Plowhorses'  THEN 3
        WHEN 'Dogs'        THEN 4
    END,
    total_revenue DESC`;r.menu_engineering_table_data&&(r.menu_engineering_table_data instanceof Error?V.initialError=r.menu_engineering_table_data:V.initialData=r.menu_engineering_table_data,r.menu_engineering_table_columns&&(V.knownColumns=r.menu_engineering_table_columns));let Q,me=!1;const z=Ze.createReactive({callback:H=>{n(4,Q=H)},execFn:i},{id:"menu_engineering_table",...V});z(Se,{noResolve:de,...V}),globalThis[Symbol.for("menu_engineering_table")]={get value(){return Q}};let Re={initialData:void 0,initialError:void 0},se=Y`SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10`,j=`SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10`;r.top_by_volume_data&&(r.top_by_volume_data instanceof Error?Re.initialError=r.top_by_volume_data:Re.initialData=r.top_by_volume_data,r.top_by_volume_columns&&(Re.knownColumns=r.top_by_volume_columns));let ye,Ee=!1;const S=Ze.createReactive({callback:H=>{n(5,ye=H)},execFn:i},{id:"top_by_volume",...Re});S(j,{noResolve:se,...Re}),globalThis[Symbol.for("top_by_volume")]={get value(){return ye}};let K={initialData:void 0,initialError:void 0},ke=Y`SELECT
    menu_name,
    category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC
LIMIT 10`,he=`SELECT
    menu_name,
    category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC
LIMIT 10`;r.top_by_revenue_data&&(r.top_by_revenue_data instanceof Error?K.initialError=r.top_by_revenue_data:K.initialData=r.top_by_revenue_data,r.top_by_revenue_columns&&(K.knownColumns=r.top_by_revenue_columns));let Ve,Ke=!1;const ce=Ze.createReactive({callback:H=>{n(6,Ve=H)},execFn:i},{id:"top_by_revenue",...K});ce(he,{noResolve:ke,...K}),globalThis[Symbol.for("top_by_revenue")]={get value(){return Ve}};let Ie={initialData:void 0,initialError:void 0},Le=Y`SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END)  AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)   AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)   AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)   AS top_revenue_value
FROM (
    SELECT
        branch_name,
        menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name`,Ae=`SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END)  AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)   AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)   AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)   AS top_revenue_value
FROM (
    SELECT
        branch_name,
        menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name`;r.andalan_per_cabang_data&&(r.andalan_per_cabang_data instanceof Error?Ie.initialError=r.andalan_per_cabang_data:Ie.initialData=r.andalan_per_cabang_data,r.andalan_per_cabang_columns&&(Ie.knownColumns=r.andalan_per_cabang_columns));let He,Qe=!1;const ve=Ze.createReactive({callback:H=>{n(7,He=H)},execFn:i},{id:"andalan_per_cabang",...Ie});ve(Ae,{noResolve:Le,...Ie}),globalThis[Symbol.for("andalan_per_cabang")]={get value(){return He}};let Fe={initialData:void 0,initialError:void 0},De=Y`SELECT
    menu_name,
    category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1)                                                                 AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC`,s=`SELECT
    menu_name,
    category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1)                                                                 AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC`;r.menu_wow_data&&(r.menu_wow_data instanceof Error?Fe.initialError=r.menu_wow_data:Fe.initialData=r.menu_wow_data,r.menu_wow_columns&&(Fe.knownColumns=r.menu_wow_columns));let _t,we=!1;const ft=Ze.createReactive({callback:H=>{n(8,_t=H)},execFn:i},{id:"menu_wow",...Fe});ft(s,{noResolve:De,...Fe}),globalThis[Symbol.for("menu_wow")]={get value(){return _t}};let Pe={initialData:void 0,initialError:void 0},Ue=Y`SELECT
    order_date,
    menu_name,
    SUM(total_qty_sold) AS qty_harian
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM (
        SELECT
            menu_name,
            AVG(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS avg_awal,
            AVG(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS avg_akhir
        FROM (
            SELECT
                menu_name,
                order_date,
                total_qty_sold,
                ROW_NUMBER() OVER (PARTITION BY menu_name ORDER BY order_date) AS hari_ke
            FROM restaurant.menu_performance
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
        )
        GROUP BY menu_name
    )
    WHERE (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) <= 0
    ORDER BY (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) ASC
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY order_date, menu_name
ORDER BY order_date, menu_name`,qe=`SELECT
    order_date,
    menu_name,
    SUM(total_qty_sold) AS qty_harian
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM (
        SELECT
            menu_name,
            AVG(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS avg_awal,
            AVG(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS avg_akhir
        FROM (
            SELECT
                menu_name,
                order_date,
                total_qty_sold,
                ROW_NUMBER() OVER (PARTITION BY menu_name ORDER BY order_date) AS hari_ke
            FROM restaurant.menu_performance
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
        )
        GROUP BY menu_name
    )
    WHERE (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) <= 0
    ORDER BY (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) ASC
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY order_date, menu_name
ORDER BY order_date, menu_name`;r.declining_trend_data&&(r.declining_trend_data instanceof Error?Pe.initialError=r.declining_trend_data:Pe.initialData=r.declining_trend_data,r.declining_trend_columns&&(Pe.knownColumns=r.declining_trend_columns));let it,Ye=!1;const dt=Ze.createReactive({callback:H=>{n(9,it=H)},execFn:i},{id:"declining_trend",...Pe});dt(qe,{noResolve:Ue,...Pe}),globalThis[Symbol.for("declining_trend")]={get value(){return it}};let Xe={initialData:void 0,initialError:void 0},We=Y`SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS qty_30_awal,
    SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END)
        - SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change
FROM (
    SELECT
        branch_name,
        menu_name,
        order_date,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY branch_name, menu_name ORDER BY order_date) AS hari_ke
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
)
GROUP BY branch_name, menu_name
HAVING pct_change <= 0
ORDER BY pct_change ASC`,et=`SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS qty_30_awal,
    SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END)
        - SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change
FROM (
    SELECT
        branch_name,
        menu_name,
        order_date,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY branch_name, menu_name ORDER BY order_date) AS hari_ke
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
)
GROUP BY branch_name, menu_name
HAVING pct_change <= 0
ORDER BY pct_change ASC`;r.declining_by_branch_data&&(r.declining_by_branch_data instanceof Error?Xe.initialError=r.declining_by_branch_data:Xe.initialData=r.declining_by_branch_data,r.declining_by_branch_columns&&(Xe.knownColumns=r.declining_by_branch_columns));let Be,St=!1;const ot=Ze.createReactive({callback:H=>{n(10,Be=H)},execFn:i},{id:"declining_by_branch",...Xe});return ot(et,{noResolve:We,...Xe}),globalThis[Symbol.for("declining_by_branch")]={get value(){return Be}},l.$$set=H=>{"data"in H&&n(11,_=H.data)},l.$$.update=()=>{l.$$.dirty[0]&2048&&n(12,{data:r={},customFormattingSettings:m,__db:c}=_,r),l.$$.dirty[0]&4096&&va.set(Object.keys(r).length>0),l.$$.dirty[1]&67108864&&e.params,l.$$.dirty[0]&122880&&(v||!F?v||(Ne(D,{noResolve:v,...R}),n(16,F=!0)):Ne(D,{noResolve:v})),l.$$.dirty[0]&1966080&&(fe||!pe?fe||(h(X,{noResolve:fe,...w}),n(20,pe=!0)):h(X,{noResolve:fe})),l.$$.dirty[0]&31457280&&(Me||!je?Me||(G(ge,{noResolve:Me,...W}),n(24,je=!0)):G(ge,{noResolve:Me})),l.$$.dirty[0]&503316480&&(P||!ue?P||(Ce(B,{noResolve:P,...oe}),n(28,ue=!0)):Ce(B,{noResolve:P})),l.$$.dirty[0]&1610612736|l.$$.dirty[1]&3&&(de||!me?de||(z(Se,{noResolve:de,...V}),n(32,me=!0)):z(Se,{noResolve:de})),l.$$.dirty[1]&60&&(se||!Ee?se||(S(j,{noResolve:se,...Re}),n(36,Ee=!0)):S(j,{noResolve:se})),l.$$.dirty[1]&960&&(ke||!Ke?ke||(ce(he,{noResolve:ke,...K}),n(40,Ke=!0)):ce(he,{noResolve:ke})),l.$$.dirty[1]&15360&&(Le||!Qe?Le||(ve(Ae,{noResolve:Le,...Ie}),n(44,Qe=!0)):ve(Ae,{noResolve:Le})),l.$$.dirty[1]&245760&&(De||!we?De||(ft(s,{noResolve:De,...Fe}),n(48,we=!0)):ft(s,{noResolve:De})),l.$$.dirty[1]&3932160&&(Ue||!Ye?Ue||(dt(qe,{noResolve:Ue,...Pe}),n(52,Ye=!0)):dt(qe,{noResolve:Ue})),l.$$.dirty[1]&62914560&&(We||!St?We||(ot(et,{noResolve:We,...Xe}),n(56,St=!0)):ot(et,{noResolve:We}))},n(14,v=Y`SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance`),n(15,D=`SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance`),n(18,fe=Y`SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_qty DESC
LIMIT 1`),n(19,X=`SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_qty DESC
LIMIT 1`),n(22,Me=Y`SELECT
    menu_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_revenue DESC
LIMIT 1`),n(23,ge=`SELECT
    menu_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_revenue DESC
LIMIT 1`),n(26,P=Y`SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Stars'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plowhorses'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzles'
        ELSE 'Dogs'
    END AS klasifikasi
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category`),n(27,B=`SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Stars'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plowhorses'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzles'
        ELSE 'Dogs'
    END AS klasifikasi
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category`),n(30,de=Y`SELECT
    klasifikasi,
    menu_name,
    category,
    total_qty,
    total_revenue
FROM (
    SELECT
        menu_name,
        category,
        SUM(total_qty_sold)  AS total_qty,
        SUM(total_revenue)   AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Stars'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plowhorses'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzles'
            ELSE 'Dogs'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Stars'       THEN 1
        WHEN 'Puzzles'     THEN 2
        WHEN 'Plowhorses'  THEN 3
        WHEN 'Dogs'        THEN 4
    END,
    total_revenue DESC`),n(31,Se=`SELECT
    klasifikasi,
    menu_name,
    category,
    total_qty,
    total_revenue
FROM (
    SELECT
        menu_name,
        category,
        SUM(total_qty_sold)  AS total_qty,
        SUM(total_revenue)   AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Stars'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plowhorses'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzles'
            ELSE 'Dogs'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Stars'       THEN 1
        WHEN 'Puzzles'     THEN 2
        WHEN 'Plowhorses'  THEN 3
        WHEN 'Dogs'        THEN 4
    END,
    total_revenue DESC`),n(34,se=Y`SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10`),n(35,j=`SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10`),n(38,ke=Y`SELECT
    menu_name,
    category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC
LIMIT 10`),n(39,he=`SELECT
    menu_name,
    category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC
LIMIT 10`),n(42,Le=Y`SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END)  AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)   AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)   AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)   AS top_revenue_value
FROM (
    SELECT
        branch_name,
        menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name`),n(43,Ae=`SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END)  AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)   AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)   AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)   AS top_revenue_value
FROM (
    SELECT
        branch_name,
        menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name`),n(46,De=Y`SELECT
    menu_name,
    category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1)                                                                 AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC`),n(47,s=`SELECT
    menu_name,
    category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1)                                                                 AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC`),n(50,Ue=Y`SELECT
    order_date,
    menu_name,
    SUM(total_qty_sold) AS qty_harian
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM (
        SELECT
            menu_name,
            AVG(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS avg_awal,
            AVG(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS avg_akhir
        FROM (
            SELECT
                menu_name,
                order_date,
                total_qty_sold,
                ROW_NUMBER() OVER (PARTITION BY menu_name ORDER BY order_date) AS hari_ke
            FROM restaurant.menu_performance
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
        )
        GROUP BY menu_name
    )
    WHERE (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) <= 0
    ORDER BY (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) ASC
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY order_date, menu_name
ORDER BY order_date, menu_name`),n(51,qe=`SELECT
    order_date,
    menu_name,
    SUM(total_qty_sold) AS qty_harian
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM (
        SELECT
            menu_name,
            AVG(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS avg_awal,
            AVG(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS avg_akhir
        FROM (
            SELECT
                menu_name,
                order_date,
                total_qty_sold,
                ROW_NUMBER() OVER (PARTITION BY menu_name ORDER BY order_date) AS hari_ke
            FROM restaurant.menu_performance
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
        )
        GROUP BY menu_name
    )
    WHERE (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) <= 0
    ORDER BY (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) ASC
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY order_date, menu_name
ORDER BY order_date, menu_name`),n(54,We=Y`SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS qty_30_awal,
    SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END)
        - SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change
FROM (
    SELECT
        branch_name,
        menu_name,
        order_date,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY branch_name, menu_name ORDER BY order_date) AS hari_ke
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
)
GROUP BY branch_name, menu_name
HAVING pct_change <= 0
ORDER BY pct_change ASC`),n(55,et=`SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS qty_30_awal,
    SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END)
        - SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change
FROM (
    SELECT
        branch_name,
        menu_name,
        order_date,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY branch_name, menu_name ORDER BY order_date) AS hari_ke
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
)
GROUP BY branch_name, menu_name
HAVING pct_change <= 0
ORDER BY pct_change ASC`),[I,be,q,Oe,Q,ye,Ve,He,_t,it,Be,_,r,R,v,D,F,w,fe,X,pe,W,Me,ge,je,oe,P,B,ue,V,de,Se,me,Re,se,j,Ee,K,ke,he,Ke,Ie,Le,Ae,Qe,Fe,De,s,we,Pe,Ue,qe,Ye,Xe,We,et,St,e]}class gn extends Dt{constructor(t){super(),pt(this,t,on,_n,vt,{data:11},null,[-1,-1,-1])}}export{gn as component};
