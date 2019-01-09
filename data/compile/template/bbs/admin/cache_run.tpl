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
	<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=dorun'; ?>">
	<div class="h_a">缓存更新</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="100" />
			<col />
			<tr>
				<th>更新站点缓存</th>
				<td>
					<a class="btn" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=dorun'; ?>">提交</a>
				</td>
				<td><div class="fun_tips">数据转换后或前台不能正常访问时，可以使用此功能更新所有缓存</div></td>
			</tr>
			<tr>
				<th>重新统计版块帖子数</th>
				<td>
					<a class="btn" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=doforum'; ?>">提交</a>
				</td>
				<td><div class="fun_tips">当版块帖子数统计不准确时，可以使用此功能重新统计</div></td>
			</tr>
			<tr>
				<th>开启css压缩</th>
				<td>
					<?php  if(Wekit::C('site','css.compress')){
					$text='关闭';$tip='已开启';
					}else{ 
					$text='开启';$tip='已关闭';
					} ?>
					<a class="btn J_ajax_refresh" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=buildCss'; ?>">
					<?php echo htmlspecialchars($text, ENT_QUOTES, 'UTF-8');?>
					</a>
				</td>
				<td><div class="fun_tips">当前状态：<span class="red"><?php echo htmlspecialchars($tip, ENT_QUOTES, 'UTF-8');?></span>。开启后，可使css大小减少20%-30%，新装模板需要更新css缓存。</div></td>
			</tr>
			<tr>
				<th>更新css缓存</th>
				<td>
					<a class="btn" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=doCss'; ?>">提交</a>
				</td>
				<td><div class="fun_tips">在开启css压缩情况下，可以重新压缩css</div></td>
			</tr>
			<tr>
				<th>清除模板缓存</th>
				<td>
					<a class="btn" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=doTpl'; ?>">提交</a>
				</td>
				<td><div class="fun_tips">当页面显示不正常，可尝试使用此功能修复</div></td>
			</tr>
		</table>
	</div>
	<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>