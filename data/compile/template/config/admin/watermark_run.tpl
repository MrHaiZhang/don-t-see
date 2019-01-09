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
		<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=watermark'; ?>">水印设置</a></li>
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=watermark&a=set'; ?>">水印策略</a></li>
		</ul>
	</div>
	<div class="h_a">水印设置</div>
	<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=watermark&a=dorun'; ?>" data-role="list">
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>图片附件大小控制</th>
				<td>
					<div class="mb10">宽：<input name="markLimitwidth" type="number" class="input length_2 mr5" value="<?php echo htmlspecialchars($config['mark.limitwidth'], ENT_QUOTES, 'UTF-8');?>"><span>像素</span></div>
					<div>高：<input name="markLimitheight" type="number" class="input length_2 mr5"  value="<?php echo htmlspecialchars($config['mark.limitheight'], ENT_QUOTES, 'UTF-8');?>"><span>像素</span></div>
				</td>
				<td><div class="fun_tips">对超过设定值的图片附件加水印</div></td>
			</tr>
			<tr>
				<th>水印位置</th>
				<td>
					<div class="locate">
						<ul class="cc" id="J_locate_list">
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==1), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="1">左上</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==2), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="2">中上</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==3), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="3">右上</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==4), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="4">左中</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==5), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="5">中心</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==6), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="6">右中</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==7), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="7">左下</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==8), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="8">中下</a></li>
							<li class="<?php echo htmlspecialchars(Pw::isCurrent($config['mark.position']==9), ENT_QUOTES, 'UTF-8');?>"><a href="" data-value="9">右下</a></li>
						</ul>
						<input id="J_locate_input" name="markPosition" type="hidden" value="<?php echo htmlspecialchars($config['mark.position'], ENT_QUOTES, 'UTF-8');?>">
					</div>
				</td>
				<td><div class="fun_tips">选择水印在图片中的位置</div></td>
			</tr>
			<tr>
				<th>为GIF图片加水印</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="markGif" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['mark.gif']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="markGif" value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['mark.gif']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips">开启该功能会导致GIF动画失效</div></td>
			</tr>
			<tr>
				<th>水印类型</th>
				<td>
					<ul class="single_list cc" id="J_watermark_type">
						<li><label><input data-id="J_watermark_img" name="markType" value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['mark.type']==1), ENT_QUOTES, 'UTF-8');?>><span>图片水印</span></label></li>
						<li><label><input data-id="J_watermark_text" name="markType" value="2" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['mark.type']==2), ENT_QUOTES, 'UTF-8');?>><span>文字水印</span></label></li>
					</ul>
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
<?php 
$style = ($config['mark.type']==1) ? 'display:none' : '';
?>
			<tbody id="J_watermark_text" class="J_watermark_tbody" style="<?php echo htmlspecialchars($style, ENT_QUOTES, 'UTF-8');?>"><!-- 文字 -->
				<tr>
					<th>水印文字</th>
					<td>
						<input name="markText" type="text" class="input length_5" value="<?php echo htmlspecialchars($config['mark.text'], ENT_QUOTES, 'UTF-8');?>">
					</td>
					<td><div class="fun_tips">注：如果为中文，先要在src/repository/font目录中添加中文字体，文件名以cn_开头</div></td>
				</tr>
				<tr>
					<th>水印字体</th>
					<td>
						<select name="markFontfamily" class="select_5">
							<?php  foreach ($fontList as $value){ ?>
							<option value="<?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected($config['mark.fontfamily']==$value), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8');?></option>
							<?php  } ?>
						</select>
					</td>
					<td><div class="fun_tips">字体文件存放在src/repository/font下</div></td>
				</tr>
				<tr>
					<th>水印文字大小</th>
					<td>
						<select name="markFontsize" class="select_5 mr5">
							<option value="5" <?php echo htmlspecialchars(Pw::isSelected($config['mark.fontsize']==5), ENT_QUOTES, 'UTF-8');?>>5</option>
							<option value="8" <?php echo htmlspecialchars(Pw::isSelected($config['mark.fontsize']==8), ENT_QUOTES, 'UTF-8');?>>8</option>
							<option value="10" <?php echo htmlspecialchars(Pw::isSelected($config['mark.fontsize']==10), ENT_QUOTES, 'UTF-8');?>>10</option>
							<option value="20" <?php echo htmlspecialchars(Pw::isSelected($config['mark.fontsize']==20), ENT_QUOTES, 'UTF-8');?>>20</option>
						</select><span>像素</span>
					</td>
					<td><div class="fun_tips"></div></td>
				</tr>
				<tr>
					<th>水印文字颜色</th>
					<td>
						<ul class="single_list cc">
							<li>
								<span class="color_pick J_color_pick"><em style="<?php  if ($config['mark.fontcolor']) { ?>background:<?php echo htmlspecialchars($config['mark.fontcolor'], ENT_QUOTES, 'UTF-8');?>;<?php  } ?>"></em></span>
								<input class="J_hidden_color" name="markFontcolor" type="hidden" value="<?php echo htmlspecialchars($config['mark.fontcolor'], ENT_QUOTES, 'UTF-8');?>">
							</li>
						</ul>
					</td>
					<td><div class="fun_tips"></div></td>
				</tr>
			
			</tbody>
<?php 
$style = ($config['mark.type']==2) ? 'display:none' : '';
?>
			<tbody id="J_watermark_img" class="J_watermark_tbody" style="<?php echo htmlspecialchars($style, ENT_QUOTES, 'UTF-8');?>"> <!-- 图片 -->
				<tr>
					<th>水印文件</th>
					<td>
						<select name="markFile" class="select_5">
							<?php  foreach ($markList as $value){ ?>
							<option value="<?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected($config['mark.file']==$value), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($value, ENT_QUOTES, 'UTF-8');?></option>
							<?php  } ?>
						</select>
					</td>
					<td><div class="fun_tips">水印文件存放在src/repository/mark下</div></td>
				</tr>
			</tbody>
				<tr>
					<th>水印透明度</th>
					<td>
						<input name="markTransparency" type="number" class="input length_5" value="<?php echo htmlspecialchars($config['mark.transparency'], ENT_QUOTES, 'UTF-8');?>" min="1" max="100" >
					</td>
					<td><div class="fun_tips">设置水印图标透明度，数值越大，图标越清晰，值得范围0到100</div></td>
				</tr>
				<tr>
					<th>图片质量</th>
					<td>
						<input name="markQuality" type="number" class="input length_5" value="<?php echo htmlspecialchars($config['mark.quality'], ENT_QUOTES, 'UTF-8');?>" min="1" max="100" >
					</td>
					<td><div class="fun_tips">设置添加水印后的图片质量，数值越大，图片越清晰，值得范围0到100</div></td>
				</tr>
				<tr>
					<th>水印效果预览</th>
					<td>
						<input type="button" id="J_img_preview" value="水印效果预览" class="btn" />
					</td>
					<td><div class="fun_tips">无需保存即可预览</div></td>
				</tr>
		</table>
	</div>

	<div class="btn_wrap">
		<div class="btn_wrap_pd">
			<button class="btn btn_submit mr10 J_ajax_submit_btn" type="submit">提交</button>
		</div>
	</div>
	<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>
	
<!--=================结束=================-->
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script>
$(function(){

	//水印位置
	$('#J_locate_list > li > a').click(function(e){
		e.preventDefault();
		var $this = $(this);
		$this.parents('li').addClass('current').siblings('.current').removeClass('current');
		$('#J_locate_input').val($this.data('value'));
	});
	
	
	//切换显示水印类型
	$('#J_watermark_type input:radio').on('change', function(){
			$('#'+ $(this).data('id')).show().siblings('tbody.J_watermark_tbody').hide();
	});
	
	//引入组件
	Wind.use('dialog', 'ajaxForm', function(){
		
		//水印图片预览
		$('#J_img_preview').click(function(e){
			e.preventDefault();
			var $this = $(this);

			$('form.J_ajaxForm').ajaxSubmit({
				url         : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=watermark&a=view'; ?>',
				dataType	: 'json',
				success		: function(data, statusText, xhr, $form) {
					if(data.state === "success") {
						Wind.dialog.html('<div style="padding:15px;"><img width="700" height="269" style="display:block;" src='+ data.data +' alt="水印效果预览"/></div><div class="pop_bottom tac"><button class="btn J_close" type="button">关闭</button></div>', {
							
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