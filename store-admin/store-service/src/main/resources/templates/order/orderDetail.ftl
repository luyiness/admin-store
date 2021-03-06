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
    <title>???????????????????????????</title>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
    <#include "/include/top-menu.ftl"/>
    <#include "/include/left.ftl"/>
    <div class="content-wrapper" style="background: #fff">
        <section class="content-header">
            <h1>
                ????????????
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> ??????</a></li>
                <li class="active"><a href="#">????????????</a></li>
            </ol>
        </section>
        <section class="content">
            <div class="conNavR fr frintOrderDetail">
                <p class="myChoicel">????????????</p>
                <div>
                    <div class="line"></div>
                </div>
                <span id="orderId" style="display: none"></span>
                <div class="contentDetail">
                    <div class="title">????????????</div>
                    <table class="table detailTa">
                        <tr>
                            <td>?????????</td>
                            <td id="providerName"></td>
                            <td>?????????</td>
                            <td id="orderNo"></td>
                        </tr>
                        <tr>
                            <td>????????????</td>
                            <td id="sumNofreightPrice"></td>
                            <td>??????</td>
                            <td id="freight"></td>
                        </tr>
                        <tr><td>????????????</td>
                            <td id="orderDate" colspan="3"></td>
                        </tr>
                    </table>
                </div>
                <div class="contentDetail">
                    <div class="title">???????????????</div>
                    <table class="table detailTa">
                        <tr>
                            <td>?????????</td>
                            <td id="getOrderMan"></td>
                            <td>???????????????</td>
                            <td id="tel"></td>
                        </tr>
                        <tr>
                            <td>???????????????</td>
                            <td colspan="3" id="address">
                        </tr>
                    </table>
                </div>
                <div class="contentDetail">
                    <div class="title" id="shipping">????????????</div>
                </div>
                <div class="contentDetail" style="margin-top: 0px;padding-top: 0px" id="goodsListTable">
                    <script id="orderGoodsListTemplate" type="text/html">
                        <div class="contentDetail">
                            {{each orderDetailQueryVo.subOrderItemWithSubOrderNo as value2 i}}
                            <table class="detailsho" style="width: 100%;">
                                <tr class="tcontent">
                                    <!-- ???????????????????????????(??????)-->
                                    {{if value2.subOrderStatusAfterSendOrder > 1}}
                                    <td width="10%">?????? : {{i + 1}}</td>
                                    {{/if}}
                                    <#-- ???????????????-->
                                    <td width="30%">????????????:<span id="subOrderNo">{{value2.subOrderNo}}</span></td>
                                    <td width="30%" align="left" class="fontblue">?????? :
                                        {{value2.subOrderSumPrice}} ???
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
                                        <a>{{value.name}}(????????????:{{value.skuId}})</a>
                                    </td>
                                    <td align="center" width="25%">?????????<span class="">{{value.price}}???</span></td>
                                    <td align="center" width="13%">???????????{{value.count}}</td>
                                    <td width="7%"></td>
                                    <td align="right" width="20%">
                                        <a href="javascript:void(0)">
                                            <span class="fontora litilesum">
                                                ??????: {{value.orderItemTotalPrice}}???
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
                                    <th colspan="8">????????????</th>
                                </tr>
                                <tr class="tcontent">
                                    <th style="text-align:center;width: 45px;">??????</th>
                                    <th style="text-align:center;width: 10%;">????????????</th>
                                    <th style="text-align:center;width: 10%;">????????????</th>
                                    <th style="text-align:center;width: 10%;">????????????</th>
                                    <th style="text-align:center;width: 10%;">????????????</th>
                                    <th style="text-align:center;">??????</th>
                                </tr>
                                </thead>
                                <tbody>
                                {{each value2.subOrderShippingListVos as value i}}
                                {{if value.shippingCompanyName==undefined}}
                                <tr>
                                    <td style="text-align: center;">{{i + 1}}</td>
                                    <td style="text-align: center;" colspan="5">???????????????????????????</td>
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
                                    <!--??????????????????-->
                                    <td style="text-align: center;">
                                        {{if value.shippingStatus==1}}
                                        ?????????
                                        {{else if value.shippingStatus==2}}
                                        ?????????
                                        {{else if value.shippingStatus==4}}
                                        ?????????
                                        {{else if value.shippingStatus==7}}
                                        ?????????
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
                            <div class="title" id="shipping" style="margin-left: -35px;">????????????</div>
                        </div>
                        <table id="permTable" class="table table-bordered table-striped">
                            <thead>
                            <tr>
                                <th style="text-align:center;width: 45px;">??????</th>
                                <th style="text-align:center;width: 10%;">????????????</th>
                                <th style="text-align:center;width: 10%;">????????????</th>
                                <th style="text-align:center;width: 10%;">????????????</th>
                                <th style="text-align:center;width: 10%;">????????????</th>
                                <th style="text-align:center;">??????</th>
                            </tr>
                            </thead>
                            <tbody>
                            {{each orderDetailQueryVo.subOrderItemWithSubOrderNo[0].subOrderShippingListVos as value i}}
                            {{if value.length <= 0}}
                            {{if orderDetailQueryVo.subOrderItemWithSubOrderNo.length == 1}}
                            <tr>
                                <td style="text-align: center;" colspan="6">???????????????????????????</td>
                            </tr>
                            {{else}}
                            <tr>
                                <td style="text-align: center;">{{i + 1}}</td>
                                <td style="text-align: center;" colspan="6">???????????????????????????</td>
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
                                <!--??????????????????-->
                                <td style="text-align: center;">
                                    {{if value.shippingStatus == 1}}
                                    ?????????
                                    {{else if value.shippingStatus == 2}}
                                    ?????????
                                    {{else if value.shippingStatus == 4}}
                                    ?????????
                                    {{else if value.shippingStatus == 7}}
                                    ?????????
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
                                    onclick="window.location.href='${ctx}/order/ordersList'">??? ???
                            </button>
                            <!-- ???????????????????????? ????????????????????????????????????-->
                            {{if orderDetailQueryVo.singleSubOrderStatus == "6" && orderDetailQueryVo.afterSaleType != "2"}}
                            <button class="backButton"
                                    style="margin-top: 40px;margin-left: 100px;"
                                    type="button" id="sureOrder"
                                    onclick="sureOrder()">????????????
                            </button>
                            {{else}}
                            {{/if}}
                        </div>
                        </div>
                    </script>
        </section>
    </div>
    <#--??????-->
    <div class="modal fade" id="shippingInfosModal" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">????????????</h4>
                </div>
                <div class="modal-body" id="updateProductStockDiv">
                    <div class="track-rcol">
                        <div style="margin-left: 100px;" id="shippingNo">????????????:</div>
                        <div style="margin-left: 100px;MARGIN-TOP: 20PX;" id="company">????????????:</div>
                    </div>

                    <div class="track-rcol" style="margin-top: 20px;">
                        <div style="margin-left: 100px;MARGIN-TOP: 20PX;" id="shippingNo">????????????</div>
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
                            id="updateProductStockCountBtn" data-dismiss="modal">??????
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
    /***????????????**/
    function sureOrder() {
        window.wxc.xcConfirm("????????????:??????????????????", "confirm", {
            onOk: function () {
                var orderNo = $("#orderId").text();//orderNo?????????
                var datas = {"orderNo": orderNo};
                $.ajax({
                    url: "${ctx}/order/sureOrdersByOrderId",
                    type: "POST",
                    data: datas
                }).done(function (data) {
                    if (data.success) {
                        window.wxc.xcConfirm("???????????????", "success");
                        window.location.href = '${ctx}/order/ordersList';
                    } else {
                        window.wxc.xcConfirm("????????????????????????????????????" + data.result, "error");
                    }
                }).fail(function () {
                    window.wxc.xcConfirm("??????????????????????????????", "error");
                });
            }
        })
    }

    function logisticLineShow(that) {
        var contents = $(that).text();
        var company = $(that).parent().parent().find("td").eq(2).text();
        var shippingNo = $(that).parent().parent().find("td").eq(3).text().trim();
        $("#company").text("????????????:" + company);
        $("#shippingNo").text("????????????:" + shippingNo);

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
                window.wxc.xcConfirm("?????????????????????", "error");
            }
        }).fail(function () {
            $("#shippingInfosModal").modal('hide');
            window.wxc.xcConfirm("??????????????????????????????", "error");
        }).always(function () {
        });
    }

    /**??????dizhi?????????**/
    function getQueryString(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    }

    var load = new Loading();
    //??????????????????????????????
    var showLoading = function () {
        load.init();
        load.start();
    };
    //??????????????????????????????
    var hideLoading = function () {
        load.stop();
    };
    $(function () {
        //???????????????
        var orderNo = getQueryString("orderNo");
        /**??????????????????????????????**/
        $.ajax({
            url: "${ctx}/order/orderDetails",
            type: "POST",
            data: {
                orderNo: orderNo
            }, beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            //????????????????????????
            data = $.parseJSON(data);
            if (data.success) {
                if (data.result.orderId == undefined) {
                    window.wxc.xcConfirm("????????????????????????????????????", "error");
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
                    //????????????????????????????????????
                    var orderGoodsListTemplate = template("orderGoodsListTemplate", {orderDetailQueryVo: data.result});
                    $("#goodsListTable").html(orderGoodsListTemplate);
                }
            } else {
                window.wxc.xcConfirm("??????????????????????????????", "error");
            }
        }).fail(function () {
            window.wxc.xcConfirm("??????????????????????????????", "error");
        }).always(function () {
            hideLoading();
            //?????? ??????,????????????
        });
        //????????????
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