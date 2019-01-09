


/*滚动到最顶部*/
$(".to-top").click(function(event) {
    $(".all_content").animate({scrollTop:0}, 500)
});


    $(function() {
        setTimeout(function () {

        setHeadPic();
        /*如果用户头像+用户名和id+修改icon>屏幕宽度 用户名id换行显示*/
        var headPicW = parseInt($(".head-pic").width());
        var userDesW = parseInt($(".user-des").width());
        var userDesL = parseInt($(".user-des").css('marginLeft'));
        var userHeadBoxW = parseInt($(".user-head-box").width());
        var allW = 0;
        if ($(".change_btn").length!=0) {
            var changeBtnW = $(".change_btn").width()
            allW = headPicW+userDesW+userDesL+changeBtnW;
        }else{
            allW = headPicW+userDesW+userDesL;
        }
        if ((allW-userHeadBoxW)>0){
            $(".user-des").children('.name:first').after('<br>')
        }
        },10);

    });



/*调用后就会显示新手引导的函数:obj需引导对象；tipStr引导文字；ifNextGuide是否有下一个guide,true-有，false-无*/
function newComerGuide(obj) {
    obj.addClass('introjs-showElement introjs-relativePosition');
    var objStep = obj.attr('data-step'); //第几步
    var tipStr = obj.attr('data-intro'); //提示的信息
  // 4、“用户中心”修改用户信息新手引导
    // var coverStr = '<div class="guide-big-img-mask big-img-mask" next-step="0"  style="margin-top: 0px;"><div class="rec_tip"><img class="bent-arrow-img" src="'+site_img+'/community/bent-arrow.png" style="width: 56px;margin-top: '+returnXY(obj).Y+';margin-left: '+returnXY(obj).X+';"><p class="tip-text">'+tipStr+'</p></div></div>';
    var coverStr = '<div class="guide-big-img-mask big-img-mask" next-step="0"  style="margin-top: 0px;"><div class="rec_tip"><img class="bent-arrow-img" src="'+site_img+'/community/bent-arrow.png" style="width: 56px;margin-top: 10px;margin-left: '+returnXY(obj).X+';"><p class="tip-text">'+tipStr+'</p></div></div>';
    $("body").append(coverStr)

    $(".rec_tip").prepend(obj.clone(true))
    $(".big-img-mask").fadeIn('fast');
    $(".all_content").css('overflow-y', 'hidden');
    
     if (obj.hasClass('follow_btn')) {//follow_btn 1、“签到”的新手指引  反过来的箭头 {@theme:site.wap.images}/community/
        $(".bent-arrow-img").attr('src',site_img+'/community/bent-arrow2.png');
       /* $(".bent-arrow-img").css({
          'margin-top': returnXY(obj).Y,
          'margin-left': returnXY(obj).neX
        });*/
        var follow_btnL = $(".follow_btn").offset().left - 28;
        var follow_btnLeft = follow_btnL+'px';
        console.log("follow_btnLeft:"+follow_btnLeft)
         $(".bent-arrow-img").css({
          'margin-top': '21px',
          'margin-left': follow_btnLeft
        });

        $(".rec_tip .follow_btn").css({
          'margin-top': returnObjXY(obj).Y,
          'margin-right': '15px'
        });

        $(".big-img-mask").attr('next-step', '1');//还有下一步的引导
       
        $(".guide-big-img-mask .rec_tip p").css({
            'margin-left': '42%',
            'margin-top': '10px'
          });
      }

      if (obj.hasClass('integral_gift')) {//反过来的箭头 3、“福利礼包”页面的“积分礼包”新手引导
        $(".bent-arrow-img").attr('src',site_img+'/community/bent-arrow2.png');
        /*$(".bent-arrow-img").css({
          'margin-top': returnXY(obj).Y,
          'margin-left': returnXY(obj).neX
        });*/
        $(".bent-arrow-img").css({
          'margin-top': '10',
          'margin-left': returnXY(obj).neX
        });
        $(".rec_tip .integral_gift").css({
          'margin-top': returnObjXY(obj).Y,
          'margin-left': returnObjXY(obj).neX
        });

        $(".big-img-mask").attr('next-step', '0');//还有下一步的引导
      }


      $(".rec_tip").click(function(event) {
        /* 获取mask的next-step*/
        var nextStep = $(".big-img-mask").attr('next-step');
        if (nextStep!=0) {//有下一步   2、“福利礼包”的新手引导
           $(".rec_tip .follow_btn").remove();
          $(".rec_tip").prepend('<li class="showGuide2" data-step="2" data-intro="游戏礼包全在这里<br>还可以用积分兑换高价值道具哦~"><a class="gift"><span></span><i>礼包福利</i></a></li>')
       
          $(".follow_btn").removeClass('introjs-showElement introjs-relativePosition');//上一个指引obj不再显示
          $(".showGuide2").addClass('introjs-showElement introjs-relativePosition');
          var tipStr = $(".showGuide2").attr('data-intro');
          $(".tip-text").html(tipStr);
          $(".bent-arrow-img").attr('src',site_img+'/community/bent-arrow.png');
          /*$(".bent-arrow-img").css({
                'margin-top': returnXY($(".showGuide2")).Y,
                'margin-left': 0
              });*/
              $(".bent-arrow-img").css({
                'margin-top': '14px',
                'margin-left': '-64px'
              });

          var showGuide2LiW= $(".section_ul.flex-box li").width();

          $(".rec_tip .showGuide2").css({
                'margin-top': returnObjXY($(".showGuide2")).Y,
                'margin-left': returnObjXY($(".showGuide2")).X,
                'width':showGuide2LiW
              });

           $(".guide-big-img-mask .rec_tip p").css({
            'margin-left': '28%',
            'margin-top': '8px'
          });
          $(".big-img-mask").attr('next-step', '0');
          $(".big-img-mask").fadeIn('fast');
          $(".all_content").css('overflow-y', 'hidden');
        }else{
          close();
        }
      });
}
/*关闭新手引导*/
function close() {
  $(".introjs-showElement").removeClass('introjs-showElement introjs-relativePosition');
  $(".big-img-mask").fadeOut('fast');
  $(".all_content").css('overflow-y', 'auto');
}

/*返回对象的绝对位置*/
function returnObjXY(obj) {
    var x = obj.offset().left;
    var y = obj.offset().top;
    var nex = obj.offset().left;
    var aX = x + 'px';
    var aY = y + 'px';
    var aneX = nex + 'px';
    return {
      'X' :aX,
      'Y' :aY,
      'neX':aneX
    };
}
/*根据对象的绝对位置，计算并返回箭头的位置的方法*/
function returnXY(obj) {
    var x = obj.offset().left + (obj.outerWidth(true)/2)-28;
    var y = obj.offset().top + (obj.outerHeight(true)) + 5;
    var nex = obj.offset().left -(obj.outerWidth(true)/2) -28;
    var aX = x + 'px';
    var aY = y + 'px';
    var aneX = nex + 'px';
    return {
      'X' :aX,
      'Y' :aY,
      'neX':aneX
    };
}




    /*控制头像*/
    function setHeadPic() {
         /*头像head-pic图片取中间部分*/
            $(".head-pic").each(function(index, el) {
                /*原图片的宽高*/
            var headImgW = $(this).children('img').width()
            var headImgH = $(this).children('img').height()
            if (headImgH==headImgW) {/*正方形图*/
                $(this).children('img').css('width','100%');
            }else if(headImgH>headImgW) { /*竖图*/
                $(this).children('img').css('width','100%');
                /*marginT是现在图片的高减去图片盒子高后的1/2;所以$(this).children('img').height()不能用headImgH*/
                var marginT = $(this).children('img').height()/2 - $(this).height()/2;
                $(this).children('img').css('margin-top', -marginT);
            }else{/*横图*/
                $(this).children('img').css('height', '100%');
                var marginL = $(this).children('img').width()/2 - $(this).width()/2;
                $(this).children('img').css('margin-left', -marginL);
            }

            /*添加圣诞帽子的代码*/
            // $(this).css('position', 'relative');
            // var christIcon = '<img src="'+site_img+'/community/christ-icon.png" style="position: absolute;top: -22px;left: -17px;">';
            // $(this).prepend(christIcon)
        });
    }



//评论查看大图
$(".post-text").on("click","img",function(){
    showBigPic($(this))
});
$("#community_game_post .hot-discuss").on("click",".discuss-img",function(){
    showBigPic($(this).children("img"))
});

function showBigPic(obj){
    var _this = obj;
    var imgSrc = _this.attr("src");
    var imgWidth = _this.width();
    var imgHeight = _this.height();
    var winWidth = $(window).width();
    var winHeight = $(window).height();
    var recTip =  $(".rec_tip");
    if(imgWidth / imgHeight >= winWidth / winHeight){
        recTip.addClass("ver").html($("<img />").attr("src",imgSrc).css("width","100%"))
    }else{
        recTip.addClass("hor").html($("<img />").attr("src",imgSrc).css("height","100%"))
    }
    $("#lookPicMask").fadeIn();

    dragPic()
}

$("#lookPicMask .btnImgClose").on("click",function(event) {
    $(this).children('.rec_tip').empty().removeClass("ver hor");
    $("#lookPicMask").fadeOut();
});

function dragPic(){
    var imgScale = 1;
    var miniScale = 0.2;
    var maxScale = 2;
    var scaleRate = 0.2;
    var scaleW = 0;
    var scaleH = 0;
    var winWidth = $(window).width();
    var winHeight = $(window).height();

    var mask = $(".big-img-mask");
    var img = mask.find("img");

    $(".btnEnlarge").on("click",function(){
        var width = img.width();
        var height = img.height();
        imgScale += scaleRate;
        if(imgScale >= maxScale){
            imgScale = maxScale
        }
        scaleW = Math.ceil(width * imgScale);
        scaleH = Math.ceil(height * imgScale);
        img.css("transform","scale(" + imgScale + "," + imgScale +")")
        img.css("webkittransform","scale(" + imgScale + "," + imgScale +")")

    })

    $(".btnNarrow").on("click",function(){
        imgScale -= scaleRate;
        if(imgScale <= miniScale){
            imgScale = miniScale
        }
        var width = img.width();
        var height = img.height();
        scaleW = Math.ceil(width * imgScale);
        scaleH = Math.ceil(height * imgScale);
        img.css("transform","scale(" + imgScale + "," + imgScale +")")
        img.css("webkittransform","scale(" + imgScale + "," + imgScale +")")
    })

    var startX = 0;
    var startY = 0;
    var distanX = 0;
    var distanY = 0;
    mask.on("touchstart",function(e){
        startX = e.originalEvent.targetTouches[0].pageX;
        startY = e.originalEvent.targetTouches[0].pageY;
    })

    var x = 0;
    var y = 0;
    var speed = 2;
    mask.on("touchmove",function(e) {
        var moveX = e.originalEvent.targetTouches[0].pageX;
        var moveY = e.originalEvent.targetTouches[0].pageY;

        distanX =  moveX - startX;
        distanY = moveY - startY;

        if(Math.abs(distanX) >= Math.abs(distanY) && scaleW > winWidth){
            if (distanX > 0  ) {
                x+=speed
                if(x >= (scaleW - winWidth) / 2 / imgScale){
                    x = (scaleW - winWidth) / 2 / imgScale
                }
            } else if(distanX < 0){
                x-=speed;
                if(Math.abs(x) >=  (scaleW - winWidth) / 2 / imgScale){
                    x = -(scaleW - winWidth) / 2 / imgScale
                }
            }
        }else if(Math.abs(distanX) <= Math.abs(distanY) && scaleH > winHeight){
            if (distanY > 0 ) {
                y+=speed;
                if(y >= (scaleH - winHeight) / 2 / imgScale){
                    y = (scaleH - winHeight) / 2 / imgScale
                }
            } else if(distanY < 0){
                y-=speed
                if(Math.abs(y) >=  (scaleH - winHeight) / 2 / imgScale){
                    y = -(scaleH - winHeight) / 2 / imgScale
                }
            }
        }
        img.css("transform", "scale(" + imgScale + "," + imgScale + ") translate(" + x  + "px," + y + "px)");
        img.css("webkittransform", "scale(" + imgScale + "," + imgScale + ") translate(" + x  + "px," + y + "px)");

    })

    mask.on("touchend",function(e){
    })
}

/*重写个alert*/
function alert(msg) {
    var str = '<div class="tip_wrap"><div class="tip_content">'+msg+'</div></div>'
    var windowH = $(window).height()

    $("body").append(str);
    var tipWrapH = $(".tip_wrap").height()
    var tipWrapTop = windowH/2 - tipWrapH/2; 
    // console.log(tipWrapTop+'px')
    $(".tip_wrap").css('top', tipWrapTop);
    $(".tip_wrap").fadeIn('fast');
    setTimeout(function () {
      $(".tip_wrap").fadeOut('slow');
      $(".tip_wrap").remove()
    },1000);
}

/*所有等待加载*/
    $(window).load(function(){
                setTimeout(function () {
                    $('.load-container').fadeOut('fast');;
                $(".all_content").removeClass('hide')
                },50)
            }); 