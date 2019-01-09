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
<body>
<div class="wrap">
	<div class="nav">
		<ul class="cc">
			<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=email'; ?>">电子邮件设置</a></li>
			<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=email&a=send'; ?>">电子邮件检测</a></li>
		</ul>
	</div>
	<div class="h_a">功能说明</div>
	<div class="prompt_text">
		目前只提供SMTP模式
	</div>
	<div class="h_a">电子邮件设置</div>
	<form class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=email&a=dorun'; ?>" method="post">
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>邮件发送</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input type="radio" name="mailOpen" value="1" <?php echo htmlspecialchars(Pw::ifcheck($config['mailOpen'] == 1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input type="radio" name="mailOpen" value="0" <?php echo htmlspecialchars(Pw::ifcheck($config['mailOpen'] == 0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips">开启后可以给用户发送电子邮件。</div></td>
			</tr>
			<tr>
				<th>SMTP服务器</th>
				<td>
					<input type="text" class="input length_5" name="mailHost" value="<?php echo htmlspecialchars($config['mail.host'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>SMTP端口</th>
				<td>
					<input type="text" class="input length_5" name="mailPort" value="<?php echo htmlspecialchars($config['mail.port'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips">默认不需修改。</div></td>
			</tr>
			<tr>
				<th>发信人地址</th>
				<td>
					<input type="text" class="input length_5" name="mailFrom" value="<?php echo htmlspecialchars($config['mail.from'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>SMTP用户身份验证</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input type="radio" name="mailAuth" value="1" <?php echo htmlspecialchars(Pw::ifcheck($config['mail.auth'] == 1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input type="radio" name="mailAuth" value="0" <?php echo htmlspecialchars(Pw::ifcheck($config['mail.auth'] == 0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips">如果SMTP服务器要求通过身份验证才可以发邮件，请选择"开启"。</div></td>
			</tr>
			<tr>
				<th>验证用户名</th>
				<td>
					<input type="text" class="input length_5" name="mailUser" value="<?php echo htmlspecialchars($config['mail.user'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>验证密码</th>
				<td>
					<input type="text" class="input length_5" name="mailPassword" value="<?php echo htmlspecialchars($password, ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips">安全考虑，只显示密码的前后两位，中间显示八个 * 号。</div></td>
			</tr>
		</table>
	</div>
	<div class="btn_wrap">
		<div class="btn_wrap_pd">
		<button class="btn btn_submit J_ajax_submit_btn" type="submit">提交</button>
		</div>
	</div>
	<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>
