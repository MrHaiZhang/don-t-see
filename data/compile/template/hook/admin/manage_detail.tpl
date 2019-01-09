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
	<div class="return">
	<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=hook&c=manage'; ?>">返回上一级</a>
	</div>
	</div>
	<div class="h_a">基本信息</div>
	<div class="prompt_text">
		<ul>
		<li>系统别名：<?php echo htmlspecialchars($hook['name'], ENT_QUOTES, 'UTF-8');?></li>
		<li>所属模块：<?php echo htmlspecialchars($hook['app_name'], ENT_QUOTES, 'UTF-8');?></li>
		<li>创建时间：<?php echo htmlspecialchars(Pw::time2str($hook['created_time']), ENT_QUOTES, 'UTF-8');?></li>
		</ul>
	</div>
	<div class="h_a">使用说明</div>
	<div class="prompt_text">
		<pre><?php echo htmlspecialchars($dec, ENT_QUOTES, 'UTF-8');?></pre>
	</div>
	<div class="h_a">参数/返回值</div>
	<div class="prompt_text">
		<pre><?php echo htmlspecialchars($param, ENT_QUOTES, 'UTF-8');?></pre>
	</div>
	<div class="h_a">接口定义</div>
	<div class="prompt_text">
		<pre><?php echo htmlspecialchars($interface, ENT_QUOTES, 'UTF-8');?></pre>
	</div>
	<div class="mb5"><span class="mr20 f14 b ">已注册扩展列表</span>
	<a class ="btn J_dialog" title="向该钩子下添加新扩展" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?hook_name=', rawurlencode($hook['name']),'&m=hook&c=inject&a=add'; ?>"><span class="add"></span>添加</a>
	</div>
	<div class="table_list">
		<table width="100%">
			<thead>
				<tr>
					<td>别名</td>
					<td>所属模块</td>
					<td>描述</td>
					<td>类名</td>
					<td>方法名</td>
					<td>加载方式</td>
					<td>挂载条件</td>
					<td>操作</td>
				</tr>
			</thead>
			<?php  foreach($injectors as $v) { ?>
			<tr>
				<td><?php echo htmlspecialchars($v['alias'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['app_name'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['description'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['class'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['method'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['loadway'], ENT_QUOTES, 'UTF-8');?></td>
				<td><?php echo htmlspecialchars($v['expression'], ENT_QUOTES, 'UTF-8');?></td>
				<td><a class="J_dialog mr10" title="编辑Injector" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?id=', rawurlencode($v['id']),'&m=hook&c=inject&a=edit'; ?>">[编辑]</a><a class="J_ajax_del" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?id=', rawurlencode($v['id']),'&m=hook&c=inject&a=del'; ?>">[删除]</a></td>
			</tr>
			<?php  } ?>
		</table>
	</div>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>