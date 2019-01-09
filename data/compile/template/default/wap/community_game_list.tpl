
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="<?php echo htmlspecialchars(Wekit::V('charset'), ENT_QUOTES, 'UTF-8');?>" />
<title><?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','title'), ENT_QUOTES, 'UTF-8');?></title>
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta name="generator" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','version'), ENT_QUOTES, 'UTF-8');?>" />
<meta name="description" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','description'), ENT_QUOTES, 'UTF-8');?>" />
<meta name="keywords" content="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','seo','keywords'), ENT_QUOTES, 'UTF-8');?>" />
<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/'.Wekit::C('site', 'theme.site.default').'/css'.Wekit::getGlobal('theme','debug'); ?>/core.css?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" />
<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/'.Wekit::C('site', 'theme.site.default').'/css'.Wekit::getGlobal('theme','debug'); ?>/style.css?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>" />
<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
<!-- <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community-common.js"></script> -->
<!-- <base id="headbase" href="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','base'), ENT_QUOTES, 'UTF-8');?>/" /> -->
<?php echo Wekit::C('site', 'css.tag');?>
<script>

//全局变量 Global Variables
var GV = {
	JS_ROOT : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','res'), ENT_QUOTES, 'UTF-8');?>/js/dev/',										//js目录
	JS_VERSION : '<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>',											//js版本号(不能带空格)
	JS_EXTRES : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','extres'), ENT_QUOTES, 'UTF-8');?>',
	TOKEN : '<?php echo htmlspecialchars(Wind::getComponent('windToken')->saveToken('csrf_token'), ENT_QUOTES, 'UTF-8');?>',	//token $.ajaxSetup data
	U_CENTER : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=space'; ?>',		//用户空间(参数 : uid)
<?php 
$loginUser = Wekit::getLoginUser();
if ($loginUser->isExists()) {
?>
	//登录后
	U_NAME : '<?php echo htmlspecialchars($loginUser->username, ENT_QUOTES, 'UTF-8');?>',										//登录用户名
	U_AVATAR : '<?php echo htmlspecialchars(Pw::getAvatar($loginUser->uid), ENT_QUOTES, 'UTF-8');?>',							//登录用户头像
<?php 
}
?>
	U_AVATAR_DEF : '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>/face/face_small.jpg',					//默认小头像
	U_ID : parseInt('<?php echo htmlspecialchars($loginUser->uid, ENT_QUOTES, 'UTF-8');?>'),									//uid
	REGION_CONFIG : '',														//地区数据
	CREDIT_REWARD_JUDGE : '<?php echo $loginUser->showCreditNotice();?>',			//是否积分奖励，空值:false, 1:true
	URL : {
		LOGIN : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login'; ?>',										//登录地址
		QUICK_LOGIN : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login&a=fast'; ?>',								//快速登录
		IMAGE_RES: '<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','images'), ENT_QUOTES, 'UTF-8');?>',										//图片目录
		CHECK_IMG : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&c=login&a=showverify'; ?>',							//验证码图片url，global.js引用
		VARIFY : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=verify&a=get'; ?>',									//验证码html
		VARIFY_CHECK : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=verify&a=check'; ?>',							//验证码html
		HEAD_MSG : {
			LIST : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=message&c=notice&a=minilist'; ?>'							//头部消息_列表
		},
		USER_CARD : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=space&c=card'; ?>',								//小名片(参数 : uid)
		LIKE_FORWARDING : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=post&a=doreply'; ?>',							//喜欢转发(参数 : fid)
		REGION : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=area'; ?>',									//地区数据
		SCHOOL : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=misc&c=webData&a=school'; ?>',								//学校数据
		EMOTIONS : "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=emotion&type=bbs'; ?>",					//表情数据
		CRON_AJAX : '<?php echo htmlspecialchars($runCron, ENT_QUOTES, 'UTF-8');?>',											//计划任务 后端输出执行
		FORUM_LIST : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=forum&a=list'; ?>',								//版块列表数据
		CREDIT_REWARD_DATA : '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?m=u&a=showcredit'; ?>',					//积分奖励 数据
		AT_URL: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=remind'; ?>',									//@好友列表接口
		TOPIC_TYPIC: '<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/','index.php?c=forum&a=topictype'; ?>'							//主题分类
	}
};
</script>
<script src="<?php echo htmlspecialchars(Wind::getComponent('response')->getData('G','url','js'), ENT_QUOTES, 'UTF-8');?>/wind.js?v=<?php echo htmlspecialchars(NEXT_RELEASE, ENT_QUOTES, 'UTF-8');?>"></script>
<script type="text/javascript">
var site_img = '<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>';
</script>
<!-- 百度统计 -->
<script>
	var _hmt = _hmt || [];
	(function() {
	  var hm = document.createElement("script");
	  hm.src = "https://hm.baidu.com/hm.js?8329b6ac5dc3bcb8cbb72f544f368e37";
	  var s = document.getElementsByTagName("script")[0]; 
	  s.parentNode.insertBefore(hm, s);
	})();
</script>
<!-- 站长统计 -->
<script>
	(function(){
	    var bp = document.createElement('script');
	    var curProtocol = window.location.protocol.split(':')[0];
	    if (curProtocol === 'https') {
	        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
	    }
	    else {
	        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
	    }
	    var s = document.getElementsByTagName("script")[0];
	    s.parentNode.insertBefore(bp, s);
	})();
</script>
<meta name="baidu-site-verification" content="iMDIf2wt7e" />
<?php
PwHook::display(array(PwSimpleHook::getInstance("head"), "runDo"), array(), "", $__viewer);
?>
        
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
		<meta name="format-detection" content="telephone=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="default">
		<link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/base.css"/>
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css">
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
		<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
		<style>

/* 2017-09-12 */
.rank_list li{
    padding: 10px 10px 10px 0;
}
 
.rank_list .title{
        width: 120%;
        font-weight: 700;
}
.section_head{
    position: relative;
    height: 42px;
}
.section_title{
    position:absolute;
    left: 0px;
    top: 6px;
    line-height: 28px;
    font-size: 21px;
    font-weight: 400;
    border-left: 4px solid #1ea4f2;
    padding-left: 10px;
    font-size: 18px;
}
.rank_list .desc{
    line-height: 25px;
    margin-top: 3px;
    overflow:hidden;
    text-overflow: ellipsis;
    display:-webkit-box;
    -webkit-line-clamp:2;
    -webkit-box-orient:vertical;
        font-size: 14px;
        color:#949494;
}
.icon_box img{
    width:20px;
    background-size:100%;
    background-repeat:no-repeat;
}
 .icon_box{
   margin-left: 5px;
margin-right: 15px;
text-align: center;
width: 20px;
}
.top_icon{
    width: 20px;
    height: 25px;
    background-size: 100%;
    background-repeat: no-repeat;
    display: inline-block;
}
.top1{
    background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/top1.png);
}
.top2{
    background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/top2.png);
}
.top3{
    background-image:url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/top3.png);
}
.top_num{
    font-size: 20px;
    width: 20px;
}
		
.rank_list .title {
    font-size: 18px;
    line-height: 20px;
    color: #333333;
    margin-bottom: 5px;
}
.rank_list .icon {
    width: 70px;
    height: 70px;
    display: block;
}
.rank_list li {
    border-top: 1px solid #e5e5e5;
    position: relative;
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    -ms-flex-align: center;
    align-items: center;
}
.section {
    margin-bottom: 10px;
    background-color: #fff;
        padding: 0 10px;
}
.game-list h1,.game-list p{text-align:left;}
		</style>
    </head>
    <body>
    <div class="all_content">
        <div class="q_layout">
            <?php  foreach ($cateList as $_cateId => $_cate) { 
                //关注板块
                if($_cate['vieworder'] == 2 && count($my_forumList) > 0){ ?>
                <div class="section my_favourite">
                    <div class="section_head">
                        <h2 class="section_title"><?php echo $_cate['name'];?></h2>
                    </div>
                        <ul class="rank_list rank_list--4">
                        <?php  foreach ($my_forumList as $_id => $_item){ ?>
                            <li style="width: 100%">
                                <div class="icon_box">
                                    <img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/shoucang.png" alt="">
                                </div>

                                <div class="game-list" style="width: 100%;" onclick="jump_to_area(<?php echo $_item['fid'];?>)">
                                    <div class="lf" onclick=""><img class="icon" src="<?php echo htmlspecialchars(Pw::getPath($_item['icon']), ENT_QUOTES, 'UTF-8');?>" alt=""></div>
                                    <div class="lf" style="padding:3px 0 0 8px;width: 66%">
                                        <h1 class="title"><?php echo $_item['name'];?></h1>
                                        <p class="">关注：<span><?php echo htmlspecialchars($_item['isIn'], ENT_QUOTES, 'UTF-8');?></span></p>
                                        <p class="">话题：<span><?php echo htmlspecialchars($_item['threads'], ENT_QUOTES, 'UTF-8');?></span></p>
                                        <!-- <p class="desc"><?php echo $_item['descrip'];?></p> -->
                                    </div>
                                   
                                </div>
                                 <div class=""  style="float: right;padding-right: 5px;" onclick="jump_to_area(<?php echo $_item['fid'];?>)">
                                    <div style="float: right;"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/arrow.png" alt=""></div>
                                </div>
                            </li>
                        <?php  }?>
                        </ul>
                    </div>
                </div>
                <?php  } else if($_cate['vieworder'] != 2){ ?>
                <div class="section my_favourite">
                    <div class="section_head">
                        <h2 class="section_title"><?php echo $_cate['name'];?></h2>
                    </div>
                        <ul class="rank_list rank_list--4">
                        <?php  
                        $i = 0;
                        foreach ($forumList[$_cateId] as $_id => $_item){
                            if($_item['parentid'] == $_cate['fid']){
                        ?>
                            <li style="width: 100%">
                                <div class="icon_box">
                                    <?php  
                                        if($_cate['vieworder'] == 3){
                                            if($i == 0){
                                                ?><div class="top_icon top1"></div><?php 
                                            }else if($i == 1){
                                                ?><div class="top_icon top2"></div><?php 
                                            }else if($i == 2){
                                                ?><div class="top_icon top3"></div><?php 
                                            }
                                            else{
                                                ?><div class="top_num"><?php  echo $i+1; ?></div><?php 
                                            }
                                            $i++;
                                        }
                                        else{
                                            ?><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/shoucang.png" alt=""><?php 
                                        }
                                    ?>
                                </div>

                                <div class="game-list" style="width: 100%;" onclick="jump_to_area(<?php echo $_item['fid'];?>)">
                                    <div class="lf" onclick=""><img class="icon" src="<?php echo htmlspecialchars(Pw::getPath($_item['icon']), ENT_QUOTES, 'UTF-8');?>" alt=""></div>
                                    <div class="lf" style="padding:3px 0 0 8px;width: 66%">
                                        <h1 class="title"><?php echo $_item['name'];?></h1>
                                        <p class="">关注：<span><?php echo htmlspecialchars($_item['isIn'], ENT_QUOTES, 'UTF-8');?></span></p>
                                        <p class="">话题：<span><?php echo htmlspecialchars($_item['threads'], ENT_QUOTES, 'UTF-8');?></span></p>
                                        <!-- <p class="desc"><?php echo $_item['descrip'];?></p> -->
                                    </div>
                                   
                                </div>
                                 <div class=""  style="float: right;padding-right: 5px;" onclick="jump_to_area(<?php echo $_item['fid'];?>)">
                                    <div style="float: right;"><img src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/arrow.png" alt=""></div>
                                </div>
                            </li>
                            <?php  } 
                        } ?>
                        </ul>
                    </div>
            <?php  }
            } ?>
            </div>
        </div>
        <div class="nav_placeholder"></div> 
    </div>
    <script>
    	/**
         * 版块跳转
         * @param  {[Int]} fid [版块id]
         */
        function jump_to_area(fid) {
            location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>" + 'index.php?m=wap&c=OneGame&fid=' + fid;
        }

    </script>
    </body>
</html>