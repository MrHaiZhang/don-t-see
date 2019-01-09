<!doctype html>
<html>
<head>
<meta charset="<?php echo htmlspecialchars(Wekit::V('charset'), ENT_QUOTES, 'UTF-8');?>">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','c','name'), ENT_QUOTES, 'UTF-8');?></title>
<link href="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','css'), ENT_QUOTES, 'UTF-8');?>/admin_style.css?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" rel="stylesheet" />
<script>
//全局变量，是Global Variables不是Gay Video喔
var GV = {
	JS_ROOT : "<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','res'), ENT_QUOTES, 'UTF-8');?>/js/dev/",																									//js目录
	JS_VERSION : "<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>",																										//js版本号
	TOKEN : '<?php echo htmlspecialchars(Wind::getComponent('windToken')->saveToken('csrf_token'), ENT_QUOTES, 'UTF-8');?>',	//token ajax全局
	REGION_CONFIG : {},
	SCHOOL_CONFIG : {},
	URL : {
		LOGIN : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','loginUrl'), ENT_QUOTES, 'UTF-8');?>',																													//后台登录地址
		IMAGE_RES: '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>',																										//图片目录
		REGION : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=area'; ?>',					//地区
		SCHOOL : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=school'; ?>'				//学校
	}
};
</script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/wind.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/jquery.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>

</head>
<body class="body_none" style="width:380px;">
<form class="J_ajaxForm"  action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=client&a=doedit'; ?>" method="post">
	<div class="pop_cont">
		<div class="pop_table" style="height:auto;">
			<table width="100%">
				<tr>
					<th>客户端名称</th>
					<td><span class="must_red">*</span><input type="text" class="input length_4 mr5" name="appname" value="<?php echo htmlspecialchars($app['name'], ENT_QUOTES, 'UTF-8');?>"></td>
				</tr>
				<tr>
					<th>客户端地址</th>
					<td><span class="must_red">*</span><input type="text" class="input length_4 mr5" name="appurl" value="<?php echo htmlspecialchars($app['siteurl'], ENT_QUOTES, 'UTF-8');?>"><div class="gray">如http://www.phpwind.net</div></td>
				</tr>
				<tr>
					<th>客户端IP</th>
					<td><input type="text" class="input length_4 mr5" name="appip" value="<?php echo htmlspecialchars($app['siteip'], ENT_QUOTES, 'UTF-8');?>"></td>
				</tr>
				<tr>
					<th>客户端编码</th>
					<td>
						<ul class="switch_list cc">
							<li><label><input name="charset"  value="utf8" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($app['charset'] == 'utf8'), ENT_QUOTES, 'UTF-8');?>><span>UTF-8</span></label></li>
							<li><label><input name="charset"  value="gbk" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($app['charset'] == 'gbk'), ENT_QUOTES, 'UTF-8');?>><span>GBK</span></label></li>
						</ul>
					</td>
				</tr>
				<tr>
					<th>客户端接口文件</th>
					<td><input type="text" class="input length_4 mr5" name="apifile" value="<?php echo htmlspecialchars($app['apifile'], ENT_QUOTES, 'UTF-8');?>"><div class="gray">为空默认为windid.php</div></td>
				</tr>
				<tr>
					<th>通讯密钥</th>
					<td><span class="must_red">*</span><input type="text" class="input length_4 mr5" name="appkey" value="<?php echo htmlspecialchars($app['secretkey'], ENT_QUOTES, 'UTF-8');?>"></td>
				</tr>
				<tr>
					<th>同步登录</th>
					<td>
						<ul class="switch_list cc">
							<li><label><input name="issyn"  value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($app['issyn']), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
							<li><label><input name="issyn"  value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck(!$app['issyn']), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
						</ul>
					</td>
				</tr>
				<tr>
					<th>接收通知</th>
					<td>
						<ul class="switch_list cc">
							<li><label><input name="isnotify"  value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($app['isnotify']), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
							<li><label><input name="isnotify"  value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck(!$app['isnotify']), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="pop_bottom">
			<button class="btn btn_submit fr J_ajax_submit_btn" type="submit" >提交</button>
			<input type="hidden" name="id" value="<?php echo htmlspecialchars($app['id'], ENT_QUOTES, 'UTF-8');?>">
		</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>

<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>

</body>
</html>