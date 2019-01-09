<!DOCTYPE html>
<html lang="en">
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
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/base.css"/>
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css">
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community_user_center.css">
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>

    </head>
    <style type="text/css">
	.blur_li *{
		color:#1ea4f2 !important;
	}
    </style>
    <body>
    <div class="bottom-nav">
            <div class="publish"><a href="javascript: history.go(-1);">返回上一页</a></div>
    </div>

	 <div class="all_content">

    	<div class="q_layout">
		<div class="section">
			<div class="user-head-box">
                <div class="head-pic" style="height: 50px;"><img src="<?php echo htmlspecialchars(Pw::getAvatar($loginUser->uid,'big'), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time, ENT_QUOTES, 'UTF-8');?>" alt="" style="width: 100%;"></div>
                <div class="user-des">
                    <p class="name" style="font-size: 15px;margin-right: 2px;"><?php echo htmlspecialchars($loginUser->username, ENT_QUOTES, 'UTF-8');?></p> <p class="name user-id">（ID：<?php echo htmlspecialchars($loginUser->info['ident_id'], ENT_QUOTES, 'UTF-8');?>）</p> 
                    <div class="blur_li"><p class="lever-icon">我的积分：<?php echo htmlspecialchars($plat_credit, ENT_QUOTES, 'UTF-8');?></p></div>
                </div>
                <div class="change_btn">
                	<!-- <img src="http://bbs.test.q-dazzle.com/themes/site/wap/images/community/change.png" alt=""> -->
                </div>
            </div>
		</div>
		<div class="section task-section">
			<ul>
    			<li class="title">
    				<span class="user-msg-img-wrap"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/task.png" alt=""></span>
					<span class="msg_text">每日任务</span>
					<i class="fr orange"></i>
    			</li>
    			<?php  if($config['punch.open'] == 1){
  if($punch['time'] < strtotime(date('y-m-d', time()))){?>
					<li>
	    				<span class="user-msg-img-wrap"></span>
						<span class="msg_text">每日签到（<?php echo htmlspecialchars($config['punch.reward']['min'], ENT_QUOTES, 'UTF-8');
 echo htmlspecialchars($config['punch.reward']['type_name'], ENT_QUOTES, 'UTF-8');?>）</span>
						<i class="fr un-finish-color">（0/1）</i>
	    			</li>	
					<?php  } else{ ?>
					<li class="blur_li">
	    				<span class="user-msg-img-wrap"></span>
						<span class="msg_text">每日签到（<?php echo htmlspecialchars($config['punch.reward']['min'], ENT_QUOTES, 'UTF-8');
 echo htmlspecialchars($config['punch.reward']['type_name'], ENT_QUOTES, 'UTF-8');?>）</span>
						<i class="fr un-finish-color">（1/1）</i>
	    			</li>
					<?php  } 
  } 
  foreach($list as $key=>$value){ 
    				if($value['period'] > 0){ 
  if($value['tag'] != 6){?>
						<li>
		    				<span class="user-msg-img-wrap"></span>
							<span class="msg_text"><?php echo htmlspecialchars($value['title'], ENT_QUOTES, 'UTF-8');?>（<?php echo htmlspecialchars($value['reward']['descript'], ENT_QUOTES, 'UTF-8');?>）</span>
							<i class="fr un-finish-color">（<?php echo htmlspecialchars($value['ed_num'], ENT_QUOTES, 'UTF-8');?>/<?php echo htmlspecialchars($value['end_num'], ENT_QUOTES, 'UTF-8');?>）</i>
		    			</li>	
    					<?php  } else{ ?>
						<li class="blur_li">
		    				<span class="user-msg-img-wrap"></span>
							<span class="msg_text"><?php echo htmlspecialchars($value['title'], ENT_QUOTES, 'UTF-8');?>（<?php echo htmlspecialchars($value['reward']['descript'], ENT_QUOTES, 'UTF-8');?>）</span>
							<i class="fr un-finish-color">（<?php echo htmlspecialchars($value['ed_num'], ENT_QUOTES, 'UTF-8');?>/<?php echo htmlspecialchars($value['end_num'], ENT_QUOTES, 'UTF-8');?>）</i>
		    			</li>
    					<?php  } 
  }
    			} ?>
    		</ul>
		</div>
		<div class="section">
			<ul>
				<li class="title">
					<span><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/task_new.png" alt=""></span>
					<span class="msg_text">新手任务</span>
				</li>
				<?php  foreach($list as $key=>$value){ 
					if($value['period'] == 0){ 
  if($value['tag'] != 6){?>
						<li>
		    				<span class="user-msg-img-wrap"></span>
							<span class="msg_text"><?php echo htmlspecialchars($value['title'], ENT_QUOTES, 'UTF-8');?>（<?php echo htmlspecialchars($value['reward']['descript'], ENT_QUOTES, 'UTF-8');?>）</span>
							<i class="fr un-finish-color">未完成</i>
		    			</li>	
    					<?php  } else{ ?>
						<li class="blur_li">
		    				<span class="user-msg-img-wrap"></span>
							<span class="msg_text"><?php echo htmlspecialchars($value['title'], ENT_QUOTES, 'UTF-8');?>（<?php echo htmlspecialchars($value['reward']['descript'], ENT_QUOTES, 'UTF-8');?>）</span>
							<i class="fr un-finish-color">已完成</i>
		    			</li>
    					<?php  } 
  }
    			} ?>
			</ul>
		</div>
		<div class="section">
			<ul>
				<li class="title" onclick="location.href='index.php?m=wap&c=Record'">
					<span><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/jifen_huoqu.png" alt=""></span>
					<span class="msg_text">积分获取记录</span>
				</li>
			</ul>
		</div>


    	</div>
    </div>

    <div style="height: 44px;"></div>

    </body>
</html>