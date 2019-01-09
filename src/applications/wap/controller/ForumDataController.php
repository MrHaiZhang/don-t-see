<?php

Wind::import('SRV:forum.srv.PwThreadDisplay');
Wind::import('SRV:credit.bo.PwCreditBo');

Wind::import('SRV:forum.srv.PwThreadList');
Wind::import('SRV:forum.srv.PwPost');

/**
 * 手机端帖子详情
 * form src\applications\bbs\controller\ReadController.php
 * form src\applications\like\controller\MylikeController.php
 * 2017.10.23
 */
class ForumDataController extends PwBaseController {

	public $todayposts = 0;
	public $article = 0;
	public $groups_arr = array();		//管理组信息
	public $user_desc = array();		//用户信息
	
	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
		//锚点
		$this->setOutput($_GET['anchor'], 'anchor');
		$this->setOutput($_GET['post_anchor'], 'post_anchor');
	}

	public function run() {
		$tid = intval($this->getInput('tid'));		//帖子id
		$prev_fid = intval($this->getInput('prev_fid'));		//进入版块id
		if($prev_fid > 0){
			Pw::setCookie('prev_fid', $prev_fid);
		} else{
			$prev_fid = Pw::getCookie('prev_fid');
		}
		$ajax = $this->getInput('ajax', 'get');		//是否是ajax加载
		list($page, $uid, $desc) = $this->getInput(array('page', 'uid', 'desc'), 'get');
		//默认降序排序
		$desc = 1;

		$threadDisplay = new PwThreadDisplay($tid, $this->loginUser);
		
		$this->runHook('c_read_run', $threadDisplay);		//屏蔽字符

		$pwforum = $threadDisplay->getForum();		//版块信息

		Wind::import('SRV:forum.srv.threadDisplay.PwCommonRead');
		
		$readdb_list = array();
		//判断当前页数据是否为空
		intval($page) == 0 && $page = 1;
		$page_count = $page;
		while ($page <= $page_count) {
			$dataSource = new PwCommonRead($threadDisplay->thread);
			$dataSource->setPage($page)
				->setPerpage(Wekit::C('bbs', 'read.perpage'))
				->setDesc($desc);

			$threadDisplay->execute($dataSource);
			$threadInfo = $threadDisplay->getThreadInfo();		//帖子信息
			$userInfo = Wekit::load('user.PwUser')->getUserByUid($threadInfo['created_userid'], PwUser::FETCH_ALL);		//发帖人信息

			//帖子被隐藏或删除
			if($threadInfo['disabled'] != 0){
				header('location:index.php?m=wap&c=OneGame&fid='.$threadInfo['fid']);
				exit;
				//$this->forwardAction('wap/OneGame/run?fid='.$threadInfo['fid']);
			}

			//帖子屏蔽
			if($threadInfo['ifshield'] == 1){
				$threadInfo['subject'] = '此贴已被屏蔽';
			}

			$threadInfo['extend'] = json_decode($threadInfo['extend'], true);

			//活动帖子
			if($threadInfo['type'] == 1){
				$threadInfo['activity_param'] = json_decode($threadInfo['activity_param'], true);

				$activity_time_start = $threadInfo['activity_param']['activity_time_start'] ? strtotime($threadInfo['activity_param']['activity_time_start']) : 0;
				$activity_time_end = $threadInfo['activity_param']['activity_time_end'] ? strtotime($threadInfo['activity_param']['activity_time_end']) : 0;
				if($activity_time_start != 0 && time() > $activity_time_start){
					$stop_statue_one = true;
				}
				if($activity_time_end != 0 && time() < $activity_time_end){
					$stop_statue_two = true;
				}
				if($activity_time_start == 0 && $activity_time_end == 0){
					$stop_statue_three = true;
				}

				if(!(($stop_statue_one && $stop_statue_two) || $stop_statue_three)){
					$threadInfo['activity_param']['stop'] = 1;
				}
				

				//屏蔽评论
				if($threadInfo['activity_param']['activity_content_screen'] == 1){
					$activity_content_screen = true;
				}
			}

			//获取管理组数据
			$this->groups_arr = Wekit::load('usergroup.PwUserGroups')->getGroupsByTypeInUpgradeOrder('system');

			//回复列表
			$readdb = $threadDisplay->getList();

			$page_count = ceil($threadDisplay->total/Wekit::C('bbs', 'read.perpage'));

	        foreach($readdb as $key=>$value){
	        	//隐藏评论
	        	if($value['hide_other'] == 1 && $value['created_userid'] != $this->loginUser->uid){
	        		unset($readdb[$key]);
	        		continue;
	        	}
	        	//一级回复数据加工
	        	$readdb[$key]['seachLike'] = $this->seachLike(2, $value['pid']);		//是否喜欢

	        	//昵称
	        	$readdb[$key]['created_username'] = $this->systemUserName($value['created_userid'], $value['created_username']);
	        	
	            $readdb[$key]['content'] = $this->workReply($readdb[$key]['created_userid'], $readdb[$key]['content']);
	            //提取图片
				$readdb[$key]['content_img'] = $this->getImg($readdb[$key]['content']);
				//0楼不需要去掉图片
				if($value['lou'] == 0){
					$created_info = Wekit::load('user.PwUser')->getUserByUid($value['created_userid'], PwUser::FETCH_MAIN);
					//管理组帖子可以有a标签
			    	if(array_key_exists($created_info['groupid'], $this->groups_arr)){
			    		$readdb[$key]['content'] = strip_tags($readdb[$key]['content'], '<img><div><span><p><strong><br/><br><a>');
			    	} else{
			    		$readdb[$key]['content'] = strip_tags($readdb[$key]['content'], '<img><div><span><p><strong><br/><br>');
			    	}
				} else{
					//去除评论内容里的图片
					$readdb[$key]['content'] = $this->delImg($readdb[$key]['content_img'][0], $readdb[$key]['content']);
					$readdb[$key]['content'] = strip_tags($readdb[$key]['content'], '<img><div><span><p><br/><br>');
					if($activity_content_screen && $userInfo['uid'] != $this->loginUser->uid){
						$readdb[$key]['content'] = '该评论仅作者可见';  
						$readdb[$key]['content_img'] = array();
					}
				}


				//二级回复数据加工
				if($activity_content_screen && $userInfo['uid'] != $this->loginUser->uid){
					$readdb[$key]['replies_list'] = array();
				} else if($value['replies_list']){
	        		foreach($value['replies_list'] as $kk=>$vv){
	        			//隐藏评论
			        	if($vv['hide_other'] == 1 && $vv['created_userid'] != $this->loginUser->uid){
			        		unset($readdb[$key]['replies_list'][$kk]);
			        		continue;
			        	}

	        			$readdb[$key]['replies_list'][$kk] = $this->workReplyList($threadDisplay, $vv);
	        			
						$readdb[$key]['replies_list'][$kk]['content'] = strip_tags($readdb[$key]['replies_list'][$kk]['content'], '<img><div><span><p><br/><br>');
	        		}
	        	}
				
	        }

	        //判断用户头像是否在审核中
	        foreach ($readdb as $key => $value) {
	        	foreach ($this->user_desc as $kk => $vv) {
	        		if($value['created_userid'] == $kk){
	        			$readdb[$key]['headcheck'] = $vv['headcheck'];
					}
	        	}
	        }
	        $readdb_list = array_merge($readdb_list, $readdb);
	        //当前页有数据，退出循环
	        if($readdb_list[0]['lou'] == 0 && count($readdb_list) > 1){
	        	break;
	        } else if($readdb_list[0]['lou'] != 0 && count($readdb_list) > 0){
	        	break;
	        }
	        $page++;
		}
		$readdb = $readdb_list;

        if($ajax == 'ajax'){
        	foreach($readdb as $key=>$value){
	        	//一级回复数据加工,这些类似js加载，只能在页面初始化时使用
	        	if($value['headcheck'] == 1){
	        		$readdb[$key]['created_userimg'] = Pw::getAvatar(0).'?'.time();
	        	} else{
	        		$readdb[$key]['created_userimg'] = Pw::getAvatar($readdb[$key]['created_userid']).'?'.time();
	        	}
	        	
	        	$readdb[$key]['created_time_str'] = Pw::time2str($readdb[$key]['created_time']);
	        }

        	$return_arr = array(
        		'page'=>$threadDisplay->page,
        		'page_count'=>$page_count,
        		'total'=>$threadDisplay->total,
        		'list'=>(array)$readdb,
        		);

        	echo json_encode($return_arr);
        	exit;
        }

        $config = Wekit::C()->getValues('bbs');
        $hot_reply_num = $config['read.hot_reply'];		//热门评论数

        //热门回复列表(个数、偏移量、升序排列、上级回复id、热门排序)
        $hot_readdb = $threadDisplay->thread->getRepliesGroup(2, 0, false, 0, true);
        foreach ($hot_readdb as $key=>$value) {
        	//不符合条件
        	if($hot_reply_num > $value['replies']){
        		unset($hot_readdb[$key]);
        		continue;
        	}
        	//一级回复数据加工
        	//屏蔽字符
        	$hot_readdb[$key] = $threadDisplay->runWithFilters('bulidRead', $value);
        	$hot_readdb[$key]['seachLike'] = $this->seachLike(2, $value['pid']);		//是否喜欢

        	//昵称
        	$hot_readdb[$key]['created_username'] = $this->systemUserName($value['created_userid'], $value['created_username']);

        	$hot_readdb[$key]['content'] = $this->workReply($hot_readdb[$key]['created_userid'], $hot_readdb[$key]['content']);
        	//提取图片
			$hot_readdb[$key]['content_img'] = $this->getImg($hot_readdb[$key]['content']);
			//去除评论内容里的图片
			$hot_readdb[$key]['content'] = $this->delImg($hot_readdb[$key]['content_img'][0], $hot_readdb[$key]['content']);
			$hot_readdb[$key]['content'] = strip_tags($hot_readdb[$key]['content'], '<img><div><span><p><br/><br>');

			//下面有回复时
			if($value['replies'] > 0){
				//获取二级级回复，降序排序,默认2条
				$hot_readdb[$key]['replies_list'] = $threadDisplay->thread->getRepliesGroup(2, 0, false, $value['pid']);
			}
		}

		//判断用户头像是否在审核中
        foreach ($hot_readdb as $key => $value) {
        	foreach ($this->user_desc as $kk => $vv) {
        		if($value['created_userid'] == $kk){
        			$hot_readdb[$key]['headcheck'] = $vv['headcheck'];
				}
        	}
        }

        foreach($hot_readdb as $key=>$value){
        	//二级回复数据加工
        	if($value['replies_list']){
        		foreach($value['replies_list'] as $kk=>$vv){
        			$hot_readdb[$key]['replies_list'][$kk] = $this->workReplyList($threadDisplay, $vv);

					$hot_readdb[$key]['replies_list'][$kk]['content'] = strip_tags($hot_readdb[$key]['replies_list'][$kk]['content'], '<div><span><p><br/><br>');
        		}
        	}        	
        }

        //热门帖子列表,取去掉置顶的前5个
        $threaddb = array();
        $threaddb_num = 5;
        $threadList = new PwThreadList();
        $i = 1;
        while ($threaddb_num > 0) {
			$threadList->setPage($i)
				->setPerpage(10)
				->setIconNew($pwforum->foruminfo['newtime']);
			
			//排序,hotpost热门贴子
			$orderby = 'hotpost';
			Wind::import('SRV:forum.srv.threadList.PwCommonThread');
			$t_dataSource = new PwCommonThread($pwforum, $orderby);
			$t_dataSource->setUrlArg('orderby', $orderby);

			$threadList->execute($t_dataSource);
			$threaddb_list = $threadList->getList();
			//没有更多了
			if($threadList->page < $i){
				break;
			}
			foreach($threaddb_list as $key=>$value){
				if(!$value['issort'] && ($value['created_time']<$value['lastpost_time'] || $value['created_userid'] == $this->loginUser->uid) && $threaddb_num > 0){
					$threaddb[] = $value;
					$threaddb_num--;
				}
			}
			$i++;
        }
        
        //是否喜欢
        $seachLike = $this->seachLike(1, $tid);

        //回帖权限
		$post_obj = $this->_getPost('reply');
		$stop_action = 0;
		if ($this->loginUser->uid && ($result = $post_obj->check()) !== true && $action!='addPic') {
			$error = $result->getError();
			
			if (is_array($error) && $error[0] == 'BBS:post.forum.allow.ttype'
			&& ($allow = $post_obj->forum->getThreadType($post_obj->user))) {
				$special = key($allow);
				$this->forwardAction('wap/ForumNew/run?fid=' . $post_obj->forum->fid . ($special ? ('&special=' . $special) : ''));
			}
			//发帖权限
			if(is_array($error)){
				if($error[0] == 'permission.post.allow'){
					$stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.post.allow'){
					$stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.reply.allow'){
					$stop_action = 1;
				}
			} else if($error == 'ban'){
				$stop_action = 2;
			} else{
				$stop_action = 3;
			}
			
			//$this->showError($error);
		}

		//用户该帖回复数
		$user_reply_num = Wekit::load('thread.PwThread')->countPostByTidAndUid($tid, $this->loginUser->uid);
		//管理员组不受限制
		if(array_key_exists($this->loginUser->info['groupid'], $this->groups_arr)){
    		$user_reply_num = 0;
    	}
		
        $this->setOutput($prev_fid, 'prev_fid');
		$this->setOutput($tid, 'tid');
		$this->setOutput($threadDisplay->fid, 'fid');
		$this->setOutput($pwforum, 'pwforum');
		$this->setOutput($threadDisplay, 'threadDisplay');
		$this->setOutput($threadInfo, 'threadInfo');
		$this->setOutput($userInfo, 'userInfo');
		$this->setOutput($activity_content_screen, 'activity_content_screen');
		$this->setOutput($readdb, 'readdb');
		$this->setOutput($hot_readdb, 'hot_readdb');
		$this->setOutput($threaddb, 'threaddb');
		$this->setOutput($seachLike, 'seachLike');
		$this->setOutput(time(), 'time');
		$this->setOutput($stop_action, 'stop_action');
		$this->setOutput($user_reply_num, 'user_reply_num');
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');


		//貌似是分页
		$this->setOutput($threadDisplay->page, 'page');
		$this->setOutput($threadDisplay->perpage, 'perpage');
		$this->setOutput($threadDisplay->total, 'count');
		$this->setOutput($threadDisplay->maxpage, 'totalpage');
		$this->setOutput($threadDisplay->getUrlArgs(), 'urlargs');
		$this->setOutput($threadDisplay->getUrlArgs('desc'), 'urlDescArgs');
		$this->setOutput($this->loginUser->getPermission('look_thread_log', $isBM, array()), 'canLook');
		$this->setOutput($this->_getFpage($threadDisplay->fid), 'fpage');

		$this->setTemplate('community_game_post');

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setDefaultSeo($lang->getMessage('SEO:bbs.read.run.title'), '', $lang->getMessage('SEO:bbs.read.run.description'));
		$seoBo->init('bbs', 'read');
		$seoBo->set(
			array(
				'{forumname}' => $threadDisplay->forum->foruminfo['name'], 
				'{title}' => $threadDisplay->thread->info['subject'], 
				'{description}' => Pw::substrs(strip_tags($threadDisplay->thread->info['content']), 100, 0, false), 
				'{classfication}' => $threadDisplay->thread->info['topic_type'], 
				'{tags}' => $threadInfo['tags'],
				'{page}' => $threadDisplay->page
			)
		);
		Wekit::setV('seo', $seoBo);
	}

	//评论详情
	public function postDetailAction(){
		$tid = intval($this->getInput('tid'));		//帖子id
		$pid = intval($this->getInput('pid'));		//回复id
		$page = intval($this->getInput('page'));		//页码
		$ajax = $this->getInput('ajax', 'get');		//是否是ajax加载
		$page = is_int($page) && $page >0 ? $page : 1;
		$perpage = 20;
		if($pid < 1){
			header('location:index.php');
			exit;
		}

		if(!$this->loginUser->isExists()){
			header('location:index.php?m=wap&c=login');
			exit;
		}

		//获取管理组数据
		$this->groups_arr = Wekit::load('usergroup.PwUserGroups')->getGroupsByTypeInUpgradeOrder('system');

		$threadDisplay = new PwThreadDisplay($tid, $this->loginUser);
		$this->runHook('c_read_run', $threadDisplay);		//屏蔽字符

		//回复详情(个数、偏移量、升序排列、上级回复id、热门排序、回复id)
        $readdb = $threadDisplay->thread->getRepliesGroup(1, 0, false, 0, flase, $pid);

        foreach ($readdb as $key=>$value) {
        	//隐藏评论
        	if($value['hide_other'] == 1 && $value['created_userid'] != $this->loginUser->uid){
        		unset($readdb[$key]);
        		continue;
        	}
        	//一级回复数据加工
        	//屏蔽字符
        	$readdb[$key] = $threadDisplay->runWithFilters('bulidRead', $value);
        	$readdb[$key]['seachLike'] = $this->seachLike(2, $value['pid']);

        	//昵称
        	$readdb[$key]['created_username'] = $this->systemUserName($value['created_userid'], $value['created_username']);

			//下面有回复时
			if($value['replies'] > 0){
				//获取二级级回复，降序排序
				$readdb[$key]['replies_list'] = $threadDisplay->thread->getRepliesGroup($perpage, ($page-1)*$perpage, false, $value['pid']);
			}
		}

		foreach($readdb as $key=>$value){
        	//二级回复数据加工
        	if($value['replies_list']){
        		foreach($value['replies_list'] as $kk=>$vv){
        			//隐藏评论
		        	if($vv['hide_other'] == 1 && $vv['created_userid'] != $this->loginUser->uid){
		        		unset($readdb[$key]['replies_list'][$kk]);
		        		continue;
		        	}
		        	
        			$readdb[$key]['replies_list'][$kk] = $this->workReplyList($threadDisplay, $vv);

					$readdb[$key]['replies_list'][$kk]['content'] = strip_tags($readdb[$key]['replies_list'][$kk]['content'], '<div><img><span><p><br/><br>');
        		}
        	}

            $readdb[$key]['content'] = $this->workReply($readdb[$key]['created_userid'], $readdb[$key]['content']);
            //提取图片
			$readdb[$key]['content_img'] = $this->getImg($readdb[$key]['content']);
			//去除评论内容里的图片
			$readdb[$key]['content'] = $this->delImg($readdb[$key]['content_img'][0], $readdb[$key]['content']);
			$readdb[$key]['content'] = strip_tags($readdb[$key]['content'], '<img><div><span><p><br/><br>');
        }

        $readdb = array_pop($readdb);

        //判断用户头像是否在审核中
    	foreach ($this->user_desc as $key => $value) {
    		if($readdb['created_userid'] == $key){
    			$readdb['headcheck'] = $value['headcheck'];
			}
    	}

        if($ajax == 'ajax'){
        	$return_arr = array(
        		'page'=>$page++,
        		'list'=>array_merge($readdb['replies_list']),
        		);

        	echo json_encode($return_arr);
        	exit;
        }

        //回帖权限
		$post_obj = $this->_getPost('reply');
		$stop_action = 0;
		if (($result = $post_obj->check()) !== true && $action!='addPic') {
			$error = $result->getError();
			
			if (is_array($error) && $error[0] == 'BBS:post.forum.allow.ttype'
			&& ($allow = $post_obj->forum->getThreadType($post_obj->user))) {
				$special = key($allow);
				$this->forwardAction('wap/ForumNew/run?fid=' . $post_obj->forum->fid . ($special ? ('&special=' . $special) : ''));
			}
			//发帖权限
			if(is_array($error)){
				if($error[0] == 'permission.post.allow'){
					$stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.post.allow'){
					$stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.reply.allow'){
					$stop_action = 1;
				}
			} else if($error == 'ban'){
				$stop_action = 2;
			} else{
				$stop_action = 3;
			}
			
			//$this->showError($error);
		}

        //var_dump($readdb);

		$this->setOutput($pid, 'pid');
		$this->setOutput($tid, 'tid');
		$this->setOutput($page, 'page');
		$this->setOutput($readdb, 'readdb');
		$this->setOutput($stop_action, 'stop_action');
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');

		$this->setTemplate('community_comment_details');

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setDefaultSeo($lang->getMessage('SEO:bbs.read.run.title'), '', $lang->getMessage('SEO:bbs.read.run.description'));
		$seoBo->init('bbs', 'read');
		$seoBo->set(
			array(
				'{forumname}' => $threadDisplay->forum->foruminfo['name'], 
				'{title}' => $threadDisplay->thread->info['subject'], 
				'{description}' => Pw::substrs($threadDisplay->thread->info['content'], 100, 0, false), 
				'{classfication}' => $threadDisplay->thread->info['topic_type'], 
				'{tags}' => $threadInfo['tags'],
				'{page}' => $threadDisplay->page
			)
		);
		Wekit::setV('seo', $seoBo);
	}

	/**
	 * 获取用户是否喜欢
	 * @param  [int] $typeid [1：帖子，2：评论]
	 * @param  [int] $fromid [帖子id或评论id]
	 * @return [string]         [description]
	 */
	private function seachLike($typeid, $fromid) {
		return $this->_getLikeService()->seachLike($this->loginUser, $typeid, $fromid);
	}

	private function _getLikeService() {
		return Wekit::load('like.srv.PwLikeService');
	}

	/**
	 * 增加喜欢
	 *
	 */
	public function doLikeAction() {
		if(!$this->loginUser->isExists()){
			echo 'login';
			exit;
		}

		$typeid = (int) $this->getInput('typeid', 'post');
		$fromid = (int) $this->getInput('fromid', 'post');

		if ($typeid < 1 || $fromid < 1) $this->showError('BBS:like.fail');
		$resource = $this->_getLikeService()->addLike($this->loginUser, $typeid, $fromid);
		
		//if ($resource instanceof PwError) $this->showError($resource->getError());
		if ($resource instanceof PwError){
			$get_err = $resource->getError();
			
			if($get_err == 'BBS:like.fail.already.liked'){		//已经喜欢过
				echo 'inlike';
				exit;
			} else if($get_err == 'BBS:like.fail.myself.post'){		//是自己的
				echo 'myself';
				exit;
			} else{
				var_dump($resource);
				exit;
			}
		}

		
		//设置日点赞数
		$redis_obj = $this->getRedis();
		$redis_obj->setLikeDayCount();

		//增加用户通知
		$params = array();
		if($typeid == 1){
			Wind::import('SRV:forum.bo.PwThreadBo');
			$threadInfo = new PwThreadBo($fromid);		//帖子信息
			$from_uid = $threadInfo->authorid;
			$params['threadId'] = $threadInfo->tid;
			$fid = $threadInfo->fid;		//版块id
		} else{
			$reply = Wekit::load('forum.PwThread')->getPost($fromid);		//回复信息
			$from_uid = $reply['created_userid'];
			$params['threadId'] = $reply['tid'];
			$params['pid'] = $reply['pid'];
			$fid = $reply['fid'];		//版块id
		}
		$params['manageUsername'] = $this->loginUser->username;
		$params['manageUserid'] = $this->loginUser->uid;
		//不发给自己赞自己的
		if($from_uid != $params['manageUserid']){
			$noticeService = Wekit::load('message.srv.PwNoticeService');
			$noticeService->sendNotice($from_uid, 'likeagree', $fromid, $params);

			//增加点赞周榜单
			$redis_obj->setUserForumLike($fid, $from_uid);
		}


		$needcheck = false;
		if($resource['extend']['needcheck'])  $needcheck = false;
		$data['likecount'] = $resource['likecount'];		//点赞总数
		$data['needcheck'] = $needcheck;
		
		echo 'success';
		exit;
	}

	//加工图片数据
	public function workImg($attach){
		if(!is_array($attach) || !$attach){
			return array();
		}

		$new_attach = array();
		foreach($attach as $key=>$value){
			//图片过大放缩略图
			if($value['ifthumb'] == 3){
				$new_attach[] = $value['miniUrl'];
			} else{
				$new_attach[] = $value['url'];
			}		
        }

        return $new_attach;
	}

	//加工评论数组
	public function workReplyList(PwThreadDisplay $threadDisplay, $reply_list){
		//屏蔽字符
		$reply_list = $threadDisplay->runWithFilters('bulidRead', $reply_list);

		//昵称
		$reply_list['created_username'] = $this->systemUserNameReply($reply_list['created_userid'], $reply_list['created_username']);

    	//没有二次回复
    	if(strpos($reply_list['content'], '[/quote2]') === false){
    		$reply_list['created_username'] .= '：';
    	}

    	$reply_list['content'] = $this->workReply($reply_list['created_userid'], $reply_list['content'], true);
    	//提取图片
		$reply_list['content_img'] = $this->getImg($reply_list['content']);

		return $reply_list;
	}

	//加工评论数据
	public function workReply($user_id, $content, $br_add = false){
		//禁言检查
		$user_arr = $this->getUserDesc($user_id);
		if($user_arr[$user_id]['groupid'] == '6'){
			return '用户被禁言,该主题自动屏蔽!';
		}

		if(strpos($content, '[/quote]') !== false){
			$content_arr = explode('[/quote]', $content);
			$content = $content_arr[1];
		}

		//加工二次回复的回复
		if(strpos($content, '[/quote2]') !== false){
			$content_arr = explode('[/quote2]', $content);
			$content = '<span class="the_content">'.$content_arr[1].'</span>';

			$re_data = explode('[quote2]', $content_arr[0]);
			$replyid = $re_data[1];
			$reply_post = Wekit::load('thread.PwThread')->getPost($replyid);
			//昵称
			$reply_post['created_username'] = $this->systemUserNameReply($reply_post['created_userid'], $reply_post['created_username']);

			$re_content = '<span class="the_replies">回复</span>&nbsp;<span class="user-name">'.$reply_post['created_username'].'：</span><br/>';
			$content = $re_content.$content;
		} else if($br_add){
			$content = '<br/>'.$content;
		}

		preg_match_all("/<div.*?class=\"J_video\".*?data-url=\"(.*?)\".*?>/i",$content,$matches);
        if(isset($matches[1]) && is_array($matches[1])){
            $urls = $matches[1];
            foreach($urls as $k=>$v){
                $urls[$k] = preg_replace(array("/javascript:/i","/>|<|\(|\)|(\\\\x)|\s/i"),array('',''),$v);
            }
            $content = str_replace($matches[1],$urls,$content);
        }
        return htmlspecialchars_decode($content);
    }

    //提取图片
    public function getImg($content){
    	$img_arr = array();
		preg_match_all('/<img.+?src="(.+?)"/s', $content, $img_arr);
		$content = $img_arr[1];
		foreach ($content as $key => $value) {
			//表情
			if(strpos($value, 'res/images/emotion/') !== false){
				unset($content[$key]);
				continue;
			}
		}
		return array_merge($content);
    }

    //去除固定src的img
    public function delImg($url, $content){
    	$content = str_replace('<img src="'.$url.'">', '', $content);
    	$content = str_replace('<img src="'.$url.'" title="趣炫游戏" alt="趣炫游戏">', '', $content);
    	return $content;
    }

	//获取显示的用户名称和样式
    public function systemUserName($user_id, $username){
    	$created_info = Wekit::load('user.PwUser')->getUserByUid($user_id, PwUser::FETCH_ALL);
    	if($created_info['nickname'] != ''){
    		$username = $created_info['nickname'];
    	} else{
    		$username = mb_substr($username , 0 , 2, 'utf-8').'****'.mb_substr($username , -2 , mb_strlen($username,'utf8'), 'utf-8');
    	}
    	if(array_key_exists($created_info['groupid'], $this->groups_arr)){
    		$username = '<span class="official-icon" style="float:none;">官方</span><span style="color:#1ea4f2; font-size:1em;">'.$username.'</span>';
    	}
    	return $username;
    }

    public function systemUserNameReply($user_id, $username){
    	$created_info = Wekit::load('user.PwUser')->getUserByUid($user_id, PwUser::FETCH_ALL);
    	if($created_info['nickname'] != ''){
    		$username = $created_info['nickname'];
    	} else{
    		$username = mb_substr($username , 0 , 2, 'utf-8').'****'.mb_substr($username , -2 , mb_strlen($username,'utf8'), 'utf-8');
    	}
    	if(array_key_exists($created_info['groupid'], $this->groups_arr)){
    		$username = '<span style="color:#1ea4f2; font-size:1em;">'.$username.'</span>';
    	}
    	return $username;
    }

    //不重复获取回复用户信息
    public function getUserDesc($user_id){
    	foreach ($this->user_desc as $key => $value) {
    		if($key == $user_id){
    			return $this->user_desc;
    		}
    	}

    	$users = Wekit::load('user.PwUser')->fetchUserByUid(array($user_id), 5);

    	$this->user_desc += $users;
    	return $this->user_desc;
    }


    private function _getPost($action) {
		switch ($action) {
			case 'reply':
			case 'doreply':
				$tid = $this->getInput('tid');
				Wind::import('SRV:forum.srv.post.PwReplyPost');
				$postAction = new PwReplyPost($tid);
				break;
			case 'modify':
			case 'domodify':
				$tid = $this->getInput('tid');
				$pid = $this->getInput('pid');
				if ($pid) {
					Wind::import('SRV:forum.srv.post.PwReplyModify');
					$postAction = new PwReplyModify($pid);
				} else {
					Wind::import('SRV:forum.srv.post.PwTopicModify');
					$postAction = new PwTopicModify($tid);
				}
				break;
			default:
				$fid = $this->getInput('fid');
				$special = $this->getInput('special');
				Wind::import('SRV:forum.srv.post.PwTopicPost');
				$postAction = new PwTopicPost($fid);
				$special && $postAction->setSpecial($special);
		}
		return new PwPost($postAction);
	}
			
}	