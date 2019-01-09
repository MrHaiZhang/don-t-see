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
			<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=u&c=manage'; ?>">用户管理</a></li>
		</ul>
	</div>
	<div class="h_a">提示信息</div>
	<div class="mb10 prompt_text">
		<ol>
			<li>用户名和电子邮箱支持模糊搜索。用户名或电子邮箱输入“a” 则检索出所有以a开头的用户名或电子邮箱。</li>
			<li>可以对用户的基本信息、积分信息、用户组，以及用户产生的内容进行管理。</li>
		</ol>
	</div>
	<div class="mb10"><a class="btn J_dialog" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=u&c=manage&a=add'; ?>" title="添加用户" role="button"><span class="add"></span>添加用户</a></div>
	<div class="h_a">搜索</div>
	<div class="search_type cc mb10">
		<form action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=u&c=manage'; ?>" method="post">
		<input type="hidden" name="page" value="<?php echo htmlspecialchars($page, ENT_QUOTES, 'UTF-8');?>">
		<label>用户组：</label>
		<select name="gid[]" size="5" class="mr10" multiple>
			<option value="-1" <?php echo htmlspecialchars(Pw::isSelected(Pw::inArray(-1, $args['gid'])), ENT_QUOTES, 'UTF-8');?>>不限制</option>
			<?php foreach($groups as $item) {?>
				<option value="<?php echo htmlspecialchars($item['gid'], ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected(Pw::inArray($item['gid'], $args['gid'])), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8');?></option>
			<?php }?>
		</select>
		<label>用户名包含：</label><input name="username" type="text" class="input length_2 mr10" value="<?php echo htmlspecialchars($args['username'], ENT_QUOTES, 'UTF-8');?>">
		<label>UID：</label><input name="uid" type="number" class="input length_1 mr10" value="<?php echo htmlspecialchars($args['uid'], ENT_QUOTES, 'UTF-8');?>">
		<label>电子邮箱：</label><input name="email" type="text" class="input mr10" value="<?php echo htmlspecialchars($args['email'], ENT_QUOTES, 'UTF-8');?>">
		<?php  if ($hasSensitive) { ?>
		<label>是否有敏感词：<input type="checkbox" name="hasSensitive" value="1" checked="checked"></label>
		<?php  } else{ ?>
		<label>是否有敏感词：<input type="checkbox" name="hasSensitive" value="1"></label>
		<?php  } ?>
		<label>敏感词包含：</label><input name="sensitive" type="text" class="input length_2 mr10" value="<?php echo htmlspecialchars($args['sensitive'], ENT_QUOTES, 'UTF-8');?>">
		<button type="submit" class="btn">搜索</button>
		<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
	</div>
		<?php  if ($list) { ?>
	<div class="table_list">
		<table width="100%">
			<thead>
				<tr>
					<td width="30">UID</td>
					<td>用户名</td>
					<td>昵称</td>
					<!-- <td>电子邮箱</td> -->
					<td>手机号</td>
					<td>唯一ID</td>
					<td>注册时间</td>
					<td>最后登录时间</td>
					<td>积分</td>
					<td>敏感词</td>
					<td>操作</td>
				</tr>
			</thead>
		<?php foreach ($list as $key => $item) {?>
			<tr>
				<td><?php echo htmlspecialchars($item['uid'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($item['username'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($item['nickname'], ENT_QUOTES, 'UTF-8');?></td>
				<!-- <td><?php echo htmlspecialchars($item['email'], ENT_QUOTES, 'UTF-8');?></td> -->
				<td><?php echo htmlspecialchars($item['mobile'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($item['ident_id'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars(Pw::time2str($item['regdate'], 'Y-m-d H:i:s'), ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars(Pw::time2str($item['lastvisit'], 'Y-m-d H:i:s'), ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($item['credit1'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($item['sensitive'], ENT_QUOTES, 'UTF-8');?></td>
				<td><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?uid=', rawurlencode($item['uid']),'&m=u&c=manage&a=edit'; ?>" class="mr10" title="编辑">[编辑]</a>
					<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?uid=', rawurlencode($item['uid']),'&m=u&c=manage&a=clear'; ?>" class="mr10 J_dialog" title="清理">[清理]</a>
					<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?key=2&value=', rawurlencode($item['username']),'&m=u&c=forbidden'; ?>" title="禁止">[禁止]</a></td>
			</tr>
		<?php }?>
		</table>
	</div>
	<?php $__tplPageCount=(int)$count;
$__tplPagePer=(int)$perPage;
$__tplPageTotal=(int)0;
$__tplPageCurrent=(int)$page;
if($__tplPageCount > 0 && $__tplPagePer > 0){
$__tmp = ceil($__tplPageCount / $__tplPagePer);
($__tplPageTotal !== 0 &&  $__tplPageTotal < $__tmp) || $__tplPageTotal = $__tmp;}
$__tplPageCurrent > $__tplPageTotal && $__tplPageCurrent = $__tplPageTotal;
if ($__tplPageTotal > 1) {
 
$_page_min = max(1, $__tplPageCurrent-3);
$_page_max = min($__tplPageTotal, $__tplPageCurrent+3);
?>
<div class="pages">
<?php  if ($__tplPageCurrent > $_page_min) { 
	$_page_i = $__tplPageCurrent-1;
?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_pre J_pages_pre">&laquo;&nbsp;上一页</a>
	<?php  if ($_page_min > 1) { 
		$_page_i = 1;		
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>">1...</a>
	<?php  } 
  for ($_page_i = $_page_min; $_page_i < $__tplPageCurrent; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  } ?>
	<strong><?php echo htmlspecialchars($__tplPageCurrent, ENT_QUOTES, 'UTF-8');?></strong>
<?php  if ($__tplPageCurrent < $_page_max) { 
  for ($_page_i = $__tplPageCurrent+1; $_page_i <= $_page_max; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  if ($_page_max < $__tplPageTotal) { 
		$_page_i = $__tplPageTotal;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>">...<?php echo htmlspecialchars($__tplPageTotal, ENT_QUOTES, 'UTF-8');?></a>
	<?php  }
		$_page_i = $__tplPageCurrent+1;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=u&c=manage'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_next J_pages_next">下一页&nbsp;&raquo;</a>
<?php  } ?>
</div>
<?php } 
  } else { ?>
			<div class="not_content_mini"><i></i>啊哦，没有符合条件的用户！</div>
		<?php  } ?>
	
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>