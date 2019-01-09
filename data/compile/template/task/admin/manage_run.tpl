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
<!--===================任务列表====================-->
<form class="J_ajaxForm" data-role="list" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=task&c=manage&a=open'; ?>" method="post">
	<div class="h_a">基本设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>任务中心</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input type="radio" name="isOpen" value="1" <?php echo htmlspecialchars(Pw::ifcheck($isOpen == 1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input type="radio" name="isOpen" value="0" <?php echo htmlspecialchars(Pw::ifcheck($isOpen == 0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>
	<div class="mb10"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=task&c=manage&a=add'; ?>" class="btn"><span class="add"></span>添加新任务</a></div>
	<div class="table_list">
		<table width="100%" class="J_check_wrap">
			<colgroup>
				<col width="65">
			</colgroup>
			<thead>
				<tr>
					<td>顺序</td>
					<td>名称</td>
					<td><label><input class="J_check_all" data-checklist="J_check_y" data-direction="y" type="checkbox">启用</label></td>
					<td>奖励</td>
					<td>时限</td>
					<td>操作</td>
				</tr>
			</thead>
			<?php  if ($list) { 
 foreach($list as $id => $task) {
				if(!$task['start_time'] && $task['end_time'] == PwTaskDm::MAXENDTIME) {
					$time = '不限';
				} else {
					$start_time = $task['start_time'] ? Pw::time2str($task['start_time'], 'Y-m-d') . '开始' : '不限';
					$end_time = $task['end_time'] == PwTaskDm::MAXENDTIME ? '不限' : Pw::time2str($task['end_time'], 'Y-m-d') . '结束';
					$time = $start_time . ' 至 ' . $end_time;
				}
				$reward = $task['reward']['descript'] ? $task['reward']['descript'] : '无';
				$msg = isset($task['msg']) ? ' data-msg=' . $task['msg'] . '' : '';
			?>
			<tr>
				<td><input type="number" name="task[<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>][sequence]" class="input length_1" value="<?php echo htmlspecialchars($task['view_order'], ENT_QUOTES, 'UTF-8');?>"></td>
				<td><input type="text" name="task[<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>][title]" class="input length_3" value="<?php echo htmlspecialchars($task['title'], ENT_QUOTES, 'UTF-8');?>"></td>
				<td><input type="checkbox" name="task[<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>][status]" data-yid="J_check_y" class="J_check" <?php echo htmlspecialchars(Pw::ifCheck($task['is_open']), ENT_QUOTES, 'UTF-8');?> value="1">
				</td>
				<td><?php echo htmlspecialchars($reward, ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($time, ENT_QUOTES, 'UTF-8');?></td>
				<td><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?id=', rawurlencode($id),'&m=task&c=manage&a=edit'; ?>" class="mr5">[编辑]</a><a class="J_ajax_del" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=task&c=manage&a=del'; ?>" data-pdata="{'id':'<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>'}" <?php echo htmlspecialchars($msg, ENT_QUOTES, 'UTF-8');?>>[删除]</a></td>
			</tr>
			<?php }
  } else { ?>
				<tr><td colspan="7" class="tac">啊哦，暂无内容！</td></tr>
			<?php  } ?>
		</table>
		<div class="p10"><?php $__tplPageCount=(int)$count;
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
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_pre J_pages_pre">&laquo;&nbsp;上一页</a>
	<?php  if ($_page_min > 1) { 
		$_page_i = 1;		
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>">1...</a>
	<?php  } 
  for ($_page_i = $_page_min; $_page_i < $__tplPageCurrent; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  } ?>
	<strong><?php echo htmlspecialchars($__tplPageCurrent, ENT_QUOTES, 'UTF-8');?></strong>
<?php  if ($__tplPageCurrent < $_page_max) { 
  for ($_page_i = $__tplPageCurrent+1; $_page_i <= $_page_max; $_page_i++) { 
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($_page_i, ENT_QUOTES, 'UTF-8');?></a>
	<?php  } 
  if ($_page_max < $__tplPageTotal) { 
		$_page_i = $__tplPageTotal;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>">...<?php echo htmlspecialchars($__tplPageTotal, ENT_QUOTES, 'UTF-8');?></a>
	<?php  }
		$_page_i = $__tplPageCurrent+1;
	?>
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?page=', rawurlencode($_page_i),'&m=task&c=manage'; 
 echo htmlspecialchars(array() ? '&' . http_build_query(array()) : '', ENT_QUOTES, 'UTF-8');?>" class="pages_next J_pages_next">下一页&nbsp;&raquo;</a>
<?php  } ?>
</div>
<?php } ?></div>
	</div>
	<?php  if ($list) { ?>
	<div class="btn_wrap">
		<div class="btn_wrap_pd">
			<button class="btn btn_submit J_ajax_submit_btn" type="submit">提交</button>
		</div>
	</div>
	<?php  } ?>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>