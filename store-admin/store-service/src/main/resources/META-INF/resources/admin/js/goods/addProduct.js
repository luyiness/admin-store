layui.use('upload', function () {
    var $ = layui.jquery, upload = layui.upload;
});

var last_product_id_style = "";

var brandId;
var brandName;

var isSaveProducts = new Array();

/*checkbox---------------------->*/

function check_checkbox(rCheckbox) {
    var checkboxAllClass = $(".check_checkbox_All_class")[0];
    if (rCheckbox.checked) {
        var rCheckboxClass = new Array();
        var checkboxClass = $(".check_checkbox_class");
        for (var i = 0; i < checkboxClass.length; i++) {
            if (!checkboxClass[i].disabled) {
                rCheckboxClass.push(checkboxClass[i]);
            }
        }
        var isAllCheck = true;
        rCheckboxClass.forEach(value => {
            if (!value.checked) {
                isAllCheck = false;
            }
        });
        if (isAllCheck) {
            checkboxAllClass.checked = true;
        } else {
            checkboxAllClass.checked = false;
        }
    } else {
        checkboxAllClass.checked = false;
    }
}

function check_checkbox_All() {
    var checkboxAllClass = $(".check_checkbox_All_class")[0];
    var rCheckboxClass = new Array();
    var checkboxClass = $(".check_checkbox_class");
    for (var i = 0; i < checkboxClass.length; i++) {
        if (!checkboxClass[i].disabled) {
            rCheckboxClass.push(checkboxClass[i]);
        }
    }
    rCheckboxClass.forEach(value => {
        value.checked = checkboxAllClass.checked;
    });
}

/*全部置为未选中*/
function checkboxCheckFalse() {
    $(".check_checkbox_All_class")[0].checked = false;
    for (var i = 0; i < $(".check_checkbox_class").length; i++) {
        $(".check_checkbox_class")[i].checked = false;
    }
}

/*<----------------------checkbox*/

function nextToBatchSaveProduct() {

    var modelName = $("#modelName").val();
    if ("" == modelName) {
        showMessage({message: "基本内容【产品名称】还未填写完整，请仔细检查后再进行下一步操作。"});
        return;
    }

    var brandName = $("#brandName").val();
    if ("" == brandName) {
        showMessage({message: "基本内容【品牌】还未填写完整，请仔细检查后再进行下一步操作。"});
        return;
    }

    var standardNameForFori = [];
    standardNames.forEach(function (item, index, arr) {
        standardNameForFori.push(item)
    })
    for (var i = 0; i < standardNameForFori.length; i++) {
        var standardName = standardNameForFori[i];
        for (var j = 0; j < standardNameForCheck.length; j++) {
            var standardNameFC = standardNameForCheck[j];
            if (standardName == standardNameFC) {
                standardNameForFori[i] = "";
            }
        }
    }
    if (standardNameForFori.length > 0) {
        for (var i = 0; i < standardNameForFori.length; i++) {
            if (standardNameForFori[i] != "") {
                showMessage({message: "商品属性【" + standardNameForFori[i] + "】还未填写完整，请仔细检查后再进行下一步操作。"});
                return;
            }
        }
    }

    $("#commodityAttributeId").css('display', 'none');
    $("#catalogueId").css('display', '');
    $("#nextToBatchSaveProductId").css('display', 'none');
    $("#batchSaveProductId").css('display', '');
    $("#goBackBatchSaveProductId").css('display', '');

    $(".infoListH").hide();

    showGoodsTable();

    checkboxCheckFalse();

}

function goBackBatchSaveProduct() {
    $(".infoListH").show();
    $("#commodityAttributeId").css('display', '');
    $("#catalogueId").css('display', 'none');
    $("#nextToBatchSaveProductId").css('display', '');
    $("#batchSaveProductId").css('display', 'none');
    $("#goBackBatchSaveProductId").css('display', 'none');
}

//图片管理-在第一张图片后加上 "此图为展示在商品详情页的主图"
function append_main_image_sample() {
    var html_ = document.getElementById("main_image_sample_id");
    $(".del-fileinput-button")[0].parentNode.parentNode.parentNode.append(html_);
}

function editButton(id) {
    if ("${remark!}" == 'productView') {
        return false;
    }
    ProductEditFunc.setGoodsVoid();

    var columns = id.split("||");
    var columnDatas = "";
    for (var j = 0; j < columns.length; j++) {
        columnDatas += columns[j];
    }
    $("#standardValueId").val(escapeJquery(columnDatas.replace(/ /g, "")));

    $(".goodsInfo").show();
    $('.goodsInfoCoverLayer').removeClass('f-hide');

    append_main_image_sample();

    $("#specification").val(id);
    var goodsData;
    for (var i = 0; i < goodsDatas.length; i++) {
        if (goodsDatas[i].stardard == id) {
            goodsData = goodsDatas[i];
            break;
        }
    }
    if (goodsData) {
        ProductEditFunc.setGoods2Ducument(goodsData);
    }

}

function escapeJquery(srcString) {
    // 转义之后的结果
    var escapseResult = srcString;

    // javascript正则表达式中的特殊字符
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
        "]", "|", "{", "}"];

    // jquery中的特殊字符,不是正则表达式中的特殊字符
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
        ":", ";", "<", ">", ",", "/"];

    for (var i = 0; i < jsSpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp("\\" + jsSpecialChars[i], "g"), "");
    }

    for (var i = 0; i < jquerySpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i], "g"), "");
    }

    return escapseResult;
}

function editButtonPush(id) {
    var columns = id.split("||");
    var columnDatas = "";
    for (var j = 0; j < columns.length; j++) {
        columnDatas += columns[j];
    }
    var text = $("#" + escapeJquery(columnDatas.replace(/ /g, ""))).text();
    if (text == "未录入") {
        showMessage({message: "请先录入商品信息"});
        return;
    }

    saveProduct(columnDatas);
}

function saveGoodsInfoCoverLayer(standardValueId) {
    //暂存商品
    var goodsDatas = ProductEditFunc.setGoodsDatas();
    if (goodsDatas == false) {
        return;
    }
    //未录入改为已录入
    $("#" + $("#standardValueId").val()).text("已录入");
    //多选框置为可选
    $("#checkbox_" + standardValueId).attr("disabled", false);
    $("#checkbox_" + standardValueId).addClass("checkchild");
    $("#checkbox_" + standardValueId).attr("checked", false);
    $("#checkbox_All").attr("checked", false);
    $("#checkbox_All").attr("disabled", false);
    //关闭弹窗
    closeGoodsInfoCoverLayer();
}

function closeGoodsInfoCoverLayer() {
    $("#standardValueId").val("");
    $('.goodsInfoCoverLayer').addClass('f-hide');
}

function batchSaveProduct() {
    saveProduct("");
}

function showBrands() {
    findBrand();
    $('.findBrandCoverLayer').removeClass('f-hide');
}

function sureProviderBrand() {
    $("#brandId").val(brandId);
    $("#brandName").val(brandName);
    brandId = "";
    brandName = "";
    sDefi_message_modal_Close();
}

function sDefi_message_modal_Close() {
    $('.findBrandCoverLayer').addClass('f-hide');
    brandDataFlag = false;
    firstLetter = "A";
    $("#brandInfo").html("");
    $("#provider_brand_name").val("");
    $("#product_id").val("");
}

//查询品牌ajax
function findBrand(brandName) {

    $("#brandInfo").html("");

    $.ajax({
        url: STATIC_CTX + "/product/findBrand",
        data: {
            name: brandName,
        },
        type: "POST",
        success: function (rep) {
            if (rep.success) {
                if (rep.result.length > 0) {
                    var html = template("brandShow", {brands: rep.result});
                    $("#brandInfo").append(html);
                    $("#provider_brand_name").focus();
                } else {
                    var html = template("brandShow", {brands: rep.result});
                    $("#brandInfo").html(html);
                }
            } else {
                window.wxc.xcConfirm("品牌查询失败", "error");
            }
        },
        error: function () {
            window.wxc.xcConfirm("品牌查询异常", "error");
        }
    });
}

//选中品牌
function providerBrandSpan(providerBrandId, providerBrandName) {
    brandId = providerBrandId;
    brandName = providerBrandName;
    //改样式
    if (last_product_id_style != "") {
        last_product_id_style.style.backgroundColor = "";
    }
    var provider_brand_id_style = document.getElementById(providerBrandId);
    provider_brand_id_style.style.backgroundColor = "aliceblue";
    last_product_id_style = document.getElementById(providerBrandId);
};
