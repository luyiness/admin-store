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
                楼层模板管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/floortemplate/list">楼层模板管理</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well">
                        <span>名称:</span> <input type="text" class="form-control" placeholder="名称" id="name-search">
                        <div style="float: right;">
                            <button type="button" class="btn" id="btn-advanced-search" onclick="search()">
                                <i class="fa fa-search"></i>查询
                            </button>
                            <button style="width: 67px;" type="button" class="btn" id="btn-advanced-add" onclick="addData('${ctx}/floortemplate/edit')">
                                <i class="fa fa-add"></i>添加
                            </button>
                        </div>
                    </form>
                    <div class="box">
                        <div class="box-body">
                            <table style="text-align: center;" id="floorTemplateTable" class="table table-bordered table-striped">
                                <thead>
                                <tr>
                                    <th style="text-align: center;">序号</th>
                                    <th style="text-align: center;">名称</th>
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

    $(function () {
        //  $('#permTable').DataTable();
        table= $('#floorTemplateTable').DataTable({
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

            "bStateSave" : false,
            "bJQueryUI" : true,
            "bPaginate" : true,// 分页按钮
            "bFilter" : false,// 搜索栏
            "bLengthChange" : false,// 每行显示记录数
            "iDisplayLength" : 10,// 每页显示行数
            "bSort" : false,// 排序
            "bInfo" : true,// Showing 1 to 10 of 23 entries 总记录数没也显示多少等信息
            "bWidth" : true,
            "bScrollCollapse" : true,
            "sPaginationType" : "full_numbers", // 分页，一共两种样式 另一种为two_button // 是datatables默认
            //  "bProcessing" : true,
            "bServerSide" : true,
            "bDestroy" : true,
            "bSortCellsTop" : true,
            "sAjaxSource" : "${ctx}/floortemplate/list",
            //  "sScrollY": "100%",
            "fnInitComplete": function() {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams" : function(aoData) {

                aoData.push({
                            "name" : "name",
                            "value" : $("#name-search").val()
                        }
                );
            },
            "aoColumns" : [
                {"data" :  function(row, type, set, meta) {
                    var c = meta.settings._iDisplayStart + meta.row + 1;
                    return c;
                }},
                {"data" : "name"}
            ],
            "aoColumnDefs" : [
                {
                    "sClass":"center",
                    "aTargets":[2],
                    "data":"id",
                    "mRender":function(a,b,c,d){//id，c表示当前记录行对象
                        return '<a href=\"javascript:void(0);\" onclick=\"confirmDelete(\''+a+'\')\">删除</a>&nbsp;&nbsp;&nbsp;&nbsp;'
                                + '<a href=\"${ctx}/floortemplate/edit?id='+a+'\" >修改</a>';
                    }
                }
            ],
            "fnRowCallback" : function(nRow, aData, iDisplayIndex) {//相当于对字段格式化

            },

            "fnServerData" : function(sSource, aoData, fnCallback) {
                var serializeData = function(aoData){
                    var data = {};
                    for(var i = 0 ;i<aoData.length ;i++){
                        var dd = aoData[i];
                        if(dd['value']){
                            data[ dd['name'] ]= dd['value'];
                        }
                    }
                    return $.param(data);

                };

                $.ajax({
                    "type" : 'post',
                    "url" : sSource,
                    //"dataType" : "json",
                    ///"dataSrc": "data",
                    "data" :serializeData(aoData),
                    "success" : function(resp) {
                        fnCallback(resp);
                        var total = $("td");
                        if(total.size()<2 && searchFlag){
                            window.wxc.xcConfirm("很抱歉，系统找不到您的记录，换个条件试试！", "info");
                        }
                    }
                });
            }

        });

    });

    function search(){
        //table.draw();
        searchFlag=true;
        var name = trim($("#name-search").val());
        if(name==null || name==""){
            window.wxc.xcConfirm("请选择您的查询条件", "newCustom");
        }else{
            table.ajax.reload();
        }
    }


    function addData(url){
        window.location.href=url;
    }

    function confirmDelete(id){
        var url = "${ctx}/floortemplate/delete";
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
                            if (data.status == "success") {
                                window.wxc.xcConfirm(data.message, "success");
                                table.ajax.reload();
                            } else {
                                window.wxc.xcConfirm(data.message, "newCustom");
                            }
                        })
                        .fail(function () {
                            window.wxc.xcConfirm("异常，请联系管理员。", "error");
                            console.log("error");
                        });
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);

    }

    function trim(str){ //删除左右两端的空格
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }

</script>
</body>
</html>
