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
                密码管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="#">密码管理</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">密码管理</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form enctype="multipart/form-data" class="form-horizontal" id="editForm" action="${ctx}/banner/update" method="post">
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>旧密码：</label>
                                    <div class="col-sm-5">
                                        <input type="password" class="form-control" id="oldPassword" name="name"
                                                required placeholder="旧密码" minlength="6" maxlength="16">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>新密码：</label>
                                    <div class="col-sm-5">
                                        <input type="password" class="form-control" id="newPassword" name="name"
                                                required placeholder="新密码" minlength="6" maxlength="16">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>确认新密码：</label>
                                    <div class="col-sm-5">
                                        <input type="password" class="form-control" id="confirmPassword" name="name"
                                                required placeholder="确认新密码" minlength="6" maxlength="16">
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
        var oldPassword = $("#oldPassword").val();
        var newPassword = $("#newPassword").val();
        var confirmPassword = $("#confirmPassword").val();
        if(oldPassword==null || oldPassword==""){
            window.wxc.xcConfirm("旧密码不能为空", "newCustom");
        }else if(newPassword==null || newPassword==""){
            window.wxc.xcConfirm("新密码不能为空", "newCustom");
        }else if(confirmPassword==null || confirmPassword==""){
            window.wxc.xcConfirm("确认密码不能为空", "newCustom");
        }else if(newPassword.length<6){
            window.wxc.xcConfirm("新密码至少为6位", "newCustom");
        }else if(newPassword!=confirmPassword){
            window.wxc.xcConfirm("两次输入的密码不一致", "newCustom");
        }else{
            $.ajax({
                type: 'POST',
                url: "/password/update" ,
                data:{
                    "oldPassword" : oldPassword,
                    "newPassword" : newPassword
                },
                success: function (data) {
                    if(data.status=="error"){
                        window.wxc.xcConfirm(data.message, "error");
                    }else{
                        var option = {
                            onOk: function () {
                                window.location.href = "${ctx}/password/";
                            }
                        }
                        window.wxc.xcConfirm("密码修改成功。", "success", option);
                        setTimeout(function () {
                            window.location.href = "${ctx}/password/";
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
