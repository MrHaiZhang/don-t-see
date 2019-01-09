/*
* @Author: pc
* @Date:   2018-01-19 11:50:58
* @Last Modified by:   pc
* @Last Modified time: 2018-01-19 20:26:25
*/

/*控制横竖屏*/
$(function() {

	 /*添加横屏的遮盖层*/
      var rotateCoverStr = '<div class="rotateCover-mask" style="background-color: rgb(0, 0, 0)!important; padding-top: 20px;    text-align: center;display: none;width: 100%;height: 100%;background-color: rgba(0, 0, 0, .2);position: absolute;top: 0;left: 0;z-index: 1000;"><img class="rotate-img" src="'+site_img+'/community/rotate.png"><p class="rotate-p-text" style="color: #fff;font-size: 20px;position: absolute;    width: 100%;">为了更好的体验，请将手机/平板竖过来</p></div>'
      if ($(".rotateCover-mask").length==0) {
        $("body").append(rotateCoverStr)
      }
          console.log("window.orientation:"+window.orientation);
          // alert(window.orientation)
          if (window.orientation) {
                console.log("oritation有值，是手机上");
                showLandscapeImg();
              }

          /*手机/平板、电脑重力发生改变（旋转）后判断横竖屏状态*/
          $(window).on("orientationchange",function(){
                showLandscapeImg();
                // alert(window.orientation)
          });
});

function showLandscapeImg() {
  var windowH = $(window).height()
  var windowW = $(window).width()
      if(window.orientation == 0){                    // Portrait竖屏
        $(".rotateCover-mask").fadeOut('fast');
      }else{                                      // Landscape横屏
        if (windowH>windowW) {
            windowH = windowW
        }
        console.log("windowH:"+windowH)
        var imgMarginT = windowH/7;
        var rotateTextT=windowH/1.5;

        if (windowH>350) {
          imgMarginT = windowH/6;
        }
        if (windowH>400) {
          imgMarginT = windowH/5;
        }
        if (windowH>500) {
          imgMarginT = windowH/4;
        }
        if (windowH>590) {
          imgMarginT = windowH/4.5;
        }
        if (windowH>750) {
          imgMarginT = windowH/3;
        }

        var imgMarginTop = imgMarginT + 'px';                  
        $(".rotate-img").css('margin-top',imgMarginTop);

        var rotateTextTop = rotateTextT+'px';

        $(".rotate-p-text").css('top', rotateTextTop);
        $(".rotateCover-mask").fadeIn('fast');
      }
  
  
}





