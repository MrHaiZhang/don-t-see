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
	<!-- <div class="nav">
		<ul class="cc">
			<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=notify'; ?>">通知管理</a></li>
		</ul>
	</div> -->
	<div class="h_a">提示信息</div>
	<div class="mb10 prompt_text">
		<ol>
			<li>用于管理客户端信息同步通知。</li>
			<li>过期通知指的是所有客户端都已执行成功的通知，定期删除可提高系统性能。</li>
			<li>一些总是失败的通知，可以删除掉，可提高系统性能</li>
		</ol>
	</div>
	
	<div class="h_a">搜索</div>
	<div class="search_type cc mb10">
		<form action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=notify'; ?>" method="post">
		<label>执行状态：</label>
			<select name="complete" class="select_2">
				<option value="">不限</option>
				<option value="1" <?php echo htmlspecialchars(Pw::isSelected($args['complete']), ENT_QUOTES, 'UTF-8');?>>成功</option>
				<option value="0" <?php echo htmlspecialchars(Pw::isSelected($args['complete'] === '0'), ENT_QUOTES, 'UTF-8');?>>失败</option>
			</select>
			
			
		<label>客户端：</label>
			<select name="clientid" class="select_2">
				<option value="">不限</option>
			<?php foreach ($apps as $v) {?>
				<option value="<?php echo htmlspecialchars($v['id'], ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($v['name'], ENT_QUOTES, 'UTF-8');?></option>
			<?php }?>
			</select>
		<button type="submit" class="btn">搜索</button>
		<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
	</div>
	<div class="table_list">
		<table width="100%">
			<thead>
				<tr>
					<td width="60">通知ID</td>
					<td>通知对象</td>
					<td>通知内容</td>
					<td>通知时间</td>
					<td>执行次数</td>
					<td>当前状态</td>
					<td>操作</td>
				</tr>
			</thead>
		<?php foreach ($list as $key => $v) {?>
			<tr>
				<td><?php echo htmlspecialchars($v['logid'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['fromclient'], ENT_QUOTES, 'UTF-8');?> -> <?php echo htmlspecialchars($v['client'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['operation'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars(Pw::time2str($v['time'], 'Y-m-d H:i:s'), ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['send_num'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php  if($v['complete']){?>成功<?php  }else{ ?><span style="color:#ff0000">失败</span><?php }?></td>
				<td><?php  if(!$v['complete']){?><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?logid=', rawurlencode($v['logid']),'&m=windidclient&c=notify&a=resend'; ?>" class="mr10" title="重新发送">[重新发送]</a><?php }?><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=notify&a=delete'; ?>" class="mr10 J_ajax_del" class="mr10 J_ajax_del" data-msg="确定要删除选中内容?" data-pdata="{'logid': '<?php echo htmlspecialchars($v['logid'], ENT_QUOTES, 'UTF-8');?>'}">[删除]</a></td>
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
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_pre J_pages_pre">&laquo;&nbsp;上一页</a>
	<?php  if ($_page_min > 1) { 
		$_page_i = 1;		
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>">1...</a>
	<?php  } 
  for ($_page_i = $_page_min; $_page_i < $__tplPageCurrent; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  } ?>
	<strong><?php echo htmlspecialchars($__tplPageCurrent, ENT_QUOTES, 'UTF-8');?></strong>
<?php  if ($__tplPageCurrent < $_page_max) { 
  for ($_page_i = $__tplPageCurrent+1; $_page_i <= $_page_max; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  if ($_page_max < $__tplPageTotal) { 
		$_page_i = $__tplPageTotal;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>">...<?php echo htmlspecialchars($__tplPageTotal, ENT_QUOTES, 'UTF-8');?></a>
	<?php  }
		$_page_i = $__tplPageCurrent+1;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=windidclient&c=notify'; 
 echo htmlspecialchars($args ? '&' . http_build_query($args) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_next J_pages_next">下一页&nbsp;&raquo;</a>
<?php  } ?>
</div>
<?php } ?>
	<div class="btn_wrap">
		<div class="btn_wrap_pd" id="J_sub_wrap">
			<a class="btn" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=notify&a=clear'; ?>" title="清理过期通知">清理过期通知</a>
		</div>
	</div>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>