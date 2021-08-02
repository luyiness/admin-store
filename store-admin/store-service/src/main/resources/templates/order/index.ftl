<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
<#include "/include/head.ftl" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
<#include "/include/top-menu.ftl"/>
    <!-- Left side column. contains the logo and sidebar -->
<#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                订单管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/order/list">订单管理</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form  action="${ctx}/order/outOrder" class="form-inline well" method="get">
                        <div class="form-group">
                            <label>所属机构:</label>
                            <div class="radio-inline" style="cursor: default;"><#if company??>${company.name}</#if></div>
                            <#--<select id="oneId" name="coreuserId_1" style="width: 150px;" class="form-control">-->
                                <#--<option value="" selected="selected">请选择</option>-->
                            <#--</select>-->
                            <#--<select id="twoId" name="coreuserId_2" style="width: 150px;" class="form-control">-->
                                <#--<option value="" selected="selected">请选择</option>-->
                            <#--</select>-->
                            <#--<select id="threeId" name="coreuserId_3" style="width: 150px;" class="form-control">-->
                                <#--<option value="" selected="selected">请选择</option>-->
                            <#--</select>-->
                        </div>
                        <div class="form-group" style="margin-left: 50px;">
                            <label>店铺名称:</label>
                            <div class="radio-inline" style="cursor: default;"><#if (store.storeExt)??>${store.storeExt.storeName}</#if></div>
                        </div>
                        <div class="form-group" style="margin-left: 50px;">
                            <label>订单状态:</label>
                            <select style="width: 120px;" id="status" name="status" class="form-control">
                                <option value="" selected="selected">请选择</option>
                                <option value="1">待付款</option>
                                <option value="2">未发货</option>
                                <option value="3">待收货</option>
                                <option value="4">待评价</option>
                                <option value="5">已完成</option>
                                <option value="6">已取消</option>
                            </select>
                        </div>
                        <#--<div class="form-group" style="margin-left: 10px;">-->
                            <#--<label>店铺:</label>-->
                            <#--<select style="width: 150px;" id="storeId" name="storeId" class="form-control">-->
                                <#--<option value="" selected="selected">全部</option>-->
                            <#--<#if list??>-->
                                <#--<#list list as store>-->
                                    <#--<option value="${store.id}">${store.storeExt.storeName}</option>-->
                                <#--</#list>-->
                            <#--</#if>-->
                            <#--</select>-->
                        <#--</div>-->

                        <div style="margin-top: 10px;">
                            <div class="form-group">
                                <label>订单号:</label>
                                <input type="text" id="orderNo" name="orderNo" style="width: 150px;"
                                       class="form-control" placeholder="订单号"
                                       id="title-search">
                            </div>
                            <div class="form-group">
                                <label>下单人:</label>
                                <input type="text" id="memberId" name="memberId" style="width: 130px;"
                                       class="form-control" placeholder="下单人"
                                       id="title-search">
                            </div>
                            <!-- Date -->
                            <div style="margin-left:8px" class="form-group">
                                <label>下单日期:</label>
                                <div class="input-group date">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <input name="startTime" style="width: 130px;" type="text" placeholder="请选择起始日期"
                                           class="form-control pull-right"
                                           id="startDate-search">
                                </div>
                                <!-- /.input group -->

                                <label>-</label>
                                <div class="input-group date">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <input name="endTime" style="width: 130px;" type="text" placeholder="请选择终止日期"
                                           class="form-control pull-right"
                                           id="endDate-search">
                                </div>
                            </div>
                            <div style="float: right">
                                <button type="button" class="btn" id="btn-advanced-search" onclick="search()">
                                    <i class="fa fa-search"></i>查询
                                </button>
                                <button type="submit" class="btn" id="btn-advanced-add">
                                    <i class="fa fa-add"></i>导出
                                </button>
                            </div>
                        </div>
                    </form>
                    <div class="box">

                        <div class="box-body">
                            <table style="text-align: center;" id="permTable"
                                   class="table table-bordered table-striped">
                                <thead>
                                <tr>
                                    <th style="text-align: center;">序号</th>
                                    <#--<th style="text-align: center;">一级机构</th>-->
                                    <#--<th style="text-align: center;">二级机构</th>-->
                                    <#--<th style="text-align: center;">三级机构</th>-->
                                    <th style="text-align: center;">下单人</th>
                                    <th style="text-align: center;">订单号</th>
                                    <#--<th style="text-align: center;">店铺</th>-->
                                    <th style="text-align: center;">下单日期</th>
                                    <th style="text-align: center;">订单金额</th>
                                    <th style="text-align: center;">订单状态</th>
                                    <th style="text-align: center;">确认收货时间</th>
                                    <th style="text-align: center;">是否开立发票</th>
                                    <th style="text-align: center;width: 5%">操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
    </div>
    <!-- /.row -->
    </section>
    <!-- /.content -->
</div>


<#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>

<script>

    var table;
    var searchFlag = false;
    var obj;
    $(function () {

        //  $('#permTable').DataTable();
        table = $('#permTable').DataTable({
//           "sPaginationType" : "full_numbers",//设置分页控件的模式
//            "bPaginate": true, //翻页功能
//            "bLengthChange": false, //改变每页显示数据数量
//            "bFilter": false, //过滤功能
//            "bSort": false, //排序功能
//            "bInfo": true,//页脚信息
//            "bAutoWidth": true,//自动宽度
//            "stateSave":true,//设置缓存页页码数据
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
            //  "bProcessing" : true,
            "bServerSide": true,
            "bDestroy": true,
            "bSortCellsTop": true,
            "sAjaxSource": "${ctx}/order/list",
            //  "sScrollY": "100%",
            "fnInitComplete": function () {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams": function (aoData) {

                aoData.push({
                            "name": "orderNo",
                            "value": $("#orderNo").val()
                        },
//                        {
//                            "name": "coreuserId_1",
//                            "value": $("#oneId").val()
//                        },
//                        {
//                            "name": "coreuserId_2",
//                            "value": $("#twoId").val()
//                        },
//                        {
//                            "name": "coreuserId_3",
//                            "value": $("#threeId").val()
//                        },
                        {
                            "name": "status",
                            "value": $("#status").val()
                        },
//                        {
//                            "name": "storeId",
//                            "value": $("#storeId").val()
//                        },
                        {
                            "name": "memberId",
                            "value": $("#memberId").val()
                        },
                        {
                            "name": "startTime",
                            "value": encodeURI($("#startDate-search").val())
                        },
                        {
                            "name": "endTime",
                            "value": encodeURI($("#endDate-search").val())
                        }
                );
            },
            "aoColumns": [
                {
                    "data": function (row, type, set, meta) {
                        var c = meta.settings._iDisplayStart + meta.row + 1;
                        return c;
                    }
                },
//                {
//                    "data": function (row, type, set, meta) {
//                        var publishDate = row.NAME_1;
//                        if (publishDate != undefined && publishDate != null && publishDate != "") {
//                            return publishDate;
//                        } else {
//                            return "";
//                        }
//                    }
//                },
//                {
//                    "data": function (row, type, set, meta) {
//                        var publishDate = row.NAME_2;
//                        if (publishDate != undefined && publishDate != null && publishDate != "") {
//                            return publishDate;
//                        } else {
//                            return "";
//                        }
//                    }
//                },
//                {
//                    "data": function (row, type, set, meta) {
//                        var publishDate = row.NAME_3;
//                        if (publishDate != undefined && publishDate != null && publishDate != "") {
//                            return publishDate;
//                        } else {
//                            return "";
//                        }
//                    }
//                },
                {
                    "data": function (row, type, set, meta) {
                        var publishDate = row.REAL_NAME;
                        if (publishDate != undefined && publishDate != null && publishDate != "") {
                            return publishDate;
                        } else {
                            return "";
                        }
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var publishDate = row.ORDER_NO;
                        if (publishDate != undefined && publishDate != null && publishDate != "") {
                            return publishDate;
                        } else {
                            return "";
                        }
                    }
                },
//                {
//                    "data": function (row, type, set, meta) {
//                        var publishDate = row.STORE_NAME;
//                        if (publishDate != undefined && publishDate != null && publishDate != "") {
//                            return publishDate;
//                        } else {
//                            return "";
//                        }
//                    }
//                },
                {
                    "data": function (row, type, set, meta) {
                        var publishDate = row.CREATE_TIME;
                        if (publishDate != undefined && publishDate != null && publishDate != "") {
                            publishDate = timeFormat(publishDate);
                        } else {
                            publishDate = "";
                        }
                        return publishDate;
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var publishDate = row.SUM_PRICE;
                        if (publishDate != undefined && publishDate != null && publishDate != "") {
                            return publishDate;
                        } else {
                            return "";
                        }
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var isDisable = "";
                        if (row.STATUS != undefined && row.STATUS != null && row.STATUS != "") {
                            if (row.STATUS == "1") {
                                isDisable = "待付款";
                            } else if (row.STATUS == "2") {
                                isDisable = "未发货";
                            } else if (row.STATUS == "3") {
                                isDisable = "待收货";
                            } else if (row.STATUS == "4") {
                                isDisable = "待评价";
                            } else if (row.STATUS == "5") {
                                isDisable = "已完成";
                            } else if (row.STATUS == "6") {
                                isDisable = "已取消";
                            }
                        }
                        return isDisable;
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var publishDate = row.FINISHED_TIME;
                        if (publishDate != undefined && publishDate != null && publishDate != "") {
                            publishDate = timeFormat(publishDate);
                        } else {
                            publishDate = "";
                        }
                        return publishDate;
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var isDisable = "";
                        if (row.IS_SETUP != undefined && row.IS_SETUP != null && row.IS_SETUP != "") {
                            if (row.IS_SETUP == true) {
                                isDisable = "是";
                            } else {
                                isDisable = "否";
                            }
                        }
                        return isDisable;
                    }
                }],

            "aoColumnDefs": [
//                { "sWidth": "5%",  'sClass': "text-center", "aTargets": [ 0 ] },
//                { "sWidth": "7%",  'sClass': "text-center", "aTargets": [ 1 ] },
//                { "sWidth": "7%",  'sClass': "text-center", "aTargets": [ 2 ] },
//                { "sWidth": "7%",  'sClass': "text-center", "aTargets": [ 3 ] },
//                { "sWidth": "10%",  'sClass': "text-center", "aTargets": [ 4 ] },
//                { "sWidth": "10%",  'sClass': "text-center", "aTargets": [ 5 ] },
//                { "sWidth": "10%",  'sClass': "text-center", "aTargets": [ 6 ] },
//                { "sWidth": "10%",  'sClass': "text-center", "aTargets": [ 7 ] },
//                { "sWidth": "5%",  'sClass': "text-center", "aTargets": [ 8 ] },
//                { "sWidth": "5%",  'sClass': "text-center", "aTargets": [ 9 ] },
//                { "sWidth": "7%",  'sClass': "text-center", "aTargets": [ 10 ] },
//                { "sWidth": "7%",  'sClass': "text-center", "aTargets": [ 11 ] },
                {
                    "sClass": "center",
//                    "sWidth": "0.1%",
                    "aTargets": [8],
                    "data": "ID",
                    "mRender": function (a, b, c, d) {//id，c表示当前记录行对象
                        return '<a href=\"${ctx}/order/orderDetail?orderNo=' + c.ORDER_NO + '\" >查看</a>';
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
                    "success": function (resp) {
                        fnCallback(resp);
                        var total = $("td");
                        if (total.size() < 2 && searchFlag) {
                            window.wxc.xcConfirm("很抱歉，系统找不到您的记录，请换个条件试试！", "info");
                        }
                    }
                });
            }

        });

        //获取层级信息
        <#--$.post("${ctx}/order/coreCompany", function (data) {-->
            <#--obj = JSON.parse(data);//由JSON字符串转换为JSON对象-->
            <#--$("#oneId").html("");-->
            <#--var strOne = "<option value=\"\" selected=\"selected\">请选择</option>";-->
            <#--for (var i = 0; i < obj.length; i++) {-->
                <#--if (obj[i].companyLevel == 1) {-->
                    <#--strOne += "<option value=" + obj[i].id + ">" + obj[i].name + "</option>";-->
                <#--}-->
            <#--}-->
            <#--$("#twoId").html("<option value=\"\" selected=\"selected\">请选择</option>");-->
            <#--$("#threeId").html("<option value=\"\" selected=\"selected\">请选择</option>");-->
            <#--$("#oneId").html(strOne);-->
        <#--}, "json");-->
    });


    //集团级选中事件
//    $("#oneId").change(function () {
//        var oneId = $("#oneId").val();
//        $("#twoId").html("");
//        var strTwo = "<option value=\"\" selected=\"selected\">请选择</option>";
//        for (var i = 0; i < obj.length; i++) {
//            if (obj[i].companyLevel == 2 && oneId == obj[i].parent.id) {
//                strTwo += "<option value=" + obj[i].id + ">" + obj[i].name + "</option>";
//            }
//        }
//        $("#threeId").html("<option value=\"\" selected=\"selected\">请选择</option>");
//        $("#twoId").html(strTwo);
//    });

    //公司级选中事件
//    $("#twoId").change(function () {
//        var twoId = $("#twoId").val();
//        $("#threeId").html("");
//        var strThree = "<option value=\"\" selected=\"selected\">请选择</option>";
//        for (var i = 0; i < obj.length; i++) {
//            if (obj[i].companyLevel == 3 && twoId == obj[i].parent.id) {
//                strThree += "<option value=" + obj[i].id + ">" + obj[i].name + "</option>";
//            }
//        }
//        $("#threeId").html(strThree);
//    });

    //列表查询函数
    function search() {
        searchFlag = true;
        var startDate = $("#startDate-search").val().trim();
        var endDate = $("#endDate-search").val().trim();

        if ((startDate == "" && endDate != "") || (startDate != "" && endDate == "")) {
            window.wxc.xcConfirm("日期不能为空", "newCustom");
        } else if ((startDate != "" && endDate != "")) {
            var flag = judgeDate(endDate, startDate);
            if (flag) {
                table.ajax.reload();
            } else {
                window.wxc.xcConfirm("开始日期不能大于结束日期", "newCustom");
            }
        }else{
            table.ajax.reload();
        }

    }

    //Date picker
    $('#startDate-search').datepicker({
        format: 'yyyy-mm-dd',
        language: 'cn',
        autoclose: true
    });

    //Date picker
    $('#endDate-search').datepicker({
        format: 'yyyy-mm-dd',
        language: 'cn',
        autoclose: true
    });

    //判断两个日期的大小
    function judgeDate(date1, date2) {
        var oDate1 = new Date(date1);
        var oDate2 = new Date(date2);
        if (oDate1.getTime() >= oDate2.getTime()) {
            return true;
        } else {
            return false;
        }
    }

    //格式化时间
    function timeFormat(timeStr) {
        var dateStr = new Date(timeStr);
        var year = dateStr.getFullYear();
        var month = (dateStr.getMonth() + 1) < 10 ? "0" + (dateStr.getMonth() + 1) : (dateStr.getMonth() + 1);
        var day = (dateStr.getDate()) < 10 ? "0" + (dateStr.getDate()) : (dateStr.getDate());
        var hour = (dateStr.getHours()) < 10 ? "0" + (dateStr.getHours()) : (dateStr.getHours());
        var minute = (dateStr.getMinutes()) < 10 ? "0" + (dateStr.getMinutes()) : (dateStr.getMinutes());
        var second = (dateStr.getSeconds()) < 10 ? "0" + (dateStr.getSeconds()) : (dateStr.getSeconds());
        timeStr = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
        return timeStr;
    }

    //导出数据
    function outData() {
        $.ajax({
            "type": 'get',
            "url": "${ctx}/order/outOrder",
            dataType: "application/vnd.ms-excel",   //ajax 返回 文件 类型
            "data":{"orderNo":$("#orderNo").val(),
//                "coreuserId_1":$("#oneId").val(),
//                "coreuserId_2":$("#twoId").val(),
//                "coreuserId_3":$("#threeId").val(),
                "status":$("#status").val(),
//                "storeId":$("#storeId").val(),
                "memberId":$("#memberId").val(),
                "startTime":encodeURI($("#startDate-search").val()),
                "endTime":encodeURI($("#endDate-search").val())
            },
            "success": function (resp) {
                <#--window.open("${ctx}/order/outOrdert","_blank");-->
                window.wxc.xcConfirm("导出数据成功！", "info", window.wxc.xcConfirm.btnEnum.ok);
            }
        });
    }

</script>
</body>
</html>
