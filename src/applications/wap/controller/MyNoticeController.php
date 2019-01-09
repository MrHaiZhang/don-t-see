<?php

/**
 * 手机端个人消息
 * form src\applications\message\controller\NoticeController.php
 * 2017.10.30
 */
class MyNoticeController extends PwBaseController {
	public $groups_arr = array();
	public $user_desc = array();		//用户信息

	public function beforeAction($handlerAdapter){
		parent::beforeAction($handlerAdapter);
		if (!$this->loginUser->isExists()) {
			$this->forwardRedirect(WindUrlHelper::createUrl('u/login/run'));
		}
		$action = $handlerAdapter->getAction();
		$controller = $handlerAdapter->getController();
		$this->setOutput($action,'_action');
		$this->setOutput($controller,'_controller');
	}

	public function run() {
		$ajax = $this->getInput('ajax', 'get');

		list($type,$page) = $this->getInput(array('type','page'));
		$page = intval($page);
		$page < 1 && $page = 1;
		$perpage = 10;
		list($start, $limit) = Pw::page2limit($page, $perpage);

		//获取管理组数据
		$this->groups_arr = Wekit::load('usergroup.PwUserGroups')->getGroupsByTypeInUpgradeOrder('system');

		$type = $type == 'system' ? $type : $type = 'user';

		//type决定获取的通知(0:全部,3:删帖,4:勋章,5:任务,6:系统群发,10:帖子回复,15:楼层回复,17:点赞,99:积分修改)
		//需要把10和15、17合并，其他的合并
		$noticeList = $this->_getNoticeDs()->getNotices($this->loginUser->uid, $type, $start, $limit);
		$noticeList = $this->_getNoticeService()->formatNoticeList($noticeList);

		//通知总数(按分类)
		$typeCounts = $this->_getNoticeService()->countNoticesByType($this->loginUser->uid);

		//获取未读通知数(按分类)
		$u_unreadCount = $this->_getNoticeDs()->getTypeUnreadNoticeCount($this->loginUser->uid, 'user');
		$s_unreadCount = $this->_getNoticeDs()->getTypeUnreadNoticeCount($this->loginUser->uid, 'system');
		//$unreadCount = $s_unreadCount + $u_unreadCount;
		$unreadCount = $type == 'system' ? $unreadCount = $u_unreadCount : $unreadCount = $s_unreadCount;

		//设置已读
		//$this->_readNoticeList($unreadCount,$noticeList);
		//设置单类型全部已读
		$this->_readNoticeTypeList($unreadCount, $type);
		

		//count
		$u_Count = 0;
		$s_Count = 0;
		foreach($typeCounts as $key=>$value){
			if($key == 0){
				continue;
			}
			if($key == 10 || $key == 15 || $key == 17){
				$u_Count += intval($value['count']);
			} else if($key == 3 || $key == 6 || $key == 13 || $key == 14){
				$s_Count += intval($value['count']);
			}
		}

		$count = $type == 'system' ? $count = $s_Count : $count = $u_Count;
		

		//获取帖子信息
		$posts = $tids = array();
		foreach ($noticeList as $v) {
			$tids[] = $v['extend_params']['threadId'];
			if(!$v['extend_params']['pid']){
				$tids[] = $v['extend_params']['manageThreadId'];
			}
		}
		$threads = $this->_getThreadDs()->fetchThread($tids, 3);

		//敏感词替换
		$wordFiter_obj = Wekit::load('word.srv.PwWordFilter');

		foreach ($noticeList as $v) {
			$tid = $v['extend_params']['threadId'];
			$pid = $v['extend_params']['pid'];
			$rpid = $v['extend_params']['rpid'];
			//$v['threadSubject'] = Pw::substrs($threads[$v['tid']]['subject'], 30);
			//$v['content'] = Pw::substrs($v['content'], 30);
			$v['created_time'] = PW::time2str($v['modified_time'],'auto');
			
			if($v['typeid'] == 17){		//点赞
				$v['rp_post'] = $pid ? '赞了这条评论' : '赞了这个话题';
				$v['created_username'] = $v['extend_params']['manageUsername'];
				$v['created_userid'] = $v['extend_params']['manageUserid'];
			} else if($v['typeid'] == 14){		//积分信息
				$v['extend_params']['title'] = '系统消息';
				$v['extend_params']['content'] = '恭喜您获得来自【'.$v['extend_params']['action_reason'].'】的'.$v['extend_params']['num'].$v['extend_params']['credit'].'奖励，感谢您的参与，祝您游戏愉快！';
			} else if($v['typeid'] == 3){		//删帖
				if($v['extend_params']['pid']){
					$rp_data = Wekit::load('thread.PwThread')->getPost($v['extend_params']['pid']);
					$stop_content = strip_tags($this->workReply($rp_data['created_userid'], $rp_data['content']), '<img>');
					$stop_content = mb_substr($stop_content , 0 , 10, 'utf-8');
				} else{
					$stop_content = $threads[$v['extend_params']['manageThreadId']]['subject'];
				}
				$v['extend_params']['title'] = '系统消息';
				$v['extend_params']['content'] = '您发布的内容 【'.$stop_content.'】由于【'.$v['extend_params']['manageReason'].'】已被管理员'.$v['extend_params']['manageTypeString'].'，如有疑问，请联系趣炫官方客服800097987';
				
			} else if($v['typeid'] == 13){		//用户禁止
				$v['extend_params']['title'] = '系统消息';
				$type_name = $v['extend_params']['type'][0];

				if($v['extend_params']['ban'] == 2){
					$v['extend_params']['content'] = '您的帐号已被管理员解除'.$type_name.'，如有疑问，请联系趣炫官方客服800097987';
				} else{
					if($v['extend_params']['end_time'] > 0){
						$stop_time = $type_name.'至【'.date('Y-m-d H:i:s', $v['extend_params']['end_time']).'】';
					} else{
						$stop_time = '永久'.$type_name;
					}
					$v['extend_params']['content'] = '您的帐号由于【'.$v['extend_params']['reason'].'】已被管理员'.$stop_time.'，如有疑问，请联系趣炫官方客服800097987';
				}				
			} else{
				$post = Wekit::load('thread.PwThread')->getPost($pid);
				$v['rp_post'] = $this->workReply($post['created_userid'], $post['content']);
				$v['rp_post'] = strip_tags($v['rp_post'], '<img>');
				$v['rp_post'] = $wordFiter_obj->replaceWord($v['rp_post'], 0);
				$v['created_username'] = $v['extend_params']['replyUsername'];
				$v['created_userid'] = $v['extend_params']['replyUserid'];

				$v['anchor_id'] = 'post-id-'.$pid;
				$post['rpid'] > 0 && $v['anchor_id'] = 'post-id-'.$post['rpid'];
			}

			//昵称
			$v['created_username'] = $this->systemUserName($v['created_userid'], $v['created_username']);


			//点赞或回复的评论
			if($v['typeid'] == 17){
				$reply = Wekit::load('forum.PwThread')->getPost($pid);		//回复信息
				$v['reply_content'] = $this->workReply($reply['created_userid'], $reply['content']);
				$v['reply_content'] = strip_tags($v['reply_content'], '<img>');
				$v['reply_content'] = $wordFiter_obj->replaceWord($v['reply_content'], 0);

				//昵称
				if($reply['created_userid']){
					$v['reply_username'] = $this->systemUserNameThreads($reply['created_userid'], $reply['created_username']);
				}
				
				$pid > 0 && $v['anchor_id'] = 'post-id-'.$pid;
				$reply['rpid'] > 0 && $v['anchor_id'] = 'post-id-'.$reply['rpid'];
				
			}else if($pid && $v['typeid'] != 10){
				// $reply = Wekit::load('forum.PwThread')->getPost($pid);		//回复信息
				// $content_arr = $this->workReply($reply['content'], true);
				// $v['content'] = strip_tags($content_arr['content'], '<img>');

				//二次回复和回复二次回复的都要显示
				if($rpid > 0){
					$rp_data = Wekit::load('thread.PwThread')->getPost($rpid);
					$v['reply_content'] = strip_tags($this->workReply($rp_data['created_userid'], $rp_data['content']), '<img>');
					$v['reply_content'] = $wordFiter_obj->replaceWord($v['reply_content'], 0);
					//昵称
					$v['reply_username'] = $this->systemUserNameThreads($rp_data['created_userid'], $rp_data['created_username']);
				}
			}

			if($type == 'user'){
				if($this->user_desc[$v['created_userid']]['headcheck'] == 1){
					$v['created_userimg'] = Pw::getAvatar(0).'?'.time();
				} else{
					$v['created_userimg'] = Pw::getAvatar($v['created_userid']).'?'.time();
				}
			} else{
				$v['created_userimage'] = 'site_logo.jpg';
			}

			$v['threadSubject'] = $threads[$tid]['subject'];		//帖子标题
			$v['threadUsername'] = $threads[$tid]['created_username'];		//帖子发起人
			$v['threadContent'] = $this->workReply($threads[$tid]['created_userid'], $threads[$tid]['content']);		//帖子内容
			$v['threadContent'] = $wordFiter_obj->replaceWord($v['threadContent'], 0);

			//昵称
			$v['threadUsername'] = $this->systemUserNameThreads($threads[$tid]['created_userid'], $threads[$tid]['created_username']);

			$v['threadContent'] = strip_tags($v['threadContent']);
			$posts[] = $v;
		}

		if($ajax == 'ajax'){
			$return_arr = array(
        		'page'=>$page,
        		'total'=>$count,
        		'list'=>$posts,
        		);

        	echo json_encode($return_arr);
        	exit;
		}


		//var_dump($posts);
		
		$u_unreadCount = $u_unreadCount > 0 ? $u_unreadCount = '（'.$u_unreadCount.'）' : '';
		$s_unreadCount = $s_unreadCount > 0 ? $s_unreadCount = '（'.$s_unreadCount.'）' : '';

		$this->setOutput($this->getInput('fid', 'get'), 'fid');
		$this->setOutput($page, 'page');
		$this->setOutput($perpage, 'perpage');
		$this->setOutput($count, 'count');
		$this->setOutput($type, 'type');
		$this->setOutput($u_unreadCount, 'u_unreadCount');
		$this->setOutput($s_unreadCount, 's_unreadCount');
		$this->setOutput($u_Count, 'u_Count');
		$this->setOutput($s_Count, 's_Count');
		$this->setOutput($posts, 'posts');

		$this->setTemplate('community_my_message');

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setCustomSeo($lang->getMessage('SEO:mess.notice.run.title'), '', '');
		Wekit::setV('seo', $seoBo);
	}

	/**
	 *
	 * Enter description here ...
	 * @return PwMessageNotices
	 */
	protected function _getNoticeDs(){
		return Wekit::load('message.PwMessageNotices');
	}

	/**
	 *
	 * Enter description here ...
	 * @return PwNoticeService
	 */
	protected function _getNoticeService(){
		return Wekit::load('message.srv.PwNoticeService');
	}

	/**
	 *
	 * Enter description here ...
	 * @return PwUser
	 */
	protected function _getUserDs(){
		return Wekit::load('user.PwUser');
	}

	/**
	 *
	 * 设置已读
	 * @param int $unreadCount
	 * @param array $noticeList
	 */
	private function _readNoticeList($unreadCount,$noticeList){
		if ($unreadCount && $noticeList) {
			//更新用户的通知未读数
			$readnum = 0; //本次阅读数
			Wind::import('SRV:message.dm.PwMessageNoticesDm');
			$dm = new PwMessageNoticesDm();
			$dm->setRead(1);
			$ids = array();
			foreach ($noticeList as $v) {
				if ($v['is_read']) continue;
				$readnum ++;
				$ids[] = $v['id'];
			}
			$ids && $this->_getNoticeDs()->batchUpdateNotice($ids,$dm);
			$newUnreadCount = $unreadCount - $readnum;
			if ($newUnreadCount != $unreadCount) {
				Wind::import('SRV:user.dm.PwUserInfoDm');
				$dm = new PwUserInfoDm($this->loginUser->uid);
				$dm->setNoticeCount($newUnreadCount);
				$this->_getUserDs()->editUser($dm,PwUser::FETCH_DATA);
			}
		}
	}

	/**
	 *
	 * 按类型设置已读
	 * @param int $unreadCount
	 * @param array $type
	 */
	private function _readNoticeTypeList($unreadCount,$type){
		Wind::import('SRV:message.dm.PwMessageNoticesDm');
		$dm = new PwMessageNoticesDm();
		$dm->setRead(1);

		if($type == 'user'){
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 10, $dm);
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 15, $dm);
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 17, $dm);
		} else if($type == 'system'){
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 3, $dm);
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 6, $dm);
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 13, $dm);
			$this->_getNoticeDs()->batchUpdateNoticeByUidAndType($this->loginUser->uid, 14, $dm);
		}

		//更新用户的通知未读数
		Wind::import('SRV:user.dm.PwUserInfoDm');
		$dm = new PwUserInfoDm($this->loginUser->uid);
		$dm->setNoticeCount($unreadCount);
		$this->_getUserDs()->editUser($dm,PwUser::FETCH_DATA);
	}

	protected function _getThreadDs() {
		return Wekit::load('forum.PwThread');
	}


	//加工评论数据
	public function workReply($user_id, $content, $return_rpid = false){
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
			$content = $content_arr[1];

			$re_data = explode('[quote2]', $content_arr[0]);
			if(is_numeric($re_data[1])){
				$replyid = $re_data[1];
			} else{
				$replyid = 0;
			}
		} else{
			$replyid = 0;
		}

		$content = htmlspecialchars_decode($content);

		//提取图片
		$img_arr = array();
		preg_match_all('/<img.+?src="(.+?)"/s', $content, $img_arr);
		$content_img = $img_arr[1];
		foreach ($content_img as $key => $value) {
			//表情
			if(strpos($value, 'res/images/emotion/') !== false){
				continue;
			}
			$content = str_replace('<img src="'.$value.'">', '', $content);
			$content = str_replace('<img src="'.$value.'" title="趣炫游戏" alt="趣炫游戏">', '', $content);
		}

		preg_match_all("/<div.*?class=\"J_video\".*?data-url=\"(.*?)\".*?>/i",$content,$matches);
        if(isset($matches[1]) && is_array($matches[1])){
            $urls = $matches[1];
            foreach($urls as $k=>$v){
                $urls[$k] = preg_replace(array("/javascript:/i","/>|<|\(|\)|(\\\\x)|\s/i"),array('',''),$v);
            }
            $content = str_replace($matches[1],$urls,$content);
        }

        if($return_rpid){
        	return array(
	        	'content'=>$content,
	        	'replyid'=>$replyid
	        	);
        } else{
        	return $content;
        }
        
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
    		$username = '<span class="official-icon" style="margin-top: 7px;">官方</span><span style="color:#1ea4f2; font-size:1em;">'.$username.'</span>';
    	}
    	return $username;
    }

    public function systemUserNameThreads($user_id, $username){
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
    	if($this->loginUser->uid == $user_id){
    		return $this->user_desc;
    	}

    	foreach ($this->user_desc as $key => $value) {
    		if($key == $user_id){
    			return $this->user_desc;
    		}
    	}

    	$users = Wekit::load('user.PwUser')->fetchUserByUid(array($user_id), 5);

    	$this->user_desc += $users;
    	return $this->user_desc;
    }

	/*//加工评论数据
	public function workReply($content){
		if(strpos($content, '[/quote]') !== false){
			$content_arr = explode('[/quote]', $content);
			$content = $content_arr[1];
		}

		//加工二次回复的回复
		if(strpos($content, '[/quote2]') !== false){
			$content_arr = explode('[/quote2]', $content);
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
        return htmlspecialchars_decode($content);
    }*/
}	
