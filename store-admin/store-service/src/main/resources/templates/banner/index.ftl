<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
<#include "../include/head.ftl" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
<#include "../include/top-menu.ftl"/>
    <!-- Left side column. contains the logo and sidebar -->
<#include "../include/left.ftl"/>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Banner管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/banner/list">Banner管理</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">


                    <div class="col-xs-12">
                        <form class="form-inline well" style="text-align: right">
                                <button type="button" class="btn" id="btn-advanced-add"
                                        onclick="addData('${ctx}/banner/edit')">
                                    <i class="fa fa-add"></i>新增Banner
                                </button>
                        </form>

                    <div class="box">
                        <div class="box-body">
                            <table id="bannerTable" style="text-align: center" class="table table-bordered table-striped">
                                <thead>
                                <tr >
                                    <th style="text-align: center">序号</th>
                                    <th style="text-align: center">名称</th>
                                    <th style="text-align: center">排序</th>
                                    <th style="text-align: center">操作</th>
                                </tr>
                                </thead>

                            </table>
                        </div>
                    </div>

            </div>
        </section>
    </div>



<#include "../include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "../include/resource.ftl"/>

<script>

    var table;

    $(function () {
        //  $('#permTable').DataTable();
        table= $('#bannerTable').DataTable({

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
            "bPaginate" : false,// 分页按钮
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
            "sAjaxSource" : "${ctx}/banner/list",
            //  "sScrollY": "100%",
            "fnInitComplete": function() {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams" : function(aoData) {

                aoData.push(

                );
            },
            "aoColumns" : [
                {"data" :  function(row, type, set, meta) {
                    var c = meta.settings._iDisplayStart + meta.row + 1;
                    return c;
                },"sWidth":"15%"},
                {"data" : "name" ,"sWidth":"50%"},
                {"data" : "showIndex","sWidth":"15%"}
            ],

            "aoColumnDefs":[
                {
                    "sClass":"center",
                    "aTargets":[3],
                    "data":"id",
                    "mRender":function(a,b,c,d){//id，c表示当前记录行对象
                            return '<a href=\"javascript:void(0);\" onclick=\"confirmDelete(\''+a+'\')\">删除</a>' +
                                    '&nbsp;&nbsp;&nbsp;&nbsp;'
                                    + '<a href=\"${ctx}/banner/edit?id='+a+'\" >修改</a>';

                    }
                }
            ],
            "fnRowCallback" : function(nRow, aData, iDisplayIndex) {//相当于对字段格式化

            },
            "createdRow": function ( row, data, index ) {

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
                    "data" :serializeData(aoData),
                    "success" : function(resp) {
                        fnCallback(resp);
                    }
                });
            }

        });

    });

    function search(){
        //table.draw();
        table.ajax.reload();
    }


    function addData(url){
        var total = $("tr");
        if(total.size()>=11){
            window.wxc.xcConfirm("当前banner总数已达上限！", "newCustom");
        }
        else {
            window.location.href = url;
        }
    }

    function confirmDelete(id){
        var total = $("tr");
        if(total.size()<3){
            window.wxc.xcConfirm("当前只有一个banner，无法删除！", "newCustom");
        }else{
            var url = "${ctx}/banner/delete";
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
                                window.wxc.xcConfirm(data.message, "success");
                                table.ajax.reload();
                            })
                            .fail(function () {
                                window.wxc.xcConfirm("异常，请联系管理员。", "error");
                            });
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);

        }
    }

</script>
</body>
</html>
