!function(t){var e=function(){var e=65,n='<div class="colorpicker"><div class="colorpicker_color"><div><div></div></div></div><div class="colorpicker_hue"><div></div></div><div class="colorpicker_new_color"></div><div class="colorpicker_current_color"></div><div class="colorpicker_hex"><input type="text" maxlength="6" size="6" /></div><div class="colorpicker_rgb_r colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_rgb_g colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_rgb_b colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_h colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_s colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_b colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_submit"></div></div>',r={eventName:"click",onShow:function(){},onBeforeShow:function(){},onHide:function(){},onChange:function(){},onSubmit:function(){},color:"ff0000",livePreview:!0,flat:!1},i=function(e,n){var r=I(e);t(n).data("colorpicker").fields.eq(1).val(r.r).end().eq(2).val(r.g).end().eq(3).val(r.b).end()},o=function(e,n){t(n).data("colorpicker").fields.eq(4).val(e.h).end().eq(5).val(e.s).end().eq(6).val(e.b).end()},s=function(e,n){t(n).data("colorpicker").fields.eq(0).val(V(e)).end()},a=function(e,n){t(n).data("colorpicker").selector.css("backgroundColor","#"+V({h:e.h,s:100,b:100})),t(n).data("colorpicker").selectorIndic.css({left:parseInt(150*e.s/100,10),top:parseInt(150*(100-e.b)/100,10)})},c=function(e,n){t(n).data("colorpicker").hue.css("top",parseInt(150-150*e.h/360,10))},l=function(e,n){t(n).data("colorpicker").currentColor.css("backgroundColor","#"+V(e))},u=function(e,n){t(n).data("colorpicker").newColor.css("backgroundColor","#"+V(e))},d=function(n){var r=n.charCode||n.keyCode||-1;if(r>e&&90>=r||32==r)return!1;var i=t(this).parent().parent();i.data("colorpicker").livePreview===!0&&h.apply(this)},h=function(e){var n,r=t(this).parent().parent();r.data("colorpicker").color=n=this.parentNode.className.indexOf("_hex")>0?L(j(this.value)):this.parentNode.className.indexOf("_hsb")>0?E({h:parseInt(r.data("colorpicker").fields.eq(4).val(),10),s:parseInt(r.data("colorpicker").fields.eq(5).val(),10),b:parseInt(r.data("colorpicker").fields.eq(6).val(),10)}):P(A({r:parseInt(r.data("colorpicker").fields.eq(1).val(),10),g:parseInt(r.data("colorpicker").fields.eq(2).val(),10),b:parseInt(r.data("colorpicker").fields.eq(3).val(),10)})),e&&(i(n,r.get(0)),s(n,r.get(0)),o(n,r.get(0))),a(n,r.get(0)),c(n,r.get(0)),u(n,r.get(0)),r.data("colorpicker").onChange.apply(r,[n,V(n),I(n)])},p=function(){var e=t(this).parent().parent();e.data("colorpicker").fields.parent().removeClass("colorpicker_focus")},f=function(){e=this.parentNode.className.indexOf("_hex")>0?70:65,t(this).parent().parent().data("colorpicker").fields.parent().removeClass("colorpicker_focus"),t(this).parent().addClass("colorpicker_focus")},m=function(e){var n=t(this).parent().find("input").focus(),r={el:t(this).parent().addClass("colorpicker_slider"),max:this.parentNode.className.indexOf("_hsb_h")>0?360:this.parentNode.className.indexOf("_hsb")>0?100:255,y:e.pageY,field:n,val:parseInt(n.val(),10),preview:t(this).parent().parent().data("colorpicker").livePreview};t(document).bind("mouseup",r,v),t(document).bind("mousemove",r,g)},g=function(t){return t.data.field.val(Math.max(0,Math.min(t.data.max,parseInt(t.data.val+t.pageY-t.data.y,10)))),t.data.preview&&h.apply(t.data.field.get(0),[!0]),!1},v=function(e){return h.apply(e.data.field.get(0),[!0]),e.data.el.removeClass("colorpicker_slider").find("input").focus(),t(document).unbind("mouseup",v),t(document).unbind("mousemove",g),!1},y=function(){var e={cal:t(this).parent(),y:t(this).offset().top};e.preview=e.cal.data("colorpicker").livePreview,t(document).bind("mouseup",e,w),t(document).bind("mousemove",e,b)},b=function(t){return h.apply(t.data.cal.data("colorpicker").fields.eq(4).val(parseInt(360*(150-Math.max(0,Math.min(150,t.pageY-t.data.y)))/150,10)).get(0),[t.data.preview]),!1},w=function(e){return i(e.data.cal.data("colorpicker").color,e.data.cal.get(0)),s(e.data.cal.data("colorpicker").color,e.data.cal.get(0)),t(document).unbind("mouseup",w),t(document).unbind("mousemove",b),!1},_=function(){var e={cal:t(this).parent(),pos:t(this).offset()};e.preview=e.cal.data("colorpicker").livePreview,t(document).bind("mouseup",e,k),t(document).bind("mousemove",e,x)},x=function(t){return h.apply(t.data.cal.data("colorpicker").fields.eq(6).val(parseInt(100*(150-Math.max(0,Math.min(150,t.pageY-t.data.pos.top)))/150,10)).end().eq(5).val(parseInt(100*Math.max(0,Math.min(150,t.pageX-t.data.pos.left))/150,10)).get(0),[t.data.preview]),!1},k=function(e){return i(e.data.cal.data("colorpicker").color,e.data.cal.get(0)),s(e.data.cal.data("colorpicker").color,e.data.cal.get(0)),t(document).unbind("mouseup",k),t(document).unbind("mousemove",x),!1},C=function(){t(this).addClass("colorpicker_focus")},T=function(){t(this).removeClass("colorpicker_focus")},S=function(){var e=t(this).parent(),n=e.data("colorpicker").color;e.data("colorpicker").origColor=n,l(n,e.get(0)),e.data("colorpicker").onSubmit(n,V(n),I(n),e.data("colorpicker").el)},M=function(){var e=t("#"+t(this).data("colorpickerId"));e.data("colorpicker").onBeforeShow.apply(this,[e.get(0)]);var n=t(this).offset(),r=N(),i=n.top+this.offsetHeight,o=n.left;return i+176>r.t+r.h&&(i-=this.offsetHeight+176),o+356>r.l+r.w&&(o-=356),e.css({left:o+"px",top:i+"px"}),0!=e.data("colorpicker").onShow.apply(this,[e.get(0)])&&e.show(),t(document).bind("mousedown",{cal:e},$),!1},$=function(e){D(e.data.cal.get(0),e.target,e.data.cal.get(0))||(0!=e.data.cal.data("colorpicker").onHide.apply(this,[e.data.cal.get(0)])&&e.data.cal.hide(),t(document).unbind("mousedown",$))},D=function(t,e,n){if(t==e)return!0;if(t.contains)return t.contains(e);if(t.compareDocumentPosition)return!!(16&t.compareDocumentPosition(e));for(var r=e.parentNode;r&&r!=n;){if(r==t)return!0;r=r.parentNode}return!1},N=function(){var t="CSS1Compat"==document.compatMode;return{l:window.pageXOffset||(t?document.documentElement.scrollLeft:document.body.scrollLeft),t:window.pageYOffset||(t?document.documentElement.scrollTop:document.body.scrollTop),w:window.innerWidth||(t?document.documentElement.clientWidth:document.body.clientWidth),h:window.innerHeight||(t?document.documentElement.clientHeight:document.body.clientHeight)}},E=function(t){return{h:Math.min(360,Math.max(0,t.h)),s:Math.min(100,Math.max(0,t.s)),b:Math.min(100,Math.max(0,t.b))}},A=function(t){return{r:Math.min(255,Math.max(0,t.r)),g:Math.min(255,Math.max(0,t.g)),b:Math.min(255,Math.max(0,t.b))}},j=function(t){var e=6-t.length;if(e>0){for(var n=[],r=0;e>r;r++)n.push("0");n.push(t),t=n.join("")}return t},O=function(t){var t=parseInt(t.indexOf("#")>-1?t.substring(1):t,16);return{r:t>>16,g:(65280&t)>>8,b:255&t}},L=function(t){return P(O(t))},P=function(t){var e={h:0,s:0,b:0},n=Math.min(t.r,t.g,t.b),r=Math.max(t.r,t.g,t.b),i=r-n;return e.b=r,e.s=0!=r?255*i/r:0,e.h=0!=e.s?t.r==r?(t.g-t.b)/i:t.g==r?2+(t.b-t.r)/i:4+(t.r-t.g)/i:-1,e.h*=60,e.h<0&&(e.h+=360),e.s*=100/255,e.b*=100/255,e},I=function(t){var e={},n=Math.round(t.h),r=Math.round(255*t.s/100),i=Math.round(255*t.b/100);if(0==r)e.r=e.g=e.b=i;else{var o=i,s=(255-r)*i/255,a=(o-s)*(n%60)/60;360==n&&(n=0),60>n?(e.r=o,e.b=s,e.g=s+a):120>n?(e.g=o,e.b=s,e.r=o-a):180>n?(e.g=o,e.r=s,e.b=s+a):240>n?(e.b=o,e.r=s,e.g=o-a):300>n?(e.b=o,e.g=s,e.r=s+a):360>n?(e.r=o,e.g=s,e.b=o-a):(e.r=0,e.g=0,e.b=0)}return{r:Math.round(e.r),g:Math.round(e.g),b:Math.round(e.b)}},H=function(e){var n=[e.r.toString(16),e.g.toString(16),e.b.toString(16)];return t.each(n,function(t,e){1==e.length&&(n[t]="0"+e)}),n.join("")},V=function(t){return H(I(t))},R=function(){var e=t(this).parent(),n=e.data("colorpicker").origColor;e.data("colorpicker").color=n,i(n,e.get(0)),s(n,e.get(0)),o(n,e.get(0)),a(n,e.get(0)),c(n,e.get(0)),u(n,e.get(0))};return{init:function(e){if(e=t.extend({},r,e||{}),"string"==typeof e.color)e.color=L(e.color);else if(void 0!=e.color.r&&void 0!=e.color.g&&void 0!=e.color.b)e.color=P(e.color);else{if(void 0==e.color.h||void 0==e.color.s||void 0==e.color.b)return this;e.color=E(e.color)}return this.each(function(){if(!t(this).data("colorpickerId")){var r=t.extend({},e);r.origColor=e.color;var g="collorpicker_"+parseInt(1e3*Math.random());t(this).data("colorpickerId",g);var v=t(n).attr("id",g);r.flat?v.appendTo(this).show():v.appendTo(document.body),r.fields=v.find("input").bind("keyup",d).bind("change",h).bind("blur",p).bind("focus",f),v.find("span").bind("mousedown",m).end().find(">div.colorpicker_current_color").bind("click",R),r.selector=v.find("div.colorpicker_color").bind("mousedown",_),r.selectorIndic=r.selector.find("div div"),r.el=this,r.hue=v.find("div.colorpicker_hue div"),v.find("div.colorpicker_hue").bind("mousedown",y),r.newColor=v.find("div.colorpicker_new_color"),r.currentColor=v.find("div.colorpicker_current_color"),v.data("colorpicker",r),v.find("div.colorpicker_submit").bind("mouseenter",C).bind("mouseleave",T).bind("click",S),i(r.color,v.get(0)),o(r.color,v.get(0)),s(r.color,v.get(0)),c(r.color,v.get(0)),a(r.color,v.get(0)),l(r.color,v.get(0)),u(r.color,v.get(0)),r.flat?v.css({position:"relative",display:"block"}):t(this).bind(r.eventName,M)}})},showPicker:function(){return this.each(function(){t(this).data("colorpickerId")&&M.apply(this)})},hidePicker:function(){return this.each(function(){t(this).data("colorpickerId")&&t("#"+t(this).data("colorpickerId")).hide()})},setColor:function(e){if("string"==typeof e)e=L(e);else if(void 0!=e.r&&void 0!=e.g&&void 0!=e.b)e=P(e);else{if(void 0==e.h||void 0==e.s||void 0==e.b)return this;e=E(e)}return this.each(function(){if(t(this).data("colorpickerId")){var n=t("#"+t(this).data("colorpickerId"));n.data("colorpicker").color=e,n.data("colorpicker").origColor=e,i(e,n.get(0)),o(e,n.get(0)),s(e,n.get(0)),c(e,n.get(0)),a(e,n.get(0)),l(e,n.get(0)),u(e,n.get(0))}})}}}();t.fn.extend({ColorPicker:e.init,ColorPickerHide:e.hidePicker,ColorPickerShow:e.showPicker,ColorPickerSetColor:e.setColor})}(jQuery);