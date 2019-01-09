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
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
		<script src='<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js'></script>
		<style>
			body{background-color:#fff;}
			.q_layout .section textarea{text-align:left;width: 100%; padding-top: 10px;font-size: 16px;}
			::-webkit-input-placeholder{font-size: 16px;color:#949494;}
			:-moz-placeholder{font-size: 16px;color:#949494;   }
			::-moz-placeholder{font-size: 16px;color:#949494; }
			:-ms-placeholder{font-size: 16px;color:#949494;  }
			.publish-tab{ padding-top: 2px;    border-top: 1px solid #eee;border-bottom: 1px solid #eee;}
			.publish-btn a{display: inline-block;font-size: 14px;background-color: #1ea4f2;color: #fff;    border-radius: 5px;line-height: 34px;    padding: 0 10px;}
			input{border:none;}
			.topic_title{    width: 100%;text-align: left;line-height: 35px;}
			
			/*编辑器样式*/
			#edui1_toolbarbox{ display: none; }
			#container .edui-default{ border: none; }
			.comment-type{ text-align: left; padding: 5px 0; }
			.comment-type span{ font-size: 16px; color: #949494; vertical-align: middle; }
			.comment-tit{ width: 100%; border-bottom: 1px solid #e0e0e0;}
			.view p { color: #333;}
			.topic_title{    font-size: 18px;color: #949494;}
			/* 编辑器里的弹框 */
			#edui_fixedlayer{ display: none; }
			.comment-text {overflow: auto;-webkit-touch-scrolling:touch;text-align: left;font-size:16px;color:#949494; border:0;outline: 0;box-shadow: none}
			.comment-text div, .comment-text p{text-align: left;font-size:16px;color:#949494; width:100%;display: block;}
			.comment-text img{max-width: 60%}
			.alertTips{width:160px;line-height:30px;height:30px;text-align: center;font-size: 16px;background: rgba(0,0,0,0.4);
				position: absolute;left:50%;margin-left: -80px;top:50%;margin-top: -15px;z-index:999;color:#fff;border-radius:5px;display: none}

			.J_insert_emotions a{ margin-left: 5px; }
			.J_insert_emotions img{ width: 32px; padding: 3px; }

		</style>
    </head>
    <body>

    <script type="text/javascript">
    	var stop_action = "<?php echo htmlspecialchars($stop_action, ENT_QUOTES, 'UTF-8');?>";
    	if(stop_action == 1){
    		$('body').css('pointer-events', 'none');
    		alert("你所属的用户组没有发布权限");
    		$('html').click(function(){
    			alert("你所属的用户组没有发布权限");
    		})
    	} else if(stop_action == 2){
    		$('body').css('pointer-events', 'none');
    		alert("您已被禁言");
    		$('html').click(function(){
    			alert("您已被禁言");
    		})
    	} else if(stop_action == 3){
    		$('body').css('pointer-events', 'none');
    		history.go(-1);
    	}
    </script>
	
    <div class="all_content">

    	<div class="q_layout">
    		<div class="section">
    			<!-- 新建话题 -->
    			<div class="new_topic">
    				<div class="comment-tit comment-type">
    					<span>话题类型：</span>
    					<select name="atc_type">
							<option value='0'>综合讨论</option>
							<option value='1'>问题建议</option>
							<option value='2'>萌新求助</option>
							<option value='3'>大神攻略</option>
    					</select>
    				</div>
    				<div class="comment-tit">
    					<input class="topic_title" type="text" name="atc_title" placeholder="文章标题（有趣的标题会有更多人关注喔）" value="">
    				</div>
					<div class="comment-text" id="comment-text" contenteditable="plaintext-only"><p>说点什么吧!(内容至少6个汉字）</p><p>小提示：</p><p>攻略心得分享与游戏内事迹分享会更受欢迎！</p></div>
	    			<div class="publish-tab">
	    				<div class="publish-img"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/pic.png" alt=""></div>
	    				<div class="J_insert_emotions"><a href="" tabindex="-1" rel="nofollow" class="J_insert_emotions" data-emotiontarget="#comment-text"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/emoji_bt.png" alt=""></a></div>
	    				<div class="publish-btn">
	    					<a href="javascript:;" onclick="ajaxForum()">发布话题</a>
	    				</div>
	    			</div>
	    			<!-- 加载图片上传 -->
	    			<div class="webuploader-text">
	    				
				    </div>
    			</div>
    		</div>
    	</div>
    </div>
	<div class="alertTips">图片上传中</div>

    <script type="text/javascript" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/webuploader/webuploader.js"></script>
	<script>
		Wind.use('jquery', 'globalweb', 'dialog', function(){
			// 阅读页的常用交互
			Wind.js(GV.JS_ROOT +'pages/bbs/readweb.js?v='+ GV.JS_VERSION);
		});

		var verifiedWord = '';
		$(function(){
			// 输入文本框要是屏幕高度的一半
				var screenH = window.screen.height;
				if ($("new_topic").hasClass('hidden')) {
					commentTextH = screenH/3
				}else{
					commentTextH = screenH/3-$(".topic_title").height()
				}
				$(".comment-text").height(commentTextH)
		});
		var commentText = $(".comment-text");
		commentText.on("focus",function(){
			setTextNode()
			if($.trim(commentText.find("p").eq(0).text()) == "说点什么吧!(内容至少6个汉字）" && $.trim(commentText.find("p").eq(1).text()) == "小提示：" && $.trim(commentText.find("p").eq(2).text()) == "攻略心得分享与游戏内事迹分享会更受欢迎！" &&  commentText.find("img").length == 0){
				commentText.html("")
			}
		})
		commentText.on("blur",function(){
			setTextNode()
			if($.trim(commentText.text()).indexOf("说点什么吧!(内容至少6个汉字）小提示：攻略心得分享与游戏内事迹分享会更受欢迎！") < 0 && $.trim(commentText.text()).length == 0 && commentText.find("img").length == 0){
				commentText.html("<p>说点什么吧!(内容至少6个汉字）</p><p>小提示：</p><p>攻略心得分享与游戏内事迹分享会更受欢迎！</p>")
			}
		})

		var imgloading = false;
		var uploader = WebUploader.create({
		    swf: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/webuploader/Uploader.swf',
		    chunked: false,		// 开起分片上传
		    pick: '.webuploader-text',		//指定选择文件的按钮容器
    		server: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/utf8-php/php/action_upload.php',		// 文件接收服务端。
		    accept : {		//指定接受哪些类型的文件
				    title: 'Images',
				    extensions: 'jpg,jpeg,bmp,png',
				    mimeTypes: 'image/*'
				},
			formData: {  
		        csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
		        action:'webuploader',
		        file_name:'file',
		    },
			auto : true,		//自动开始上传
		});

		// 当有文件添加进来的时候
		uploader.on( 'fileQueued', function( file ) {
			$('.alertTips').show();
			imgloading = true;
		});

		//上传成功
		uploader.on('uploadSuccess', function( file,response ) {
			$('.alertTips').hide();
			var data = eval('('+response._raw+')');
			if(data.state == 'SUCCESS'){
				alert('上传成功');
				//data.url是返回的图片路径
				var commentP = $(".comment-text");
				var commentTips = commentP.text();

				if(commentTips == "说点什么吧!(内容至少6个汉字）小提示：攻略心得分享与游戏内事迹分享会更受欢迎！"){
					$(".comment-text").html("<p><img src='" + data.url +"' /><p>")
				}else{
					commentP.last().append("<p><img src='" + data.url +"' /> </p>")
				} 
			} else if(data.state == '文件类型不允许'){
				alert('请上传png、jpg、jpeg、bmp格式的图片');
			} else{
				alert('图片上传失败，请上传小于4M的图片');
			}
			imgloading = false;
        });

        //上传失败
		uploader.on('uploadError', function( file,response ) {
			$('.alertTips').hide();
			imgloading = false;
			alert('图片上传失败');
        });

		$(".publish-img").click(function(event) {
			/* 点击ueditor图片上传按钮，选取图片 */
			//$('#edui3_body').find('iframe').eq(0).contents().find('input[type="file"]').click();
			$(".webuploader-text").find('input[type="file"]').click();
		});


		//提交话题内容
		function ajaxForum(){
			if(imgloading){
				return;
			}
			var atc_type = $('select[name="atc_type"]').val();
			var atc_title = $('input[name="atc_title"]').val();
			var atc_content = commentText.html();

			if($.trim(atc_title) == ''){
				alert("请输入标题");
				return;
			} else if(($.trim(commentText.find("p").eq(0).text()) == "说点什么吧!(内容至少6个汉字）" && $.trim(commentText.find("p").eq(1).text()) == "小提示：" && $.trim(commentText.find("p").eq(2).text()) == "攻略心得分享与游戏内事迹分享会更受欢迎！") || $.trim(commentText.text()).length < 6){
				alert("至少输入6个字");
				return;
			}

			$.ajax({
				url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&a=doadd"+verifiedWord,
				type:'post',
				async: false,
				data:{
					fid:"<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>",
					csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
					activity_prefix:"<?php echo htmlspecialchars($activity_prefix, ENT_QUOTES, 'UTF-8');?>",
					atc_type:atc_type,
					atc_title:atc_title,
					atc_content:atc_content,
				},
				success:function(data){
					console.log(data);
					try{
						data = eval('('+data+')');
						if(data['state'] == 'success'){
							window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>"+data['url']+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>";
						} else if(data['state'] == 'word'){
							alert('标题或者话题中含有敏感词：'+data['msg']);
						} else if(data['state'] == 'sword'){
							alert(data['msg']);
						} else if(data['state'] == 'raload'){
							if(confirm('发布内容含敏感词：'+data['msg']+'，需审核后才会显示，确认发布吗？')){
								verifiedWord = '&verifiedWord=1';
							 　 ajaxForum();
							}
							
						}
					} catch(e){
						alert('发帖失败');
					}
				}
			})
		}
	</script>

    </body>
</html>