<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
<#include "/include/head.ftl" />
<style>

    img {max-width:89.6666666%}
</style>


</head>
<body class="hold-transition skin-blue sidebar-mini" onload="setImgStyle()">
<div class="wrapper" id="main-containter">
<#include "/include/top-menu.ftl"/>
    <!-- Left side column. contains the logo and sidebar -->
<#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Banner管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li><a href="${ctx}/banner/list">Banner管理</a></li>
                <li class="active"><a href="#">编辑Banner</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">编辑Banner</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form enctype="multipart/form-data" class="form-horizontal" id="editForm" action="${ctx}/banner/update" method="post">
                            <input type="hidden" id="bannerId" name="id" value="${banner.id!}"/>
                            <input type="hidden" id="imgSrc" name="imageUrl" value="${banner.imageUrl!}" >
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="inputEmail3" class="col-sm-2 control-label"><span class="text-red">*</span>Banner名称</label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" id="bannerName" name="name"
                                               value="${banner.name!}" required placeholder="Banner名称">
                                    </div>

                                    <label for="inputPassword3" class="col-sm-2 control-label"><span class="text-red">*</span>排序值</label>
                                    <div class="col-sm-2">
                                        <input type="number" id="showIndex" name="showIndex" value="${banner.showIndex!}" class="form-control" required
                                               placeholder="排序值">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputPassword3" class="col-sm-2 control-label"><span class="text-red">*</span>Banner图片</label>
                                    <div class="col-sm-10">
                                        <#--<img id="img" onload="changeImgWidth()" style="max-width: " src="<#if isNew >/image/null_pic.jpg<#else >${banner.imageUrl}</#if>" >-->
                                        <div>
                                            <img id="img"  onload="setImgStyle()" <#if !isNew >style="width: 89.6666666%;float: left;position: relative;min-height: 1px;"</#if> src="<#if isNew >/image/null_pic.jpg<#else >${banner.imageUrl}</#if>" >
                                        </div>

                                        <div>
                                            <input id="formPic" type="file" name="bannerPic" value="选择图片" accept="image/*" onchange="changeImg()">
                                            <p id="tips" class="" style="color:red;">温馨提示：上传图片的以.jpg或.png格式为好，建议大小为1920*445，不要超过1M。</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group valid-height-control">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>是否配置URL：</label>
                                    <div class="col-sm-2">
                                        <div class="radio-inline"><input type="radio" name="setUrl" value="1" <#if !(banner.id)??>checked<#elseif (banner.linkValue)??>checked</#if> onchange="showUrl(1);"/>是</div>
                                        <div class="radio-inline"><input type="radio" name="setUrl" value="0" <#if (banner.id)??&&!(banner.linkValue)??>checked</#if> onchange="showUrl(0);"/>否</div>
                                    </div>
                                    <div class="col-sm-5 pull-left" id="urlDiv" <#if (banner.id)??&&!((banner.linkValue)??)>hidden</#if>>
                                        <input type="url" id="linkValue" name="linkValue" class="form-control required"
                                               tip-title="Banner链接" value="${banner.linkValue!}" placeholder="Banner链接">
                                    </div>
                                </div>
                                <div class="form-group">

                                </div>
                                <div class="form-group">

                                </div>

                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-default" onclick="cancel('${ctx}/banner/list')">取消
                                </button>
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

    function maxWidthLimit() {
        var maxWidth = document.getElementById("showIndex").getBoundingClientRect().right - document.getElementById("bannerName").getBoundingClientRect().left;
        document.getElementById("img").setAttribute("style","max-width:"+maxWidth);
    }

    function changeImg() {
        if ($("#formPic").val()!=null && $("#formPic").val()!=""){
            window.wxc.xcConfirm("正在上传Banner图片，请稍后。", "info");
            notAllowClose();
            $("#editForm").ajaxSubmit({
                type: 'post',
                url: '/image/api/',
                success: function (data) {
                    $("#imgSrc").val(data[0].filePath);
                    $("#img").attr("src", data[0].filePath);
                    $("#img").removeAttr("style");
                    emptyWindow();
                    window.wxc.xcConfirm("Banner图片上传成功。", "success");
                },
                error: function (data) {
                    emptyWindow();
                    window.wxc.xcConfirm("Banner图片上传失败，请联系管理员。", "error");
                }
            });
        }
    };

    function ajaxSubmit2(frm, fn) {
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

    //用于关闭弹窗的
    function notAllowClose() {
        var confirmButton = document.getElementsByClassName("sgBtn ok")[0];
        var closeButton = document.getElementsByClassName("clsBtn")[0];
        if(closeButton!=null) closeButton.parentNode.removeChild(closeButton);
        if(confirmButton!=null) confirmButton.parentNode.removeChild(confirmButton);
    }

    //用于关闭弹窗的提示窗口
    function emptyWindow() {
        var background = document.getElementsByClassName("xc_layer")[0];
        var alertWindow = document.getElementsByClassName("popBox")[0];
        if(background!=null) background.parentNode.removeChild(background);
        if(alertWindow!=null) alertWindow.parentNode.removeChild(alertWindow);
    }

    function submitCheck() {
        var bannerId = $("#bannerId").val();
        var bannerName = trim($("#bannerName").val());
        var imgSrc = $("#imgSrc").val();
        var showIndex = $("#showIndex").val();
        if(bannerName==null || bannerName==""){
            window.wxc.xcConfirm("Banner名称不能为空", "newCustom");
        }else if(imgSrc==null || imgSrc==""){
            window.wxc.xcConfirm("请上传Banner图片", "newCustom");
//        }else if(showIndex<=0 || showIndex>10 || parseInt(showIndex)!=showIndex){
        }else if(showIndex<=0 || parseInt(showIndex)!=showIndex){
            window.wxc.xcConfirm("请输入正确的排序值", "newCustom");
        }else{
            $("#showIndex").val(parseInt(showIndex));
            $.ajax({
                type: 'POST',
                url: "${ctx}/banner/check" ,
                data:{
                    "bannerId" : bannerId,
                    "bannerName" : bannerName,
                    "showIndex" :parseInt(showIndex)
                },
                success: function (data) {
                    if(data=="1"){
                        window.wxc.xcConfirm("该Banner名称已存在", "newCustom");
                        return false;
                    }else if(data=="2"){
                        window.wxc.xcConfirm("该排序值已存在", "newCustom");
                        return false;
//                          $("#editForm").submit();
                    }else if(data=="3"){
                        window.wxc.xcConfirm("该Banner名称及排序值均已存在", "newCustom");
//                        window.wxc.xcConfirm("该banner名称已存在", "custom");
                        return false;
                    }else if(data=="0"){
                        //
                        ajaxSubmit2(document.getElementById("editForm"), function (data) {
                            if (data.status == "success") {
                                var txt = data.message;
                                var option = {
                                    onOk: function () {
                                        goToNewuRL();
                                    }
                                }
                                window.wxc.xcConfirm(txt, "success", option);
                                setTimeout(function () {
                                    goToNewuRL();
                                }, 5000);
                            }
                        });

                        //
//                        $("#editForm").submit();
                    }
                },
                error:function (data) {
                    window.wxc.xcConfirm("异常，请联系管理员。", "error");
                }
            });
        }
    }

    function goToNewuRL(){
        window.location.href="${ctx}/banner/list";
    }

    function trim(str){ //删除左右两端的空格
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }

    function changeImgWidth() {
        $("#img").removeAttr("style");
//        alert(document.getElementById("bannerName").getBoundingClientRect().left);
//        alert(document.getElementById("showIndex").getBoundingClientRect().right);
//        var maxWidth = document.getElementById("bannerName").scrollWidth*809/433;
        var maxWidth = document.getElementById("showIndex").getBoundingClientRect().right - document.getElementById("bannerName").getBoundingClientRect().left;
        var nowWidth = $("#img").width();
        var scale = maxWidth/nowWidth;
        if(nowWidth>maxWidth){
            $("#img").width($("#img").width()*scale);
//            document.getElementById("img").height = ($("#img").height()*scale);
        }
    }

    function setImgStyle() {
        if($("#img").attr("src")!="/image/null_pic.jpg"){
            var maxWidth = document.getElementById("showIndex").getBoundingClientRect().right - document.getElementById("bannerName").getBoundingClientRect().left;
            var nowWidth = $("#img").width();
            if(nowWidth>maxWidth){
                $("#img").attr("style","width: 89.6666666%;float: left;position: relative;min-height: 1px;");
            }else{
                $("#img").attr("style","width: "+maxWidth+"px");
            }
            nowWidth = $("#img").width();
            $("#img").height(nowWidth/1920*445);
        }
    }
    function showUrl(flag){
        if(flag==1){
            $("#urlDiv").show();
        }else{
            $("#urlDiv").hide();
            $("#linkValue").val(null);
        }
    }
</script>
<script>
    function cancel(url) {
        window.location.href = url;
    }
</script>
</body>
</html>
