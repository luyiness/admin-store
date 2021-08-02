//公用表单校验插件初始化
function initDefaultValidator(form) {
    return $(form).validate({
        errorElement: "p",
        errorPlacement:function(err, e) {
            err.text(e.attr('tip-title'));
            var label = e.parent();
            var errAfterDiv = label.attr("err-after-div");
            if(errAfterDiv){
                var errMsgDiv = label.nextAll(".err-msg-div");
                err.addClass("text-error").appendTo(errMsgDiv);
            }else{
                err.addClass("text-error").insertAfter(e);
            }
        },
        showErrors: function (errorMap, errorList) {
            this.defaultShowErrors();
            $.each(errorList, function () {
                var element = $(this.element);
                var err = element.nextAll(".text-error");
                var message = this.message.replace(/{tip-title}/g, element.attr('tip-title') ? element.attr('tip-title') : '该字段');
                err.text(message);
            });
        }
    });
}

//跳转到新的Url
function go(url){
    window.location.href = url;
}
