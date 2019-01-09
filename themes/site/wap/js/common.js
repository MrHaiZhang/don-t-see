/*
* @Author: pc
* @Date:   2017-03-27 16:54:16
* @Last Modified by:   pc
* @Last Modified time: 2018-01-17 21:09:40
*/



'use strict';
$(function () {
	/*底部导航栏切换*/
	$(".nav_bar_box").children('a').click(function(event) {
		$(".nav_bar_box").children('a').removeClass('nav_bar_li_current');
		$(".nav_bar_box").children('a').children('i').removeClass('nav_bar_i_current');
		$(this).addClass('nav_bar_li_current');
		$(this).children('i').addClass('nav_bar_i_current');
	});


      

       

});

//对话提示框----游戏下载链接异常提示
  function showDialog(msg)
  {
    // $("#dialog").remove();
    var dialog = '<div id="dialog" class="border-radius"><div style="text-align:center;"></div><p>message</p></div>';
    $(dialog).appendTo($('body'));
    $("#dialog p").html(msg);
    $("#dialog").css({"top":"50%","left":"50%",'marginTop':-$('#dialog').height()/2,'marginLeft':-$('#dialog').width()/2}).show().fadeOut(2000);
  }

  //领取礼包
  function ajax_get_gift(gift_id,obj){
      _hmt.push(['_trackEvent', '礼包领取', '礼包领取', '礼包ID为'+gift_id+'点击领取按钮次数']);
      var options = {
              url: mobile_domain+"index.php?c=xcxapi&a=api_get_gift",
              type: "POST",
              dataType: "json",
              data:{"gift_id":gift_id},
              success:function(data){
                if (data.code==2) {
                  //未登录
                  window.location.href="index.php?m=wap&c=Login";
                } else if(data.code==1){
                  _hmt.push(['_trackEvent', '礼包领取', '领取成功', '礼包ID为'+gift_id+'领取成功']);
                  $("#rest_num_"+gift_id).html($("#rest_num_"+gift_id).html()-1);
                  $(obj).addClass('have_getten').removeClass('get_welfare');
                  $(obj).html('已领取');
                  // $(obj).removeAttr('onclick');
                  show_tip(data,0);
                } else if(data.code == 10) {
                  show_tip(data,1);
                } else {
                  show_tip(data,0);
                }
              }
            }
    $.ajax(options);
  }
  //领取礼包弹窗
  function show_tip(data,flag) {
      // var marginTop = getScrollTop()+'px';
      var marginTop = -$(".q_layout").offset().top;

        $(".rec_gift_mask").css('margin-top',marginTop);
        $(".rec_gift_mask").fadeIn(100);
        $(".rec_tip").fadeIn(100);
        if (flag == 1) {
        $("#received").css('font-size','13px');
          $("#received").html(data.msg);
          $(".received").css('display','block');
          $(".dis_received").css('display','none');
        } else {
          if (data.code == 1) {
            $(".received").css('display','none');
            $(".dis_received").css('display','block');
            $("#gift_code").val(data.gift_code);
            $("#receive_msg").html("恭喜您领取成功！");
          } else if(data.code == 5){
           $(".received").css('display','none');
            $(".dis_received").css('display','block');
            $("#gift_code").val(data.gift_code);
            $("#receive_msg").html(data.msg);
          } else {
            $(".received").css('display','block');
            $("#received").html(data.msg);
            $(".dis_received").css('display','none');
          }
        }
    }

    function close_tip(){
        $(".rec_gift_mask").fadeOut(100);
        $(".rec_tip").fadeIn(100);
        // location.reload();
    }
    function copy_gift_code(obj){
/*        var gift_code = $("#gift_code").select();
        gift_code.execCommand("Copy");*/
        var gc = $("#gift_code")[0];
        gc.select(); // 选择对象
        document.execCommand("Copy"); // 执行浏览器复制命令
       }
//获取已经领取了的礼包信息
  function ajax_get_user_gift(gift_id,obj){
    var options = {
          url: mobile_domain+"index.php?c=welfare&a=get_user_gift",
          type: "POST",
          dataType: "json",
          data:{"gift_id":gift_id},
          success:function(data){
            if (data.code==2) {
              //未登录
              window.location.href="account.php?c=account";
            } else {
              show_tip(data,0);
            }
          }
        }
    $.ajax(options);
  }
//游戏下载ajax请求
function ajax_download(game_id){
  _hmt.push(['_trackEvent', '游戏下载', '点击', '下载_手机端首页']);
  if (game_id <= 0) {
    return false;
  }
  //判断用户当前系统如果是ios看是否有下载链接地址
  var u = navigator.userAgent;
  if (u.indexOf('Android') > -1 || u.indexOf('Linux') > -1) {//安卓手机
    window.location.href = mobile_domain + 'index.php?c=game&a=download_count&game_id=' + game_id;
  } else if (u.indexOf('iPhone') > -1 || u.indexOf('iPad') > -1 || u.indexOf('iPod') > -1) {//苹果设备
    var options = {
      url:mobile_domain+"index.php?c=game&a=ajax_get_download",
      type:"POST",
      dataType: "json",
      data:{"game_id":game_id},
      success:function(data){
        // console.log(data);
        if (data.code == 1) {
          // alert("游戏不存在");
          showDialog("游戏不存在")
        } else if(data.code == 0) {
          // alert(data.msg);
          showDialog(data.msg)
        } else if (data.code == 5) {
          window.location.href = data.url;
        }
      }
    };
    $.ajax(options);
  } else if (u.indexOf('Windows Phone') > -1) {//winphone手机
    // alert("暂无此设备下载地址");
    showDialog("暂无此设备下载地址")
  } else { //其他设备
    // alert("暂无此设备下载地址");
    showDialog("暂无此设备下载地址")
  }
}
