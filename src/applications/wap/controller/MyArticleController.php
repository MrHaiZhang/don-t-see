<?php
Wind::import('LIB:base.PwBaseController');

Wind::import('SRV:forum.srv.PwThreadDisplay');


/**
 * 手机端个人动态
 * form src\applications\my\controller\ArticleController.php
 * 2017.10.30
 */
class MyArticleController extends PwBaseController {
	private $perpage = 5;
	public $groups_arr = array();
	public $user_desc = array();		//用户信息
	
	public function beforeAction($handlerAdapter) {
		$this->setOutput($this->getInput('fid', 'get'), 'fid');
		parent::beforeAction($handlerAdapter);
		if (!$this->loginUser->isExists()) {
			$this->forwardAction('wap/login/run',array('backurl' => WindUrlHelper::createUrl('wap/MyArticle/run')));
		}
	}
	
	/* (non-PHPdoc)
	 * @see WindController::run()
	 */
	public function run() {
		$ajax = $this->getInput('ajax', 'get');
		Wind::import('SRV:forum.srv.PwThreadList');
		list($page, $perpage) = $this->getInput(array('page', 'perpage'));
		$page = $page ? $page : 1;
		$perpage = $perpage ? $perpage : $this->perpage;
		$threadList = new PwThreadList();

		$threadList->setPage($page)->setPerpage($perpage);
		Wind::import('SRV:forum.srv.threadList.PwMyThread');
		$dataSource = new PwMyThread($this->loginUser->uid);

		$threadList->execute($dataSource);
		$threads = $threadList->getList();

		//获取帖子内容
		if(is_array($threads)){
			foreach($threads as $k=>$v){
				$tid = $v['tid'];

				$threads[$k]['created_time'] = PW::time2str($v['created_time'],'auto');

				$threadDisplay = new PwThreadDisplay($tid, $this->loginUser, false, false);
				//屏蔽字符
				$this->runHook('c_read_run', $threadDisplay);

				$pwforum = $threadDisplay->getForum();		//版块信息
				$threads[$k]['forum_name'] = $pwforum->foruminfo['name'];

				Wind::import('SRV:forum.srv.threadDisplay.PwCommonRead');
				$dataSource = new PwCommonRead($threadDisplay->thread);

				$dataSource->setPage(1)
					->setPerpage($pwforum->forumset['readperpage'] ? $pwforum->forumset['readperpage'] : Wekit::C('bbs', 'read.perpage'))
					->setDesc($desc);
				
				//图片懒加载
				$threadDisplay->setImgLazy(Wekit::C('bbs', 'read.image_lazy'));
				$threadDisplay->execute($dataSource);

				//内容
				$readdb = $threadDisplay->getList();
				foreach($readdb as $key=>$value){
					if($value['lou'] == 0){
						$threads[$k]['content'] = $this->workReply($value['created_userid'], $value['content']);
						$threads[$k]['content'] = strip_tags($threads[$k]['content'], '<img>');
					}     
                }
			}
		}

		if($ajax == 'ajax'){
			$return_arr = array(
        		'page'=>$threadList->page,
        		'total'=>$threadList->total,
        		'list'=>array_merge($threads),
        		);

        	echo json_encode($return_arr);
        	exit;
		}

		$this->setOutput($threads, 'threads');

		$this->setOutput($threadList->total, 'count');
		$this->setOutput($threadList->page, 'page');
		$this->setOutput($threadList->perpage, 'perpage');
		
		$this->setTemplate('community_post_records');
		
		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$title_seo = $lang->getMessage('SEO:bbs.article.reply.title');
		$title_arr = explode(' - ', $title_seo, 2);
		$title_seo = '我的帖子 - '.$title_arr[1];
		$seoBo->setCustomSeo($title_seo, '', '');
		Wekit::setV('seo', $seoBo);
	}
	
	/**
	 * 回复列表
	 */
	public function replyAction() {
		$ajax = $this->getInput('ajax', 'get');
		list($page, $perpage) = $this->getInput(array('page', 'perpage'));
		$page = $page ? $page : 1;
		$perpage = $perpage ? $perpage : $this->perpage;
		list($start, $limit) = Pw::page2limit($page, $perpage);

		//获取管理组数据
		$this->groups_arr = Wekit::load('usergroup.PwUserGroups')->getGroupsByTypeInUpgradeOrder('system');

		//评论总数
		$count = $this->_getThreadExpandDs()->countDisabledPostByUid($this->loginUser->uid);

		if ($count) {
			$tmpPosts = $this->_getThreadExpandDs()->getDisabledPostByUid($this->loginUser->uid,$limit,$start);
			$posts = $tids = array();
			foreach ($tmpPosts as $v) {
				$tids[] = $v['tid'];
			}
			$threads = $this->_getThreadDs()->fetchThread($tids, 3);
			foreach ($tmpPosts as $v) {
				//$v['threadSubject'] = Pw::substrs($threads[$v['tid']]['subject'], 30);
				//$v['content'] = Pw::substrs($v['content'], 30);
				$v['created_time'] = PW::time2str($v['created_time'],'auto');

				$v['created_userimg'] = Pw::getAvatar($v['created_userid']).'?'.time();
				$v['threadSubject'] = $threads[$v['tid']]['subject'];
				$v['threadContent'] = $threads[$v['tid']]['content'];
				$v['threadContent'] = strip_tags($v['threadContent']);
				$content_arr = $this->workReply($v['created_userid'], $v['content'], true);
				$v['content'] = strip_tags($content_arr['content'], '<img>');

				//二次回复和回复二次回复的都要显示
				if($content_arr['replyid'] != 0){
					$rp_data = Wekit::load('thread.PwThread')->getPost($content_arr['replyid']);
					$v['rp_content'] = strip_tags($this->workReply($rp_data['created_userid'], $rp_data['content']), '<img>');
					//昵称
					$v['rp_username'] = $this->systemUserName($rp_data['created_userid'], $rp_data['created_username']);
				} else{
					if($v['rpid'] != 0){
						$rp_data = Wekit::load('thread.PwThread')->getPost($v['rpid']);
						$v['rp_content'] = strip_tags($this->workReply($rp_data['created_userid'], $rp_data['content']), '<img>');
						//昵称
						$v['rp_username'] = $this->systemUserName($rp_data['created_userid'], $rp_data['created_username']);
					}
				}

				if($v['rpid'] != 0){
					$v['post_id'] = $v['rpid'];
				} else{
					$v['post_id'] = $v['pid'];
				}

				

				//昵称
				$v['created_username'] = $this->systemUserName($v['created_userid'], $v['created_username']);

				$posts[] = $v;
			}
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
		$this->setOutput($count, 'count');
		$this->setOutput($page, 'page');
		$this->setOutput($posts, 'posts');

		$this->setTemplate('community_comment_records');
		
		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$title_seo = $lang->getMessage('SEO:bbs.article.reply.title');
		$title_arr = explode(' - ', $title_seo, 2);
		$title_seo = '我的回复 - '.$title_arr[1];
		$seoBo->setCustomSeo($title_seo, '', '');
		Wekit::setV('seo', $seoBo);
	}
	
	/**
	 * Enter description here ...
	 *
	 * @return PwThreadExpand
	 */
	protected function _getThreadExpandDs() {
		return Wekit::load('forum.PwThreadExpand');
	}
	
	/**
	 * Enter description here ...
	 *
	 * @return PwThread
	 */
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
				unset($content_img[$key]);
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
    		$username = '<span class="official-icon" style="float:none;">官方</span><span style="color:#1ea4f2; font-size:1em;">'.$username.'</span>';
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

    	$users = Wekit::load('user.PwUser')->fetchUserByUid(array($user_id));

    	$this->user_desc += $users;
    	return $this->user_desc;
    }

}	
