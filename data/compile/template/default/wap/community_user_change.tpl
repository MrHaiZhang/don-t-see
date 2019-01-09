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

		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.1.8.3.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/simple.switch.min.js"></script>
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/simple.switch.three.css">
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
		<style>
		body{background-color: #fff;}
		.head-pic{float:right;}
		.user_change_ul li{border-bottom: 1px solid #e5e5e5;text-align:left;box-sizing: content-box;}
		.user_change_ul li.change_head_pic{height: 50px;padding:10px 0;  line-height: 50px;}
		.user_change_ul li div{display:inline-block; line-height: 40px;font-size: 14px; }
		.preserve-box{position:absolute;bottom: 0;width: 100%;    height: 44px;padding: 0 10px; z-index: 99;}
		.preserve{display: inline-block;background-color: #1ea4f2;width: 70%;border-radius: 5px;line-height: 36px;color:#fff;font-size: 14px;margin-top: 5px;}

		/* 上传图片样式 */
		#J_avatgar_normal_form dd{ width: 200px; margin: auto; }
		#J_avatgar_normal_form .mb10{ text-align: left; }
		#J_avatgar_normal_form .mb20{ text-align: left; }
		.J_previewImg{height:100%;}
		</style>
    </head>
    <body>
	<div class="preserve-box bottom-nav">
		<div class="back-icon" style="position: absolute;left:5px;"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserCenter&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>"></a></div>
		<a class="preserve" href="javaScript:;" onclick="checkInput()">保存资料</a>
	</div>
    <div class="all_content">
    	<div class="q_layout">
    		<div class="section">
    			<ul class="user_change_ul">
	    			<li class="change_head_pic">
	    				<div>用户头像</div>
	    				<div class="head-pic">
	    					<!-- 上传图片 -->
	    					<div class="avatar_other" style="display: none;">
								<form id="J_avatgar_normal_form" action="<?php echo htmlspecialchars($avatarArr['postUrl'], ENT_QUOTES, 'UTF-8');?>&_json=1" method="post" enctype="multipart/form-data" >
								<dl class="cc">
									<dt>
										<img class="J_avatar J_previewImg" src="<?php echo htmlspecialchars(Pw::getAvatar($loginUser->uid, 'big'), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>" data-type="big" width="200" height="200" />
									</dt>
									<dd>
										<div class="mb10"><input type="file" name="avatar" class="J_upload_preview"></div>
										<div class="gray mb20">支持JPG、JPEG、PNG文件格式</div>
										<button type="button" class="btn btn_submit btn_big mr20" id="J_avatgar_normal_btn" onclick="ajaxUpload()">保存</button>
									</dd>
								</dl>
								<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
							</div>
							<img class="J_avatar J_previewImg" src="<?php echo htmlspecialchars(Pw::getAvatar($loginUser->uid, 'big'), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>" data-type="big"/>
	    				</div>
	    			</li>
	    			<li>
	    				<div>用户名</div>
	    				<div class="fr"><?php echo htmlspecialchars($userinfo['username'], ENT_QUOTES, 'UTF-8');?></div>
	    			</li>
	    			<li>
	    				<div>用户昵称</div>
	    				<div class="fr">
	    					<input type="text" name="nickname" value="<?php echo htmlspecialchars($userinfo['nickname'], ENT_QUOTES, 'UTF-8');?>" placeholder="中英文、数字以及下划线" style="border: none; text-align: right;color: #999;    font-size: 14px;">
	    				</div>
	    			</li>
	    			<li>
	    				<div>性别</div>
	    				<div class="fr">
	
							<div class="gender fr">
								<!-- 选取性别的开关 -->
								<input name="test" type="checkbox" <?php  if($userinfo['gender'] == 0){ ?>checked="check"<?php  } ?> class="checkbox">
							</div>
	    				</div>
	    			</li>
	    			<li>
	    				<div>联系方式</div>
						<div class="fr">
							<input type="text" name="mobile" value="<?php echo htmlspecialchars($userinfo['mobile'], ENT_QUOTES, 'UTF-8');?>" style="border: none; text-align: right;color:#999;    font-size: 14px;">
						</div>
	    			</li>
	    		</ul>

    		</div>
    	</div>

    </div>

	<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
	<script>
	/*选取性别前端样式*/
	$(function() {
		$(".checkbox").simpleSwitch({
			"theme": "FlatCircular"
		});
	});

/*昵称和联系方式点击编辑时全选*/
// $('input[name="nickname"],input[name="mobile"]').focus(function(event) {
// 	$(this).select();
// });

$("input:text").click(function(){
    $(this).select();
});



	//头像上传
	Wind.ready(document, function(){
		//Wind.use('jquery');
		Wind.use('jquery', 'global');		
		Wind.js(GV.JS_ROOT + 'pages/profile/profileAvatarNormal.js?v=' + GV.JS_VERSION)
	});

	$('.head-pic').click(function(){
		// alert('个人资料正在升级，请稍后再试');
		// return;
		$('input[name="avatar"]').click();
	})

	$('input[name="avatar"]').change(function(){
		if($(this).val() != ''){
			ajaxUpload();
		}
	});

	function ajaxUpload(){ 
		// alert('个人资料正在升级，请稍后再试');
		// return;

		var url = $('#J_avatgar_normal_form').attr('action');
		var formData = new FormData($('#J_avatgar_normal_form')[0]);
        $.ajax({
            url:url,
            type:"post",
            data:formData,
            processData:false,
            contentType:false,
            success:function(data){
                if(data == 1){
                	var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserEdit&a=hascheck";
			        $.ajax({
			            url:url,
			            type:"post",
			            async:false,
			            success:function(data){
			                console.log(data);
			            }
			        });

                	alert('上传成功，请等待头像通过审核');
                	//window.location.reload();
                }
            },
            error:function(e){
            	console.log(e);
            	alert('上传失败');
            	//window.location.reload();
            }
        });
	}

function checkInput() {
		// alert('个人资料正在升级，请稍后再试');
		// return;

		var nickname = $('input[name="nickname"]').val();
		var mobile = $('input[name="mobile"]').val();
		var reg = /^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
		// var phoneReg = /(^(\d{3,4}-)?\d{7,8})$|(13[0-9]{9})/;
		 var phoneReg = /^1[34578]\d{9}$/;
		if(nickname.length > 6){
			alert('昵称太长啦~请输入昵称少于六个字符');
			return;
		}else if (nickname.length!=0){
			if(!reg.test(nickname)){
				alert('昵称只能是中英文、数字以及下划线,且不能以下划线开头和结尾')
				return;
			}else if(mobile.length!=0) {
				if(!phoneReg.test(mobile)){
					alert('请填写正确的手机号或电话号码')
					return;
				}
			}
		}else if(mobile.length!=0) {
			if(!phoneReg.test(mobile)){
				alert('请填写正确的手机号或电话号码')
				return;
			}
		}
		postData();
	}


	function postData(){
		// alert('个人资料正在升级，请稍后再试');
		// return;
		
		if ($("#Switch0").hasClass('On')) {//用户选择男
				var gender = 0;
			}else{//用户选择女
				var gender = 1;
			}
		// var gender = $('select[name="gender"]').val();
		
		var nickname = $('input[name="nickname"]').val();
		var mobile = $('input[name="mobile"]').val();
		if(nickname.length > 10){
			alert('昵称最多只能是十个字符');
			return;
		}

		var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserEdit&a=dorun";
        $.ajax({
            url:url,
            type:"post",
            data:{
            	nickname:nickname,
            	gender:gender,
            	mobile:mobile,
            },
            success:function(data){
                console.log(data);
                try{
					data = eval('('+data+')');
					if(data['state'] == 'success'){
						alert('用户资料更新成功');
						setTimeout(function(){
							window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=UserCenter&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>";
						}, 1500);
					} else if(data['state'] == 'word'){
						alert('非法的手机号码');
					} else if(data['state'] == 'nn_out'){
						alert('昵称需要在二至八个字符之间');
					} else if(data['state'] == 'nn_fail'){
						alert('昵称只能是中英文、数字以及下划线,并不能以下划线开头和结尾');
					}
				} catch(e){
					alert('更新失败');
				}
            }
        });
	}
	</script>
    </body>
</html>