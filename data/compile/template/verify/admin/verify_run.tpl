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
		<li class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=verify&c=verify'; ?>">验证码</a></li>
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=verify&c=verify&a=set'; ?>">验证策略</a></li>
	</ul>
</div>
<div class="h_a">提示信息</div>
<div class="prompt_text mb10">
	验证机制统一设置验证码规则，对应模块需要开启验证码功能需在验证策略中启用。
</div>
<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=verify&c=verify&a=dorun'; ?>" data-role="list">
	<div class="h_a">验证码设置</div>
	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>验证码类型</th>
				<td>
					<ul class="single_list cc">
						<?php  foreach($verifyType AS $k=>$v){
							$msg .= $v['description'] . '<br/>';
						?>
						<li><label><input name="type"  value="<?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8');?>" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['type']==$k), ENT_QUOTES, 'UTF-8');?>><span><?php echo htmlspecialchars($v['name'], ENT_QUOTES, 'UTF-8');?></span></label></li>
						<?php  } ?>
					</ul>
				</td>
				<td class="td_tips">
				<div>
					<?php echo $msg;?>
				</div></td>
			</tr>
			<tr>
				<th>识别难度</th>
				<td>
					<ul class="three_list cc">
						<li><label><input name="randtype[]" type="checkbox" value="font" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('font',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机字体</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="size" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('size',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机字体大小</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="angle" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('angle',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机倾斜</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="background" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('background',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机背景</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="color" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('color',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机颜色</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="graph" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('graph',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机干扰图形</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="distortion" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('distortion',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>随机扭曲</span></label></li>
						<li><label><input name="randtype[]" type="checkbox" value="gif" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('gif',$config['randtype'])), ENT_QUOTES, 'UTF-8');?>><span>gif动画</span></label></li>
					</ul>
				</td>
				<td class="td_tips"><div>由于部分服务器对字体和gif功能支持不友好，如果您的站点开启验证码后出现服务器不稳定现象请关闭“随机字体”、“gif动画”</div></td>
			</tr>
			<tr>
				<th class="th" rowspan="2">验证码内容</th>
				<td class="td">
					<ul class="single_list cc mb20">
						<li><label><input name="contentType[]" type="checkbox" value="3" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('3',$config['content.type'])), ENT_QUOTES, 'UTF-8');?>><span>英文字符和数字</span></label></li>
						<li><label><input name="contentType[]" type="checkbox" value="5" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('5',$config['content.type'])), ENT_QUOTES, 'UTF-8');?>><span>中文字符</span></label></li>
					</ul>
					<div class="b mb5">验证码个数（建议设置为4个）</div>
					<input name="contentLength" type="number" class="input" value="<?php echo htmlspecialchars($config['content.length'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td class="td_tips"><div>四种验证码内容供选择，多选情况下随机出现其中一种<br><span class="red">注：启用中文验证码，先要在src/repository/font目录中添加中文字体，文件名以cn_开头</span></div></td>
			</tr>
			<tr>
				<td class="td">
					<ul class="single_list cc mb20">
						<li><label><input name="contentType[]" type="checkbox" value="4" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('4',$config['content.type'])), ENT_QUOTES, 'UTF-8');?>><span>100以内随机加减法</span></label></li>
						<li><label><input name="contentType[]" type="checkbox" value="6" <?php echo htmlspecialchars(Pw::ifcheck(Pw::inArray('6',$config['content.type'])), ENT_QUOTES, 'UTF-8');?>><span>自定义验证问题</span></label></li>
					</ul>
					<div class="b mb5">验证问题与答案</div>
					<div class="cross">
						<ul id="J_ul_list_verify" class="J_ul_list_public">
<?php foreach($config['content.questions'] as $key => $value){ ?>
							<li>
								<span class="span_3"><input name="contentQuestions[<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>][ask]" type="text" class="input length_2" value="<?php echo htmlspecialchars($value['ask'], ENT_QUOTES, 'UTF-8');?>"></span>
								<span class="span_4"><input name="contentQuestions[<?php echo htmlspecialchars($key, ENT_QUOTES, 'UTF-8');?>][answer]" type="text" class="input  length_2 mr15" value="<?php echo htmlspecialchars($value['answer'], ENT_QUOTES, 'UTF-8');?>"><a href="" class="J_ul_list_remove">[删除]</a></span></li>
<?php  } ?>
						</ul>
					</div>
					<div class="group_list">
						<ul >
						
						</ul>
					</div>
					<div class="mb20"><a href="#" class="link_add J_ul_list_add" data-related="verify">添加验证问题</a></div>
					<div class="b mb5">显示验证问题答案</div>
					<ul class="switch_list cc">
						<li><label><input name="contentShowanswer"  value="1" type="radio"  <?php echo htmlspecialchars(Pw::ifcheck($config['content.showanswer']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="contentShowanswer"  value="0" type="radio"  <?php echo htmlspecialchars(Pw::ifcheck($config['content.showanswer']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td class="td_tips">
				<div style="margin-top:20px;">
					<p>自定义验证问题，系统将随机显示其一</p>
					<p>注：如果验证问题和答案里有中文，先要在src/repository/font目录中添加中文字体，文件名以cn_开头</p>
				</div></td>
			</tr>
			<tr>
				<th>语音验证码</th>
				<td>
					<ul class="switch_list cc">
						<li><label><input name="voice"  value="1" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['voice']==1), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
						<li><label><input name="voice"  value="0" type="radio" <?php echo htmlspecialchars(Pw::ifcheck($config['voice']==0), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
					</ul>
				</td>
				<td class="td_tips"><div>语音文件存放在src/repository/audio下,可以用自定义的语音文件替换。注:格式和命名需相同</div></td>
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
//添加验证问题html
var _li_html = '<li>\
					<span class="span_3"><input type="text" value="" class="input length_2" name="contentQuestions[new_][ask]"></span>\
					<span class="span_4">\
						<input type="text" value="" class="input length_2 mr15" name="contentQuestions[new_][answer]"><a class="J_ul_list_remove" href="#">[删除]</a>\
					</span>\
				</li>';
</script>
</body>
</html>