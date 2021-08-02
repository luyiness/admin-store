<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
    <style>
        .reChoice {
            color: #fff;
            padding: 5px 10px;
            background-color: #199eda;
            border: none;
            outline: none;
            font-size: 13px;
            margin-top: -4px;
        }
        /*弹窗*/
        .f-hide{
            display: none;
        }
        .coverLayer {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            background: url(${ctx}/admin/images/opcityBg.png);
            z-index: 999;
        }
        .reprotLayer, .reprotResultLayer {
            position: absolute;
            width: 470px;
            /* height: 245px; */
            padding-bottom: 15px;
            top: 35%;
            left: 34.5%;
            background-color: #fff;
        }
        .receiverTitle {
            color: #fff;
            background-color: #199eda;
            height: 40px;
            padding-left: 10px;
            padding-top: 12px;
        }
        .receiverTitle .closeBtn {
            float: right;
            position: absolute;
            top: 12px;
            right: 8px;
            font-size: 14px;
            cursor: pointer;
        }
        .reprotInfo, .reprotResultInfo {
            padding: 20px 30px;
        }
        .reprotInfoC {
            text-align: center;
        }
        .failList:last-child {
            margin-bottom: 0;
        }
        .resultSureBtn {
            cursor: pointer;
            width: 120px;
            line-height: 35px;
            background: #199eda;
            color: #fff;
            margin: 20px auto;
            text-align: center;
        }
        .resultBtnC {
            display: none;
            margin: 0 auto;
            text-align: center;
        }
        .resultBtnC span.sureEditBtn {
            background: #199eda;
        }
        .resultBtnC span {
            display: inline-block;
            vertical-align: middle;
            color: #fff;
            cursor: pointer;
            width: 120px;
            line-height: 35px;
            text-align: center;
            margin-right: 30px;
        }
        .resultBtnC span.sureEditBtn {
            background: #199eda;
        }
        .resultBtnC span.cancelEditBtn {
            background: #b7b7b7;
        }

    </style>
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
                产品分类选择
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/product/goodsList">商品管理</a></li>
                <li class="active">产品分类选择</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div style="width: 50%;margin: 0 auto;height: 500px;border:#4b646f solid 1px;overflow-y: auto;background: #fff;" id="jstree_div"></div>
            <div class="reChoice" style="margin:30px auto 0 auto;width: 60px;text-align: center;cursor: pointer;" onclick="forward()">下一步</div>
            <input type="hidden" id="categoryId">
        </section>
        <!-- /.content -->
    </div>


    <div class="reportResultCoverLayer coverLayer f-hide" id="message-modal">
        <div class="reprotLayer">
            <div class="receiverTitle" style="padding-top: 3px;">
                <h5 class="title">温馨提示</h5>
                <span class="closeBtn" style="font-size: 18px;top: 6px;">x</span>
            </div>
            <div class="reprotInfo">
                <div class="reprotInfoC reprotResultInfoC">
                    <div class="failList">
                        <h6 class="insuredTips" style="font-size: 15px;"></h6>
                    </div>
                </div>
                <p class="resultSureBtn" rel="close" onclick="cannle(this);">确  定</p>
                <p class="resultBtnC"><span class="sureEditBtn">确  定</span><span onclick="cannle(this)" class="cancelEditBtn">取  消</span> </p>
            </div>
        </div>
    </div>

<#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>
<!-- jstree-->
<script src="${c_static}/lte/jstree/jstree.min.js"></script>
<script type="text/javascript">
    $(function() {
        $('#jstree_div').jstree({
            'core' : {

                'check_callback': true,
                "data" : function (obj, callback){
                    $.ajax({
                        url : "getCategoryTree",
                        dataType : "json",
                        type : "POST",
                        success : function(data) {
                            if(data) {
                                callback.call(this, data);
                            }else{
                                $("#jstree_div").html("暂无数据！");
                            }
                        }
                    });
                }
            },
            "plugins": ["wholerow"]
        }).bind("select_node.jstree", function(event, data) {
            var inst = data.instance;
            var selectedNode = inst.get_node(data.selected);
            //console.info(selectedNode.aria-level);
            var level = $("#"+selectedNode.id).attr("aria-level");
            if(parseInt(level) <= 2){
                $("#categoryId").val("");
                loadConfig(inst, selectedNode);
            }else{
                $("#categoryId").val(selectedNode.id);
            }
        });

        /*$('#jstree').bind("activate_node.jstree", function (obj, e) {
            // 处理代码
            // 获取当前节点
            currentNode = e.node;
        });

        $('#jstree').bind('select_node.jstree', function(e, data) {

            var id = data.instance.get_node(data.selected[0]).id;
            $("#categoryId").val(id);

        });*/
    });
    function loadConfig(inst, selectedNode){
        $.ajax({
            url : "getCategoryTree",
            dataType : "json",
            data:{id:selectedNode.id},
            type : "POST",
            success : function(data) {
                if(data) {
                    selectedNode.children = [];
                    $.each(data, function (i, item) {
                        //var obj = {text:item.name};
                        //$('#jstree_div').jstree('create_node', selectedNode, obj, 'last');
                        inst.create_node(selectedNode,item,"last");
                    });
                    inst.open_node(selectedNode);
                }else{
                    $("#jstree_div").html("暂无数据！");
                }
            }
        });
    }
    var currentNode;

    function forward(){
        if(!$("#categoryId").val() == ""){
            window.location.href = "addProduct?productCategoryId="+$("#categoryId").val();
        }else{
//            alert("请选择第三级分类")
            showMessage({message: "请选择第三级分类"});
        }
    }

    function showMessage(options) {
        var defaults = {
            title: "温馨提示",
            message: ""
        };
        var o = $.extend(defaults, options);
        var modal = $('#message-modal');
        modal.find('.title').html(o.title);
        modal.find('.insuredTips').html(o.message).css({'margin':'0 auto;','text-align':'center;'});
        modal.removeClass('f-hide');
    }
    function showCannle(){
        $("#message-modal").find(".resultSureBtn").hide();
        $("#message-modal").find(".resultBtnC").show();
    }

    function hideCannle(){
        $(document).off("click",".sureEditBtn");
        $("#message-modal").find(".resultSureBtn").show();
        $("#message-modal").find(".resultBtnC").hide();

    }
    function cannle(obj){
        $(obj).parents('.coverLayer').addClass('f-hide');
        hideCannle();
    }
    $('.closeBtn').on('click',function () {
        $('.coverLayer').addClass('f-hide');
    })
</script>
</body>
</html>
