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
        <#--<section class="content-header">
            <h1>
                欢迎您
                <small>${user.username!}</small>
            </h1>
            <h5>
                今天是&nbsp;&nbsp;${.now}
            </h5>
            <#if user.currentLoginTime??>
                <h5>
                    您上次登录时间是&nbsp;&nbsp;${user.currentLoginTime!}
                </h5>
            </#if>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                <li class="active">Dashboard</li>
            </ol>
        </section>-->
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
<#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>
</body>
</html>
