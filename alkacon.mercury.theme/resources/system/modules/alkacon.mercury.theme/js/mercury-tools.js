(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{33:function(e,n,t){"use strict";var o,a,r;function l(){var e=Mercury.windowScrollTop();r.each((function(){var n=o(this);if("none"!=n.css("background-image")){var t=0,r=n.offset().top,l=n.outerHeight(!0),i=r+l,s=r-e,c=i-e,f=Mercury.windowHeight(),u=n.data("parallax").effect;if(!(l<=1||c<0||s>f)){if(a&&console.info("elementTop: "+r+" elementBottom: "+i),a&&console.info("elementScrollTop: "+s+" elementScrollBottom: "+c),1==u){var p=0;(p=l<=f?c-f:s)>0&&(t=Math.round(.5*Math.abs(p)),a&&console.info("elementHeight: "+l+" windowHeight: "+f+" offset: "+t+" elementScrollTop: "+s))}else 2==u?s<0&&(t=Math.round(2*s)):3==u&&(t=Math.round(.33*s));n.css("background-position","50% "+t+"px")}}}))}function i(e,n){o=e,a=n,r=e(".effect-parallax-bg"),a&&(console.info("Parallax.init()"),console.info(".effect-parallax-bg elements found: "+r.length)),r.length>0&&(r.each((function(){var e=o(this),n=1;void 0!==e.data("parallax")&&void 0!==e.data("parallax").effect&&(n=e.data("parallax").effect),e.data("parallax",{effect:n})})),o(window).on("scroll",l).resize(l),l())}t.r(n),t.d(n,"initParallax",(function(){return i}))},34:function(e,n,t){"use strict";var o,a;function r(e,n,t){return e.split("$("+n+")").join(t)}function l(e){try{(e=e.substr(1)).length<6&&(e+=e);var n=(299*parseInt(e.substr(0,2),16)+587*parseInt(e.substr(2,2),16)+114*parseInt(e.substr(4,2),16))/1e3;return a&&console.info("getContrastBg(#"+e+") result: "+n),n>=220?"box box-grey":"box box-white"}catch(e){return"p-20"}}function i(e,n){o=e,(a=n)&&console.info("CssSampler.init()");var t=o(".template-info.sample");a&&console.info(".template-info.sample elements found: "+t.length);for(var i=0;i<t.length;i++){var s=o(t[i]),c=s.html();s.empty(),a&&console.info("Creating CSS sample for id: "+s.attr("id"));for(var f=Mercury.getCssJsonData(s.attr("id")),u=f.length-1;u>=0;u--){var p=f[u];if(p.name){var d=c;d=r(d,"name",p.name),d=r(d,"value",p.value),d=r(d,"background",l(p.value)),s.append(o(d))}}}}t.r(n),t.d(n,"initCssSampler",(function(){return i}))}}]);
//# sourceMappingURL=mercury-tools.js.map