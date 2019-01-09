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
	<?php foreach($tabs as $alias => $tab){?>
		<li class="<?php echo htmlspecialchars($tab['current'], ENT_QUOTES, 'UTF-8');?>"><a href="<?php echo htmlspecialchars(WindUrlHelper::createUrl($tab['url']), ENT_QUOTES, 'UTF-8');?>"><?php echo htmlspecialchars($tab['title'], ENT_QUOTES, 'UTF-8');?></a></li>
	<?php  } ?>
	</ul>
</div>
<div class="h_a">功能说明</div>
<div class="prompt_text">
SEO信息中可以直接输入文字，也可以使用代码。
<p>可以使用的代码包括：</p>
<ol>
<li>全站名称:{sitename}（应用范围：所有位置）</li>
<li>版块名称:{forumname}（应用范围：帖子列表页和帖子阅读页）</li>
<li>版块简介:{forumdescription}（应用范围：帖子列表页）</li>
<li>帖子主题分类名称:{classification}（应用范围：帖子列表页）</li>
<li>帖子标题:{title}（应用范围：帖子阅读页）</li>
<li>帖子摘要:{description}（应用范围：帖子阅读页）</li>
<li>tag名称:{tags}（应用范围：帖子阅读页）</li>
<li>翻页:{page}（应用范围：所有有翻页功能页面）</li>
</ol>

以上标签（必须包含大括号"{}"）可以通过添加在下面来优化页面SEO设置，多个标签之间可以用半角连字符"-"、半角","或半角空格隔开。留空为默认SEO设置

</div>
<form action="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','admin.php?mod=bbs&m=seo&c=manage&a=doRun'; ?>" method="post" class="J_ajaxForm">
<?php foreach($pages as $alias => $title){ ?>
<div class="h_a"><?php if($alias == 'thread'){ ?><span class="away_icon mr5 J_toggle_row" title="展开全部版块"></span><?php  } 
 echo htmlspecialchars($title, ENT_QUOTES, 'UTF-8');?>
</div>

	<div class="table_full">
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>title [标题]</th>
				<td>
					<input data-id="<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>" name="seo[<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>][0][title]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo[$alias][0]['title'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>description [描述]</th>
				<td>
					<input data-id="<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>" name="seo[<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>][0][description]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo[$alias][0]['description'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>keywords [关键字]</th>
				<td>
					<input data-id="<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>" name="seo[<?php echo htmlspecialchars($alias, ENT_QUOTES, 'UTF-8');?>][0][keywords]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo[$alias][0]['keywords'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>
	<div class="J_child_wrap" style="display: none;">
	<?php if($alias == 'thread') { ?>
	<!--展开后的具体版块页 start-->
	<?php $type = array('forum' => '60px', 'sub' => '90px', 'sub2' => '120px');
 foreach($cateList as $cate) { ?>
	<div class="table_full" style="padding-left:30px;">
		<div class="h_a">&raquo; <?php echo htmlspecialchars(strip_tags($cate['name']), ENT_QUOTES, 'UTF-8');?></div>
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>title [标题]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($cate['fid'], ENT_QUOTES, 'UTF-8');?>][title]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$cate['fid']]['title'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>description [描述]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($cate['fid'], ENT_QUOTES, 'UTF-8');?>][description]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$cate['fid']]['description'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>keywords [关键字]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($cate['fid'], ENT_QUOTES, 'UTF-8');?>][keywords]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$cate['fid']]['keywords'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
		</div>
	<?php foreach($forumList[$cate['fid']] as $forum) { ?>
	<div class="table_full" style="padding-left:<?php echo htmlspecialchars($type[$forum['type']], ENT_QUOTES, 'UTF-8');?>;">
		<div class="h_a">&raquo; <?php echo htmlspecialchars(strip_tags($forum['name']), ENT_QUOTES, 'UTF-8');?></div>
		<table width="100%">
			<col class="th" />
			<col width="400" />
			<col />
			<tr>
				<th>title [标题]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($forum['fid'], ENT_QUOTES, 'UTF-8');?>][title]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$forum['fid']]['title'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>description [描述]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($forum['fid'], ENT_QUOTES, 'UTF-8');?>][description]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$forum['fid']]['description'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
			<tr>
				<th>keywords [关键字]</th>
				<td>
					<input data-id="thread" name="seo[thread][<?php echo htmlspecialchars($forum['fid'], ENT_QUOTES, 'UTF-8');?>][keywords]" type="text" class="input length_5 J_seo_input" value="<?php echo htmlspecialchars($seo['thread'][$forum['fid']]['keywords'], ENT_QUOTES, 'UTF-8');?>">
				</td>
				<td><div class="fun_tips"></div></td>
			</tr>
		</table>
	</div>
	<?php  } } } ?>
</div>
	<!--展开后的具体版块页 end-->

	<?php  } ?>
	
<div class="btn_wrap">
	<div class="btn_wrap_pd">
		<button class="btn btn_submit mr10 J_ajax_submit_btn" type="submit">提交</button>
	</div>
</div>
<input type="hidden" name="csrf_token" value="<?php echo WindSecurity::escapeHTML(Wind::getComponent('windToken')->saveToken('csrf_token')); ?>"/></form>

</div>
<div class="pop_seo" id="J_pop_seo" style="display:none">
	<div class="hd">
		<a href="#" class="close J_pop_close">关闭</a>
			<strong>可以使用的代码（点击插入）：</strong>
		</div>
	<div class="ct" id="J_seo_code"></div>
</div>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/pages/admin/common/common.js?v<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script type="text/javascript">
$(function(){
	//展开显示
	$('span.J_toggle_row').on('click', function(){
		var $this = $(this),
			list = $this.parent().nextAll('.J_child_wrap').filter(':first');

		if($this.hasClass('start_icon')) {
			list.hide();
			$this.removeClass('start_icon').addClass('away_icon');
		}else{
			list.show();
			$this.removeClass('away_icon').addClass('start_icon');
		}
	});
	
	//代码提示
	var SEO_CODE = <?php echo WindSecurity::escapeEncodeJson($codes, 'UTF-8');?>,
		pop_seo = $('#J_pop_seo'),
		timer;
	
	$('input.J_seo_input').on('focus', function(){
		//聚焦
		var $this = $(this),
			id = $this.data('id');
		
		//先撤销原有的id
		$('#J_focus_input').removeAttr('id');
		$this.attr('id', 'J_focus_input');
		
		if(timer) {
			clearTimeout(timer);
			pop_seo.hide();
		}
		
		try{
			var seo_arr = [];
			$.each(SEO_CODE[id], function(i, o){
				seo_arr.push('<a class="J_insert_input" href="#">'+ o +'</a>');
			});

			if(!seo_arr.length) {
				return false;
			}

			$('#J_seo_code').html(seo_arr.join(''));

			//显示窗口并定位
			pop_seo.show().css({
				left : $this.offset().left + $this.outerWidth(),
				top : $this.offset().top - pop_seo.outerHeight() + $this.outerHeight()
			});

		}catch(err){
			pop_seo.hide();
		}
		
		
	}).on('blur', function(){
		//失焦
		var $this = $(this);
		timer = setTimeout(function(){
			pop_seo.hide();
			
		}, 150);
	});
	
	//点击关闭
	pop_seo.on('click', 'a.J_pop_close', function(e){
		e.preventDefault();
		pop_seo.hide();
	});
	
	//点击代码
	pop_seo.on('click', 'a.J_insert_input', function(e){
		e.preventDefault();
		clearTimeout(timer);
		
		var input = $('#J_focus_input'),
			v = input.val() +' '+ $(this).text();
			
		input.val(v).focus();
	});
	
	//点击弹窗区域
	pop_seo.on('click', function(){
		clearTimeout(timer);
	});

});
</script>
</body>
</html>