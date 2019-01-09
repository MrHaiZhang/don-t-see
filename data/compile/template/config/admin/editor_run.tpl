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

<!-- start -->
<div class="nav">
	<ul class="cc">
		<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=editor'; ?>">基本设置</a></li>
	</ul>
</div>

<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=editor&a=dorun'; ?>" data-role="list">
	<div class="h_a">功能设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>布局样式</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="style" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['editor.style']==0), ENT_QUOTES, 'UTF-8');?>><span>高级</span></label></li>
						<li><label><input name="style" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['editor.style']==1), ENT_QUOTES, 'UTF-8');?>><span>简单</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>内容重复验证</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="content_duplicate" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['content.duplicate']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="content_duplicate" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['content.duplicate']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>

	<div class="h_a">标签设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>帖子中标签转换控制</th>
				<td>
					<input name="cvtimes" type="text" class="input length_3" value="<?php echo htmlspecialchars($config['ubb.cvtimes'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>[img]标签</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="img_open" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.img.open']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="img_open" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.img.open']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>[img]大小控制</th>
				<td>
					<div class="mb10">宽:&nbsp;<input name="img_width" type="number" class="input length_2 mr5" value="<?php echo htmlspecialchars($config['ubb.img.width'], ENT_QUOTES, 'UTF-8');?>">像素</div>
					<div>高:&nbsp;<input name="img_height" type="number" class="input length_2 mr5" value="<?php echo htmlspecialchars($config['ubb.img.height'], ENT_QUOTES, 'UTF-8');?>">像素</div>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>[size]标签最大值控制</th>
				<td>
					<input name="size_max" type="text" class="input length_3" value="<?php echo htmlspecialchars($config['ubb.size.max'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips">建议取值：5~7，留空不限制</div></td>
			</tr>
			<tr>
				<th>[flash]标签</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="flash_open" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.flash.open']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="flash_open" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.flash.open']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>多媒体标签</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="media_open" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.media.open']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="media_open" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.media.open']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>[iframe]标签</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="iframe_open" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.iframe.open']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="iframe_open" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['ubb.iframe.open']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>
	<div class="btn_wrap">
		<div class="btn_wrap_pd">
			<button class="btn btn_submit mr10 J_ajax_submit_btn" type="submit">提交</button>
		</div>
	</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
<!-- end -->

</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>