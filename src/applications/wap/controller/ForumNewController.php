<?php
defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('SRV:forum.srv.PwPost');
Wind::import('WIND:utility.WindJson');
Wind::import('SRV:credit.bo.PwCreditBo');

Wind::import('SRV:forum.srv.PwThreadDisplay');

/**
 * 手机端帖子操作
 * form src\applications\bbs\controller\PostController.php
 * 2017.09.28
 */
class ForumNewController extends PwBaseController {

	public $post;
	public $stop_action = 0;

	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
		$action = $handlerAdapter->getAction();

		if (in_array($action, array('fastreply', 'replylist'))) {
			return;
		}

		$this->post = $this->_getPost($action);

		$tid = $this->getInput('tid', 'get');

		//登录检测
		$pwforum = $this->post->forum;
		if (!$this->loginUser->isExists()) {
			if($tid){
				$this->forwardAction('wap/login/run', array('backurl' => WindUrlHelper::createUrl('wap/ForumNew/' . $action, array('tid' => $tid))));
			} else{
				$this->forwardAction('wap/login/run', array('backurl' => WindUrlHelper::createUrl('wap/ForumNew/' . $action, array('fid' => $pwforum->fid))));
			}
		}

		if (($result = $this->post->check()) !== true && $action != 'addPic') {
			$error = $result->getError();
			
			if (is_array($error) && $error[0] == 'BBS:post.forum.allow.ttype'
			&& ($allow = $this->post->forum->getThreadType($this->post->user))) {
				$special = key($allow);
				$this->forwardAction('wap/ForumNew/run?fid=' . $this->post->forum->fid . ($special ? ('&special=' . $special) : ''));
			}
			//发帖权限
			if(is_array($error)){
				if($error[0] == 'permission.post.allow'){
					$this->stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.post.allow'){
					$this->stop_action = 1;
				} else if($error[0] == 'BBS:forum.permissions.reply.allow'){
					$this->stop_action = 1;
				}
			} else if($error == 'ban'){
				$this->stop_action = 2;
			} else{
				$this->stop_action = 3;
			}
			
			//$this->showError($error);
		}
		
		// //版块风格
		// $pwforum = $this->post->forum;
		// if ($pwforum->foruminfo['password']) {
		// 	if (!$this->loginUser->isExists()) {
		// 		$this->forwardAction('wap/login/run', array('backurl' => WindUrlHelper::createUrl('wap/forumnew/' . $action, array('fid' => $pwforum->fid))));
		// 	} elseif (Pw::getPwdCode($pwforum->foruminfo['password']) != Pw::getCookie('fp_' . $pwforum->fid)) {
		// 		$this->forwardAction('bbs/forum/password', array('fid' => $pwforum->fid));
		// 	}
		// }
		// if ($pwforum->foruminfo['style']) {
		// 	$this->setTheme('forum', $pwforum->foruminfo['style']);
		// }
		
		//锚点
		$this->setOutput($_GET['anchor'], 'anchor');
		$this->setOutput($_GET['post_anchor'], 'post_anchor');
		$this->setOutput($this->stop_action, 'stop_action');
		$this->setOutput($action, 'action');
    }
	
	public function run() {
		$fid = $this->getInput('fid', 'get');
		$tid = $this->getInput('tid', 'get');
		$activity_prefix = $this->getInput('activity_prefix', 'get');
		if(!$fid && !$tid){
			header('location:index.php');
			exit;
		}


		
		$this->setOutput($tid, 'tid');
		$this->setOutput($fid, 'fid');
		$this->setOutput($activity_prefix, 'activity_prefix');
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');

		$this->setTemplate('community_new_thread');

		// seo设置 
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setCustomSeo($lang->getMessage('SEO:bbs.post.run.title'), '', '');
		Wekit::setV('seo', $seoBo);
	}

	/**
	 * 发帖
	 */
	public function doaddAction() {
		list($title, $content, $activity_prefix, $topictype, $subtopictype, $reply_notice, $atc_type, $hide) = $this->getInput(array('atc_title', 'atc_content', 'activity_prefix', 'topictype', 'sub_topictype', 'reply_notice', 'atc_type', 'hide'), 'post');
		$pwPost = $this->post;
		$this->runHook('c_post_doadd', $pwPost);

		//去除emoji表情
		$title = $this->filterEmoji($title);
		if($title == ''){
			$return_arr = array(
				'state'=>'sword',
				'msg'=>'标题至少输入2个字',
				);
			echo json_encode($return_arr);
			exit;
		}
		$title = $activity_prefix.$title;

		$content = $this->filterEmoji($content);
		$content = str_replace(array("\r\n", "\r", "\n"), "<br/>", $content);
		if(mb_strlen(strip_tags(trim($content)),'utf8') < 6){
			$return_arr = array(
				'state'=>'sword',
				'msg'=>'正文至少输入6个字',
				);
			echo json_encode($return_arr);
			exit;
		}
		$extend = json_encode(array(
			'type'=>$atc_type,
		));

		//内容本身已对script等标签进行转义，重复转义会导致页面输出时这些标签还是转义符号
		$postDm = $pwPost->getDm();
		$postDm->setTitle(htmlspecialchars($title))
			->setContent($content)
			->setHide($hide)
			->setExtend($extend)
			->setReplyNotice(1);

		//set topic type
		$topictype_id = $subtopictype ? $subtopictype : $topictype;
		$topictype_id && $postDm->setTopictype($topictype_id);

		if (($result = $pwPost->execute($postDm)) !== true) {
			$res_err = $result->getError();
			//敏感词屏蔽
			if($res_err[0] == 'WORD:title.tag.error' || $res_err[0] == 'WORD:content.error' || $res_err[0] == 'WORD:content.error.tip'){
				$res_data = $result->getData();
				//审核敏感词
				if($res_data['isVerified'] == 1){
					//忽略审核敏感词重新发帖
					$return_arr = array(
						'state'=>'raload',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				} else{
					$return_arr = array(
						'state'=>'word',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				}
			} else if($res_err[0] == 'BBS:post.content.length.more'){
				$return_arr = array(
					'state'=>'sword',
					'msg'=>'内容最多只能'.$res_err[1]['{max}'].'个字',
					);
				echo json_encode($return_arr);
				exit;
			} else{
				$data = $result->getData();
				$data && $this->addMessage($data, 'data');
				$this->showError($result->getError());
			}
		}
		$tid = $pwPost->getNewId();

		//设置帖子日发布数
		$redis_obj = $this->getRedis();
		$redis_obj->setThreadDayCount();

		$return_arr = array(
			'state'=>'success',
			'url'=>'index.php?m=wap&c=ForumData&tid='.$tid,
			);
		echo json_encode($return_arr);
		exit;
		//$this->showMessage('success', 'bbs/read/run/?tid=' . $tid . '&fid=' . $pwPost->forum->fid, true);
	}

	/**
	 * 发回复页
	 */
	public function replyAction() {
		$tid = $this->getInput('tid');
		$pid = $this->getInput('pid');
		$replyid = $this->getInput('replyid');		//回复的二次评论id
		
		$info = $this->post->getInfo();

		$this->setOutput($tid, 'tid');
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');

		if($pid){
			$threadDisplay = new PwThreadDisplay($tid, $this->loginUser);

			if($replyid){
				//回复详情(个数、偏移量、升序排列、上级回复id、热门排序、回复id)
	        	$readdb = $threadDisplay->thread->getRepliesGroup(1, 0, false, 0, flase, $replyid);
			} else{
				//回复详情(个数、偏移量、升序排列、上级回复id、热门排序、回复id)
	        	$readdb = $threadDisplay->thread->getRepliesGroup(1, 0, false, 0, flase, $pid);
			}
			
	        $readdb = array_pop($readdb);

	        //昵称
        	$readdb['created_username'] = $this->systemUserName($readdb['created_userid'], $readdb['created_username']);
			
			$this->setOutput($pid, 'pid');
			$this->setOutput($replyid, 'replyid');
			$this->setOutput($readdb, 'readdb');
			$this->setTemplate('community_new_second_comment');
		} else{
			$this->setTemplate('community_new_comment');
		}

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setCustomSeo($lang->getMessage('SEO:bbs.post.reply.title'), '', '');
		Wekit::setV('seo', $seoBo);
	}

	/**
	 * 回复
	 */
	public function doreplyAction() {
		$tid = $this->getInput('tid');
		$replyid = $this->getInput('replyid');		//回复的二次评论id
		list($title, $content, $hide, $rpid) = $this->getInput(array('post_title', 'post_content', 'hide', 'pid'), 'post');

		//去除emoji表情
		$content = $this->filterEmoji($content);
		if(mb_strlen(trim($content),'utf8') < 2){
			$return_arr = array(
				'state'=>'word_length',
				'msg'=>'至少输入2个字',
				);
			echo json_encode($return_arr);
			exit;
		}

		//替换换行符
		$content =  str_replace(array("\r\n", "\r", "\n"), "<br>", $content);

		$post_content_img = $this->getInput('post_content_img', 'post');		//图片
		if($post_content_img){
			$content .= '<img src="'.$post_content_img.'" title="趣炫游戏" alt="趣炫游戏">';
		}

		$pwPost = $this->post;
		$this->runHook('c_post_doreply', $pwPost);

		$info = $pwPost->getInfo();
		$title == 'Re:' . $info['subject'] && $title = '';
		if ($rpid) {
			$reply_username = '';
			if($replyid){
				/*$reply_post = Wekit::load('thread.PwThread')->getPost($replyid);
				//昵称
	        	$created_info = Wekit::load('user.PwUser')->getUserByUid($reply_post['created_userid'], PwUser::FETCH_INFO);
	        	if($created_info['nickname'] != ''){
	        		$reply_post['created_username'] = $created_info['nickname'];
	        	}

				$reply_username = '回复&nbsp;<span class="user-name">'.$reply_post['created_username'].'</span><span class="colon">：</span>';*/
				$reply_username = '[quote2]'.$replyid.'[/quote2]';
			}

			$post = Wekit::load('thread.PwThread')->getPost($rpid);
			if ($post && $post['tid'] == $tid && $post['ischeck']) {
				$post['content'] = $post['ifshield'] ? '此帖已被屏蔽' : trim(Pw::stripWindCode(preg_replace('/\[quote(=.+?\,\d+)?\].*?\[\/quote\]/is', '', $post['content'])));
				$post['content'] && $content = '[quote=' . $post['created_username'] . ',' . $rpid . ']' . Pw::substrs($post['content'], 120) . '[/quote]' . $reply_username . $content;
			} else {
				$rpid = 0;
			}
		}

		//被回复人id
		if($replyid > 0){
			$bepost = Wekit::load('thread.PwThread')->getPost($replyid);
			$bereplyuid = $bepost['created_userid'] > 0 ? $bepost['created_userid'] : 0;
		} else if($rpid > 0){
			$bepost = Wekit::load('thread.PwThread')->getPost($rpid);
			$bereplyuid = $bepost['created_userid'] > 0 ? $bepost['created_userid'] : 0;
		} else{
			$threadDisplay = new PwThreadDisplay($tid, $this->loginUser);
			$threadInfo = $threadDisplay->getThreadInfo();		//帖子信息
			$bereplyuid = $threadInfo['created_userid'];
		}
		//不是自己则设置,被回复任务需要参数
		if($bereplyuid != $this->loginUser->uid){
			$pwPost->setBeReplyUid($bereplyuid);
		}

		$postDm = $pwPost->getDm();
		$postDm->setTitle($title)
			->setContent($content)
			->setHide($hide)
			->setReplyId($replyid)
			->setReplyPid($rpid);

		if (($result = $pwPost->execute($postDm)) !== true) {
			$res_err = $result->getError();
			//敏感词屏蔽
			if($res_err[0] == 'WORD:content.error.tip'){
				$res_data = $result->getData();
				//审核敏感词
				if($res_data['isVerified'] == 1){
					//忽略审核敏感词重新发帖
					$return_arr = array(
						'state'=>'raload',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				} else{
					$return_arr = array(
						'state'=>'word',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				}
			} else if($res_err == 'BBS:post.content.duplicate'){
				$return_arr = array(
					'state'=>'sword',
					'msg'=>'',
					);
				echo json_encode($return_arr);
				exit;
			} else if($res_err[0] == 'BBS:post.content.length.more'){
				$return_arr = array(
					'state'=>'sword',
					'msg'=>'内容最多只能'.$res_err[1]['{max}'].'个字',
					);
				echo json_encode($return_arr);
				exit;
			} else{
				$data = $result->getData();
				$data && $this->addMessage($data, 'data');
				$this->showError($result->getError());
			}			
		}
		//$pid = $pwPost->getNewId();

		//设置评论日发布数
		$redis_obj = $this->getRedis();
		$redis_obj->setReplyDayCount();
		
		if($rpid != 0){
			$return_arr = array(
				'state'=>'success',
				'url'=>'index.php?m=wap&c=ForumData&a=postDetail&tid='.$tid.'&pid='.$rpid,
				);
		} else{
			$return_arr = array(
				'state'=>'success',
				'url'=>'index.php?m=wap&c=ForumData&tid='.$tid,
				);
		}
		
		echo json_encode($return_arr);
		exit;
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
    	return $username;
    }

    //过滤emoji表情
    public function filterEmoji($str){
        $str = preg_replace_callback('/./u',array($this, "filterReturn"),$str);
        return $str;
    }

    public function filterReturn($match){
    	return strlen($match[0]) >= 4 ? '' : $match[0];
    }
}	