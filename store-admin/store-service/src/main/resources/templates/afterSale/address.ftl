<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>售后</title>
    <#include "/include/head.ftl" />
    <style>
        iframe {
            width: 100%;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">

<div class="wrapper" id="main-containter">

    <#include "/include/top-menu.ftl"/>

    <!-- Left side column. contains the logo and sidebar -->
    <#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <iframe src="/static/modules/storeAfterSale/#/address" frameborder="no"></iframe>
    </div>


    <#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>

<script type="text/javascript">
    // function changeFrameHeight() {
    //     let ifm = document.querySelectorAll("iframe")[0];
    //     ifm.height = document.documentElement.clientHeight - 56;
    // }
    //
    // window.onresize = function () {
    //     changeFrameHeight();
    // }
    // $(function () {
    //     changeFrameHeight();
    // });
    $(window.parent.document).find("iframe").load(function(){
        let main = $(window.parent.document).find("iframe");
        let thisHeight = $(document).height() + 30;
        main.height(thisHeight);
    });
</script>

</body>
</html>
