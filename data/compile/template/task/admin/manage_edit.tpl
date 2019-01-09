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
		<div class="return"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=task&c=manage'; ?>">返回上一级</a></div>
	</div>
<form class="J_ajaxForm" data-role="list" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?_json=1&m=task&c=manage&a=doEdit'; ?>" method="post">
<input type="hidden" name="id" value="<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>">
<div class="h_a">编辑任务</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>完成条件</th>
				<td><span class="must_red">*</span>
					<div class="task_item_list">
						<div class="hd">
							<ul class="J_tabs_nav">
				<?php 
					foreach ($conditionList as $key => $item) {
						$current = $task['conditions']['type'] == $key ? 'current' : '';
				?>
								<li id="J_tab_nav_<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>" class="<?php echo htmlspecialchars($current, ENT_QUOTES, 'UTF-8');?>"><a href=""><?php echo htmlspecialchars($item['title'], ENT_QUOTES, 'UTF-8');?></a></li>
				<?php }?>
							</ul>
						</div>
						<input type="hidden" id="J_key" value="<?php echo htmlspecialchars($task['conditions']['type'], ENT_QUOTES, 'UTF-8');?>" name="condition[type]" />
						<div id="J_task_radio" class="J_tabs_contents">
				<?php foreach ($conditionList as $key => $item) {?>
							<div data-id="J_tab_nav_<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>" class="ct J_tab_item" id="<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>">
								<ul class="cc">
							<?php foreach ($item['children'] as $childid => $child) {
									$check = false;
									if ($task['conditions']['type'] == $key && $task['conditions']['child'] == $childid) $check = true;
							?>
									<li><label><input data-key="<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>" type="radio" name="condition[child]" data-param="<?php echo htmlspecialchars($child['var'], ENT_QUOTES, 'UTF-8');?>" data-url="<?php echo htmlspecialchars($child['url'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($childid, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::ifcheck($check), ENT_QUOTES, 'UTF-8');?>/><span><?php echo htmlspecialchars($child['title'], ENT_QUOTES, 'UTF-8');?></span></label></li>
							<?php }?>
								</ul>
							</div>
					<?php }?>
							</div>
						</div>
					</td>
					<td><div class="fun_tips">每个任务需要选择一个完成条件，不同的任务会有不同的限制条件。</div></td>
				</tr>
	
				<tbody id="J_task_main">
					<tr>
						<th>任务名称</th>
						<td>
							<span class="must_red">*</span>
							<input name="title" type="text" class="input length_5 input_hd" value="<?php echo htmlspecialchars($task['title'], ENT_QUOTES, 'UTF-8');?>">
						</td>
						<td><div class="fun_tips">显示在前台的任务名称，最多显示100字。</div></td>
					</tr>
					<tr>
						<th>任务目标描述</th>
						<td>
							<span class="must_red">*</span>
							<textarea name="description" class="length_5"><?php echo htmlspecialchars($task['description'], ENT_QUOTES, 'UTF-8');?></textarea>
						</td>
						<td><div class="fun_tips">显示在前台的任务完成目标描述，支持html代码。</div></td>
					</tr>
					<tr>
						<th>任务图标</th>
						<td>
							<input type="hidden" value="<?php echo htmlspecialchars($task['icon'], ENT_QUOTES, 'UTF-8');?>" name="oldicon" id="J_oldicon" />
							<div class="single_image_up"><a href="">重新选择</a><input name="icon" type="file" class="J_upload_preview" data-preview="#J_icon" value="<?php echo htmlspecialchars($task['icon'], ENT_QUOTES, 'UTF-8');?>"></div>
							<?php if ($task['icon']) {?><img id="J_icon" src="<?php echo htmlspecialchars(Pw::getPath($task['icon']), ENT_QUOTES, 'UTF-8');?>" /><a href="" id="J_task_icon_reset">[恢复系统默认]</a><?php }?>
						</td>
						<td><div class="fun_tips">留空则使用默认图标。</div></td>
					</tr>
					<tr>
						<th>任务有效期</th>
						<td>
							<input name="start_time" type="text" class="input length_2 mr20 J_date" value="<?php echo htmlspecialchars($task['start_time'], ENT_QUOTES, 'UTF-8');?>" min="<?php echo htmlspecialchars($_current, ENT_QUOTES, 'UTF-8');?>"><span class="mr20">至</span><input name="end_time" type="text" class="input length_2 J_date" value="<?php echo htmlspecialchars($task['end_time'], ENT_QUOTES, 'UTF-8');?>"  min="<?php echo htmlspecialchars($_current, ENT_QUOTES, 'UTF-8');?>">
						</td>
						<td><div class="fun_tips">留空代表不限制。</div></td>
					</tr>
					<tr>
						<th>任务周期</th>
						<td>
							<input name="period" type="text" class="input length_5 mr5" value="<?php echo htmlspecialchars($task['period'], ENT_QUOTES, 'UTF-8');?>">小时
						</td>
						<td><div class="fun_tips">如设置为24，则表示该任务开始24小时以后可以再次申请，留空表示一次性任务。</div></td>
					</tr>
					<tr>
						<th>周期可完成数</th>
						<td>
							<input name="end_num" type="text" class="input length_5 mr5" value="<?php echo htmlspecialchars($task['end_num'], ENT_QUOTES, 'UTF-8');?>">次
						</td>
						<td><div class="fun_tips">一个任务周期内可以重复完成的次数</div></td>
					</tr>
					<tr>
						<th>前置任务</th>
						<td>
							<select class="select_5" name="pre_task">
							<option value="0" selected>无</option>
							<?php foreach($pre_tasks as $id => $title){ ?>
							<option value="<?php echo htmlspecialchars($id, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected($task['pre_task'] == $id), ENT_QUOTES, 'UTF-8');?>><?php echo $title;?></option>
							<?php  } ?>
							</select>
						</td>
						<td><div class="fun_tips"></div></td>
					</tr>
					<tr>
						<th>可申请的用户组</th>
						<td>
							<div class="user_group J_check_wrap">
					<?php foreach($groupTypes as $type => $typeName){ ?>
								<dl>
									<dt><label><input class="J_check_all" data-direction="y" data-checklist="J_check_<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>" type="checkbox" <?php echo htmlspecialchars(Pw::ifcheck(1 == $isAll), ENT_QUOTES, 'UTF-8');?> /><?php echo htmlspecialchars($typeName, ENT_QUOTES, 'UTF-8');?></label></dt>
									<dd>
					<?php foreach($groups as $group){ 
						if($group['type'] == $type){
							 $check = Pw::inArray($group['gid'], $task['user_groups']) || 1 == $isAll;
						?>
										<label><input class="J_check" data-yid="J_check_<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>" type="checkbox" name="user_groups[]" value="<?php echo htmlspecialchars($group['gid'], ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::ifcheck($check), ENT_QUOTES, 'UTF-8');?> /><span><?php echo htmlspecialchars($group['name'], ENT_QUOTES, 'UTF-8');?></span></label>
					<?php } }?>
									</dd>
								</dl>
					<?php }?>
							</div>
						</td>
						<td><div class="fun_tips"></div></td>
					</tr>
					<tr>
						<th>申请设置</th>
						<td>
							<ul class="single_list cc">
								<li><label><input type="radio" name="is_auto" value="1" <?php echo htmlspecialchars(Pw::ifcheck($task['is_auto'] == 1), ENT_QUOTES, 'UTF-8');?> >自动申请</label></li>
								<li><label><input type="radio" name="is_auto" value="0" <?php echo htmlspecialchars(Pw::ifcheck($task['is_auto'] == 0), ENT_QUOTES, 'UTF-8');?> >手动申请</label></li>
							</ul>
						</td>
						<td><div class="fun_tips"></div></td>
					</tr>
					<tr>
						<th>显示设置</th>
						<td>
							<ul class="single_list cc">
								<li><label><input type="radio" name="is_display_all" value="0" <?php echo htmlspecialchars(Pw::ifcheck($task['is_display_all'] == 0), ENT_QUOTES, 'UTF-8');?> >符合条件才显示</label></li>
								<li><label><input type="radio" name="is_display_all" value="1" <?php echo htmlspecialchars(Pw::ifcheck($task['is_display_all'] == 1), ENT_QUOTES, 'UTF-8');?> >显示给所有用户</label></li>
							</ul>
						</td>
						<td><div class="fun_tips"></div></td>
					</tr>
					<tr>
						<th>任务奖励</th>
						<td>
							<select id="J_reward_select" class="select_5" name="reward[type]">
								<option value="">无</option>
						<?php foreach ($rewardList as $type => $item) {?>
								<option data-id="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>" data-param="<?php echo htmlspecialchars($item['var'], ENT_QUOTES, 'UTF-8');?>" data-url="<?php echo htmlspecialchars($item['url'], ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected($task['reward']['type'] == $type), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($item['title'], ENT_QUOTES, 'UTF-8');?></option>
						<?php }?>
							</select>
						</td>
						<td><div class="fun_tips"></div></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="btn_wrap">
			<div class="btn_wrap_pd">
				<button class="btn btn_submit J_ajax_submit_btn" type="submit">提交</button>
				<input id="J_checked_all" type="hidden" name="isAll" value="<?php echo htmlspecialchars($isAll, ENT_QUOTES, 'UTF-8');?>" >
			</div>
		</div>
	<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
Wind.use(GV.JS_ROOT +'pages/task/admin/task_manage.js?v=' + GV.JS_VERSION, function(){
	$('#J_task_icon_reset').on('click', function(e){
		e.preventDefault();
		$('#J_icon').hide().attr('src', '');
		$('#J_oldicon').val('');
		$('.J_upload_preview').val('');
		$(this).hide();
	});
});
</script>
</body>
</html>