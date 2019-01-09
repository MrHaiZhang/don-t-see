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
    <ul class="cc">
		<li <?php echo $typeClasses['qq'];?>><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?type=qq&m=config&c=ThirdOpenPlatform'; ?>">QQ</a></li>
		<li <?php echo $typeClasses['weibo'];?>><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?type=weibo&m=config&c=ThirdOpenPlatform'; ?>">新浪微博</a></li>
	</ul>
</div>
	<div class="h_a">功能说明</div>
	<div class="prompt_text">
		<ul>
			<li>此功能为设置PC网站的第三方（QQ，微博）账户登录使用的AppId和AppKey，
            这里的AppId和AppKey与移动端有可能不一样，所以需要单独设置。</li>
			<li>设置后，在移动APP端使用了第三方账户方式登陆的用户，在您的PC网站也可以使用相同的第三方账户登录。</li>
		</ul>
	</div>
<form class="J_ajaxForm" action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?m=config&c=ThirdOpenPlatform&a=doset'; ?>" method="post">
<input type="hidden" name="type" value="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>" />
<div class="table_full">
	<table width="100%">
		<col width="th" />
		<col width="400"/>
		<col />
		
		<tr>
		<th>开启绑定</th>
		<td>
			<ul class="switch_list cc">
                <li><label><input type="radio" name="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>_status" value="1" <?php echo htmlspecialchars(Pw::ifcheck($info['status']), ENT_QUOTES, 'UTF-8');?>><span>开启</span></label></li>
                <li><label><input type="radio" name="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>_status" value="0" <?php echo htmlspecialchars(Pw::ifcheck(!$info['status']), ENT_QUOTES, 'UTF-8');?>><span>关闭</span></label></li>
			</ul>
		</td>
		<td><div class="fun_tips"></div></td>
		</tr>
		<tr>
            <th><?php echo htmlspecialchars($lab['AppId'], ENT_QUOTES, 'UTF-8');?></th>
		<td>
            <input type="text" class="input length_5 mr5" name="<?php echo htmlspecialchars($type.'_appId', ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($info['appId'], ENT_QUOTES, 'UTF-8');?>">
		</td>
        <td><div class="fun_tips">
                <?php  
                $link = '';
                switch($type){
                case 'taobao':
                $link = 'http://open.taobao.com';
                break;
                case 'qq':
                $link = 'http://connect.qq.com';
                break;
                case 'weibo':
                $link = 'http://open.weibo.com';
                break;
                case 'weixin':
                $link = 'http://open.weixin.qq.com';
                break;
                }
                echo '申请地址：<a href="'.$link.'" target="_blank">'.$link.'</a>，注意是申请网站接入。<br />';
                echo '回调地址请填写：'.$redirecturl;
                ?>
            </div>
        </td>
		</tr>
		<tr>
		<th><?php echo htmlspecialchars($lab['AppKey'], ENT_QUOTES, 'UTF-8');?></th>
		<td>
            <input type="text" class="input length_5 mr5" name="<?php echo htmlspecialchars($type.'_appKey', ENT_QUOTES, 'UTF-8');?>" value="<?php echo htmlspecialchars($info['appKey'], ENT_QUOTES, 'UTF-8');?>">
		</td>
		</tr>
	
        <!-- 显示顺序 -->
        <input type="hidden" class="input length_5 mr5" name="<?php echo htmlspecialchars($type, ENT_QUOTES, 'UTF-8');?>_displayOrder" value="<?php echo htmlspecialchars($info['displayOrder'], ENT_QUOTES, 'UTF-8');?>">
	</table>
</div>
<div class="btn_wrap">
	<div class="btn_wrap_pd" id="J_sub_wrap">
   <button type="submit" class="btn btn_submit J_ajax_submit_btn">提交</button>
	</div>
</div>
<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>

</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
</body>
</html>
