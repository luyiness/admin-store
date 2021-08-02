$(function(){
    $('.productDetail ul li').on('click',function(){
        $(this).siblings().removeClass('active');
        $('.productDetail ul li').removeClass('activePrev');
        //$(this).siblings().removeClass('activePrev');
        $(this).addClass('active');
        $(this).prev('li').addClass('activePrev');
        $(this).parent('ul').find('li').each(function(){
            $('.detailContent .contentTab').eq($(this).index()).hide();
        });
        $('.detailContent .contentTab').eq($(this).index()).show();
        if ($(this).index() == 3) {
            //如果是点击这个页面，将加载数据
            getTransRecord(true);
        }
    });

    $('.samePerson input').on('click',function(){
        if($('.samePerson input').is(':checked')){
            $(this).parent('li').nextAll('li.insurePersonInfo').hide();
        }else{
            $(this).parent('li').nextAll('li.insurePersonInfo').show();
        }
    });
    $('.checkRadio>span').on('click',function(){
        $(this).siblings().children('input').removeAttr('checked').removeClass('checkedWay');
        $(this).children('input').attr('checked','checked').addClass('checkedWay');
    });
    $('.payment>span').on('click',function(){
        $(this).siblings().children('input').removeAttr('checked').removeClass('checkPayment');
        $(this).children('input').attr('checked','checked').addClass('checkPayment');
    });
    function maxHeight(){
        var maxHeight = 0;
        $('.promotions').find('.productName').each(function(){
            var currentHeight = $(this).height();
            if(currentHeight>maxHeight){
                maxHeight = currentHeight;
            }
        });
        $('.productName').css({
            height: maxHeight
        });
    }
    maxHeight();

    //$('a.productTerms').on('click',function(){
    //    var termsTitle = $(this).attr('title');
    //    $('.termsContent').show();
    //    $('.termsBg').show();
    //    $('.termsContent h2').text(termsTitle);
    //});
    $('.closeTerms').on('click',function(){
        $('.termsContent').hide();
        $('.termsBg').hide();
        $('#itemsContent').empty();
    });
    $('#information a').on('click',function(){
        var currentHerf = $(this).attr('title');
        var currentTitle = $(this).attr('titleName');
        checkTheItems(currentHerf,currentTitle);

    });
//    浜у搧璇︽儏椤甸潰璐拱璁板綍鐨勪笅鎷夊姞锟�?
    $('#tableBottom').on('click',function(){
        $('.goTo').css('display','block');
        getTransRecord(false);
    });
    $('div.share-page').remove();
    $('.common-tip').remove();
    $('.share').on('click',function(){
        $('.toShare').fadeIn('slow');
    });
    $('.closeBtn').on('click',function(){
        $('.toShare').fadeOut('slow');
    });

    //$(".menuTab").load("./menu.html");
    //$(".footer").load("./foot.html");
    //$(".shareMain").load("./share.html");
    $(".toplab").click(function () {
        $("#backlab").show();
    });
    $(".backlab").click(function () {
        $("#backlab").fadeOut(400);
    })
    $("#offon").removeAttr('checked');
    //    移动端上fixed兼容性问题
    var ua = navigator.userAgent.toLowerCase(),u = navigator.userAgent;
    $('.productContent input,.productContent select').on('focus',function(){
        if((!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/))&&ua.indexOf('ucbrowser')>1){
            $('.infoButton').css('position','relative');
        }
    });
    $('.productContent input,.productContent select').on('blur',function(){
        if((!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/))&&ua.indexOf('ucbrowser')>1){
            $('.infoButton').css('position','fixed');
        }
    });
});
function checkTheItems(href,title){
    if(title == '太平赚吧') {
        window.location.href = "http://baoxian.cntaiping.com/referrals/ECommerce/CKLogin.action";
        return
    }
    var showUrl = encodeURI(encodeURI(href));
    if(!(showUrl==null||showUrl==''||showUrl==undefined)){
        $('#itemsContent').load(showUrl,function(){
            $('.termsContent').scrollTop(0);
            $('div.termsContent').show();
            //$('div.termsContent').css('height',$('body').height());
            $('.termsBg').show();
            $('.termsContent>h2').text(title);
        });
    }
}
var second=60;
function sendMobileCode(){
    $("#sendMobileCode").attr("disabled", 'disabled');//????disabled????
    var _res = setInterval(function(){
        $("#sendMobileCode").val(second+"s重新发送");
        $("#sendMobileCode").css("color","#A9A9A9")
        second-=1;
        if(second <= -1){
            $('#sendMobileCode').removeAttr('disabled');
            second=60;
            $("#sendMobileCode").val("重新发送");
            $("#sendMobileCode").css("color","#045294");
            clearInterval(_res);//???setInterval
        }
    },1000);
}

var _res1;
var _res2;
function alertPop(str){
    clearTimeout(_res1);
    clearTimeout(_res2);
    $(".errorPop").html(str);
    $(".errorPop").css("opacity", 1);
    $(".errorPop").show();
    _res1 = setTimeout(function () {
        $(".errorPop").fadeTo("slow", 0);
        _res2 = setTimeout(function () {
            $(".errorPop").hide();
        }, 500);
    }, 2000);
}

function isWxBrowse(){
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i)=="micromessenger") {
        return true;
    } else {
        return false;
    }
}

function footImg(){
    if(!isWxBrowse()){
        $(".foot").css("padding","1rem 8%");
        $(".iconImg img").attr("src","image/goodslist/QRcode.jpg");
        $(".iconImg").css("width","30%");
        $(".footText").css("width","68%");
        $(".foot .footText .weixin").css({
            "font-size":"1.05rem",
            "line-height":"1.8rem"
        });
        $(".foot .footText .phoneNumber").css({
            "font-size": "1.05rem",
            "line-height": "2.5rem"
        });
        $(".foot .footText .phoneNumber a").css("font-size","1.15rem");
    }
}

var pageIndex = 1;
function getTransRecord(isFrist) {
    if(pageIndex != 1&&isFrist){
        return ;
    }
    var url = "/mobileMall/transRecord.do?productCode=" + $("#productCode").val() + "&pageIndex=" + pageIndex;
    $.ajax({
        type: "get",
        url: url,
        dataType: 'json',

        success: function (data) {
            if (data.data) {

                var records = data.data;
                var transRecordId = "#transRecordId";
                var tableLength = $('#transRecordId').find('tr').length;

                if(isFrist&&tableLength==0) {

                    $.each(records, function (index, record) {

                        $(transRecordId).append(
                            " <tr>"
                            + " <td>" + record.person_name + "</td>"
                            + " <td>" + record.PRICE + "</td>"
                            + " <td>" + record.POLICY_TIME + "</td>"

                            + " </tr>"
                        );

                    });
                }

                if(pageIndex>1){
                    $.each(records, function (index, record) {
                        $(transRecordId).append(
                            " <tr>"
                            + " <td>" + record.person_name + "</td>"
                            + " <td>" + record.PRICE + "</td>"
                            + " <td>" + record.POLICY_TIME + "</td>"

                            + " </tr>"
                        );

                    });
                }
                pageIndex=Number(data.pageIndex)+1;//返回列表页数

            } else {
                console.log(data.message)
            }

        },
        error: function (error) {
            console.log(error)
            //alert(error);
        }
    });
}
