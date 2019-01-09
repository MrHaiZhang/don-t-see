<?php
Wind::import('SRV:forum.bo.PwForumBo');
Wind::import('SRV:credit.bo.PwCreditBo');

/**
 * 礼包模块
 * 2017.12.16
 */
class GiftController extends PwBaseController {
	private $perpage = 10;

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
		$gid = intval($this->getInput('gid'));		//官网游戏id
		$fid = intval($this->getInput('fid'));		//版块id

		if($fid < 1){
			$forumDs = Wekit::load('forum.PwForum');
			$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN);
			foreach($list as $key => $value){
				$value['game_id'] == $gid && $fid = $key;
			}
		}
		
		if($fid <= 0){
			header('location:index.php');
			exit;
		}
		$pwforum = new PwForumBo($fid, true);

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$gift_list = $this->getWebGift($fid, $this->loginUser->username, 'except_point', $appweb, $securityKey);

		$point_gift_list = $this->getWebGift($fid, $this->loginUser->username, 'point', $appweb, $securityKey);

		$redis_obj = $this->getRedis();
		//用户进入礼包中心记录
		$frist_in = $redis_obj->getUserFristInGiftCenterTF($this->loginUser->uid);
		if(!$frist_in){
			$redis_obj->setUserFristInGiftCenter($this->loginUser->uid);
		}

		Wind::import('SRV:wap.HomeRequest');
		$home_request = new HomeRequest();
		$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));

		//var_dump($point_gift_list);
		$this->setOutput($fid, 'fid');
		$this->setOutput($pwforum, 'pwforum');
		$this->setOutput($this->loginUser, 'loginUser');
		$this->setOutput($appweb, 'appweb');
		$this->setOutput($gift_list, 'gift_list');
		$this->setOutput($point_gift_list, 'point_gift_list');
		$this->setOutput($frist_in, 'frist_in');
		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');
		$this->setTemplate('community_game_gift');
		
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

	//获取礼包信息
	public function ajaxRunAction(){
		$fid = intval($this->getInput('fid'));		//版块id
		$gift_type = $this->getInput('gift_type') ? $this->getInput('gift_type') : 'except_point';		//加载类型
		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$gift_list = $this->getWebGift($fid, $this->loginUser->username, $gift_type, $appweb, $securityKey);

		echo json_encode($gift_list);
		exit;
	}

	//展示礼包详情
	public function giftDetailsAction(){
		$fid = intval($this->getInput('fid'));		//版块id
		$gift_id = $this->getInput('gift_id');		//礼包id
		
		if($gift_id <= 0){
			header('location:index.php?m=wap&c=Gift');
			exit;
		}
		if($fid <= 0){
			header('location:index.php');
			exit;
		}

		$pwforum = new PwForumBo($fid, true);

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$post_data = array(
			'plat_user_name'=>$this->loginUser->username,
			'sign_type'=>'NG',
			'gift_id'=>$gift_id,
			'ticket'=>md5($this->loginUser->username.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_gift_detalis';

		$gift = json_decode($this->curlPost($post_url, $post_data), true);
		$condition_arr = explode('_',$gift['gift_condition']);
		$gift['point'] = $condition_arr[1] ? intval($condition_arr[1]) : 0;

		$gift['gift_content'] = htmlspecialchars_decode($gift['gift_content']);
		$gift['gift_get_way'] = htmlspecialchars_decode($gift['gift_get_way']);
		$gift['attention'] = htmlspecialchars_decode($gift['attention']);

		//限时礼包
		if($gift['gift_type_id'] == 10){
			$gift['remain_time'] = $gift['end_time'] - time();
			$gift['remain_time'] < 0 && $gift['remain_time'] = 0;
		} else{
			$gift['remain_time'] = -1;
		}

		Wind::import('SRV:wap.HomeRequest');
		$home_request = new HomeRequest();
		$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));

		$this->setOutput($gift, 'gift');
		$this->setOutput($pwforum, 'pwforum');
		$this->setOutput($this->loginUser, 'loginUser');
		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setTemplate('community_game_gift_content');
	}

	//领取礼包
	public function getGiftAction(){
		$gift_id = $this->getInput('gift_id');		//礼包id
		$change_point = $this->getInput('change_point');		//积分礼包
		if($gift_id <= 0){
			echo json_encode(array('code'=>14, 'msg'=>'礼包不存在'));
			exit;
		}

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		//积分礼包
		if($change_point == 1){
			//网站配置
			$config = Wekit::C()->getValues('site');
			$appweb = $config['info.appweb'];		//官网域名
			$securityKey = $config['securityKey'];		//秘钥

			$post_data = array(
				'plat_user_name'=>$this->loginUser->username,
				'sign_type'=>'NG',
				'gift_id'=>$gift_id,
				'ticket'=>md5($this->loginUser->username.$securityKey),
				);

			$post_url = $appweb.'/index.php?c=bbsapi&a=api_gift_detalis';

			$gift = json_decode($this->curlPost($post_url, $post_data), true);
			$condition_arr = explode('_',$gift['gift_condition']);
			$gift['point'] = $condition_arr[1] ? intval($condition_arr[1]) : 0;

			$point_ng = '';
			//积分不足
			if($this->loginUser->info['credit1'] < $gift['point']){
				//$point_ng = 'ng';
			}
		}

		$post_data = array(
			'plat_user_name'=>$this->loginUser->username,
			'sign_type'=>'NG',
			'gift_id'=>$gift_id,
			'point_ng'=>$point_ng,
			'ip_address'=>bindec(decbin(ip2long($this->get_client_ip()))),
			'ticket'=>md5($this->loginUser->username.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_get_gift';

		$content = $this->curlPost($post_url, $post_data);
		$return_data = json_decode($content, true);

		//成功领取积分礼包
		if($change_point == 1 && $return_data['code'] == 1){
			$creditBo = PwCreditBo::getInstance();
			$creditBo->addLog('gain_gift', array(1 => -$gift['point']), Wekit::getLoginUser(), array('gift_name' => $gift['gift_name']));
			$creditBo->sets($this->loginUser->uid, array(1 => -$gift['point']));
		}
		

		echo $content;
		exit;
	}

	/**
	 * 获取官网礼包信息
	 * @param String $username 		//版块id
	 * @param String $fid 		//用户名
	 * @param String $gift_type 		//加载类型
	 * @param String $mobweb 		//官网域名
	 * @param String $securityKey 		//秘钥
	 * @return [array] [官网礼包信息]
	 */
	public function getWebGift($fid, $username, $gift_type, $appweb, $securityKey){
		$ajax = $this->getInput('ajax');		//是否ajax
		$current_id = intval($this->getInput('current_id'));		//最后的礼包id

		if($fid <= 0){
			header('location:index.php');
			exit;
		}
		$pwforum = new PwForumBo($fid, true);

		$post_data = array(
			'plat_user_name'=>$username,
			'sign_type'=>'NG',
			'game_id'=>$pwforum->foruminfo['game_id'],
			'perpage'=>$this->perpage,
			'ajax'=>$ajax,
			'current_id'=>$current_id,
			'gift_type'=>$gift_type,
			'ticket'=>md5($username.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_get_gift_list';

		$content = $this->curlPost($post_url, $post_data);
		
		$return_data = json_decode($content, true);

		
		foreach ($return_data['data'] as $key => $value) {
			$return_data['data'][$key]['gift_content'] = strip_tags(htmlspecialchars_decode($return_data['data'][$key]['gift_content']), '<br/><br>');

			if($gift_type != 'except_point'){
				$condition_arr = explode('_',$value['gift_condition']);
				$return_data['data'][$key]['point'] = $condition_arr[1] ? intval($condition_arr[1]) : 0;
			}

			//限时礼包
			if($value['gift_type_id'] == 10){
				$return_data['data'][$key]['remain_time'] = $return_data['data'][$key]['end_time'] - time();
				$return_data['data'][$key]['remain_time'] < 0 && $return_data['data'][$key]['remain_time'] = 0;
			} else{
				$return_data['data'][$key]['remain_time'] = -1;
			}
		}
		return $return_data;
	}

	public function curlPost($post_url, $post_data){
		$curl = curl_init($post_url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
		$content = curl_exec($curl);
		curl_close($curl);
		return $content;
	}

	//获取客户端IP
	function get_client_ip() {
	    $cip = getenv ( 'HTTP_CLIENT_IP' );
	    $xip = getenv ( 'HTTP_X_FORWARDED_FOR' );
	    $rip = getenv ( 'REMOTE_ADDR' );
	    $srip = $_SERVER ['REMOTE_ADDR'];
	    if ($cip && strcasecmp ( $cip, 'unknown' )) {
	        $onlineip = $cip;
	    } elseif ($xip && strcasecmp ( $xip, 'unknown' )) {
	        $onlineip = $xip;
	    } elseif ($rip && strcasecmp ( $rip, 'unknown' )) {
	        $onlineip = $rip;
	    } elseif ($srip && strcasecmp ( $srip, 'unknown' )) {
	        $onlineip = $srip;
	    }
	    preg_match ( '/[\d\.]{7,15}/', $onlineip, $match );
	    return $match [0] ? $match [0] : '';
	}
}
?>