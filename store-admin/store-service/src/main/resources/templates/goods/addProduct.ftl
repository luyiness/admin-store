<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
    <link rel="stylesheet" href="${p_static}/admin/css/product/reset.css" type="text/css">
    <link rel="stylesheet" href="${p_static}/admin/css/product/storeBasicInfo.css" type="text/css">
    <link rel="stylesheet" href="${p_static}/admin/layui/css/layui.css" type="text/css">
    <#include "/include/head.ftl" />
    <style>

        .file-upload-content {
            width: 680px;
        }

        .table-tr-td {
            border-style: none;
        }

        .brand-td {
            width: 237px;
            line-height: 30px;
            padding-left: 10px;
            border: 1px solid #80808017;
            cursor: pointer;
        }

        .brand-td-title {
            width: 117px;
            line-height: 28px;
            padding-left: 10px;
            font-size: 20px;
            font-weight: bold;
        }

        .standardValue, .tableStandard {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            display: inline-block;
            cursor: pointer;
        }

        .tableStandard {
            margin-right: 0;
        }

        .standardValueDiv span {
            margin-right: 10px;
        }

        .standardValueDiv span:last-child {
            margin-right: 0;
        }

        .proListC {
            width: 75%;
            margin: 0 auto;
        }

        .proListCon .detilsList {
            width: 50% !important;
            float: left;
        }

        .proListCon input, .proListCon select {
            width: 60% !important;

        }

        .proPicCon {
            width: 60%;
            display: inline-block;
        }

        .h {
            overflow: hidden;
        }

        .main-header {
            z-index: 2;
        }

        /*附件上传失败弹窗*/
        .failCoverLayer header {
            background: #029bdf;
            color: #fff;
            font-size: 16px;
            padding: 6px 15px;
            height: 36px;
        }

        .failCoverLayer .coverCon {
            margin: 250px auto;
            width: 378px;
            height: 210px;
            background: #fff;
        }

        .failCoverLayer .tipsIconC {
            background: url("../images/failIcon.png") no-repeat 100%;
            display: inline-block;
            width: 62px;
            height: 60px;
        }

        .failCoverLayer .closeTips {
            cursor: pointer;
        }

        .failCoverLayer .failTips {
            display: table;
            height: 100px;
            width: 100%;
            padding-top: 15px;
        }

        .failCoverLayer .failTipsCon {
            display: table-cell;
            vertical-align: middle;
        }

        .failTips {
            display: table;
            height: 100px;
            width: 100%;
        }

        .failCoverLayer .tipsIconBox {
            padding-right: 0;
            margin-left: -8px;
        }

        .failCoverLayer .insuredTips {
            font-size: 14px;
            height: 48px;
            line-height: 25px;
            color: #000;
            text-align: center;
        }

        .failCoverLayer .sureBtnBox {
            text-align: center;
            margin: 0 auto;
            margin-top: 10px;
        }

        .btnSure {
            display: inline-block;
            width: 90px;
            height: 32px;
            line-height: 30px;
            border: 1px solid #029bdf;
            background: #029bdf;
            color: #fff;
            cursor: pointer;
        }

        .goback {
            width: 100px;
            height: 32px;
            line-height: 32px;
            color: #ffffff;
            background-color: #199eda;
            border-radius: 5px;
            text-decoration: none;

        }

        .goback:hover {
            color: #ffffff;
        }

        #infoDetail {
            position: relative;
        }

        .info_modal {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 1000;
            display: none;

            background-color: #cccccc;
            opacity: 0.1;
        }

        #goodsInfo {
            position: relative;
        }

        .goods_modal {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 1000;
            background-color: #cccccc;
            opacity: 0.1;
            display: none;
        }

        .goList {
            text-align: center;
            width: 100px;
            height: 32px;
            line-height: 32px;
            color: #ffffff;
            background-color: #199eda;
            border-radius: 5px;
            text-decoration: none;
            margin-left: 42%;
            display: none;

        }

        .goList:hover {
            color: #ffffff;
        }

        /*自定义公共遮罩层*/
        .sDefi-coverLayer {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            padding-top: 15%;
            z-index: 999;
            background: rgba(0, 0, 0, 0.5);
            display: none;
        }

        .sDefi-receiverTitle {
            color: #fff;
            background-color: #199eda;
            height: 40px;
            padding-left: 10px;
            padding-top: 7px;
            position: relative;
        }

        .sDefi-receiverTitle .sDefi-closeBtn {
            float: right;
            position: absolute;
            top: 14px;
            right: 8px;
            font-size: 14px;
            cursor: pointer;
            color: #ffffff;
        }

        .sDefi-reprotLayer, .sDefi-reprotResultLayer {
            margin: 0 auto;
            width: 470px;
            padding-bottom: 15px;
            background-color: #fff;
        }

        .sDefi-reprotInfo, .sDefi-reprotResultInfo {
            padding: 20px 30px;
        }

        .sDefi-reprotInfoC {
            text-align: center;
        }

        .sDefi-insuredTips {
            display: inline-block;
            vertical-align: middle;
            font-size: 14px;
        }

        /*两个按钮*/
        .sDefi-resultBtnC {
            height: auto;
        }

        .sDefi-resultBtnC span {
            display: inline-block;
            vertical-align: middle;
            color: #fff;
            cursor: pointer;
            width: 120px;
            line-height: 35px;
            text-align: center;
            margin-right: -25px;
            margin-left: 76px;
            margin-top: 50px;
        }

        .sDefi-resultBtnC span.sDefi-sureEditBtn {
            background: #199eda;
        }

        .sDefi-resultBtnC span.sDefi-sureEditBtn:hover {
            background: #2bb9da;
        }

        .sDefi-resultBtnC span.sDefi-cancelEditBtn {
            /*background: #b7b7b7;*/
            color: #199eda;
            border: 1px solid #199eda;
            margin-left: 40px;
        }

        .sDefi-icon {
            font-size: 20px;
            color: #ff8a00;
            display: inline-block;
            padding-right: 5px;
            vertical-align: middle;
        }

        .sDefi-resultSureBtn {
            cursor: pointer;
            width: 120px;
            line-height: 35px;
            background: #199eda;
            color: #fff;
            margin: 0 auto;
            text-align: center;
        }

        .sDefi-resultSureBtn {
            margin: 20px auto;
        }

        /*自定义公共遮罩层end*/

        /*----------------自定义弹出层---------------->*/
        /* 弹出框最外层 */
        .msg__wrap {
            position: fixed;
            top: 50%;
            left: 50%;
            z-index: 10;
            transition: all .3s;
            transform: translate(-50%, -50%) scale(0, 0);
            max-width: 50%;

            background: #fff;
            box-shadow: 0 0 10px #eee;
            font-size: 10px;
        }

        /* 弹出框头部 */
        .msg__wrap .msg-header {
            padding: 10px 10px 0 10px;
            font-size: 1.8em;
        }

        .msg__wrap .msg-header .msg-header-close-button {
            float: right;
            cursor: pointer;
        }

        /* 弹出框中部 */
        .msg__wrap .msg-body {
            padding: 10px 10px 10px 10px;
            display: flex;
        }

        /* 图标 */
        .msg__wrap .msg-body .msg-body-icon {
            width: 80px;
        }

        .msg__wrap .msg-body .msg-body-icon div {
            width: 45px;
            height: 45px;
            margin: 0 auto;
            line-height: 45px;
            color: #fff;
            border-radius: 50% 50%;
            font-size: 2em;
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-success {
            background: #32a323;
            text-align: center;
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-success::after {
            content: "成";
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-wrong {
            background: #ff8080;
            text-align: center;
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-wrong::after {
            content: "误";
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-info {
            background: #80b7ff;
            text-align: center;
        }

        .msg__wrap .msg-body .msg-body-icon .msg-body-icon-info::after {
            content: "注";
        }

        /* 内容 */
        .msg__wrap .msg-body .msg-body-content {
            min-width: 200px;
            font-size: 1.5em;
            word-break: break-all;
            display: flex;
            align-items: center;
            padding-left: 10px;
            box-sizing: border-box;
        }

        /* 弹出框底部 */
        .msg__wrap .msg-footer {
            padding: 0 10px 10px 10px;
            display: flex;
            flex-direction: row-reverse;
        }

        .msg__wrap .msg-footer .msg-footer-btn {
            width: 50px;
            height: 30px;
            border: 0 none;
            color: #fff;
            outline: none;
            font-size: 1em;
            border-radius: 2px;
            margin-left: 5px;
            cursor: pointer;
        }

        .msg__wrap .msg-footer .msg-footer-cancel-button {
            background-color: #ff3b3b;
        }

        .msg__wrap .msg-footer .msg-footer-cancel-button:active {
            background-color: #ff6f6f;
        }

        .msg__wrap .msg-footer .msg-footer-confirm-button {
            background-color: #4896f0;
        }

        .msg__wrap .msg-footer .msg-footer-confirm-button:active {
            background-color: #1d5fac;
        }

        /* 遮罩层 */
        .msg__overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            z-index: 5;
            background-color: rgba(0, 0, 0, .4);
            transition: all .3s;
            opacity: 0;
        }

        /*<----------------自定义弹出层----------------*/

        .goodsInfoCoverLayer {
            z-index: 900;
        }

    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
    <#include "/include/top-menu.ftl"/>
    <#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <section class="content-header">
            <h1>
                添加产品
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/product/goodsList">商品管理</a></li>
                <li class="active">
                    添加产品
                </li>
            </ol>
        </section>

        <section class="content" style="padding-left: 0px;">
            <div class="infoC">
                <div class="infoTop h">
                    <em>
                        您选择的类目：
                    </em>
                    <span class="categoryName"></span> ->
                    <span class="categoryName"></span> ->
                    <span class="categoryName"></span>
                    <button onclick="reChooseCategory()" class="reChoice fr"
                            style="border: none;outline: none;font-size: 15px;">
                        重选类目
                    </button>
                </div>
                <div class="infoListC">
                    <#--基本内容-->
                    <div class="infoList">
                        <p class="infoTit">基本内容</p>
                        <div class="infoListDetils proListCon">
                            <div class="proListC h">
                                <div class="detilsList">
                                    <label style="width: 80px;"><em class="red">*</em>产品名称：</label>
                                    <input type="text" id="modelName" maxlength="50" placeholder="">
                                </div>
                                <div class="detilsList">
                                    <label><em class="red">*</em>品牌：</label>
                                    <input type="text" maxlength="0" id="brandName" onclick="showBrands()"
                                           placeholder="请选择">
                                    <input style="display:none;" id="brandId">
                                </div>
                            </div>
                        </div>
                    </div>
                    <#--商品属性-->
                    <div class="infoList infoListH" id="commodityAttributeId">
                        <p class="infoTit">商品属性</p>
                        <div id="productStandardDiv" class="infoListDetils">

                        </div>
                    </div>
                    <#--商品列表-->
                    <div class="infoList goodsList" style="display: none;" id="catalogueId">
                        <p class="infoTit">商品列表</p>
                        <div id="goodsTableDiv"
                             class="infoListDetils">
                        </div>
                    </div>
                    <#--操作按钮-->
                    <div class="submitBtn"
                         style="margin: 0 auto;text-align:center; width: 50%;margin-bottom: 30px;">
                        <a href="javascript:history.go(-1)"
                           style="display: inline-block;margin-right: 30px; border: 1px solid #199eda;"
                           onclick="goBack()"
                           class="goback">返回上一页</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <div id="goBackBatchSaveProductId"
                             style="display: inline-block;margin-right: 30px;color: #199eda; border: 1px solid #199eda;background: transparent;display: none"
                             class="reChoice" onclick="goBackBatchSaveProduct()">上一步
                        </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <div style="display: inline-block;margin-right: 30px;color: #199eda; border: 1px solid #199eda;background: transparent;"
                             class="reChoice " onclick="nextToBatchSaveProduct()" id="nextToBatchSaveProductId">下一步
                        </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <div style="display: inline-block;margin-right: 30px;color: #199eda; border: 1px solid #199eda;background: transparent;display: none"
                             class="reChoice " onclick="batchSaveProduct()" id="batchSaveProductId">批量提交
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<div class="reportResultCoverLayer coverLayer f-hide" id="message-modal">
    <div class="reprotLayer">
        <div class="receiverTitle" style="padding-top: 3px;">
            <h5 class="title">温馨提示</h5>
            <span class="closeBtn" style="font-size: 18px;top: 6px;">x</span>
        </div>
        <div class="reprotInfo">
            <div class="reprotInfoC reprotResultInfoC">
                <div class="failList">
                    <h6 class="insuredTips" style="font-size: 15px;"></h6>
                </div>
            </div>
            <p class="resultSureBtn" rel="close" onclick="cannle(this);">确 定</p>
            <p class="resultBtnC"><span class="sureEditBtn">确  定</span><span onclick="cannle(this)"
                                                                             class="cancelEditBtn">取  消</span></p>
        </div>
    </div>
</div>

<#--附件上传失败弹窗-->
<div class="coverLayer   failCoverLayer f-hide">
    <div class="coverCon">
        <header class="h" style="position: relative">
            <h5 class="title" style="width: 50%;display: inline-block;margin: 0;">温馨提示</h5>
            <span class="closeBtn" style="font-size: 18px;float: right;margin-top: -2px;">x</span>
        </header>
        <div class="failTips">
            <div class="failTipsCon row">
                <#--<span class="col-xs-4 text-right tipsIconBox"><span class=" tipsIconC"></span></span>-->
                <div class="col-xs-1"></div>
                <div class="col-xs-10">
                    <p class="insuredTips">您上传的文件格式不符合规则（只能上传图片），请重新上传</p>
                </div>
                <div class="col-xs-1"></div>
            </div>
        </div>
        <div class="sureBtnBox">
            <span class="btnSure" id="btnSure">确定</span>
        </div>
    </div>
</div>
<#--重选类目弹窗-->
<div class="reChoiceCoverLayer coverLayer f-hide" id="message-modal">
    <div class="reprotLayer">
        <div class="receiverTitle" style="padding-top: 3px;">
            <h5 class="title">温馨提示</h5>
            <span class="closeBtn" style="font-size: 18px;top: 6px;">x</span>
        </div>
        <div class="reprotInfo">
            <div class="reprotInfoC reprotResultInfoC">
                <div class="failList">
                    <h6 class="insuredTips" style="font-size: 15px;">此操作将不保留现有的信息,您确定重选吗?</h6>
                </div>
            </div>
            <p class="resultBtnC" style="display: block;margin-top: 30px;">
                <span class="sureEditBtn" onclick="sureReChoice()">确  定</span>
                <span onclick="cannle(this)" class="cancelEditBtn">取  消</span>
            </p>
        </div>
    </div>
</div>

<div style="display: none;">
    <div id="main_image_sample_id" style="color: red;padding-top: 8px;height: 37px;text-align: end;">此图为展示在商品详情页的主图
    </div>
</div>

<#include "/include/foot.ftl"/>

<#--品牌弹窗-->
<div class="findBrandCoverLayer coverLayer f-hide" id="sDefi-message-modal" style="padding-top: 5%;">
    <div class="sDefi-reprotLayer" style="width: 750px;height: 500px;padding-bottom: 0px;">
        <div class="col-xs-12" style="padding:0px;height: 100%;">
            <form id="rightFormData" action="" class="form-inline well" method="post"
                  style="overflow: hidden;padding: 0px;height: 100%;background-color: white;">
                <div class="col-xs-12"
                     style="padding-top: 10px;height: 50px;padding-left: 0px;padding-right: 0px;border-bottom: 1px solid #80808080;">
                    <div class="form-group" style="width: 300px;">
                        <label style="width: 20px;"></label>
                        <label>品牌名称：</label>
                        <input type="text" id="provider_brand_name" name="provider_brand_name" class="form-control"
                               style="width: 60%;height: 26px;">
                        <input hidden id="provider_brand_id">
                    </div>
                    <div class="form-group">
                        <button type="button" class="btn btn-brand-search"
                                onclick="findBrand($('#provider_brand_name').val())"
                                style="height: 28px;padding: 3px 18px;">搜索
                        </button>
                    </div>
                </div>
                <div id="brandTableScroll"
                     style="width: 100%;height: 392px;overflow-y: scroll;overflow-x: hidden;padding-left: 10px;">
                    <table style="width: 100%;">
                        <thead id="brandInfo">
                        </thead>
                    </table>
                </div>
                <script id="brandShow" type="text/html">
                    {{if brands.length > 0}}
                    {{each brands as brand}}
                    <tr>
                        <td class="brand-td-title" style="border-style: none;">{{brand.character}}</td>
                        <td style="border-style: none;"></td>
                        <td style="border-style: none;"></td>
                        <td style="border-style: none;"></td>
                    </tr>
                    <tr>
                        {{each brand.providerBrandDtos as providerBrand providerBrand_index}}
                        {{if providerBrand_index == 0}}
                        <td class="brand-td" id="{{providerBrand.id}}">
                            {{if providerBrand.isCoreBrand}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span style="color:#F00">{{providerBrand.name}}</span>
                            </div>
                            {{else}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span>{{providerBrand.name}}</span>
                            </div>
                            {{/if}}
                        </td>
                        {{else if (providerBrand_index+1) %3 == 0 }}
                        <td class="brand-td" id="{{providerBrand.id}}">
                            {{if providerBrand.isCoreBrand}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span style="color:#F00">{{providerBrand.name}}</span>
                            </div>
                            {{else}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span>{{providerBrand.name}}</span>
                            </div>
                            {{/if}}
                        </td>
                    </tr>
                    <tr>
                        {{else}}
                        <td class="brand-td" id="{{providerBrand.id}}">
                            {{if providerBrand.isCoreBrand}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span style="color:#F00">{{providerBrand.name}}</span>
                            </div>
                            {{else}}
                            <div onclick='providerBrandSpan("{{providerBrand.id}}","{{providerBrand.name}}")'>
                                <span>{{providerBrand.name}}</span>
                            </div>
                            {{/if}}
                        </td>
                        {{/if}}
                        {{/each}}
                    </tr>
                    {{/each}}
                    {{else}}
                    <tr>
                        <td colspan="4" style="text-align: center;height: 380px;"><label>没有检索到数据，请换个条件试试</label>
                        </td>
                    </tr>
                    {{/if}}
                </script>
                <div style="text-align: center; margin-top: 10px;">
                    <button type="button" class="btn" id="brand-sureBtn" onclick="sureProviderBrand()"
                            style="margin-right:150px;background-color: #0dadec; color: white;">
                        确 定
                    </button>
                    <button type="button" class="btn" id="importBtn" onclick="sDefi_message_modal_Close()">
                        取 消
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<#--录入商品信息-->
<div class="goodsInfoCoverLayer coverLayer f-hide" id="sDefi-goodsInfo-id"
     style="padding-top: 5%;padding-left: 5%;padding-right: 5%;padding-bottom: 10%;">
    <div class="sDefi-reprotLayer"
         style="overflow: hidden;overflow-x: hidden;overflow-y: scroll;height: 100%;width: 100%;">
        <div class="col-xs-12" style="padding:0px;height: 100%;">
            <#--商品基本信息-->
            <div class="infoList goodsInfo">
                <div class="infoTit col-xs-6" style="width: 50%;">商品基本信息</div>
                <div class="infoTit col-xs-6" style="width: 50%;text-align: right;">
                    <a style="color:#000;" onclick="closeGoodsInfoCoverLayer()">×</a>
                </div>
                <div class="col-xs-12 infoListDetils proListCon h">
                    <p class="infoTip h"><span class="fl">提示：价格的发布和修改有可能会有延迟，如果出现敬请谅解</span></p>
                    <div class="proListC h">
                        <div class="detilsList">
                            <label><em class="red">*</em>名称：</label>
                            <input type="text" id="goodsName" placeholder="请不要输入特殊字符" maxlength="50">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>重量：</label>
                            <input type="text" id="weight" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>产地：</label>
                            <input type="text" id="productArea" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red"></em>条形码：</label>
                            <input type="text" id="upc" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>销售单位：</label>
                            <input type="text" id="saleUnit" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>包装清单：</label>
                            <input type="text" id="wareQD" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>库存：</label>
                            <input type="text" id="stockCount" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>协议价：</label>
                            <input type="text" id="costPrice" placeholder="">
                        </div>
                        <div class="detilsList">
                            <label><em class="red">*</em>市场价：</label>
                            <input type="text" id="marketPrice" placeholder="">
                        </div>
                    </div>
                </div>
            </div>
            <#--图片管理-->
            <div class="infoList goodsInfo" id="goodsInfo" style="overflow: hidden;">
                <div class="goods_modal"></div>
                <p class="infoTit">图片管理</p>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 300px;" class="table-tr-td">
                            <div style="text-align: center">
                                <img src="${ctx}/admin/images/main-image-sample-s.png">
                            </div>
                            <div style="text-align: center;">示例</div>
                        </td>
                        <td style="width: auto;" class="table-tr-td">
                            <div class="infoListDetils">
                                <div class="detilsList imgList file-uploads-group">
                                    <label style="width: 100px;/*vertical-align: top;*/">
                                        <em class="red">*</em>商品图片：
                                    </label>
                                    <div class="proPicCon">
                                        <div class="file-upload-content">
                                            <div id="fileinput-container">
                                            </div>
                                            <span class="add-fileinput-button iconfont"
                                                  style="display: none;">+
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <#--商品描述-->
            <div class="infoList goodsInfo" id="infoDetail">
                <p class="infoTit">商品描述</p>
                <div class="infoListDetils">
                    <div class="detilsList imgList"><label><em class="red">*</em>详情：</label>
                        <div class="proDetils">
                        <textarea class="" id="description"
                                  name="description"
                                  rows="10" cols="80" style="width: 100%;">
                        </textarea>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" name="productCategoryId" id="productCategoryId" value="${productCategoryId!}">
            <input type="hidden" name="productModelSku" id="productModelSku" value="">
            <input type="hidden" name="modelId" id="modelId" value="">
            <input type="hidden" name="goodsSku" id="goodsSku" value="${goodsSku!}">
            <input type="hidden" name="specification" id="specification" value="">
            <input type="hidden" name="providerGoodsId" id="providerGoodsId" value="${providerGoodsId!}">
            <#--规格id-->
            <input type="hidden" id="standardValueId">
            <input type="hidden" name="errorMsg" id="errorMsg" value="${errorMsg}">
            <input type="hidden" name="modelSku" id="modelSku" value="${modelSku!}">
            <#--按钮-->
            <div style="text-align: center">
                <div style="display: inline-block;margin-right: 30px; border: 1px solid #199eda;"
                     class="reChoice" onclick="saveGoodsInfoCoverLayer($('#standardValueId').val())">确定
                </div>
                <div style="display: inline-block;margin-right: 30px;color: #6e6e6e; border: 1px solid #dfdfdf;background: transparent;"
                     class="reChoice" onclick="closeGoodsInfoCoverLayer()">取消
                </div>
            </div>
            <div>
                &nbsp;
            </div>
            <div>
                &nbsp;
            </div>
        </div>
    </div>

</div>

<#include "/include/resource.ftl"/>
<script type="text/javascript"
        src="${p_static}/admin/layui/layui.js"></script>
<script type="text/javascript"
        src="${c_static}/lte/plugins/ckeditor_4.8.0_standard/ckeditor.js"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/jQuery/fileuploader/js/vendor/jquery.ui.widget.js')}"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.iframe-transport.js')}"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload.js')}"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload-process.js')}"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload-validate.js')}"></script>
<script type="text/javascript"
        src="${c_static}${_v('/plugins/artTemplate/template.js')}"></script>

<script>
    var v = new Date().getFullYear() + "" + (new Date().getMonth() + 1) + "" + new Date().getDate() + "" + new Date().getHours();
    document.write("<script type='text/javascript' src='${p_static}/admin/js/goods/addProduct.js?v=" + v + "'><\/script>");
</script>

<script id="uploadImage_" type="text/html">
    <div class="fileupload" style="position: relative">
        <span class="fileinput-button">
            {{title}}
        </span>
        <span class="fileinput-name">
            {{if uploading}}
                上传中...
            {{else}}
            {{fileName}}
            {{/if}}
        </span>
        <span class="del-fileinput-button iconfont" onclick="bindFileuploadDelEvents(this)" rel-idx="{{idx}}"
              style="{{if showDelBtn}}{{else}}display:none;{{/if}}z-index:{{999 - idx}}">-</span>
        <input class="fileupload-input" type="file"
               style="float: left;position: relative;top: -36px;z-index: 998;width: 326px;font-size: 0px;cursor: pointer;height: 100%;opacity: 0;"
               data-fileupload-idx="{{idx}}"
               data-uploading="{{if uploading}}true{{else}}false{{/if}}"
               data-url="{{uploadUrl}}" value="{{filePath}}"/>

        <div style="position: absolute;left: 0;top: 0;width: 380px;height: 36px;z-index: 999;background: transparent;display: none;">
        </div>
    </div>
</script>

<script>
    var v = new Date().getFullYear() + "" + (new Date().getMonth() + 1) + "" + new Date().getDate();
    document.write("<script type='text/javascript' src='${p_static}/admin/js/product/storeBasicInfo.js?v=" + v + "'><\/script>");
</script>


<script id="productBrand_" type="text/html">
    <option value="" selected="selected">请选择</option>
    {{if data}}
    {{each data as brand i}}
    <option value="{{brand.id}}">{{brand.name}}</option>
    {{/each}}
    {{/if}}
</script>

<script id="productStandard_" type="text/html">
    <span style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;属性框文字可编辑</span>
    {{if data}}
    {{each data as standard i}}
    <div class="detilsList">
        <label style="vertical-align: top;margin-top: 8px;" class="standardName">{{standard.name}}</label>
        <div class="standardValueDiv" style="width: 65%;display: inline-block;vertical-align: top;">
            {{each standard.categoryStandardValues as val i}}
            <span style="margin-bottom: 10px;display: inline-block;vertical-align: middle;width: 48%;cursor: pointer;">
                <input class="standardValue" onchange="lockStandardInput(this,'{{standard.name}}');" type="checkbox"
                       value="{{val.value}}">
                <input type="text" maxlength="50" value="{{val.value}}" class="standardValueInput"
                       style="width: 90%;margin-left: 5px;" onchange="validateStandardValue(this)"
                       onblur="validateStandardValue(this)"/>
            </span>
            {{/each}}
        </div>
    </div>
    {{/each}}
    {{/if}}
</script>

<script>
    var editorTxt = CKEDITOR.replace('description');
    var goodsTables;

    var standardNames = [];
    var standardNameForCheck = [];

    function showMessage(options) {
        var defaults = {
            title: "温馨提示",
            message: ""
        };
        var o = $.extend(defaults, options);
        var modal = $('#message-modal');
        modal.find('.title').html(o.title);
        modal.find('.insuredTips').html(o.message).css({'margin': '0 auto;', 'text-align': 'center;'});
        modal.removeClass('f-hide');
    }

    function showCannle() {
        $("#message-modal").find(".resultSureBtn").hide();
        $("#message-modal").find(".resultBtnC").show();
    }

    function hideCannle() {
        $(document).off("click", ".sureEditBtn");
        $("#message-modal").find(".resultSureBtn").show();
        $("#message-modal").find(".resultBtnC").hide();

    }

    function cannle(obj) {
        $(obj).parents('.coverLayer').addClass('f-hide');
        hideCannle();
    }

    function lockStandardInput(obj, standardName) {
        if ($(obj).is(":checked")) {
            standardNameForCheck.push(standardName);
            var standardValue = $(obj).parent().find("input[type='text']").val();
            if (standardValue == undefined || standardValue == "") {
                showMessage({message: "请先填写该规格"});
                $(obj).removeProp("checked");
                return;
            }
            $(obj).val(standardValue);
            $(obj).parent().find("input[type='text']").prop("readOnly", true).css("background-color", "rgb(233,233,233)");
        } else {
            for (var i = 0; i < standardNameForCheck.length; i++) {
                var element = standardNameForCheck[i];
                if (element == standardName) {
                    standardNameForCheck[i] = "";
                    break;
                }
            }
            $(obj).parent().find("input[type='text']").removeProp("readOnly").css("background-color", "white");
        }
    }

    function showGoodsTable() {
        var standardListDiv = $("#productStandardDiv").find(".detilsList");
        var standardList = new Array;
        var isShow = true;
        var titleVals = new Array;
        for (var i = 0; i < standardListDiv.length; i++) {
            titleVals.push($(standardListDiv.get(i)).find(".standardName").text());
            var checkedInput = $(standardListDiv.get(i)).find("input:checkbox:checked");
            if (checkedInput && checkedInput.length < 1) {
                isShow = false;
                break;
            } else {
                var standardValueList = new Array;
                for (var j = 0; j < checkedInput.length; j++) {
                    var standardValue = $(checkedInput.get(j)).parent().find("input[type='text']").val();
                    standardValueList.push(standardValue)
                }
                standardList.push(standardValueList);
            }
        }

        if (isShow) {
            $(".goodsList").show();
            $("#goodsTableDiv").show();
            var standardGoods = splitMain(standardList);
            var titiles = new Array;
            var tableData = new Array;
            if (standardGoods.length > 0) {
                for (var i = 0; i < titleVals.length; i++) {
                    titiles.push({title: titleVals[i]})
                }
                var rowCount = 0;
                titiles.push({title: "状态"})
                titiles.push({title: "操作"})
                for (var i = 0; i < standardGoods.length; i++) {
                    var columns = standardGoods[i].split("||");
                    var columnDatas = new Array;
                    for (var j = 0; j < columns.length; j++) {
                        columnDatas.push(columns[j])
                        if (j == columns.length - 1) {

                            var rColumns = standardGoods[i].split("||");
                            var rColumnDatas = "";
                            for (var k = 0; k < rColumns.length; k++) {
                                rColumnDatas += escapeJquery(rColumns[k].replace(/ /g, ""));
                            }
                            var rFlag = false;
                            isSaveProducts.forEach(value => {
                                if (value == rColumnDatas) {
                                    rFlag = true;
                                }
                            });
                            if (rFlag) {
                                columnDatas.push("已提交");
                            } else {
                                columnDatas.push("未录入");
                            }
                            columnDatas.push(standardGoods[i]);
                            rowCount = j + 1;
                        }
                    }
                    tableData.push(columnDatas);
                }
                GoodsTableFunc.createGoodsTable(titiles, tableData);
            }
        } else {
            $(".goodsList,.goodsInfo").hide();
            $("#goodsTableDiv").hide();
        }
    }

    $(function () {
        $.ajax({
            url: "getCategoryInfo",
            data: {
                productCategoryId: $("#productCategoryId").val(),
                sku: $("#goodsSku").val()
            },
            success: function (data) {
                if (data.status == "success") {

                    var cateList = $(".categoryName");
                    var categoryNames = data.data.categoryNames;
                    for (var i = 0; i < cateList.length; i++) {
                        $(cateList.get(i)).text(categoryNames[i]);
                    }
                    if (data.data.brands.length > 0) {
                        $("#brandId").val(data.data.brands[0].id);
                        $("#brandName").val(data.data.brands[0].name);
                    }
                    /*$("#brandId").html(template('productBrand_', {data: data.data.brands}));*/
                    $("#productStandardDiv").html(template('productStandard_', {data: data.data.productCategoryStandardDTOS}));

                    /*data.data.productCategoryStandardDTOS.forEach(function (item, index, arr) {
                        standardNames.push(item)
                    });*/
                    data.data.productCategoryStandardDTOS.filter(function (item) {
                        standardNames.push(item.name)
                    });

                    standardValueChange();

                }
            },
            error: function (e) {
            }
        })
        setTimeout("loadPage()", 500);
    })

    function standardValueChange() {
        $(".standardValue").change(function () {
            if (!$(this).is(":checked")) {
                var showPopFlag = false;
                for (var i = goodsDatas.length - 1; i >= 0; i--) {
                    if (goodsDatas[i].stardard.indexOf($(this).val()) >= 0) {
                        showPopFlag = true;
                    }
                }
                if (showPopFlag) {
                    if (window.confirm("此操作将会删除该规格下所有商品信息,您确定删除吗?")) {
                        var len = goodsDatas.length - 1;
                        if (len >= 0) {
                            for (var i = len; i >= 0; i--) {
                                if (goodsDatas[i].stardard.indexOf($(this).val()) >= 0) {
                                    if (goodsDatas[i] && goodsDatas[i].sku != "") {
                                        delGoodsDatas.push(goodsDatas[i].sku);
                                    }
                                    goodsDatas.splice(i, 1);
                                }
                            }
                        }

                    } else {
                        //$(this).prop("checked",true);
                        $(this).trigger("click");
                        showGoodsTable();
                    }
                }
            }
        });
    }

    function loadPage() {
        if ($("#goodsSku").val() && $("#goodsSku").val() != "") {
            $.ajax({
                url: "findProviderGoods",
                data: {goodsSku: $("#goodsSku").val()},
                success: function (data) {
                    if (data.status == "success") {
                        $("#productStandardDiv").html(template('productStandard_', {data: data.data.productCategoryStandardDTOS}));
                        var providerGoodsList = data.data.providerGoodsList;
                        for (var goods of providerGoodsList) {
                            var specifications = [];
                            for (var goodsSpecification of goods.providerGoodsSpecifications) {
                                specifications.push(goodsSpecification.value);
                                $("input[value='" + goodsSpecification.value + "']").attr("checked", true);
                            }
                            goods.stardard = specifications.join("||");
                        }
                        goodsDatas = providerGoodsList;
                        ProductEditFunc.setProductModel(data.data.productModel);
                        ProductEditFunc.setGoods2Ducument(data.data.providerGoods);
                        $(".standardValueInput").prop("readOnly", true).css("background-color", "rgb(233,233,233)");
                        showGoodsTable();
                        $(".goodsInfo").show();
                        standardValueChange();
                    }
                },
                error: function (e) {
                }
            })
        } else {
            addFileUploader(fileUploadViewModel, 0);
        }
    }

    //用于操作产品详情的符文本框
    var ProductDetailFunctionBundle = {
        getCkeditorHtmlMsgByID: function (ckeditorid) {
            var ckinstance = eval("CKEDITOR.instances." + ckeditorid);
            var text = ckinstance.getData();
//                alert(text);
            return text;
        },
        setCkeditorHtmlMsgByID: function (ckeditorid, msg) {
            var ckinstance = eval("CKEDITOR.instances." + ckeditorid);
            ckinstance.setData(msg);
        },
        getCkeditorHtmlMsg: function () {
            var ckinstance = CKEDITOR.instances.description;
            var text = ckinstance.getData();
            return text;
        },
        setCkeditorHtmlMsg: function (msg) {
            var ckinstance = CKEDITOR.instances.description;
            ckinstance.setData(msg);
        },
        testCkeditor: function () {
            this.setCkeditorHtmlMsg(this.getCkeditorHtmlMsg());
        }
    };


    function splitArray(arr, depth) {
        for (var i = 0; i < arr[depth].length; i++) {
            result[depth] = arr[depth][i]
            if (depth != arr.length - 1) {
                splitArray(arr, depth + 1);
            } else {
                results.push(result.join('||'));
            }
        }
    }

    function splitMain(arr) {
        results = [];
        result = [];
        splitArray(arr, 0);
        return results;
    }

    $('.goList').hide();

    var goodsDatas = new Array;
    var delGoodsDatas = new Array;

    var ProductEditFunc = {
        getProductModel: function () {
            if (!ProductEditFunc.modelValidate(true)) {
                return false;
            }
            var providerProductModel = {};
            providerProductModel.categoryId = $("#productCategoryId").val();
            providerProductModel.modelSku = $("#modelSku").val();
            providerProductModel.modelId = $("#modelId").val();
            providerProductModel.name = $("#modelName").val();
            providerProductModel.brandId = $('#brandId').val();
            return providerProductModel;
        },
        modelValidate: function (showPop) {
            var modelName = $("#modelName").val();
            var brandId = $('#brandId').val();
            if (modelName == undefined || modelName == "") {
                if (showPop) {
                    showMessage({message: "请填写产品名称"});
                    return false;
                }
            }
            if (brandId == undefined || brandId == "" || brandId == "") {
                if (showPop) {
                    showMessage({message: "请选择产品品牌"});
                    return false;
                }
            }
            return true;
        },
        setGoodsDatas: function () {
            if (!ProductEditFunc.goodsDataValidate(true)) {
                return false;
            }
            $(".goodsInfo").hide();
            var goodsData = {};
            var providerGoodsId
            var goodsName = $("#goodsName").val();
            var sku = $("#sku").val();
            var weight = $("#weight").val();
            var productArea = $("#productArea").val();
            var upc = $("#upc").val();
            var saleUnit = $("#saleUnit").val();
            var wareQD = $("#wareQD").val();
            var stockCount = $("#stockCount").val();
            var costPrice = $("#costPrice").val();
            var productModelSku = $("#productModelSku").val();
            var specification = $("#specification").val();
            var goodsSku = $("#goodsSku").val();
            var marketPrice = $("#marketPrice").val();

            var standardValueId = $("#standardValueId").val();
            goodsData.standardValueId = standardValueId;

            if (sku == ""
                || sku == undefined
                || goodsData.sku == ""
                || goodsData.sku == undefined) {
                $.ajax({
                    url: "getsku",
                    type: "POST",
                    contentType: "application/json",
                    async: false,
                    success: function (data) {
                        sku = data;
                    },
                    error: function () {
                        showMessage({message: "商品sku生成失败"});
                        return;
                    }
                });
            }

            goodsData.id = providerGoodsId;
            goodsData.modelSku = productModelSku
            goodsData.weight = weight
            goodsData.name = goodsName;
            goodsData.productArea = productArea;
            goodsData.upc = upc;
            if (goodsSku == ""
                || goodsSku == undefined) {
                goodsData.sku = sku;
            } else {
                goodsData.sku = goodsSku;
            }
            goodsData.saleUnit = saleUnit;
            goodsData.marketPrice = marketPrice;
            goodsData.wareQD = wareQD;
            goodsData.costPrice = costPrice;
            goodsData.stockCount = stockCount;
            goodsData.brandName = $("#brandId").text();
            goodsData.stardard = specification;
            var specifications = specification.split("||");
            var goodsSpecs = new Array;
            var goodsSpecHtml = "";
            for (var i = 0; i < specifications.length; i++) {
                var goodSpec = {};
                goodSpec.standardCode = $($(".standardName").get(i)).text();
                goodSpec.value = specifications[i];
                goodsSpecs.push(goodSpec);
                goodsSpecHtml = goodsSpecHtml + "<tr><td class='tdTitle'>" + $($(".standardName").get(i)).text() + "</td><td>" + specifications[i] + "</td></tr>"
            }

            goodsData.providerGoodsSpecifications = goodsSpecs;

            var pics = [];
            for (var i = 0; i < fileUploadViewModel.fileinputs.length; i++) {
                var picTmp = {};
                if (i == 0) {
                    picTmp.isPrimary = "1";
                } else {
                    picTmp.isPrimary = "0";
                }
                picTmp.path = fileUploadViewModel.fileinputs[i].filePath;
                picTmp.compressPath = fileUploadViewModel.fileinputs[i].compressFilePath;
                picTmp.type = "0";
                picTmp.orderSort = i;
                pics[i] = picTmp;
            }
            goodsData.pics = pics;
            goodsData.introduction = ProductDetailFunctionBundle.getCkeditorHtmlMsg();
            if (goodsDatas.length > 0) {
                var spliceFlag = true;
                for (var i = 0; i < goodsDatas.length; i++) {
                    if (goodsDatas[i].stardard == specification) {
                        goodsDatas.splice(i, 1, goodsData);
                        spliceFlag = false;
                        break;
                    }
                }
                if (spliceFlag) {
                    goodsDatas.push(goodsData);
                }
            } else {
                goodsDatas.push(goodsData);
            }
                var brandName = $("#brandName").val();
            goodsData.param = "<table cellpadding=\"0\" cellspacing=\"1\" width=\"100%\" border=\"0\" class=\"Ptable\">\n" +
                "        <tbody>\n" +
                "            <tr>\n" +
                "                <th class=\"tdTitle\" colspan=\"2\">主体</th>\n" +
                "            </tr>\n" +
                "            <tr>\n" +
                "                <td class=\"tdTitle\">商品名称</td>\n" +
                "                <td>" + goodsData.name + "</td>\n" +
                "            </tr>\n" +
                "            <tr>\n" +
                "                <td class=\"tdTitle\">品牌</td>\n" +
                "                <td>" + brandName + "</td>\n" +
                "            </tr>\n" +
                "            <tr>\n" +
                "                <td class=\"tdTitle\">重量</td>\n" +
                "                <td>" + goodsData.weight + "</td>\n" +
                "            </tr>\n" +
                "            <tr>\n" +
                "                <td class=\"tdTitle\">产地</td>\n" +
                "                <td>" + goodsData.productArea + "</td>\n" +
                "            </tr>\n" +
                "            <tr>\n" +
                "                <td class=\"tdTitle\">包装清单</td>\n" +
                "                <td>" + goodsData.wareQD + "</td>\n" +
                "            </tr>\n" +
                "        </tbody>\n" + goodsSpecHtml +
                "    </table>";

            ProductEditFunc.setGoodsVoid();
            if (!$(".tableStandard[value='" + specification + "']").is(":checked")) {
                $(".tableStandard[value='" + specification + "']").trigger("click");
            }

        },
        setGoods2Ducument: function (data) {
            var goodsData = data;
            $("#goodsName").val(goodsData.name);
            $("#weight").val(goodsData.weight);
            $("#productArea").val(goodsData.productArea);
            $("#upc").val(goodsData.upc);
            $("#saleUnit").val(goodsData.saleUnit);
            $("#wareQD").val(goodsData.wareQD);
            $("#stockCount").val(goodsData.stockCount);
            $("#costPrice").val(goodsData.costPrice);
            /*$("#postSalePolicy").val(goodsData.postSalePolicy);*/
            $("#productModelSku").val(goodsData.modelSku);
            $("#goodsSku").val(goodsData.sku);
            $("#marketPrice").val(goodsData.marketPrice);

            //规格组合
            var specifications = [];
            for (var goodsSpecification of goodsData.providerGoodsSpecifications) {
                specifications.push(goodsSpecification.value);
            }
            $("#specification").val(specifications.join("||"));

            var pics = goodsData.pics;
            $("#fileinput-container").html("");
            fileUploadViewModel.fileinputs = [];
            for (var i = 0; i < pics.length; i++) {
                var model = {
                    title: "请选择文件",
                    showDelBtn: i > 0,
                    idx: i,
                    fileName: pics[i].path,
                    filePath: pics[i].path,
                    uploading: false
                };
                fileUploadViewModel.fileinputs.push(model);
                addFileUploader(fileUploadViewModel, i);
            }
            setTimeout(function () {
                CKEDITOR.instances.description.setData(goodsData.introduction);
            }, 100);
        },
        setProductModel: function (data) {
            providerProductModel = data;
            $("#productCategoryId").val(providerProductModel.categoryId);
            $("#productModelSku").val(providerProductModel.modelSku);
            $("#modelId").val(providerProductModel.modelId);
            $("#modelName").val(providerProductModel.name);
            $("#brandId").val(providerProductModel.brandId);
        },
        setGoodsVoid: function () {
            $("#goodsName").val("");
            $("#weight").val("");
            $("#productArea").val("");
            $("#upc").val("");
            $("#saleUnit").val("");
            $("#wareQD").val("");
            $("#stockCount").val("");
            $("#costPrice").val("");
            $("#goodsSku").val("");
            $("#marketPrice").val("");
            $("#providerGoodsId").val("");
            $("#goodsSku").val("");
            $("#specification").val("");
            ProductDetailFunctionBundle.setCkeditorHtmlMsg("");
            $("#fileinput-container").html("");
            fileUploadViewModel.fileinputs = [];
            var model = {
                title: "请选择文件",
                showDelBtn: 0 > 0,
                idx: 0,
                fileName: "",
                filePath: "",
                uploading: false
            };
            fileUploadViewModel.fileinputs.push(model);
            addFileUploader(fileUploadViewModel, 0);

        },
        goodsDataValidate: function (showPop) {
            var goodsName = $.trim($("#goodsName").val());
            var weight = $.trim($("#weight").val());
            var productArea = $.trim($("#productArea").val());
            var saleUnit = $.trim($("#saleUnit").val());
            var wareQD = $.trim($("#wareQD").val());
            var stockCount = $.trim($("#stockCount").val());
            var costPrice = $.trim($("#costPrice").val());
            var marketPrice = $.trim($("#marketPrice").val());
            var introduction = ProductDetailFunctionBundle.getCkeditorHtmlMsg();
            if (goodsName == undefined || goodsName == "") {
                if (showPop) {
                    showMessage({message: "请填写商品名称"});
                    return false;
                }
            }
            if (weight == undefined || weight == "") {
                if (showPop) {
                    showMessage({message: "请填写商品重量"});
                    return false;
                }
            }
            if (productArea == undefined || productArea == "") {
                if (showPop) {
                    showMessage({message: "请填写商品产地"});
                    return false;
                }
            }
            if (wareQD == undefined || wareQD == "") {
                if (showPop) {
                    showMessage({message: "请填写商品清单"});
                    return false;
                }
            }
            if (stockCount == undefined || stockCount == "") {
                if (showPop) {
                    showMessage({message: "请填写商品库存"});
                    return false;
                }
            } else if (!(/^\d/).test(stockCount)) {
                if (showPop) {
                    showMessage({message: "商品库存只能输入数字"});
                    return false;
                }
            }
            if (costPrice == undefined || costPrice == "") {
                if (showPop) {
                    showMessage({message: "请填写协议价"});
                    return false;
                }
            } else if (!(/^\d+(\.\d{0,2})?$/).test(costPrice)) {
                if (showPop) {
                    showMessage({message: "协议价只能输入整数和两位小数"});
                    return false;
                }
            }
            if (marketPrice == undefined || marketPrice == "") {
                if (showPop) {
                    showMessage({message: "请填写市场价"});
                    return false;
                }
            } else if (!(/^\d+(\.\d{0,2})?$/).test(marketPrice)) {
                if (showPop) {
                    showMessage({message: "市场价只能输入整数和两位小数"});
                    return false;
                }
            }
            var picPaths = fileUploadViewModel.fileinputs;
            for (var i = 0; i < picPaths.length; i++) {
                if (picPaths[i].filePath == "") {
                    showMessage({message: "请上传图片"});
                    return false;
                }
            }
            if (introduction == undefined || introduction == "") {
                if (showPop) {
                    showMessage({message: "请录入商品详情"});
                    return false;
                }
            }
            return true;
        }
    }

    var GoodsTableFunc = {
        createGoodsTable: function (titles, tableDatas) {
            var table = "<table id='goodsTable'><thead>"

            for (var i = 0; i < titles.length; i++) {
                if (i == 0) {
                    table = table +
                        "<th>" +
                        "   <input class='tableStandard check_checkbox_All_class' type='checkbox' id='checkbox_All' onclick='check_checkbox_All()' disabled='disabled'>" +
                        "</th>";
                }
                table = table + "<th>" + titles[i].title + "</th>";
            }

            table = table + "</thead><tbody>";

            for (var i = 0; i < tableDatas.length; i++) {
                var data = tableDatas[i];
                table = table + "<tr>";
                for (var j = 0; j < data.length; j++) {
                    var columns = data[data.length - 1].split("||");
                    var columnDatas = "";
                    for (var k = 0; k < columns.length; k++) {
                        columnDatas += escapeJquery(columns[k].replace(/ /g, ""));
                    }
                    if (j == 0) {
                        table = table +
                            "<td>" +
                            "<input class='tableStandard check_checkbox_class' type='checkbox' " +
                            "id='checkbox_" + columnDatas + "' " +
                            "disabled ='disabled' " +
                            "onclick='check_checkbox(this)' " +
                            "value = " + "'" + data[data.length - 1] + "'" + " >" +
                            "</td>";
                    }
                    if (j == data.length - 1) {
                        var rFlag = false;
                        isSaveProducts.forEach(value => {
                            if (value == columnDatas) {
                                rFlag = true;
                            }
                        });
                        if (rFlag) {
                            table = table + "<td></td>";
                        } else {
                            table = table + "" +
                                "<td id='lastTd_" + columnDatas + "'>" +
                                "   <a href='javascript:void(0)' class='editGoods' onclick = 'editButton(\"" + data[j] + "\")'>" + "录入商品信息" + "</a>" +
                                "   &nbsp;&nbsp;&nbsp;&nbsp;" +
                                "   <a href='javascript:void(0)' class='editGoods' onclick = 'editButtonPush(\"" + data[j] + "\")'>" + "提交" + "</a>" +
                                "</td>";
                        }
                    } else if (j == data.length - 2) {
                        table = table + "<td id='" + columnDatas + "'>" + data[j] + "</td>";
                    } else {
                        table = table + "<td>" + data[j] + "</td>";
                    }
                }
                table = table + "</tr>";
            }
            table = table + "</tbody></table>"

            $("#goodsTableDiv").html(table);
            for (var i = 0; i < goodsDatas.length; i++) {
                $(".tableStandard[value='" + goodsDatas[i].stardard + "']").attr("checked", true);
            }
        }
    }

    function saveProduct(standardValueId) {

        var providerProductModel = ProductEditFunc.getProductModel();
        if (!providerProductModel) {
            submitFlag = true;
            return false;
        }
        if (goodsDatas.length == 0) {
            submitFlag = true;
            showMessage({message: "请先录入商品信息"});
            return false;
        }

        var rGoodsDatas = new Array;
        if (standardValueId != "") {
            standardValueId = escapeJquery(standardValueId.replace(/ /g, ""));
            goodsDatas.forEach(value => {
                if (standardValueId == value.standardValueId) {
                    rGoodsDatas.push(value);
                }
            });
        } else {
            var standardCheckBoxs = $(".tableStandard");
            var standardCheckBoxIdArray = new Array;
            for (var i = 0; i < standardCheckBoxs.length; i++) {
                if (standardCheckBoxs[i].checked) {
                    standardCheckBoxIdArray.push(standardCheckBoxs[i].id.slice(9));
                }
            }
            if (standardCheckBoxIdArray.length == 0) {
                showMessage({message: "请至少选择一条商品数据！"});
                return false;
            }
            goodsDatas.forEach(value => {
                standardCheckBoxIdArray.forEach(value1 => {
                    if (value1 == value.standardValueId) {
                        rGoodsDatas.push(value);
                    }
                });
            });
        }

        var url = "saveProduct";
        $.ajax({
            url: url,
            type: "POST",
            contentType: "application/json",
            datatype: "json",
            data: JSON.stringify({
                productModel: providerProductModel,
                providerGoodses: rGoodsDatas,
                delGoodses: delGoodsDatas
            }),
            success: function (data) {
                if (data.success) {
                    if (standardValueId == "") {
                        window.location.href = "/store-admin/product/goodsList";
                    } else {
                        var columnDatas = rGoodsDatas[0].standardValueId;
                        $("#checkbox_" + columnDatas).attr("disabled", true);
                        $("#checkbox_" + standardValueId).remove("checkchild");
                        $("#" + standardValueId).text("已提交");
                        $("#lastTd_" + standardValueId).html("");
                        isSaveProducts.push(columnDatas);
                    }
                } else {
                    submitFlag = true;
                    showMessage({message: data.resultMessage});
                }
            },
            error: function (e) {
                submitFlag = true;
            }
        })
    }

    function reChooseCategory() {
        $('.reChoiceCoverLayer').removeClass('f-hide');
        showCannle();
    }

    function sureReChoice() {
        $(this).parents('.coverLayer').addClass('f-hide');
        window.location.href = "chooseCategory";
    }

    function validateStandardValue(obj) {
        var validateInputs = $(obj).parents(".standardValueDiv").find(".standardValueInput");
        var validate = new Array;
        for (var i = 0; i < validateInputs.length; i++) {
            if (validateInputs.get(i).value == obj.value) {
                if(validateInputs.get(i)!=null && validateInputs.get(i)!=undefined && ""!=validateInputs.get(i).trim()){
                    validate.push(validateInputs.get(i).value);
                }
            }
        }
        if (validate.length > 1) {
            $(obj).val("");
            showMessage({message: "已有相同的规格"});
        } else {
            var standardName = obj.parentElement.parentElement.parentElement.getElementsByClassName("standardName")[0].textContent;
            $.ajax({
                url: "categoryStandardSave",
                type: "POST",
                data: {
                    productCategoryId: $("#productCategoryId").val(),
                    standardName: standardName,
                    standardVal: validate[0]
                },
                success: function () {
                }
            })
        }
    }

    $('.closeBtn').on('click', function () {
        $('.coverLayer').addClass('f-hide');
    })
    $("#stockCount").keyup(function () {
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
    }).bind("paste", function () {  //CTR+V事件处理
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
    }).css("ime-mode", "disabled"); //CSS设置输入法不可用

</script>

</body>
</html>
