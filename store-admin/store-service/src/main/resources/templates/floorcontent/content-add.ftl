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
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/floorcontent/list"><i class="fa fa-dashboard"></i>楼层内容管理</a></li>
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
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>内容名称：</label>
                                    <div class="col-sm-4">
                                        <input type="text" class="form-control" name="name" id="name" required placeholder="内容名称">
                                    </div>
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>内容图片：</label>
                                    <div class="col-sm-3">
                                        <input type="file" class="form-control required" name="file1" id="file1" >
                                    </div>
                                    <div class="col-sm-1">
                                        <button type="button" class="btn btn-info" id="submitId" class="form-control">上传
                                        </button>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>所属楼层：</label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="floorId" id="adminRoleId" required placeholder="请选择">
                                            <option value="" selected="selected">请选择</option>
                                        <#if list??>
                                            <#list list as floor>
                                                <option value="${floor.id}">${floor.name}</option>
                                            </#list>
                                        </#if>
                                        </select>
                                    </div>
                                    <label for="" class="col-sm-2 control-label">图片路径：</label>
                                    <div class="col-sm-3">
                                        <input type="text" class="form-control" placeholder="图片路径" name="contentImageUrl" id="contentImageUrl" style="display: none">
                                        <input type="text" class="form-control" placeholder="图片路径" name="contentImageUrl2" id="contentImageUrl2" disabled="disabled">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>排序：</label>
                                    <div class="col-sm-4">
                                        <input type="number" class="form-control  required digits minValue" placeholder="排序" name="showIndex" id="showIndex" min-value="1">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"><span class="text-red">*</span>类型：</label>
                                    <div class="col-sm-4">
                                        <div class="radio-inline">
                                            <input id="noId" type="radio" name="type" value="0" required placeholder="图片" checked="true"/>图片
                                        </div>
                                        <div class="radio-inline">
                                            <input id="urlId" type="radio" name="type" value="1" required placeholder="超链接"/>超链接
                                        </div>
                                        <div class="radio-inline">
                                            <input id="picId" type="radio" name="type" value="2" required placeholder="检索"/>图片检索
                                        </div>
                                    </div>
                                </div>
                                <#--
                                <div class="form-group" id="showUrl" style="display: none;">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>URL：</label>
                                    <div class="col-sm-4">
                                        <input type="url" class="form-control" placeholder="URL" name="linkUrl" id="linkUrl">
                                    </div>
                                </div>
                                -->
                                <!-- 超链接板块 开始 -->
                                <div class="form-group valid-height-control" id="showUrl" style="display: none;">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>链接来源：</label>
                                    <div class="col-sm-4">
                                        <select id="linkSource" name="linkSource" class="form-control required"
                                                title="请选择链接来源" placeholder="请选择" onchange="setLinkCheck();">
                                            <option value="" selected="selected">请选择</option>
                                        <#list linkSourceMap?keys as linkKey>
                                            <option value="${linkKey!}">${linkSourceMap[linkKey]!}</option>
                                        </#list>
                                        </select>
                                    </div>
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>URL：</label>
                                    <div class="col-sm-3">
                                        <input type="text" id="linkUrl" name="linkUrl" class="form-control required url" tip-title="URL" placeholder="URL">
                                    </div>
                                </div>
                                <!-- 超链接板块 结束 -->
                                <div class="form-group" id="showPic" style="display: none;">
                                    <label for="" class="col-sm-2 control-label"><span class="text-red">*</span>关键字：</label>
                                    <div class="col-sm-4">
                                        <input type="text" class="form-control required" placeholder="关键字" name="picSearchContent" id="picSearchContent">
                                    </div>
                                </div>
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

    $("#noId").on("click", function () {
        $("#showUrl").hide();
        $("#showPic").hide();
    });

    $("#picId").on("click", function () {
        $("#showUrl").hide();
        $("#showPic").show();
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