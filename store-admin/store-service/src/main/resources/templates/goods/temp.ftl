<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>商城供应商管理后台</title>
    <link rel="stylesheet" href="${p_static}/admin/css/product/reset.css" type="text/css">
    <link rel="stylesheet" href="${p_static}/admin/css/product/storeBasicInfo.css" type="text/css">
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
                <li class="active"><a href="${ctx}/goods/list">商品管理</a></li>
                <li class="active">添加商品</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="infoC">
                <div class="infoTop h"><em>您选择的类目：</em><span class="categoryName"></span> -> <span class="categoryName"></span> -> <span class="categoryName"></span> <#if remark == 'add'><button onclick="reChooseCategory();" class="reChoice fr" style="border: none;outline: none;font-size: 15px;">重选类目</button></#if></div>
                <div class="infoListC">
                    <div class="infoList">
                        <p class="infoTit">基本内容</p>
                    <#--<p class="infoTip h"><span class="fl">提示：价格的发布和修改有可能会有延迟，如果出现敬请谅解</span> <span class="fr">请确保您填写的商品信息符合 <a href="javascript:void(0);" class="blue">京东开放平台 商品价格规范</a></span></p>-->
                        <div class="infoListDetils">
                            <div class="detilsList"><label><em class="red">*</em>产品名称：</label><input type="text" id="modelName"  placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>品牌：</label><select id="brandId" type="text" placeholder="请选择">
                            <#--<option value="每日优鲜">每日优鲜</option>
                    <option value="每日优鲜">每日优鲜</option>
                    <option value="每日优鲜">每日优鲜</option>-->
                            </select>
                            </div>
                        </div>


                    </div>

                    <div class="infoList">
                        <p class="infoTit">商品属性</p>
                    <#--<p class="infoTip h"><span class="fl">提示：如果属性和属性值不满足业务需要，<a href="javascript:void(0);" class="blue">请点击此处进行问题反馈</a></span></p>-->
                        <div id="productStandardDiv" class="infoListDetils">
                        </div>
                    </div>

                    <div class="infoList goodsList" style="display: none;">
                        <p class="infoTit">商品列表</p>
                        <div id="goodsTableDiv" class="infoListDetils">
                        </div>
                    </div>

                    <div class="infoList goodsInfo" style="display: none;">
                        <p class="infoTit">商品基本信息</p>
                    <#--<p class="infoTip h"><span class="fl">提示：价格的发布和修改有可能会有延迟，如果出现敬请谅解</span> <span class="fr">请确保您填写的商品信息符合 <em class="blue">京东开放平台 商品价格规范</em></span></p>-->
                        <div class="infoListDetils">
                            <div class="detilsList"><label><em class="red">*</em>名称：</label><input type="text" id="goodsName" placeholder=""></div>
                        <#--<div class="detilsList"><label><em class="red">*</em>商品编码：</label><input type="text" id="sku" placeholder=""></div>-->
                            <div class="detilsList"><label><em class="red">*</em>重量：</label><input type="text" id="weight" placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>产地：</label><input type="text" id="productArea" placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>条形码：</label><input type="text" id="upc" placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>销售单位：</label><input type="text" id="saleUnit" placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>包装清单：</label><input type="text" id="wareQD" placeholder=""></div>
                            <div class="detilsList"><label><em class="red">*</em>库存：</label><input type="text" id="stockCount" placeholder=""></div>
                        <#--<div class="detilsList"><label><em class="red">*</em>售后类型：</label><input type="text" id="postSalePolicy" placeholder=""></div>-->
                            <div class="detilsList"><label><em class="red">*</em>协议价：</label><input type="text" id="costPrice" placeholder=""></div>
                        <#--<div class="detilsList"><label><em class="red">*</em>销售价：</label><input type="text" id="salePrice" placeholder=""></div>-->
                            <div class="detilsList"><label><em class="red">*</em>市场价：</label><input type="text" id="marketPrice" placeholder=""></div>
                        </div>
                    </div>
                </div>

                <div class="infoList goodsInfo" style="overflow: hidden;display: none;">
                    <p class="infoTit">图片管理</p>
                    <!--<p class="infoTip h"><span class="fl">提示：价格的发布和修改有可能会有延迟，如果出现敬请谅解</span> <span class="fr">请确保您填写的商品信息符合 <em class="blue">京东开放平台 商品价格规范</em></span></p>-->
                    <div class="infoListDetils">
                        <div class="detilsList imgList file-uploads-group"><label><em class="red">*</em>商品图片：</label><div class="file-upload-content">
                            <div id="fileinput-container">
                            </div>
                            <span class="add-fileinput-button iconfont" style="display: none;">&#xe624;</span>
                        </div>
                        </div>
                    </div>

                </div>
                <div class="infoList goodsInfo" style="display: none;">
                    <p class="infoTit">商品描述</p>
                    <!--<p class="infoTip h"><span class="fl">提示：价格的发布和修改有可能会有延迟，如果出现敬请谅解</span> <span class="fr">请确保您填写的商品信息符合 <em class="blue">京东开放平台 商品价格规范</em></span></p>-->
                    <div class="infoListDetils">
                        <div class="detilsList imgList"><label><em class="red">*</em>详情：</label><div class="proDetils">
                        <textarea class="" id="description" name="description" rows="10" cols="80" style="width: 100%;">

                        </textarea>
                        </div>
                        </div>
                    </div>

                </div>
                <div class="submitBtn" style="margin: 0 auto;text-align:center; width: 30%;margin-bottom: 30px;">
                    <div style="display: inline-block;margin-right: 30px;color: #199eda; border: 1px solid #199eda;background: transparent;" class="reChoice " onclick="ProductEditFunc.setGoodsDatas()">暂存商品</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <div class="reChoice" style="display: inline-block" onclick="saveProduct()">保存并提交产品</div>
                </div>
            </div>
            <div class="reportResultCoverLayer coverLayer f-hide" id="message-modal">
                <div class="reprotLayer">
                    <div class="receiverTitle">
                        <h5 class="title">温馨提示</h5>
                        <span class="icon iconfont closeBtn"></span>
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
            <!--</div>-->
            <input type="hidden" name="productCategoryId" id="productCategoryId" value="<#--22d4ed2f-5160-429a-b517-7112ed26465c-->${productCategoryId!}">
            <input type="hidden" name="productModelSku" id="productModelSku" value="">
            <input type="hidden" name="modelId" id="modelId" value="">
            <input type="hidden" name="goodsSku" id="goodsSku" value="${goodsSku!}">
            <input type="hidden" name="brandId" id="brandId" value="">
            <input type="hidden" name="specification" id="specification" value="">
            <input type="hidden" name="providerGoodsId" id="providerGoodsId" value="${providerGoodsId!}">
        </section>
        <!-- /.content -->
    </div>



<#include "/include/foot.ftl"/>
</div>
<!-- ./wrapper -->
<#include "/include/resource.ftl"/>
<script type="text/javascript" src="${c_static}/lte/plugins/ckeditor_4.8.0_standard/ckeditor.js"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/jQuery/fileuploader/js/vendor/jquery.ui.widget.js')}"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.iframe-transport.js')}"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload.js')}"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload-process.js')}"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/jQuery/fileuploader/js/jquery.fileupload-validate.js')}"></script>
<script type="text/javascript" src="${c_static}${_v('/plugins/artTemplate/template.js')}"></script>
<#--
<script src="js/jquery1.11.2.min.js"></script>-->

<script id="uploadImage_" type="text/html">
    <div class="fileupload">
        <span class="fileinput-button">{{title}}</span>
        <span class="fileinput-name">{{if uploading}}上传中...{{else}}{{fileName}}{{/if}}</span>
    <#--<span class="addFileButton iconfont" style=""></span>-->
        <span class="del-fileinput-button iconfont" onclick="bindFileuploadDelEvents(this)" rel-idx="{{idx}}" style="{{if showDelBtn}}{{else}}display:none;{{/if}}z-index:{{999 - idx}}">-</span>
        <input class="fileupload-input" type="file"
               style="float: left;position: relative;top: -36px;z-index: 998;width: 326px;font-size: 0px;cursor: pointer;height: 100%;opacity: 0;"
               data-fileupload-idx="{{idx}}"
               data-uploading="{{if uploading}}true{{else}}false{{/if}}"
               data-url="{{uploadUrl}}" value="{{filePath}}"/>
    </div>
</script>

<script>
    var v = new Date().getFullYear() + "" + (new Date().getMonth() + 1) + "" + new Date().getDate();
    document.write("<script type='text/javascript' src='${p_static}/admin/js/product/storeBasicInfo.js?v=" + v + "'><\/script>");
</script>


<script id="productBrand_" type="text/html">
    <option value="" selected="selected">请选择</option>
    {{if data}}
    {{each data as brand i}}
    <option value="{{brand.id}}">{{brand.name}}</option>
    {{/each}}
    {{/if}}
</script>

<script id="productStandard_" type="text/html">
    {{if data}}
    {{each data as standard i}}
    <div class="detilsList"><label style="vertical-align: top;" class="standardName">{{standard.name}}</label>
        <div style="width: 50%;display: inline-block;">
            {{each standard.list as val i}}
            &nbsp;&nbsp;<span><input class="standardValue" onchange="lockStandardInput(this);" type="checkbox" value="{{val.attrValue}}"><input type="text"  value="{{val.attrValue}}" /></span>&nbsp;&nbsp;
            {{/each}}
        </div>
    </div>
    {{/each}}
    {{/if}}
</script>

<script>
    var editorTxt = CKEDITOR.replace('description');

    var goodsTables;
    //showMessage({message: "请选择供应商联系人"});
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

    function lockStandardInput(obj){
        if($(obj).is(":checked")){
            var standardValue = $(obj).parent().find("input[type='text']").val();
            if(standardValue ==  undefined || standardValue == ""){
                showMessage({message: "请先填写该规格"});
                $(obj).removeProp("checked");
                return;
            }
            $(obj).val(standardValue);
            $(obj).parent().find("input[type='text']").prop("readOnly",true);
            $(obj).parent().find("input[type='text']").css("background-color","rgb(233,233,233)");
        } else {
            $(obj).parent().find("input[type='text']").removeProp("readOnly");
            $(obj).parent().find("input[type='text']").css("background-color","white");
        }
        showGoodsTable()
    }

    function showGoodsTable(){
        var standardListDiv = $("#productStandardDiv").find(".detilsList");
        var standardList = new Array;
        var isShow = true;
        var titleVals = new Array;
        for(var i = 0; i < standardListDiv.length; i++){
            titleVals.push($(standardListDiv.get(i)).find(".standardName").text());
            var checkedInput = $(standardListDiv.get(i)).find("input:checkbox:checked");
            if(checkedInput && checkedInput.length < 1){
                isShow = false;
                break;
            }else{
                var standardValueList = new Array;
                for(var j = 0; j < checkedInput.length; j++){
                    var standardValue = $(checkedInput.get(j)).parent().find("input[type='text']").val();
                    standardValueList.push(standardValue)
                }
                standardList.push(standardValueList);
            }
        }

        if(isShow){
            $(".goodsList").show();
            $("#goodsTableDiv").show();
            var standardGoods = splitMain(standardList);
            var titiles = new Array;
            var tableData = new Array;
            if(standardGoods.length>0){
                for(var i = 0; i < titleVals.length; i++){
                    titiles.push({title:titleVals[i]})
                }
                var rowCount = 0;
                titiles.push({title:"操作"})
                for(var i = 0; i < standardGoods.length; i++){
                    var columns = standardGoods[i].split("||");
                    var columnDatas = new Array;
                    for(var j = 0; j < columns.length; j++){
                        columnDatas.push(columns[j])
                        if(j == columns.length-1){
                            columnDatas.push(standardGoods[i])
                            rowCount = j+1;
                        }
                    }
                    tableData.push(columnDatas);
                }

                GoodsTableFunc.createGoodsTable(titiles,tableData);
            }

        }else{
            $(".goodsList,.goodsInfo").hide();
            $("#goodsTableDiv").hide();
        }
    }

    $(function(){

        $.ajax({
            url:"getCategoryInfo",
            data:{productCategoryId:$("#productCategoryId").val()},
            success:function(data){
                if(data.status == "success"){
                    var cateList = $(".categoryName");
                    var categoryNames = data.data.categoryNames;
                    for (var i = 0;i<cateList.length;i++) {
                        $(cateList.get(i)).text(categoryNames[i]);
                    }

                    $("#brandId").html(template('productBrand_', {data:data.data.brands}));
                    $("#productStandardDiv").html(template('productStandard_', {data:data.data.standards}));

                    $(".standardValue").change(function(){
                        if(!$(this).is(":checked")){
                            if(window.confirm("此操作将会删除该规格下所有商品信息,您确定删除吗?")){
                                var len = goodsDatas.length-1;
                                //start from the top
                                if(len>=0){
                                    for(var i=len;i>=0;i--) {
                                        if (goodsDatas[i].stardard.indexOf($(this).val())>=0) {
                                            if(goodsDatas[i] && goodsDatas[i].sku != ""){
                                                delGoodsDatas.push(goodsDatas[i].sku);
                                            }
                                            goodsDatas.splice(i, 1);
                                        }
                                    }
                                }

                            }else{
                                $(this).prop("checked",true);
                                showGoodsTable();
                            }
                        }
                    });

                }
            },
            error:function(e){

            }
        })

        /*$.ajax({
            url:"getStandard",
            data:{productCategoryId:$("#productCategoryId").val()},
            success:function(data){
                if(data.status == "success"){
                    $("#productStandardDiv").html(template('productStandard_', data));
                }
            },
            error:function(e){

            }
        })*/
        setTimeout("loadPage()",500);

    })

    function loadPage(){
        if($("#goodsSku").val() && $("#goodsSku").val()!=""){
            $.ajax({
                url:"findProviderGoods",
                data:{goodsSku:$("#goodsSku").val()},
                success:function(data){
                    console.log(data);
                    if(data.status == "success"){
                        var providerGoodsList = data.data.providerGoodsList;
                        for (var goods of providerGoodsList) {
                            var specifications = [];
                            for (var goodsSpecification of goods.providerGoodsSpecifications) {
                                specifications.push(goodsSpecification.value);
                                $("input[value='"+goodsSpecification.value+"']").attr("checked",true);
                            }
                            goods.stardard = specifications.join("||");
                        }
                        goodsDatas = providerGoodsList;
                        ProductEditFunc.setProductModel(data.data.productModel);
                        ProductEditFunc.setGoods2Ducument(data.data.providerGoods);
                        showGoodsTable();
                        $(".goodsInfo").show();
                    }
                },
                error:function(e){

                }
            })
        }else{
            addFileUploader(fileUploadViewModel, 0);
        }
    }

    //用于操作产品详情的符文本框
    var ProductDetailFunctionBundle = {
        getCkeditorHtmlMsgByID: function (ckeditorid) {
            var ckinstance = eval("CKEDITOR.instances." + ckeditorid);
            var text = ckinstance.getData();
//                alert(text);
            return text;
        },
        setCkeditorHtmlMsgByID: function (ckeditorid, msg) {
            var ckinstance = eval("CKEDITOR.instances." + ckeditorid);
            ckinstance.setData(msg);
        },
        getCkeditorHtmlMsg: function () {
            var ckinstance = CKEDITOR.instances.description;
            var text = ckinstance.getData();
            return text;
        },
        setCkeditorHtmlMsg: function (msg) {
            var ckinstance = CKEDITOR.instances.description;
            ckinstance.setData(msg);
        },
        testCkeditor: function () {
            this.setCkeditorHtmlMsg(this.getCkeditorHtmlMsg());
        }
    };


    function splitArray(arr, depth) {
        for (var i = 0; i < arr[depth].length; i++) {
            result[depth] = arr[depth][i]
            if (depth != arr.length - 1) {
                splitArray(arr, depth + 1);
            } else {
                results.push(result.join('||'));
            }
        }
    }

    function splitMain(arr) {
        results = [];
        result = [];
        splitArray(arr, 0);
        //console.log(content.length, content);
        return results;
    }

    function editButton(id){
        ProductEditFunc.setGoodsVoid();
        $(".goodsInfo").show();
        $("#specification").val(id);
        var goodsData;
        for(var i = 0; i < goodsDatas.length;i++){
            if(goodsDatas[i].stardard == id){
                goodsData = goodsDatas[i];
                break;
            }
        }
        if(goodsData){
            ProductEditFunc.setGoods2Ducument(goodsData);
        }

    }

    var goodsDatas = new Array;
    var delGoodsDatas = new Array;

    var ProductEditFunc = {
        getProductModel:function(){
            if(!ProductEditFunc.modelValidate(true)){
                return false;
            }
            var providerProductModel = {};
            providerProductModel.categoryId = $("#productCategoryId").val();
            providerProductModel.modelSku = $("#productModelSku").val();
            providerProductModel.modelId = $("#modelId").val();
            providerProductModel.name = $("#modelName").val();
            providerProductModel.brandId = $("#brandId").val();
            return providerProductModel;
        },
        modelValidate:function(showPop){
            var modelName =$("#modelName").val();
            var brandId = $("#brandId").val();
            if(modelName == undefined || modelName == ""){
                if(showPop){
                    showMessage({message: "请填写产品名称"});
                    return false;
                }
            }
            if(brandId == undefined || brandId == ""||brandId == ""){
                if(showPop){
                    showMessage({message: "请选择产品品牌"});
                    return false;
                }
            }
            return true;
        },
        setGoodsDatas:function(){
            if(!ProductEditFunc.goodsDataValidate(true)){
                return false;
            }
            $(".goodsInfo").hide();
            var goodsData = {};
            var providerGoodsId
            var goodsName = $("#goodsName").val();
            var sku = $("#sku").val();
            var weight = $("#weight").val();
            var productArea = $("#productArea").val();
            var upc = $("#upc").val();
            var saleUnit = $("#saleUnit").val();
            var wareQD = $("#wareQD").val();
            var stockCount = $("#stockCount").val();
            var costPrice = $("#costPrice").val();
            /*var postSalePolicy = $("#postSalePolicy").val();*/
            var productModelSku = $("#productModelSku").val();
            var specification = $("#specification").val();
            var goodsSku = $("#goodsSku").val();
            var marketPrice = $("#marketPrice").val();

            goodsData.id = providerGoodsId;
            goodsData.sku =sku;
            goodsData.modelSku = productModelSku
            goodsData.weight = weight
            goodsData.name = goodsName;
            goodsData.productArea = productArea;
            goodsData.upc = upc;
            goodsData.sku = goodsSku;
            goodsData.saleUnit = saleUnit;
            goodsData.marketPrice = marketPrice;
            goodsData.wareQD = wareQD;
            goodsData.costPrice =costPrice;
            goodsData.stockCount = stockCount;
            /*goodsData.postSalePolicy=postSalePolicy;*/
            goodsData.brandName = $("#brandId option:selected").text();
            goodsData.stardard = specification;
            var specifications = specification.split("||");
            var goodsSpecs = new Array;
            for(var i = 0; i < specifications.length; i++){
                var goodSpec = {};
                goodSpec.standardCode = $($(".standardName").get(i)).text();
                goodSpec.value = specifications[i];
                goodsSpecs.push(goodSpec)
            }

            goodsData.providerGoodsSpecifications = goodsSpecs;

            var pics = [];
            var picPaths =  fileUploadViewModel.fileinputs;
            for(var i = 0;i<picPaths.length;i++){
                var picTmp = {};
                if(i=0){
                    picTmp.isPrimary = "1";
                }else{
                    picTmp.isPrimary = "0";
                }
                picTmp.path = picPaths[i].filePath;
                picTmp.type = "0";
                picTmp.orderSort = i;
                pics[i] = picTmp;
            }
            goodsData.pics = pics;
            goodsData.introduction = ProductDetailFunctionBundle.getCkeditorHtmlMsg();
            if(goodsDatas.length>0){
                var spliceFlag = true;
                for(var i = 0; i < goodsDatas.length;i++){
                    if(goodsDatas[i].stardard == specification){
                        goodsDatas.splice(i,1,goodsData);
                        spliceFlag = false;
                        break;
                    }
                }
                if(spliceFlag){
                    goodsDatas.push(goodsData);
                }
            }else{
                goodsDatas.push(goodsData);
            }
            ProductEditFunc.setGoodsVoid();
            $(".tableStandard[value='"+specification+"']").prop("checked",true);
        },
        setGoods2Ducument:function(data){
            goodsData = data;
            $("#goodsName").val(goodsData.name);
            $("#weight").val(goodsData.weight);
            $("#productArea").val(goodsData.productArea);
            $("#upc").val(goodsData.upc);
            $("#saleUnit").val(goodsData.saleUnit);
            $("#wareQD").val(goodsData.wareQD);
            $("#stockCount").val(goodsData.stockCount);
            $("#costPrice").val(goodsData.costPrice);
            /*$("#postSalePolicy").val(goodsData.postSalePolicy);*/
            $("#productModelSku").val(goodsData.modelSku);
            $("#goodsSku").val(goodsData.sku);
            $("#marketPrice").val(goodsData.marketPrice);

            //规格组合
            var specifications = [];
            for (var goodsSpecification of goodsData.providerGoodsSpecifications) {
                specifications.push(goodsSpecification.value);
            }
            $("#specification").val(specifications.join("||"));

            var pics = goodsData.pics;
            $("#fileinput-container").html("");
            fileUploadViewModel.fileinputs = [];
            for(var i = 0; i<pics.length;i++){
                var model = {
                    title: "请选择文件",
                    showDelBtn: i > 0,
                    idx: i,
                    fileName: pics[i].path,
                    filePath: pics[i].path,
                    uploading: false
                };
                fileUploadViewModel.fileinputs.push(model);
                addFileUploader(fileUploadViewModel, i);
            }
            CKEDITOR.instances.description.setData(goodsData.introduction);
        },
        setProductModel:function(data){
            providerProductModel = data;
            $("#productCategoryId").val(providerProductModel.categoryId);
            $("#productModelSku").val(providerProductModel.modelSku);
            $("#modelId").val(providerProductModel.modelId);
            $("#modelName").val(providerProductModel.name);
            $("option[value='"+providerProductModel.brandId+"']").attr("selected",true);
            /* = $("#brandId").val();*/
        },
        setGoodsVoid:function(){
            $("#goodsName").val("");
            $("#weight").val("");
            $("#productArea").val("");
            $("#upc").val("");
            $("#saleUnit").val("");
            $("#wareQD").val("");
            $("#stockCount").val("");
            $("#costPrice").val("");
            /*$("#postSalePolicy").val("");*/
            $("#goodsSku").val("");
            $("#marketPrice").val("");
            $("#providerGoodsId").val("");
            $("#goodsSku").val("");
            $("#specification").val("");
            ProductDetailFunctionBundle.setCkeditorHtmlMsg("");
            $("#fileinput-container").html("");
            fileUploadViewModel.fileinputs = [];
            var model = {
                title: "请选择文件",
                showDelBtn: 0 > 0,
                idx: 0,
                fileName: "",
                filePath: "",
                uploading: false
            };
            fileUploadViewModel.fileinputs.push(model);
            addFileUploader(fileUploadViewModel, 0);

        },
        goodsDataValidate:function(showPop){
            var goodsName = $("#goodsName").val();
            var weight = $("#weight").val();
            var productArea = $("#productArea").val();
            var saleUnit = $("#saleUnit").val();
            var wareQD = $("#wareQD").val();
            var stockCount = $("#stockCount").val();
            var costPrice = $("#costPrice").val();
            /*var postSalePolicy = $("#postSalePolicy").val();*/
            var marketPrice = $("#marketPrice").val();
            var introduction = ProductDetailFunctionBundle.getCkeditorHtmlMsg();
            if(goodsName == undefined || goodsName == ""){
                if(showPop){
                    showMessage({message: "请填写商品名称"});
                    return false;
                }
            }
            if(weight == undefined || weight == ""){
                if(showPop){
                    showMessage({message: "请填写商品重量"});
                    return false;
                }
            }
            if(productArea == undefined || productArea == ""){
                if(showPop){
                    showMessage({message: "请填写商品产地"});
                    return false;
                }
            }
            /*if(saleUnit == undefined || saleUnit == ""){
                if(showPop){
                    showMessage({message: ""});
                    return false;
                }
            }*/
            if(wareQD == undefined || wareQD == ""){
                if(showPop){
                    showMessage({message: "请填写商品清单"});
                    return false;
                }
            }
            if(stockCount == undefined || stockCount == ""){
                if(showPop){
                    showMessage({message: "请填写商品库存"});
                    return false;
                }
            }
            if(costPrice == undefined || costPrice == ""){
                if(showPop){
                    showMessage({message: "请填写协议价"});
                    return false;
                }
            }
            /*if(postSalePolicy == undefined && postSalePolicy == "请填写商品"){
                if(showPop){
                    showMessage({message: ""});
                    return false;
                }
            }*/
            if(marketPrice == undefined || marketPrice == ""){
                if(showPop){
                    showMessage({message: "请填写市场价"});
                    return false;
                }
            }
            var picPaths = fileUploadViewModel.fileinputs;
            for(var i = 0;i < picPaths.length;i++){
                if(picPaths[i].filePath == ""){
                    showMessage({message: "请上传图片"});
                    return false;
                }
            }
            if(introduction == undefined || introduction == ""){
                if(showPop){
                    showMessage({message: "请录入商品详情"});
                    return false;
                }
            }
            return true;
        }
    }

    var GoodsTableFunc = {
        createGoodsTable:function(titles,tableDatas){
            var table = "<table id='goodsTable'><thead>"

            for(var i = 0 ;i<titles.length ; i++){
                if(i == 0){
                    table = table + "<th></th>";
                }
                table = table + "<th>"+titles[i].title+"</th>";
            }

            table = table + "</thead><tbody>";

            for(var i = 0 ;i<tableDatas.length ; i++){
                var data = tableDatas[i];
                table = table+"<tr>";
                for(var j = 0 ;j<data.length ; j++){
                    if(j == 0){
                        table = table + "<td><input class='tableStandard' type='checkbox' value='"+data[data.length-1]+"'></td>";
                    }
                    if(j == data.length - 1){
                        table = table + '<td><a href="javascript:void(0)" class="editGoods" onclick="editButton(\''+data[j]+'\')">编辑</a></td>';
                    }else{
                        table = table + "<td>"+data[j]+"</td>";
                    }
                }
                table = table+"</tr>";
            }
            table = table +"</tbody></table>"
            $("#goodsTableDiv").html(table);
            for(var i = 0; i < goodsDatas.length; i++){
                $(".tableStandard[value='"+goodsDatas[i].stardard+"']").attr("checked",true);
            }
            $(".tableStandard").change(function(){
                if(!$(this).is(":checked")){
                    if(window.confirm("此操作将会删除该规格所有信息,您确定删除吗?")){
                        var len = goodsDatas.length-1;
                        //start from the top
                        if(len>=0){
                            for(var i=len;i>=0;i--) {
                                if (goodsDatas[i].stardard.indexOf($(this).val())>=0) {
                                    if(goodsDatas[i] && goodsDatas[i].sku != ""){
                                        delGoodsDatas.push(goodsDatas[i].sku);
                                    }
                                    goodsDatas.splice(i, 1);
                                }
                            }
                        }

                    }else{
                        $(this).prop("checked",true);
                    }
                }
            });

        }

    }

    <#if remark != 'productView'>
        function saveProduct(){
            var providerProductModel = ProductEditFunc.getProductModel();
            if(!providerProductModel){
                return false;
            }
            if(goodsDatas.length == 0){
                showMessage({message: "产品下没有商品信息，请添加商品信息"});
                return false;
            }
            var url = "addProduct";
            if("${remark!}" == "edit"){
                url = "editProduct";
            }
            $.ajax({
                url:url,
                type:"POST",
                contentType:"application/json",
                datatype:"json",
                data:JSON.stringify({
                    productModel:providerProductModel,
                    providerGoodses:goodsDatas,
                    delGoodses:delGoodsDatas
                }),
                success:function(data){
                    if(data.status == "success"){
                        window.location.href="/store-admin/login/goodsList";
                    }else{
                        showMessage({message: data.message});
                    }
                },
                error:function(e){

                }
            })
        }
    <#else>
        setTimeout("disabledData()",1000);
        function disabledData(){
            $("input,select,textarea").attr("disabled",true);
            $("input,select,textarea").attr("readOnly",true);
            $(".submitBtn").hide();
        }
    </#if>

    function reChooseCategory(){
        if(window.confirm("此操作将不保留现有的信息,您确定重选吗?")){
            window.location.href="chooseCategory";
        }
    }

</script>
</body>
</html>
