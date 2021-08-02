<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no, width=device-width">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" href="${p_static}/admin/plugins/bootstrap-3.3.7-dist/css/bootstrap.min.css"
          type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/product/productDetails.css">
    <link rel="stylesheet" href="${p_static}/admin/plugins/swiper/css/swiper.min.css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/common/reset.css" type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/common/global.css" type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/member/common.css">
    <script src="${p_static}/admin/js/jquery-2.1.1.min.js"></script>
    <script src="${p_static}/admin/js/common.js"></script>
    <script src="${p_static}/admin/js/monitor.js"></script>
    <#--<script type="text/javascript" src="${p_static}/admin/js/order/addShipping.js"></script>-->
    <#--<script src="${p_static}/admin/js/productSpecificationsNew.js"></script>-->
    <title>产品详情</title>
    <style>
        .selectListWrap a {
            color: #000;
        }

        .content {
            width: 77%;
            line-height: 2rem;
        }

        .content input {
            color: #aaaaaa;
            border: none;
            width: 90%;
        }

        .content span {
            display: inline-block;
            /*vertical-align: middle;*/
            vertical-align: inherit;
            height: 1rem;
            width: 10%;
            background: url("${p_static}/admin/images/drop-arrow.png") no-repeat 100%;
            background-position: 50% -1.3rem;
            position: relative;
            top: -1px;
        }

        .content span.remove {
            display: inline-block;
            height: 1rem;
            width: 10%;
            background: url("${p_static}/admin/images/drop-arrow.png") no-repeat 100%;
            background-position: 50% -0.3rem;
            position: relative;
        }

        .selectListWrap {
            position: fixed;
            width: 100%;
            height: initial;
            left: 0px;
            bottom: 0px;
            outline: 0;
            -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
            z-index: 999999;
            display: none;
            min-width: 330px;
            /*overflow-y: scroll;*/
            /* margin-bottom: 20px; */
        }

        #provinceId {
            height: 30%;
            overflow: visible;
        }

        .selectList {
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.5);
        }

        .topSelect {
            overflow: hidden;
            border-bottom: 1px solid #ccc;
            background: #f0f0f0;
            font-size: 13px;
            width: 100%;
        }

        .topSelect > a {
            display: inline-block;
            float: left;
            width: 25%;
            line-height: 3rem;
            border-left: 1px solid #ccc;
            border-bottom: 1px solid transparent;
            color: #4D4D4D;
            text-align: center;
            outline: 0;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            /*margin-right: -0.5rem;*/
        }

        .topSelect > a.selected {
            background: #fff;
            border-bottom: 1px solid #fff;
            color: #46A4FF;
        }

        .topSelect > a:first-child {
            border-left: none;
        }

        .topSelect > a:last-child.active {
            border-right: 1px solid #ccc;
        }

        .selectCon {
            width: 100%;
            min-height: 10px;
            background-color: #fff;
            padding: 50px 0px 10px 0px;

        }

        .wrap {
            font-size: 13px;
        }

        .wrap a.ative {
            background: #46A4FF;
            text-decoration: none;
            border-radius: 0.3rem;
            padding: 0rem 0.5rem;
        }

        .h {
            overflow: hidden;
        }

        .fl {
            float: left;
        }

        .fr {
            float: right;
        }

        .hui {
            background: #0066CC;
            width: 10px;
            height: 10px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;
        }

        .wihte {
            background: #a1a1a1;
            width: 10px;
            height: 10px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            border-radius: 5px;

        }

        /*弹窗提示*/
        .notPro, .notEqual, .notOrdered {
            padding-top: 0.7rem;
            margin-left: 10%;
            text-align: center;
            background: #ffffff;
            -webkit-border-radius: 0.4rem;
            -moz-border-radius: 0.4rem;
            border-radius: 0.4rem;
            /* z-index: 6; */
            z-index: 16;
            position: absolute;
            bottom: 35%;
            /*border: 3px solid ;*/
            display: none;
            width: 80%;
        }

        .notPro p, .notEqual p, .notOrdered p {
            margin: 0 auto;
            text-align: center;
            /*width: 75%;*/
            width: 60%;
            font-size: 1.1rem;
            color: rgb(51, 51, 51);;
            margin-bottom: 2rem;
        }

        .button {
            width: 100%;
            border-top: 1px solid #999;
        }

        /*.solid{*/
        /*margin-bottom: -3rem;*/
        /*}*/
        .notPro button, .notEqual button {
            border: none;
            width: 48%;
            border: none;
            line-height: 3rem;
            font-size: 1.1rem;
            color: #ffffff;
        }

        .notPro .changeAddress, .notEqual .sureOrdered {
            color: rgb(51, 51, 51);
            background: #ffffff;
            border: none;
            border-radius: 0 0 0 0.4rem;
        }

        .notPro .backPro, .notEqual .backFill {
            background: #008bff;
            border: none;
            border-radius: 0 0 0.4rem 0;
        }

        .notOrdered button.sureBack {
            line-height: 3rem;
            font-size: 1.4rem;
            width: 100%;
            background: #008bff;
            border: none;
            border-radius: 0 0 0.4rem 0.4rem;
        }

        .imgpoint {
            margin-top: -17px;
            position: relative;
            z-index: 998;
        }

        .nav-tabs > li.active > a, .nav-tabs > li.active > a:focus, .nav-tabs > li.active > a:hover {
            border: 1px solid transparent;
        }
        #myTab li{
            width: 50%;
        }

        input.dropNum {
            border: none;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
        }

        .nav-tabs > li.active > a, .nav-tabs > li.active > a:focus, .nav-tabs > li.active > a:hover {
            color: #189ade;
            cursor: default;
            background-color: #fff;
            /*border: 1px solid #ddd;*/
            border-bottom-color: #189ade;
            border-bottom: 3px solid;
        }

        #assess table:first-child {
            margin: 0;
        }

        #myTabContent {
            /*padding-bottom: 4rem;*/
            margin: 0 auto;
            margin-top: 1.5em;
        }

        #assess {
            border: 1px solid #ccc
        }

        #assess table td {
            border: 1px solid #ccc
        }

        .conLi ul li {
            list-style: disc;
            margin-left: 10%;
        }

        .conLi i {
            font-size: 1.5rem;
            color: #fff100;
            font-weight: bold;
        }

        .wrap table td {
            line-height: 2rem;
            width: 20%;
            text-align: center;
        }

        /*   .selectCon tr{
               line-height: 2rem;
           }*/
        .swiper-container-horizontal > .swiper-pagination-bullets, .swiper-pagination-custom, .swiper-pagination-fraction {
            bottom: -1px;
        }
        a:focus, a:hover {
            text-decoration: none;
        }
        #productFormat table td{
            text-align: center;
        }
    </style>

</head>
<body>
<div style="margin: 3% 36%">
<header>
<#--<#include "/layout/leftMenu.ftl">-->
<#--<#include "/layout/top.ftl">-->
    <h2 class="pageTitle">产品详情</h2>
</header>
<input type="hidden" value="${storeId!}" id="storeId">
<input type="hidden" value="${productId!}" id="productId">
<#--<input type="hidden" value="${productFashId!}" id="productFashId">-->
<#--<input type="hidden" value="${goodsId!}" id="goodsId">-->
<#--<input type="hidden" value="${addres}" id="addres">-->

<script>
    <#--var factionId="${productFashId!}";-->
    var sku="${goodsDetailsVo.goodsDto.sku!}";
    var productId="${productId}";
    <#--var provinceCode="${provoiceId!}";-->
    <#--var cityCode="${cityId!}";-->
    <#--var countyCode="${areaId!}";-->
    <#--var townCode="${addres!}";-->
    var count="1";
    <#--var storeCode = "${storeCode!}";-->
    <#--var goodsId = "${goodsId!}";-->
    <#--var activityId = "${activityId!}";-->
    <#--var activityCode = "${activityCode!'null'}";-->

</script>
<#--banner-->
<div class="detailList">
    <#--<div class="point">-->
        <#--<p>京东正品保证</p>-->
    <#--</div>-->
    <div class="swiper-container">
    <div class="swiper-wrapper">
    <#if goodsDetailsVo.goodsDto.goodsPictures??>
        <#list goodsDetailsVo.goodsDto.goodsPictures as goodsPictures>
            <div class="swiper-slide"><a><img src="${goodsPictures.bigPicturePath}"/></a></div>
        </#list>
    </#if>
    </div>
    <div class="swiper-pagination">

    <#if goodsDetailsVo.goodsDto.goodsPictures??>
        <#list goodsDetailsVo.goodsDto.goodsPictures as goodsPictures>
            <span class="swiper-pagination-bullet"></span>
        </#list>
    </#if>

    </div>
</div>
</div>
<#--名称价格-->
<div class="carouselText container" style="background: #FFFFFF;">
    <p style=" font-size: 1.3rem; text-align: left;padding: 5px;word-break: break-all;color: darkslategray;line-height: 1.8rem;">${goodsDetailsVo.goodsDto.name!}</p>
<#--<p style="color: red;">全场包邮，中秋节提前大促销全场包邮，中秋节提前</p>-->
    <hr class="divider"/>
    <p class="money">${goodsDetailsVo.goodsDto.salePrice!?string('0.00')}<span class="pix">元</span></p>
<#--<p class="jdMoney grey">京东价<span class="jdScore">${(goodsDetailsVo.goodsDto.marketPrice)!?c}金币</span></p>-->


<#--地址选择-->
    <#--<div class="addressTo"></div>-->
    <#--<div class="address">-->
        <#--<div class="addCon">-->
            <#--<span class="to" style="display: inline-block;color: #aaa;vertical-align: middle; margin-right: -4px; /*margin-top: -3px;*/">-->
                <#--送至-->
            <#--</span>-->
            <#--<span class="img" style="    display: inline-block; vertical-align: top;margin-top: -3px;">-->
                <#--<img src="/itaiping-mobile/goodsDetils/images/add.png" alt="" style="width: 24px;margin-top: 3px;" />-->
            <#--</span>-->
        <#--</div>-->
        <#--<div class="content" style="margin-left: -12px;">-->
            <#--<input type="text" style="-webkit-user-select:none;" id="addrClose" &lt;#&ndash;onselectstart="return false;"&ndash;&gt;-->
                   <#--placeholder="${DetailedAddress!"上海上海市浦东新区"}" value="${DetailedAddress!"上海上海市浦东新区"}" readonly="readonly"/><span id="Arrow"></span>-->
        <#--&lt;#&ndash;<input type="hidden" id="parentId" >&ndash;&gt;-->
        <#--</div>-->
    <#--</div>-->
    <#--<div class="addressTo"></div>-->
</div>

<!--城市选择内容-->
<#--<div class="addrWrap">-->
    <#--<#include "/layout/addrWrap.ftl">-->
<#--</div>-->
<div class="popupBg"></div>

<#--产品详情-->
<footer class="container">
    <ul id="myTab" class="nav nav-tabs">
        <li class="active"><a href="#productDetail" id="producetDetails" data-toggle="tab">商品详情 </a></li>
        <li><a href="#productFormat" data-toggle="tab" id="productParams">规格参数</a></li>
        <#--<li><a href="#assess" data-toggle="tab">客户评价</a></li>-->
    </ul>
<#--产品主图，详情，评价-->
    <div id="myTabContent" class="tab-content" style="padding-bottom: 4rem;overflow:scroll">
        <div class="tab-pane fade in active " id="productDetail">
        ${(goodsDetailsVo.goodsDto.introduction)!}
        </div>
        <div class="tab-pane fade  productFormat" id="productFormat">
        ${(goodsDetailsVo.goodsDto.param)!}
        </div>
    </div>


    <div class="buyButton " style="width: 103%;  line-height: initial;height:initial;">
        <div class="allBut"
             style="background: #fff; width: 27%;border-top: 1px solid #ddd;text-align: center ">
            <#--<div onclick="history.go(-1)" class="backActive"-->
                 <#--style="display: inline-block; width: 24%; vertical-align: middle; ">-->
                <#--<img class="backActiveImg" style="display: block;width: 2rem;text-align: center; margin: 0 auto;"-->
                     <#--src="/itaiping-mobile/${_v('/goodsDetils/images/returnShop.png')}" alt="">-->
                <#--<span class="backActiveText"-->
                      <#--style="display: block;font-size: 1rem; color: #555;margin: 0.2rem 0;">返回</span>-->
            <#--</div>-->
            <#--<a href="/itaiping-mobile/myCart">-->
                <#--<div class="shop" style="position: relative; display: inline-block;width: 24%;vertical-align: middle; ">-->
                    <#--<img class="shopImg" style="display: block;width: 1.6rem;text-align: center; margin: 0 auto;"-->
                         <#--src="/itaiping-mobile/${_v('/goodsDetils/images/shop.png')}" alt="">-->
                    <#--<span class="shopText"-->
                          <#--style="display: block;font-size: 1rem;color: #555;margin: 0.2rem 0;">购物车</span>-->
                <#--<span class="shopNum"-->
                      <#--style="position: absolute; display:none; top: -3px; right: 32.5%; color: #fff; border: 1px solid transparent; border-radius: 1rem;  width: 1.6rem;background: red;  font-size: 0.6rem;  text-align: center; ">-->
                <#--${(sumGoodsCount!0)}-->
                <#--</span>-->
                <#--</div>-->
            <#--</a>-->
            <span class="submitButton">
                <div class="blue" style="display:inline-block;border: none;width: 100%;height:4rem;color: #fff;background: #0096e7;text-align: center; vertical-align: middle;font-size: 1.2rem; line-height: 4rem;">
                    <span <#--onclick="toShipping('test20181000020407')"-->> 规格选择</span>
                </div>
                <div class="addShop " onclick="buy()"
                     style="display:none;border: none;width: 100%;height:4rem;color: #fff;background: #0096e7;text-align: center; vertical-align: middle;font-size: 1.2rem; line-height: 4rem;">
                </div>
                <#--<div class="notBuy "-->
                     <#--style="display:none;width: 48%;height:4rem;color: #fff;background: #afafaf;text-align: center; vertical-align: middle;font-size: 1.2rem; line-height: 4rem;">-->
                    <#--暂时缺货-->
                <#--</div>-->
            </span>
        </div>
    </div>
    <button class="backTop"></button>
</footer>

<!--規格選擇彈窗-->
<#--<div class="confirmP ">-->
    <#--<div class="container classCon " style="margin-bottom: 2rem;" id="container">-->
    <#--<#if goodsDetailsVo.goodsDto.goodsPictures??>-->
        <#--<#list goodsDetailsVo.goodsDto.goodsPictures as GoodsPicture>-->
            <#--<#if GoodsPicture_index==0>-->
                <#--<input id="img" type="hidden" value="${GoodsPicture.bigPicturePath}"/>-->
            <#--</#if>-->

        <#--</#list>-->
    <#--</#if>-->
        <#--<div class="imgClass class cla">-->
            <#--<span class="price">-->
                <#--<i style="width: 10rem;left: 7rem;" class="red" id="salePrice"></i>-->
            <#--</span>-->
        <#--</div>-->
        <#--&lt;#&ndash;<script>&ndash;&gt;-->
            <#--&lt;#&ndash;$(function () {&ndash;&gt;-->
                <#--&lt;#&ndash;var img = $("#img").val();&ndash;&gt;-->
                <#--&lt;#&ndash;$(".imgClass").css("background", "url('" + img + "')")&ndash;&gt;-->
                <#--&lt;#&ndash;$(".imgClass").css("background-size", "cover")&ndash;&gt;-->
            <#--&lt;#&ndash;});&ndash;&gt;-->
        <#--&lt;#&ndash;</script>&ndash;&gt;-->
    <#--&lt;#&ndash;规格&ndash;&gt;-->
        <#--<div id="productSpecifications" class="clearfix" style="margin-left: 15px;"></div>-->
    <#--&lt;#&ndash;规格js&ndash;&gt;-->
        <#--<script id="loadProductSpecifications" type="text/html">-->
            <#--{{if productSpecificationsVo.productStandardVos}}-->
            <#--{{each productSpecificationsVo.productStandardVos as productStandardVo productStandardVoIndex}}-->
            <#--<div class="chooseVersion clearfix" id="chooseVersion_{{productStandardVo.standardCode.replace('/', '')}}">-->
                <#--<input type="hidden" value="{{productStandardVo.standardCode}}">-->
                <#--<div class="dt">选择{{productStandardVo.name}}:</div>-->
                <#--<div class="dd chooseType clearfix">-->
                    <#--{{if productStandardVo.productStandardValueVos}}-->
                    <#--{{each productStandardVo.productStandardValueVos as productStandardValueVo productStandardValueVoIndex}}-->
                    <#--<div class="item" title="{{productStandardValueVo.attrValue}}">-->
                        <#--<a href="javascript:void(0);" data="{{productStandardValueVo.attrValue}}" {{if productStandardValueVo.active == "true"}} class="active"{{/if}}>{{productStandardValueVo.attrValue}}</a>-->
                    <#--</div>-->
                    <#--{{/each}}-->
                    <#--{{/if}}-->
                <#--</div>-->
            <#--</div>-->
            <#--{{/each}}-->
            <#--{{/if}}-->
        <#--</script>-->
    <#--</div>-->
<#--</div>-->
<#--错误提示-->
<span class="errorPop"></span>
</div>
</body>

<script src="${p_static}/admin/plugins/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
<script src="${p_static}/admin/plugins/swiper/js/swiper-3.3.1.min.js"></script>
<#--<script src="/itaiping-mobile/${_v('/plugins/angular1.2.32/angular.min.js')}"></script>-->
<script src="${p_static}/admin/js/fastclick.min.js"></script>
<#--<script src="/itaiping-mobile/${_v('/js/common.js')}"></script>-->
<#--<script src="/itaiping-mobile/${_v('/goodsDetils/js/productDetails.js')}" type="text/javascript"></script>-->
<#--<script type="text/javascript" src="/itaiping-mobile/${_v('/goodsDetils/js/address.js')}"></script>-->
<#--<script src="/itaiping-mobile/${_v('/goodsDetils/js/productDetailAll.js')}" type="text/javascript"></script>-->
<script>
    function startPhoto() {
        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            loop: true,
            effect: 'slide',
            paginationClickable: true,
            spaceBetween: 0,
            centeredSlides: true,
            autoplay: 3000,
            autoplayDisableOnInteraction: false
        });
    }

    $(function () {
        startPhoto();
    });

//    $('.addrWrap').load('/itaiping-mobile/common/addrWrap.html');
    //    $('.content').load('/itaiping-mobile/common/addrChoice.html');

    $("#productDetail div").css("width","100%");

//返回顶部按钮
$(document).ready(function () {
    $(".backTop").hide();
    $(function () {
        $(window).scroll(function () {
            var clientHeight = $(window).height();
            if ($(window).scrollTop() >= clientHeight) {
                $(".backTop").fadeIn(500);
            }
            else {
                $(".backTop").fadeOut(500);
            }
        });
        $(".backTop").click(function () {
            $('body,html').animate({scrollTop: 0}, 500);
            return false;
        });
    });
});
</script>
</html>