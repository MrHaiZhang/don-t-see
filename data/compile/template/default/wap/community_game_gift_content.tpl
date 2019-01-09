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
    <style>
        .section{padding: 0 14px;}
        .first-section{ width: 100%; }
        .game_community_title{overflow: hidden}
        .back-community{border-radius: 5px;color: #1ea4f2; display: inline-block;font-size: 10pt;padding: 3px 10px; margin-top: 25px;background-color: #fff;border: 1px solid #1ea4f2;font-weight: 700;float: right;}
        .game-name{font-weight: 700;color:#333;float: left;font-size:18px;    padding-left:10px;margin-top: 24px;}
        .gamelist{    height: 82px;padding:14px 0;}
        .gamelist .header-icon-body{width: 55px;height: 55px;}
        .game-name{    margin-top: 14px;}
        .back-community{    margin-top: 15px;}
        .second-section{height:50px;line-height:50px;}
        .blue{color:#1ea4f2}
        .integral{float:left;font-size:16px;color:#949494}
        .integral .blue{font-size:16px;}
        .record{float:right;font-size:16px;}
        .record a{color:#949494;display: inline-block;font-size:16px;padding-left: 44px; background: url("<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/images'; ?>/community/record.png") left center  no-repeat;background-size: 40px}
        .gift-content{padding-top: 15px;}
        .gift-content h2{border-left:5px solid #1ea4f2;font-size:16px;text-align: left;font-weight: normal;padding-left: 5px;height:25px;line-height: 25px;}
        .gift-content div{overflow: hidden;padding:10px;border-bottom: 1px solid #e5e5e5;text-align: left;margin-bottom: 15px;line-height: 1.5;color:#949494}
        .gift-content .sales-num{float:left;font-size:14px;}
        .gift-content .overplus-num{float:right;font-size:14px}
        .gift-content .sales-num i,.gift-content .overplus-num i{font-size:14px;font-weight: bold}

        .q_layout{padding-bottom: 44px;}
        .bottom-nav{border-bottom: 1px solid #1ea4f2;border-top: 1px solid #1ea4f2;left:0;overflow: hidden;padding:0;}
        .publish{width:100%;padding-left:40px;padding-right: 90px;}
        .publish a{font-size:20px;color:#949494;background-color: transparent}
        .publish a i{font-size:20px;}
        .back-icon{float: none;position: absolute;left:0;top:0}
        .btnGet{display: inline-block;position:absolute;right:0;top:0;width:90px;height:100%;border-radius: 5px;font-size:13px;text-align: center;color:#fff;background-color:#1ea4f2;line-height: 42px; }

        .rec_tip .rec_tip_sure{margin:15px 0}
        .rec_tip .rec_btn{text-align: center}
        .rec_tip .rec_tip_sure, .rec_tip .rec_jump{display:inline-block;}
        .rec_tip .rec_jump{margin-left: 5%;}
    </style>
</head>
<body>

<div class="all_content">
    <div class="q_layout">
        <div class="first-section section">
            <div class="gamelist">
                <div class="game_community_title">
                    <div class="header-icon-body">
                        <img src="<?php echo htmlspecialchars(Pw::getPath($pwforum->foruminfo['icon']), ENT_QUOTES, 'UTF-8');?>" id="icon_id" alt="" title="">
                    </div>
                    <h1 class="game-name"><?php echo $pwforum->foruminfo['name'];?></h1>
                    <div class="download_btn">
                        <a class="back-community" href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=OneGame&fid=<?php echo htmlspecialchars($pwforum->foruminfo['fid'], ENT_QUOTES, 'UTF-8');?>">回到社区</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="second-section section">
            <div class="integral">我的积分：<span class="blue"><?php echo htmlspecialchars($plat_credit, ENT_QUOTES, 'UTF-8');?></span></div>
            <div class="record">
                <a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Record&load_type=gift">领取记录</a>
            </div>
        </div>
        <div class="third-section section">
            <div class="gift-content">
                <h2><?php echo $gift['gift_name'];?></h2>
                <div>
                    <span class="sales-num">销量：<i class="blue"><?php echo htmlspecialchars($gift['total_num']-$gift['rest_num'], ENT_QUOTES, 'UTF-8');?></i></span>
                    <span class="overplus-num">剩余：<i class="blue"><?php echo htmlspecialchars($gift['rest_num'], ENT_QUOTES, 'UTF-8');?></i></span>
                </div>
                <h2>礼包内容</h2>
                <div><?php echo $gift['gift_content'];?></div>
                <h2>领取方式</h2>
                <div><?php echo $gift['gift_get_way'];?></div>
                <h2>注意事项</h2>
                <div><?php echo $gift['attention'];?></div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" name="is_get" value="<?php echo htmlspecialchars($gift['is_get'], ENT_QUOTES, 'UTF-8');?>">
<div class="bottom-nav">
    <div class="back-icon"><a href="<?php echo Wind::getComponent('response')->getData('G', 'url', 'base'),'/',''; ?>index.php?m=wap&c=Gift&fid=<?php echo htmlspecialchars($pwforum->foruminfo['fid'], ENT_QUOTES, 'UTF-8');?>"></a></div>
    <div class="publish"><a href="javascript:;">所需积分：<i class="blue"><?php echo htmlspecialchars($gift['point'], ENT_QUOTES, 'UTF-8');?></i></a></div>
    <?php  if($gift['rest_num'] <= 0){ ?>
        <a href="javascript:;" class="btnGet">已抢完</a>
    <?php  } else if($gift['is_get'] == 1){ ?>
        <a href="javascript:;" onclick="ajax_get_gift(<?php echo htmlspecialchars($gift['gift_id'], ENT_QUOTES, 'UTF-8');?>, this)" class="btnGet">已领取</a>
    <?php  } else{ ?>
        <a href="javascript:;" onclick="ajax_get_gift(<?php echo htmlspecialchars($gift['gift_id'], ENT_QUOTES, 'UTF-8');?>, this)" class="btnGet">立即兑换</a>
    <?php  } ?>
</div>


<div class="rec_gift_mask" style="display: none;">
    <div class="rec_tip">
        <div class="title">
            <span>温馨提示</span>
            <a title="关闭" onclick="close_tip();">✕</a>
        </div>
        <div class="received" style="display: none;">
            <p id="received"><span style="font-size:10pt;">积分不够了~</span></p>
            <img src="//wap.quxuan.com/mobile_common/img/received.jpg?=1513267200" alt="">
            <div class="rec_btn"><a class="rec_tip_sure" onclick="close_tip()">确定</a><a href="index.php?m=wap&c=UserTask&fid=<?php echo htmlspecialchars($fid, ENT_QUOTES, 'UTF-8');?>" class="rec_jump">立即获取积分</a></div>
        </div>
        <div class="dis_received" style="display: block;">
            <p id="receive_msg">恭喜您领取成功！</p>
            <?php  if($gift['remain_time'] == -1){ ?>
                <p id="tomorrow_msg" style="display: none;">请明天再来</p>
            <?php  } ?>
            <div class="copy">
                <p>长按复制礼包码</p>
                <input type="text" value="" readonly="true" class="code" id="gift_code">
            </div>
            <div class="rec_btn"><a class="rec_tip_sure" onclick="close_tip()">确定</a><a href="index.php?m=wap&c=Record&load_type=gift" class="rec_jump">礼包领取记录</a></div>
        </div>
        
        
    </div>
</div>
<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/jquery.min.js"></script>
<script src="<?php echo Wind::getComponent('response')->getData('G', 'url', 'themes').'/site/wap/js'; ?>/community.js"></script>
<script>
    function close_tip(){
        $(".rec_gift_mask").fadeOut();
    }

    //领取礼包
    function ajax_get_gift(gift_id, obj){
        var options = {
            url: "index.php?m=wap&c=Gift&a=getGift",
                type: "GET",
                dataType: "json",
                data:{
                    "gift_id":gift_id,
                    "change_point":1,
                },
                success:function(data){
                    console.log(data);
                    if (data.code==2) {
                        //未登录
                        window.location.href="index.php?m=wap&c=Login";
                    } else if(data.code == 99) {
                        show_tip(data,1);
                    } else if(data.code==1){
                        $(obj).addClass('have_getten').removeClass('get_welfare');
                        $(obj).html('已领取');
                        //修改页面值
                        $('.integral .blue').html($('.integral .blue').html()*1-<?php echo htmlspecialchars($gift['point'], ENT_QUOTES, 'UTF-8');?>);
                        $('.sales-num .blue').html($('.sales-num .blue').html()*1+1);
                        $('.overplus-num .blue').html($('.overplus-num .blue').html()*1-1);
                        
                        show_tip(data,0);
                    } else if(data.code == 10) {
                        show_tip(data,1);
                    } else {
                        show_tip(data,0);
                    }
                }
            }
        $.ajax(options);
    }

    $(".rec_tip").on("click",function(e){
        e.stopPropagation()
    })

    $(".rec_gift_mask").on("click",function(){
        $(this).hide();
    })
    
    //领取礼包弹窗
    function show_tip(data,flag) {
        // var marginTop = getScrollTop()+'px';
        /*var marginTop = -$(".q_layout").offset().top;

        $(".rec_gift_mask").css('margin-top',marginTop);*/
        $(".rec_gift_mask").fadeIn(100);
        $(".rec_tip").fadeIn(100);
        if (flag == 1) {
            $("#received").css('font-size','13px');
            $("#received").html(data.msg);
            $(".received").css('display','block');
            $(".dis_received").css('display','none');
        } else {
            if (data.code == 1) {
                $(".received").css('display','none');
                $(".dis_received").css('display','block');
                $("#gift_code").val(data.gift_code);
                $("#tomorrow_msg").hide();
                $("#receive_msg").html("恭喜您领取成功！");
            } else if(data.code == 5){
                $(".received").css('display','none');
                $(".dis_received").css('display','block');
                $("#gift_code").val(data.gift_code);
                $("#tomorrow_msg").show();
                $("#receive_msg").html(data.msg);
            } else if(data.code == 13){
                $(".received").css('display','none');
                $(".dis_received").css('display','block');
                $("#gift_code").val(data.gift_code);
                $("#tomorrow_msg").show();
                $("#receive_msg").html(data.msg);
            } else {
                $(".received").css('display','block');
                $("#received").html(data.msg);
                $(".dis_received").css('display','none');
            }
        }
    }

</script>
</body>
</html>