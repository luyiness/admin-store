<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <#include "/include/head.ftl">
    <link rel="stylesheet" href="${p_static}/admin/css/myOrder.css" type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/orderDetail.css" type="text/css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/load/load.css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/bootstrap/bootstrap-table.min.css"/>
    <style>
        a:hover {
            color: #1100ff;
        !important;
            text-decoration: underline;
        }

        body {
            font-size: 12px;
        }

        ul li {
            list-style: none;
        }

        .track-rcol {
            width: 900px;
            border: 1px solid #eee;
        }

        .track-list {
            margin: 20px;
            padding-left: 5px;
            position: relative;
            margin-top: 25px;
        }

        /**















        ${p_static}                /admin/images/order-icons.png*/
        .track-list li {
            margin-top: 10px;
            position: relative;
            padding: 9px 0 0 25px;
            line-height: 18px;
            border-left: 1px solid #d9d9d9;
            color: #999;
        }

        .track-list li.first {
            color: #04a0d7;
            padding-top: 0;
            border-left-color: #fff;
        }

        .track-list li .node-icon {
            position: absolute;
            left: -6px;
            top: 50%;
            width: 11px;
            height: 11px; /*background: url(http://demo.daimabiji.com/3531/img/order-icons.png)*/
            -21 px -72px no-repeat;
        }

        .track-list li.first .node-icon {
            background-position: 0 -72px;
        }

        .track-list li .time {
            margin-right: 20px;
            position: relative;
            top: 4px;
            display: inline-block;
            vertical-align: middle;
        }

        .track-list li .txt {
            max-width: 600px;
            position: relative;
            top: 4px;
            display: inline-block;
            vertical-align: middle;
        }

        .track-list li.first .time {
            margin-right: 20px;
        }

        .track-list li.first .txt {
            max-width: 600px;
        }
    </style>
    <title>商城供应商管理后台</title>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
    <#include "/include/top-menu.ftl"/>
    <#include "/include/left.ftl"/>
    <div class="content-wrapper" style="background: #fff">
        <section class="content-header">
            <h1>
                订单详情
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="#">订单详情</a></li>
            </ol>
        </section>
        <section class="content">
            <div class="conNavR fr frintOrderDetail">
                <p class="myChoicel">订单详情</p>
                <div>
                    <div class="line"></div>
                </div>
                <span id="orderId" style="display: none"></span>
                <div class="contentDetail">
                    <div class="title">订单信息</div>
                    <table class="table detailTa">
                        <tr>
                            <td>供应商</td>
                            <td id="providerName"></td>
                            <td>订单号</td>
                            <td id="orderNo"></td>
                        </tr>
                        <tr>
                            <td>商品金额</td>
                            <td id="sumNofreightPrice"></td>
                            <td>运费</td>
                            <td id="freight"></td>
                        </tr>
                        <tr><td>下单时间</td>
                            <td id="orderDate" colspan="3"></td>
                        </tr>
                    </table>
                </div>
                <div class="contentDetail">
                    <div class="title">收货人信息</div>
                    <table class="table detailTa">
                        <tr>
                            <td>收货人</td>
                            <td id="getOrderMan"></td>
                            <td>收货人电话</td>
                            <td id="tel"></td>
                        </tr>
                        <tr>
                            <td>收货人地址</td>
                            <td colspan="3" id="address">
                        </tr>
                    </table>
                </div>
                <div class="contentDetail">
                    <div class="title" id="shipping">商品信息</div>
                </div>
                <div class="contentDetail" style="margin-top: 0px;padding-top: 0px" id="goodsListTable">
                    <script id="orderGoodsListTemplate" type="text/html">
                        <div class="contentDetail">
                            {{each orderDetailQueryVo.subOrderItemWithSubOrderNo as value2 i}}
                            <table class="detailsho" style="width: 100%;">
                                <tr class="tcontent">
                                    <!-- 这里的订单包裹信息(个数)-->
                                    {{if value2.subOrderStatusAfterSendOrder > 1}}
                                    <td width="10%">包裹 : {{i + 1}}</td>
                                    {{/if}}
                                    <#-- 子订单号：-->
                                    <td width="30%">子订单号:<span id="subOrderNo">{{value2.subOrderNo}}</span></td>
                                    <td width="30%" align="left" class="fontblue">总计 :
                                        {{value2.subOrderSumPrice}} 元
                                    </td>
                                    <td width="40%" align="right">
                                        <span class="litilesum">
                                        </span>
                                    </td>
                                </tr>
                            </table>
                            <table class="table">
                                {{each value2.subOrderItemQueryVos as value i}}
                                <tr>
                                    <td height="100px" align="center"
                                        width="10%">
                                        <a>
                                            <div class="dimg">
                                                <img class="shopimg"
                                                     src="{{value.picturePath}}">
                                            </div>
                                        </a>
                                    </td>
                                    <td align="left" width="23%">
                                        <a>{{value.name}}(商品编号:{{value.skuId}})</a>
                                    </td>
                                    <td align="center" width="25%">单价：<span class="">{{value.price}}元</span></td>
                                    <td align="center" width="13%">数量：×{{value.count}}</td>
                                    <td width="7%"></td>
                                    <td align="right" width="20%">
                                        <a href="javascript:void(0)">
                                            <span class="fontora litilesum">
                                                金额: {{value.orderItemTotalPrice}}元
                                            </span>
                                        </a>
                                    </td>
                                </tr>
                                {{/each}}
                            </table>
                            {{if orderDetailQueryVo.singleSubOrderStatus=="1"
                            || orderDetailQueryVo.singleSubOrderStatus=="2"
                            || orderDetailQueryVo.singleSubOrderStatus=="4"}}
                            <table id="permTable" class="table table-bordered table-striped"
                                   style="margin-top: -24px;display:none">
                                <thead>
                                <tr class="tcontent">
                                    <th colspan="8">物流进度</th>
                                </tr>
                                <tr class="tcontent">
                                    <th style="text-align:center;width: 45px;">序号</th>
                                    <th style="text-align:center;width: 10%;">物流方式</th>
                                    <th style="text-align:center;width: 10%;">物流公司</th>
                                    <th style="text-align:center;width: 10%;">物流编号</th>
                                    <th style="text-align:center;width: 10%;">物流状态</th>
                                    <th style="text-align:center;">备注</th>
                                </tr>
                                </thead>
                                <tbody>
                                {{each value2.subOrderShippingListVos as value i}}
                                {{if value.shippingCompanyName==undefined}}
                                <tr>
                                    <td style="text-align: center;">{{i + 1}}</td>
                                    <td style="text-align: center;" colspan="5">该包裹没有物流信息</td>
                                </tr>
                                {{else}}
                                <tr>
                                    <td style="text-align: center;">{{i + 1}}</td>
                                    <td style="text-align: center;">{{value.shippingType}}</td>
                                    <td style="text-align: center;">
                                        {{value.shippingCompanyName}}
                                    </td>
                                    <td style="text-align: center;">
                                        <a>{{value.logisticNo}}</a>
                                    </td>
                                    <!--物流状态判断-->
                                    <td style="text-align: center;">
                                        {{if value.shippingStatus==1}}
                                        已发货
                                        {{else if value.shippingStatus==2}}
                                        已签收
                                        {{else if value.shippingStatus==4}}
                                        已拒收
                                        {{else if value.shippingStatus==7}}
                                        待发货
                                        {{/if}}
                                    </td>
                                    <td style="text-align: center;">{{value.shippingRemark}}</td>
                                </tr>
                                {{/if}}
                                {{/each}}
                                </tbody>
                            </table>
                            {{/if}}
                            {{/each}}
                            <div class="contentDetail shipping">
                                <div class="shippingInfo">
                                    <div>
                                        <div class="packageInfos" id="div777">

                                            <table class="progress-approve">
                                                <tr>
                                                    <td style="vertical-align: middle;" width="25px">
                                                        <div class="suli"></div>
                                                    </td>
                                                    <td style="padding-top: 10px;">
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="packageInfos" id="div000">
                                            <table class="progress-approve">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {{if orderDetailQueryVo.singleSubOrderStatus == "1"
                        || orderDetailQueryVo.singleSubOrderStatus == "2"
                        || orderDetailQueryVo.singleSubOrderStatus == "4"}}
                        <div class="contentDetail shipping">
                            <div class="title" id="shipping" style="margin-left: -35px;">物流进度</div>
                        </div>
                        <table id="permTable" class="table table-bordered table-striped">
                            <thead>
                            <tr>
                                <th style="text-align:center;width: 45px;">序号</th>
                                <th style="text-align:center;width: 10%;">物流方式</th>
                                <th style="text-align:center;width: 10%;">物流公司</th>
                                <th style="text-align:center;width: 10%;">物流编号</th>
                                <th style="text-align:center;width: 10%;">物流状态</th>
                                <th style="text-align:center;">备注</th>
                            </tr>
                            </thead>
                            <tbody>
                            {{each orderDetailQueryVo.subOrderItemWithSubOrderNo[0].subOrderShippingListVos as value i}}
                            {{if value.length <= 0}}
                            {{if orderDetailQueryVo.subOrderItemWithSubOrderNo.length == 1}}
                            <tr>
                                <td style="text-align: center;" colspan="6">该订单没有物流信息</td>
                            </tr>
                            {{else}}
                            <tr>
                                <td style="text-align: center;">{{i + 1}}</td>
                                <td style="text-align: center;" colspan="6">该包裹没有物流信息</td>
                            </tr>
                            {{/if}}
                            {{else}}
                            <tr>
                                <td style="text-align: center;">{{i + 1}}</td>
                                <td style="text-align: center;">{{value.shippingType}}</td>
                                <td style="text-align: center;">
                                    {{value.shippingCompanyName}}
                                </td>
                                <td style="text-align: center;">
                                    <a style="color: black;" onclick="logisticLineShow(this)">{{value.logisticNo}}</a>
                                </td>
                                <!--物流状态判断-->
                                <td style="text-align: center;">
                                    {{if value.shippingStatus == 1}}
                                    已发货
                                    {{else if value.shippingStatus == 2}}
                                    已签收
                                    {{else if value.shippingStatus == 4}}
                                    已拒收
                                    {{else if value.shippingStatus == 7}}
                                    待发货
                                    {{/if}}
                                </td>
                                <td style="text-align: center;">{{value.shippingRemark}}</td>
                            </tr>
                            {{/if}}
                            {{/each}}
                            </tbody>
                        </table>
                        {{/if}}
                        <div class="contentDetail" style="text-align: center;  margin-bottom: 20px;">
                            <button class="backButton"
                                    style="margin-top: 40px;margin-left: 100px;background: #aba6a1 !important;;"
                                    type="button"
                                    onclick="window.location.href='${ctx}/order/ordersList'">返 回
                            </button>
                            <!-- 这里的确认订单是 针对于已付款的订单的商品-->
                            {{if orderDetailQueryVo.singleSubOrderStatus == "6" && orderDetailQueryVo.afterSaleType != "2"}}
                            <button class="backButton"
                                    style="margin-top: 40px;margin-left: 100px;"
                                    type="button" id="sureOrder"
                                    onclick="sureOrder()">确认订单
                            </button>
                            {{else}}
                            {{/if}}
                        </div>
                        </div>
                    </script>
        </section>
    </div>
    <#--弹框-->
    <div class="modal fade" id="shippingInfosModal" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">物流跟踪</h4>
                </div>
                <div class="modal-body" id="updateProductStockDiv">
                    <div class="track-rcol">
                        <div style="margin-left: 100px;" id="shippingNo">物流单号:</div>
                        <div style="margin-left: 100px;MARGIN-TOP: 20PX;" id="company">物流公司:</div>
                    </div>

                    <div class="track-rcol" style="margin-top: 20px;">
                        <div style="margin-left: 100px;MARGIN-TOP: 20PX;" id="shippingNo">物流进度</div>
                        <div class="track-list">
                            <ul id="shippingLinesDiv">
                            </ul>
                        </div>
                    </div>
                </div>
                <script id="shippingLinesTemplate" type="text/html">
                    {{each data as value i}}
                    {{if i==0}}
                    <li class="first">
                        <span class="time">{{value.msgTime}}</span>
                        <i class="node-icon"></i>
                        <span class="txt">{{value.content}}</span>
                    </li>
                    {{else}}
                    <li>
                        <span class="time">{{value.msgTime}}</span>
                        <i class="node-icon"></i>
                        <span class="txt">{{value.content}}</span>
                    </li>
                    {{/if}}
                    {{/each}}
                </script>
                <div class="modal-footer">
                    <button style="margin-left: 500px;float: left;" type="button" class="btn btn-info"
                            id="updateProductStockCountBtn" data-dismiss="modal">确定
                    </button>
                </div>
            </div>
        </div>
    </div>
    <#include "/include/foot.ftl"/>
</div>
</body>
<script src="${p_static}/admin/js/template/template.js"></script>
<#include "/include/resource.ftl">
<script src="${p_static}/admin/js/bootstrap/bootstrap-table.min.js"></script>
<script src="${p_static}/admin/js/load/load-min.js"></script>
<script>
    /***确认订单**/
    function sureOrder() {
        window.wxc.xcConfirm("温馨提示:是否确认订单", "confirm", {
            onOk: function () {
                var orderNo = $("#orderId").text();//orderNo待添加
                var datas = {"orderNo": orderNo};
                $.ajax({
                    url: "${ctx}/order/sureOrdersByOrderId",
                    type: "POST",
                    data: datas
                }).done(function (data) {
                    if (data.success) {
                        window.wxc.xcConfirm("处理成功。", "success");
                        window.location.href = '${ctx}/order/ordersList';
                    } else {
                        window.wxc.xcConfirm("异常，请联系管理员。原因" + data.result, "error");
                    }
                }).fail(function () {
                    window.wxc.xcConfirm("异常，请联系管理员。", "error");
                });
            }
        })
    }

    function logisticLineShow(that) {
        var contents = $(that).text();
        var company = $(that).parent().parent().find("td").eq(2).text();
        var shippingNo = $(that).parent().parent().find("td").eq(3).text().trim();
        $("#company").text("物流公司:" + company);
        $("#shippingNo").text("物流单号:" + shippingNo);

        var subOrderNo = $("#subOrderNo").text();

        $.ajax({
            url: "${ctx}/mallShipping/shippingLine",
            type: "POST",
            data: {subOrderNo: subOrderNo, shippingNo: shippingNo}
        }).done(function (data) {
            if (data.success) {
                $("#shippingInfosModal").modal('show');
                var shippingLinesTemplate = template("shippingLinesTemplate", {data: data.result.trackInfoList});
                $("#shippingLinesDiv").html(shippingLinesTemplate);
            } else {
                window.wxc.xcConfirm("暂无物流信息。", "error");
            }
        }).fail(function () {
            $("#shippingInfosModal").modal('hide');
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
        });
    }

    /**获取dizhi栏参数**/
    function getQueryString(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    }

    var load = new Loading();
    //显示立即加载中。。。
    var showLoading = function () {
        load.init();
        load.start();
    };
    //取消立即加载中。。。
    var hideLoading = function () {
        load.stop();
    };
    $(function () {
        //获取订单号
        var orderNo = getQueryString("orderNo");
        /**显示订单详细数据信息**/
        $.ajax({
            url: "${ctx}/order/orderDetails",
            type: "POST",
            data: {
                orderNo: orderNo
            }, beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            //设置订单基本信息
            data = $.parseJSON(data);
            if (data.success) {
                if (data.result.orderId == undefined) {
                    window.wxc.xcConfirm("无此订单，请联系管理员。", "error");
                } else {
                    $("#orderId").text(data.result.orderId);
                    $("#providerName").text(data.result.storeName);
                    $("#orderNo").text(data.result.orderNo);
                    $("#sumNofreightPrice").text(data.result.sumCostPrice);
                    // $("#freight").text(data.result.totalPrice-data.result.sumCostPrice);
                    $("#freight").text(data.result.feight);
                    $("#orderDate").text(data.result.createdTime);
                    $("#getOrderMan").text(data.result.memberName);
                    $("#address").text(data.result.addressName);
                    $("#tel").text(data.result.memberTel);
                    //循环遍历订单内的商品信息
                    var orderGoodsListTemplate = template("orderGoodsListTemplate", {orderDetailQueryVo: data.result});
                    $("#goodsListTable").html(orderGoodsListTemplate);
                }
            } else {
                window.wxc.xcConfirm("异常，请联系管理员。", "error");
            }
        }).fail(function () {
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
            //移除 事件,最后执行
        });
        //页面加载
        $(".packageInfo").hide();
        $(".package").eq(0).trigger("click");
    })
    $(".package").click(function () {
        $(this).siblings().removeClass("packageFont");
        $(this).addClass("packageFont");
        $('#div' + this.id).siblings().hide();
        $('#div' + this.id).show();

    })
</script>
</html>