<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
    <link rel="stylesheet" href="${p_static}/admin/css/bootstrap/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="${p_static}/lte/jstree/themes/default/style.min.css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/load/load.css"/>
    <script src="${p_static}/lte/plugins/jQuery/jquery1.11.2.min.js"></script>
    <script src="${p_static}/admin/js/bootstrap/bootstrap-table.min.js"></script>
    <link rel="stylesheet" href="${p_static}/admin/layui/css/layui.css">
    <style>
        label {
            margin-bottom: 0 !important;
            vertical-align: middle;
        }

        .form-group {
            width: 52%;
            margin-bottom: 15px !important;
        }

        .form-group label {
            width: 125px;
            text-align: left;
        }

        .form-inline .form-control {
            width: 68% !important;
        }

        #permTable td {
            text-align: center !important;
        }

        .priceInput {
            width: 60px !important;
        }


        .popBtnC span {
            display: inline-block;
            width: 80px;
            height: 30px;
            line-height: 30px;
            text-align: center;
            border-radius: 5px;
        }

        .twoBtnC span {
            width: 100px;
            height: 32px;
            line-height: 32px;
        }

        #submitEditShipping {
            color: #fff;
            background: #4e9bd6;
            border: 1px solid #4e9bd6;
            margin-right: 30px;
            cursor: pointer;
        }

        #cancelEditShipping {
            color: #333;
            border: 1px solid #333;
            cursor: pointer;
        }

    </style>
    <#include "/include/head.ftl" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
    <#include "/include/top-menu.ftl"/>
    <#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <section class="content-header">
            <h1>
                运费管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/freightRule/index">运费管理</a></li>
            </ol>
        </section>
        <#--通用规则 StoreFreightRuleDto-->
        <input type="hidden" name="nFreightRuleName" id="nFreightRuleId" value='${nFreightRuleValue!}'/>
        <#--特殊规格 map< 价格+邮费 , StoreFreightRuleDtos >-->
        <input type="hidden" name="sFreightRuleName" id="sFreightRuleId" value='${sFreightRuleValue!}'/>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well">
                        <div class="form-group" style="">
                            <label>供应商:</label>
                            <input type="text" class="form-control"
                                   id="provideName" disabled name="provideName"
                                   value="${storeName!}">
                            <input type="text" class="form-control"
                                   id="storeId" style="display: none;" name="storeId"
                                   value="${storeId!}">
                        </div>
                        <div class="form-group" style="" id="editDiv">
                            <label>运费规则:</label>
                            <input type="button" id="editButtonId" value="编辑" onclick="showEditTable()">
                        </div>
                        <input type="hidden" name="normalrRuleId" id="normalrRuleId"
                               value="<#if normalrRule??>${normalrRule.id!}<#else>null</#if>"/>
                        <div class="form-group normalrRule" id="normalrRuleShowId">
                            <#if normalrRule??>
                                <#if normalrRule.freePrice??>
                                    <label>店铺通用包邮价:</label>
                                    &nbsp;&nbsp;满${normalrRule.freePrice!}元包邮，不足包邮价格邮费为${normalrRule.freightPrice!}元
                                <#else>
                                </#if>
                            </#if>
                        </div>
                        <div id="editNormalrRuleShowId" style="display: none">
                            <label>店铺通用包邮价:</label>
                            &nbsp;&nbsp;满&nbsp;&nbsp;&nbsp;
                            <input style="width: 50px" id="editNfreePrice">
                            &nbsp;&nbsp;&nbsp;元包邮，不足包邮价格邮费为&nbsp;&nbsp;&nbsp;
                            <input style="width: 50px" id="editNfreightPrice">
                            &nbsp;&nbsp;&nbsp;元
                        </div>
                        <p>&nbsp;</p>
                        <input type="hidden" name="specialRuleFlag" id="specialRuleFlag"
                               value="<#if specialRuleFlag??>${specialRuleFlag!}<#else>null</#if>"/>
                        <div class="form-group specialRules" id="specialRules">
                            <label
                                    <#if sFreightRuleValue??>
                                    <#else>
                                        style="display: none"
                                    </#if>
                                    id="sFreightRuleLabelId">特殊规则:</label>
                            <div id="specialRulesTableId" style="display: none">
                                <div class="specialRuleClass"
                                     style="width: 700px;height: 70px;padding-bottom: 10px;"
                                     id="specialRuleId0">
                                    <div class="col-xs-9">
                                        满 &nbsp;&nbsp;&nbsp;
                                        <input style="width: 50px" id="pinkageId0">
                                        &nbsp;&nbsp;&nbsp; 元包邮，不足包邮价格邮费为
                                        &nbsp;&nbsp;&nbsp;
                                        <input style="width: 50px" id="unPinkageId0">
                                        &nbsp;&nbsp;&nbsp; 元 &nbsp;&nbsp;&nbsp;
                                        <button type="button"
                                                class="layui-btn layui-btn-primary"
                                                onclick="choiceAreas(this)"
                                                style="border-radius: 5px;background-color: #d8d8d8;">
                                            选择地区
                                        </button>
                                        &nbsp;&nbsp;&nbsp;
                                    </div>
                                    <div class="col-xs-3" style="text-align: center">
                                        <i class="col-xs-6 layui-icon layui-icon-add-circle"
                                           style="cursor:pointer;font-size: 30px;color: cornflowerblue;"
                                           onclick="addSpecialRule(this)"></i>
                                        <i class="col-xs-6 layui-icon layui-icon-close-fill"
                                           style="cursor:pointer;font-size: 32px;color: cornflowerblue;"
                                           onclick="delSpecialRule(this)"></i>
                                    </div>
                                    <div class="col-xs-12" id="specialRuleId0Address">
                                    </div>
                                </div>
                            </div>
                            <#if specialRules??>
                                <#list specialRules as specialRule>
                                    <div class="showSpecialRulesTableId">
                                        <div style="width: 700px;height: 70px;padding-bottom: 10px;">
                                            <div class="col-xs-9">
                                                满 &nbsp;&nbsp;&nbsp;
                                            ${specialRule.freePrice!}
                                                &nbsp;&nbsp;&nbsp; 元包邮，不足包邮价格邮费为
                                                &nbsp;&nbsp;&nbsp;
                                            ${specialRule.freightPrice!}
                                                &nbsp;&nbsp;&nbsp; 元 &nbsp;&nbsp;&nbsp;
                                                &nbsp;&nbsp;&nbsp;
                                            </div>
                                            <div class="col-xs-12">
                                                适用地区: <span>${specialRule.levelOneAddressName!}</span>
                                            </div>
                                        </div>
                                    </div>
                                </#list>
                            <#else>
                            </#if>

                            <#if freeFreightGoods??>
                                <div class="form-group freeFreightGoods" id="freeFreightGoods" style="margin-top: 20px;">
                                <label>特殊商品:</label>
                                    <#list freeFreightGoods as ffg>
                                        <div class="freeFreightGoods">
                                            <p>${ffg.sku!} &nbsp;&nbsp;${ffg.name!}</p>
                                        </div>
                                    </#list>
                                <div class="form-group specialRules" id="specialRules">
                            <#else>
                            </#if>

                        </div>
                        <div class="popBtnC" style="display: none;">
                            <span id="submitEditShipping" onclick="saveSpecialRule()">确定</span>
                            <span id="cancelEditShipping">取消</span>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </div>
    <#include "/include/foot.ftl"/>
</div>
<#include "/include/resource.ftl"/>

<script src="${p_static}/admin/js/load/load-min.js"></script>
<script type="text/javascript" src="${p_static}/admin/layui/layui.js"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/artTemplate/template.js')}"></script>
<script>
    var v = new Date().getFullYear() + "" + (new Date().getMonth() + 1) + "" + new Date().getDate() + "" + new Date().getHours();
    document.write("<script type='text/javascript' src='${p_static}/admin/js/freightrule/freightRule.js?v=" + v + "'><\/script>");
</script>


<script id="newSpecialRuleId_" type="text/html">
    {{if data}}
    <div class="specialRuleClass"
         style="width: 700px;height: 70px;padding-bottom: 10px;"
         id="specialRuleId{{data.rindex}}">
        <div class="col-xs-9">
            满 &nbsp;&nbsp;&nbsp;
            <input style="width: 50px" id="pinkageId{{data.rindex}}" value="{{data.freePrice}}">
            &nbsp;&nbsp;&nbsp; 元包邮，不足包邮价格邮费为
            &nbsp;&nbsp;&nbsp;
            <input style="width: 50px" id="unPinkageId{{data.rindex}}" value="{{data.freightPrice}}">
            &nbsp;&nbsp;&nbsp; 元 &nbsp;&nbsp;&nbsp;
            <button type="button"
                    class="layui-btn layui-btn-primary"
                    onclick="choiceAreas(this)"
                    style="border-radius: 5px;background-color: #d8d8d8;">
                选择地区
            </button>
            &nbsp;&nbsp;&nbsp;
        </div>
        <div class="col-xs-3" style="text-align: center">
            <i class="col-xs-6 layui-icon layui-icon-add-circle"
               style="cursor:pointer;font-size: 30px;color: cornflowerblue;"
               onclick="addSpecialRule(this)"></i>
            <i class="col-xs-6 layui-icon layui-icon-close-fill"
               style="cursor:pointer;font-size: 32px;color: cornflowerblue;"
               onclick="delSpecialRule(this)"></i>
        </div>
        <div class="col-xs-12" id="specialRuleId{{data.rindex}}Address">
        </div>
    </div>
    {{/if}}
</script>
<script id="choiceAreas_" type="text/html">
    {{if data}}
    {{each data as province i}}
    <div class="col-xs-3" style="padding-top: 5px;">
        <input
                {{province.isCheck}}
                {{province.isChecked}}
                class="provinceCheckboxClass"
                id="{{province.id}}"
                onchange=""
                type="checkbox"
                value="{{province.name}}">
        <span style="width: 120px;">{{province.name}}</span>
    </div>
    {{/each}}
    {{/if}}
</script>
<script id="specialRuleAddress_" type="text/html">
    {{if data}}
    适用地区: <span>{{data}}</span>
    {{/if}}
</script>

</body>
</html>
