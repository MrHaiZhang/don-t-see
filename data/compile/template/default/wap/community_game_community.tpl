
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
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css?2">
        <!-- <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community_game_community.css"> -->
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/intro.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
        <style type="text/css">
                    
            .game-list h1,.game-list p{text-align:left;}

            .second-section{padding-bottom: 40px;}
            /*社区页面*/
            .gamelist {
                position: relative;
                text-align: left;
                width: 100%;
                box-sizing: border-box;
                background: #fff;
                padding: 14px;
                height: 100px;
            }
            .game_community_title{
                border-bottom: 1px solid #e5e5e5;
                text-align: left;
                height: 86px;
            }
            .gamelist .header-icon-body {
                float: left;
                width: 72px;
                height: 72px;
                display: inline-block;
            }
            .gamelist .header-icon-body img {
                width: 100%;
                border-radius: 18%;
            }
            .gamelist .main-header-text {
                margin: 0;
                display: inline-block;
                height: auto;
                text-align: left;
                padding: 0px 0px 0px 10px;
            }
            .gamelist .main-header-text p{text-align:left;}
            .follow_btn {
                display: inline-block;
                padding-top: 12px;;
                float: right;
                    padding-left: 5px;
                padding-right: 5px;
            }
            .follow_btn a.follow{
                border-radius: 5px;
               /*  color: #1ea4f2; */
               color:rgba(0,0,0,0);
                display: inline-block;
                font-size: 10pt;
                /* padding:3px 10px; */
                    padding: 6px 21px;
                margin-bottom: 12px;
                background-color: #fff;
                /* border:1px solid #1ea4f2; */
                background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-sign.png);
                background-size: contain;
                background-repeat: no-repeat;
            }
            .follow_btn a.followed {
                border-radius: 5px;
                /* color: #fff; */
                /* background-color:#1ea4f2; */
                color:rgba(0,0,0,0);
                display: inline-block;
                font-size: 10pt;
                /* padding:3px 10px; */
                 padding: 6px 14px;
                margin-bottom: 27px;
                /* border:1px solid #1ea4f2; */
                background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-signed.png);
                background-size: contain;
                background-repeat: no-repeat;
            }
            .gamelist .main-header-text h1 {
                display: inline-block;
                margin: 0;
                line-height: 30px;
                max-height: 60px;
                vertical-align: top;
                font-size: 18px;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
                color: #333;
                text-align: left;
            }

            @media screen and (max-width: 350px){
            .section_ul a{width:67px!important;height: 67px!important;}
            .section_ul li a span{    width: 46px!important;height: 46px!important;}
            .gamelist .main-header-text h1{font-size: 15px;}
            }
            /*.bulletin-title{text-align:left;font-size: 14px;white-space:nowrap;overflow:hidden;text-overflow: ellipsis;    color: #333;}*/

            .gamelist .main-header-text .game_type {
                color: #1ea4f2;
                font-size: 14px;
                margin-bottom: 6px;
                text-align: left;
            }
            .section_ul{display:-webkit-box;display:-webkit-flex;display:-ms-flexbox;display:flex;-webkit-box-pack:justify;-webkit-justify-content:space-between;-ms-flex-pack:justify;justify-content:space-between;-webkit-box-align: center;-webkit-align-items: center;-ms-flex-align: center;align-items: center;    padding: 9px 0;}
            .section_ul li{display:inline-block;position: relative;}
            .section_ul a{display:inline-block;width:76px;height: 76px;position: relative;}

            .section_ul li i{display:inline-block;    color: #666;    position: absolute;bottom: 0;width: 100%;left: 0;}
            .section_ul li a span{display:inline-block;width:56px;height: 56px;background-size:100%;background-repeat:no-repeat;background-position:center;}


            .section_ul li a.game span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-game.png);}
            .section_ul li a.gift span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-gift.png);}
            .section_ul li a.news span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-new.png);}
            .section_ul li a.cust span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/z-cs.png);}
            span.shuxian {
                display: inline-block;
                width: 1px;
                height: 53px;
                background-color: #e5e5e5;
                margin-top: 3%;
            }

            .bulletin .bulletin-li{border-top:1px solid #e5e5e5;}
            .topic-top{height:50px;position: relative;border-bottom:1px solid #e5e5e5;}
            .topic-top .topic-icon{position: absolute;left:0;top:10px;width:32px;height:32px;border-radius: 50%;}
            .topic-top h3{    position: absolute;left: 0;top: 17px;color: #949494;font-size: 16px;box-sizing: border-box;width: 100%;font-weight: normal;text-align: left;padding-left: 40px;line-height: 1;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;}
            .topic_tab{display: flex; justify-content: space-around;    border-bottom: 1px solid #e5e5e5;    background-color: #fff;position:relative;}
            .topic_tab h2.activity{color:#1ea4f2;font-weight:700;}
            .topic_tab i.vertical_line{background:#1ea4f2;width:50%;height:4px;position:absolute;left:0;top:36px;-webkit-transition: -webkit-transform .3s ease-in-out;-moz-transition: -moz-transform .3s ease-in-out;-ms-transition: -ms-transform .3s ease-in-out;transition: transform .3s ease-in-out;}
            .topic_tab h2:nth-of-type(1).activity~.vertical_line {
                transform: translateX(0);
                -webkit-transform: translateX(0);
            }
            .topic_tab h2:nth-of-type(2).activity~.vertical_line {
                transform: translateX(100%);
                -webkit-transform: translateX(100%);
            }
            .topic-title .bulletin-title{font-weight: 700;}
            .uncontent{ text-align: center; padding: 10px 14px; }
            .topic-brief p{text-align:left;}

            .discuss-box{    padding: 10px 0;display: flex;justify-content: space-around;-webkit-justify-content: space-around;}
            .discuss-box span{float: left;width:20px;height: 20px;background-size:100%;background-repeat:no-repeat;background-position:center;}
            .discuss-box .read-num span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/look.png);    background-size: 125%;}
            .discuss-box .discuss-num span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/pinglun.png);}
            .discuss-box .like-num span{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/zan.png);}
            .topic-list li{margin-bottom:10px;background-color: #fff;padding: 0 14px;}
            /*.topic-list li a{display:inline-block;}*/
            .to-top{position:fixed;right:10px; bottom:80px; background-color:#1ea4f2;color:#fff;font-size: 14px;width:50px;height:50px;border-radius:23px;padding: 7px;z-index: 99;}
            .bottom-nav div,.bottom-nav a{display:inline-block;}
            .publish a{display:inline-block;font-size: 14px;background-color:#1ea4f2;color:#fff;width:100%;border-radius:5px;    line-height: 34px;}
            .back-icon a{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/back1.png);background-size: 95%;}
            .user-center a{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/user1.png);}
            .user-center{position:relative;}
            .show-new-message{position:absolute;right: -5px;width: 19px;height: 19px;border-radius:9px;background-color:#ff9600;color:#fff;line-height: 18px;}
            /*滚动到话题部分时冻结*/
            .q_layout{height: 100%;}
            .fixed-head-box{position: absolute;width: 100%;height: 100%;top: 0;left: 0;}
            .scroll-body-box{position: absolute;width: 100%;height: 94%;top: 40px;left: 0;overflow-y:scroll;}
            .fixed-tab{position:fixed;width: 100%;top: 0;}

            .t_center{ text-align: center; }
            .discuss-img-box{    border-bottom: 1px solid #e0e0e0;padding-bottom: 14px;padding-top: 4px;box-sizing: content-box;height:auto !important;overflow: hidden;}
            .img-box{
                width:30%;
                display: inline-block;
                float:left;
                overflow: hidden;
                box-sizing: content-box;
                position: relative;
            }
            .img-box:nth-child(2),.img-box:nth-child(3){
                margin-left: 5%;
            }
            .img-box img{
                width:100%;
                position: relative;
                left:0;
                top:50%;
                -webkit-transform: translateY(-50%);
                -ms-transform: translateY(-50%);
                transform: translateY(-50%);
            }
            .pb10-pb1{padding-bottom: 10px;border-bottom: 1px solid #e5e5e5;}
            .load-more{ line-height: 25px; display: none; }

            /* 签到功能 */
            .user-msg{position: absolute;left: 32%;top: 0;}
            .user-name{font-weight: 700;font-size: 20px;color: #fff;text-align: left;}
            .user-sign-box{background-color: #fff; display: inline-block;width: 90%;height:auto !important;
             height:580px;background:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/bg.jpg);background-size: cover;background-repeat:no-repeat;}
            .sign-title{position: relative;    height: 71px;}

            .sign-btn{height: 44px; width: 30%;margin: 0 auto;}
            .sign-btn.sign{background:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/signinnow.png); background-size:contain;background-repeat: no-repeat;}
            .sign-btn.sign-fin{background:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/sign-fin.png); background-size:contain;background-repeat: no-repeat;}
            .sign-btn.had-sign{background:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/signinnow.png); background-size:cover;}
            .sign-table{padding:0 6%;  padding-top: 19px;}
            .user-gender{display:inline-block;width: 17px;height: 17px;margin-left: 8px;margin-top: 5px;}
            .user-gender.male{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gender-male.png);background-size: contain;}
            .user-gender.female{background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/gender-female.png);background-size: contain;}
            .sign-row{   /*  display: -webkit-box;display: -webkit-flex;display: -ms-flexbox;display: flex;-webkit-justify-content: space-around;-ms-flex-pack: distribute;justify-content: space-around;  */height: 83px; }
            .sign-row div{display:inline-block;width: 29%;height:94px; background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/1.png) center;-webkit-background-size: contain;
            background-size: contain;background-repeat:no-repeat;}
            .sign-row .day3{ background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/13.png)  center;-webkit-background-size: contain;background-size: contain;background-repeat:no-repeat;}
            .sign-row .day4{ background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/14.png)  center;-webkit-background-size: contain;background-size: contain;background-repeat:no-repeat;}
            .sign-row .day5{ background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/15.png)  center;-webkit-background-size: contain;background-size: contain;background-repeat:no-repeat;}
            .sign-row .day6{ background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/16.png)  center;-webkit-background-size: contain;background-size: contain;background-repeat:no-repeat;}
            .sign-row-day7{    margin-top: -3px;margin-bottom: 17px;height: 100px;}

            .sign-row .day7-wrap{width: 60%;min-height: 80px;/* height: 120px; */padding-top: 3px;background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/17bg.png);background-repeat:no-repeat;background-size: cover;margin-bottom: 17px;}
            .sign-row .day7{width: 52%;min-height:97px; height: 104px;background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/17.png);background-repeat:no-repeat;background-size: contain;}

            .sign-introduction-wrap{width: 100%;padding-left: 8%;    position: relative;min-height: 92px;height: 201px;}

            @media screen and (min-width:620px) {
                .sign-title{    margin-top: 0%;}
                .user-sign-box{    width: 60%;}
                .sign-introduction-wrap {height: 250px!important;    padding-left: 13%;}
                .sign-introduction{    top: -18px!important;}
                .sign-row-day7{height: 142px!important;}
                .sign-row{height: 145px;}
                .sign-row div{    width: 32%;    height: 130px;}
                .sign-table{    padding-top: 95px;}
                .sign-row .day7{    height: 179px;}
                .sign-btn{height: 70px;width: 23%;}
                .user-msg{left: 28%!important;}
                .user-name{font-size: 35px; }
                .user-gender{width: 33px;height: 33px;}
                .user-point{font-size: 21px!important;}
                .point-num{font-size: 26px!important;}
                .signed-introduction-wrap{margin-bottom: 128px!important;}
                .signed-introduction{    width: 65%!important;    height: 120%!important;}
                .sign-tip{line-height: 64px!important;font-size: 16px!important;top: 30px;}
                .jifenshu{font-size: 16px!important;}
            }  

            @media screen and (max-width:620px) and (min-width: 520px) {
                .sign-title{    margin-top: 0;}
                .user-sign-box{    width: 72%;}
                .sign-row div{height: 118px!important;}
                .sign-introduction-wrap {height: 226px!important;    padding-left: 10%;}
                .sign-introduction{    top: -42px;}
                .sign-row-day7{height: 115px!important;}
                .sign-row{height: 145px;}
                .sign-table{    padding-top: 55px;}
                .sign-row .day7{    height: 179px;}
                .user-msg{left: 30%!important;}
                .user-name{font-size: 28px!important;}
                .user-point{font-size: 21px!important;}
                .point-num{    font-size: 25px!important;}
                .signed-introduction-wrap{margin-bottom: 103px!important;}
                .signed-introduction{    height: 114%!important;}
                .sign-tip{line-height: 64px!important;font-size: 16px!important;top: 30px;}
                .jifenshu{font-size: 16px!important;}
                .sign-btn-wrap{    bottom: 35px!important;}
                .user-gender{width: 24px!important;    height: 24px!important;}
            }

            @media screen and (max-width: 520px) {
                .sign-title{    margin-top: 1%;}
                .user-sign-box{    width: 80%!important;}
                .sign-table{padding-top: 28px;}
                .sign-introduction-wrap {height: 166px!important;}
                .sign-row-day7{height: 94px!important;}
                .sign-row .day7{    height: 117px;}
                .sign-row{height: 105px;}
                .user-name{margin-top: 3px;}
                .signed-introduction-wrap{    margin-bottom: 42px!important;}
                .signed-introduction{    height: 104%!important;}
                .sign-tip{    line-height: 41px!important;font-size: 12px!important;}
                .jifenshu{font-size: 12px!important;}
            }
            @media screen and (max-width: 375px) {
                 .user-sign-box{    width: 76%!important;}
                .sign-table{padding-top: 0px;}
                .sign-introduction-wrap {height: 155px!important;}
                .sign-introduction{    width: 84%!important;    top: -18px!important;}
                .sign-row-day7{height: 83px!important;}
                .sign-row .day7{    height: 117px;}
                .sign-row{height: 94px;}
                .user-name{margin-top: 0px;}
                .sign-btn-wrap{bottom: 13px!important;}
                .signed-introduction-wrap{margin-bottom: 31px!important;}
                .signed-introduction{    width: 74%!important;  height: 100%!important;}
            }

            @media screen and (max-width: 320px) {
                .sign-title{margin-top: 0;height: 66px;}
                .sign-table{padding-top: 0px;}
                .sign-introduction-wrap {height: 128px!important;}
                .sign-row-day7{height: 66px!important;}
                .sign-row{height: 83px;}
                .user-name{margin-top: 0px;font-size: 17px;}
                .sign-btn-wrap{bottom: 4px!important;}
                .signed-introduction-wrap{margin-bottom: 8px!important;}
                .signed-introduction{height: 95%!important;}
                .sign-tip{    line-height: 26px!important;font-size: 12px!important;top: 23px!important;}
                .jifenshu{font-size: 14px!important;}
                .sign-introduction{top: -17px!important; }
                .point-num{    font-size: 13px!important;}
                .user-point{    font-size: 12px!important;}
                .sign-row div{height: 77px;}
                .signed-introduction{   width: 74%!important;}
                .user-gender{margin-left: 3px!important;}
            }

            .sign-introduction{    position: absolute;top: -26px;width: 88%;height:165px; background:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/shuoming.png);background-size: contain;background-repeat: no-repeat;}
            .head-img-wrap{display: inline-block;width: 23%; margin-left: 6%;position: absolute;top: 8px;left: 0; background-color: #0090cf;    overflow: hidden;    border-radius: 50%;display: -webkit-box;    display: -webkit-flex;    display: -ms-flexbox;    display: flex;    -webkit-box-align: center;    -webkit-align-items: center;    -ms-flex-align: center;    align-items: center;-webkit-box-pack: center;-webkit-justify-content: center;-ms-flex-pack: center;justify-content: center;  }
            .head-img{display: inline-block;width: 92%; overflow: hidden;    border-radius: 50%;}
            .user-point{text-align: left;    color: #fff;font-size: 13px;}
            .point-num{font-size: 15px;}
            .close-btn-wrap{margin-top: 6px;}
            .close-btn{width: 40px;height: 40px;margin:0 auto; background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/close-icon.png)  center;-webkit-background-size: contain;background-size: contain;background-repeat:no-repeat;}

            .signed-introduction-wrap{height: 124px;margin-bottom:20px;    width: 100%;}
            .signed-introduction{ background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/signed.png);background-size: contain;background-repeat:no-repeat;width: 68%;margin: 0 auto; height:100%;   position: relative;  }
            .sign-ok-wrap{position: absolute;bottom: 9px;width:100%;}
            .sign-ok{background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/queding.png);background-size: contain;background-repeat:no-repeat;width: 35%; height:58px;margin-top: 30px;    margin: 0 auto;}
            .sign-share{background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/xuanyao.png);background-size: contain;background-repeat:no-repeat;width: 35%; height:58px;margin-top: 30px;position: absolute;bottom: 9px;left:12%;}

            .sign-btn-wrap{position:absolute;width:100%;bottom:15px;}
            .user-sign-box{position:relative;}
            .sign-tip{position:absolute;top: 25px;width: 100%;text-align: center;line-height: 36px;font-size: 15px;color: #2d6d95;}
            .jifenshu{font-size: 15px;}

            /* 新手引导“礼包福利”引导样式 */
            .rec_tip .showGuide2 span{    display: inline-block;
                width: 56px;
                height: 56px;
                background-size: 100%;
                background-repeat: no-repeat;
                background-position: center;background-image: url(http://bbs.test.q-dazzle.com/themes/site/wap/images/community/z-gift.png);}
            .rec_tip .showGuide2 a.gift{    display: inline-block;
                width: 76px;
                height: 76px;
                position: relative;}
            .rec_tip .showGuide2 i{display: inline-block;
                color: #666;
                position: absolute;
                bottom: 0;
                width: 100%;
                left: 0;}
            .rollmsg{ background-color: #fff; width: 100%; height: 30px; line-height: 30px; padding-left: 100%; overflow: hidden; }
            .rollmsg span{ font-size: 14px; white-space:nowrap; position: relative; }
        </style>
    </head>
    <body>
    <div class="to-top">
        <p>返回</p>
        <p>顶部</p>
    </div>
    <div class="bottom-nav">
            <div class="back-icon"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>"></a></div>
            <div class="publish">
                <a href="javascript:void(0);" onClick="toNewPost()">发布话题</a>
            </div>
            <div class="user-center">
                <?php  if($unreadCount){ ?>
                <span class="show-new-message"><?php echo htmlspecialchars($unreadCount, ENT_QUOTES, 'UTF-8');?></span>
                <?php  } ?>
                <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserCenter&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"></a>
            </div>
        </div> 
   <div class="all_content">
        <div class="q_layout">
        <!-- 返回顶部 -->
        

        <div class="first-section">
            <div class="gamelist">
                <div class="game_community_title">
                    <div class="header-icon-body">
                      <img src="<?php echo htmlspecialchars(Pw::getPath($pwforum->foruminfo['icon']), ENT_QUOTES, 'UTF-8');?>" id="icon_id" alt="" title="">
                    </div>
                    <div class="main-header-text">
                      <h1 id="game_name"><?php echo $pwforum->foruminfo['name'];?></h1>
                      <p class="">关注：<span><?php echo htmlspecialchars($countUserByFid, ENT_QUOTES, 'UTF-8');?></span></p>
                      <p class="">话题：<span><?php echo htmlspecialchars($countThreadsByFid, ENT_QUOTES, 'UTF-8');?></span></p>
                    </div>
                    <!-- <div class="follow_btn" onclick="followGame()"> -->
                    <div class="follow_btn showGuide" onclick="signInAndFollow()" data-step="1" data-intro="点击签到<br>每日可以获得大量积分哦！">
                        <?php  if ($havePunch) { ?>
                        <a class="followed" href="#">已签到</a>
                        <?php  } else { ?>
                        <a class="follow" href="#">签到</a>
                        <a class="followed hidden" href="#">已签到</a>
                        <?php  } ?>
                    </div>
                </div>
            </div>
            <?php  if ($open_str) { ?>
                <div class="rollmsg"><span>开服信息：<?php echo htmlspecialchars($open_str, ENT_QUOTES, 'UTF-8');?></span></div>
            <?php  } ?>
            <div class="clr"></div>
            <!-- 版块、公告 -->
            <div class="section">
                <ul class="section_ul flex-box">
                    <li><a class="game" onclick="toModel(1, '<?php echo htmlspecialchars($pwforum->foruminfo['get_url'][0], ENT_QUOTES, 'UTF-8');?>')"><span></span><i>游戏下载</i></a>
                    </li>
                    <span class="shuxian"></span>

                    <li class="showGuide2" data-step="2" data-intro="游戏礼包全在这里<br>还可以用积分兑换高价值道具哦~"><a class="gift" onclick="toModel(2, '<?php echo htmlspecialchars($pwforum->foruminfo['get_url'][1], ENT_QUOTES, 'UTF-8');?>')"><span></span><i>礼包福利</i></a>
                    </li>
                    <span class="shuxian"></span>

                    <li><a class="news" onclick="toModel(3, '<?php echo htmlspecialchars($pwforum->foruminfo['get_url'][2], ENT_QUOTES, 'UTF-8');?>')"><span></span><i>游戏资讯</i></a>
                    </li>
                    <span class="shuxian"></span>

                    <li><a class="cust" onclick="toModel(4, '<?php echo htmlspecialchars($pwforum->foruminfo['get_url'][3], ENT_QUOTES, 'UTF-8');?>&UserId=<?php echo htmlspecialchars($loginUser->username, ENT_QUOTES, 'UTF-8');?>')"><span></span><i>联系客服</i></a></li>
                </ul>
                <!-- 公告 -->
                <ul class="bulletin">
                    <?php  if($notice_list){
                        foreach ($notice_list as $key => $value) { ?>
                            <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&prev_fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&tid=<?php echo htmlspecialchars($value['tid'], ENT_QUOTES, 'UTF-8');?>">
                                <li class="bulletin-li">
                                    <?php  if($value['extend'] != null && $value['extend']['type'] == 4){ ?>
                                        <span class="active-icon">活动</span>
                                    <?php  } else{ ?>
                                        <span class="bulletin-icon">公告</span>
                                    <?php  } ?>
                                    <p class="bulletin-title"><?php echo $value['subject'];?></p>
                                </li>
                            </a>
                       <?php  }
                    } ?>
                </ul>
            </div>
        </div>

        <!-- 热门话题、所有话题 -->
        <div class="second-section">
        <!-- 选项卡滚到顶部时冻结在顶部 -->
            <div class="topic_tab flex-box">
                <h2 class="hot-topic activity" onclick="change_topic('hot-topic')">热门话题</h2>
                <h2 class="all-topic" onclick="change_topic('all-topic')">所有话题</h2>
                <i class="vertical_line under_line"></i>
            </div>

            <div class="hot-topic-box">
                <ul class="topic-list">
                    <?php  if($threaddb){
                        foreach ($threaddb as $key => $value) {  
                            if($value['fid'] == $fid && !$value['notice']){ ?>
                    <li id="hot-id-<?php echo htmlspecialchars($value['tid'], ENT_QUOTES, 'UTF-8');?>">
                        <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&tid=<?php echo htmlspecialchars($value['tid'], ENT_QUOTES, 'UTF-8');?>&anchor=hot-id-<?php echo htmlspecialchars($value['tid'], ENT_QUOTES, 'UTF-8');?>">
                            <div class="topic-top">
                                <?php  if($value['headcheck'] == 1){ ?>
                                    <img src="<?php echo htmlspecialchars(Pw::getAvatar(0), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>" class="topic-icon"/>
                                <?php  } else{ ?>
                                    <img src="<?php echo htmlspecialchars(Pw::getAvatar($value['created_userid']), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>" class="topic-icon"/>
                                <?php  } ?>
                                <h3><?php echo htmlspecialchars($value['created_username'], ENT_QUOTES, 'UTF-8');?></h3>
                            </div>
                            <div class="topic-title bulletin-li">
                                <?php  if($value['topped']){ ?>
                                <span class="bulletin-icon">置顶</span>
                                <?php  } 
  if($value['digest']){ ?>
                                <span class="essence-icon">精华</span>
                                <?php  } 
  if(($value['extend'] == null || ($value['extend'] != null && $value['extend']['type'] != 4)) && $value['official']){ ?>
                                <span class="official-icon">官方</span>
                                <?php  } 
  if($value['extend'] != null){ 
  if($value['extend']['type'] == 0){ ?>
                                        <span class="extend-icon">综合讨论</span>
                                    <?php  } else if($value['extend']['type'] == 1){ ?>
                                        <span class="extend-icon">问题建议</span>
                                    <?php  } else if($value['extend']['type'] == 2){ ?>
                                        <span class="extend-icon">萌新求助</span>
                                    <?php  } else if($value['extend']['type'] == 3){ ?>
                                        <span class="essence-icon">大神攻略</span>
                                    <?php  } else if($value['extend']['type'] == 4){ ?>
                                        <span class="active-icon">活动</span>
                                    <?php  } 
  } ?>
                                <p class="bulletin-title"><?php echo $value['subject'];?></p>
                            </div>
                            <div class="topic-brief">
                                <div class="post_text_size show_2_line gray-font"><?php echo $value['content'];?></div>
                            </div>
                            <!-- 自动显示文章中的图片，超过3张也显示3张，不够3张左对齐 -->
                            <?php  if($value['content_img']) {  ?>
                                <div class="discuss-img-box">
                                <?php  foreach ($value['content_img'] as $k => $v) {  
  if($k < 3){ ?>
                                    <div class="img-box"><img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="未上传"></div>
                                    <?php  } 
  } ?>
                                </div>
                            <?php  } ?>
                            <div class="clr"></div>
                            <div class="discuss-box flex-box">
                                <div class="read-num"><span></span><i><?php echo htmlspecialchars($value['hits'], ENT_QUOTES, 'UTF-8');?></i></div>
                                <div class="discuss-num"><span></span><i><?php echo htmlspecialchars($value['replies'], ENT_QUOTES, 'UTF-8');?></i></div>
                                <?php  if($value['seachLike'] == 'inlike'){  ?>
                                    <div class="like-num liked-num"><span></span><i><?php echo htmlspecialchars($value['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                <?php  } else if($value['seachLike'] == 'mylike'){  ?>
                                    <div class="like-num"><span></span><i><?php echo htmlspecialchars($value['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                <?php  } else{ ?>
                                    <div class="like-num"><span></span><i><?php echo htmlspecialchars($value['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                <?php  } ?>
                            </div>
                        </a>
                    </li>
                            <?php  }
                        }
                    } else{ ?>
                        <li><div class="topic-title t_center">暂时没有热门话题哦！<br/>到所有话题互动一下吧~</div></li>
                    <?php  } ?>
                </ul>
            </div>
    
            <div class="all-topic-box hidden">
                <ul class="topic-list"></ul>
            </div>
            
            <div class="load-more">加载更多内容</div>
        </div>
        
    </div>
    </div>
    <!-- 签到弹窗 -->
    <div class="change-rec_gift_mask user-sign-box-mask" style="display: none;" onclick="closeSign()">
            <div class="user-sign-box">
            <!-- 签到标题 -->
            <div class="sign-title">
                 <div class="head-img-wrap"><div class="head-img"><img src="<?php echo htmlspecialchars(Pw::getAvatar($userInfo['uid'],'big'), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time, ENT_QUOTES, 'UTF-8');?>" alt="" style="width: 100%;"></div></div>
                <div class="user-msg">
                    <p class="user-name"><?php echo htmlspecialchars($userInfo['username'], ENT_QUOTES, 'UTF-8');?><span class="user-gender-wrap">
                    <?php  if($userInfo['gender'] == 0){ ?>
                        <span class="user-gender male"></span>
                    <?php  } else{ ?>
                        <span class="user-gender female"></span>
                    <?php  } ?>
                    </span></p>
                    <p class="user-point">我的积分：<span class="point-num"><?php echo htmlspecialchars($plat_credit, ENT_QUOTES, 'UTF-8');?></span></p>
                </div>
            </div>

            <!-- 七天签到礼包 -->
            <div class="sign-table">
                <div class="sign-row">
                    <?php  for($i = 0; $i < 3; $i++){
                        if($i < $user_punch){ ?>
                            <div class="day<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>" style="background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>.png) center; -webkit-background-size: contain; background-size: contain; background-repeat: no-repeat;"></div>
                        <?php  } else{ ?>
                            <div class="day<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>" style="background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/1<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>.png) center; -webkit-background-size: contain; background-size: contain; background-repeat: no-repeat;"></div>
                        <?php  }
                    } ?>
                </div>
                <div class="sign-row">
                    <?php  for($i = 3; $i < 6; $i++){
                        if($i < $user_punch){ ?>
                            <div class="day<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>" style="background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>.png) center; -webkit-background-size: contain; background-size: contain; background-repeat: no-repeat;"></div>
                        <?php  } else{ ?>
                            <div class="day<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>" style="background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/1<?php echo htmlspecialchars($i+1, ENT_QUOTES, 'UTF-8');?>.png) center; -webkit-background-size: contain; background-size: contain; background-repeat: no-repeat;"></div>
                        <?php  }
                    } ?>
                </div>
                <div class="sign-row sign-row-day7">
                    <div class="day7-wrap">
                    <?php  if($user_punch >= 7){ ?>
                        <div class="day7" style="background: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/7.png) center; -webkit-background-size: contain; background-size: contain; background-repeat: no-repeat;"></div>
                    <?php  } else{ ?>
                        <div class="day7"></div>
                    <?php  } ?>
                    </div>
                </div>
            </div>



            <!-- 签到说明 -->
            <div class="sign-introduction-wrap"><div class="sign-introduction"></div></div>
            <!-- 已签到 -->
            <div class="signed-introduction-wrap hidden"><div class="signed-introduction"><div class="sign-tip">恭喜您获得<span class="jifenshu">20积分</span>，再接再厉~</div><div class="sign-ok-wrap"><div class="sign-ok"></div></div><!-- <div class="sign-share"></div> --></div></div>
            
            
             <!-- 签到按钮 -->
            <div class="sign-btn-wrap">
                <?php  if($havePunch){ ?>
                    <div class="sign-btn sign-fin"></div>
                <?php  } else{ ?>
                    <div class="sign-btn sign" onclick="signIn()"></div>
                <?php  } ?>
            </div>

            </div>
            <!-- <div class="close-btn-wrap"><div class="close-btn"></div></div> -->
        </div>



    <script>
    
    $(function() {
        /*执行新手引导*/
        if("<?php echo htmlspecialchars($frist_in, ENT_QUOTES, 'UTF-8');?>" == ''){
            newComerGuide($(".follow_btn"));
        }       
        // newComerGuide($(".follow_btn"));

        setTimeout(function () {
            /**
            * 有discuss-img-box装图片的盒子时是该盒子的下划线分割、没有时topic-brief分割
            */
            $("ul.topic-list li").each(function(index, el) {
                if ($(this).has('.discuss-img-box').length==0) {
                    $(this).children('a').children('.topic-brief').addClass('pb10-pb1')
                }
            });

            /**
            * 帖子中的插图要根据宽度计算高度
            */
            if ($(".discuss-img-box .img-box").length>1) {
                $(".img-box").each(function(index, el) {
                    $(this).height($(this).width())
                });
            }
            
        },300);

        //锚点跳转
        var anchor = "<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>";
        var anchor_arr = anchor.split('-');
        var anchor_type = anchor_arr[0];
        if(anchor){
            if(anchor_type != 'hot'){
                var obj = $(".all-topic");
                obj.parents(".topic_tab").children('h2').each(function(index, el) {
                    $(this).removeClass('activity');
                });
                obj.addClass('activity');

                $(".all-topic-box").removeClass('hidden');
                $(".hot-topic-box").addClass('hidden');
            }

            
            var storage = window.sessionStorage; 
            for (var i=0, len = storage.length; i < len; i++){     
                var key = storage.key(i);
                var value = storage.getItem(key);
                if(key.indexOf('ss_hot_list') >= 0){
                    $('.hot-topic-box .topic-list').append(value);
                } else if(key.indexOf('ss_all_list') >= 0){
                    $('.all-topic-box .topic-list').append(value);
                }
            }

            if(anchor_type == 'hot'){ 
                loadHotPage = sessionStorage.getItem('ss_page_hot');
            } else if(anchor_type == 'all'){
                loadAllPage = sessionStorage.getItem('ss_page_all');
            }

            $(".all_content").animate({scrollTop:$('#'+anchor).offset().top},1);
        } else{
            sessionStorage.clear();
        }

        //滚动开服信息
        var rollmsg = $('.rollmsg');
        var rollstr = rollmsg.find('span');
        if(rollmsg){
            var rollwidth = rollmsg.innerWidth()*2 + rollstr.width();
            var rolltime = rollwidth*10;
            rollstr.animate({ left: '-'+rollwidth+'px' }, rolltime, 'linear', function(){
                rollmsg.remove();
            });
        }
    });





    
    var loadMore = false;       //是否到底

    var loadAllNew = true;     //所有话题判断是否可以加载
    var loadAllPage = 0;     //所有话题当前页数

    var loadHotNew = true;     //热门话题判断是否可以加载
    var loadHotPage = <?php echo htmlspecialchars($page, ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($page, ENT_QUOTES, 'UTF-8');?>:1;     //热门话题当前页数

    /*判断上下滑动：*/
    $('body').bind('touchstart',function(e){
        startX = e.originalEvent.changedTouches[0].pageX;
        startY = e.originalEvent.changedTouches[0].pageY;
    });
    $("body").bind("touchmove",function(e){
        var h_y_fix_bar = parseInt($(".first-section").css('height'));
        //获取滑动屏幕时的X,Y
        endX = e.originalEvent.changedTouches[0].pageX;
        endY = e.originalEvent.changedTouches[0].pageY;
        //获取滑动距离
        distanceX = endX-startX;
        distanceY = endY-startY;

        // 获取屏幕滚动的高度/偏移量
        var scrollH = $('.all_content').scrollTop() //这个类做滚动的

        //判断滑动方向
        if(Math.abs(distanceX)>Math.abs(distanceY) && distanceX>0){
            console.log('往右滑动');
        }else if(Math.abs(distanceX)>Math.abs(distanceY) && distanceX<0){
            console.log('往左滑动');
        }else if(Math.abs(distanceX)<Math.abs(distanceY) && distanceY<0){
            console.log('往上滑动');

            //拉到底部加载新帖子
            var scrollHeight = $('.all_content').prop('scrollHeight');      //滚动条高度
            var clientHeight = $(document).height();      //窗口高度

            if(!$(".all-topic-box").hasClass('hidden')){
                if(scrollHeight <= clientHeight+scrollH && loadAllNew){
                    $('.load-more').show();
                    loadMore = true;
                    //$('.all_content').scrollTop($('.all_content').prop('scrollHeight')-clientHeight);
                }
            } else if(!$(".hot-topic-box").hasClass('hidden')){
                if(scrollHeight <= clientHeight+scrollH && loadHotNew){
                    $('.load-more').show();
                    loadMore = true;
                   // $('.all_content').scrollTop($('.all_content').prop('scrollHeight')-clientHeight);
                }
            }

        } else if(Math.abs(distanceX)<Math.abs(distanceY) && distanceY>0){
            console.log('往下滑动');
            if(loadMore){
                $('.load-more').hide();
                $('.load-more').html('加载更多内容');
                loadMore = false;
            }
        }
    });
    $('body').bind('touchend',function(e){
        if(loadMore){
            $('.load-more').hide();
            $('.load-more').html('加载更多内容');
            loadMore = false;
            if(!$(".all-topic-box").hasClass('hidden')){
                loadData('all');
            } else if(!$(".hot-topic-box").hasClass('hidden')){
                loadData('hot');
            }
        }
    });


    /*切换“热门话题”和“所有话题*/
    function change_topic(className) {
        var obj = $("."+className)
        obj.parents(".topic_tab").children('h2').each(function(index, el) {
            $(this).removeClass('activity')
        });
        obj.addClass('activity');

        if (className == 'hot-topic') {
            $(".all-topic-box").addClass('hidden')
            $(".hot-topic-box").removeClass('hidden')
            if(loadHotPage == 0){
                loadData('hot');
            }
        }else{
            $(".hot-topic-box").addClass('hidden')
            $(".all-topic-box").removeClass('hidden')
            if(loadAllPage == 0){
                loadData('all');
            }
        }

        setTimeout(function () {
            /**
            * 有discuss-img-box装图片的盒子时是该盒子的下划线分割、没有时topic-brief分割
            */
            $("ul.topic-list li").each(function(index, el) {
                if ($(this).has('.discuss-img-box').length==0) {
                    $(this).children('a').children('.topic-brief').addClass('pb10-pb1')
                }
            });

            /**
            * 帖子中的插图要根据宽度计算高度
            */
            if ($(".discuss-img-box .img-box").length>1) {
                $(".img-box").each(function(index, el) {
                    $(this).height($(this).width())
                });
            }
            
        },300);
    }

    /*点击签到-签到后自动会关注*/
    function signInAndFollow() {
        var uid = "<?php echo htmlspecialchars($userInfo['uid'], ENT_QUOTES, 'UTF-8');?>";
        if(uid <= 0){
            window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=login";
            return;
        }
        $(".user-sign-box-mask").fadeIn('fast');
        setTimeout(function () {
            var userSignBoxH = $(".user-sign-box").height()
            var winH = $(window).height()
            var userSignBoxT = (winH-userSignBoxH)/2;
            console.log("userSignBox"+userSignBoxT)
            $(".user-sign-box").css('margin-top', userSignBoxT);
           
            // 禁止滚动
            $(".all_content").css('overflow-y', 'auto');
            $(".head-img").height($(".head-img").width())
            console.log($(".head-img").width())
            $(".head-img-wrap").height($(".head-img-wrap").width()) 
            console.log($(".head-img-wrap").width())
        },50);
    }

    /*点击签到*/
    function onPunch() {
        var punch_state = 'fail';
        $.ajax({
            url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&a=punch&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>",
            async: false,
            type:'GET',
            success:function(data){
                try{
                    data = eval('('+data+')');
                    if(data['state'] == 'success'){
                        $('.jifenshu').html(data['data']['reward']);
                        alert('获得'+data['data']['reward']);
                        punch_state = 'success';
                    } else{
                        punch_state = 'fail';
                    }
                } catch(e){
                    punch_state = 'fail';
                }
            }
        })
        return punch_state;
    }



    // /*点击关注*/
    // function followGame() {
    //     console.log($(".follow_btn"))
    //     $(".follow_btn").children('a').each(function(index, el) {
    //         if($(this).hasClass('hidden')){
    //             that = $(this);//要显示的
    //             if ($(this).hasClass('follow')) {
    //                 /*要显示的是“关注”，说明用户取消关注了*/
    //                 $.ajax({
    //                     url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&a=quit&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>",
    //                     type:'GET',
    //                     success:function(data){
    //                         if(data == 'success'){
    //                             that.removeClass('hidden');
    //                             alert('已取消关注');
    //                         } else if(data == 'login'){
    //                             window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=login";
    //                         }
    //                         console.log(data);
    //                     }
    //                 })
    //             } else{
    //                 /**/
    //                 $.ajax({
    //                     url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&a=join&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>",
    //                     type:'GET',
    //                     success:function(data){
    //                         if(data == 'success'){
    //                             that.removeClass('hidden');
    //                             alert('关注成功');
    //                         } else if(data == 'login'){
    //                             window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Login";
    //                         }
    //                         console.log(data);
    //                     }
    //                 })
    //             }
    //         } else{
    //             $(this).addClass('hidden')
    //         }
    //     });
    // }

   // function toPost(argument) {
   //    window.location.href = "community_game_post.html"
   // }

    /**
    * 加载数据
    * @param  {[string]} type [加载类型]
    * @return {[type]}      [description]
    */
    function loadData(type){
        if(type == 'hot' && loadHotNew){
            loadHotNew = false;
            loadHotPage++;
            var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&page="+loadHotPage+"&ajax=ajax";

            var loadtf = ajaxData(loadHotPage, url, $('.hot-topic-box .topic-list'));
            if(loadtf == 'loadNext'){
                //setTimeout(function(){
                    loadHotNew = true;
                //}, 500);
            }
        } else if(type == 'all' && loadAllNew){
            loadAllNew = false;
            loadAllPage++;
            var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&page="+loadAllPage+"&ajax=ajax&orderby=postdate";

            var loadtf = ajaxData(loadAllPage, url, $('.all-topic-box .topic-list'));
            if(loadtf == 'loadNext'){
                //setTimeout(function(){
                    loadAllNew = true;
                //}, 500);
            }
        }

        setTimeout(function () {
            $("ul.topic-list li").each(function(index, el) {
                if ($(this).has('.discuss-img-box').length==0) {
                    $(this).children('a').children('.topic-brief').addClass('pb10-pb1')
                }
            });
        },100)
    }

    /**
    * 将数据放入dom
    * @param  {[int]} loadPage [页码]
    * @param  {[string]} loadUrl  [请求url]
    * @param  {[obj]} loadObj  [加载对象]
    * @return {[string]}          [判断是否还可以加载]
    */
    function ajaxData(loadPage, loadUrl, loadObj){
        var loadtf = 'loadNext';
        $.ajax({
            url:loadUrl,
            type:'GET',
            async:false,
            success:function(data){
                //console.log(data);
                var fid = <?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>;
                data = eval('('+data+')');

                var page = data['page'];        //页码
                var page_count = data['page_count'];        //总页码
                var total = data['total'];      //总数
                var list = data['list'];        //数据
                
                //已经加载完
                if(page < loadPage ){
                    //加载的是所有话题
                    if(page == 0 && $('.all-topic-box .topic-list').is(loadObj)){
                        loadObj.append('<li><div class="topic-title t_center">暂时没有话题哦！<br/>赶紧来发表一下吧~</div></li>');
                    } else if(page == 0 && $('.hot-topic-box .topic-list').is(loadObj)){
                        
                    } else{
                        loadObj.append('<div class="uncontent gray-font">已显示全部内容</div>');
                    }
                    
                    loadtf = 'loadOut';
                    return loadtf;
                }

                if($('.all-topic-box .topic-list').is(loadObj)){
                    var threads_type = 'all';
                } else if($('.hot-topic-box .topic-list').is(loadObj)){
                    var threads_type = 'hot';
                }

                for(var i = 0; i < list.length; i++) {  
                    if(list[i]['fid'] == fid && list[i]['notice'] == 0){
                        
                        //用户信息
                        var user_message = '';
                        user_message += '<div class="topic-top">'+
                            '<img src="'+list[i]['created_userimg']+'" class="topic-icon"/>'+
                            '<h3>'+list[i]['created_username']+'</h3>'+
                        '</div>';

                        //标签
                        var tab_str = '';
                        if(list[i]['topped'] != 0){
                            tab_str += '<span class="bulletin-icon">置顶</span>';
                        }
                        if(list[i]['digest'] == 1){
                            tab_str += '<span class="essence-icon">精华</span>';
                        }
                        if((list[i]['extend'] == null || (list[i]['extend'] != null && list[i]['extend']['type'] != 4)) && list[i]['official'] == 1){
                            tab_str += '<span class="official-icon">官方</span>';
                        }
                        if(list[i]['extend'] != null){
                            if(list[i]['extend']['type'] == 0){
                                tab_str += '<span class="extend-icon">综合讨论</span>';
                            } else if(list[i]['extend']['type'] == 1){
                                tab_str += '<span class="extend-icon">问题建议</span>';
                            } else if(list[i]['extend']['type'] == 2){
                                tab_str += '<span class="extend-icon">萌新求助</span>';
                            } else if(list[i]['extend']['type'] == 3){
                                tab_str += '<span class="essence-icon">大神攻略</span>';
                            } else if(list[i]['extend']['type'] == 4){
                                tab_str += '<span class="active-icon">活动</span>';
                            }
                        }
                        

                        //图片
                        var content_img = '';
                        if(list[i]['content_img'] != ''){
                            content_img += '<div class="discuss-img-box">';
                            for(var j = 0; j < list[i]['content_img'].length; j++){
                                if(j > 2){
                                    break;
                                }
                                content_img += '<div class="img-box"><img src="'+list[i]['content_img'][j]+'" alt="未上传"></div>';
                            }
                            content_img += '</div>';
                        }
                                

                        //是否喜欢
                        var can_like = '';
                        if(list[i]['seachLike'] == 'inlike'){
                            can_like = '<div class="like-num liked-num"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        } else if(list[i]['seachLike'] == 'mylike'){
                            can_like = '<div class="like-num"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        } else{
                            can_like = '<div class="like-num"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        }

                        var threads_content = '<li id="'+threads_type+'-id-'+list[i]['tid']+'">'+
                            '<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&tid='+list[i]['tid']+'&anchor='+threads_type+'-id-'+list[i]['tid']+'">'+
                                user_message+
                                '<div class="topic-title bulletin-li">'+
                                tab_str+
                                '<p class="bulletin-title">'+list[i]['subject']+'</p>'+
                                '</div>'+
                                '<div class="topic-brief">'+
                                '<div class="post_text_size show_2_line gray-font">'+list[i]['content']+'</div>'+
                                '</div>'+
                                content_img+
                                '<div class="clr"></div>'+
                                '<div class="discuss-box flex-box">'+
                                    '<div class="read-num"><span></span><i>'+list[i]['hits']+'</i></div>'+
                                    '<div class="discuss-num"><span></span><i>'+list[i]['replies']+'</i></div>'+
                                    can_like+
                                '</div>'+
                            '</a>'+
                        '</li>';
                        
                        loadObj.append(threads_content);

                        sessionStorage.setItem('ss_page_'+threads_type, page);
                        var ss_threads_list = '';
                        if(sessionStorage.getItem('ss_'+threads_type+'_list')){
                            ss_threads_list = sessionStorage.getItem('ss_'+threads_type+'_list');
                        }
                        sessionStorage.setItem('ss_'+threads_type+'_list', ss_threads_list+threads_content);
                    }
                }
                setImgSize();

                if(page == page_count){
                    loadObj.append('<div class="uncontent gray-font">已显示全部内容</div>');
                    loadtf = 'loadOut';
                    return loadtf;
                }
            }
        })

        return loadtf;
    }
    setImgSize();
    //设置缩略图盒子大小
    function setImgSize(){
        var bigBox = "";
        if(!$(".hot-topic-box").is(":hidden")){
            bigBox = $(".hot-topic-box .discuss-img-box");
        }else{
            bigBox = $(".all-topic-box .discuss-img-box");
        }
        
        var len = bigBox.length;

        if(len > 0){
            for(var i = 0; i < len;i++){
                var imgBoxs = bigBox.eq(i).children(".img-box");
                var boxWidth = imgBoxs.eq(0).width();
                imgBoxs.css("height",boxWidth);
            }

        }
    }

    /**
     * 添加喜欢
     * @param {[int]} type [喜欢类型]
     * @param {[int]} id   [相关id]
     * @param {[obj]} obj  [html对象]
     */
    function addLike(type, id, $obj){
        $.ajax({
            url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&a=doLike",
            type:'POST',
            data:{
                csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
                typeid:type,
                fromid:id,
            },
            success:function(data){
                console.log(data);
                if(data == 'login'){
                    window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Login";
                } else if(data == 'inlike'){
                    alert('已经点赞过'); 
                } else if(data == 'myself'){
                    alert('这是你自己发的'); 
                } else if(data == 'success'){
                    var liek_count = $($obj).find('i').html();
                    $($obj).find('i').html(liek_count*1+1);
                    $($obj).addClass('liked-num');
                }
                    
            }
        })
    }

    /**
     * 跳转模块
     * @param {[int]} model_id [模块id]
     * @param {[string]} url   [相关id]
     */
    function toModel(model_id, url){
        $.ajax({
            url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&a=setModel",
            type:'POST',
            data:{
                csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
                model_id:model_id
            },
            success:function(data){
                console.log(data);
                window.location.href = url;     
            }
        })
    }

    //发帖
    function toNewPost(){
        var stop_action = '<?php echo htmlspecialchars($stop_action, ENT_QUOTES, 'UTF-8');?>';
        if(stop_action == 1){
            alert('论坛功能正在升级，暂时关闭发帖功能');
        } else{
            window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>";
        }
    }

    // //阻止事件冒泡和默认行为
    // $('body').delegate(".like-num", "click", function(e){
    //     window.event ? window.event.cancelBubble = true : e.stopPropagation();
    //     return false;
    // })
    // $('body').delegate(".discuss-num", "click", function(e){
    //     window.event ? window.event.cancelBubble = true : e.stopPropagation();
    //     return false;
    // })

    /*点击签到*/    
    function signIn() {
        var punch_state = onPunch();
        
        if(punch_state == 'success'){
            $('.follow').addClass('hidden');
            $('.followed').removeClass('hidden');

            //更换第七天的
            if(<?php echo htmlspecialchars($user_punch, ENT_QUOTES, 'UTF-8');?> == 6){
                $(".day<?php echo htmlspecialchars($user_punch+1, ENT_QUOTES, 'UTF-8');?>").css("background-image", "url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/7.png)");
            } else{
                $(".day<?php echo htmlspecialchars($user_punch+1, ENT_QUOTES, 'UTF-8');?>").css("background-image", "url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/<?php echo htmlspecialchars($user_punch+1, ENT_QUOTES, 'UTF-8');?>.png)");
            }
            $(".sign-introduction-wrap").addClass('hidden')
            $(".signed-introduction-wrap").removeClass('hidden')
            $(".sign-btn-wrap").addClass('hidden')
            // $(".sign-btn.sign").css({
            //     'background': 'url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/sign-fin.png)',
            //     'background-size': 'contain',
            //     'background-repeat': 'no-repeat'
            // });
            
        } else{
            alert('出了点问题，请稍后再试');
        }
        event.stopPropagation();//阻止事件冒泡
    }

    /*关闭弹窗*/
    function closeSign() {
        $(".user-sign-box-mask").fadeOut('fast');
        setTimeout(function(){
            location.reload();
        }, 500)
    }



   
    </script>
    <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
    </body>
</html>