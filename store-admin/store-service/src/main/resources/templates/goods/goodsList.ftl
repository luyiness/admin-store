<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>

    <link rel="stylesheet" href="${p_static}/admin/css/bootstrap/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="${p_static}/lte/jstree/themes/default/style.min.css"/>
    <link rel="stylesheet" href="${p_static}/admin/layui/css/layui.css">
    <link rel="stylesheet" href="${p_static}/admin/css/load/load.css"/>
    <link rel="stylesheet" href="${p_static}/admin/css/invoice.css">
    <script src="${p_static}/lte/plugins/jQuery/jquery1.11.2.min.js"></script>
    <!-- jstree-->
    <script src="${p_static}/lte/jstree/jstree.min.js"></script>

    <script src="${p_static}/admin/js/bootstrap/bootstrap-table.min.js"></script>
    <style>
        label {
            margin-bottom: 0 !important;
            vertical-align: middle;
        }

        .form-group {
            width: 32%;
            margin-bottom: 15px !important;
        }

        .form-group label {
            width: 98px;
            text-align: right;
        }

        .form-inline .form-control {
            width: 68% !important;
        }

        #permTable td {
            text-align: center !important;
        }
    </style>
<#include "/include/head.ftl" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper" id="main-containter">
<#include "/include/top-menu.ftl"/>
<#include "/include/left.ftl"/>
    <div class="content-wrapper">
        <section class="content-header">
            <h1>
                商品管理
            </h1>
            <ol class="breadcrumb">
                <li><a href="${ctx}/index.htm"><i class="fa fa-dashboard"></i> 首页</a></li>
                <li class="active"><a href="${ctx}/product/goodsList">商品管理</a></li>
            </ol>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <form class="form-inline well" style="height: 220px;">
                        <div class="col-xs-12">
                            <div class="col-xs-4 form-group" style="">
                                <label>供应商:</label>
                                <input type="text" class="form-control" id="provideName" disabled name="provideName" style="width: 60% !important;">
                                <input type="text" class="form-control" id="storeId" style="display: none;" name="storeId"
                                       value="${storeId!}">
                            </div>
                            <div class="col-xs-4 form-group" style="">
                                <label>供应商SKU:</label>
                                <input type="text" class="form-control" placeholder="供应商SKU" id="productSku"
                                       name="productSku" style="width: 55% !important;" >
                            </div>
                            <div class="col-xs-4 form-group" style="">
                                <label>商品名称:</label>
                                <input type="text" class="form-control" placeholder="商品名称" id="productName"
                                       name="productName" style="width: 55% !important;">
                            </div>
                        </div>

                        <div class="col-xs-12">
                            <div class="col-xs-4 form-group" style="">
                                <label>商品品牌:</label>
                                <input type="text" class="form-control" placeholder="商品品牌" id="productBrand"
                                       name="productBrand" style="width: 55% !important;" >
                            </div>
                            <div class="col-xs-4 form-group" style="">
                                <label>上下架状态:</label>
                                <select class="form-control" id="providerSaleStatus"
                                        name="providerSaleStatus" placeholder="上下架状态" style="width: 55% !important;">
                                    <option selected="selected" value="-1">全部</option>
                                    <option value="-2">未上架</option>
                                    <option value="1">已上架</option>
                                    <option value="-3">已下架</option>
                                </select>
                            </div>
                            <div class="col-xs-4 form-group" style="">
                                <label>分类:</label>
                                <input type="text" class="form-control" placeholder="分类名称" readonly id="categoryIds"
                                       name="categoryIds" style="width: 55% !important;">
                                <input type="text" style="display: none;" class="form-control" id="categoryId"
                                       name="categoryId">
                            </div>
                        </div>

                        <!--这里有分类树DIV-->
                        <div class="modal fade" id="jstree_div_content" tabindex="-1" role="dialog"
                             aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                permTable
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                        <h4 class="modal-title" id="myModalLabel">选择商品分类</h4>
                                    </div>
                                    <div class="modal-body" id="jstree_div"
                                         style="height: 400px;line-height: 400px; overflow: auto;overflow-x: hidden;">
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">
                                            关闭
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--修改库存模态框-->
                        <div class="modal fade" id="updateProductStockModal" tabindex="-1" role="dialog"
                             aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="myModalLabel">修改库存</h4>
                                    </div>
                                    <div class="modal-body" id="updateProductStockDiv">
                                        <div class="form-group" style="margin-right: 10px;width: 60%">
                                            <label>库存量:</label>
                                            <input type="text" class="form-control" placeholder="库存" id="stockCount"
                                                   name="stockCount">
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-info" id="updateProductStockCountBtn"
                                                onclick="sureToupdateProductStockCount()">
                                            确定
                                        </button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">
                                            关闭
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--二维码生成-->
                        <div class="modal fade" id="qrcodeImage_div_content" tabindex="-1" role="dialog"
                             aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                        <h4 class="modal-title" id="myModalLabel">二维码查看</h4>
                                    </div>
                                    <div class="modal-body" id="jstree_div"
                                         style="height: 400px;line-height: 400px; overflow: auto;overflow-x: hidden;">
                                        <img style="margin-left: 70px;" id="qrcodeImage"/>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">
                                            关闭
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xs-12">
                            <div class="col-xs-4 form-group" style="">
                                <label>是否包邮:</label>
                                <select class="form-control" id="isFreeFreight"
                                        name="isFreeFreight" placeholder="是否包邮" style="width: 55% !important;">
                                    <option selected="selected" value="">全部</option>
                                    <option value="1">是</option>
                                    <option value="0">否</option>
                                </select>
                            </div>

                            <div class="col-xs-4 btnC form-group" style="overflow: hidden;float: right;">
                                <div style="float: right">
                                    <button type="button" style="" class="btn" id="btn-advanced-search"
                                            onclick="resetSearchCriteria()">
                                        重置条件
                                    </button>
                                </div>
                                <div style="float: right">
                                    <button type="button" style="float: right;margin-right: 30px;" class="btn"
                                            id="btn-advanced-search" onclick="search()">
                                        <i class="fa fa-search"></i>查询
                                    </button>
                                </div>
                            </div>
                        </div>


                        <br/>
                        <div style="float: left">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="upProduct_select()">
                                <i class=""></i>批量上架
                            </button>
                        </div>
                        <div style="float: left;margin-left: 15px;">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="downProduct_select()">
                                <i class=""></i>批量下架
                            </button>
                        </div>

                        <div style="float: left;margin-left: 30px;">
                            <button type="button" style="float: right;margin-right: 15px;" class="btn"
                                    id="btn-advanced-search" onclick="addProduct()">
                                <i class="add"></i>添加商品
                            </button>
                        </div>

                        <div style="float: left;margin-left: 15px;">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="free_shipping_select()">
                                <i class=""></i>设置包邮商品
                            </button>
                        </div>
                        <div style="float: left;margin-left: 15px;">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="free_shipping_batch()">
                                <i class=""></i>导入包邮商品
                            </button>
                        </div>
                        <div style="float: left;margin-left: 15px;">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="un_free_shipping_select()">
                                <i class=""></i>取消包邮商品
                            </button>
                        </div>
                        <div style="float: left;margin-left: 15px;">
                            <button type="button" style="" class="btn" id="btn-advanced-search"
                                    onclick="goodsExport()">
                                <i class=""></i>导出商品清单
                            </button>
                        </div>
                    </form>
                    <div class="box">
                        <div class="box-body">
                            <table id="permTable" class="table table-bordered table-striped" style="width: 100%;">
                                <thead>
                                <tr>
                                    <th style="text-align: center;width: 5%;">
                                        <input type="checkbox" style="margin-left: 0px;" class="cb-getGoods"/>
                                    </th>
                                    <th style="text-align: center;width: 6%;">序号</th>
                                    <th style="text-align: center;width: 11%;">供应商</th>
                                    <th style="text-align: center;width: 10%;">供应商SKU</th>
                                    <th style="text-align: center;width: 11%;">商品名称</th>
                                    <th style="text-align: center;width: 10%;">商品品牌</th>
                                    <th style="text-align: center;width: 9%;">市场价</th>
                                    <th style="text-align: center;width: 9%;">协议价</th>
                                    <th style="text-align: center;width: 9%;">库存</th>
                                    <th style="text-align: center;width: 10%;">上下架状态</th>
                                    <th style="text-align: center;width: 10%;">是否包邮</th>
                                    <th style="text-align: center;">操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

<#------------------------批量添加物流------------------------>
    <div class="coverLayer wuliuLayer" id="batchAddFreeFreightGoods" hidden>
        <div class="coverCon" style="height: 300px;">
            <header>
                导入
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row">
                    <div class="contentLMargin" style="padding-left: 50px;">
                        <table style="height: 190px;">
                            <tr>
                                <td>
                                    <font style="font-weight: bolder;">导入模板下载：</font>
                                </td>
                                <td>
                                    <a href="${ctx}/product/downBatchExcel"
                                       style="color: #029bdf"><u>《批量添加包邮商品模板下载.xls》</u></a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <font style="font-weight: bolder;">请选择导入文件：</font>
                                </td>
                                <td>
                                    <form enctype="multipart/form-data" id="fileFormBatch">
                                        <input type="file" name="file" id="importXLSBatch">
                                    </form>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="sureBtnBox" style="text-align: right;height: 100%;width: 100%;">
                <table style="width: 100%;height: 75px;border: 1px solid #eee;">
                    <tr>
                        <td style="width: 33%;"></td>
                        <td style="width: 33%;"></td>
                        <td style="text-align: center">
                            <button class="btn" type="button"
                                    style="width: 60px;background-color: #eee;margin: 10px;"
                                    onclick="closeBoxBatch();">关闭
                            </button>
                            <button class="btn" type="button"
                                    style="width: 60px;background-color: #2493f2;color: white;margin: 10px;"
                                    onclick="uploadFileBatch();">上传
                            </button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="coverLayer wuliuLayer" id="uploadingIdBatch" hidden>
        <div class="coverCon">
            <header>
                温馨提示
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row">
                    <div class="contentLMargin">
                        文件导入中...
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="coverLayer wuliuLayer" id="dialogIdsBatch" hidden>
        <div class="coverCon" style="height: 300px;">
            <header>
                <span id="tipTextBatch"></span>
                <span class="glyphicon glyphicon-remove  closeTips" onclick="closeBoxBatch();"></span>
            </header>
            <div class="boxTips">
                <div class="boxTipsCon row" style="height:100px;">
                    <div class="" id="contentIdsBatch"
                         style="overflow-y:scroll;height:200px;margin-left:100px;overflow: hidden;">
                    </div>
                </div>
            </div>
            <div class="sureBtnBox">
                <span class="sureBtn" onclick="closeBoxBatch();">确 定</span>
            </div>
        </div>
    </div>
<#------------------------批量添加物流------------------------>
    
<#include "/include/foot.ftl"/>
</div>
<#include "/include/resource.ftl"/>

<script src="${p_static}/admin/js/load/load-min.js"></script>

<script>

    var table;
    var searchFlag = false;
    //选中的id
    var selectIds = [];
    //全局的全部checkbox
    var $wholeChexbox = $('.cb-getGoods');

    //获取选中的id数组
    function getSelectIds(e, sku) {
        if ($(e).is(':checked')) {
        } else {
            $(".cb-getGoods").removeAttr("checked");
        }
    }

    function init() {
        //全局的全部checkbox
        var $allCheckbox = $('input[type="checkbox"]');
        //全局的全部checkbox
        var $wholeChexbox = $('.cb-getGoods');
        var $cartBox = $('tbody>tr');
        //初始化 全选按钮为false
        $wholeChexbox.prop("checked", false);
        $allCheckbox.click(function () {
            if ($(this).is(':checked')) {
            } else {
            }
        });

        //===============================================全局全选与单个选择的关系================================

        $wholeChexbox.click(function () {
            var $chkBox = $('tbody>tr');
            var $checkboxs = $chkBox.find('input[type="checkbox"]');
            //清空
            selectIds = [];
            if ($(this).is(':checked')) {
                $checkboxs.prop("checked", true);
            } else {
                $checkboxs.prop("checked", false);
            }
            $checkboxs.each(function () {
                if ($(this).is(':checked')) {
                    var id = $(this).attr("goods-bind");
                    selectIds.push(id);
                }
            });
        });

        $($('tbody>tr').find('input[type="checkbox"]')).each(function () {
            $(this).click(function () {
                if ($(this).is(':checked')) {
                    //判断：所有单个商品是否勾选
                    var len = $($('tbody>tr').find('input[type="checkbox"]')).length;
                    var num = 0;
                    $($('tbody>tr').find('input[type="checkbox"]')).each(function () {
                        if ($(this).is(':checked')) {
                            num++;
                        }
                    });
                    if (num == len) {
                        $('.cb-getGoods').prop("checked", true);
                    }
                    var id = $(this).attr("goods-bind");
                    selectIds.push(id);
                } else {
                    //单个商品取消勾选，全局全选取消勾选
                    $('.cb-getGoods').prop("checked", false);
                }
            })
        })
        getCheckedout();
    }

    /**防止点击分页条出现 全选无法去掉*/
    function getCheckedout() {
        //防止点击分页条出现 全选无法去掉
        $(".pagination").find("a").each(function () {
            $(this).click(function () {
                $wholeChexbox.prop("checked", false);
            })
        })
    }

    $(function () {
        //页面一加载获取供应商名字显示
        $.ajax({
            url: "${ctx}/product/getStoreName",
            type: "POST"
        }).done(function (data) {
            if (data.success) {
                $("#provideName").val(data.result);
            } else {
                window.wxc.xcConfirm("没获取到供应商姓名，异常，请联系管理员。", "error");
            }
        }).fail(function () {
            window.wxc.xcConfirm("没获取到供应商姓名，异常，请联系管理员。", "error");
        });

        table = $('#permTable').DataTable({
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
            "bStateSave": false,
            "bJQueryUI": true,
            "bPaginate": true,// 分页按钮
            "bFilter": false,// 搜索栏
            "bLengthChange": false,// 每行显示记录数
            "iDisplayLength": 10,// 每页显示行数
            "bSort": false,// 排序
            "bInfo": true,// Showing 1 to 10 of 23 entries 总记录数没也显示多少等信息
            "bWidth": true,
            "bScrollCollapse": true,
            "sPaginationType": "full_numbers", // 分页，一共两种样式 另一种为two_button // 是datatables默认
            "bServerSide": true,
            "bDestroy": true,
            "bSortCellsTop": true,
            "sAjaxSource": "${ctx}/product/list",
            "fnInitComplete": function () {
                this.fnAdjustColumnSizing(true);
            },
            "fnServerParams": function (aoData) {
                aoData.push({
                            "name": "storeId",
                            "value": $("#storeId").val()
                        }, {
                            "name": "productName",
                            "value": $("#productName").val()
                        }, {
                            "name": "productSku",
                            "value": $("#productSku").val()
                        }, {
                            "name": "productBrand",
                            "value": $("#productBrand").val()
                        }, {
                            "name": "providerSaleStatus",
                            "value": $("#providerSaleStatus").val()
                        }, {
                            "name": "categoryId",
                            "value": $("#categoryId").val()
                        }, {
                            "name": "isFreeFreight",
                            "value": $("#isFreeFreight").val()
                        }
                );
            },
            "aoColumns": [
                {
                    "sClass": "text-center",
                    "data": "sku",
                    'render': function (data, type, row) {
                        return '<input class="checkchild" goods-bind=' + row.sku + '  type="checkbox"  style="margin-left: 0px;" onclick="getSelectIds(this,' + row.sku + ')"/>';
                    },
                    "bSortable": false
                },

                {
                    "data": function (row, type, set, meta) {
                        var c = meta.settings._iDisplayStart + meta.row + 1;
                        return c;
                    }
                },
                {
                    "data":
                            function (row, type, set, meta) {
                                var providerName = row.provideName;
                                if (row.provideName == "" || row.provideName == null) {
                                    providerName = "";
                                }
                                return providerName;
                            }
                },
                {"data": "sku"},
                {"data": "name"},
                {"data": "providerBrandName"},
                {"data": "marketPrice"},
                {
                    "data": "costPrice"
                },
                {"data": "stockCount"},
                {
                    "data": function (row, type, set, meta) {
                        var goods_state = "";
                        //商品的状态 0 已下架1已上架 2审核通过 3审核不通过 4默认
                        if (row.status == 1) {
                            goods_state = "已上架";
                        } else if (row.status == -1) {
                            goods_state = "已下架";
                        } else {
                            goods_state = "未上架";
                        }
                        return goods_state;
                    }
                },
                {
                    "data": function (row, type, set, meta) {
                        var isFreeFreight = "";
                        //商品是否包邮：1-是
                        if (row.isFreeFreight == 1) {
                            isFreeFreight = "是";
                        } else {
                            isFreeFreight = "否";
                        }
                        return isFreeFreight;
                    }
                }
            ],
            "aoColumnDefs": [
                {'sClass': "text-center", "aTargets": [0]},
                {"aTargets": [1]},
                {"sClass": "text-center", "aTargets": [2]},
                {
                    "aTargets": [11],
                    "sClass": "text-center",
                    "data": "id",
                    "mRender": function (a, b, c, d) {//id，c表示当前记录行对象
                        //商品的状态 0 已下架1已上架 2审核通过 3审核不通过 4默认
                        if (c.status == "4") {
                            //0 待审核 默认
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"preLookProduct(\'' + c.sku + '\')\">预览</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProduct(\'' + c.sku + '\')\">修改</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>';
                        }
                        if (c.status == "3") {
                            //1审核不通过
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProduct(\'' + a + '\')\">修改</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"preLookProduct(\'' + a + '\')\">预览</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>';
                        }
                        if (c.status == "2") {
                            //2审核通过
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"upProduct(\'' + c.sku + '\')\">上架</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"preLookProduct(\'' + c.sku + '\')\">预览</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProduct(\'' + c.sku + '\')\">修改</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>'
                                    ;
                        }
                        if (c.status == "1") {
                            // 3已上架
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"downProduct(\'' + c.sku + '\')\">下架</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"preLookProduct(\'' + c.sku + '\')\">预览</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>';

                            ;
                        } else if (c.status == "0") {
                            //4已下架
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"upProduct(\'' + c.sku + '\')\">上架</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"preLookProduct(\'' + c.sku + '\')\">预览</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProduct(\'' + c.sku + '\')\">修改</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\"  onclick=\"deleteProduct(\'' + c.sku + '\',\'' + c.storeId + '\')\">删除</a>';
                            ;
                        } else if (c.status == "-1") {
                            //4已下架
                            return ''
                                    +
                                    '<a href=\"javascript:void(0);\" onclick=\"lookProduct(\'' + c.sku + '\')\">查看</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProduct(\'' + c.sku + '\')\">修改</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"upProduct(\'' + c.sku + '\')\">上架</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\" onclick=\"updateProductStockCount(\'' + c.sku + '\')\">修改库存</a>'
                                    + ' | ' +
                                    '<a href=\"javascript:void(0);\"  onclick=\"deleteProduct(\'' + c.sku + '\',\'' + c.storeId + '\')\">删除</a>';
                            ;
                        }
                    }
                },
            ],
            "fnRowCallback": function (nRow, aData, iDisplayIndex) {
            },
            "fnServerData": function (sSource, aoData, fnCallback) {
                var serializeData = function (aoData) {
                    var data = {};
                    for (var i = 0; i < aoData.length; i++) {
                        var dd = aoData[i];
                        if (dd['value']) {
                            data[dd['name']] = dd['value'];
                        }
                    }
                    return $.param(data);
                };
                $.ajax({
                    "type": 'post',
                    "url": sSource,
                    "data": serializeData(aoData),
                    beforeSend: function () {
                        showLoading();
                    },
                    "success": function (resp) {
                        fnCallback(resp);
                        var total = $("td");
                        if (total.size() < 2 && searchFlag) {
                            hideLoading();
                            window.wxc.xcConfirm("很抱歉，系统找不到您的记录，换个条件试试！", "info");
                        } else {
                            hideLoading();
                        }
                        init();
                    }
                }).always(function (data) {
                });
            }
        });
    });

    $(function () {
        $("[name='store_level']").attr("checked", 'true');//全选
    });

    //列表查询函数
    function search() {
        searchFlag = true;
        table.ajax.reload();
    }

    //重置搜索条件
    function resetSearchCriteria() {
        $("#productSku")[0].value = "";
        $("#productName")[0].value = "";
        $("#productBrand")[0].value = "";
        $("#providerSaleStatus")[0].value = "-1";
        $("#categoryIds")[0].value = "";
        $("#categoryId").val("");
        $("#isFreeFreight").val("");
    }

    //添加商品函数
    function addProduct() {
        window.location.href = "${ctx}/product/chooseCategory";
    }

    //上架提醒
    function upProduct(id) {
        selectIds = [];
        selectIds.push(id);
        var url = "${ctx}/product/updateProduct";
        var tipTxt = "温馨提示:是否确认将该商品上架？";
        var option = {
            onOk: function () {
                ajaxFunc(selectIds, url, 1);
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }

    //批量上架
    function upProduct_select() {
        var checkboxs = $('tbody>tr').find('input[type="checkbox"]');
        //清空
        selectIds = [];
        for (var i = 0; i < checkboxs.length; i++) {
            if (checkboxs[i].checked) {
                var sku = checkboxs[i].attributes[1].value;
                selectIds.push(sku);
            }
        }
        if (selectIds == undefined || selectIds == '') {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            var url = "${ctx}/product/updateProduct";
            var tipTxt = "是否批量上架所选商品？";
            var option = {
                onOk: function () {
                    ajaxFunc(selectIds, url, 1);
                    $("input:checkbox").removeAttr("checked");
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);
        }
    }

    //下架提醒
    //todo 接口中并没有 判断当前选中的商品是否是活动商品
    function downProduct(id) {
        selectIds = [];
        selectIds.push(id);
        var url = "${ctx}/product/updateProduct";
        var tipTxt = "温馨提示:是否确认将该商品下架？";
        var option = {
            title: "提示",
            btn: parseInt("0011", 2),
            onOk: function () {
                ajaxFunc(selectIds, url, 0);
                $("input:checkbox").removeAttr("checked");
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }

    //批量下架
    function downProduct_select() {
        var checkboxs = $('tbody>tr').find('input[type="checkbox"]');
        //清空
        selectIds = [];
        for (var i = 0; i < checkboxs.length; i++) {
            if (checkboxs[i].checked) {
                var sku = checkboxs[i].attributes[1].value;
                selectIds.push(sku);
            }
        }
        if (selectIds == undefined || selectIds == '') {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            var url = "${ctx}/product/updateProduct";
            var tipTxt = "是否批量下架所选商品？";
            var option = {
                title: "提示",
                btn: parseInt("0011", 2),
                onOk: function () {
                    ajaxFunc(selectIds, url, 0);
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);
        }
    }

    //批量设置包邮商品
    function free_shipping_select() {
        var checkboxs = $('tbody>tr').find('input[type="checkbox"]');
        //清空
        selectIds = [];
        for (var i = 0; i < checkboxs.length; i++) {
            if (checkboxs[i].checked) {
                var sku = checkboxs[i].attributes[1].value;
                selectIds.push(sku);
            }
        }
        if (selectIds == undefined || selectIds == '') {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            var url = "${ctx}/product/setUpFreeShippingGoods";
            var tipTxt = "是否批量设置所选商品为包邮商品？";
            var option = {
                title: "提示",
                btn: parseInt("0011", 2),
                onOk: function () {
                    ajaxFunc(selectIds, url, 1);
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);
        }
    }

    //批量设置取消包邮商品
    function un_free_shipping_select() {
        var checkboxs = $('tbody>tr').find('input[type="checkbox"]');
        //清空
        selectIds = [];
        for (var i = 0; i < checkboxs.length; i++) {
            if (checkboxs[i].checked) {
                var sku = checkboxs[i].attributes[1].value;
                selectIds.push(sku);
            }
        }
        if (selectIds == undefined || selectIds == '') {
            window.wxc.xcConfirm("请至少选择一条数据。", "error");
            return;
        } else {
            var url = "${ctx}/product/setUpFreeShippingGoods";
            var tipTxt = "是否批量取消所选商品为包邮商品？";
            var option = {
                title: "提示",
                btn: parseInt("0011", 2),
                onOk: function () {
                    ajaxFunc(selectIds, url, 0);
                }
            }
            window.wxc.xcConfirm(tipTxt, "confirm", option);
        }
    }

    function free_shipping_batch () {
        $("#batchAddFreeFreightGoods").show();
    }

    function closeBoxBatch() {
        $("#dialogIdsBatch").hide();
        $("#batchAddFreeFreightGoods").hide();
        $("#dialogIdsBatch").hide();
    }


    function uploadFileBatch() {
        var isValidate = true;
        var filePath = $("#importXLSBatch").val();
        if (filePath != "") {
            var suffix = filePath.substr(filePath.lastIndexOf(".") + 1, filePath.length);
            if (suffix.toLowerCase() == "xls" || suffix.toLowerCase() == "xlsx") {
                isValidate = true;
            } else {
                isValidate = false;
                window.wxc.xcConfirm("只能上传xls文件", "info");
            }
        } else {
            isValidate = false;
            window.wxc.xcConfirm("请先选择要上传的excel文件", "info");
        }
        if (isValidate) {
            $("#fileFormBatch").ajaxSubmit({
                type: 'post',
                url: STATIC_CTX + '/product/batchImportExcel',
                success: function (data) {
                    var errorText;
                    //异常信息
                    var errorMsg = data.errorMsg;
                    if (errorMsg != undefined && errorMsg != null && errorMsg != "") {
                        errorText = "<br>";
                        for (var i = 0; i < errorMsg.length; i++) {
                            errorText += errorMsg[i].error + "<br>";
                        }
                    } else {
                        //导入结果
                        var returnList = data.returnList;
                        $("#importXLSBatch").val(null);
                        $("#uploadingIdBatch").hide();
                        errorText = "共导入";
                        errorText += returnList.length;
                        errorText += "条数据，其中";
                        errorText += returnList.length - data.errorSize;
                        errorText += "条导入成功，";
                        errorText += data.errorSize;
                        errorText += "条导入失败";
                        errorText += "</br>";
                        errorText += "</br>";
                        errorText += "</br>";
                        errorText += "<a onclick='downReturnListBatch(" + JSON.stringify(returnList) + ")' style='color: #1E9FFF; cursor: pointer;'>下载导入结果</a><br>";
                        $("#tipTextBatch").html("导入结果");
                        $("#contentIdsBatch").html("<p class='logisticsProgress' style='padding-top: 50px'>" + errorText + "</p>");
                        $("#dialogIdsBatch").show();
                    }
                    table.ajax.reload();
                },
                error: function (data) {
                    $("#uploadingIdBatch").hide();
                    window.wxc.xcConfirm("文件导入出错，请重新导入！", "info", window.wxc.xcConfirm.btnEnum.ok);
                }
            });
            $("#importBatchId").hide();
            $("#importXLSBatch").val(null);
            $("#uploadingIdBatch").show();
        }
    }

    function downReturnListBatch(returnList) {
        var form = $("<form>");
        form.attr('style', 'display:none');
        form.attr('target', '_blank');
        form.attr('method', 'post');
        form.attr('action', STATIC_CTX + '/product/downloadReturnList');

        var returninput = $('<input>');
        returninput.attr('type', 'hidden');
        returninput.attr('name', 'returnList');
        returninput.attr('value', JSON.stringify(returnList));
        form.append(returninput);

        $('body').append(form);
        form.submit();
    }



    //修改商品库存信息
    function sureToupdateProductStockCount() {

        var sku = $("#updateProductStockCountBtn").attr("sku-id");//商品sku
        var stockCount = $("#stockCount").val();//商品库存

        var r = /^\+?[0-9][0-9]*$/;　　//正整数
        var flag = r.test(stockCount);
        if (!flag) {
            window.wxc.xcConfirm("请输入正整数。", "error");
            return false;
        }
        if(stockCount>100000){
            window.wxc.xcConfirm("商品最大库存10万。", "error");
            return false;
        }


        //根据商品sku查询相应库存
        $.ajax({
            url: '${ctx}/product/updateProductStockCount',
            type: 'POST',
            dataType: 'json',
            data: {sku: sku, stockCount: stockCount},
            beforeSend: function () {
                showLoading();
                $("#stockCount").empty();
                $("#updateProductStockCountBtn").removeAttr("sku-id");
            }
        }).done(function (data) {
            if (data.success) {
                $("#updateProductStockModal").modal('hide');
                search();
                window.wxc.xcConfirm("更新库存成功。", "success");
            } else {
                window.wxc.xcConfirm("更新库存异常，请联系管理员。", "error");
            }
        }).fail(function () {
            hideLoading();
            window.wxc.xcConfirm("更新库存异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
        });
    }

    //弹出模态框修改商品库存信息
    function updateProductStockCount(sku) {
        //根据商品sku查询相应库存
        $.ajax({
            url: '${ctx}/product/getProductStockCount',
            type: 'POST',
            dataType: 'json',
            data: {sku: sku},
            beforeSend: function () {
                showLoading();
                $("#stockCount").empty();
                $("#updateProductStockCountBtn").removeAttr("sku-id");
            }
        }).done(function (data) {
            if (data.success) {
                //弹出模态框
                $("#updateProductStockCountBtn").attr("sku-id", sku);
                $("#stockCount").val(data.result);
                $("#updateProductStockModal").modal('show');
            }
        }).fail(function () {
            hideLoading();
            window.wxc.xcConfirm("获取库存异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
        });
    }

    //修改商品信息
    function updateProduct(id) {
        window.location.href = "${ctx}/product/editProduct?sku=" + id;
    }

    //预览商品详细信息
    function preLookProduct(sku) {
        //  $("#qrcodeImage").attr("src", '${ctx}/goods/paymentQRCode?url=' + encodeURIComponent('/productPreView/preview?sku=' + sku + '&storeId=${storeId!}'));
        //   $("#qrcodeImage_div_content").modal("show");
        window.open("${ctx}/productPreView/preview?sku=" + sku + "&storeId=${storeId!}", "goods/goodsDetail.ftl");
    }

    //查看商品详细信息
    function lookProduct(id) {
        window.location.href = "${ctx}/product/productView?sku=" + id;
    }

    var load = new Loading();
    var showLoading = function () {
        load.init();
        load.start();
    };
    //取消立即加载中。。。
    var hideLoading = function () {
        load.stop();
    };

    function ajaxFunc(ids, url, status) {
        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            data: {ids: ids, status: status},
            beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            if (data.success) {
                window.wxc.xcConfirm(data.resultMessage, "success");
                table.ajax.reload();
                //清空选中的数组
                selectIds = [];
            } else {
                window.wxc.xcConfirm("操作失败，原因：" + data.resultMessage, "error");
            }
        }).fail(function () {
            hideLoading();
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
            $("input:checkbox").removeAttr("checked");
        });
    }

    //==============================分类树=============================

    var flag = 1;

    $("#categoryIds").click(function () {
        if (flag == 1) {
            $('#jstree_div').jstree({
                'core': {
                    'check_callback': true,
                    "data": function (obj, callback) {
                        $.ajax({
                            url: "${ctx}/product/getCategoryTree",
                            dataType: "json",
                            type: "POST",
                            beforeSend: function () {
                                showLoading();
                            },
                            success: function (data) {
                                if (data) {
                                    callback.call(this, data);
                                    $("#jstree_div_content").modal('show');
                                } else {
                                    $("#jstree_div_content").modal('show');
                                    $("#jstree_div").html("暂无数据！");
                                }
                                flag++;
                            }, complete: function () {
                                hideLoading();
                            }
                        });
                    }
                },
                "plugins": ["wholerow"]
            }).bind("select_node.jstree", function (event, data) {
                var inst = data.instance;
                var selectedNode = inst.get_node(data.selected);
                var level = $("#" + selectedNode.id).attr("aria-level");
                if (parseInt(level) <= 3) {
                    loadConfig(inst, selectedNode);
                    if (parseInt(level) == 3) {
                        $("#categoryId").val(selectedNode.id);
                        $("#categoryIds").val(selectedNode.text);
                        $("#jstree_div_content").modal('hide');
                    }
                }
            });
        } else {
            $("#jstree_div_content").modal('show');
        }
    });

    function loadConfig(inst, selectedNode) {
        $.ajax({
            url: "${ctx}/product/getCategoryTree",
            dataType: "json",
            data: {id: selectedNode.id},
            type: "POST",
            success: function (data) {
                if (data) {
                    selectedNode.children = [];
                    $.each(data, function (i, item) {
                        inst.create_node(selectedNode, item, "last");
                    });
                    inst.open_node(selectedNode);
                } else {
                    $("#jstree_div").html("暂无数据！");
                }
            }
        });
    }

    //***************************************************************

    /*删除提醒*/
    function deleteProduct(id, storeId) {
        selectIds = [];
        selectIds.push(id);
        var url = "${ctx}/product/deleteProduct";
        var tipTxt = "商品删除后 , 不会在商铺列表中展示 , 是否删除该商品 ？";
        var option = {
            onOk: function () {
                ajaxDele(selectIds, url, storeId);
            }
        }
        window.wxc.xcConfirm(tipTxt, "confirm", option);
    }

    //删除
    function ajaxDele(ids, url, storeId) {
        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            data: {ids: ids, storeId: storeId},
            beforeSend: function () {
                showLoading();
            }
        }).done(function (data) {
            if (data.success) {
                window.wxc.xcConfirm(data.resultMessage, "success");
                table.ajax.reload();
                selectIds = [];
            } else {
                window.wxc.xcConfirm("操作失败，原因：" + data.resultMessage, "error");
            }
        }).fail(function () {
            hideLoading();
            window.wxc.xcConfirm("异常，请联系管理员。", "error");
        }).always(function () {
            hideLoading();
        });
    }


    //商品导出
    function goodsExport() {
        var form = $("<form>");
        form.attr('style', 'display:none');
        form.attr('target', '_blank');
        form.attr('method', 'post');
        form.attr('action', "${ctx}/product/goodsExport");

        var productSku = $('<input>');
        productSku.attr('type', 'hidden');
        productSku.attr('name', 'productSku');
        productSku.attr('value', $("#productSku").val());
        form.append(productSku);

        var productName = $('<input>');
        productName.attr('type', 'hidden');
        productName.attr('name', 'productName');
        productName.attr('value', $("#productName").val());
        form.append(productName);

        var productBrand = $('<input>');
        productBrand.attr('type', 'hidden');
        productBrand.attr('name', 'productBrand');
        productBrand.attr('value', $("#productBrand").val());
        form.append(productBrand);

        var providerSaleStatus = $('<input>');
        providerSaleStatus.attr('type', 'hidden');
        providerSaleStatus.attr('name', 'providerSaleStatus');
        providerSaleStatus.attr('value', $("#providerSaleStatus").val());
        form.append(providerSaleStatus);

        var categoryId = $('<input>');
        categoryId.attr('type', 'hidden');
        categoryId.attr('name', 'categoryId');
        categoryId.attr('value', $("#categoryId").val());
        form.append(categoryId);

        var isFreeFreight = $('<input>');
        isFreeFreight.attr('type', 'hidden');
        isFreeFreight.attr('name', 'isFreeFreight');
        isFreeFreight.attr('value', $("#isFreeFreight").val());
        form.append(isFreeFreight);

        $('body').append(form);
        form.submit();
    }

</script>
</body>
</html>