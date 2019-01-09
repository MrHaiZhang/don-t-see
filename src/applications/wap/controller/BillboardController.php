<?php
Wind::import('SRV:forum.bo.PwForumBo');


/**
 * 用户榜单
 * form bbs\src\applications\task\controller\IndexController.php
 * 2017.12.12
 */
class BillboardController extends PwBaseController {
	private $perpage = 20;

	/* (non-PHPdoc)
	 * @see PwBaseController::beforeAction()
	 */
	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
		if (!$this->loginUser->isExists()) {
			$this->forwardAction('wap/login/run');
		}
	}
	
	/* (non-PHPdoc)
	 * @see WindController::run()
	 */
	public function run() {
		$fid = intval($this->getInput('fid'));		//版块id
		if($fid <= 0){
			header('location:index.php');
			exit;
		}
		//版块信息
		$pwforum = new PwForumBo($fid, true);


		$redis_obj = $this->getRedis();
		$uf_diest_list = $redis_obj->getUserForumDigest($fid);		//精华榜
		$uf_diest_time = $redis_obj->getUserForumDigestTime($fid);		//精华榜时间
		$uf_like_list = $redis_obj->getUserForumLike($fid);		//点赞榜
		$uf_like_time = $redis_obj->getUserForumLikeTime($fid);		//点赞榜时间
		$user_punch = Wekit::load('user.PwUser')->getPunchNum(30);		//打卡榜


		//获取和最后一位打卡次数相同的人
		count($user_punch) > 0 && $last_punch_num = $user_punch[count($user_punch)-1]['punch_num'];
		if($last_punch_num > 0){
			$last_punch_list = Wekit::load('user.PwUser')->getPunchSpNum($last_punch_num);
			$user_punch = $user_punch + $last_punch_list;
		}
		
		$user_punch = array_values($user_punch);
		//相同次数的人按打卡时间排序,先打卡的在前
		for($i = 0; $i < count($user_punch); $i++) {
			for($j = 0; $j < count($user_punch); $j++) {
				if($user_punch[$i]['uid'] != $user_punch[$j]['uid'] && $user_punch[$i]['punch_num'] == $user_punch[$j]['punch_num']){
					$punch_value = unserialize($user_punch[$i]['punch']);
					$punch_vv = unserialize($user_punch[$j]['punch']);
					if($punch_value['time'] > $punch_vv['time'] && $i < $j){	
						$xx = $user_punch[$i];
						$user_punch[$i] = $user_punch[$j];
						$user_punch[$j] = $xx;
					}
				}
			}
		}

		arsort($uf_diest_list);
		arsort($uf_like_list);

		$uf_diest = array_slice($uf_diest_list, 0, 30, true);
		$uf_like = array_slice($uf_like_list, 0, 30, true);
		$user_punch = array_slice($user_punch, 0, 30, true);

		//获取和最后一位相同次数的人
		$last_diest_list = array();
		$id_list = array_keys($uf_diest_list, end($uf_diest));
		foreach ($id_list as $key => $value) {
			$last_diest_list[$value] = $uf_diest_list[$value];
		}
		$uf_diest = $uf_diest+$last_diest_list;

		$last_like_list = array();
		$id_list = array_keys($uf_like_list, $uf_diest[count($uf_diest)-1]);
		foreach ($id_list as $key => $value) {
			$last_like_list[$value] = $uf_like_list[$value];
		}
		$uf_like = $uf_like+$last_like_list;


		$user_punch_id = array();

		$diest_list = array();
		$like_list = array();
		$punch_list = array();
		foreach ($uf_diest as $key => $value) {
			$diest_list[] = array('uid'=>$key,'num'=>$value,'time'=>$uf_diest_time[$key]);
		}
		foreach ($uf_like as $key => $value) {
			$like_list[] = array('uid'=>$key,'num'=>$value,'time'=>$uf_like_time[$key]);
		}
		foreach ($user_punch as $key => $value) {
			$punch_list[] = array('uid'=>$value['uid'],'num'=>$value['punch_num']);
			$user_punch_id[] = $value['uid'];
		}

		//相同次数的人按时间排序,先的在前
		for($i = 0; $i < count($diest_list); $i++) {
			for($j = 0; $j < count($diest_list); $j++) {
				if($diest_list[$i]['uid'] != $diest_list[$j]['uid'] && $diest_list[$i]['num'] == $diest_list[$j]['num']){
					if($diest_list[$i]['time'] > $diest_list[$j]['time'] && $i < $j){
						$xx = $diest_list[$i];
						$diest_list[$i] = $diest_list[$j];
						$diest_list[$j] = $xx;
					}
				}
			}
		}

		for($i = 0; $i < count($like_list); $i++) {
			for($j = 0; $j < count($like_list); $j++) {
				if($like_list[$i]['uid'] != $like_list[$j]['uid'] && $like_list[$i]['num'] == $like_list[$j]['num']){
					if($like_list[$i]['time'] > $like_list[$j]['time'] && $i < $j){
						$xx = $like_list[$i];
						$like_list[$i] = $like_list[$j];
						$like_list[$j] = $xx;
					}
				}
			}
		}


		$uf_diest = array_slice($diest_list, 0, 30, true);
		$uf_like = array_slice($like_list, 0, 30, true);

		//获取用户id
		$uf_diest_id = array();
		foreach ($uf_diest as $key => $value) {
			$uf_diest_id[] = $value['uid'];
		}
		$uf_like_id = array();
		foreach ($uf_like as $key => $value) {
			$uf_like_id[] = $value['uid'];
		}

		//批量获取用户信息
		$user_id_list = array_merge($uf_diest_id, $uf_like_id, $user_punch_id);
		$user_list = Wekit::load('user.PwUser')->fetchUserByUid($user_id_list, PwUser::FETCH_MAIN);

		foreach ($user_list as $key => $value) {
			foreach ($diest_list as $kk => $vv) {
				if($vv['uid'] == $value['uid']){
					$diest_list[$kk]['username'] = $this->systemUserName($value['uid'], $value['username']);
					break;
				}
			}
			foreach ($like_list as $kk => $vv) {
				if($vv['uid'] == $value['uid']){
					$like_list[$kk]['username'] = $this->systemUserName($value['uid'], $value['username']);
					break;
				}
			}
			foreach ($punch_list as $kk => $vv) {
				if($vv['uid'] == $value['uid']){
					$punch_list[$kk]['username'] = $this->systemUserName($value['uid'], $value['username']);
					break;
				}
			}
		}


		$this->setOutput($fid, 'fid');
		$this->setOutput($pwforum, 'pwforum');
		$this->setOutput($diest_list, 'diest_list');
		$this->setOutput($like_list, 'like_list');
		$this->setOutput($punch_list, 'punch_list');
		$this->setTemplate('community_ranking_list');
		
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

	//获取显示的用户名称和样式
    public function systemUserName($user_id, $username){
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
}
?>