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
			.q_layout .section textarea{text-align:left;width: 100%; padding-top: 10px;font-size: 16px;color: #949494;}
			::-webkit-input-placeholder{font-size: 16px;color:#949494;}
			:-moz-placeholder{font-size: 16px;color:#949494;   }
			::-moz-placeholder{font-size: 16px;color:#949494; }
			:-ms-placeholder{font-size: 16px;color:#949494;  }
			.publish-tab{padding-top: 2px;    border-top: 1px solid #eee;border-bottom: 1px solid #eee;}
			.publish-btn a{display: inline-block;font-size: 14px;background-color: #1ea4f2;color: #fff;    border-radius: 5px;line-height: 34px;    padding: 0 10px;}
			input{border:none;}
			.topic_title{    width: 100%;text-align: left;line-height: 35px;}
			.alertTips{width:160px;line-height:30px;height:30px;text-align: center;font-size: 16px;background: rgba(0,0,0,0.4);
				position: absolute;left:50%;margin-left: -80px;top:50%;margin-top: -15px;z-index:999;color:#fff;border-radius:5px;display: none}

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
				<!-- 新建评论 -->
    			<div class="new_comment">
    				<!-- <textarea class="comment-text" id="comment-text" name="post_content" id="" cols="30" rows="10" placeholder="请输入评论内容（至少2个汉字）"></textarea> -->
    				<div class="comment-text" id="comment-text" contenteditable="plaintext-only"><p>请输入评论内容（至少2个汉字）</p></div>
	    			<div class="publish-tab">
	    				<div class="publish-img"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/pic.png" alt=""></div>
	    				<div class="J_insert_emotions"><a href="" tabindex="-1" rel="nofollow" class="J_insert_emotions" data-emotiontarget="#comment-text"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/emoji_bt.png" alt=""></a></div>
	    				<div class="publish-btn">
	    					<a href="javascript:;" onclick="ajaxPost()">发布评论</a>
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
	<!-- <link rel="stylesheet" type="text/css" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/webuploader/webuploader.css"> -->
	
    <script type="text/javascript" src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/webuploader/webuploader.js"></script>
	<script>
		Wind.use('jquery', 'globalweb', 'dialog', function(){
			// 阅读页的常用交互
			Wind.js(GV.JS_ROOT +'pages/bbs/readweb.js?v='+ GV.JS_VERSION);
		});

		var verifiedWord = '';
		var data_url = '';		//图片路径
		var imgloading = false;
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
			if($.trim(commentText.find("p").eq(0).text()) == "请输入评论内容（至少2个汉字）" &&  commentText.find("input").length == 0 &&  commentText.find("hr").length == 0){
				commentText.html("")
			}
		})
		commentText.on("blur",function(){
			setTextNode()
			if($.trim(commentText.text()).indexOf("请输入评论内容（至少2个汉字）") < 0 && $.trim(commentText.text()).length == 0 && commentText.find("img").length == 0 &&  commentText.find("hr").length == 0){
				commentText.html("<p>请输入评论内容（至少2个汉字）</p>")
			}
		})


		//文本域滚动时禁止页面滚动
		$(".comment-text").on("touchstart",function(e){
			e.stopPropagation();
			$("body").on("touchstart",function(e){
				e.preventDefault()
			})
		})
		$(".comment-text").on("touchcancel touchend",function(e){
			$("body").unbind("touchstart")
		})

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
			imgloading = true;
			$('.alertTips').show();
		    var $li = $(
		            '<div id="' + file.id + '" class="file-item thumbnail">' +
		                '<img>' +
		                '<div class="info">' + file.name + '</div>' +
		            '</div>'
		            ),
		        $img = $li.find('img');

		    //去掉之前的图片,只上传一张
		    var file_list = uploader.getFiles();
		    for(var i = 0; i < file_list.length; i++){
		    	if(i+1 == file_list.length){
		    		break;
		    	}
		    	uploader.removeFile(file_list[i]);
		    }
		    $('.file-item').each(function(){
		    	$(this).remove();
		    })

		    // $list为容器jQuery实例
		    $(".webuploader-text").append( $li );


		    // 创建缩略图
		    // 如果为非图片文件，可以不用调用此方法。
		    // thumbnailWidth x thumbnailHeight 为 100 x 100
		    var thumbnailWidth = 200;
		    var thumbnailHeight = 200;
		    uploader.makeThumb( file, function( error, src ) {
		        if ( error ) {
		            $img.replaceWith('<span>不能预览</span>');
		            return;
		        }

		        $img.attr( 'src', src );
		    }, thumbnailWidth, thumbnailHeight );
		});

        //上传成功
		uploader.on('uploadSuccess', function( file,response ) {
			$('.alertTips').hide();
			var data = eval('('+response._raw+')');
			//console.log(data);
			if(data.state == 'SUCCESS'){
				alert('上传成功');
				data_url = data.url;
			} else if(data.state == '文件类型不允许'){
				alert('请上传png、jpg、jpeg、bmp格式的图片');
			} else{
				alert('图片上传失败，请上传小于4M的图片');
				//去掉之前的图片
			    var file_list = uploader.getFiles();
			    for(var i = 0; i < file_list.length; i++){
			    	if(i+1 == file_list.length){
			    		break;
			    	}
			    	uploader.removeFile(file_list[i]);
			    }
			    $('.file-item').each(function(){
			    	$(this).remove();
			    })
			}
			imgloading = false;
        });

        //上传失败
		uploader.on('uploadError', function( file,response ) {
			$('.alertTips').hide();
			imgloading = false;
			alert('图片上传失败');
			//ajaxPost('');
        });

		/* 点击ueditor图片上传按钮，选取图片 */
		$(".publish-img").click(function(event) {
			$(".webuploader-text").find('input[type="file"]').click();
		});

		//上传图片
		function ajaxImg(){
			var file_list = uploader.getFiles('inited');
			if(file_list != ''){
				$('.alertTips').show();
				uploader.upload();
			} else{
				ajaxPost('');
			}
			
		}

		//提交评论
		function ajaxPost(){
			if(imgloading){
				return;
			}

			// var post_content = $('textarea[name="post_content"]').val();
			
			// if(post_content.length < 2){
			// 	alert("至少输入2个字");
			// 	return;
			// }

			var post_content = commentText.html();

			if($.trim(commentText.find("p").eq(0).text()) == '请输入评论内容（至少2个汉字）' || $.trim(commentText.text()).length < 2){
				alert("至少输入2个字");
				return;
			}

			$.ajax({
				url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&a=doreply"+verifiedWord,
				type:'post',
				async: false,
				data:{
					tid:"<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>",
					csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
					post_content:post_content,
					post_content_img:data_url,
				},
				success:function(data){
					//console.log(data);
					try{
						data = eval('('+data+')');
						if(data['state'] == 'success'){
							window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>"+data['url']+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"+"&post_anchor=<?php echo htmlspecialchars($post_anchor, ENT_QUOTES, 'UTF-8');?>";
						} else if(data['state'] == 'word'){
							alert('您提交的内容中含有敏感词：'+data['msg']);
						} else if(data['state'] == 'word_length'){
							alert('至少输入2个字');
						} else if(data['state'] == 'sword'){
							alert('不能重复发送相同的内容');
						} else if(data['state'] == 'raload'){
							if(confirm('发布内容含敏感词：'+data['msg']+'，需审核后才会显示，确认发布吗？')){
								verifiedWord = '&verifiedWord=1';
								ajaxPost();
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