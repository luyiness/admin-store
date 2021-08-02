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
                用户名管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="#">用户名管理</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">用户名管理</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form enctype="multipart/form-data" class="form-horizontal" id="editForm" action="${ctx}/username/update" method="post">

                            <div class="box-body">
                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>原用户名：</label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" value="${user.username}" name="username" minlength="6"  maxlength="16"
                                                disabled="disabled">
                                    </div>
                                </div>

                            </div>

                            <div class="box-body">
                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>新用户名：</label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" id="newUsername" name="name" minlength="6"  maxlength="16"
                                                required placeholder="新用户名">
                                    </div>
                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <button id="register" onclick="submitCheck()" type="button" class="btn btn-info pull-right">保存</button>
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
<script type="text/javascript">

    function submitCheck() {
        var reg1 = /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/;
        var newUsername = $("#newUsername").val();
        if(newUsername==null || newUsername==""){
            window.wxc.xcConfirm("新用户名不能为空", "newCustom");
        }else if(!reg1.test(newUsername)){
            window.wxc.xcConfirm("新用户名不合法！(字母开头，允许6-16字节，允许字母数字下划线)", "newCustom");
            return false;
        }else{
            $.ajax({
                type: 'POST',
                url: "/username/update" ,
                data:{
                    "newUsername" : newUsername
                },
                success: function (data) {
                    if(data.status=="error"){
                        window.wxc.xcConfirm(data.message, "error");
                    }else{
                        var option = {
                            onOk: function () {
                                window.location.href = "${ctx}/username/";
                            }
                        }
                        window.wxc.xcConfirm("用户名修改成功。", "success", option);
                        setTimeout(function () {
                            window.location.href = "${ctx}/username/";
                        }, 5000);
                    }
                },
                error:function (data) {
                    window.wxc.xcConfirm("异常，请联系管理员。", "error");
                }
            });
        }
    }

</script>
</body>
</html>
