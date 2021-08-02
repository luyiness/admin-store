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
                商品管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/goods/list">商品管理</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well">
                        <div class="form-group" style="margin-right: 25px;">
                            <label>店铺名称:</label>
                            <div class="checkbox-inline" style= "cursor:default"><#if (store.storeExt)??>${(store.storeExt.storeName)!}</#if></div>
                        </div>
                        <div class="form-group" style="margin-right: 25px;">
                            <label>店铺层级:</label>
                            <div class="checkbox-inline" style= "cursor:default"><#if (store.storeExt)??><#if (store.storeExt.storeHierarchy) == 1>集团级<#elseif store.storeExt.storeHierarchy == 2>公司级<#else>二级机构</#if></#if></div>
                        </div>
                        <div class="form-group" style="margin-right: 25px;">
                        <label>商品名称:</label> <input type="text" class="form-control" placeholder="商品名称" id="goods_name" name="goods_name">
                        </div>
                        <div class="form-group" style="margin-right: 10px;">
                            <label>商品状态:</label>
                            <select style="width: 120px;" class="form-control" id="goods_state" name="goods_state" placeholder="集团级公告">
                                <option selected = "selected" value="2">全部</option>
                                <option value="1">已上架</option>
                                <option value="0">已下架</option>
                            </select>
                        </div>

                        <div style="float: right">
                        <button type="button" style="float: right" class="btn" id="btn-advanced-search" onclick="search()">
                            <i class="fa fa-search"></i>查询
                        </button>
                         </div>
                    </form>
                    <div class="box">

                        <div class="box-body">
                            <table id="permTable" class="table table-bordered table-striped">
                                <thead>
                                <tr>
                                    <th style="width: 72px;">序号</th>
                                    <#--<th style="width: 100px;">商品分类</th>-->
                                    <th style="text-align:center;">商品名称</th>
                                    <th style="width: 88px;">状态</th>
                                    <th style="width: 88px;text-align: center;">操作</th>
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
    var searchFlag=false;

    $(function () {
      //  $('#permTable').DataTable();
       table= $('#permTable').DataTable({
//           "sPaginationType" : "full_numbers",//设置分页控件的模式
//            "bPaginate": true, //翻页功能
//            "bLengthChange": false, //改变每页显示数据数量
//            "bFilter": false, //过滤功能
//            "bSort": false, //排序功能
//            "bInfo": true,//页脚信息
//            "bAutoWidth": true,//自动宽度
//            "stateSave":true,//设置缓存页页码数据
//            "sScrollX": "100%",
//            "sScrollXInner": "110%",
//            "bScrollCollapse": true,
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
           "sAjaxSource" : "${ctx}/goods/list",
          //  "sScrollY": "100%",
           "fnInitComplete": function() {
               this.fnAdjustColumnSizing(true);
           },
           "fnServerParams" : function(aoData) {
               aoData.push({
                   "name" : "goods_name",
                   "value" : $("#goods_name").val()
               },{
                   "name" : "goods_state",
                   "value" : $("#goods_state").val()
               }
               );
           },
           "aoColumns" : [
               {"data" :  function(row, type, set, meta) {
                    var c = meta.settings._iDisplayStart + meta.row + 1;
                    return c;
                }},
//               {"data" : "goods_category"},
               {"data" : "name"},
               {"data" :  function(row, type, set, meta) {
                   var goods_state="";
                   if(row.state==1){
                       goods_state ="已上架";
                   }else{
                       goods_state ="已下架";
                   }
                   return goods_state;
               }}],
           "aoColumnDefs":[
               {'sClass':"text-center", "aTargets": [ 0 ] },
               {"aTargets": [ 1 ] },
               {"sClass":"text-center", "aTargets": [ 2 ] },
               {
                   "aTargets":[3],
                   "sClass":"text-center",
                   "data":"id",
                   "mRender":function(a,b,c,d){//id，c表示当前记录行对象
                       if(c.state=="1"){
                           return '<a href=\"javascript:void(0);\" onclick=\"upGoods(\'' + a + '\')\">下架</a>';
                       }else{
                           return '<a href=\"javascript:void(0);\" onclick=\"downGoods(\'' + a + '\')\">上架</a>';
                       }
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
    $(function () {
        $("[name='store_level']").attr("checked",'true');//全选
    });

    //列表查询函数
    function search(){
        searchFlag=true;
        table.ajax.reload();
    }


    //上架提醒
    function upGoods(id) {
        var url = "${ctx}/goods/updategoods";
        var tipTxt = "温馨提示:是否确认将该商品下架？";
        var option = {
            onOk: function () {
                ajaxFunc(id,url);
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }

    //下架提醒
    function downGoods(id) {
        var url = "${ctx}/goods/updategoods";
        var tipTxt = "温馨提示:是否确认将该商品上架？";
        var option = {
            title: "提示",
            btn: parseInt("0011", 2),
            onOk: function () {
                ajaxFunc(id,url);
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }

    function ajaxFunc(id,url) {
        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            data: {id: id},
        }).done(function (data) {
            if (data.status == "success") {
                window.wxc.xcConfirm(data.message, "success");
                table.ajax.reload();
            }}).fail(function () {
                window.wxc.xcConfirm("异常，请联系管理员。", "error");
                console.log("error");
            });
    }
</script>
</body>
</html>
