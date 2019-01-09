<!DOCTYPE html>
<html lang="en">
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
        <link rel="stylesheet" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/css'.Wekit::getGlobal('theme','debug'); ?>/community.css?2">
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.event.drag-1.5.min.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.touchSlider.js"></script>
        <script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/common.js"></script>
        <style>
        div{ text-align: left; font-size: 16px; }
        .section{padding: 0 14px;}
        .bottom-nav{position:fixed; z-index: 99; text-align: center;}
        .first-section{position:fixed; width: 100%; z-index: 99;}
        .back-community{border-radius: 5px;color: #1ea4f2; display: inline-block;font-size: 10pt;padding: 3px 10px; margin-top: 25px;background-color: #fff;border: 1px solid #1ea4f2;font-weight: 700;float: right;}
        .game-name{font-weight: 700;color:#333;float: left;font-size:18px;    padding-left:10px;margin-top: 24px;}
        .gamelist{    height: 82px;padding:14px 0;}
        .gamelist .header-icon-body{width: 55px;height: 55px;}
        .game-name{    margin-top: 14px;}
        .back-community{    margin-top: 15px;}

       
        
        .post-head{border-bottom: 1px solid #e5e5e5;}
        
       
        .discuss-box{padding-top: 10px;padding-bottom: 10px;} 
        .discuss-box div{display:inline-block;    color: #949494;}
        .discuss-box .read-num{margin-right:10px;}
        .post-con{padding:10px 0;padding-bottom:0;}
        .post-con *{font-size:inherit;}
        .post-text,.post-text p{text-align:left;}
        .post-img img{width:100%;}

        .post-msg{text-align:left;line-height: 30px;    color: #949494;}
        .post-num{display: inline-block;    padding-bottom: 10px;}
        .post-msg .like-num{float: right;    line-height: 30px;}
        .post-msg .like-num span{height: 30px;}
        .like-num span{background-image: url(<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/zan.png);float: left;
            width: 20px;
            height: 20px;
            background-size: 100%;
            background-repeat: no-repeat;
            background-position: center;}

        .q_box_header {
            position: relative;
            height: 37px;
           /*  border-bottom: 2px solid #1ea4f2; */
            line-height: 23px;
        }

        .hot-post{}
        .hot-post li{text-align:left;font-size: 14px; color:#999;   line-height: 38px;    border-top: 1px solid #e5e5e5;}
        .hot-discuss>li{border-top: 1px solid #e5e5e5;/* padding: 10px 0; */padding: 10px 0 0 0;}
        .discuss-user{display:flex;justify-content: space-between;line-height: 37px;}
        .discuss-user .user-name{font-size: 18px;font-weight: 700;}
        .discuss-user .user-floor{font-size: 14px;}
        .discuss-con{margin-left: 60px;}
        .discuss-discuss{background-color:rgb(238,238,238);padding:5px 10px;}
        .discuss-discuss li{text-align:left;}
        .discuss-discuss li span{font-size: inherit;}
        .discuss-img{  width:30%;  display: inline-block; overflow: hidden;  box-sizing: content-box;  position: relative;margin:5px 0}
        .discuss-img img{width:100%;  position: relative;  left:0;  top:50%;  -webkit-transform: translateY(-50%);  -moz-transform: translateY(-50%);  transform: translateY(-50%);}
        .discuss-img:nth-child(2),.discuss-img:nth-child(3){  margin-left: 5%;}
        .post-text img{max-width: 100% !important;}
        
        .nocontent{ padding: 10px; }
        .uncontent{ padding: 10px; background-color: #f2f2f2; }
        .stepping{ height: 44px; }

       /* .user-head-box{display: flex;justify-content: space-between;}
        .user-des .name{text-align: left;}*/
       
       .load-more{ line-height: 25px; text-align: center; display: none; }
       .more-replies{ color: #1ea4f2; }

        .btnImgClose{position: absolute;left:20px;top:10px;border:1px solid #fff;color:#fff;font-size:20px;
            border-radius: 50%;width:30px;height:30px;text-align: center;line-height:30px;}
        .btnNarrow,.btnEnlarge{position: absolute;right:20px;top:10px;padding:3px 15px;line-height:1;font-size:20px;
            text-align: center; font-weight: bold;background: none;outline: 0;border:1px solid #fff;color:#fff}
        .btnNarrow{right:75px;}
        </style>
    </head>
    <body id="community_game_post">
    <div class="bottom-nav">
        <div class="back-icon">
        <?php  if($readdb[0]['lou'] == 0 && $readdb[0]['notice']){ ?>
            <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($prev_fid, ENT_QUOTES, 'UTF-8');?>&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"></a>
        <?php  } else{ ?>
            <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"></a>
        <?php  } ?>
        </div>
        <div class="publish">
            <?php  if($threadInfo['type'] == 0){  ?>
                <a href="javascript:void(0);" onClick="toNewPost(<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>)">发布评论</a>
            <?php  } else if($threadInfo['activity_param']['stop'] == 1){  ?>
                <a href="javascript:void(0);" class="unpublish">活动已结束</a>
            <?php  } else if($threadInfo['activity_param']['activity_type'] == 0 && $threadInfo['activity_param']['activity_return_num'] != 0 && $user_reply_num >= $threadInfo['activity_param']['activity_return_num']){  ?>
                <a href="javascript:void(0);" class="unpublish">谢谢参与</a>
            <?php  } else if($threadInfo['activity_param']['activity_type'] == 0){  ?>
                <a href="javascript:void(0);" onClick="toNewPost(<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>)">立即发帖参与活动</a>
            <?php  } else if($threadInfo['activity_param']['activity_type'] == 2 && $threadInfo['activity_param']['activity_url'] == ''){  ?>
                <a href="javascript:void(0);" class="unpublish">该帖子不需评论哦</a>
            <?php  } else if($threadInfo['activity_param']['activity_type'] == 2 && $threadInfo['activity_param']['activity_url'] != ''){  ?>
                <a href="javascript:void(0);" onClick="location.href='<?php echo htmlspecialchars($threadInfo['activity_param']['activity_url'], ENT_QUOTES, 'UTF-8');?>'">前往参与活动</a>
            <?php  } else{  ?>
                <a href="javascript:void(0);" onClick="toNewthread('<?php echo htmlspecialchars($threadInfo['activity_param']['activity_prefix'], ENT_QUOTES, 'UTF-8');?>')">立即发帖参与活动</a>
            <?php  } ?>
        </div>
        <?php  if($seachLike == 'inlike'){  ?>
            <div class="like-btn liked" onClick="addLike(1, <?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, this, false)"><a href="javascript:void(0);"></a></div>
        <?php  } else if($seachLike == 'mylike'){  ?>
            <div class="like-btn"><a href="javascript:void(0);"></a></div>
        <?php  } else{ ?>
            <div class="like-btn addlike_t1" onClick="addLike(1, <?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, this, false)"><a href="javascript:void(0);"></a></div>
        <?php  } ?>
    </div>
    <div class="first-section section">
        <div class="gamelist">
            <div class="game_community_title">
                <div class="header-icon-body">
                  <img src="<?php echo htmlspecialchars(Pw::getPath($pwforum->foruminfo['icon']), ENT_QUOTES, 'UTF-8');?>" id="icon_id" alt="" title="">
                  <input type="hidden" value="3" id="game_id">
                </div>
                <h1 class="game-name"><?php echo $pwforum->foruminfo['name'];?></h1>
                <div class="download_btn">
                    <?php  if($pwforum->foruminfo['fid'] == 2){ ?>
                        <a class="back-community" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php">回到社区</a>
                    <?php  } else{ ?>
                        <a class="back-community" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($pwforum->foruminfo['fid'], ENT_QUOTES, 'UTF-8');?>">回到社区</a>
                    <?php  } ?>
                </div>
            </div>
        </div>
    </div>

    <div class="all_content">

    <div class="q_layout" style="padding-top: 92px;">
        <?php  foreach ($readdb as $key => $read) { 
  if($read['lou'] == 0){ ?>
            <div class="second-section section">
                <div class="user-head-box">
                    <div class="head-pic">
                    <?php  if($read['headcheck'] == 1){ ?>
                        <img src="<?php echo htmlspecialchars(Pw::getAvatar(0), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                    <?php  } else{ ?>
                        <img src="<?php echo htmlspecialchars(Pw::getAvatar($read['created_userid']), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                    <?php  } ?>
                    </div>
                    <div class="user-des">
                        <!-- <p class="name"><?php echo htmlspecialchars($read['created_username'], ENT_QUOTES, 'UTF-8');?>（ID：<?php echo htmlspecialchars($userInfo['ident_id'], ENT_QUOTES, 'UTF-8');?>）</p> -->
                        <p class="name" style="font-size: 15px;margin-right: 2px;"><?php echo $read['created_username'];?></p><p class="name user-id">（ID：<?php echo htmlspecialchars($userInfo['ident_id'], ENT_QUOTES, 'UTF-8');?>）</p>
                        <p class="lever-icon"><span class="level level1"></span></p>
                    </div>
                </div>
                <div class="post-head">
                    <div class="bulletin-li">
                        <?php  if($threadInfo['extend'] != null && $threadInfo['extend']['type'] == 4){ ?>
                        <span class="active-icon">活动</span>
                        <?php  } else if($threadInfo['notice']){ ?>
                        <span class="bulletin-icon">公告</span>
                        <?php  } else{ 
  if($threadInfo['topped']){ ?>
                            <span class="bulletin-icon">置顶</span>
                            <?php  } 
  if($threadInfo['digest']){ ?>
                            <span class="essence-icon">精华</span>
                            <?php  } 
  if(($threadInfo['extend'] == null || ($threadInfo['extend'] != null && $threadInfo['extend']['type'] != 4)) && $threadInfo['official']){ ?>
                            <span class="official-icon">官方</span>
                            <?php  } 
  if($threadInfo['extend'] != null){ 
  if($threadInfo['extend']['type'] == 0){ ?>
                                    <span class="extend-icon">综合讨论</span>
                                <?php  } else if($threadInfo['extend']['type'] == 1){ ?>
                                    <span class="extend-icon">问题建议</span>
                                <?php  } else if($threadInfo['extend']['type'] == 2){ ?>
                                    <span class="extend-icon">萌新求助</span>
                                <?php  } else if($threadInfo['extend']['type'] == 3){ ?>
                                    <span class="essence-icon">大神攻略</span>
                                <?php  } 
  } 
  } ?>
                        
                        <p class="bulletin-title" style="white-space: inherit;"><?php echo $threadInfo['subject'];?></p>
                    </div>
                    <div class="discuss-box" style="padding-top: 0;">
                        <div class="data"><?php echo htmlspecialchars(Pw::time2str($read['created_time']), ENT_QUOTES, 'UTF-8');?></div>
                        <div class="fr">
                            <div class="read-num"><span></span><i><?php echo htmlspecialchars($threadInfo['hits'], ENT_QUOTES, 'UTF-8');?></i></div>
                            <div class="discuss-num" onClick="clickPublish()"><span></span><i><?php echo htmlspecialchars($threadInfo['replies_count'], ENT_QUOTES, 'UTF-8');?></i></div>                          
                        </div>
                    </div>
                </div>
                <div class="post-con">
                    <div class="post-text post_text_size">
                        <?php echo $read['content'];?>
                    </div>
                    <?php  foreach ($read['attach'] as $k => $v) {  ?>
                        <div class="post-img">
                            <img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="">
                        </div>
                    <?php  } ?>
                </div>
                <div class="post-msg">
                    <div class="post-num">话题编号：<?php echo htmlspecialchars($threadInfo['tid'], ENT_QUOTES, 'UTF-8');?></div>
                    <?php  if($seachLike == 'inlike'){  ?>
                        <div class="like-num liked-num" onClick="addLike(1, <?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                    <?php  } else if($seachLike == 'mylike'){  ?>
                        <div class="like-num"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                    <?php  } else{ ?>
                        <div class="like-num addlike_t2" onClick="addLike(1, <?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                    <?php  } ?>
                </div>
            </div>
            <?php  if(count($threaddb) > 0) { ?>
            <div class="third-section section">
                <div class="q_box_header"><h3>热门话题</h3></div>
                <ul class="hot-post">
                    <?php  foreach ($threaddb as $kk => $rr) { ?>
                        <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&tid=<?php echo htmlspecialchars($rr['tid'], ENT_QUOTES, 'UTF-8');?>"><li><?php echo $rr['subject'];?></li></a>
                    <?php  } ?>
                </ul>
            </div>
            <?php  } 
  } 
  } 
  if(count($hot_readdb) > 0) { ?>
        <div class="fourth-section section">
            <div class="q_box_header"><h3>热门评论</h3></div>
            <ul class="hot-discuss">
                <?php  foreach ($hot_readdb as $key => $read) { ?>
                    <li>
                        <div class="head-pic">
                        <?php  if($read['headcheck'] == 1){ ?>
                            <img src="<?php echo htmlspecialchars(Pw::getAvatar(0), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                        <?php  } else{ ?>
                            <img src="<?php echo htmlspecialchars(Pw::getAvatar($read['created_userid']), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                        <?php  } ?>
                        </div>
                        <div class="discuss-con">
                            <div class="discuss-user">
                                <p class="user-name"><?php echo $read['created_username'];?></p>
                                <p class="user-floor"><?php echo htmlspecialchars($read['lou'], ENT_QUOTES, 'UTF-8');?>楼</p>
                            </div>
                            <div>
                                <div class="discuss-text" onClick="getForumNew(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                    <?php echo $read['content'];?>
                                </div>
                                <?php  if($read['content_img']){  ?>
                                    <div class="discuss-img-box">
                                    <?php  foreach ($read['content_img'] as $k => $v) {  
  if($k < 3){ ?>
                                        <div class="discuss-img">
                                            <img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="">
                                        </div>
                                        <?php  } 
  } ?>
                                    </div>
                                <?php  } ?>
                            </div>
                            <div class="clr"></div>
                            

                            <?php  if($read['replies_list']){ ?> 
                            <div>
                                <ul class="discuss-discuss">
                                <?php  foreach ($read['replies_list'] as $kk => $rr) { ?>
                                    <li onClick="reSecondPost(<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, <?php echo htmlspecialchars($rr['rpid'], ENT_QUOTES, 'UTF-8');?>, <?php echo htmlspecialchars($rr['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                        <span class="discuss-user-name"><?php echo $rr['created_username'];?></span>
                                        <span class="discuss-discuss-text"><?php echo $rr['content'];?></span>
                                        <?php  if($rr['content_img']){  ?>
                                            <div class="discuss-img-box">
                                            <?php  foreach ($rr['content_img'] as $k => $v) {  
  if($k < 3){ ?>
                                                <div class="discuss-img">
                                                    <img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="">
                                                </div>
                                                <?php  } 
  } ?>
                                            </div>
                                        <?php  } ?>
                                    </li>
                                <?php  } 
  if($read['replies'] > 2){ ?>
                                    <li onClick="getForumData(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                        <span class="more-replies">查看更多评论（<?php echo htmlspecialchars($read['replies'], ENT_QUOTES, 'UTF-8');?>）</span>
                                    </li>
                                <?php  } ?>
                                </ul>
                            </div>
                            <?php  } ?>

                            <div class="discuss-box">
                                <div class="data"><?php echo htmlspecialchars(Pw::time2str($read['created_time']), ENT_QUOTES, 'UTF-8');?></div>
                                <div class="fr">
                                    <?php  if($read['seachLike'] == 'inlike'){  ?>
                                        <div class="like-num liked-num" onClick="addLike(2, <?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                    <?php  } else if($read['seachLike'] == 'mylike'){  ?>
                                        <div class="like-num"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                    <?php  } else{ ?>
                                        <div class="like-num" onClick="addLike(2, <?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                    <?php  } ?>
                                    <div class="discuss-num" onClick="getForumNew(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)"><span></span><i><?php echo htmlspecialchars($read['replies'], ENT_QUOTES, 'UTF-8');?></i></div>
                                </div>
                            </div>

                        </div>
                    </li>
                <?php  } ?>
            </ul>
        </div>
        <?php  } ?>
        
        <div class="fifth-section section">
            <div class="q_box_header"><h3>最新评论</h3></div>
            <ul class="hot-discuss">
                <?php  if(count($readdb) > 1) { 
  foreach ($readdb as $key => $read) { 
                    if($read['lou'] != 0 && $read['disabled'] == 0){ ?>
                        <li id="post-id-<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>">
                            <div class="head-pic">
                            <?php  if($read['headcheck'] == 1){ ?>
                                <img src="<?php echo htmlspecialchars(Pw::getAvatar(0), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                            <?php  } else{ ?>
                                <img src="<?php echo htmlspecialchars(Pw::getAvatar($read['created_userid']), ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($time_v, ENT_QUOTES, 'UTF-8');?>"/>
                            <?php  } ?>
                            </div>
                            <div class="discuss-con">
                                <div class="discuss-user">
                                    <p class="user-name"><?php echo $read['created_username'];?></p>
                                    <p class="user-floor"><?php echo htmlspecialchars($count-$read['lou'], ENT_QUOTES, 'UTF-8');?>楼</p>
                                </div>
                                <div>
                                    <?php  if($activity_content_screen){  ?>
                                        <div class="discuss-text">
                                            <?php echo $read['content'];?>
                                        </div>
                                    <?php  } else{  ?>
                                        <div class="discuss-text" onClick="getForumNew(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                            <?php echo $read['content'];?>
                                        </div>
                                    <?php  } 
  if($read['content_img']){  ?>
                                        <div class="discuss-img-box">
                                        <?php  foreach ($read['content_img'] as $k => $v) {  
  if($k < 3){ ?>
                                            <div class="discuss-img">
                                                <img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="">
                                            </div>
                                            <?php  } 
  } ?>
                                        </div>
                                    <?php  } ?>
                                </div>
                                <div class="clr"></div>
                                
                                <?php  if($read['replies_list']){ ?> 
                                <div>
                                    <ul class="discuss-discuss">
                                    <?php  foreach ($read['replies_list'] as $kk => $rr) { 
  if($kk < 2){  ?>
                                        <li onClick="reSecondPost(<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>, <?php echo htmlspecialchars($rr['rpid'], ENT_QUOTES, 'UTF-8');?>, <?php echo htmlspecialchars($rr['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                            <span class="discuss-user-name"><?php echo $rr['created_username'];?></span>
                                            <span class="discuss-discuss-text"><?php echo $rr['content'];?></span>
                                            <?php  if($rr['content_img']){  ?>
                                                <div class="discuss-img-box">
                                                <?php  foreach ($rr['content_img'] as $k => $v) {  
  if($k < 3){ ?>
                                                    <div class="discuss-img">
                                                        <img src="<?php echo htmlspecialchars($v, ENT_QUOTES, 'UTF-8');?>" alt="">
                                                    </div>
                                                    <?php  } 
  } ?>
                                                </div>
                                            <?php  } ?>
                                        </li>
                                        <?php  } 
  } 
  if($read['replies'] > 2){ ?>
                                        <li onClick="getForumData(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)">
                                            <span class="more-replies">查看更多评论（<?php echo htmlspecialchars($read['replies'], ENT_QUOTES, 'UTF-8');?>）</span>
                                        </li>
                                    <?php  } ?>
                                    </ul>
                                </div>
                                <?php  } ?>
                    
                                <div class="discuss-box">
                                    <div class="data"><?php echo htmlspecialchars(Pw::time2str($read['created_time']), ENT_QUOTES, 'UTF-8');?></div>
                                    <div class="fr">
                                        <?php  if($read['seachLike'] == 'inlike'){  ?>
                                            <div class="like-num liked-num" onClick="addLike(2, <?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                        <?php  } else if($read['seachLike'] == 'mylike'){  ?>
                                            <div class="like-num"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                        <?php  } else{ ?>
                                            <div class="like-num" onClick="addLike(2, <?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>, this, true)"><span></span><i><?php echo htmlspecialchars($read['like_count'], ENT_QUOTES, 'UTF-8');?></i></div>
                                        <?php  } ?>
                                        <div class="discuss-num" onClick="getForumNew(<?php echo htmlspecialchars($read['pid'], ENT_QUOTES, 'UTF-8');?>)"><span></span><i><?php echo htmlspecialchars($read['replies'], ENT_QUOTES, 'UTF-8');?></i></div>
                                    </div>
                                </div>

                            </div>
                        </li>
                    <?php  }
                } 
  }else{ ?>
                    <div class="nocontent">
                        <p>暂时没有回复哦!</p>
                        <p>赶紧抢个沙发吧~</p>
                    </div>
                <?php  } ?>
            </ul>
        </div>
        <div class="load-more">加载更多内容</div>
        <div class="stepping"></div>
    
    </div>
    </div>
    <!-- 查看图片的弹窗遮罩 -->
    <div class="big-img-mask" style="margin-top: 0px;" id="lookPicMask">
        <div class="rec_tip">
        </div>
        <div class="btnEnlarge">+</div>
        <div class="btnNarrow">-</div>
        <div class="btnImgClose">X</div>
    </div>
    </body>
    <script src='<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js'></script>

    <script type="text/javascript">
    
    $(function() {
        /**
        * ul.discuss-discuss是评论中的二次评论，有二次评论的评论底部需要添加10px底边距
        */
        $("ul.discuss-discuss").parent('div').prev('div').css('padding-bottom', '10px');
        console.log($("ul.discuss-discuss").parent('div').prev('div'))

        /**
        *post-text评论文字中插入的图片，宽度小于屏幕宽度则完全展示、否则进行100%缩放
        */
        setTimeout(function () {
            $(".post-text img").each(function(index, el) {
                var postImgW = $(this).width();
                var windowW = $(window).width()
                if (postImgW>windowW) {
                    $(this).css('width', '100%');
                }else{
                    console.log("postImgW!!>windowW--")
                }

                //将图片居中
                if(!$(this).hasClass('emoji_pic')){
                    postImgW = $(this).width();
                    $(this).css('display', 'initial');
                    $(this).wrap("<div style='text-align: center;'></div>")
                }
            });
            
        },10)

        //锚点跳转
        var post_anchor = "<?php echo htmlspecialchars($post_anchor, ENT_QUOTES, 'UTF-8');?>";
        if(post_anchor){
            
            var storage = window.sessionStorage; 
            if(post_list = storage.getItem('ss_post_list')){
                $('.fifth-section .hot-discuss').append(post_list);
                loadPage = sessionStorage.getItem('ss_post_page');
            } else{
                while($('body').find('#'+post_anchor).length < 1 && loadNew){
                    loadNew = false;
                    loadPage++;
                    var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&tid=<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>&page="+loadPage+"&ajax=ajax";
                    var loadtf = ajaxData(loadPage, url, $('.fifth-section .hot-discuss'));
                    if(loadtf == 'loadNext'){
                        loadNew = true;
                    }
                }
            }


            $(".all_content").animate({scrollTop:$('#'+post_anchor).offset().top-82},1);
        } else{
            sessionStorage.removeItem('ss_post_list');
        }

    });

        var loadMore = false;       //是否到底
        var loadNew = true;     //评论判断是否可以加载
        var loadPage = <?php echo htmlspecialchars($page, ENT_QUOTES, 'UTF-8');?>?<?php echo htmlspecialchars($page, ENT_QUOTES, 'UTF-8');?>:1;     //评论当前页数

        /*判断上下滑动：*/
        $('body').bind('touchstart',function(e){
            startX = e.originalEvent.changedTouches[0].pageX;
            startY = e.originalEvent.changedTouches[0].pageY;
        });
        $("body").bind("touchmove",function(e){
            //获取滑动屏幕时的X,Y
            endX = e.originalEvent.changedTouches[0].pageX;
            endY = e.originalEvent.changedTouches[0].pageY;
            //获取滑动距离
            distanceX = endX-startX;
            distanceY = endY-startY;

            //拉到底部加载新评论
            if(Math.abs(distanceX)<Math.abs(distanceY) && distanceY<0){
                
                var scrollH = $('.all_content').scrollTop();       //获取屏幕滚动的高度/偏移量
                var scrollHeight = $('.all_content').prop('scrollHeight');      //滚动条高度
                var clientHeight = $(document).height();      //窗口高度

                if(scrollHeight <= clientHeight+scrollH && loadNew){
                    $('.load-more').show();
                    loadMore = true;
                    //$('.all_content').scrollTop($('.all_content').prop('scrollHeight')-clientHeight);
                }           
            } else if(Math.abs(distanceX)<Math.abs(distanceY) && distanceY>0){
                if(loadMore){
                    $('.load-more').hide();
                    $('.load-more').html('加载更多内容');
                    loadMore = false;
                }
            }
        });
        $('body').bind('touchend',function(e){
            if(loadMore && loadNew){
                $('.load-more').hide();
                $('.load-more').html('加载更多内容');
                loadMore = false;

                loadNew = false;
                loadPage++;
                var url = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&tid=<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>&page="+loadPage+"&ajax=ajax";

                var loadtf = ajaxData(loadPage, url, $('.fifth-section .hot-discuss'));
                if(loadtf == 'loadNext'){
                    setTimeout(function(){
                        loadNew = true;
                    }, 1000);
                }
            }
        });

        /**
        * 将数据放入dom
        * @param  {[int]} loadPage [页码]
        * @param  {[string]} loadUrl  [请求url]
        * @param  {[obj]} loadObj  [加载对象]
        * @return {[string]}          [判断是否还可以加载]
        */
        function ajaxData(loadPage, loadUrl, loadObj){
            var loadtf = 'loadNext';
            $.ajax({
                url:loadUrl,
                type:'GET',
                dataType:'json',
                async:false,
                success:function(data){
                    console.log(data);
                    var page = data['page'];        //页码
                    var page_count = data['page_count'];        //总页码
                    var total = data['total'];      //总数
                    var list = data['list'];        //数据
                    
                    //已经加载完
                    if(page < loadPage){
                        loadObj.parents('.fifth-section').after('<div class="uncontent">已显示全部内容</div>');
                        loadtf = 'loadOut';
                        return loadtf;
                    }
                    
                    for(var i in list) {
                        if(list[i]['disabled'] != 0){
                            continue;
                        }
                        //图片
                        var content_img = '';
                        if(list[i]['content_img'] != ''){
                            content_img += '<div class="discuss-img-box">';
                            for(var j = 0; j < list[i]['content_img'].length; j++){
                                if(j > 2){
                                    break;
                                }
                                content_img += '<div class="discuss-img"><img src="'+list[i]['content_img'][j]+'" alt="未上传"></div>';
                            }
                            content_img += '</div>';
                        }           

                        //二级回复
                        var read_second = '';
                        if(list[i]['replies_list']){
                            read_second += '<div><ul class="discuss-discuss">';
                            for(var j = 0; j < list[i]['replies_list'].length; j++){
                                if(j == 2){
                                    if(list[i]['replies'] > 2){
                                    read_second += '<li onClick="getForumData('+list[i]['pid']+')"><span class="more-replies">查看更多评论（'+list[i]['replies']+'）</span></li>';
                                    }
                                    break;
                                }
                                //图片
                                var replies_img = '';
                                if(list[i]['replies_list'][j]['content_img'] != ''){
                                    replies_img += '<div class="discuss-img-box">';
                                    for(var k = 0; k < list[i]['replies_list'][j]['content_img'].length; k++){
                                        if(k > 2){
                                            break;
                                        }
                                        replies_img += '<div class="discuss-img"><img src="'+list[i]['replies_list'][j]['content_img'][k]+'" alt="未上传"></div>';
                                    }
                                    replies_img += '</div>';
                                } 
                                
                                read_second += '<li onClick="reSecondPost('+<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>+', '+list[i]['replies_list'][j]['rpid']+', '+list[i]['replies_list'][j]['pid']+')">'+
                                    '<span class="discuss-user-name">'+list[i]['replies_list'][j]['created_username']+'</span>'+
                                    '<span class="discuss-discuss-text">'+list[i]['replies_list'][j]['content']+'</span>'+
                                    replies_img+
                                '</li>';
                            }
                            read_second += '</ul></div>';
                        }
                        

                        //是否喜欢
                        var can_like = '';
                        if(list[i]['seachLike'] == 'inlike'){
                            can_like = '<div class="like-num liked-num" onClick="addLike(2, '+list[i]['pid']+', this, true)"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        } else if(list[i]['seachLike'] == 'mylike'){
                            can_like = '<div class="like-num"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        } else{
                            can_like = '<div class="like-num" onClick="addLike(2, '+list[i]['pid']+', this, true)"><span></span><i>'+list[i]['like_count']+'</i></div>';
                        }

                        //帖子内容
                        var post_content = '';
                        var activity_content_screen = "<?php echo htmlspecialchars($activity_content_screen, ENT_QUOTES, 'UTF-8');?>";
                        if(activity_content_screen){
                            post_content = '<div class="discuss-text">'+list[i]['content']+'</div>'+content_img;
                        }else{
                            post_content = '<div class="discuss-text" onClick="getForumNew('+list[i]['pid']+')">'+list[i]['content']+'</div>'+content_img;
                        }
                        var post_content = '<li id="post-id-'+list[i]['pid']+'">'+
                            '<div class="head-pic"><img src="'+list[i]['created_userimg']+'" alt=""></div>'+
                            '<div class="discuss-con">'+
                                '<div class="discuss-user">'+
                                    '<p class="user-name">'+list[i]['created_username']+'</p>'+
                                    '<p class="user-floor">'+(total-list[i]['lou'])+'楼</p>'+
                                '</div>'+
                                '<div>'+
                                    post_content+
                                '</div>'+
                                '<div class="clr"></div>'+
                                    read_second+
                                '<div class="discuss-box">'+
                                    '<div class="data">'+list[i]['created_time_str']+'</div>'+
                                    '<div class="fr">'+
                                        can_like+
                                        '<div class="discuss-num" onClick="getForumNew('+list[i]['pid']+')"><span></span><i>'+list[i]['replies']+'</i></div>'+
                                    '</div>'+
                                '</div>'+
                            '</div>'+
                        '</li>'
                        
                        loadObj.append(post_content);

                        sessionStorage.setItem('ss_post_page', page);
                        var ss_post_list = '';
                        if(sessionStorage.getItem('ss_post_list')){
                            ss_post_list = sessionStorage.getItem('ss_post_list');
                        }
                        sessionStorage.setItem('ss_post_list', ss_post_list+post_content);
                    }

                    if(page == page_count){
                        loadObj.parents('.fifth-section').after('<div class="uncontent">已显示全部内容</div>');
                        loadtf = 'loadOut';
                        return loadtf;
                    }
                
                    setImgSize();
                }
            })
            setHeadPic();
            return loadtf;
        }

    setImgSize();
    //设置缩略图盒子大小
    function setImgSize(){
        var bigBox = $(".discuss-img-box");
        var len = bigBox.length;
        if(len > 0){
            for(var i = 0; i < len;i++){
                var imgBoxs = bigBox.eq(i).children(".discuss-img");
                var boxWidth = imgBoxs.eq(0).width();
                imgBoxs.css("height",boxWidth);
            }
        }
    }

        /**
         * 添加喜欢
         * @param {[int]} type [喜欢类型]
         * @param {[int]} id   [相关id]
         * @param {[obj]} obj  [html对象]
         * @param {[bool]} addnum  [是否增加数字]
         */
        function addLike(type, id, obj, addnum){
            $.ajax({
                url:"<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&a=doLike",
                type:'POST',
                data:{
                    csrf_token:"<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8');?>",
                    typeid:type,
                    fromid:id,
                },
                success:function(data){
                    //console.log(data);
                    if(data == 'login'){
                        window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Login";
                    } else if(data == 'inlike'){
                        //可能会出现两条相同的记录
                        if(!$(obj).hasClass('liked-num')){
                            var liek_count = $(obj).find('i').html();
                            $(obj).find('i').html(liek_count*1+1);
                            $(obj).addClass('liked-num');
                        }
                        alert('已经点赞过'); 
                    } else if(data == 'myself'){
                        alert('这是你自己发的'); 
                    } else if(data == 'success'){
                        alert('点赞成功');
                        if(addnum){
                            var liek_count = $(obj).find('i').html();
                            $(obj).find('i').html(liek_count*1+1);
                            $(obj).addClass('liked-num');
                            //更改关联元素
                            if($(obj).hasClass('addlike_t2')){
                                $('.addlike_t1').addClass('liked');
                            }
                        } else{
                            $(obj).addClass('liked');
                            //更改关联元素
                            var liek_count = $('.addlike_t2').find('i').html();
                            $('.addlike_t2').find('i').html(liek_count*1+1);
                            $('.addlike_t2').addClass('liked-num');
                        }
                    }
                        
                }
            })
        }

        //二次评论
        function getForumNew(pid){
            var stop_action = '<?php echo htmlspecialchars($stop_action, ENT_QUOTES, 'UTF-8');?>';
            if(stop_action == 1){
                alert('论坛功能正在升级，暂时关闭评论功能');
            } else{
                window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&a=reply&tid="+<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>+"&pid="+pid+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"+"&post_anchor=post-id-"+pid;
            }
            
        }

        //查看评论详情
        function getForumData(pid){
            window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumData&a=postdetail&tid="+<?php echo htmlspecialchars($tid, ENT_QUOTES, 'UTF-8');?>+"&pid="+pid+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"+"&post_anchor=post-id-"+pid;
        }

        //单次评论
        function toNewPost(tid){
            var stop_action = '<?php echo htmlspecialchars($stop_action, ENT_QUOTES, 'UTF-8');?>';
            if(stop_action == 1){
                alert('论坛功能正在升级，暂时关闭评论功能');
            } else{
                window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&a=reply&tid="+tid+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>";
            }
            
        }

        //发布帖子
        function toNewthread(activity_prefix){
            window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>&activity_prefix="+activity_prefix+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>";
        }

        //回复二次评论
        function reSecondPost(tid, pid, replyid){
            var stop_action = '<?php echo htmlspecialchars($stop_action, ENT_QUOTES, 'UTF-8');?>';
            if(stop_action == 1){
                alert('论坛功能正在升级，暂时关闭评论功能');
            } else{
                window.location.href = "<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=ForumNew&a=reply&tid="+tid+"&pid="+pid+"&replyid="+replyid+"&anchor=<?php echo htmlspecialchars($anchor, ENT_QUOTES, 'UTF-8');?>"+"&post_anchor=post-id-"+pid;
            }
        }

        function clickPublish(){
            $('.publish').find('a').click();
        }

    </script>
</html>