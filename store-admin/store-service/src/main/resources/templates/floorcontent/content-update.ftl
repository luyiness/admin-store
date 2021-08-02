<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>

<#include "/include/head.ftl" />
    <style>
        .text-error {
            color: red;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="ontent-wrapper">
<#include "/include/top-menu.ftl"/>
    <!-- Left side column. contains the logo and sidebar -->
<#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                楼层内容管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="#"><i class="fa fa-dashboard"></i>楼层内容管理</a></li>
                <li class="active"><a href="#">编辑楼层内容</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">编辑楼层内容</h3>
                        </div>
                        <form class="form-horizontal" action="${ctx}/floorcontent/save" method="post" id="floorContendForm">
                            <input type="hidden" name="id" id="id" value="${floorContent.id!}">
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>内容名称：</label>
                                    <div class="col-sm-4">
                                        <input type="text" class="form-control" value="${floorContent.name!}" name="name" id="name" required placeholder="内容名称">
                                    </div>
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>内容图片：</label>
                                    <div class="col-sm-3">
                                        <input type="file" class="form-control <#if !floorContent.contentImageUrl?exists>required</#if>" name="file1" id="file1" >
                                    </div>
                                    <div class="col-sm-1">
                                        <button type="button" class="btn btn-info" id="submitId" class="form-control">上传</button>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>所属楼层：</label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="floorId" required id="adminRoleId">
                                            <option value="">请选择</option>
                                        <#if list??>
                                            <#list list as floor>
                                                <option value="${floor.id}" <#if floorId == floor.id> selected="selected"</#if>> ${floor.name}</option>
                                            </#list>
                                        </#if>
                                        </select>
                                    </div>
                                    <label for="" class="col-sm-2 control-label">图片路径：</label>
                                    <div class="col-sm-3">
                                        <input class="form-control" placeholder="图片路径" name="contentImageUrl" id="contentImageUrl" style="display: none"  <#if floorContent.contentImageUrl?exists>value="${floorContent.contentImageUrl}</#if>">
                                        <input class="form-control" placeholder="图片路径" name="contentImageUrl2" id="contentImageUrl2" disabled="disabled"  <#if floorContent.contentImageUrl?exists>value="${floorContent.contentImageUrl}</#if>">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>排序：</label>
                                    <div class="col-sm-4">
                                        <input type="number" class="form-control required digits minValue" value="${floorContent.showIndex!}" name="showIndex" id="showIndex" min-value="1"  placeholder="排序" >
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"><span class="text-red">*</span>类型：</label>
                                    <div class="col-sm-4">
                                        <div class="radio-inline"><input id="noId" type="radio" name="type" value="0" required placeholder="图片" <#if floorContent.type == 0>checked="true"</#if> />图片</div>
                                        <div class="radio-inline"><input id="urlId" type="radio" name="type" value="1" required placeholder="超链接" <#if floorContent.type == 1>checked="true"</#if>  />超链接</div>
                                        <div class="radio-inline"><input id="picId" type="radio" name="type" value="2" required placeholder="检索" <#if floorContent.type == 2>checked="true"</#if>  />检索</div>
                                    </div>
                                </div>
                                <!-- 超链接板块 开始 -->
                                <div class="form-group valid-height-control" id="showUrl" <#if floorContent.type != 1>style="display: none;"</#if> >
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>链接来源：</label>
                                    <div class="col-sm-4">
                                        <select id="linkSource" name="linkSource" class="form-control required"
                                                title="请选择链接来源" placeholder="请选择" onchange="setLinkCheck();">
                                            <option value="" selected="selected">请选择</option>
                                        <#list linkSourceMap?keys as linkKey>
                                            <option value="${linkKey!}" <#if floorContent.linkSource?? && linkKey == floorContent.linkSource >selected</#if>>${linkSourceMap[linkKey]!}</option>
                                        </#list>
                                        </select>
                                    </div>
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>URL：</label>
                                    <div class="col-sm-3">
                                        <input type="text" id="linkUrl" name="linkUrl" class="form-control required url" tip-title="URL" placeholder="URL" value="${floorContent.linkUrl!}">
                                    </div>
                                </div>
                                <!-- 超链接板块 结束 -->
                                <!-- 图片检索板块 开始 -->
                                <div class="form-group" id="showPic" <#if floorContent.type != 2>style="display: none;"</#if>>
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>关键字：</label>
                                    <div class="col-sm-4">
                                        <input type="text" class="form-control required" placeholder="关键字" name="picSearchContent" id="picSearchContent" value="${floorContent.picSearchContent!}">
                                    </div>
                                </div>
                                <!-- 图片检索板块 结束 -->
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <button type="button" class="btn btn-default" onclick="go('${ctx}/floorcontent/list')">取消</button>
                                <button type="submit" class="btn btn-info pull-right">保存</button>
                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                </div>
            </div>
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
<#include "/include/foot.ftl"/>
</div>
<!-- ./ontent-wrapper -->
<#include "/include/resource.ftl"/>
<script src="${c_static}/lte/plugins/jQuery/ajaxfileupload.js"></script>
<script type="text/javascript" src="${p_static}/admin/js/global.js"></script>
<script>
    $(function () {
        // Replace the <textarea id="editor1"> with a CKEditor
        // instance, using default configuration.
    });

    $("#urlId").on("click", function () {
        $("#showUrl").show();
        $("#showPic").hide();
    });

    $("#picId").on("click", function () {
        $("#showUrl").hide();
        $("#showPic").show();
    });

    $("#noId").on("click", function () {
        $("#showUrl").hide();
        $("#showPic").hide();
    });

    $(document).ready(function () {
        var validator = initDefaultValidator($("#floorContendForm"));
        $("#floorContendForm").bind('submit', function(){
            if(validator.form()){
                ajaxSubmit(this, function(data){
                    var txt=  data.message;
                    if (data.status == "success") {
                        var option = {
                            onOk: function(){
                                go("${ctx}/floorcontent/list");
                            }
                        }
                        window.wxc.xcConfirm(txt, "success", option);
                        setTimeout(function () {
                            go("${ctx}/floorcontent/list");
                        }, 5000);
                    } else {
                        window.wxc.xcConfirm(txt, "error", option);
                    }
                });
            }
            return false;
        });
    });

    //设置链接校验类型
    function setLinkCheck() {
        var linkSource =$("#linkSource").val();
        var linkUrlDoc =$("#linkUrl");
        if(linkSource=="0"){
            linkUrlDoc.removeClass("url");
        }else if(linkSource=="1"){
            if(!linkUrlDoc.hasClass("url")){
                linkUrlDoc.addClass("url");
            }
        }
        linkUrlDoc.valid();
    }

    var absoluteFilePath = "";
    $("#submitId").on("click", function () {
        $.ajaxFileUpload({
            url: '/image/api/', //你处理上传文件的服务端
            secureuri: false,
            fileElementId: 'file1',
            dataType: 'application/json',
            success: function (data) {
                var str = data.toString();
                var start = str.indexOf("[");
                var end = str.indexOf("]");
                str = str.substring(start, end + 1);
                var resultData = $.parseJSON(str);
                absoluteFilePath = resultData[0].filePath;
                $("#contentImageUrl").val(absoluteFilePath);
                $("#contentImageUrl2").val(absoluteFilePath);
                $("#file1").removeClass("required");
                window.wxc.xcConfirm("上传成功，地址为：" + absoluteFilePath, "success");
            }
        });
    });

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