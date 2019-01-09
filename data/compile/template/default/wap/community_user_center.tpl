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
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/introjs.css">
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/introjs-rtl.css">
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/base.css"/>
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css">
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community_user_center.css">
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/intro.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
		<style>
			.rec_tip .user-head-box.showGuide{    padding: 10px 24px 10px 14px;}
		</style>
    </head>
    <body>
    <div class="all_content">

    	<div class="q_layout">
    		<div class="section">
    			<div class="user-head-box showGuide" data-step="1" data-intro="点击修改头像和昵称<br />让小伙伴更容易记住你吧~

">
	                <div class="head-pic"><img src="<?php echo htmlspecialchars(Pw::getAvatar($space->spaceUid,'big'), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time, ENT_QUOTES, 'UTF-8');?>" alt=""></div>
	                <div class="user-des">
                        <p class="name" style="font-size: 15px;margin-right: 2px;"><?php echo htmlspecialchars($space->spaceUser['username'], ENT_QUOTES, 'UTF-8');?></p> <p class="name user-id">（ID：<?php echo htmlspecialchars($space->spaceUser['ident_id'], ENT_QUOTES, 'UTF-8');?>）</p> 
                        <p class="lever-icon"><span class="level level1"></span></p>
	                </div>
	                <div class="change_btn">
	                	<img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/change.png" alt="">
	                </div>
	            </div>
    		</div>
    		<div class="section section1">
    			<ul>
	    			<li class="user-msg">
	    				<span class="user-msg-img-wrap"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/mes.png" alt=""></span>
						<span class="msg_text">个人消息</span>
						<i class="fr orange"><?php echo htmlspecialchars($unreadCount, ENT_QUOTES, 'UTF-8');?></i>
	    			</li>
	    			<li class="acc-point">
	    				<span class="acc-point-img-wrap"><img style="width: 32px;height:32px" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/jifen.png" alt=""></span>
						<span class="msg_text">个人积分</span>
						<i class="fr qxblue"><?php echo htmlspecialchars($plat_credit, ENT_QUOTES, 'UTF-8');?></i>
	    			</li>
	    		</ul>
    			<!-- <div class="user-msg">
    				<span class="user-msg-img-wrap"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/mes.png" alt=""></span>
					<span class="msg_text">个人消息</span>
					<i class="fr orange"><?php echo htmlspecialchars($unreadCount, ENT_QUOTES, 'UTF-8');?></i>
    			</div> -->
    		</div>
    		<div class="section">
    			<ul>
    				<li class="ranking-list">
    					<span class="user-msg-img-wrap"><img style="width: 32px;height:32px" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/bangdan.png" alt=""></span>
						<span class="msg_text">社区榜单</span>
						<i class="fr qxblue"></i>
    				</li>
    			</ul>
    		</div>
    		<div class="section">
    			<ul class="record">
    				<li><span><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/jilu.png" alt=""></span><span class="msg_text">个人动态</span></li>
    				<li><span class="msg_text">发帖纪录</span><i class="fr"><?php echo htmlspecialchars($space->spaceUser['thread_count'], ENT_QUOTES, 'UTF-8');?></i></li>
    				<li><span class="msg_text">评论纪录</span><i class="fr"><?php echo htmlspecialchars($space->spaceUser['post_count'], ENT_QUOTES, 'UTF-8');?></i></li>
    				<li><span class="msg_text">礼包领取纪录</span><i class="fr"></i></li>
    			</ul>
    		</div>
    		<!-- <div class="section section1">
    			<div class="user-msg t-center" onclick="logout()">
    							退出登录
    			</div>
    		</div> -->
    		<!-- 个人设置先屏蔽 -->
    		<!-- <div class="section">
    			<ul class="switch-list">
    				<li><span class="user-msg-img-wrap"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/setting.png" alt=""></span><span class="msg_text">个人设置</span></li>
    				<li><span class="msg_text">显示VIP等级</span><span class="m-switch lg active" title=""><input type="checkbox" class="m-switch-input" value="on">	<span class="m-switch-helper"></span></span></li>
    				<li><span class="msg_text">公开发帖纪录</span><span class="m-switch lg active" title=""><input type="checkbox" class="m-switch-input" value="on">	<span class="m-switch-helper"></span></span></li>
    				<li><span class="msg_text">公开评论纪录</span><span class="m-switch lg active" title=""><input type="checkbox" class="m-switch-input" value="on">	<span class="m-switch-helper"></span></span></li>
    				<li><span class="msg_text red">公开个人信息</span><span class="m-switch lg" title=""><input type="checkbox" class="m-switch-input" value="on">	<span class="m-switch-helper"></span></span></li>
    				<li><span class="user-msg-img-wrap"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/friends.png" alt=""></span><span class="msg_text red">个人交互</span></li>
    				<li><span class="msg_text red">我的关注</span></li>
    				<li><span class="msg_text red">我的粉丝</span></li>
    				<li><span class="msg_text red">我的好友</span></li>
    			</ul>
    		</div> -->
    	</div>
    </div>
    <div class="bottom-nav logout-nav">
    	<div class="back-icon" style="position: absolute;left:5px;"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"></a></div>
    	<div class="publish"><a class="logout" href="javascript:;">退出登录</a></div>
    </div>
	<script>

		$(".logout-nav a.logout").click(function(event) {
		if ($("a.logout").hasClass('if_logout')) {
			/*真的退出登录*/
			logout()
		}else{
			$("a.logout").addClass('if_logout').html('<span style="float: left;      font-size: 14px;  margin-left: 10px;">确定</span>').prepend('<img style="display:inline-block;    background-color: #fff;border-radius: 30px; margin-top: 5px;float: left;margin-left: 35%;    width: 24px;" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/right.png" alt="">')
			// $("a.logout").addClass('if_logout').html('<img style="display:inline-block;  margin-left: 10px;   background-color: #fff;border-radius: 30px; margin-top: 2px;float: left;   width: 30px;" src="http://192.168.7.182/right.png" alt="">').prepend('<span style="float: left;   margin-left: 35%; ">确定</span>')
			// $(".publish").prepend('<img style="display:inline-block;" src="http://192.168.7.182/right.png" alt="">')
		}
	});


		$(function(){
			/*执行新手引导*/
        	if("<?php echo htmlspecialchars($frist_in, ENT_QUOTES, 'UTF-8');?>" == ''){
			    newComerGuide($(".showGuide"));
			}
			// newComerGuide($(".showGuide"));
			
			setTimeout(function(){
				// 输入文本框要是屏幕高度的一半
				var screenH = window.screen.height;
				var commentTextH = screenH/2-$(".comment-top").height()
				// console.log(commentTextH)
				$(".comment-text").height(commentTextH);
				/*头像高度根据宽度自适应*/
				$(".head-pic").height($(".head-pic").width())
			},50);
		});


		/*通过开关控制是否公开*/
		// $(".switch").parent('li').click(function(event) {
		// 	var imgSrc = $(this).children('.switch').children('img')[0].src;
		// 	var imgSrcLength = imgSrc.length;
		// 	var src = imgSrc.substring(imgSrcLength-8,imgSrcLength-4)
		// 	if (src=="open") {
		// 		// 将开着的开关关闭
		// 		var newSrc1 = imgSrc.substr(0,imgSrcLength-8)
		// 		var newSrc = newSrc1+"close.png"
		// 		$(this).children('.switch').children('img').attr('src', newSrc);
		// 	}else{
		// 		/*将关着的开关打开*/
		// 		var newSrc1 = imgSrc.substr(0,imgSrcLength-9)
		// 		var newSrc = newSrc1+"open.png"
		// 		$(this).children('.switch').children('img').attr('src', newSrc);
		// 	}
		// });
		
		/*通过开关控制是否公开*/
		$(".switch-list li").each(function(index, el) {
			$(this).click(function(event) {
				if ($(this).children('.m-switch.lg').hasClass('active')) {
					$(this).children('.m-switch.lg').removeClass('active')
				}else{
					$(this).children('.m-switch.lg').addClass('active')				
				}
			});
		});

		/*点击编辑用户信息*/
		$(".user-head-box").click(function(event) {
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserEdit&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});

		/*进入发帖纪录*/
		$(".record li:gt(0)").click(function(event) {
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=MyArticle&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});

		/*进入回复纪录*/
		$(".record li:gt(1)").click(function(event) {
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=MyArticle&a=reply&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});

		/*进入礼包领取纪录*/
		$(".record li:gt(2)").click(function(event) {
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Record&load_type=gift"
		});

		/*进入用户消息中心*/
		$(".user-msg").click(function(event) {
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=MyNotice&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});

		/*进入个人积分*/
		$(".acc-point").click(function(event) {
			window.location.href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserTask&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});

		/*进入榜单*/
		$(".ranking-list").click(function(event) {
			window.location.href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Billboard&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"
		});
		function logout(){
			window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Login&a=logout";
		}
	</script>

    </body>
</html>