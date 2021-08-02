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
                <li ><a href="${ctx}/floortemplate/list">楼层模板管理</a></li>
                <li class="active"><a href="#">编辑楼层模板</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">编辑楼层模板</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form class="form-horizontal" action="${ctx}/floortemplate/update" method="post" id="formId">
                            <input type="hidden" name="id" value="${floorTemplate.id!}"/>
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>名称</label>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control"  name="name" value="${floorTemplate.name!}"  required placeholder="名称">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputPassword3" class="col-sm-2 control-label"><span class="text-red">*</span>模板内容</label>
                                    <div class="col-sm-6">
                                        <textarea class="form-control" name="templateContent" rows="6" cols="80" required placeholder="请在此填写模板内容">${floorTemplate.templateContent!}</textarea>
                                    </div>
                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-default" onclick="cancel('${ctx}/floortemplate/list')">取消</button>
                                <button type="submit" class="btn btn-info pull-right">保存</button>
                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                </div>
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
    function cancel(url){
        window.location.href=url;
    }

    //调用
    $(document).ready(function(){
        $('#formId').bind('submit', function(){
            ajaxSubmit(this, function(data){
                if (data.status == "success") {
                    var url="${ctx}/floortemplate/list";
                    var txt=  data.message;
                    var option = {
                        onOk: function(){
                            goToNewuRL(url);
                        }
                    }
                    window.wxc.xcConfirm(txt, "success", option);
                    setTimeout(function () {
                        goToNewuRL(url);
                    }, 5000);
                }
            });
            return false;
        });
    });

    function goToNewuRL(url){
        window.location.href=url;
    }

    //将form转为AJAX提交
    function ajaxSubmit(frm, fn) {
        var dataPara = getFormJson(frm);
        $.ajax({
            url: frm.action,
            type: frm.method,
            data: dataPara,
            success: fn
        });
    }

    //将form中的值转换为键值对。
    function getFormJson(frm) {
        var o = {};
        var a = $(frm).serializeArray();
        $.each(a, function () {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });

        return o;
    }
</script>
</body>
</html>
