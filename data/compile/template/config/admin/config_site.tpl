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
		<li><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=config'; ?>">站点信息</a></li>
		<li  class="current"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=config&a=site'; ?>">全局参数</a></li>
	</ul>
</div>

<form method="post" class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=config&a=dosite'; ?>">
<div class="h_a">全局参数设置</div>
<div class="table_full">
	<table width="100%">
		<col class="th" />
		<col width="400" />
		<col />	
		<tr>
			<th>默认时区</th>
			<td>
				<?php $__tpl_data = array('name' => 'timeTimezone' , 'value' => $config['time.timezone']); ?>
<!-- 数据格式定义：$__tpl_data = array('name' => '' , 'value' => '')  -->
<!-- name:select名称,默认值为timezone；value:select当前值,默认值为8  -->
<?php  isset($__tpl_data['name']) || $__tpl_data['name'] = 'timezone';  
isset($__tpl_data['value']) || $__tpl_data['value'] = '8';  ?>
<select class="select_5" name="<?php echo $__tpl_data['name'];?>">
<option value="-12" <?php echo Pw::isSelected($__tpl_data['value'] == '-12');?>>(标准时-12:00) 日界线西</option>
<option value="-11" <?php echo Pw::isSelected($__tpl_data['value'] == '-11');?>>(标准时-11:00) 中途岛、萨摩亚群岛</option>
<option value="-10" <?php echo Pw::isSelected($__tpl_data['value'] == '-10');?>>(标准时-10:00) 夏威夷</option>
<option value="-9" <?php echo Pw::isSelected($__tpl_data['value'] == '-9');?>>(标准时-9:00) 阿拉斯加</option>
<option value="-8" <?php echo Pw::isSelected($__tpl_data['value'] == '-8');?>>(标准时-8:00) 太平洋时间(美国和加拿大)</option>
<option value="-7" <?php echo Pw::isSelected($__tpl_data['value'] == '-7');?>>(标准时-7:00) 山地时间(美国和加拿大)</option>
<option value="-6" <?php echo Pw::isSelected($__tpl_data['value'] == '-6');?>>(标准时-6:00) 中部时间(美国和加拿大)、墨西哥城</option>
<option value="-5" <?php echo Pw::isSelected($__tpl_data['value'] == '-5');?>>(标准时-5:00) 东部时间(美国和加拿大)、波哥大</option>
<option value="-4" <?php echo Pw::isSelected($__tpl_data['value'] == '-4');?>>(标准时-4:00) 大西洋时间(加拿大)、加拉加斯</option>
<option value="-3.5" <?php echo Pw::isSelected($__tpl_data['value'] == '-3.5');?>>(标准时-3:30) 纽芬兰</option>
<option value="-3" <?php echo Pw::isSelected($__tpl_data['value'] == '-3');?>>(标准时-3:00) 巴西、布宜诺斯艾利斯、乔治敦</option>
<option value="-2" <?php echo Pw::isSelected($__tpl_data['value'] == '-2');?>>(标准时-2:00) 中大西洋</option>
<option value="-1" <?php echo Pw::isSelected($__tpl_data['value'] == '-1');?>>(标准时-1:00) 亚速尔群岛、佛得角群岛</option>
<option value="0" <?php echo Pw::isSelected($__tpl_data['value'] == '0');?>>(格林尼治标准时) 西欧时间、伦敦、卡萨布兰卡</option>
<option value="1" <?php echo Pw::isSelected($__tpl_data['value'] == '1');?>>(标准时+1:00) 中欧时间、安哥拉、利比亚</option>
<option value="2" <?php echo Pw::isSelected($__tpl_data['value'] == '2');?>>(标准时+2:00) 东欧时间、开罗，雅典</option>
<option value="3" <?php echo Pw::isSelected($__tpl_data['value'] == '3');?>>(标准时+3:00) 巴格达、科威特、莫斯科</option>
<option value="3.5" <?php echo Pw::isSelected($__tpl_data['value'] == '3.5');?>>(标准时+3:30) 德黑兰</option>
<option value="4" <?php echo Pw::isSelected($__tpl_data['value'] == '4');?>>(标准时+4:00) 阿布扎比、马斯喀特、巴库</option>
<option value="4.5" <?php echo Pw::isSelected($__tpl_data['value'] == '4.5');?>>(标准时+4:30) 喀布尔</option>
<option value="5" <?php echo Pw::isSelected($__tpl_data['value'] == '5');?>>(标准时+5:00) 叶卡捷琳堡、伊斯兰堡、卡拉奇</option>
<option value="5.5" <?php echo Pw::isSelected($__tpl_data['value'] == '5.5');?>>(标准时+5:30) 孟买、加尔各答、新德里</option>
<option value="6" <?php echo Pw::isSelected($__tpl_data['value'] == '6');?>>(标准时+6:00) 阿拉木图、 达卡、新亚伯利亚</option>
<option value="7" <?php echo Pw::isSelected($__tpl_data['value'] == '7');?>>(标准时+7:00) 曼谷、河内、雅加达</option>
<option value="8" <?php echo Pw::isSelected($__tpl_data['value'] == '8');?>>(北京时间) 北京、重庆、香港、新加坡</option>
<option value="9" <?php echo Pw::isSelected($__tpl_data['value'] == '9');?>>(标准时+9:00) 东京、汉城、大阪、雅库茨克</option>
<option value="9.5" <?php echo Pw::isSelected($__tpl_data['value'] == '9.5');?>>(标准时+9:30) 阿德莱德、达尔文</option>
<option value="10" <?php echo Pw::isSelected($__tpl_data['value'] == '10');?>>(标准时+10:00) 悉尼、关岛</option>
<option value="11" <?php echo Pw::isSelected($__tpl_data['value'] == '11');?>>(标准时+11:00) 马加丹、索罗门群岛</option>
<option value="12" <?php echo Pw::isSelected($__tpl_data['value'] == '12');?>>(标准时+12:00) 奥克兰、惠灵顿、堪察加半岛</option>
</select><?php  ?>
			</td>
			<td><div class="fun_tips">系统默认时间显示。会员可在前台设置中心进行调整</div></td>
		</tr>
		<tr>
			<th>服务器时间校正</th>
			<td>
				<input name="timeCv" type="number" class="input length_5 mr5" value="<?php echo htmlspecialchars($config['time.cv'], ENT_QUOTES, 'UTF-8');?>">分钟
			</td>
			<td><div class="fun_tips">如果站点显示时间与服务器时间有差异，可用此功能进行微调</div></td>
		</tr>
		<tr>
			<th>刷新页面时间间隔</th>
			<td>
				<input name="refreshtime" type="number" class="input length_5 mr5" value="<?php echo htmlspecialchars($config['refreshtime'], ENT_QUOTES, 'UTF-8');?>">秒
			</td>
			<td><div class="fun_tips">用户将无法在设定的时间内重复刷新页面。可有效防止用户恶意刷新。0或留空表示不限制</div></td>
		</tr>
		<tr>
			<th>在线用户时限</th>
			<td>
				<input name="onlinetime" type="number" class="input length_5 mr5" value="<?php echo htmlspecialchars($config['onlinetime'], ENT_QUOTES, 'UTF-8');?>">分钟
			</td>
			<td class="td_tips"><div>在设定时间范围内，如果会员没有对站点进行任何操作，则会员的在线状态会变为离线状态</div></td>
		</tr>
		<tr>
			<th>DEBUG 模式运行站点</th>
			<td>
				<input name="debug" type="number" class="input length_5 mr5" value="<?php echo htmlspecialchars($config['debug'], ENT_QUOTES, 'UTF-8');?>">
				<!-- <ul class="switch_list cc">
					<li><label><input name="debug" type="radio" value="1"<?php echo htmlspecialchars(Pw::ifcheck($config['debug']), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
					<li><label><input name="debug" type="radio" value="0"<?php echo htmlspecialchars(Pw::ifcheck(!$config['debug']), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
				</ul> -->
			</td>
			<td><div class="fun_tips">0：否、1：是（DEBUG）。当站点运行出现错误或异常时，建议开启DEBUG模式，以显示程序错误报告信息。并及时将错误信息反馈给程序开发商，以便尽快得到解决</div></td>
		</tr>
		<tr>
			<th>备选管理操作原因</th>
			<td>
				<textarea class="length_5" name="managereasons"><?php echo htmlspecialchars($config['managereasons'], ENT_QUOTES, 'UTF-8');?></textarea>
			</td>
			<td><div class="fun_tips">前台管理操作的默认备选原因<br>每行填写一个操作原因，分隔符“------”表示空行</div></td>
		</tr>
		<tr>
			<th>Cookie 路径</th>
			<td>
				<input name="cookiePath" type="text" class="input length_5" value="<?php echo htmlspecialchars($config['cookie.path'], ENT_QUOTES, 'UTF-8');?>">
			</td>
			<td><div class="fun_tips">默认为“/”。如果您在同一个域名下运行了多个站点，便需要将它设置为每个站点所在的目录名以防冲突。如“/bbs/”、“/forum/”。<br /><span class="red">注意:只有在特殊情况下才需要进行此设置，若您不能肯定，请填写“/”，输入错误的设置会导致站点无法正常登录</span></div></td>
		</tr>
		<tr>
			<th>Cookie 作用域</th>
			<td>
				<input name="cookieDomain" type="text" class="input length_5" value="<?php echo htmlspecialchars($config['cookie.domain'], ENT_QUOTES, 'UTF-8');?>">
			</td>
			<td><div class="fun_tips">默认为空。如果您的站点有两个不同的网址，如“phpwind.net”、“bbs.phpwind.net”，要使用户在两个不同的域名访问下，仍能保持登录状态，您需要在设置为“.phpwind.net” (注意域名需要以点开头)。<br /><span class="red">注意:只有在特殊情况下才需要进行此设置，若您不能肯定，请留空，输入错误的设置会导致站点无法正常登录</span></div></td>
		</tr>
		<tr>
			<th>Cookie 前缀</th>
			<td>
				<input name="cookiePre" type="text" class="input length_5" value="<?php echo htmlspecialchars($config['cookie.pre'], ENT_QUOTES, 'UTF-8');?>">
			</td>
			<td><div class="fun_tips">如果您的站点有两个不同的网址，如“phpwind.net”、“bbs.phpwind.net”，需要分别设置各个的前缀，防止cookie混乱。<br /></div></td>
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
</body>
</html>