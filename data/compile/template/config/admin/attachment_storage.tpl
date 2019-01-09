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
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment'; ?>">附件设置</a></li>
		<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=storage'; ?>">附件存储</a></li>
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=thumb'; ?>">附件缩略</a></li>
		<!-- <li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=storage'; ?>">头像存储</a></li> -->
	</ul>
</div>

<div class="h_a">功能说明</div>
<div class="prompt_text">
	<ul>
		<li>附件存储方案支持app扩展，可以到<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=appcenter&c=app'; ?>" class="J_linkframe_trigger">应用中心</a>下载更多的可用存储方案。</li>
		<li>附件存储方式的更换可能会造成附件丢失，<span class="red">建议在深夜或者关闭站点后</span>再进行操作。并且更换附件存储方案需<span class="red">手动转移</span>附件文件(与存储方案本身提供的支持有关)，请谨慎选择！</li>
	</ul>
</div>

<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=dostroage'; ?>" data-role="list">
	<div class="h_a">附件存储方式设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>附件存储</th>
				<td>
					<ul class="single_list cc">
						<?php  if(empty($storages)){ ?>
						<li>暂无任何附件存储方案可选～</li>
						<?php  } 
  
						$msg = '';
						foreach($storages as $var => $value) { 
							$storageType === $var && $msg = $value['description'];
						?>
						<li><span class="mr20"><label><input name="att_storage" data-msg="<?php echo htmlspecialchars($value['description'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($var, ENT_QUOTES, 'UTF-8');?>" type="radio" <?php echo Pw::ifcheck($storageType==$var);?>><span><?php echo htmlspecialchars($value['name'], ENT_QUOTES, 'UTF-8');?></span></label></span> 
							<?php  if ($value['managelink']) { ?>
							<a href="<?php echo htmlspecialchars(WindUrlHelper::createUrl($value['managelink']), ENT_QUOTES, 'UTF-8');?>">[设置]</a>
							<?php  } ?>
						</li>
						<?php  } ?>
					</ul>
				</td>
				<td><div class="fun_tips"><?php echo htmlspecialchars($msg, ENT_QUOTES, 'UTF-8');?></div></td>
			</tr>
		</table>
	</div>

	<div class="h_a">头像存储方式设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>头像存储路径</th>
				<td><?php echo Wekit::C("site", "avatarUrl"); ?></td>
				<td><div class="fun_tips">当修改头像存储方案后，提交本页面，自动更新</div></td>
			</tr>
			<tr>
				<th>附件存储</th>
				<td>
					<ul class="single_list cc">
						<?php  if (empty($windidStorages)) { ?>
						<li>暂无任何附件存储方案可选～</li>
						<?php  } 
  
						$msg = '';
						foreach($windidStorages as $var => $value) { 
							$windidStorageType === $var && $msg = $value['description'];
						?>
						<li><span class="mr20"><label><input name="avatar_storage" data-msg="<?php echo htmlspecialchars($value['description'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($var, ENT_QUOTES, 'UTF-8');?>" type="radio" <?php echo Pw::ifcheck($windidStorageType==$var);?>><span><?php echo htmlspecialchars($value['name'], ENT_QUOTES, 'UTF-8');?></span></label></span> 
							<?php  if ($value['managelink']) { ?>
							<a href="<?php echo htmlspecialchars($value['managelink'], ENT_QUOTES, 'UTF-8');?>">[设置]</a>
							<?php  } ?>
						</li>
						<?php  } ?>
					</ul>
				</td>
				<td><div class="fun_tips"><?php echo htmlspecialchars($msg, ENT_QUOTES, 'UTF-8');?></div></td>
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