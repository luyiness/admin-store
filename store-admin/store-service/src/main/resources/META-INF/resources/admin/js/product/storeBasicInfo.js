/**
 * Created by Mmlzi on 2018/8/22.
 */
// 下拉框
function dropNav(obj) {
    if ($(obj).hasClass('no-drop')) {
        return false;
    } else {
        var dropWrapper = $(obj).parents('.drop-wrapper'),
            dropList = dropWrapper.find('.drop-list');
        var $height = $(".drop-select").height();
        var $dropList = $(".drop-list");
        if ($height > 200) {
            $dropList.css("height", "200px").css("overflow-y", "scroll");
        }
        if ($(obj).hasClass("show-list")) {
            dropWrapper.find('.icon-xialajiantou-copy').removeClass('icon-xialajiantou-copy').addClass('icon-xialajiantou');
            dropList.slideUp('300');
            $(obj).removeClass('show-list');
        } else {
            dropWrapper.find('.icon-xialajiantou').removeClass('icon-xialajiantou').addClass('icon-xialajiantou-copy');
            $(obj).addClass('show-list');
            dropList.slideDown('600');
        }
        dropWrapper.mouseleave(function () {
            dropWrapper.find('.icon-xialajiantou-copy').removeClass('icon-xialajiantou-copy').addClass('icon-xialajiantou');
            dropList.slideUp('300');
            $(obj).removeClass('show-list');

        })
    }
}

$(document).on('click', '.drop-select a', function () {
    // debugger
    var selectValue = $(this).html();
    biddingStateCode = $(this).attr("state");
    var dropWrapper = $(this).parents('.drop-wrapper'),
        dropList = dropWrapper.find('.drop-list');
    dropWrapper.find('.select-value>input').val(selectValue);
    dropWrapper.find('.icon-xialajiantou-copy').removeClass('icon-xialajiantou-copy').addClass('icon-xialajiantou');
    dropList.slideUp('300');
});

/** =================文件上传相关 START============== */

var ieVer = function () {
    var rv = -1;
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
};

var fileUploadViewModel = {
    uploadUrl: '/image/api/textjson?compress=true&compressSize=240',
    ieVer: ieVer(),
    fileinputs: [
        { // 默认显示一个
            title: "请选择文件",
            showDelBtn: false,
            idx: 0,
            filePath: "",
            compressFilePath: "",
            uploading: false
        }
    ]
};

$(document).on('click', '.add-fileinput-button', function () {
    //alert('yes');
    var $uploads = $(this).parents('.file-uploads-group').find('.fileupload');
    var curIdx = $uploads.length; // idx 从0开始
    if (curIdx <= 10) {
        var model = {
            title: "请选择文件",
            showDelBtn: curIdx > 0,
            idx: curIdx,
            filePath: "",
            uploading: false
        };
        fileUploadViewModel.fileinputs.push(model);
        addFileUploader(fileUploadViewModel, curIdx);
    } else {
        $('#fileupload-input-counts-overed').removeClass('f-hide').show();
    }
});

var initFileUpload = function ($element) {
    $element.fileupload({
        maxFileSize: 1 * 1024 * 1024, //20M
        acceptFileTypes: /(\.|\/)(gif|jpeg|jpg|png)$/i,
        iframe: ieVer() > 0 && ieVer() < 10,
        dataType: 'text',
        send: function (e, data) {
            $(this).parent().find('.fileinput-name').html('上传中...').text('上传中...').css({color: '#333'});
            ;
            fileUploadViewModel.fileinputs[$element.attr('data-fileupload-idx')].uploading = true;
            $(this).attr('data-uploading', true);
            /** 禁用删除按钮 */
            $(this).parents('.fileupload').find('.del-fileinput-button')
                .addClass('disabled');
        },
        done: function (e, data) {
            data.result = JSON.parse(data.result);
            var $uploads = $('#insured-order-info-form').find('.upload-file-input');
            if (data.result && data.result[0]) {
                var input = $uploads[$(this).attr('data-fileupload-idx')];
                if (!input) {
                    input = $(document.createElement("input")).addClass('upload-file-input')
                        .attr('type', 'hidden')
                        .attr('name', 'uploadFileInputs[]');
                    input.appendTo($('#insured-order-info-form'));
                }
                $(input).val(JSON.stringify(data.result[0]));
                fileUploadViewModel.fileinputs[$(this).attr('data-fileupload-idx')].filePath = data.result[0].absoluteFilePath;
                if (data.result[0].imageCompressVO !== undefined && data.result[0].imageCompressVO !== null) {
                    fileUploadViewModel.fileinputs[$(this).attr('data-fileupload-idx')].compressFilePath = data.result[0].imageCompressVO.absoluteFilePath;
                }

                fileUploadViewModel.fileinputs[$(this).attr('data-fileupload-idx')].fileName = data.files[0].name;

                $(this).parent().find('.fileinput-name').html(data.files[0].name);
                $(this).parent().find('.fileinput-name').text(data.files[0].name);
            }

            $(this).attr('data-uploading', false);
            /** 禁用删除按钮 */
            $(this).parents('.fileupload').find('.del-fileinput-button')
                .removeClass('disabled');
        },
        fail: function (e, data) {
            window.console && $.isFunction(window.console.info) && window.console.info("faild on upload file: %o, %o", e, data);
            $(this).parent().find('.fileinput-name').html('上传失败请重试...').text('上传失败请重试...').css({color: 'red'});
            $(this).attr('data-uploading', false);
            /** 禁用删除按钮 */
            $(this).parents('.fileupload').find('.del-fileinput-button')
                .removeClass('disabled');
            window.setTimeout(function () {
                $(this).parent().find('.fileinput-name').html('').text('').css({color: '#333'});
            }, 5000);
        },
        messages: {
            maxFileSize: '上传文件请勿大于1MB',
            acceptFileTypes: '只能上传图片'
        },
        processfail: function (e, data) {
            failPopShow();
            $(this).attr('data-uploading', false);
            /** 禁用删除按钮 */
            $(this).parents('.fileupload').find('.del-fileinput-button')
                .removeClass('disabled');
        }
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
};

var bindFileuploadDelEvents = function ($el) {
    $el.on("click", function () {
        var delIdx = $el.attr("rel-idx");
        if (!isNaN(delIdx)) {
            delIdx = Number(delIdx);
            delFileUploader(fileUploadViewModel, delIdx);
        }
    });
};

/**
 * 添加一个文件选择
 * @param fileUploadViewModel
 * @param idx 当前操作序号
 */
var addFileUploader = function (fileUploadViewModel, idx) {
    var model = fileUploadViewModel.fileinputs[idx];
    model.uploadUrl = fileUploadViewModel.uploadUrl;
    model.ieVer = ieVer();
    if (model && typeof model != 'undefined') {
        var $uploader = $(template('uploadImage_', model));
        $("#fileinput-container").append($uploader);
        initFileUpload($uploader.find('.fileupload-input'));
        bindFileuploadDelEvents($uploader.find('.del-fileinput-button'));
        if (fileUploadViewModel.fileinputs.length < 10) {
            $('.add-fileinput-button').show();
        } else {
            $('.add-fileinput-button').hide();
        }
        /** 多于一个上传控件时，显示删除按钮 */
        if (fileUploadViewModel.fileinputs.length > 1) {
            $('#fileinput-container')
                .find('.fileupload-input[data-fileupload-idx="0"]')
                .parents('.fileupload').find('.del-fileinput-button').show();
        }
    }
};

/**
 * 删除一个文件选择
 * @param fileUploadViewModel
 * @param idx 当前操作序号
 */
var delFileUploader = function (fileUploadViewModel, idx) {
    var model = fileUploadViewModel.fileinputs[idx];
    var $fileInputs = $('#fileinput-container').find('.fileupload-input');
    if (model && typeof model != 'undefined') {
        var $f = $('#fileinput-container').find('.fileupload-input[data-fileupload-idx="' + idx + '"]');
        if ($f.length > 0 && $f.attr('data-uploading') + '' != 'true') {
            fileUploadViewModel.fileinputs.splice(idx, 1);
            $f.parents('.fileupload').remove();
            $fileInputs = $('#fileinput-container').find('.fileupload-input');
            /** 刷新删除元素后的 idx */
            for (var j = 0; j < $fileInputs.length; j++) {
                /** 重置所有input的序号 */
                var $fileinput = $($fileInputs[j]);
                var $delBtn = $fileinput.parents('.fileupload').find('.del-fileinput-button');
                if (fileUploadViewModel.fileinputs.length <= 1) {
                    $delBtn.hide();
                } else {
                    $delBtn.show();
                }
                fileUploadViewModel.fileinputs[j].idx = j;
                $fileinput.attr('data-fileupload-idx', j);
                $delBtn.attr('rel-idx', j);
                /** 重置z-index */
                $fileinput.css('z-index', 998 - j);
                $delBtn.css('z-index', 999 - j);
            }
            /** 只剩一个上传控件时，隐藏删除按钮 */
            if (fileUploadViewModel.fileinputs.length == 1) {
                $('#fileinput-container').find('.fileupload-input[data-fileupload-idx="0"]')
                    .parents('.fileupload').find('.del-fileinput-button').hide();
            }
            if (fileUploadViewModel.fileinputs.length < 10) {
                $('.add-fileinput-button').show();
            } else {
                $('.add-fileinput-button').hide();
            }
        }
    }
};

// 附件上传失败弹窗 显示
function failPopShow() {
    $('.failCoverLayer').removeClass('f-hide');
}

// 附件上传失败弹窗 隐藏
function failPopHide() {
    $('.failCoverLayer').addClass('f-hide');
}

$('.closeTips').on('click', function () {
    failPopHide();
})
$('.btnSure').on('click', function () {
    failPopHide();
})

/** =================文件上传相关 END============== */