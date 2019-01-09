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
		<li>此功能把站点的URL转换成静态链接的方式，更容易被搜索引擎收录。</li>
		<li><span class="red">开启伪静态功能后，需要开启服务器的rewrite模块</span></li>
		<li>url格式尽量加些特殊前缀以及连接符(例如.*-等)作为唯一标识，否则url容易冲突造成混乱。</li>
		<li>当格式中含有/时，需要把导航地址都设为绝对地址，否则会引起根目录混乱。</li>
		<li>如果url格式中包含{fname}参数，则必须在<a class="J_linkframe_trigger" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=bbs&c=setforum'; ?>">【版块编辑】</a>中设置版块的个性域名后才能正常访问。</li>
	</ul>
</div>
<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=rewrite&c=rewrite&a=doModify'; ?>">
<div class="h_a">URL伪静态设置</div>
<div class="table_purview mb10">
<table width="100%" class="J_check_wrap">
		<tr class="hd">
			<th width="160">页面</th>
			<td width="200">可用url参数</td>
			<td width="260">url格式</td>
			<td><label><input name="" class="J_check_all" data-checklist="J_check_rewrite" data-direction="y" type="checkbox" value="">全选</label></td>
		</tr>
		<?php  foreach($addons as $k => $v){ ?>
		<tr>
			<th><?php echo htmlspecialchars($v[0], ENT_QUOTES, 'UTF-8');?></th>
			<td><?php echo htmlspecialchars($v[1], ENT_QUOTES, 'UTF-8');?></td>
			<td>
			<?php  if($k == 'default'){ ?>
				m-c-a
			<?php  }else{
				$format = empty($rewrite["format.$k"]) ? $v[3] : $rewrite["format.$k"];
			 ?>
				<input name="format[<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>]" type="text" value='<?php echo htmlspecialchars($format, ENT_QUOTES, 'UTF-8');?>' class="input length_4">
			<?php  } ?>
			</td>
			<td><input name="isopen[<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>]" type="checkbox" value="1" class="J_check" data-yid="J_check_rewrite" <?php echo htmlspecialchars(Pw::ifcheck($rewrite["isopen.$k"]), ENT_QUOTES, 'UTF-8');?>>
			</td>
		</tr>
		<?php  } ?>
	</table>
</div>
<div class="h_a">使用方法</div>
<div class="prompt_text">
	<div class="red mb20">首先需要确定服务器支持rewrite模块并开启了</div>
	<h3 class="mb10">Apache Web Server 配置</h3>
	<div class="mb20">在www目录下自带了.htaccess文件，开启了rewrite后可直接使用，更改了格式后也无需更改这个文件内容。</div>
	<h3 class="mb10">IIS配置</h3>
	<div class="mb20">iis下建议使用isapi_rewrite 第三版,老版本的rewrite不支持RewriteCond语法。 
	下载地址 http://www.helicontech.com/download-isapi_rewrite3.htm 

<pre>
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f 
RewriteCond %{REQUEST_FILENAME} !-d 
RewriteRule !\.(js|ico|gif|jpe?g|bmp|png|css)$ index.php [L] 
</pre>
管理工具-> internet信息服务-> 网站 点右键. -> 属性 ISAPI筛选器 看到下面那个ISAPI_Rewrite3了吧。 转到 rewrite的选项卡 可以看到里面的rewrite规则 
	</div>
	<h3 class="mb10">Nginx配置</h3>
	<p>
	
<pre>
location / { 
    if (-f $request_filename) {
           break;
    }
    if ($request_filename ~* "\.(js|ico|gif|jpe?g|bmp|png|css)$") {
        break;
    }
    if (!-e $request_filename) {
        rewrite . /index.php last;
    }
} 
</pre>
	</p>
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
