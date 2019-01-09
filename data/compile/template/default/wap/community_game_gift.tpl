<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="<?php echo htmlspecialchars(Wekit::V('charset'), ENT_QUOTES, 'UTF-8');?>" />
<title><?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','title'), ENT_QUOTES, 'UTF-8');?></title>
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta name="generator" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','version'), ENT_QUOTES, 'UTF-8');?>" />
<meta name="description" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','description'), ENT_QUOTES, 'UTF-8');?>" />
<meta name="keywords" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','keywords'), ENT_QUOTES, 'UTF-8');?>" />
<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/'.Wekit::C('site', 'theme.site.default').'/css'.Wekit::getGlobal('theme','debug'); ?>/core.css?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" />
<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/'.Wekit::C('site', 'theme.site.default').'/css'.Wekit::getGlobal('theme','debug'); ?>/style.css?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" />
<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
<!-- <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community-common.js"></script> -->
<!-- <base id="headbase" href="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','base'), ENT_QUOTES, 'UTF-8');?>/" /> -->
<?php echo Wekit::C('site', 'css.tag');?>
<script>

//全局变量 Global Variables
var GV = {
	JS_ROOT : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','res'), ENT_QUOTES, 'UTF-8');?>/js/dev/',										//js目录
	JS_VERSION : '<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>',											//js版本号(不能带空格)
	JS_EXTRES : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','extres'), ENT_QUOTES, 'UTF-8');?>',
	TOKEN : '<?php echo htmlspecialchars(Wind::getComponent('windToken')->saveToken('csrf_token'), ENT_QUOTES, 'UTF-8');?>',	//token $.ajaxSetup data
	U_CENTER : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=space'; ?>',		//用户空间(参数 : uid)
<?php 
$loginUser = Wekit::getLoginUser();
if ($loginUser->isExists()) {
?>
	//登录后
	U_NAME : '<?php echo htmlspecialchars($loginUser->username, ENT_QUOTES, 'UTF-8');?>',										//登录用户名
	U_AVATAR : '<?php echo htmlspecialchars(Pw::getAvatar($loginUser->uid), ENT_QUOTES, 'UTF-8');?>',							//登录用户头像
<?php 
}
?>
	U_AVATAR_DEF : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>/face/face_small.jpg',					//默认小头像
	U_ID : parseInt('<?php echo htmlspecialchars($loginUser->uid, ENT_QUOTES, 'UTF-8');?>'),									//uid
	REGION_CONFIG : '',														//地区数据
	CREDIT_REWARD_JUDGE : '<?php echo $loginUser->showCreditNotice();?>',			//是否积分奖励，空值:false, 1:true
	URL : {
		LOGIN : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login'; ?>',										//登录地址
		QUICK_LOGIN : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login&a=fast'; ?>',								//快速登录
		IMAGE_RES: '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>',										//图片目录
		CHECK_IMG : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login&a=showverify'; ?>',							//验证码图片url，global.js引用
		VARIFY : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=verify&a=get'; ?>',									//验证码html
		VARIFY_CHECK : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=verify&a=check'; ?>',							//验证码html
		HEAD_MSG : {
			LIST : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=message&c=notice&a=minilist'; ?>'							//头部消息_列表
		},
		USER_CARD : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=space&c=card'; ?>',								//小名片(参数 : uid)
		LIKE_FORWARDING : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=post&a=doreply'; ?>',							//喜欢转发(参数 : fid)
		REGION : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=area'; ?>',									//地区数据
		SCHOOL : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=school'; ?>',								//学校数据
		EMOTIONS : "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=emotion&type=bbs'; ?>",					//表情数据
		CRON_AJAX : '<?php echo htmlspecialchars($runCron, ENT_QUOTES, 'UTF-8');?>',											//计划任务 后端输出执行
		FORUM_LIST : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=forum&a=list'; ?>',								//版块列表数据
		CREDIT_REWARD_DATA : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&a=showcredit'; ?>',					//积分奖励 数据
		AT_URL: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=remind'; ?>',									//@好友列表接口
		TOPIC_TYPIC: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=forum&a=topictype'; ?>'							//主题分类
	}
};
</script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/wind.js?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script type="text/javascript">
var site_img = '<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>';
</script>
<!-- 百度统计 -->
<script>
	var _hmt = _hmt || [];
	(function() {
	  var hm = document.createElement("script");
	  hm.src = "https://hm.baidu.com/hm.js?8329b6ac5dc3bcb8cbb72f544f368e37";
	  var s = document.getElementsByTagName("script")[0]; 
	  s.parentNode.insertBefore(hm, s);
	})();
</script>
<!-- 站长统计 -->
<script>
	(function(){
	    var bp = document.createElement('script');
	    var curProtocol = window.location.protocol.split(':')[0];
	    if (curProtocol === 'https') {
	        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
	    }
	    else {
	        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
	    }
	    var s = document.getElementsByTagName("script")[0];
	    s.parentNode.insertBefore(bp, s);
	})();
</script>
<meta name="baidu-site-verification" content="iMDIf2wt7e" />
<?php
PwHook::display(array(PwSimpleHook::getInstance("head"), "runDo"), array(), "", $__viewer);
?>

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
    <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/introjs.css">
    <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/introjs-rtl.css">
    <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/base.css"/>
    <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css">
    <style>
        .section{padding: 0 14px;}
        .first-section{ width: 100%; }
        .game_community_title{overflow: hidden}
        .back-community{border-radius: 5px;color: #1ea4f2; display: inline-block;font-size: 10pt;padding: 3px 10px; margin-top: 25px;background-color: #fff;border: 1px solid #1ea4f2;font-weight: 700;float: right;}
        .game-name{font-weight: 700;color:#333;float: left;font-size:18px;    padding-left:10px;margin-top: 24px;}
        .gamelist{    height: 82px;padding:14px 0;}
        .gamelist .header-icon-body{width: 55px;height: 55px;}
        .game-name{    margin-top: 14px;}
        .back-community{    margin-top: 15px;}
        .second-section{height:50px;line-height:50px;}
        .blue{color:#1ea4f2}
        .integral{float:left;font-size:16px;color:#949494}
        .integral .blue{font-size:16px;}
        .record{float:right;font-size:16px;}
        .record a{color:#949494;display: inline-block;font-size:16px;padding-left: 44px; background: url("<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/record.png") left center  no-repeat;background-size: 40px}
        .gift_tab{display: -webkit-box; display: -webkit-flex;  display: flex;  -webkit-justify-content: space-around;  justify-content: space-around;   border-bottom: 1px solid #e5e5e5; background-color: #fff;position:relative;}
        .gift_tab h2 {  padding: 6px 0;  font-size: 18px;  font-weight: 400;  color: #949494;  width: 49%;  }
        .gift_tab h2.activity{color:#1ea4f2;font-weight:700;}
        .gift_tab i.vertical_line{background:#1ea4f2;width:50%;height:4px;position:absolute;left:0;top:36px;-webkit-transition: -webkit-transform .3s ease-in-out;-moz-transition: -moz-transform .3s ease-in-out;-ms-transition: -ms-transform .3s ease-in-out;transition: transform .3s ease-in-out;}
        .gift_tab h2:nth-of-type(1).activity~.vertical_line {transform: translateX(0); -webkit-transform: translateX(0); }
        .gift_tab h2:nth-of-type(2).activity~.vertical_line {transform: translateX(100%);-webkit-transform: translateX(100%);}
        .topic-title .bulletin-title{font-weight: 700;}
        .uncontent{ text-align: center; padding: 10px 14px; }
        .topic-brief p{text-align:left;}
        .gift_tab h2{font-size:16px;}
        .official_box,.integral_box{background: #fff}
        /*礼包列表部分*/
        .welfare_list{  border-top: 1px solid #ddd;  }
        ul.welfare_list li{width: 100%;padding: 14px 14px;border-bottom: 1px solid #ddd;  height: auto !important;  }
        .welfare_list .welfare_detail{width: 100%; position: relative;  min-height: 80px;  }
        .welfare_list li h5{font-weight: 400; font-size: 16px;  color: #000;  text-align: left;  text-overflow: ellipsis;  white-space: nowrap;  overflow: hidden;  padding-left: 90px; padding-right: 90px;  line-height: 28px; }
        .welfare_detail a.imgWrap{    display: inline-block;  width: 80px;  height: 80px;  text-align: left;  position: absolute;  left: 0;  top: 0;}
        img.img_icon{border-radius: 18%;width: 100%;height: auto; vertical-align:middle; text-align: left;}
        a.imgWrap .placeholder{display: inline-block; height: 100%;vertical-align: middle; }
        .welfare_detail_desc{     text-align: left;  color: #666;  font-size: 12px;  font-weight: 200;  text-overflow: ellipsis;  white-space: nowrap;  overflow: hidden;  padding-left: 90px;  padding-right: 90px;  line-height: 30px; }
        .welfare_detail_desc a{color: #666; }
        .welfare_remain{ color: #666;  font-size: 12px;  font-weight: 200;  padding-left: 10px;  text-align: left;  text-overflow: ellipsis;  white-space: nowrap;  overflow: hidden;  padding-left: 90px;  line-height: 24px; }
        .welfare_remain i{ color: red;  }
        .welfare_integral{font-size:12px;font-weight: 200}
        .welfare_integral i{font-weight: bold}
        #integral_content .welfare_remain i,#integral_content .welfare_integral i{ color: #1ea4f2; font-size:14px; }
        .welfare_detail span.welfare_download_a{ display: inline-block;  position: absolute;right:0;top:50%;-webkit-transform: translateY(-50%);transform: translateY(-50%);line-height: normal !important;}
        .welfare_download_a a.get_welfare, .welfare_download_a a.have_getten,.welfare_download_a a.have_no_leavings{  background-color: #6fbdf4;  color: #fff;  padding: 5px 10px;  border-radius: 5px;  line-height: 20px;  height: 32px;  display: inline-block;  width: 78px;  }
        .welfare_download_a a.have_getten{  background-color: #bbb;   }
        .welfare_download_a a.have_no_leavings{  background-color: #bbb;   }
        .load-more{ line-height: 25px; display: none }
        .to-top{position:fixed;right:10px; bottom:80px; background-color:#1ea4f2;color:#fff;font-size: 14px;width:50px;height:50px;border-radius:23px;padding: 7px;z-index: 500;cursor: pointer}
        .remain_time,.remain_time_out{position: relative; float: right; top: -23px; color: #ff9600; font-size: 16px;}

        /* 三种礼包的角标类型 */
        .gift-img{position:absolute;width:70px;}

        /* 新手引导 */
        .integral_gift{font-size: 16px;padding: 6px 0;font-weight: 400;
    color: #949494;
    width: 49%;}

       
    </style>
</head>
<body>
<div class="all_content">
    <div class="q_layout">
        <div class="first-section section">
            <div class="gamelist">
                <div class="game_community_title">
                    <div class="header-icon-body">
                        <img src="<?php echo htmlspecialchars(Pw::getPath($pwforum->foruminfo['icon']), ENT_QUOTES, 'UTF-8');?>" id="icon_id" alt="" title="">
                    </div>
                    <h1 class="game-name"><?php echo $pwforum->foruminfo['name'];?></h1>
                    <div class="download_btn">
                        <a class="back-community" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($pwforum->foruminfo['fid'], ENT_QUOTES, 'UTF-8');?>">回到社区</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="second-section section">
            <div class="integral">我的积分：<span class="blue"><?php echo htmlspecialchars($plat_credit, ENT_QUOTES, 'UTF-8');?></span></div>
            <div class="record">
                <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Record&load_type=gift">领取记录</a>
            </div>
        </div>

        <div class="gift_tab flex-box">
            <h2 class="official_gift" onclick="change_topic('official_gift')">官方礼包</h2>
            <h2 class="integral_gift activity" onclick="change_topic('integral_gift')" data-intro="消耗积分可以兑换礼包哦！<br>积极签到和参与活动来获得积分吧！" data-step="0">积分礼包</h2>
            <i class="vertical_line under_line"></i>
        </div>

        <div class="official_box hidden">
            <ul class="welfare_list" id="official_content">
                <?php  foreach($gift_list['data'] as $key=>$value){ ?>
                    <li>
                        <div class="welfare_detail clearfix">
                            <a class="imgWrap">
                                <!-- 要加判断是哪种类型的礼包 -->
                                <!-- 官方 -->
                                <!-- <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-guanfang.png" alt=""> -->
                                <!-- 限时 -->
                                <!-- <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-xianshi-new.png" alt=""> -->
                                <!-- 积分 -->
                                <!-- <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-jifen.png" alt=""> -->

                                <img class="img_icon" src="<?php echo htmlspecialchars($value['icon'], ENT_QUOTES, 'UTF-8');?>" alt="">
                            </a>
                            <h5><?php echo $value['game_name'];?>&nbsp;&nbsp;<?php echo $value['gift_name'];?></h5>
                            <p class="welfare_detail_desc"><?php echo $value['gift_content'];?></p>
                            <p class="welfare_remain">剩余：<i id="rest_num_<?php echo htmlspecialchars($value['gift_id'], ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($value['rest_num'], ENT_QUOTES, 'UTF-8');?></i></p>

                            <span class="welfare_download_a">
                                <?php  if($value['rest_num'] <= 0){ ?>
                                    <a class="have_no_leavings" href="javascript:;">已抢完</a>
                                <?php  } else if($value['is_get'] == 1){ ?>
                                    <a class="have_getten" href="javascript:;" onclick="ajax_get_gift(<?php echo htmlspecialchars($value['gift_id'], ENT_QUOTES, 'UTF-8');?>,this)">已领取</a>
                                <?php  } else{ ?>
                                    <a class="get_welfare" href="javascript:;" onclick="ajax_get_gift(<?php echo htmlspecialchars($value['gift_id'], ENT_QUOTES, 'UTF-8');?>,this)">领取</a>
                                <?php  } ?>
                            </span>
                        </div>
                    </li>
                <?php  } ?>
            </ul>
        </div>
        <div class="integral_box">
            <ul class="welfare_list" id="integral_content">
                <?php  foreach($point_gift_list['data'] as $key=>$value){ ?>
                    <li onclick="trunUrl(<?php echo htmlspecialchars($value['gift_id'], ENT_QUOTES, 'UTF-8');?>)">
                        <div class="welfare_detail clearfix">
                            <a class="imgWrap">
                                 <!-- 要加判断是哪种类型的礼包 -->
                                <!-- 官方 -->
                                <!-- <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-guanfang.png" alt=""> -->
                                <?php  if($value['remain_time'] >= 0){ ?>
                                    <!-- 限时 -->
                                    <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-xianshi-new.png" alt="">
                                <?php  } else{ ?>
                                     <!-- 积分 -->
                                    <!-- <img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-jifen.png" alt=""> -->
                                <?php  } ?>
                                <img class="img_icon" src="<?php echo htmlspecialchars($value['icon'], ENT_QUOTES, 'UTF-8');?>" alt="">
                            </a>
                            <h5><?php echo $value['gift_name'];?></h5>
                            <?php  if($value['remain_time'] >= 0){ 
  if($value['remain_time'] > 0){ ?>
                                    <span class="remain_time" time_data="<?php echo htmlspecialchars($value['remain_time'], ENT_QUOTES, 'UTF-8');?>">限时礼包</span>
                                <?php  } else{ ?>
                                    <span class="remain_time_out" time_data="<?php echo htmlspecialchars($value['remain_time'], ENT_QUOTES, 'UTF-8');?>">已过期</span>
                                <?php  } 
  } ?>
                            <p class="welfare_detail_desc">点击查看礼包内容</p>
                            <p class="welfare_remain">
                                <span class="fl">销量：<i class="blue"><?php echo htmlspecialchars($value['total_num']-$value['rest_num'], ENT_QUOTES, 'UTF-8');?></i></span>
                                <span class="welfare_integral fr">所需积分：<i class="blue"><?php echo htmlspecialchars($value['point'], ENT_QUOTES, 'UTF-8');?></i></span>
                            </p>
                        </div>
                    </li>
                <?php  } ?> 
            </ul>
        </div>
        <div class="load-more">加载更多内容</div>
    </div>
</div>
<div class="to-top">
    <p>返回</p>
    <p>顶部</p>
</div>
<div class="rec_gift_mask">
    <div class="rec_tip">
        <div class="title">
            <span>温馨提示</span>
            <a title="关闭" onclick="close_tip();">✕</a>
        </div>
        <div class="received" style="display: none;">
            <p id="received"><span style="font-size:10pt;">您未玩过该游戏，请先下载</span></p>
            <img src="//wap.quxuan.com/mobile_common/img/received.jpg?=1513267200" alt="">
        </div>
        <div class="dis_received" style="display: block;">
            <p id="receive_msg">恭喜您领取成功！</p>
            <div class="copy">
                <p>长按复制礼包码</p>
                <input type="text" value="" readonly="true" class="code" id="gift_code">
            </div>
            <a class="rec_tip_sure" onclick="close_tip()">确定</a>
        </div>
    </div>
</div>

<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
<!-- <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script> -->
<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
<script>

$(function() {//新手引导
    /*执行新手引导*/
    if("<?php echo htmlspecialchars($frist_in, ENT_QUOTES, 'UTF-8');?>" == ''){
        newComerGuide($(".integral_gift"));
    }
    // newComerGuide($(".integral_gift"));
});

    var loadMore = false;       //是否到底
    var loadOfficial = true;     //官方礼包判断是否可以加载
    var oGiftId = "<?php echo htmlspecialchars($gift_list['current_id'], ENT_QUOTES, 'UTF-8');?>";     //官方礼包最后加载的id
    var loadIntegral = true;     //积分礼包判断是否可以加载
    var iGiftId = "<?php echo htmlspecialchars($point_gift_list['current_id'], ENT_QUOTES, 'UTF-8');?>";     //积分礼包最后加载的id

    $(".rec_gift_mask").on("touchmove",function(e){
        e.preventDefault()
    })

    /*切换“官方礼包”和“积分礼包*/
    var integral_box = $('.integral_box');
    var official_box = $('.official_box');
    function change_topic(className) {
        var obj = $('.'+className)
        obj.parents('.gift_tab').children('h2').each(function(index, el) {
            $(this).removeClass('activity')
        });
        obj.addClass('activity');

        if (className == 'official_gift') {
            integral_box.addClass('hidden')
            official_box.removeClass('hidden')
            if(oGiftId <= 0){
                loadData('official');
            }
        }else{
            official_box.addClass('hidden')
            integral_box.removeClass('hidden')
            if(iGiftId <= 0){
                loadData('integral');
            }
        }
    }

    var startX = 0,startY = 0,endX = 0, endY = 0,distanceX = 0,distanceY = 0;
    $('.all_content').bind('touchstart',function(e){
        startX = e.originalEvent.changedTouches[0].pageX;
        startY = e.originalEvent.changedTouches[0].pageY;
    });
    $('.all_content').bind('touchmove',function(e){
        endX = e.originalEvent.changedTouches[0].pageX;
        endY = e.originalEvent.changedTouches[0].pageY;
        //获取滑动距离
        distanceX = endX-startX;
        distanceY = endY-startY;

        // 获取屏幕滚动的高度/偏移量
        var scrollH = $('.all_content').scrollTop();

        if(Math.abs(distanceX)>Math.abs(distanceY) && distanceX>0){

        }else if(Math.abs(distanceX)>Math.abs(distanceY) && distanceX<0){

        }else if(Math.abs(distanceX)<Math.abs(distanceY) && distanceY<0){
            //拉到底部加载新帖子
            var scrollHeight = $('.all_content').prop('scrollHeight');
            var clientHeight = $(document).height();

            if(!official_box.hasClass('hidden')){
                if(scrollHeight <= clientHeight+scrollH && loadOfficial){
                    $('.load-more').show();
                    loadMore = true;
                }
            } else if(!integral_box.hasClass('hidden')){
                if(scrollHeight <= clientHeight+scrollH && loadIntegral){
                    $('.load-more').show();
                    loadMore = true;
                }
            }
        }
    });
    $('body').bind('touchend',function(e){
        if(loadMore){
            $('.load-more').hide();
            $('.load-more').html('加载更多内容');
            loadMore = false;
            if(!official_box.hasClass('hidden')){
                loadData('official');
            } else if(!integral_box.hasClass('hidden')){
                loadData('integral');
            }
        }
    });

    /**
     * 加载数据
     * @param  {[string]} type [加载类型]
     * @return {[type]}      [description]
     */
    function loadData(type){
        if(type == 'integral' && loadIntegral){
            loadIntegral = false;
            //var url = 'http://bbs.test.q-dazzle.com/index.php?m=wap&c=OneGame&fid=5&page=' + loadIntegralPage + '&ajax=ajax';
            var url = 'index.php?m=wap&c=Gift&a=ajaxRun&ajax=ajax&gift_type=point&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&current_id='+iGiftId;

            var loadtf = ajaxData(url, integral_box.children('ul'),type);
            if(loadtf == 'loadNext'){
                setTimeout(function(){
                    loadIntegral = true;
                }, 1000);
            }
        } else if(type == 'official' && loadOfficial){
            loadOfficial = false;
            //var url = 'http://bbs.test.q-dazzle.com/index.php?m=wap&c=OneGame&fid=5&page=' + loadOfficialPage + '&ajax=ajax&orderby=postdate';
            var url = 'index.php?m=wap&c=Gift&a=ajaxRun&ajax=ajax&gift_type=except_point&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&current_id='+oGiftId;

            var loadtf = ajaxData(url, official_box.children('ul'),type);
            if(loadtf == 'loadNext'){
                setTimeout(function(){
                    loadOfficial = true;
                }, 1000);
            }
        }
    }

    /**
     * 将数据放入dom
     * @param  {[string]} loadUrl  [请求url]
     * @param  {[obj]} loadObj  [加载对象]
     * @param  {[string]} type  [加载类型]
     * @return {[string]}          [判断是否还可以加载]
     */
    function ajaxData(loadUrl, loadObj, type){
        var loadtf = 'loadNext';
        $.ajax({
            url:loadUrl,
            type:'GET',
            async:false,
            success:function(data){
                data = eval('('+data+')');

                var code = data['code'];        //返回码
                var is_bottom = data['is_bottom'];      //是否最后
                var current_id = data['current_id'];        //最后加载的id
                var list = data['data'];        //数据

                //没有加载内容
                if(code != 1){
                    //加载的是所有话题
                    if(current_id == 0 && type == 'official'){
                        loadObj.append('<li><div class="topic-title t_center">暂无官方礼包！</div></li>');
                    } else if(current_id == 0 && type == 'integral'){
                        loadObj.append('<li><div class="topic-title t_center">暂无积分礼包！</div></li>');
                    } else{
                        loadObj.append('<div class="uncontent gray-font">已显示全部内容</div>');
                    }

                    loadtf = 'loadOut';
                    return loadtf;
                }

                if(type == 'official'){
                    oGiftId = current_id;
                    for(var i = 0; i < list.length; i++) {
                        var get_bt = '';
                        if(list[i]['rest_num'] <= 0){
                            get_bt = '<a class="have_no_leavings" href="javascript:;">已抢完</a>';
                        } else if(list[i]['is_get'] == 1){
                            get_bt = '<a class="have_getten" href="javascript:;" onclick="ajax_get_gift('+list[i]['gift_id']+',this)">已领取</a>';
                        } else{
                            get_bt = '<a class="get_welfare" href="javascript:;" onclick="ajax_get_gift('+list[i]['gift_id']+',this)">领取</a>';
                        }

                        var temp = '<li>';
                        temp += '<div class="welfare_detail clearfix">';
                        temp += '<a class="imgWrap">';
                        // temp += '<img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-guanfang.png" alt="">';

                        temp += '<img class="img_icon" src="'+list[i]['icon']+'" alt="">';
                        temp += '</a>';
                        temp += '<h5>'+list[i]['gift_name']+'</h5>';
                        temp += '<p class="welfare_detail_desc">'+list[i]['gift_content']+'</p>';
                        temp += '<p class="welfare_remain">剩余：<i id="rest_num_'+list[i]['gift_id']+'">'+list[i]['rest_num']+'</i></p>';
                        temp += '<span class="welfare_download_a">'+get_bt+'</span>' ;
                        temp += '</div>';
                        temp += '</li>'
                        loadObj.append(temp);
                    }
                } else{
                    iGiftId = current_id;
                    for(var i = 0; i < list.length; i++) {
                        var temp = '<li onclick="trunUrl('+list[i]['gift_id']+')">';
                        temp += '<div class="welfare_detail clearfix">';
                        temp += '<a class="imgWrap">';
                        if(list[i]['remain_time'] >= 0){
                            // <!-- 限时 -->
                            temp += '<img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-xianshi-new.png" alt="">';
                        } else{
                            // <!-- 积分 -->
                            temp += '<img class="gift-img" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gift-xiansjifenhi.png" alt="">';
                        }                       
                        
                        temp += '<img class="img_icon" src="'+list[i]['icon']+'" alt="">';
                        temp += '</a>';
                        temp += '<h5>'+list[i]['gift_name']+'</h5>';

                        if(list[i]['remain_time'] >= 0){
                            if(list[i]['remain_time'] > 0){
                                temp += '<span class="remain_time" time_data="'+list[i]['remain_time']+'">限时礼包</span>';
                            } else{
                                temp += '<span class="remain_time_out" time_data="'+list[i]['remain_time']+'">已过期</span>';
                            }
                        } 

                        temp += '<p class="welfare_detail_desc">点击查看礼包内容</p>'
                        temp += '<p class="welfare_remain"><span class="fl">销量：<i class="blue">'+(list[i]['total_num']-list[i]['rest_num'])+'</i></span><span class="welfare_integral fr">所需积分：<i class="blue">'+list[i]['point']+'</i></span></p>'
                        temp += '</div>';
                        temp += '</li>'
                        loadObj.append(temp);
                    }
                }

                //已经加载完
                if(is_bottom == 1){
                    //加载的是官方礼包
                    if(oGiftId == 0 && type == 'official'){
                        loadObj.append('<li><div class="topic-title t_center">暂无官方礼包！</div></li>');
                    } else if(iGiftId == 0 && type == 'integral'){
                        loadObj.append('<li><div class="topic-title t_center">暂无积分礼包！</div></li>');
                    } else{
                        loadObj.append('<div class="uncontent gray-font">已显示全部内容</div>');
                    }

                    loadtf = 'loadOut';
                    return loadtf;
                }
            }
        })
        return loadtf;
    }

    //领取礼包
    function ajax_get_gift(gift_id,obj){
        var options = {
            url: "index.php?m=wap&c=Gift&a=getGift",
                type: "GET",
                dataType: "json",
                data:{"gift_id":gift_id},
                success:function(data){
                    if (data.code==2) {
                        //未登录
                        window.location.href="index.php?m=wap&c=Login";
                    } else if(data.code==1){
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

    $(".rec_tip").on("click",function(e){
        e.stopPropagation()
    })

    $(".rec_gift_mask").on("click",function(){
        $(this).hide();
    })

    //领取礼包弹窗
    function show_tip(data,flag) {
        // var marginTop = getScrollTop()+'px';
        /*var marginTop = -$(".q_layout").offset().top;

        $(".rec_gift_mask").css('margin-top',marginTop);*/
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
            } else if(data.code == 13){
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

    function trunUrl(gift_id){
        location.href = "index.php?m=wap&c=Gift&a=giftDetails&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&gift_id="+gift_id;
    }


    $(function(){
        var st = window.setInterval(function(){
            $.each($('.remain_time'),function(){
                var time_data = $(this).attr('time_data');
                time_data -= 1;
                if(time_data <= 0){
                    $(this).addClass('remain_time_out').removeClass('remain_time');
                    return;
                } else{
                    hour_time = Math.floor((time_data)/(60*60));
                    minute_time = Math.floor((time_data-hour_time*60*60)/(60));
                    second_time = time_data-hour_time*60*60-minute_time*60;
                    var remain_time = hour_time+':'+minute_time+':'+second_time;
                    $(this).attr('time_data', time_data);
                    $(this).html(remain_time); 
                }  
            })
        }, 1000)
    })
    

</script>
</body>
</html>