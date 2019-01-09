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
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=storage'; ?>">附件存储</a></li>
		<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=thumb'; ?>">附件缩略</a></li>
		<!-- <li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=storage'; ?>">头像存储</a></li> -->
	</ul>
</div>

<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=dothumb'; ?>" data-role="list">
	<div class="h_a">缩略图设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>帖子图片缩略设置</th>
				<td>
					<ul class="single_list cc">
						<li><label><input type="radio" checked="" value="0" name="thumb"<?php echo htmlspecialchars(Pw::ifcheck($config['thumb'] == 0), ENT_QUOTES, 'UTF-8');?>><span>不缩略</span></label></li>
						<li><label><input type="radio" value="1" name="thumb"<?php echo htmlspecialchars(Pw::ifcheck($config['thumb'] == 1), ENT_QUOTES, 'UTF-8');?>><span>等比缩略</span></label></li>
						<li><label><input type="radio" value="2" name="thumb"<?php echo htmlspecialchars(Pw::ifcheck($config['thumb'] == 2), ENT_QUOTES, 'UTF-8');?>><span>居中截取</span></label></li>
					</ul>
				</td>
				<td>
					<div class="fun_tips">
						等比缩略：最大的一边等比缩略，保留图片原本比例。<br>
						居中截取：最小的一边等比缩略后截取中间部分，可使界面丰满，一般用于设置好图片大小的界面。
					</div>
				</td>
			</tr>
			<tr>
				<th>缩略图大小设置[宽×高]</th>
				<td><input type="text" name="thumbsize_width" value="<?php echo htmlspecialchars($config['thumb.size.width'], ENT_QUOTES, 'UTF-8');?>" class="input length_2 mr5"><span class="mr10">像素</span><span class="mr10">-</span><input type="text" name="thumbsize_height" value="<?php echo htmlspecialchars($config['thumb.size.height'], ENT_QUOTES, 'UTF-8');?>" class="input mr5 length_2"><span>像素</span></td>
				<td><div class="fun_tips">超过此尺寸的图才缩略</div></td>
			</tr>
			<tr>
				<th>缩略图质量</th>
				<td><input name="quality" type="text" class="input length_4" value="<?php echo htmlspecialchars($config['thumb.quality'], ENT_QUOTES, 'UTF-8');?>"></td>
				<td><div class="fun_tips">控制缩略图的生成质量，数字越大越清晰，最高100，建议设置85</div></td>
			</tr>
			<tr>
				<th>缩略图预览</th>
				<td><input type="button" id="J_img_preview" value="图片缩略预览" class="btn" /></td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>
	<div class="btn_wrap">
		<div class="btn_wrap_pd">
			<button class="btn btn_submit mr10 J_ajax_submit_btn" type="submit">提交</button>
		</div>
	</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
<!-- end -->

</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
$(function(){

	//引入组件
	Wind.use('dialog', 'ajaxForm', function(){
		//缩略图预览
		$('#J_img_preview').click(function(e){
			e.preventDefault();
			var $this = $(this);

			$('form.J_ajaxForm').ajaxSubmit({
				url         : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=attachment&a=view'; ?>',
				dataType	: 'json',
				success		: function(data, statusText, xhr, $form) {
					if(data.state === "success") {
						Wind.dialog.html('<div style="padding:15px;"><img style="display:block;" src='+ data.data.img +' alt="缩略图预览"/></div><div class="pop_bottom tac"><button class="btn J_close" type="button">关闭</button></div>', {
							
							onClose : function(){
								$this.focus();
							}
						});
					}else{
						Wind.dialog.alert(data.message);
					}
				}
			});
		});
	});
});
</script>
</body>
</html>