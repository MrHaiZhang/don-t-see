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
	<div class="h_a">搜索</div>
	<div class="prompt_text">
		<form id="J_forum_search_form" method="post" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=hook&c=manage&a=search'; ?>">
					<input value="<?php echo htmlspecialchars($name, ENT_QUOTES, 'UTF-8');?>" class="input length_3 mr10" name="name" autoComplete="off" type="text" placeholder="hook名称">
					<input value="<?php echo htmlspecialchars($app_name, ENT_QUOTES, 'UTF-8');?>" class="input length_3 mr10" name="app_name" autoComplete="off" type="text" placeholder="应用名称">
					<button id="J_forum_search" class="btn btn_submit" type="submit">搜索</button>
		<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
	</div>
	<div class="cc mb10"><!-- <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=hook&c=manage&a=add'; ?>" class ="btn J_dialog mr10" title="添加新钩子"><span class="add"></span>添加新钩子</a> -->
	<a class="btn J_ajax_refresh" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=cache&a=doHook'; ?>">更新hook緩存</a>
	</div>
	
	<div class="table_list">
		<table width="100%" id="J_table_list" style="table-layout:fixed;">
			<thead>
				<tr>
					<td>系统别名(系统唯一)</td>
					<td>所属模块</td>
					<td>创建时间</td>
					<td>操作</td>
				</tr>
			</thead>
			<tbody>
			<?php  foreach($hooks as $v) { ?>
			<tr>
				<td>
					<span class="mr20"><?php echo htmlspecialchars($v['name'], ENT_QUOTES, 'UTF-8');?></span>
					<!-- <a class="J_dialog link_add" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?hook_name=', rawurlencode($v['name']),'&m=hook&c=inject&a=add'; ?>" style="display: none;" title="添加injector">添加</a> -->
				</td>
				<td><?php echo htmlspecialchars($v['app_name'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars(Pw::time2str($v['created_time']), ENT_QUOTES, 'UTF-8');?></td>
				<td>
				<!-- <a class="J_dialog mr5" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?name=', rawurlencode($v['name']),'&m=hook&c=manage&a=edit'; ?>" title="编辑hook">[编辑]</a>
				<a class="J_ajax_del mr5" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?name=', rawurlencode($v['name']),'&m=hook&c=manage&a=del'; ?>">[删除]</a> -->
				<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?name=', rawurlencode($v['name']),'&m=hook&c=manage&a=detail'; ?>" class="mr5">[查看详细]</a></td>
			</tr>
			<?php  } ?>
			</tbody>
		</table>
	</div>
	<?php  if(isset($search)){ ?>
	<div class="pages">

<?php  if($page > 1) { 
$page_i = $page - 1;
?>

	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?name=', rawurlencode($name),'&page=', rawurlencode($page_i),'&m=hook&c=manage&a=search'; ?>" class="pages_pre">&laquo;&nbsp;上一页</a>

<?php  } if(count($hooks) == $perpage) {
$page_i = $page + 1;
 ?>
 
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?name=', rawurlencode($name),'&page=', rawurlencode($page_i),'&m=hook&c=manage&a=search'; ?>" class="pages_next">下一页&nbsp;&raquo;</a>

<?php  } ?>

</div>
	<?php  }else{ 
 $__tplPageCount=(int)$count;
$__tplPagePer=(int)$perpage;
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
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_pre J_pages_pre">&laquo;&nbsp;上一页</a>
	<?php  if ($_page_min > 1) { 
		$_page_i = 1;		
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>">1...</a>
	<?php  } 
  for ($_page_i = $_page_min; $_page_i < $__tplPageCurrent; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  } ?>
	<strong><?php echo htmlspecialchars($__tplPageCurrent, ENT_QUOTES, 'UTF-8');?></strong>
<?php  if ($__tplPageCurrent < $_page_max) { 
  for ($_page_i = $__tplPageCurrent+1; $_page_i <= $_page_max; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  if ($_page_max < $__tplPageTotal) { 
		$_page_i = $__tplPageTotal;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>">...<?php echo htmlspecialchars($__tplPageTotal, ENT_QUOTES, 'UTF-8');?></a>
	<?php  }
		$_page_i = $__tplPageCurrent+1;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=hook&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_next J_pages_next">下一页&nbsp;&raquo;</a>
<?php  } ?>
</div>
<?php } 
  } ?>
	
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
//鼠标移上去显示添加导航按钮
$('#J_table_list').on('mouseover', 'tr', function (e) {
	$(this).find('a.link_add').show();
}).on('mouseout', 'tr', function (e) {
	$(this).find('a.link_add').hide();
});
</script>
</body>
</html>