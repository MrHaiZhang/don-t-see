<?php
defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('SRV:forum.bo.PwForumBo');
Wind::import('SRV:forum.srv.PwThreadList');
Wind::import('SRV:forum.srv.PwThreadDisplay');
Wind::import('SRV:credit.bo.PwCreditBo');
Wind::import('SRV:forum.srv.PwPost');

/**
 * 版块首页
 * form src\applications\bbs\controller\ForumController.php
 * form src\applications\bbs\controller\ThreadController.php
 * form src\applications\space\controller\PunchController.php
 * 2017.09.29
 */
class OneGameController extends PwBaseController {

	protected $config = array();
	protected $perpage = 20;
	protected $_creditBo;
	public $user_desc = array();

	public function run() {

		$gid = intval($this->getInput('gid'));		//官网游戏id
		$fid = intval($this->getInput('fid'));		//版块id

		if($fid < 1){
			$forumDs = Wekit::load('forum.PwForum');
			$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN);
			foreach($list as $key => $value){
				$value['game_id'] == $gid && $fid = $key;
			}
		}
		
		$page = $this->getInput('page', 'get');		//页数
		$orderby = $this->getInput('orderby', 'get');		//排序
		$ajax = $this->getInput('ajax', 'get');		//ajax
		//版块信息
		$pwforum = new PwForumBo($fid, true);
		$pwforum->foruminfo['get_url'] = $pwforum->foruminfo['get_url'] ? json_decode($pwforum->foruminfo['get_url'], true) : array();
		if($pwforum->fid == 0){
			header('location:index.php');
			exit;
		}
		
		$countUserByFid = $pwforum->isIn();		//该版块关注用户数
		$countThreadsByFid = $pwforum->foruminfo['threads'];		//该版块发帖数

		//帖子列表
		$threadList = new PwThreadList();
		$threadList->setPage($page)
			->setPerpage(Wekit::C('bbs', 'thread.perpage'))
			->setIconNew($pwforum->foruminfo['newtime']);
		
		//排序,默认热门贴子，hotpost热门贴子
		$orderby = $orderby != 'postdate' ? 'hotpost' : 'postdate';
		Wind::import('SRV:forum.srv.threadList.PwCommonThread');
		$dataSource = new PwCommonThread($pwforum, $orderby);
		$dataSource->setUrlArg('orderby', $orderby);

		//公告帖子列表
		if($ajax != 'ajax'){
			$notice_list = $dataSource->getNoticeData();
			foreach ($notice_list as $key => $value) {
				$notice_list[$key]['extend'] = json_decode($value['extend'], true);
			}
			$this->setOutput($notice_list, 'notice_list');
		}

		$threadList->execute($dataSource);
		$threaddb = $threadList->getList();
		$page = $threadList->page;

		$page_count = ceil($threadList->total/Wekit::C('bbs', 'thread.perpage'));

		//获取用户被压贴的帖子
		$threadsDaoObj = Wekit::loadDaoFromMap(3, array(
			1	=> 'forum.dao.PwThreadsDao',
			2	=> 'forum.dao.PwThreadsContentDao'
		), 'PwThread');
		$suppressList = $threadsDaoObj->getThreadByUidSuppress($this->loginUser->uid);
		$threadList->total += count($suppressList);

		//获取帖子内容
		if(is_array($threaddb)){
			//去除被压贴的帖子
			foreach($threaddb as $k=>$v){
				if($v['created_time'] > $v['lastpost_time']){
					unset($threaddb[$k]);
				}
			}
			$threaddb = array_values($threaddb);
			
			//将用户被压贴的帖子按创建时间放入帖子列表
			$_iconHot = Wekit::C('bbs', 'thread.hotthread_replies');
			for($i = 0; $i < count($threaddb); $i++){
				$count = count($threaddb);

				if($i == 0){
					$lastpost_time_next = $threaddb[$i]['lastpost_time'];
					if($page != 1){
						$threadList_prev = $threadList->setPage($page-1);
						$threadList_prev->execute($dataSource);
						$threaddb_prev = $threadList_prev->getList();
						$lastpost_time_prev = $threaddb_prev[count($threaddb_prev)-1]['lastpost_time'];
					}

				} else{
					$lastpost_time_next = $threaddb[$i]['lastpost_time'];
					$lastpost_time_prev = $threaddb[$i-1]['lastpost_time'];
				}

				!$lastpost_time_prev && $lastpost_time_prev = 9999999999;

				foreach($suppressList as $kk=>$vv){
					
					$continue_tf = true;
					if($vv['created_time'] > $lastpost_time_next && $vv['created_time'] <= $lastpost_time_prev){
						$continue_tf = false;
					}

					if($continue_tf){
						continue;
					}

					if(($orderby != 'hotpost' || $vv['replies'] >= $_iconHot) && $vv['created_userid'] == $this->loginUser->uid){
						while ($count > $i) {
							$threaddb[$count] = $threaddb[$count-1];
							$count--;
						}
						$threaddb[$count] = $vv;
						$count = count($threaddb);
						$i++;
					}
				}
			}
			$threadList->setPage($page);

			foreach($threaddb as $k=>$v){
				//用户信息
				$user_arr = $this->getUserDesc($v['created_userid']);
				//昵称
        		$threaddb[$k]['created_username'] = $this->systemUserName($v['created_userid'], $v['created_username']);
        		//扩展信息
        		$threaddb[$k]['extend'] = json_decode($v['extend'], true);

				if($threaddb[$k]['ifshield'] == 1){
					$threaddb[$k]['content'] = '此帖已屏蔽';
					$threaddb[$k]['content_img'] = array();
				} else{
					$threaddb[$k]['content'] = $this->workReply($threaddb[$k]['content']);
					//提取图片
					$img_arr = array();
					preg_match_all('/<img.+?src="(.+?)"/s', $threaddb[$k]['content'], $img_arr);
					$threaddb[$k]['content_img'] = $img_arr[1];
					//缩略图
					foreach ($threaddb[$k]['content_img'] as $kkk => $vvv) {
						//表情
						if(strpos($vvv, 'res/images/emotion/') !== false){
							unset($threaddb[$k]['content_img'][$kkk]);
							continue;
						}

						$threaddb[$k]['content'] = str_replace('<img src="'.$vvv.'">', '', $threaddb[$k]['content']);

						$content_img_arr = explode('.', $vvv);
						$content_min_img = $content_img_arr[0].'_min.'.$content_img_arr[1];
						if(file_exists($_SERVER['DOCUMENT_ROOT'].$content_min_img)){
							$threaddb[$k]['content_img'][$kkk] = $content_min_img;
						}
					}

					$threaddb[$k]['content'] = strip_tags($threaddb[$k]['content'], '<img>');
				}
			}

			//判断用户头像是否在审核中
	        foreach ($threaddb as $key => $value) {
	        	foreach ($this->user_desc as $kk => $vv) {
	        		if($value['created_userid'] == $kk){
	        			$threaddb[$key]['headcheck'] = $vv['headcheck'];
					}
	        	}
	        }
		}

		if($ajax == 'ajax'){
			foreach($threaddb as $key=>$value){
	        	//一级回复数据加工,这些类似js加载，只能在页面初始化时使用
	        	if($value['headcheck'] == 1){
	        		$threaddb[$key]['created_userimg'] = Pw::getAvatar(0).'?'.time();
	        	} else{
	        		$threaddb[$key]['created_userimg'] = Pw::getAvatar($threaddb[$key]['created_userid']).'?'.time();
	        	}
	        }

			$return_list = array(
				'page'=>$threadList->page,
				'page_count'=>$page_count,
				'total'=>$threadList->total,
				'list'=>$threaddb
				);
			echo json_encode($return_list);
			exit;
		}

		$redis_obj = $this->getRedis();
		$redis_obj->setForumCount($fid);		//设置专区日访问人数

		$user_punch = 0;

		$frist_in = 1;

		//未读总数
		if($this->loginUser->uid > 0){
			$redis_obj->setUserMsg($this->loginUser->username);		//更新用户信息缓存

			$unreadCount = $this->_getNoticeDs()->getTypeUnreadNoticeCount($this->loginUser->uid, 'all');
			$unreadCount > 99 && $unreadCount = 99;
			$unreadCount == '' && $unreadCount = 0;

			$userInfo = Wekit::load('user.PwUser')->getUserByUid($this->loginUser->uid, 7);
			if($userInfo['nickname'] != ''){
				$userInfo['username'] = $userInfo['nickname'];
			}

			//一周打卡次数
			$user_punch = $redis_obj->getUserPunch($this->loginUser->uid);
			//array_key_exists($userInfo['uid'], $user_punch_list) && $user_punch = $user_punch_list[$userInfo['uid']];
			

			//今日是否打卡
			$punchData = unserialize($userInfo['punch']);
			$havePunch = $this->_getPunchService()->isPunch($punchData);

			//用户进入帖子列表记录
			$frist_in = $redis_obj->getUserFristInThreadListTF($this->loginUser->uid);
			if(!$frist_in){
				$redis_obj->setUserFristInThreadList($this->loginUser->uid);
			}
		}

		$anchor = $_GET['anchor'];

		//发帖权限
		$post_obj = $this->_getPost('run');
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

		//获取游戏开服列表
		$url = '';
		$open_url_arr = array(
			8=>'http://manager.tcenter.q-dazzle.com/api/get_new_server_info.php',
			13=>'http://manager.hyj.q-dazzle.com/api/get_new_server_info.php',
			14=>'http://manager.mhj.q-dazzle.com/api/get_new_server_info.php',
			16=>'http://manager.shuj.q-dazzle.com/api/get_new_server_info.php',
			18=>'http://3kloginwzzgsy.geiniwan.com/game/api/qx_server_list.php',
			21=>'http://manager.tsq.s12.q-dazzle.com/wx/quxuan/api.php?type=getServerOpenTime',
		);
		$url = $open_url_arr[$pwforum->foruminfo['game_id']];
		$ng_open_list = $redis_obj->getNGOpenList();
		if($url != ''){
			$post_arr = array(
				'game_id'=>1,
			);
			$api_key = 'XRCeW4ny7eMjCzuvXRCeW4ny7eMjCzuv';                   #私钥
			$ticket = $this->commonCheckTicket($post_arr,'ticket',$api_key);          
			$post_arr['ticket'] = $ticket;
			$open_arr = json_decode($this->sample_curl($url,$post_arr), true);
			$open_str = '';

			//显示现在到后天之前的开服信息
			if($open_arr['state'] == '1'  && count($open_arr['result']) > 0){
				$time = Pw::getTime();
				foreach($open_arr['result'] as $key=>$value) {
					if($value['openday'] >= strtotime(date('Y-m-d'), $time) && $value['openday'] <= strtotime(date('Y-m-d'), $time)+60*60*24*2){
						$stop_state = 1;
		            	foreach ($ng_open_list as $kk => $vv) {
		            		$ng_arr = explode('_', $vv);
		            		if($ng_arr[0] == $value['plat_cname'] && $ng_arr[1] == $pwforum->foruminfo['game_id'] && $ng_arr[2] == $value['server_id']){
				    			$stop_state = 2;
				    		}
		            	}

		            	if($pwforum->foruminfo['game_id'] == 14){
		            		$server_id = str_replace('服', '', $value['server_name']);
		            		$server_id = $server_id*1-5;
		            		$value['server_name'] = $server_id.'服';
		            	}

		            	//如果没有未开服信息，则显示前一个已开服信息
		            	if($value['openday'] < $time && $old_open_str == ''){
		            		$stop_state == 1 && $old_open_str = '-----'.$value['server_name'].' '.$value['title'].' '.date('Y-m-d H:i', $value['openday']).'开服';
		            	} else{
		            		$stop_state == 1 && $open_str .= '-----'.$value['server_name'].' '.$value['title'].' '.date('Y-m-d H:i', $value['openday']).'开服';
		            	}
					}
				}
				$open_str == '' && $open_str .= $old_open_str;
			}
		}
		
		if($this->loginUser->username){
			Wind::import('SRV:wap.HomeRequest');
			$home_request = new HomeRequest();
			$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));
		}
		
		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setOutput($this->loginUser, 'loginUser');
		$this->setOutput($threadList, 'threadList');
		$this->setOutput($threadList->page, 'page');
		$this->setOutput($threaddb, 'threaddb');
		$this->setOutput($fid, 'fid');
		$this->setOutput($pwforum, 'pwforum');
		$this->setOutput($countUserByFid, 'countUserByFid');
		$this->setOutput($countThreadsByFid, 'countThreadsByFid');
		$this->setOutput($unreadCount, 'unreadCount');
		$this->setOutput($userInfo, 'userInfo');
		$this->setOutput($user_punch, 'user_punch');
		$this->setOutput($havePunch, 'havePunch');
		$this->setOutput($frist_in, 'frist_in');
		$this->setOutput($stop_action, 'stop_action');
		$this->setOutput($open_str, 'open_str');
		//锚点
		$this->setOutput($anchor, 'anchor');
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');

		$this->setTemplate('community_game_community');


		//seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setDefaultSeo($lang->getMessage('SEO:bbs.thread.run.title'), '', $lang->getMessage('SEO:bbs.thread.run.description'));
		$seoBo->init('bbs', 'thread', $fid);
		$seoBo->set(array(
			'{forumname}' => $pwforum->foruminfo['name'],
			'{forumdescription}' => Pw::substrs($pwforum->foruminfo['descrip'], 100, 0, false),
			'{classification}' => $this->_getSubTopictypeName($type),
			'{page}' => $threadList->page
		));
		Wekit::setV('seo', $seoBo);
	}

	//设置模块日点击量
	public function setModelAction(){
		$model_id = $this->getInput('model_id', 'post');
		$redis_obj = $this->getRedis();
		$redis_obj->setModelCount($model_id);
		exit;
	}
	
	/** 
	 * 自己打卡
	 *
	 */
	public function punchAction() {
		if ($this->loginUser->uid < 1) {
			echo 'login';
			exit;
		}
		$this->config = Wekit::C()->getValues('site');
		$this->_creditBo = PwCreditBo::getInstance();
		
		// 是否开启
		if(!$this->config['punch.open']){
			echo 'unopen';
			exit;
		}

		$userInfo = $this->loginUser->info;
		// 是否自己打过了
		if ($userInfo['punch']) {
			$punchData = unserialize($userInfo['punch']);
			$havePunch = $this->_getPunchService()->isPunch($punchData);
			if ($havePunch) {
				//已经打卡
				if($punchData['username'] == $userInfo['username']){
					echo 'punched';
					exit;
				}
				$helpPunch = 1;
			}
		}
		// 奖励积分数
		$reward = $this->config['punch.reward'];
		$behavior = $this->_getUserBehaviorDs()->getBehavior($userInfo['uid'],'punch_day');
		$steps = $behavior['number'] > 0 ? $behavior['number']: 0;
		$helpPunch && $steps = $steps - 1 > 0 ? $steps - 1 : 0;
		$awardNum = $reward['min'];
		$steps && $awardNum = ($reward['min'] + $steps * $reward['step'] > $reward['max']) ? $reward['max'] : $reward['min'] + $steps * $reward['step'];
		if ($havePunch) {
			$reduce = $awardNum - $this->config['punch.friend.reward']['rewardMeNum'];
			$awardNum = $reduce > 0 ? $reduce : 0;
		}
		$behaviorNum = $havePunch ? $behavior['number'] : $behavior['number']+1;
		// 更新用户数据，记录行为
		$result = $this->_punchBehavior($userInfo,$awardNum,$behaviorNum);
		if ($result instanceof PwError) {
			$this->showError($result->getError());
		}
		// 奖励积分
		if ($awardNum) {
			$this->_creditBo->addLog('punch', array($reward['type']=>$awardNum), $this->loginUser,  array(
				'cname' => $this->_creditBo->cUnit[$reward['type']],
				'affect' => $awardNum)
			);
			$this->_creditBo->set($userInfo['uid'],$reward['type'],$awardNum);
		}
		
		
		// 查七天签到奖励
		$week_num = 0;
		$taskDs = Wekit::load('task.PwTaskUser');
		//查询是位与运算
		$count = $taskDs->countMyTasksByStatus($this->loginUser->uid, 7);
		$list = array();
		if ($count > 0) {
			$totalPage = ceil($count/100);
			$page = $page < 1 ? 1 : ($page > $totalPage ? intval($totalPage) : $page);
			/*@var $taskService PwTaskService */
			$taskService = Wekit::load('task.srv.PwTaskService');
			$list = $taskService->getMyTaskListWithStatu($this->loginUser->uid, 7, $page, 100);
		}

		foreach ($list as $key => $value) {
			if($value['conditions']['child'] == 'punch' && (date('Ymd', $value['finish_time']) == date('Ymd', time()))){
				$week_num = $value['reward']['num'];
				break;
			}
		}

		$result = array(
			'behaviornum' => $havePunch ? $behavior['number'] : $behavior['number']+1,
			'reward' => ($awardNum+$week_num). $this->_creditBo->cUnit[$this->config['punch.reward']['type']] . $this->_creditBo->cType[$this->config['punch.reward']['type']]
		);

		//加入版块
		$join_statu = $this->joinAction();

		echo json_encode(array('state' => 'success', 'data' => $result));
		exit;
		//Pw::echoJson(array('state' => 'success', 'data' => $result));exit;
	}

	/** 
	 * 打卡 - 更新用户数据
	 *
	 * @param int $uid 	
	 * @return bool
	 */
	private function _punchBehavior($userInfo,$awardNum,$behaviorNum = '') {
		$reward = $this->config['punch.reward'];
		$punchData = array(
			'username' => $this->loginUser->username,
			'time' => Pw::getTime(),
			'cNum' => $awardNum,
			'cUnit' => $this->_creditBo->cUnit[$reward['type']],
			'cType' => $this->_creditBo->cType[$reward['type']],
			'days'  => $behaviorNum,
		);

		// 更新用户data表信息
		Wind::import('SRV:user.dm.PwUserInfoDm');
		$dm = new PwUserInfoDm($userInfo['uid']);
		$dm->setPunch($punchData);
		//打卡总数
		$dm->setPunchNum($userInfo['punch_num']+1);
		$this->_getUserDs()->editUser($dm, PwUser::FETCH_DATA);

		//设置用户签到数
		$redis_obj = $this->getRedis();
		$redis_obj->setUserPunch($userInfo['uid']);
		$redis_obj->setUserPunchIp($this->getRequest()->getClientIp());

		//日签到总数
		$redis_obj->setPunchDayCount();
		
		//埋点[s_punch]
		PwSimpleHook::getInstance('punch')->runDo($dm);
		
		//记录行为
		return $this->_getUserBehaviorDs()->replaceBehavior($userInfo['uid'],'punch_day',$punchData['time']);
	}

	/**
	 * 加入版块
	 */
	public function joinAction() {
		//验证是否登录
		if (!$this->loginUser->isExists()) {
			echo 'login';
			exit;
		}

		$fid = $this->getInput('fid', 'get');
		if (!$fid) {
			$this->showError('operate.fail');
		}

		Wind::import('SRV:forum.bo.PwForumBo');
		$forum = new PwForumBo($fid);
		if (!$forum->isForum()) {
			$this->showError('BBS:forum.exists.not');
		}
		if (!$this->loginUser->isExists()) {
			$this->showError('login.not');
		}
		if (Wekit::load('forum.PwForumUser')->get($this->loginUser->uid, $fid)) {
			//已加入
			return 'already';
			$this->showError('BBS:forum.join.already');
		}
		Wekit::load('forum.PwForumUser')->join($this->loginUser->uid, $fid);
		$this->_addJoionForum($this->loginUser->info, $forum->foruminfo);
		//$this->showMessage('success');
		return 'success';
	}

	/**
	 * 退出版块
	 */
	public function quitAction() {
		//验证是否登录
		if (!$this->loginUser->isExists()) {
			echo 'login';
			exit;
		}
		
		$fid = $this->getInput('fid', 'get');
		if (!$fid) {
			$this->showError('operate.fail');
		}

		Wind::import('SRV:forum.bo.PwForumBo');
		$forum = new PwForumBo($fid);
		if (!$forum->isForum()) {
			$this->showError('BBS:forum.exists.not');
		}
		if (!$this->loginUser->isExists()) {
			$this->showError('login.not');
		}
		if (!Wekit::load('forum.PwForumUser')->get($this->loginUser->uid, $fid)) {
			$this->showError('BBS:forum.join.not');
		}
		Wekit::load('forum.PwForumUser')->quit($this->loginUser->uid, $fid);
		$this->_removeJoionForum($this->loginUser->info, $fid);
		//$this->showMessage('success');
		echo 'success';
		exit;
	}

	/**
	 * 格式化数据  把字符串"1,版块1,2,版块2"格式化为数组
	 *
	 * @param string $string
	 * @return array
	 */
	public static function splitStringToArray($string) {
		$a = explode(',', $string);
		$l = count($a);
		$l % 2 == 1 && $l--;
		$r = array();
		for ($i = 0; $i < $l; $i+=2) {
			$r[$a[$i]] = $a[$i+1];
		}
		return $r;
	}

	/**
	 * 加入版块 - 更新我的版块缓存数据
	 *
	 * @param array $userInfo
	 * @param array $foruminfo
	 * @return boolean
	 */
	private function _addJoionForum($userInfo,$foruminfo) {
		// 更新用户data表信息
		$array = array();
		$userInfo['join_forum'] && $array = self::splitStringToArray($userInfo['join_forum']);
		
		$array = array($foruminfo['fid'] => $foruminfo['name']) + $array;
		count($array) > 20 && $array = array_slice($array, 0, 20, true);
		
		$this->_updateMyForumCache($userInfo['uid'], $array);
		return true;
	}
	
	/**
	 * 推出版块 - 更新我的版块缓存数据
	 *
	 * @param array $userInfo
	 * @param int $fid
	 * @return boolean
	 */
	private function _removeJoionForum($userInfo,$fid) {
		// 更新用户data表信息
		$userInfo['join_forum'] && $array = self::splitStringToArray($userInfo['join_forum']);
		unset($array[$fid]);
		
		$this->_updateMyForumCache($userInfo['uid'], $array);
		return true;
	}

	private function _updateMyForumCache($uid, $array) {
		$joinForums = Wekit::load('forum.srv.PwForumService')->getJoinForum($uid);
		$_tmpArray = array();
		foreach ($array as $k => $v) {
			if (!isset($joinForums[$k])) continue;
			$_tmpArray[$k] = strip_tags($joinForums[$k]);
		}
		
		Wind::import('SRV:user.dm.PwUserInfoDm');
		$dm = new PwUserInfoDm($uid);
		$dm->setJoinForum(self::_formatJoinForum($_tmpArray));
		return $this->_getUserDs()->editUser($dm, PwUser::FETCH_DATA);	
	}

	/**
	 * 格式化我的版块缓存数据结构
	 *
	 * @param array $array 格式化成"1,版块1,2,版块2"
	 * @return string
	 */
	private static function _formatJoinForum($array) {
		if (!$array) return false;
		$user = '';
		foreach ($array as $fid => $name) {
			$myForum .= $fid . ',' . $name . ',';
		}
		return rtrim($myForum,',');
	}

	/**
	 * @return PwUser
	 */
	private function _getUserDs(){
		return Wekit::load('user.PwUser');
	}
	
	/**
	 * @return PwForum
	 */
	private function _getForumService() {
		return Wekit::load('forum.PwForum');
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

	//加工评论数据
	public function workReply($content){
		if(strpos($content, '[/quote] ') !== false){
			$content_arr = explode('[/quote]', $content);
			$content = $content_arr[1];
		}

		preg_match_all("/<div.*?class=\"J_video\".*?data-url=\"(.*?)\".*?>/i",$content,$matches);
        if(isset($matches[1]) && is_array($matches[1])){
            $urls = $matches[1];
            foreach($urls as $k=>$v){
                $urls[$k] = preg_replace(array("/javascript:/i","/>|<|\(|\)|(\\\\x)|\s/i"),array('',''),$v);
            }
            $content = str_replace($matches[1],$urls,$content);
        }

        $wordFilter = Wekit::load('SRV:word.srv.PwWordFilter');
		$filter_content = $wordFilter->replaceWord($content);
		if ($filter_content !== false) $content = $filter_content;
        return htmlspecialchars_decode($content);
    }

    protected function _getNoticeDs(){
		return Wekit::load('message.PwMessageNotices');
	}

	/**
	 * PwUserBehavior
	 * 
	 * @return PwUserBehavior
	 */
	private function _getUserBehaviorDs() {
		return Wekit::load('user.PwUserBehavior');
	}

	/**
	 * PwPunchService
	 * 
	 * @return PwPunchService
	 */
	private function _getPunchService(){
		return Wekit::load('space.srv.PwPunchService');
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

    /**
	 * 游戏开服签名
	 * @param  array  $data       传递的数据
	 * @param  string  $sign_name   类型，如ticket
	 * @param  string  $private_key 私钥
	 * @param  boolean $is_debug    是否开启调试模式
	 * @return string               验签后字符串
	 */
	public function commonCheckTicket($data, $sign_name, $private_key, $is_debug = false){
		if( empty($data) ) return false;
		unset($data[$sign_name]);
		ksort($data);

		$md5_str = http_build_query($data) . $private_key;
		if( $is_debug ) {
			$json = array(
				'md5_str' 	=> $md5_str,
				$sign_name	=> md5($md5_str),
			);
			die(json_encode($json));
		}
		$ticket = md5($md5_str);
		return $ticket;
	}

	public function sample_curl($url, $post_arr = array(), $timeout = 10){
		$curl = curl_init($url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, $post_arr);
		curl_setopt($curl, CURLOPT_TIMEOUT, $timeout);
		$content = curl_exec($curl);
		curl_close($curl);
		return $content;
	}
}