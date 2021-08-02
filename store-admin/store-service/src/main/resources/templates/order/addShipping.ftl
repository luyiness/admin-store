<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <#include "/include/head.ftl">
    <link rel="stylesheet" href="${p_static}/admin/layui/css/layui.css">
    <link rel="stylesheet" href="${p_static}${_v('/admin/css/order/base.css')}" type="text/css"/>
    <link rel="stylesheet" href="${p_static}${_v('/admin/css/order/logistics.css')}" type="text/css">
    <script src="${p_static}/admin/js/jquery1.11.2.min.js"></script>
    <script type="text/javascript" src="${p_static}/admin/layui/layui.js"></script>
    <script src="${p_static}/admin/js/order/addShipping.js" type="text/javascript"></script>
    <script type="text/javascript" src="${p_static}/admin/js/template.js"></script>
    <title>添加物流</title>
    <style>
        .pageWidth {
            width: 1080px;
            margin: 0 auto;
        }

        .invoiceTab {
            border-bottom: 3px solid #4f9fdb;
        }

        .invoiceTab em {
            font-style: normal;
            font-size: 20px;
            color: #4f9fdb;
            padding-bottom: 2px;
        }

        #showAddShipping {
            color: orange;
            border: 1px solid orange;
            border-radius: 5px;
            padding: 5px 10px;
        }

        .logisLeft {
            width: 100%;
        }

        .labLeft {
            width: 150px;
        }

        .popBtnC span, .twoBtnC span {
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

        #submitEditShipping, .twoSureBtn {
            color: #fff;
            background: #4e9bd6;
            border: 1px solid #4e9bd6;
        }

        #submitEditShipping, .twoBackBtn {
            margin-right: 30px;
        }

        #cancelEditShipping, .twoBackBtn {
            color: #333;
            border: 1px solid #333;
        }

        .addLogisTit, .addLogisInfo {
            width: 65%;
            margin: 0 auto;
        }

        .addLogisInfo {
            border-width: 1px;
        }

        .logisMethods select, .logisCode, .inputCom {
            width: 300px;
        }

        .popBtnC {
            margin: 30px auto;
            text-align: center;
        }

        .inputComtext {
            height: 100px;
            width: 300px;
            resize: none;
        }

        .pointer {
            cursor: pointer;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<#include "/include/top-menu.ftl"/>
<#include "/include/left.ftl"/>
<input type="hidden" value="${orderNo}" id="orderNo">
<div class="logis">
    <div class="invoiceTab pageWidth">
        <em class="blue agreeNum">添加物流</em>
    </div>
    <div class="line"></div>
    <script type="text/html" id="shippingInfoTemplete">
        {{if result}}
        <div class="logisMain">
            <div class="orderMain mt30">
                <div class="orderTit">订单信息</div>
                <div class="orderInfo">
                    <table>
                        <colgroup>
                            <col width="20%">
                            <col width="30%">
                            <col width="20%">
                            <col width="30%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <td class="bgLBlue">供应商</td>
                            <td>{{result.orderMainDto.storeName}}</td>
                            <td class="bgLBlue">订单号</td>
                            <td>{{result.orderMainDto.orderNo}}</td>
                        </tr>
                        <tr>
                            <td class="bgLBlue">订单金额</td>
                            <td>{{result.orderMainDto.sumPrice}}</td>
                            <td class="bgLBlue">下单时间</td>
                            <td>{{result.orderMainDto.createTime}}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="orderMain">
                <div class="orderTit">物流信息</div>
                <div class="orderInfo">
                    <table>
                        <colgroup>
                            <col width="20%"/>
                            <col width="20%"/>
                            <col width="20%"/>
                            <col width="20%"/>
                            <col width="20%"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <td>序号</td>
                            <td>物流方式</td>
                            <td>物流公司</td>
                            <td>物流编号</td>
                            <td>操作</td>
                        </tr>
                        </thead>
                        <tbody id="logisticTable">
                        {{each result.mallShippings as mallShipping index}}
                        <tr>
                            <td>{{index+1}}</td>
                            <td>{{mallShipping.shippingType}}</td>
                            {{if mallShipping.shippingType=='自送' || mallShipping.shippingCompany==null ||
                            mallShipping.shippingCompany=="请选择物流公司"}}
                            <td></td>
                            <td></td>
                            {{else}}
                            <td>{{mallShipping.shippingCompany}}</td>
                            <td>{{mallShipping.shippingNo}}</td>
                            {{/if}}
                            <td>
                                <span class="pointer"
                                      onclick="editeShippingInfo('{{mallShipping.id}}',this,'{{mallShipping.shippingType}}')"
                                      style="color: #3c8dbc;">编辑</span>
                                <span class="pointer" onclick="deleteShippingInfo('{{mallShipping.id}}')"
                                      style="color: #3c8dbc;">删除</span>
                            </td>
                        </tr>
                        {{/each}}
                        <tr>
                            <td colspan="5"><span class="pointer" id="showAddShipping" onclick="showAddShipping()">+添加物流信息</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        {{/if}}
    </script>
    <div class="pageWidth">
        <div class="shippingInfo" id="shippingInfo"></div>
        <div class="addLogis hide" id="addLogis">
            <input type="hidden" id="shippingId"/>
            <div class="addLogisTit" style="color:red;margin: 30px auto 5px auto;">添加物流信息</div>
            <div class="addLogisInfo">
                <div class="logisInfo clear">
                    <div class="logisLeft fl">
                        <div class="logisMethods">
                            <label class="labLeft">物流方式：</label>
                            <select id="style">
                                <option selected=selected" value="">请选择物流方式</option>
                                <option>快递</option>
                            </select>
                        </div>
                        <div id="express" class="">
                            <div class="logisMethods" id="shippingCompanyDiv">
                                <label class="labLeft">物流公司:</label>
                                <select id="logisticCompany" name="shippingCode">
                                </select>
                            </div>
                            <div class="logisMethods" id="codeshippings">
                                <label class="labLeft">物流编号：</label>
                                <input class="logisCode inputCom" id="logisCode" type="text" placeholder="物流编号">
                            </div>
                        </div>
                        <script id="shippingCompanyTemplate" type="text/html">
                            <option selected=selected" value="">请选择物流公司</option>
                            {{each data as value i}}
                            <option value="{{value.simpleName}}">{{value.fullName}}</option>
                            {{/each}}
                        </script>
                        <div class="">
                            <label class="note labLeft">备注：</label>
                            <textarea name="" class="inputComtext" id="remark" cols="30" rows="10"
                                      placeholder="备注"></textarea>
                        </div>
                        <div class="popBtnC">
                            <span class="pointer" id="submitEditShipping">确认</span>
                            <span class="pointer" id="cancelEditShipping">取消</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="orderDetilBtnC twoBtnC" style="margin: 30px auto; text-align: center;">
            <span class="reviseCancelBtn twoBackBtn pointer"
                  onclick="window.location.href='${ctx}/order/ordersList'">返回</span>
            <span class="reviseCancelBtn twoSureBtn pointer" onclick="sureOrderShipping()">确认</span>
        </div>
    </div>
</div>
<#--</div>-->
</body>
<#include "/include/resource.ftl">
<script>

    /*查询所有的物流公司*/
    $(function () {
        $.ajax({
            url: "/store-admin/mallShipping/findUsAbleLogisticsCompany",
            type: "POST",
        }).done(function (data) {
            if (data.success) {
                var shippingCompanyTemplate = template("shippingCompanyTemplate", {data: data.result});
                $("#logisticCompany").html(shippingCompanyTemplate);
            } else {
                window.wxc.xcConfirm("暂无物流公司信息。", "error");
            }
        }).fail(function () {
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
        });
    });

    $('#style').change(function () {
        switch ($(this).children('option:selected').text().trim()) {
            case '快递': {
                displayOrNot(true);
                break;
            }
            case '自送': {
                displayOrNot(false);
                break;
            }
            case '请选择物流方式': {
                displayOrNot(true);
                break;
            }
        }
    });

    function displayOrNot(flag) {
        if (flag) {
            $("#shippingCompanyDiv").css("display", "block");
            $("#codeshippings").css("display", "block");
        } else {
            $("#shippingCompanyDiv").css("display", "none");
            $("#codeshippings").css("display", "none");
        }
    }

    /*订单物流添加*/
    function sureOrderShipping() {
        //点击确认，将该suborder的状态置为待收货
        var orderNo = $("#orderNo").val();
        $.ajax({
            url: "/store-admin/mallShipping/sureOrderShipping",
            type: "POST",
            data: {
                orderNo: orderNo
            },
            dataType: "json",
            success: function (result) {
                if (result.success) {
                    window.wxc.xcConfirm("处理成功。", "success");
                    window.location.href = '${ctx}/order/ordersList';
                } else {
                    window.wxc.xcConfirm("处理失败，原因:" + result.result, "error");
                }
            },
            error: function () {
                window.wxc.xcConfirm("出现错误，请联系管理员。", "error");
            }
        });
    }

</script>
</html>