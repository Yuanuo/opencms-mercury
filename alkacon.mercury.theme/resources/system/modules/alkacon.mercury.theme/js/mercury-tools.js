"use strict";(self.webpackChunkmercury_template=self.webpackChunkmercury_template||[]).push([[471],{592:function(e,n,t){var r,o;function a(e,n,t){return e.split("$("+n+")").join(t)}function l(e){try{(e=e.substr(1)).length<6&&(e+=e);var n=(299*parseInt(e.substr(0,2),16)+587*parseInt(e.substr(2,2),16)+114*parseInt(e.substr(4,2),16))/1e3;return o&&console.info("getContrastBg(#"+e+") result: "+n),n>=220?"box box-grey":"box box-white"}catch(e){return"p-20"}}function i(e,n){r=e,(o=n)&&console.info("CssSampler.initCssSampler()");var t=r(".template-info.sample");o&&console.info("CssSampler.initCssSampler() .template-info.sample elements found: "+t.length);for(var i=0;i<t.length;i++){var s=r(t[i]),u=s.html();s.empty(),o&&console.info("CssSampler.initCssSampler() Creating CSS sample for id: "+s.attr("id"));for(var c=Mercury.getCssJsonData(s.attr("id")),f=c.length-1;f>=0;f--){var p=c[f];if(p.name){var m=u;m=a(m,"name",p.name),m=a(m,"value",p.value),m=a(m,"background",l(p.value)),s.append(r(m))}}}}t.r(n),t.d(n,{initCssSampler:function(){return i}})},528:function(e,n,t){var r;function o(){var e=Mercury.windowScrollTop();r.forEach((function(n){if("none"!=getComputedStyle(n)["background-image"]){var t=0,r=Mercury.position.offset(n).top,o=n.getBoundingClientRect().height,a=r+o,l=r-e,i=a-e,s=window.innerHeight;if(!(o<=1||i<0||l>s)){2==Mercury.debug()&&console.info("Parallax elementTop: "+r+" elementBottom: "+a),2==Mercury.debug()&&console.info("Parallax elementScrollTop: "+l+" elementScrollBottom: "+i);var u=0;(u=o<=s?i-s:l)>0&&(t=Math.round(.5*Math.abs(u)),2==Mercury.debug()&&console.info("Parallax elementHeight: "+o+" windowHeight: "+s+" offset: "+t+" elementScrollTop: "+l)),n.style.backgroundPosition="50% "+t+"px"}}}))}function a(){r=document.querySelectorAll(".effect-parallax-bg"),Mercury.debug()&&(console.info("Parallax.init()"),console.info("Parallax.init() .effect-parallax-bg elements found: "+r.length)),r.length>0&&(window.addEventListener("scroll",o),window.addEventListener("resize",o),o())}t.r(n),t.d(n,{initParallax:function(){return a}})}}]);
//# sourceMappingURL=mercury-tools.js.map