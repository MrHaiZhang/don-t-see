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

<div class="h_a">功能说明</div>
<div class="prompt_text">
	<ul>
		<li>可以为每个应用设置二级域名，根域名需和站点地址中的设置保持一致。</li>
		<li>如果应用的不同页面还需要分配子域名，则勾选“子域名”，并设置根域名。然后在具体应用的频道设置中设置子域名。根域名可以重复，根域名请不要频繁修改。
	    比如要设置版块的应用域名，开启子域名，设置根域名为空，则版块的域名形如food.phpwind.net；
	    如果设置根域名为bbs，则版块的域名形如food.bbs.phpwind.net</li>
	    <li class="red">不建议频繁更改根域名</li>
	    <li class="red">设置完二级域名后，建议重新提交下后台<a class="J_linkframe_trigger" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=nav&c=nav'; ?>">导航</a>，防止跨子域失败。</li>
	</ul>
</div>
<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=rewrite&c=domain&a=doModify'; ?>">
		<?php  if($root){ ?>
<div class="h_a">应用域名设置</div>
<div class="table_purview mb10">
	<table width="100%">
		<tr class="hd">
			<th width="160">应用名称</th>
			<td width="220">应用域名</td>
			<td width="90">开启子域名</td>
			<td width="220">根域名</td>
			<td></td>
		</tr>
		<?php foreach($addons as $k => $v){ ?>
			<tr>
				<th><?php echo htmlspecialchars($v[0], ENT_QUOTES, 'UTF-8');?></th>
				<td><input name="app[<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>]" type="text" value="<?php echo htmlspecialchars($v[2], ENT_QUOTES, 'UTF-8');?>" class="input length_1" >&nbsp;<?php echo htmlspecialchars($root, ENT_QUOTES, 'UTF-8');?></td>
				<?php  if($v[1]){ 
					$pre_root = trim(str_replace(substr($root, 1), '', $domain[$k.'.root']), '.'); ?>
				<td><input name="domain[<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>][isopen]" value="1" type="checkbox" <?php echo htmlspecialchars(Pw::ifcheck($domain[$k.'.isopen']), ENT_QUOTES, 'UTF-8');?>></td>
				<td><input name="domain[<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>][root]" type="text" value="<?php echo htmlspecialchars($pre_root, ENT_QUOTES, 'UTF-8');?>" class="input length_1" >&nbsp;<?php echo htmlspecialchars($root, ENT_QUOTES, 'UTF-8');?></td>
				<td></td>
				<?php  }else{ ?>
				<td>无</td>
				<td>不需设置</td>
				<td></td>
				<?php  } ?>
			</tr>
			<?php  } ?>
	</table>
</div>
		<?php  } else{ ?>
		<div class="not_content_mini"><i></i>要开启个性域名，需先&nbsp;<a class="J_linkframe_trigger" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=config&a=site'; ?>">设置cookie作用域</a></div>
		<?php  } ?>

<div class="h_a">保留二级域名</div>
<div class="table_full">
	<table width="100%">
		<tr>
			<th width="160">保留二级域名</th>
			<td width="320"><textarea class="length_5" name="domain_hold"><?php echo htmlspecialchars($domain['domain.hold'], ENT_QUOTES, 'UTF-8');?></textarea></td>
			<td>
			<span>
			开启了类似空间应用的子域名功能后，
			保留二级域名可以控制用户不能使用设置的关键词作为二级域名，可以通过“*”模糊匹配。
			多个词之间用英文半角逗号","分隔
			</span>
			</td>
		</tr>
	</table>
</div>
<div class="btn_wrap">
	<div class="btn_wrap_pd">
		<button class="btn btn_submit mr10 J_ajax_submit_btn" type="submit">提交</button>
	</div>
</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>
