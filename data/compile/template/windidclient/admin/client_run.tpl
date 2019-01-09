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
<div class="wrap J_check_wrap">	
	<div class="nav">
		<ul class="cc">
			<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=client'; ?>">客户端列表</a></li>
		</ul>
	</div>
	<!-- <div class="h_a">功能说明</div>
	<div class="prompt_text">
		<ul>
			<li>在此设置。</li>
		</ul>
	</div> -->
	<div class="cc mb10"><a class="btn J_dialog" title="添加客户端" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=client&a=add'; ?>" role="button"><span class="add"></span>添加客户端</a></div>
	<div class="table_list">
		<table width="100%">
			<colgroup>
				<col width="30">
				<col width="120">
				<col width="200">
				<col width="70">
				<col width="70">
				<col width="150">
				<col width="70">
			</colgroup>
			<thead>
				<tr>
					<td title="客户端ID">ID</td>
					<td>客户端名称</td>
					<td>通讯地址</td>
					<td>同步登录</td>
					<td>接收通知</td>
					<td>通讯密钥</td>
					<td>通讯状态</td>
					<td>操作</td>
				</tr>
			</thead>
			<tbody id="J_client_tbody">
				<?php  foreach ($list as $v){ ?>
				<tr>
					<td><?php echo htmlspecialchars($v['id'], ENT_QUOTES, 'UTF-8');?></td>
					<td><?php echo htmlspecialchars($v['name'], ENT_QUOTES, 'UTF-8');?></td>
					<td><?php echo htmlspecialchars($v['siteurl'], ENT_QUOTES, 'UTF-8');?>/<?php echo htmlspecialchars($v['apifile'], ENT_QUOTES, 'UTF-8');?></td>
					<td><?php  if($v['issyn']){?>是<?php  }else{ ?>否<?php }?></td>
					<td><?php  if($v['isnotify']){?>是<?php  }else{ ?>否<?php }?></td>
					<td><?php echo htmlspecialchars($v['secretkey'], ENT_QUOTES, 'UTF-8');?></td>
					<td data-id="<?php echo htmlspecialchars($v['id'], ENT_QUOTES, 'UTF-8');?>" class="J_status"><img src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>/admin/content/loading.gif"></td>
					<td>
						<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?id=', rawurlencode($v['id']),'&m=windidclient&c=client&a=edit'; ?>" class="mr10 J_dialog" title="编辑客户端">[编辑]</a>
						<a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=client&a=delete'; ?>" class="mr10 J_ajax_del" data-msg="确定要删除选中内容?" data-pdata="{'id': '<?php echo htmlspecialchars($v['id'], ENT_QUOTES, 'UTF-8');?>'}">[删除]</a>
					</td>
				</tr>
				<?php  } ?>
			</tbody>
		</table>
		
	</div>

</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
var CLIENT_URL = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=windidclient&c=client&a=clientTest'; ?>";
Wind.js(GV.JS_ROOT +'pages/admin/common/windId.js?v='+ GV.JS_VERSION);
</script>
</body>
</html>