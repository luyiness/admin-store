layui.use('upload', function () {
    var $ = layui.jquery, upload = layui.upload;
});

//弹框 icon 为1时 对号 为2时 叉号
function showMsg(msg, icon) {
    layer.alert(msg, {icon: icon});
}

var specialRuleIndex = 1;
var provinceCheckArr = new Array();
var specialRuleMap = new Map();

//新增一列特殊规则
function addSpecialRule() {
    var data = [];
    data.rindex = specialRuleIndex;
    var temp = template('newSpecialRuleId_', {data: data});
    $("#specialRuleId" + (specialRuleIndex - 1)).parent().append(temp);
    specialRuleIndex += 1;
}

function delSpecialRuleAjax(specialRuleId) {
    layer.open({
        type: 1,
        anim: 5,
        title: "提示",
        offset: '90px',
        area: ['350px', '200px'],
        shadeClose: true,
        btn: ['确定', '取消'],
        async: false,
        btnAlign: 'c',
        btn1: function (index, layero) {
            layer.close(layer.index);
            $.ajax({
                url: 'delSpecialRule',
                type: "POST",
                contentType: "application/json",
                datatype: "json",
                data: JSON.stringify({
                    storeFreightRuleDtos: specialRuleMap.get(specialRuleId)
                }),
                success: function (data) {
                    if (data.success) {
                        deleteOneLine(specialRuleId);
                    } else {
                        showMsg("删除失败", 2)
                    }
                },
                error: function (e) {
                    showMsg("请求出错,请联系管理员", 2);
                }
            });
        },
        content: "<div style='width: 335px;height: 100px;text-align: center;'>" +
            "</br></br>确定要删除吗" +
            "</div>"
    });
}

//移除一列特殊规则
function delSpecialRule(thisDiv) {
    var specialRuleList = $(".specialRuleClass");
    if (specialRuleList.length < 1) {
        return;
    }
    var specialRuleId = $(thisDiv).parent().parent().attr('id');
    if (specialRuleMap.get(specialRuleId) == undefined
        || specialRuleMap.get(specialRuleId) == "") {
        deleteOneLine(specialRuleId);
    } else {
        var idNum = specialRuleId.substring(13, specialRuleId.length);
        if ($("#pinkageId" + idNum).val() == undefined
            || $("#pinkageId" + idNum).val() == ""
            || $("#unPinkageId" + idNum).val() == undefined
            || $("#unPinkageId" + idNum).val() == "") {
            deleteOneLine(specialRuleId);
        } else {
            delSpecialRuleAjax(specialRuleId);
        }
    }
}

function deleteOneLine(specialRuleId) {
    specialRuleMap.delete(specialRuleId);
    flushProvinceCheckArr();
    // $("#" + specialRuleId).remove();
    $("#" + specialRuleId).css('display', 'none');
    $("#" + specialRuleId).removeClass('specialRuleClass');
    var specialRuleList = $(".specialRuleClass");
    if (specialRuleList.length < 1) {
        addSpecialRule();
    }
}

function choiceAreas(thisDiv) {
    var specialRuleId = $(thisDiv).parent().parent().attr('id');
    $.ajax({
        url: 'findAllProvince',
        success: function (data) {
            //使用过和未使用的地址状态区分
            var provinceCheckThisArr = specialRuleMap.get(specialRuleId);
            for (var i = 0; i < data.length; i++) {
                provinceCheckArr.forEach(value => {
                    if (value.id == data[i].id
                        || value.levelOneAddressCode == data[i].id) {
                        data[i].isCheck = 'disabled';
                    }
                });
                if (provinceCheckThisArr != undefined) {
                    provinceCheckThisArr.forEach(value => {
                        if (value.id == data[i].id
                            || value.levelOneAddressCode == data[i].id) {
                            data[i].isCheck = '';
                            data[i].isChecked = 'checked';
                        }
                    });
                }
            }
            var temp = template('choiceAreas_', {data: data});
            layer.open({
                type: 1,
                anim: 5,
                title: "选择地区",
                offset: '90px',
                area: ['700px', '400px'],
                shadeClose: true,
                btn: ['确定', '取消'],
                btnAlign: 'c',
                btn1: function (index, layero) {
                    getsTheAddressNormallyTicked(thisDiv);
                    layer.close(layer.index);
                },
                content: temp
            });
        }
    });
}

//获取正常勾选的地址
function getsTheAddressNormallyTicked(thisDiv) {
    var provinceChecks = $(".provinceCheckboxClass");
    var provinceCheckThisArr = new Array();
    for (var i = 0; i < provinceChecks.length; i++) {
        if (provinceChecks[i].checked) {
            provinceCheckThisArr.push(provinceChecks[i]);
        }
    }
    var specialRuleId = $(thisDiv).parent().parent().attr('id');
    specialRuleMap.set(specialRuleId, provinceCheckThisArr);
    flushProvinceCheckArr();
    var provinces = "";
    provinceCheckThisArr.forEach(value => {
        var province = value.value;
        provinces += (province + "、");
    });
    var temp = mosaicApplicableAreaPage(provinces);
    $("#" + specialRuleId + "Address").html(temp);
}

function flushProvinceCheckArr() {
    provinceCheckArr = new Array();
    specialRuleMap.forEach(value => {
        for (var i = 0; i < value.length; i++) {
            provinceCheckArr.push(value[i]);
        }
    });
}

function showEditTable() {
    $("#editButtonId").css('display', 'none');
    $(".popBtnC").css('display', '');
    $("#sFreightRuleLabelId").css('display', '');

    //通用规则
    var nfreePrice = "";
    var nfreightPrice = "";
    if ($("#nFreightRuleId").val() != undefined
        && $("#nFreightRuleId").val() != ""
        && $("#nFreightRuleId").val() != null) {
        var nFreightRule = JSON.parse($("#nFreightRuleId").val());
        nfreePrice = nFreightRule.freePrice;
        nfreightPrice = nFreightRule.freightPrice;
    }
    $("#editNfreePrice").val(nfreePrice);
    $("#editNfreightPrice").val(nfreightPrice);
    $("#normalrRuleShowId").css('display', 'none');
    $("#editNormalrRuleShowId").css('display', '');

    //特殊规则
    if ($("#sFreightRuleId").val() != undefined
        && $("#sFreightRuleId").val() != ""
        && $("#sFreightRuleId").val() != null) {
        $("#specialRuleId0").css('display', 'none');
        $("#specialRuleId0").removeClass('specialRuleClass');
        specialRuleMap = new Map();
        var sFreightRule = _jsonToMap($("#sFreightRuleId").val());
        var newSpecialRuleId_temps = new Array();
        var specialRuleAddress_temps = new Array();
        sFreightRule.forEach(value => {
            var levelOneAddressNames = "";
            for (var i = 0; i < value.length; i++) {
                levelOneAddressNames += (value[i].levelOneAddressName + "、");
            }
            value[0].rindex = specialRuleIndex;
            var newSpecialRuleId_temp = template('newSpecialRuleId_', {data: value[0]});
            newSpecialRuleId_temps.push(newSpecialRuleId_temp);
            var specialRuleAddress_temp = mosaicApplicableAreaPage(levelOneAddressNames);
            specialRuleAddress_temps.push(specialRuleAddress_temp);
            specialRuleMap.set("specialRuleId" + specialRuleIndex, value);
            specialRuleIndex += 1;
        });
        for (var i = 0; i < specialRuleIndex; i++) {
            $("#specialRuleId" + i).parent().append(newSpecialRuleId_temps[i]);
            $("#specialRuleId" + (i + 1) + "Address").html(specialRuleAddress_temps[i]);
        }
        flushProvinceCheckArr();
    }
    $("#specialRulesTableId").css('display', '');
    $(".showSpecialRulesTableId").css('display', 'none');
}

function _objToStrMap(obj) {
    let strMap = new Map();
    for (let k of Object.keys(obj)) {
        strMap.set(k, obj[k]);
    }
    return strMap;
}

/**
 *json转换为map
 */
function _jsonToMap(jsonStr) {
    return this._objToStrMap(JSON.parse(jsonStr));
}

//根据地址串拼接适用地区模板页面
function mosaicApplicableAreaPage(provinces) {
    var substring = "";
    if (provinces.length > 0) {
        substring = provinces.substring(0, provinces.length - 1);
    }
    var temp = template('specialRuleAddress_', {data: substring});
    return temp;
}

//数字校验
function isRealNum(val) {
    // isNaN()函数 把空串 空格 以及NUll 按照0来处理 所以先去除
    if (val === "" || val == null) {
        return false;
    }
    if (!isNaN(val)) {
        return true;
    } else {
        return false;
    }
}

function saveSpecialRule() {
    var storeFreightRules = new Array();
    var realNum = true;
    //通用规则
    var nFreightRuleDto = {};
    // 规则类型 1 为通用规则  2 为特殊规则
    nFreightRuleDto.ruleType = "1";
    // 包邮金额 （大于、等于此金额享受包邮服务）
    if ($("#editNfreePrice").val() != undefined
        && $("#editNfreePrice").val() != "") {
        if ($("#editNfreightPrice").val() == undefined
            || $("#editNfreightPrice").val() == "") {
            showMsg("请输入不包邮运费金额", 2);
            return;
        }
        realNum = isRealNum($("#editNfreePrice").val());
        if (!realNum) {
            showMsg("只能输入数字", 2);
            return;
        }
    }
    nFreightRuleDto.freePrice = $("#editNfreePrice").val();
    // 运费 （不足包邮价需要付此金额邮费）
    if ($("#editNfreightPrice").val() != undefined
        && $("#editNfreightPrice").val() != "") {
        if ($("#editNfreePrice").val() == undefined
            || $("#editNfreePrice").val() == "") {
            showMsg("请输入包邮金额", 2);
            return;
        }
        realNum = isRealNum($("#editNfreightPrice").val());
        if (!realNum) {
            showMsg("只能输入数字", 2);
            return;
        }
    }
    nFreightRuleDto.freightPrice = $("#editNfreightPrice").val();
    storeFreightRules.push(nFreightRuleDto);

    var isPinkage = false;
    //特殊规则
    specialRuleMap.forEach((value, key) => {
        for (var i = 0; i < value.length; i++) {
            var storeFreightRuleDto = {};
            var idNum = key.substring(13, key.length);
            // 规则类型 1 为通用规则  2 为特殊规则
            storeFreightRuleDto.ruleType = "2";
            // 包邮金额 （大于、等于此金额享受包邮服务）
            if ($("#pinkageId" + idNum).val() == undefined
                || $("#pinkageId" + idNum).val() == "") {
                isPinkage = true;
                break;
            } else {
                realNum = isRealNum($("#pinkageId" + idNum).val());
                if (!realNum) {
                    break;
                }
            }
            storeFreightRuleDto.freePrice = $("#pinkageId" + idNum).val();
            // 运费 （不足包邮价需要付此金额邮费）
            if ($("#unPinkageId" + idNum).val() == undefined
                || $("#unPinkageId" + idNum).val() == "") {
                isPinkage = true;
                break;
            } else {
                realNum = isRealNum($("#unPinkageId" + idNum).val());
                if (!realNum) {
                    break;
                }
            }
            storeFreightRuleDto.freightPrice = $("#unPinkageId" + idNum).val();
            // 一级地址代码 省（直辖市、自治区、特别行政区）代码
            if (value[i].levelOneAddressCode == undefined
                || value[i].levelOneAddressCode == "") {
                storeFreightRuleDto.levelOneAddressCode = value[i].id;
            } else {
                storeFreightRuleDto.levelOneAddressCode = value[i].levelOneAddressCode;
            }
            // 一级地址名称 省（直辖市、自治区、特别行政区）名称
            if (value[i].levelOneAddressName == undefined
                || value[i].levelOneAddressName == "") {
                storeFreightRuleDto.levelOneAddressName = value[i].value;
            } else {
                storeFreightRuleDto.levelOneAddressName = value[i].levelOneAddressName;
            }
            storeFreightRules.push(storeFreightRuleDto);
        }
    });
    if (isPinkage) {
        showMsg("有必填项为空,请检查", 2);
        return;
    }
    if (!realNum) {
        showMsg("只能输入数字", 2);
        return;
    } else {
        $.ajax({
            url: "eidtFreightRule",
            type: "POST",
            contentType: "application/json",
            datatype: "json",
            data: JSON.stringify({
                storeFreightRuleDtos: storeFreightRules
            }),
            success: function (data) {
                if (!data.success) {
                    showMsg(data.resultMessage, 2);
                } else {
                    window.location.href = "/store-admin/freightRule/index";
                }
            },
            error: function (e) {
                showMsg("请求出错,请联系管理员", 2);
            }
        });
    }
}

$("#cancelEditShipping").click(function () {
    window.location.href = "/store-admin/freightRule/index";
});
