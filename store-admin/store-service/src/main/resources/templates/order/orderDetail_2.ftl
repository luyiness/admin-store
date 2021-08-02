<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
<#include "/include/head.ftl">
    <link rel="stylesheet" href="${p_static}/admin/css/myOrder.css" type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/orderDetail.css" type="text/css"/>
    <#--<link href="${p_static}/admin/css/global.css" rel="stylesheet" type="text/css"/>
    <link href="${p_static}/admin/css/iconfont.css" rel="stylesheet" type="text/css"/>
    <link href="${p_static}/admin/css/orderPublicity.css" rel="stylesheet" type="text/css"/>-->
    <title>商城供应商管理后台</title>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
<#--<#include "/include/top-menu.ftl"/>-->
    <!-- Left side column. contains the logo and sidebar -->
<#include "/include/left.ftl"/>
    <div class="content-wrapper" style="background: #fff">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                订单管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/order/list">订单详情</a></li>
            </ol>
        </section>
<#--<header>
    <div class="top">
        <div class="center">

        </div>
    </div>
    <div class="center headerCon ">

    </div>
    <nav>

    </nav>
</header>-->
<!--<div class="gray"></div>-->
<#--<div class="pageWidth">
    <div class="conNav">-->
        <#--<ul>-->
            <#--<a style="cursor:pointer">首页</a> <span class="divider">&gt;</span>-->
            <#--<a style="cursor:pointer">订单公示</a> <span class="divider">&gt;</span>-->
            <#--<a style="cursor:pointer">公示详情</a>-->
        <#--</ul>-->
   <#--         <ul class="breadcrumb navItem">
                <li>
                    <a href="${ctx}/">首页</a> <span class="divider">&gt;</span>
                </li>
                <li>
                    <a href="${ctx}/order/list">订单管理</a> <span class="divider">&gt;</span>
                </li>
                <li><a>订单详情</a></li>
            </ul>
    </div>
    <#include "/include/imgCon.ftl">
    <p class="caption detailsTitle scrollTopH">公示详情</p>-->
        <section class="content">
            <div class="conNavR fr frintOrderDetail">
                <p class="myChoicel">订单详情</p>
                <div>
                    <div class="line"></div>
                </div>
            <div class="contentDetail">
                <table class="table detailTa">
                    <tr>
                        <td>订单号</td>
                        <td>测试订单号<#--${orderMain.orderNo!}--></td>
                        <td>下单时间</td>
                        <td>2018-11-11 11：11<#--${orderMain.createTime?string("yyyy-MM-dd HH:mm:ss")!}--></td>
                    </tr>
                    <tr>
                        <td>下单人</td>
                        <td>xjw</td>
                        <td>组织时间</td>
                        <td>2018-11-11 11：11</td>
                    </tr>
                    <tr>
                        <td>订单状态</td>
                       <#-- <td>
                        <#if orderMain.status??>
                            <#if ((orderMain.status) == "1")>
                                待付款
                            <#elseif ((orderMain.status) == "2")>
                                未发货
                            <#elseif ((orderMain.status) == "3")>
                                待收货
                            <#elseif ((orderMain.status) == "4")>
                                待评价
                            <#elseif ((orderMain.status) == "5")>
                                已完成
                            <#elseif ((orderMain.status) == "6")>
                                已取消
                            </#if>
                        </#if>-->
                        </td>
                        <td>商品总额</td>
                        <td>￥100</td>
                    </tr>
                    <tr>
                        <td>运费</td>
                        <td>￥100</td>
                        <td>应付总额</td>
                        <td>￥200</td>
                    </tr>
                </table>
            </div>
            <div class="contentDetail">
                <div class="title">收货人信息</div>
                <table class="table detailTa">
                    <tr>
                        <td>收货人</td>
                        <td>xjw</td>
                        <td>收货人电话</td>
                        <td>18888888888</td>
                    </tr>
                    <tr>
                        <td>收货人地址</td>
                        <td colspan="3">测试地址<#--${memberAddress.provinceName!}${memberAddress.cityName!}${memberAddress.countryName!}${memberAddress.townName!}${memberAddress.addressDetail!}--></td>

                    </tr>

                </table>
            </div>
           <#-- <div class="contentDetail">
                <div class="title">发票信息</div>
            <#if memberInVoice??>
                <table class="table detailTa">
                    <tr>
                        <td>发票类型</td>
                        <td>${memberInVoice.type!}</td>
                        <td>已开立发票</td>
                        <td>&lt;#&ndash;<#if memberInVoice.isSetUpVoice!>是</#if>&ndash;&gt;${memberInVoice.isSetup?string("是","否")!}</td>
                    </tr>
                    <tr>
                        <td>纳税人识别号</td>
                        <td>${memberInVoice.identificationCode!}</td>
                        <td>名称</td>
                        <td>${memberInVoice.name!}</td>
                    </tr>
                    <tr>
                        <td>开户行及账号</td>
                        <td colspan="3">${memberInVoice.bankAccount!}</td>

                    </tr>
                    <tr>
                        <td>地址、电话</td>
                        <td colspan="3">${memberInVoice.voiceAdPhone!}</td>

                    </tr>
                    <tr>
                        <td>发票收件人</td>
                        <td>${memberInVoice.recivePName!}</td>
                        <td>发票收件人电话</td>
                        <td>${memberInVoice.phoneNumber!}</td>
                    </tr>
                    <tr>
                        <td>发票收件地址</td>
                        <td colspan="3">${memberInVoice.address!}</td>
                    </tr>
                    <tr>
                        <td>发票明细</td>
                        <td colspan="3">${memberInVoice.invoiceDetail!}</td>
                    </tr>
                </table>
            </#if>
            </div>-->
            <div class="contentDetail">
                <div class="title" id="shipping">商品信息与物流进度</div>
            </div>
        <#if orderNos??>
            <#if (orderNos?size>0)>
                <#list orderNos as orderNo>
                    <#if orderNo_index==0>
                    <div class="contentDetail " style="margin-top: 0px;padding-top: 0px"><#else >
                    <div class="contentDetail ">
                    </#if>


                    <#if isSub>
                        <table class="detailsho" style="width: 100%">

                            <tr class="tcontent">
                                <td width="3%"></td>
                                <td width="30%" align="left" class="fontblue">
                                    子订单号：${orderNo} ${warehouses[orderNo_index]} </td>
                            <#--<td width="58%" align="center"></td>-->
                                <td width="40%" align="right"><span
                                        class="litilesum">小计：${litleCount[orderNo_index]}元</span></td>
                            </tr>
                        </table>
                    </#if>

                    <table class="table">
                        <#list items[orderNo_index] as item>
                            <tr>
                                <td height="100px" align="center"
                                    width="10%">
                                    <a href="javascript:void(0)">
                                    <div class="dimg" onclick="javascript:window.location.href='/good/goodsdetails?goodsId=${(item.goodsId)!}'">
                                        <img class="shopimg "
                                             src="${pictrues[orderNo_index][item_index].picturePath!}"></div>
                                    </a>
                                </td>
                                <td align="left" width="23%" onclick="javascript:window.location.href='/good/goodsdetails?goodsId=${(item.goodsId)!}'">
                                    <a href="javascript:void(0)">${item.productName!}</a></td>

                                <td align="center" width="25%">单价：<span class="">${item.salePrice!}元</span></td>
                                <td align="center" width="13%">数量：×${item.count}</td>
                                <td width="7%"></td>
                                <td align="right" width="20%">
                                    <a href="javascript:void(0)"><span
                                        class="fontora litilesum"
                                        onclick="javascript:window.location.href='/members/salesApply?orderMainId=${(orderMain.id)!}&jdOrderId=${orderNo!}&addressId=${(memberAddress.id)!}&goodsId=${(item.goodsId)!}&skuName=${(item.productName)!}&skuPrice=${(item.salePrice)!}&skuNum=1&count=${(item.count)!}&url=${(pictrues[orderNo_index][item_index].picturePath)!}'">
                                        <#if isCanReturn[orderNo_index][item_index]>
                                            申请售后
                                        </#if>
                                    </span>
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    </table>
                    <div class="contentDetail shipping">
                        <#if orderTrackResp??>
                            <#if orderTrackResp[orderNo]??>
                                <div>
                                    <#list orderTrackResp?keys as key>
                                        <span id="${key}" class="package">包裹[${key}]</span>
                                    <#--<#list orderTrackResp[key].goodsInfos as goods>
                                        ${goods.goodsName!}
                                    </#list>-->
                                    </#list>
                                </div>
                            <#else>
                                <#if orderTrackResp??>
                                    <div>
                                        <#list orderTrackResp as k, package>
                                            <span id="${package.trdSubOrderNo}" class="package">包裹[${package.trdSubOrderNo}]</span>
                                        <#--<#list orderTrackResp[key].goodsInfos as goods>
                                            ${goods.goodsName!}
                                        </#list>-->
                                        </#list>
                                    </div>
                                </#if>
                            </#if>
                        <div class="shippingInfo">
                            <#if orderTrackResp[orderNo]??>

                            <div>
                                <#list orderTrackResp?keys as key>
                                    <div class="packageInfo" id="div${key}">
                                        <div>
                                            <#list orderTrackResp[key].goodsInfos as goods>
                                                <span class="goodsPicSpan"><img src="${goods.goodsPictrue}" title="${goods.goodsName!}"></span>
                                            </#list>
                                        </div>
                                        <#if orderTrackResp[key].trackInfoList?size gt 0>
                                            <table class="progress-approve">
                                                <#list orderTrackResp[key].trackInfoList as orderTrack>
                                                    <tr>
                                                        <td style="vertical-align: middle;" width="25px">

                                                            <#if orderTrack_index==0>
                                                            <#--<div class="boxe boxLast">-->
                                                            <#--<div class="circleLasted"></div>-->
                                                            <#--</div>-->
                                                                <div class="boxe boxLast circleBlue1" style="margin-left: -4px">
                                                                    <img src="${ctx}/admin/images/circleBlue1.png"/>
                                                                    <div class="circleLasted"></div>
                                                                </div>
                                                            <#else >
                                                            <#--<div class="circle"></div> -->
                                                            <#--<div class="boxe">-->
                                                            <#--<div class="radius"></div>-->
                                                            <#--</div>-->
                                                                <div class="box1" style="height: 26px; margin-top: -1px;">
                                                                    <img src="${ctx}/admin/images/circleGrey23.png"/>
                                                                    <div class="radius beforeradius"></div>
                                                                </div>
                                                            </#if>
                                                            <#if orderTrack_has_next>
                                                                <div class="suli"></div>
                                                            </#if>
                                                        </td>
                                                        <td style="padding-top: 10px;<#if orderTrack_index==0>color: blue</#if>">
                                                            <#if orderTrack.msgTime??> ${(orderTrack.msgTime)?string('yyyy-MM-dd HH:mm:ss')}</#if>
                                                                        ${(orderTrack.content)!}
                                                        </td>
                                                    </tr>
                                                </#list>
                                            </table>
                                        <#else>
                                            <tr>
                                                <div style="text-align: center;background: #fff"> 该包裹没有物流信息</div>
                                            </tr>
                                        </#if>
                                    </div>
                                </#list>
                            <#else>
                                <#list orderTrackResp as k, package>
                                    <div class="packageInfo" id="div${package.trdSubOrderNo}">
                                        <div>
                                            <#list package.goodsInfos as goods>
                                                <span class="goodsPicSpan"><img src="${goods.goodsPictrue}" title="${goods.goodsName!}"></span>
                                            </#list>
                                        </div>
                                        <#if package.trackInfoList?size gt 0 >
                                            <table class="progress-approve">
                                                <#list package.trackInfoList as orderTrack>
                                                    <tr>
                                                        <td style="vertical-align: middle;" width="25px">
                                                            <#if orderTrack_index==0>
                                                                <div class="boxe boxLast circleBlue1" style="margin-left: -4px">
                                                                    <img src="${ctx}/admin/images/circleBlue1.png"/>
                                                                    <div class="circleLasted"></div>
                                                                </div>
                                                            <#else >
                                                                <div class="box1" style="height: 26px; margin-top: -1px;">
                                                                    <img src="${ctx}/admin/images/circleGrey23.png)}"/>
                                                                    <div class="radius beforeradius"></div>
                                                                </div>
                                                            </#if>
                                                            <#if orderTrack_has_next>
                                                                <div class="suli"></div>
                                                            </#if>
                                                        </td>
                                                        <td style="padding-top: 10px;<#if orderTrack_index==0>color: blue</#if>">
                                                            <#if orderTrack.msgTime??> ${(orderTrack.msgTime)?string('yyyy-MM-dd HH:mm:ss')}</#if>
                                                                    ${(orderTrack.content)!}
                                                        </td>
                                                    </tr>
                                                </#list>
                                            </table>
                                        <#else>
                                            <div style="text-align: center;background: #fff"> 该包裹没有物流信息</div>
                                        </#if>
                                    </div>
                                </#list>
                            </#if>
                        </div>
                        <#else >
                            <div style="text-align: center;background: #fff"> 该订单没有物流信息</div>
                        </#if>
                    </div>
                </div>
                </#list>
            </#if>
        </#if>
            </div>

            <div class="contentDetail" style="text-align: center;  margin-bottom: 20px;">
                <button class="backButton" style="  margin-top: 40px;margin-left: 100px;" type="button"
                        onclick="window.location.href='${ctx}/order/list'">返 回
                </button>
            </div>
            </div>
            </section>
        </div>
<#include "/include/foot.ftl"/>
    </div>
</body>


<script>
    window.jQuery || document.write('<script src="${p_static}/admin/js/jquery-2.1.1.min.js"><\/script>')
</script>
<script type="text/javascript">
    myALL(2);
</script>

<#include "/include/resource.ftl">
<script>
    $(function () {
        $(".packageInfo").hide();

        $(".package").eq(0).trigger("click");


    })

    $(".package").click(function(){
        $(this).siblings().removeClass("packageFont");
        $(this).addClass("packageFont");
        $('#div'+this.id).siblings().hide();
        $('#div'+this.id).show();

    })
</script>
</html>