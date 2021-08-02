<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
    <link rel="stylesheet" href="${p_static}/admin/layui/css/layui.css">
    <link rel="stylesheet" href="${p_static}/admin/css/load/load.css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/datepickerinput.css">
    <link rel="stylesheet" href="${p_static}/admin/css/invoice.css">
    <#include "/include/head.ftl" />
    <style>
        label {
            margin-bottom: 0;
            vertical-align: middle;
        }

        .form-group {
            width: 32%;
            margin-bottom: 15px !important;
        }

        .form-group-time {
            width: 52%;
        }

        .form-group label {
            width: 98px;
            text-align: right;
        }

        .form-inline .form-control {
            width: 68% !important;
        }

        .form-inline .form-group-time .form-control {
            width: 45% !important;
        }

        @media (min-width: 1903px) {
            .form-group {
                width: 20%;
                margin-bottom: 15px !important;
            }

            .form-group-time {
                width: 38%;
            }

            .form-group label {
                width: 98px;
                text-align: right;
            }

            .form-inline .form-control {
                width: 68% !important;
            }

            .form-inline .form-group-time .form-control {
                width: 45% !important;
            }
        }

        .dt-body-center {
            text-align: center;
            word-break: break-all;
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
                订单管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/order/ordersList">订单管理</a></li>
            </ol>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well">
                        <div class="form-group" style="/*margin: 10px;margin-right: 25px;*/">
                            <label>供应商：</label><input type="text" class="form-control"
                                                      id="provideName" disabled name="provideName">
                            <input type="text" class="form-control"
                                   id="storeId" style="display: none;" name="storeId">
                        </div>
                        <div id="providerOrderStatusDiv" class="form-group" style="/*margin-right: 25px;*/"></div>
                        <script id="providerOrderStatusTemplate" type="text/html">
                            <label>订单状态：</label>
                            <select style="width: 120px;" class="form-control" id="trdOrderState"
                                    name="providerSaleStatus"
                                    placeholder="订单状态">
                                <option selected="selected" value="">全部</option>
                                {{each providerOrderStatus as value i}}
                                <option value="{{i}}">{{value}}</option>
                                {{/each}}
                            </select>

                        </script>
                        <div class="form-group" style="/*margin-right: 25px;*/">
                            <label>订单号：</label>
                            <input type="text" class="form-control" placeholder="订单号"
                                   id="orderNo" name="orderNo">
                        </div>
                        <div class="form-group form-group-time">
                            <label class="fl pt8"
                                   style="display: inline-block;vertical-align: middle;margin-bottom: 0;">下单时间：</label>
                            <div class="query-item-main fl date-item rel"
                                 style="display: inline-block;vertical-align: middle;">
                                <input id="beginTime" type="text" class="fl date-input form-control"
                                       readonly="readonly"
                                       onclick="WdatePicker()" placeholder="请选择起始日期" name="orderStartTime"/>
                                <span class="fl pt6">&nbsp;—&nbsp; </span>
                                <input id="endTime" type="text" class="fl date-input form-control"
                                       readonly="readonly"
                                       onclick="WdatePicker()" placeholder="请选择终止日期"/>
                            </div>
                        </div>
                        <div class="btnC"
                             style="overflow: hidden;display: inline-block;vertical-align: middle;margin-left: 25px;width: 98%;">
                            <table style="float: right;margin: 10px;width: 100%">
                                <tr>
                                    <td></td>
                                    <td>
                                        <div style="float: right;margin: 10px;">
                                            <button type="button" style="float: right" class="btn"
                                                    onclick="search()">
                                                <i class="fa fa-search"></i>查询
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left;margin: 10px;">
                                            <button type="button" style="float: right" class="btn"
                                                    onclick="orderExport()">
                                                <i class="fa fa-search"></i>订单导出
                                            </button>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="float: right;margin: 10px;">
                                            <button type="button" style="float: left" class="btn"
                                                    onclick="batchSureNagetiveOrders()">
                                                <i class=""></i>批量确认拒收
                                            </button>
                                        </div>
                                        <#--<div style="float: right;margin: 10px;">
                                            <button type="button" style="float: left" class="btn"
                                                    onclick="batchSureGetOrders()">
                                                <i class=""></i>批量确认收货
                                            </button>
                                        </div>-->
                                        <div style="float: right;margin: 10px;">
                                            <button type="button" style="float: left" class="btn"
                                                    onclick="batchSureOrders()">
                                                <i class=""></i>批量确认订单
                                            </button>
                                        </div>
                                        <div style="float: right;margin: 10px;">
                                            <button type="button" style="float: left" class="btn"
                                                    onclick="batchAddShipping()">
                                                <i class=""></i>批量添加物流
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                    <div class="box">

                        <div class="box-body">
                            <table id="permTable" class="table table-bordered table-striped">
                                <thead>
                                <tr>
                                    <th style="text-align:center;width: 20px;">
                                        <input type="checkbox" style="margin-left: 0px;" class="cb-getOrders"/>
                                    </th>
                                    <#--<th style="text-align:center;width: 10%;">子订单号</th>-->
                                    <th style="text-align:center;width: 12%;">订单号</th>
                                    <th style="text-align:center;width: 10%;">下单时间</th>
                                    <th style="text-align:center;width: 8%;">商品金额</th>
                                    <th style="text-align:center;width: 5%;">运费</th>
                                    <th style="text-align:center;width: 8%;">收货人</th>
                                    <th style="text-align:center;width: 20%;">收件地址</th>
                                    <th style="text-align:center;width: 12%;">物流单号</th>
                                    <th style="text-align:center;width: 10%;">订单状态</th>
                                    <th style="text-align:center;width: 7%;">是否售后中</th>
                                    <th style="text-align:center;width: 10%;">操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <#------------------------批量添加物流------------------------>
    <div class="coverLayer wuliuLayer" id="batchAddShippingId" hidden>
        <div class="coverCon" style="height: 300px;">
            <header>
                导入
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row">
                    <div class="contentLMargin" style="padding-left: 50px;">
                        <table style="height: 190px;">
                            <tr>
                                <td>
                                    <font style="font-weight: bolder;">导入模板下载：</font>
                                </td>
                                <td>
                                    <a href="${ctx}/order/downBatchExcel"
                                       style="color: #029bdf"><u>《订单批量添加物流模板下载.xls》</u></a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font style="font-weight: bolder;">请选择导入文件：</font>
                                </td>
                                <td>
                                    <form enctype="multipart/form-data" id="fileFormBatch">
                                        <input type="file" name="file" id="importXLSBatch">
                                    </form>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="sureBtnBox" style="text-align: right;height: 100%;width: 100%;">
                <table style="width: 100%;height: 75px;border: 1px solid #eee;">
                    <tr>
                        <td style="width: 33%;"></td>
                        <td style="width: 33%;"></td>
                        <td style="text-align: center">
                            <button class="btn" type="button"
                                    style="width: 60px;background-color: #eee;margin: 10px;"
                                    onclick="closeBoxBatch();">关闭
                            </button>
                            <button class="btn" type="button"
                                    style="width: 60px;background-color: #2493f2;color: white;margin: 10px;"
                                    onclick="uploadFileBatch();">上传
                            </button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="coverLayer wuliuLayer" id="uploadingIdBatch" hidden>
        <div class="coverCon">
            <header>
                温馨提示
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row">
                    <div class="contentLMargin">
                        文件导入中...
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="coverLayer wuliuLayer" id="dialogIdsBatch" hidden>
        <div class="coverCon" style="height: 300px;">
            <header>
                <span id="tipTextBatch"></span>
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row" style="height:100px;">
                    <div class="" id="contentIdsBatch"
                         style="overflow-y:scroll;height:200px;margin-left:100px;overflow: hidden;">
                    </div>
                </div>
            </div>
            <div class="sureBtnBox">
                <span class="sureBtn" onclick="closeBoxBatch();">确 定</span>
            </div>
        </div>
    </div>
    <#------------------------批量添加物流------------------------>

    <#include "/include/foot.ftl"/>
</div>
<#include "/include/resource.ftl"/>
</body>
<script type="text/javascript" src="${p_static}/admin/layui/layui.js"></script>
<script src="${p_static}/admin/js/template/template.js"></script>
<script src="${p_static}/admin/js/load/load-min.js"></script>
<script type="text/javascript" src="${p_static}/admin/js/order/addShipping.js"></script>

<script>

    layui.use('upload', function () {
        var $ = layui.jquery, upload = layui.upload;
    });

    function batchAddShipping() {
        $("#batchAddShippingId").show();
    }

    function closeBoxBatch() {
        $("#dialogIdsBatch").hide();
        $("#batchAddShippingId").hide();
        $("#dialogIdsBatch").hide();
    }

    function uploadFileBatch() {
        var isValidate = true;
        var filePath = $("#importXLSBatch").val();
        if (filePath != "") {
            var suffix = filePath.substr(filePath.lastIndexOf(".") + 1, filePath.length);
            if (suffix.toLowerCase() == "xls" || suffix.toLowerCase() == "xlsx") {
                isValidate = true;
            } else {
                isValidate = false;
                window.wxc.xcConfirm("只能上传xls文件", "info");
            }
        } else {
            isValidate = false;
            window.wxc.xcConfirm("请先选择要上传的excel文件", "info");
        }
        if (isValidate) {
            $("#fileFormBatch").ajaxSubmit({
                type: 'post',
                url: STATIC_CTX + '/order/batchImportExcel',
                success: function (data) {
                    var errorText;
                    //异常信息
                    var errorMsg = data.errorMsg;
                    if (errorMsg != undefined && errorMsg != null && errorMsg != "") {
                        errorText = "<br>";
                        for (var i = 0; i < errorMsg.length; i++) {
                            errorText += errorMsg[i].error + "<br>";
                        }
                    } else {
                        //导入结果
                        var returnList = data.returnList;
                        $("#importXLSBatch").val(null);
                        $("#uploadingIdBatch").hide();
                        errorText = "共导入";
                        errorText += returnList.length;
                        errorText += "条数据，其中";
                        if(data.errorSize == undefined || returnList.length ==undefined){
                            errorText += "0条导入成功，";
                            errorText += "0条导入失败";
                        } else {
                            errorText += returnList.length - data.errorSize;
                            errorText += "条导入成功，";
                            errorText += data.errorSize;
                            errorText += "条导入失败";
                        }
                        errorText += "</br>";
                        errorText += "</br>";
                        errorText += "</br>";
                        errorText += "<a onclick='downReturnListBatch(" + JSON.stringify(returnList) + ")' style='color: #1E9FFF; cursor: pointer;'>下载导入结果</a><br>";
                        $("#tipTextBatch").html("导入结果");
                        $("#contentIdsBatch").html("<p class='logisticsProgress' style='padding-top: 50px'>" + errorText + "</p>");
                        $("#dialogIdsBatch").show();
                    }
                    table.ajax.reload();
                },
                error: function (data) {
                    $("#uploadingIdBatch").hide();
                    window.wxc.xcConfirm("文件导入出错，请重新导入！", "info", window.wxc.xcConfirm.btnEnum.ok);
                }
            });
            $("#importBatchId").hide();
            $("#importXLSBatch").val(null);
            $("#uploadingIdBatch").show();
        }
    }

    function downReturnListBatch(returnList) {
        var form = $("<form>");
        form.attr('style', 'display:none');
        form.attr('target', '_blank');
        form.attr('method', 'post');
        form.attr('action', STATIC_CTX + '/order/downloadReturnList');

        var returninput = $('<input>');
        returninput.attr('type', 'hidden');
        returninput.attr('name', 'returnList');
        returninput.attr('value', JSON.stringify(returnList));
        form.append(returninput);

        $('body').append(form);
        form.submit();
    }


    var table;
    var searchFlag = false;

    var $wholeChexbox = $('.cb-getOrders');    //全局的全部checkbox

    function init() {
        var $allCheckbox = $('input[type="checkbox"]');     //全局的全部checkbox
        var $wholeChexbox = $('.cb-getOrders');    //全局的全部checkbox
        var $cartBox = $('tbody>tr');

        $wholeChexbox.prop("checked", false);//初始化 全选按钮为false

        $allCheckbox.click(function () {
            if ($(this).is(':checked')) {
            } else {
            }
        });
        //===============================================全局全选与单个选择的关系================================
        $wholeChexbox.click(function () {
            var $chkBox = $('tbody>tr');
            var $checkboxs = $chkBox.find('input[type="checkbox"]');
            if ($(this).is(':checked')) {
                $checkboxs.prop("checked", true);
            } else {
                $checkboxs.prop("checked", false);
            }
        });
        $($('tbody>tr').find('input[type="checkbox"]')).each(function () {
            $(this).click(function () {
                if ($(this).is(':checked')) {
                    //判断：所有单个商品是否勾选
                    var len = $($('tbody>tr').find('input[type="checkbox"]')).length;
                    var num = 0;
                    $($('tbody>tr').find('input[type="checkbox"]')).each(function () {
                        if ($(this).is(':checked')) {
                            num++;
                        }
                    });
                    if (num == len) {
                        $('.cb-getOrders').prop("checked", true);
                    }
                } else {
                    //单个商品取消勾选，全局全选取消勾选
                    $('.cb-getOrders').prop("checked", false);
                }
            })
        })
        getCheckedout();
    }

    /**防止点击分页条出现 全选无法去掉*/
    function getCheckedout() {
        //防止点击分页条出现 全选无法去掉
        $(".pagination").find("a").each(function () {
            $(this).click(function () {
                $wholeChexbox.prop("checked", false);
            })
        })
    }

    $(function () {
        //加载订单状态数据
        $.ajax({
            url: "${ctx}/order/providerEnterOrderStatus",
            type: "POST",
            beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            var providerOrderStatusTemplate = template("providerOrderStatusTemplate", {providerOrderStatus: $.parseJSON(data)});
            $("#providerOrderStatusDiv").html(providerOrderStatusTemplate);
        }).fail(function () {
            window.wxc.xcConfirm("异常无法拉取订单状态信息，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
            //移除 事件,最后执行
        });
        //供应商名字
        $.ajax({
            url: "${ctx}/product/getStoreName",
            type: "POST"
        }).done(function (data) {
            if (data.success) {
                $("#provideName").val(data.result);
            } else {
                window.wxc.xcConfirm("没获取到供应商姓名，异常，请联系管理员。", "error");
            }
        }).fail(function () {
            window.wxc.xcConfirm("没获取到供应商姓名，异常，请联系管理员。", "error");
        });

        table = $('#permTable').DataTable({
            "oLanguage": {
                "sLengthMenu": "每页显示 _MENU_ 条记录",
                "sZeroRecords": "抱歉， 没有找到",
                "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
                "sInfoEmpty": "没有数据",
                "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
                "oPaginate": {
                    "sFirst": "首页",
                    "sPrevious": "前一页",
                    "sNext": "后一页",
                    "sLast": "尾页"
                },
                "sZeroRecords": "没有检索到数据",
                "sProcessing": "<img src='./loading.gif' />",
                "sSearch": "搜索"
            },

            "bStateSave": false,
            "bJQueryUI": true,
            "bPaginate": true,// 分页按钮
            "bFilter": false,// 搜索栏
            "bLengthChange": false,// 每行显示记录数
            "iDisplayLength": 10,// 每页显示行数
            "bSort": false,// 排序
            "bInfo": true,// Showing 1 to 10 of 23 entries 总记录数没也显示多少等信息
            "bWidth": true,
            "bScrollCollapse": true,
            "sPaginationType": "full_numbers", // 分页，一共两种样式 另一种为two_button // 是datatables默认
            "bServerSide": true,
            "bDestroy": true,
            "bSortCellsTop": true,
            "sAjaxSource": "${ctx}/order/orderList",
            "fnInitComplete": function () {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams": function (aoData) {
                aoData.push({
                        "name": "storeId",
                        "value": $("#storeId").val()
                    }, {
                        "name": "trdOrderState",
                        "value": $("#trdOrderState").val()
                    }, {
                        "name": "beginTime",
                        "value": $("#beginTime").val()
                    }, {
                        "name": "endTime",
                        "value": $("#endTime").val()
                    }, {
                        "name": "orderNo",
                        "value": $("#orderNo").val()
                    }
                );
            },
            "aoColumnDefs": [
                {
                    'targets': 0,
                    'searchable': false,
                    'orderable': false,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        return '<input class="checkchild" style="margin-left: 0px;"  subOrder-bind=' + row.subOrderNo + ' type="checkbox" />';
                    }
                },
                {
                    'targets': 1,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.orderNo == null) {
                            return '暂无';
                        }
                        return row.orderNo;
                    }
                },
                {
                    'targets': 2,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.sumCostPrice == null) {
                            return '暂无';
                        }
                        return row.createdTime;
                    }
                },
                {
                    'targets': 3,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.sumNofreightPrice == null) {
                            return '暂无';
                        }
                        return row.sumNofreightPrice;
                    }
                },
                {
                    'targets': 4,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.freight == null) {
                            return '暂无';
                        }
                        return row.freight;
                    }
                },
                {
                    'targets': 5,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.recipientName == null) {
                            return '暂无';
                        }
                        return row.recipientName;
                    }
                },
                {
                    'targets': 6,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.addressName == null) {
                            return '暂无';
                        }
                        return row.addressName;
                    }
                },
                {
                    'targets': 7,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.logisticsNo == null || row.logisticsNo == "") {
                            return '暂无';
                        }
                        return row.logisticsNo;
                    }
                },
                {
                    'targets': 8,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.trdOrderState == null || row.trdOrderState == "") {
                            return '暂无';
                        }
                        if (row.afterSaleStatusName!=null && row.afterSaleStatusName!=undefined && (row.afterSaleRefundType == 1 || row.afterSaleRefundType == 2)) {
                            return row.afterSaleStatusName;
                        }
                        switch (row.trdOrderState) {
                            case   "1" :
                                return "已发货";
                            case   "2" :
                                return "已签收";
                            case   "3" :
                                return "已取消";
                            case   "4" :
                                return "已拒收";
                            case   "5" :
                                return "待付款";
                            case   "6" :
                                return "待确认";
                            case   "7" :
                                return "已确认";
                            case   "8" :
                                return "卖家已取消";
                            case   "9" :
                                return "系统已取消";
                        }
                    }
                },{
                    'targets': 9,
                    'className': 'dt-body-center',
                    'render': function (data, type, row) {
                        if (row.ifAfterSaling == null || row.ifAfterSaling == "") {
                            return '暂无';
                        }
                         return row.ifAfterSaling;
                    }
                },
                {
                    "aTargets": [10],
                    "className": "dt-body-center",
                    "data": "id",
                    "mRender": function (a, b, c, d) {//id，c表示当前记录行对象
                        var urls = '<a href=\"javascript:void(0);\" onclick=\"showOrderDetails(\'' + c.orderNo + '\')\">详情</a>';
                        switch (c.trdOrderState) {
                            case   "1" :
                                if (c.afterSaleType != 2) {
                                    //  order_state = "已发货";
                                    //urls += " | " + '<a href=\"javascript:void(0);\" onclick=\"confirmationReceipt(\'' + c.subOrderNo + '\')\">确认收货</a>'
                                    urls +=   " | " + '<a href=\"javascript:void(0);\" onclick=\"confirmationReject(\'' + c.subOrderNo + '\')\">确认拒收</a>'
                                        + " | " + '<a href=\"javascript:void(0);\" onclick=\"editShipping(\'' + c.orderNo + '\')\">物流编辑</a>';
                                }
                                break;
                            case   "2" :
                                //  order_state = "已收货";
                                // urls+=" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认收货</a>'+" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认拒收</a>';
                                break;
                            case   "3" :
                                // order_state = "已取消";
                                // urls+=" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认收货</a>'+" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认拒收</a>';
                                break;
                            case   "4" :
                                //order_state = "已拒收";
                                //  urls+=" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认收货</a>'+" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认拒收</a>';
                                break;
                            case   "5" :
                                //order_state = "待付款";
                                //   urls+=" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认收货</a>'+" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认拒收</a>';
                                break;
                            case   "6" :
                                //order_state = "待确认";
                                if (c.afterSaleType != 2) {
                                    urls += " | " + '<a href=\"javascript:void(0);\" onclick=\"sureOrder(\'' + c.subOrderNo+"','"+c.ifAfterSaling+ '\')\">确认订单</a>' + " | " + '<a href=\"javascript:void(0);\" onclick=\"deniedOrder(\'' + c.orderNo + '\', \'' + c.subOrderNo + '\')\">取消订单</a>';
                                }
                                break;
                            case   "7" :
                                //order_state = "已确认";
                                if (c.afterSaleType != 2) {
                                urls += " | " + '<a href=\"javascript:void(0);\" onclick=\"addLogistic(\'' + c.orderNo + '\')\">添加物流</a>';
                                }
                                break;
                            case   "8" :
                                //order_state = "卖家已取消";
                                //urls+=" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认收货</a>'+" | " +'<a href=\"javascript:void(0);\" onclick=\"upPro(\'' + a + '\')\">确认拒收</a>';
                                break;
                        }
                        return urls;
                    }
                }
            ],
            "fnRowCallback": function (nRow, aData, iDisplayIndex) {//相当于对字段格式化

            },

            "fnServerData": function (sSource, aoData, fnCallback) {
                var serializeData = function (aoData) {
                    var data = {};
                    for (var i = 0; i < aoData.length; i++) {
                        var dd = aoData[i];
                        if (dd['value']) {
                            data[dd['name']] = dd['value'];
                        }
                    }
                    return $.param(data);
                };
                $.ajax({
                    "type": 'post',
                    "url": sSource,
                    "data": serializeData(aoData),
                    beforeSend: function () {
                    },
                    "success": function (resp) {
                        fnCallback(resp);
                        var total = $("td");
                        if (total.size() < 2 && searchFlag) {
                            window.wxc.xcConfirm("很抱歉，系统找不到您的记录，换个条件试试！", "info");
                        }
                        init();
                    }
                }).always(function () {
                });
            }
        });
    });

    //订单导出
    function orderExport() {
        var form = $("<form>");
        form.attr('style', 'display:none');
        form.attr('target', '_blank');
        form.attr('method', 'post');
        form.attr('action', "${ctx}/order/orderExport");

        var trdOrderState = $('<input>');
        trdOrderState.attr('type', 'hidden');
        trdOrderState.attr('name', 'trdOrderState');
        trdOrderState.attr('value', $("#trdOrderState").val());
        form.append(trdOrderState);

        var orderNo = $('<input>');
        orderNo.attr('type', 'hidden');
        orderNo.attr('name', 'orderNo');
        orderNo.attr('value', $("#orderNo").val());
        form.append(orderNo);

        var beginTime = $('<input>');
        beginTime.attr('type', 'hidden');
        beginTime.attr('name', 'beginTime');
        beginTime.attr('value', $("#beginTime").val());
        form.append(beginTime);

        var endTime = $('<input>');
        endTime.attr('type', 'hidden');
        endTime.attr('name', 'endTime');
        endTime.attr('value', $("#endTime").val());
        form.append(endTime);

        var storeId = $('<input>');
        storeId.attr('type', 'hidden');
        storeId.attr('name', 'storeId');
        storeId.attr('value', $("#storeId").val());
        form.append(storeId);

        $('body').append(form);
        form.submit();
    }

    //列表查询函数
    function search() {
        var beginTimeV = $("#beginTime").val();
        var endTimeV = $("#endTime").val();
        if (beginTimeV > endTimeV) {
            window.wxc.xcConfirm("开始时间不能大于结束时间", "error");
            return;
        }
        searchFlag = true;
        table.ajax.reload();
    }

    var load = new Loading();

    //显示立即加载中。。。
    var showLoading = function () {
        // $.mask_element('#main-containter');
        load.init();
        load.start();
    };
    //取消立即加载中。。。
    var hideLoading = function () {
        //  $.mask_close('#main-containter');
        load.stop();
    };

    function ajaxFunc(id, url) {
        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            data: {id: id},
            beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            hideLoading();
            if (data.status == "success") {
                window.wxc.xcConfirm(data.message, "success");
                table.ajax.reload();
            } else {
                window.wxc.xcConfirm("操作失败，原因：" + data.resultMessage, "error");
            }

        }).fail(function () {
            hideLoading();
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
            //移除 事件,最后执行
        });
    }

    /***增加物流**/
    function addLogistic(orderNo) {
        window.location.href = "${ctx}/order/addShipping?orderNo=" + orderNo;
    }

    /***物流编辑**/
    function editShipping(orderNo) {
        window.location.href = "${ctx}/order/editShipping?orderNo=" + orderNo;
    }

    /***订单详情**/
    function showOrderDetails(orderNo) {
        window.location.href = "${ctx}/order/orderDetailPage?orderNo=" + orderNo;
    }

    /***确认收货**/
    function confirmationReceipt(orderNo) {

        //先判断 是否是 15天的
        var datas = {"orderNo": orderNo};
        $.ajax({
            url: "${ctx}/order/checkOrderifAbove15Days",
            type: "POST",
            data: datas
        }).done(function (data) {
            if (data.success) {
                window.wxc.xcConfirm("温馨提示:是否确认收货?", "confirm", {
                    onOk: function () {
                        var orderNoList = new Array();
                        orderNoList.push(orderNo);
                        var datas = {"orderNo": orderNoList, "flag": "setSubOrderAccepted"};
                        $.ajax({
                            url: "${ctx}/order/batchWithOrders",
                            contentType: "application/json;charset=UTF-8",
                            type: "POST",
                            data: JSON.stringify(datas),
                            beforeSend: function () {
                                showLoading();
                            }
                        }).done(function (data) {
                            if (data.success) {
                                window.wxc.xcConfirm("处理成功。", "success");
                                search();
                                getCheckedout();
                            } else {
                                window.wxc.xcConfirm("异常，请联系管理员。", "error");
                                search();
                                getCheckedout();
                            }
                        }).fail(function () {
                            window.wxc.xcConfirm("异常，请联系管理员。", "error");
                        }).always(function () {
                            hideLoading();
                        });
                    }
                });
            } else {
                if (data.resultCode == "10500") {
                    window.wxc.xcConfirm("确认订单未超过15天，请确认订单超过15天后再试。", "error");
                }
            }
        }).fail(function () {
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        });
    }

    /***确认拒收**/
    function confirmationReject(orderNo) {
        var flag = false;
        //先判断 是否是 15天的
        var datas = {"orderNo": orderNo};
        $.ajax({
            url: "${ctx}/order/checkOrderifAbove15Days",
            type: "POST",
            data: datas
        }).done(function (data) {
            if (data.success) {
                window.wxc.xcConfirm("温馨提示:是否确认拒收?", "confirm", {
                    onOk: function () {
                        var orderNoList = new Array();
                        orderNoList.push(orderNo);
                        var datas = {"orderNo": orderNoList, "flag": "setSubOrderRejected"};
                        $.ajax({
                            url: "${ctx}/order/batchWithOrders",
                            contentType: "application/json;charset=UTF-8",
                            type: "POST",
                            data: JSON.stringify(datas),
                            beforeSend: function () {
                                showLoading();
                            }
                        }).done(function (data) {
                            if (data.success) {
                                window.wxc.xcConfirm("处理成功。", "success");
                                search();
                                getCheckedout();
                            } else {
                                window.wxc.xcConfirm("异常，请联系管理员。", "error");
                                search();
                                getCheckedout();
                            }
                        }).fail(function () {
                            window.wxc.xcConfirm("异常，请联系管理员。", "error");
                        }).always(function () {
                            hideLoading();
                        });
                    }
                })
            } else {
                if (data.resultCode == "10500") {
                    window.wxc.xcConfirm("确认订单未超过15天，请确认订单超过15天后再试。", "error");
                }
            }
        }).fail(function () {
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        });
    }

    /***确认订单**/
    function sureOrder(orderNo,data) {
        var msg="温馨提示:是否确认订单?";
        if (data!=null && data!=''&& data!=undefined && data=="是"){
             msg="温馨提示:该订单存在售后申请单，是否仍要确认订单？";
        }
        window.wxc.xcConfirm(msg, "confirm", {
            onOk: function () {
                var orderNoList = new Array();
                orderNoList.push(orderNo);
                var datas = {"orderNo": orderNoList, "flag": "setSubOrderSured"};
                $.ajax({
                    url: "${ctx}/order/batchWithOrders",
                    type: "POST",
                    contentType: "application/json;charset=UTF-8",
                    data: JSON.stringify(datas),
                    beforeSend: function () {
                        showLoading();
                    }
                }).done(function (data) {
                    if (data.success) {
                        window.wxc.xcConfirm("处理成功。", "success");
                        search();
                        getCheckedout();
                    } else {
                        window.wxc.xcConfirm("异常，请联系管理员。", "error");
                        search();
                        getCheckedout();
                    }
                }).fail(function () {
                    window.wxc.xcConfirm("异常，请联系管理员。", "error");
                }).always(function () {
                    hideLoading();
                });
            }
        })
    }

    /***取消订单**/
    function deniedOrder(orderNo, subOrderNo) {
        window.wxc.xcConfirm("温馨提示:是否要取消订单 " + orderNo + " ? 订单取消后，钱款将原路返还用户。", "confirm", {
            onOk: function () {
                var orderNoList = new Array();
                orderNoList.push(subOrderNo);
                var datas = {"orderNo": orderNoList, "flag": "setSubOrderDenied"};
                $.ajax({
                    url: "${ctx}/order/batchWithOrders",
                    type: "POST",
                    contentType: "application/json;charset=UTF-8",
                    data: JSON.stringify(datas),
                    beforeSend: function () {
                        showLoading();
                    }
                }).done(function (data) {
                    if (data.success) {
                        window.wxc.xcConfirm("处理成功。", "success");
                        search();
                        getCheckedout();
                    } else {
                        window.wxc.xcConfirm("异常，请联系管理员。", "error");
                        search();
                        getCheckedout();
                    }
                }).fail(function () {
                    window.wxc.xcConfirm("异常，请联系管理员。", "error");
                }).always(function () {
                    hideLoading();
                });
            }
        })
    }

    /***批量确认拒收**/
    function batchSureNagetiveOrders() {
        var $chkBox = $('tbody>tr');
        var $checkboxs = $chkBox.find('input[type="checkbox"]');
        var count = 0;
        var orderNoList = new Array();
        $checkboxs.each(function () {
            if ($(this).is(':checked')) {
                count++;
                var orderID = $(this).attr("subOrder-bind");
                orderNoList.push(orderID);
            }
        });
        if (count <= 0) {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            window.wxc.xcConfirm("温馨提示:是否确认拒收?", "confirm", {
                onOk: function () {
                    var datas = {"orderNo": orderNoList, "flag": "setSubOrderRejected"};
                    $.ajax({
                        url: "${ctx}/order/batchWithOrders",
                        type: "POST",
                        contentType: "application/json;charset=UTF-8",
                        data: JSON.stringify(datas),
                        beforeSend: function () {
                            showLoading();
                        }
                    }).done(function (data) {
                        if (data.success) {
                            if (data.result.failList.length == 0 && data.result.timeList.length == 0) {
                                window.wxc.xcConfirm("处理数据完毕", "success");
                            } else if (data.result.failList.length != 0 && data.result.timeList.length == 0) {
                                window.wxc.xcConfirm("处理数据失败", "error");
                            } else if (data.result.timeList.length != 0) {
                                window.wxc.xcConfirm("有确认订单未超过15天，请核对订单后再试", "error");
                            } else {
                                window.wxc.xcConfirm("处理数据完毕,已成功数量：" + data.result.sucList.length + ",已失败数量：" + data.result.failList.length, "warning");
                            }
                            search();
                            getCheckedout();
                        } else {
                            window.wxc.xcConfirm("异常，请联系管理员。问题原因:" + data.result, "error");
                        }
                    }).fail(function () {
                        window.wxc.xcConfirm("异常，请联系管理员。", "error");
                    }).always(function () {
                        hideLoading();
                    });
                }
            })
        }
    }

    /***批量确认收货**/
    function batchSureGetOrders() {
        var $chkBox = $('tbody>tr');
        var $checkboxs = $chkBox.find('input[type="checkbox"]');
        var count = 0;
        var orderNoList = new Array();
        $checkboxs.each(function () {
            if ($(this).is(':checked')) {
                count++;
                var orderID = $(this).attr("subOrder-bind");
                orderNoList.push(orderID);
            }
        });
        if (count <= 0) {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            window.wxc.xcConfirm("温馨提示:是否确认收货?", "confirm", {
                onOk: function () {
                    var datas = {"orderNo": orderNoList, "flag": "setSubOrderAccepted"};
                    $.ajax({
                        url: "${ctx}/order/batchWithOrders",
                        type: "POST",
                        contentType: "application/json;charset=UTF-8",
                        data: JSON.stringify(datas),
                        beforeSend: function () {
                            showLoading();
                        }
                    }).done(function (data) {
                        if (data.success) {
                            if (data.result.failList.length == 0 && data.result.timeList.length == 0) {
                                window.wxc.xcConfirm("处理数据完毕", "success");
                            } else if (data.result.failList.length != 0 && data.result.timeList.length == 0) {
                                window.wxc.xcConfirm("处理数据失败", "error");
                            } else if (data.result.timeList.length != 0) {
                                window.wxc.xcConfirm("有确认订单未超过15天，请核对订单后再试", "error");
                            } else {
                                window.wxc.xcConfirm("处理数据完毕,已成功数量：" + data.result.sucList.length + ",已失败数量：" + data.result.failList.length, "warning");
                            }
                            search();
                            getCheckedout();
                        } else {
                            window.wxc.xcConfirm("异常，请联系管理员。问题原因:" + data.result, "error");
                        }
                    }).fail(function () {
                        window.wxc.xcConfirm("异常，请联系管理员。", "error");
                    }).always(function () {
                        hideLoading();
                    });
                }
            })
        }
    }

    /*** 批量确认订单**/
    function batchSureOrders() {
        var $chkBox = $('tbody>tr');
        var $checkboxs = $chkBox.find('input[type="checkbox"]');
        //判断：所有单个商品是否勾选
        var count = 0;
        var orderNoList = new Array();
        $checkboxs.each(function () {
            if ($(this).is(':checked')) {
                count++;
                var orderID = $(this).attr("subOrder-bind");
                orderNoList.push(orderID);
            }
        });
        if (count <= 0) {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            window.wxc.xcConfirm("温馨提示:是否确认订单?", "confirm", {
                onOk: function () {
                    var datas = {"orderNo": orderNoList, "flag": "setSubOrderSured"};
                    $.ajax({
                        url: "${ctx}/order/batchWithOrders",
                        type: "POST",
                        contentType: "application/json;charset=UTF-8",
                        data: JSON.stringify(datas),
                        beforeSend: function () {
                            showLoading();
                        }
                    }).done(function (data) {
                        if (data.success) {
                            if (data.result.failList.length == 0) {
                                window.wxc.xcConfirm("处理数据完毕", "success");
                            } else if (data.result.sucList.length == 0) {
                                window.wxc.xcConfirm("处理数据失败", "error");
                            } else {
                                window.wxc.xcConfirm("处理数据完毕,已成功数量：" + data.result.sucList.length + ",已失败数量：" + data.result.failList.length, "warning");
                            }
                            search();
                            getCheckedout();
                        } else {
                            window.wxc.xcConfirm("异常，请联系管理员。问题原因:" + data.result, "error");
                        }
                    }).fail(function () {
                        window.wxc.xcConfirm("异常，请联系管理员。", "error");
                    }).always(function () {
                        hideLoading();
                    });
                }
            })
        }
    }

</script>
</html>
