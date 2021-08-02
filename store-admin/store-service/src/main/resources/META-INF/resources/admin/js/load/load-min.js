//(function(a){if(typeof define==="function"&&define.amd){define(["jquery"],a)}else{if(typeof exports==="object"){a(require("jquery"))}else{a(jQuery)}}}(function(b){b(window).bind("scroll",function(){var c=b(".mask");for(var d=0;d<c.length;d++){var h=b(c[d]).attr("ele");var g=b(h).offset().top;var f=b(document).scrollTop();var e=g-f;b(c[d]).css({"top":e+"px"})}});var a={};b.mask_fullscreen=function(e){if(b(".mask[ele=full_screen]").length>0){return}b("body").addClass("scroll-off");var c='<div class="mask" ele="full_screen"><div>数据加载中...</div></div>';b("body").append(c);clearTimeout(a["full_screen"]);if(e&&e>0){var d=setTimeout(function(){b(".mask[ele=full_screen]").remove();b("body").removeClass("scroll-off")},e);a["full_screen"]=d}};b.mask_element=function(f,e){if(b(".mask[ele="+f+"]").length>0){return}var c='<div class="mask" ele='+f+' style="width: '+b(f).width()+"px !important; height: "+b(f).height()+"px !important; left: "+b(f).offset().left+"px !important; top: "+b(f).offset().top+'px !important;"><div>数据加载中...</div></div>';b("body").append(c);clearTimeout(a[f]);if(e&&e>0){var d=setTimeout(function(){b(".mask[ele="+f+"]").remove()},e);a[f]=d}};b.mask_close=function(c){b(".mask[ele="+c+"]").remove()};b.mask_close_all=function(){b(".mask").remove()}}));
(function (root, factory) {
    //amd
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports === 'object') { //umd
        module.exports = factory($);
    } else {
        root.Loading = factory(window.Zepto || window.jQuery || $);
    }
})(window, function ($) {
    var Loading = function () { };
    Loading.prototype = {
        loadingTpl: '<div class="ui-loading"><div class="ui-loading-mask"></div><i></i></div>',
        stop: function () {
            this.loading.remove();
            this.loading = null;
        },
        start: function () {
            var _this = this;
            var loading = this.loading;
            if (!loading) {
                loading = $(_this.loadingTpl);
                $('body').append(loading);
            }
            this.loading = loading;
            //console.log(cw,ch)
            this.setPosition();
        },
        setPosition: function () {
            var _this = this;
            var loading = this.loading;
            var target = _this.target;
            var content = $(target);
            var ch = $(content).outerHeight();
            var cw = $(content).outerWidth();
            if ($(target)[0].tagName == "HTML") {
                ch = Math.max($(target).height(), $(window).height());
                cw = Math.max($(target).width(), $(window).width());
            }
            loading.height(ch).width(cw);
            loading.find('div').height(ch).width(cw);
            if (ch < 100) {
                loading.find('i').height(ch).width(ch);
            }
            var offset = $(content).offset();
            loading.css({
                top: offset.top,
                left: offset.left
            });
            var icon = loading.find('i');
            var h = ch,
                w = cw,
                top = 0,
                left = 0;
            if ($(target)[0].tagName == "HTML") {
                h = $(window).height();
                w = $(window).width();
                top = (h - icon.height()) / 2 + $(window).scrollTop();
                left = (w - icon.width()) / 2 + $(window).scrollLeft();
            } else {
                top = (h - icon.height()) / 2;
                left = (w - icon.width()) / 2;
            }
            icon.css({
                top: top,
                left: left
            })
        },
        init: function (settings) {
            settings = settings || {};
            this.loadingTpl = settings.loadingTpl || this.loadingTpl;
            this.target = settings.target || 'html';
            this.bindEvent();
        },
        bindEvent: function () {
            var _this = this;
            $(this.target).on('stop', function () {
                _this.stop();
            });
            $(window).on('resize', function () {
                _this.loading && _this.setPosition();
            });
        }
    }
    return Loading;
});