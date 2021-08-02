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
                楼层管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/floor/list">楼层管理</a></li>
            </ol>
        </section>
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well" style="text-align: right">

                            <button style="width:80px" type="button" class="btn" id="btn-advanced-add" onclick="addData()">
                                <i class="fa fa-add"></i>新增楼层
                            </button>

                        <button hidden style="width: 80px" type="button">
                            <i></i>
                        </button>
                    </form>
                    <div class="box">
                        <div class="box-body">
                            <table style="text-align: center;" id="floorTable" class="table table-bordered table-striped">
                                <thead>
                                <tr>
                                    <th style="text-align: center;">序号</th>
                                    <th style="text-align: center;">楼层名称</th>
                                    <th style="text-align: center;">楼层模板</th>
                                    <th style="text-align: center;">排列顺序</th>
                                    <th style="text-align: center;">是否禁用</th>
                                    <th style="text-align: center;">操作</th>
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
        <#--<button type="button" class="btn btn-info" id="btn-advanced-add" onclick="">-->
        <#--保存楼层-->
        <#--</button>-->
        <#--<button style="margin: 10px;" type="button" class="btn btn-info" id="btn-advanced-add" onclick="">-->
        <#--取消楼层-->
        <#--</button>-->

        </section>
        <!-- /.content -->
    </div>

    <div class="modal fade" id="modal-container-576495" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" >
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title" id="myModalLabel">
                        编辑楼层
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="box-body">
                        <div style="margin-left:40px;" class="form-group">
                            <label class="col-sm-3 control-label"><span class="text-red">*</span>楼层名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control"  id="name" name="name" required placeholder="楼层名称">
                            </div>
                        </div>
                        <br>
                        <br>
                        <div style="margin-left:40px;" class="form-group">
                            <label class="col-sm-3 control-label"><span class="text-red">*</span>楼层模板：</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="floorTemplateId" name="floorTemplateId" required>
                                    <option value="" selected="selected">请选择</option>
                                <#if temList??>
                                    <#list temList as floorTemplate>
                                        <option value="${floorTemplate.id}">${floorTemplate.name}</option>
                                    </#list>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <br>
                        <br>
                        <div style="margin-left:40px;" class="form-group">
                            <label class="col-sm-3 control-label"><span class="text-red">*</span>排列顺序：</label>
                            <div class="col-sm-6">
                                <input type="number" min="1" class="form-control" id="showIndex" name="showInde" required placeholder="0" >
                            </div>
                        </div>
                        <br>
                        <br>
                        <div style="margin-left:40px;" class="form-group">
                            <label class="col-sm-3 control-label"><span class="text-red">*</span>是否禁用：</label>
                            <div class="col-sm-6">
                                <select id="disable" name="disable" class="form-control" required>
                                    <#if floor??>
                                        <#if floor.isDisable??>
                                            <option value="false" <#if floor.isDisable>selected="selected"</#if>>否</option>
                                            <option value="true" <#if !floor.isDisable>selected="selected"</#if>>是</option>
                                        </#if>
                                        <#else>
                                            <option value="false" selected="selected">否</option>
                                            <option value="true">是</option>
                                    </#if>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="saveUpdate" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

<#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>

<script>

    var isClickSubmit =false;
    var table;
    var total;
    $(function () {
        //  $('#permTable').DataTable();
        table = $('#floorTable').DataTable({
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
            "iDisplayLength": 11,// 每页显示行数
            "bSort": false,// 排序
            "bInfo": true,// Showing 1 to 10 of 23 entries 总记录数没也显示多少等信息
            "bWidth": true,
            "bScrollCollapse": true,
            "sPaginationType": "full_numbers", // 分页，一共两种样式 另一种为two_button // 是datatables默认
            //  "bProcessing" : true,
            "bServerSide": true,
            "bDestroy": true,
            "bSortCellsTop": true,
            "sAjaxSource": "${ctx}/floor/list",
            //  "sScrollY": "100%",
            "fnInitComplete": function () {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams": function (aoData) {

            },
            "aoColumns": [
                {
                    "data": function (row, type, set, meta) {
                        var c = meta.settings._iDisplayStart + meta.row + 1;
                        return c;
                    }
                },
                {"data": "name"},
                {"data": "floorTemplate.name"},
                {"data": "showIndex"},
                {
                    "data": function (row, type, set, meta) {
                        var display = row.disable;
                        if (display) {
                            display = "是";
                        } else {
                            display = "否";
                        }
                        return display;
                    }
                }
            ],
            "aoColumnDefs": [
                {
                    "sClass": "center",
                    "aTargets": [5],
                    "data": "id",
                    "mRender": function (a, b, c, d) {//id，c表示当前记录行对象
                        if (total <= 1) {
                            return '<a href=\"javascript:void(0);\" onclick=\"updateRow(\'' + a + '\')\">编辑</a>'

                        } else {
                            return '<a href=\"javascript:void(0);\" onclick=\"updateRow(\'' + a + '\')\">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;' +
                                    '<a class=\"deleteClass\" name=\"delName\" href=\"javascript:void(0);\" onclick=\"delRow(\'' + a + '\')\">删除</a>'
                        }
                    }
                }
            ],
            "fnRowCallback": function (nRow, aData, iDisplayIndex) {//相当于对字段格式化
            },

            "fnServerData": function (sSource, aoData, fnCallback) {
                $("#floorTable_paginate").css("display", "none");
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
                        total = resp.iTotalRecords;
                        isLength();
                        fnCallback(resp);
                    }
                });
            }

        });
    });


    //判断数据是否超过10条
    function isLength() {
        if (total < 10) {
            $("#btn-advanced-add").attr("disabled", false);
            return true;
        } else {
            $("#btn-advanced-add").attr("disabled", true);
            return false;
        }
    }

    //添加楼层数据
    function addData() {
        var flag = isLength();
        if (flag) {
            $("#name").val("");
            $("#floorTemplateId").val($("#floorTemplateId option:eq(0)").val());
            $("#showIndex").val("");
            $("#disable").get(0).value = "false";
            saveId = "";
            $("#modal-container-576495").modal("toggle");
        }
    }

    var saveId = "";
    //编辑楼层数据
    function updateRow(id) {
        $.post("${ctx}/floor/queryID", {"id": id}, function (data) {
            $("#name").val(data.floor.name);
            $("#floorTemplateId").val(data.floorTemplate.id);
            $("#showIndex").val(data.floor.showIndex);
            $("#disable").get(0).value = data.floor.disable;
            saveId = id;
            $("#modal-container-576495").modal("toggle");
        }, "json");
    }

    $("#saveUpdate").click(function () {
        if(!isClickSubmit) {
            saveUpdate();
        }
    });

    //保存楼层信息
    function saveUpdate() {
        var name = $("#name").val();
        var floorTemplateId = $("#floorTemplateId").val();
        var showIndex = $("#showIndex").val();
        var disable = $("#disable").val();
        if (name != "" && floorTemplateId != "" && showIndex != "" && disable != "") {
            if (floorNamePattern(name)) {
                if (showIndexPattern(showIndex)) {
                    isClickSubmit =true;
                    $.post("${ctx}/floor/save", {
                                "id": saveId,
                                "name": name,
                                "floorTemplateId": floorTemplateId,
                                "showIndex": showIndex,
                                "disable": disable
                            },
                            function (data) {
                                var txt = data.message;
                                var flag = 0;
                                var option = {
                                    onOk: function () {
                                        flag = 1;
                                        table.ajax.reload();
                                    }
                                }
                                isClickSubmit =false;
                                if (data.status == "success") {
                                    window.wxc.xcConfirm(txt, "success", option);
                                } else {
                                    window.wxc.xcConfirm(txt, "error");
                                    return;
                                }

                                setTimeout(function () {
                                    if (flag == 0) {
                                        window.location.href = "${ctx}/floor/list";
                                    }
                                }, 5000);
                                $("#modal-container-576495").modal("toggle");
                            }, "json");
                } else {
                    window.wxc.xcConfirm("排列顺序必须为正整数！", "newCustom");
                }
            } else {
                window.wxc.xcConfirm("只可以录入英文字母或者中文或者数字", "newCustom");
            }
        } else {
            window.wxc.xcConfirm("数据不能为空", "newCustom");
        }
    }

    function floorNamePattern(floorName) {
        var pattern =
                /^[A-Za-z0-9\u4e00-\u9fa5]+$/;
        flag = pattern.test(floorName);
        return flag;
    }

    function showIndexPattern(showIndex) {
        var pattern = /^[1-9]*[1-9][0-9]*$/;
        flag = pattern.test(showIndex);
        return flag;
    }
    //删除楼层信息
    function delRow(id) {
        var delName = document.getElementsByName("delName");
        if (delName.length > 1) {
            deleteAjax(id);
        }
    }

    //删除楼层调用的ajax
    function deleteAjax(id) {
        var url = "${ctx}/floor/delete";
        var tipTxt = "温馨提示:删除后无法恢复，是否确定删除？";
        var option = {
            onOk: function () {
                $.ajax({
                    url: url,
                    type: 'POST',
                    dataType: 'json',
                    data: {id: id},
                })
                        .done(function (data) {
                            var txt = data.message;
                            var flag = 0;
                            var option = {
                                onOk: function () {
                                    flag = 1;
                                    table.ajax.reload();
                                }
                            }

                            if (data.status == "success") {
                                window.wxc.xcConfirm(txt, "success", option);
                            } else {
                                window.wxc.xcConfirm(txt, "newCustom", option);
                            }

                            setTimeout(function () {
                                if (flag == 0) {
                                    <#--window.location.href = "${ctx}/floor/list";-->
                                    table.ajax.reload();
                                }
                            }, 5000);
                        })
                        .fail(function () {
                            window.wxc.xcConfirm("异常，请联系管理员。", "error");
                            console.log("error");
                        });
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }
</script>
</body>
</html>
