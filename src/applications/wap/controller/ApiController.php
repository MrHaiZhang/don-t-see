<?php
Wind::import('SRV:forum.bo.PwForumBo');
Wind::import('SRV:credit.bo.PwCreditBo');

/**
 * 礼包模块
 * 2017.12.16
 */
class ApiController extends PwBaseController {
	private $perpage = 10;

	/* (non-PHPdoc)
	 * @see PwBaseController::beforeAction()
	 */
	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
	}
	
	/* (non-PHPdoc)
	 * @see WindController::run()
	 */
	public function run() {
		exit('this is ng');
	}

	//获取用户信息
	public function getUserMsgAction(){
		$plat_user_name = $this->getInput('plat_user_name');
		$time = $this->getInput('time');
		$sign = $this->getInput('sign');
		$nonce_str = $this->getInput('nonce_str');		//随机字符串

		$sign_data = array(
			'plat_user_name' => $plat_user_name,
			'time' => $time,
			'nonce_str' => $nonce_str,
		);

		$new_sign = $this->api_check_user_sign($sign_data);

		if($new_sign != $sign){
			echo json_encode(array('code'=>-1, 'msg'=>'签名错误'));
			exit;
		}

		$redis_obj = $this->getRedis();
		$userInfo = $redis_obj->getUserMsg($plat_user_name);
		$userData = array();
		if(empty($userInfo)){
			$userData['credit1'] = 0;
		} else{
			$userData['credit1'] = $userInfo['credit1'];
		}

		echo json_encode(array('code'=>1, 'data'=>$userData));
		exit;
	}

	//领取积分礼包
	public function getGiftAction(){
		$userForm = $this->_getLoginPost();
		$plat_user_name = $userForm['plat_user_name'];

		$gift_id = $userForm['gift_id'];		//礼包id
		if($gift_id <= 0){
			echo json_encode(array('code'=>14, 'msg'=>'礼包不存在'));
			exit;
		}

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$redis_obj = $this->getRedis();
		$userInfo = $redis_obj->getUserMsg($plat_user_name);

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$post_data = array(
			'plat_user_name'=>$plat_user_name,
			'sign_type'=>'NG',
			'gift_id'=>$gift_id,
			'ticket'=>md5($plat_user_name.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_gift_detalis';

		$gift = json_decode($this->curlPost($post_url, $post_data), true);
		$condition_arr = explode('_',$gift['gift_condition']);
		$gift['point'] = $condition_arr[1] ? intval($condition_arr[1]) : 0;

		$point_ng = '';
		//积分不足
		if($userInfo['credit1'] < $gift['point']){
			$point_ng = 'ng';
			echo json_encode(array('code'=>101, 'msg'=>'积分不足'));
			exit;
		}

		$post_data = array(
			'plat_user_name'=>$plat_user_name,
			'sign_type'=>'NG',
			'gift_id'=>$gift_id,
			'point_ng'=>$point_ng,
			'ip_address'=>bindec(decbin(ip2long($this->get_client_ip()))),
			'ticket'=>md5($plat_user_name.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_get_gift';

		$content = $this->curlPost($post_url, $post_data);
		$return_data = json_decode($content, true);

		//成功领取积分礼包
		if($change_point == 1 && $return_data['code'] == 1){
			//登录
			Wind::import('SRV:user.srv.PwLoginService');
			$login = new PwLoginService();
			$this->runHook('c_login_dorun', $login);
			$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer']);

			$creditBo = PwCreditBo::getInstance();
			$creditBo->addLog('gain_gift', array(1 => -$gift['point']), Wekit::getLoginUser(), array('gift_name' => $gift['gift_name']));
			$creditBo->sets($userInfo['uid'], array(1 => -$gift['point']));
			$redis_obj->setUserMsg($plat_user_name);
		}

		echo $content;
		exit;
	}

	//传送用户积分值
	public function syncBbsCreditAction(){
		$userForm = $this->_getSyncPost();
		Wind::import('SRV:user.PwUser');
		$pw_user = new PwUser();
		$user_data = $pw_user->getUserByName($userForm['plat_user_name'], 2);
		$return_arr = array(
			'code' => 1,
			'credit' => $user_data['credit1'],
		);

		echo json_encode($return_arr);
		exit;
	}

	private function _getLoginPost() {
		$data = array();
		list($data['plat_user_name'], $data['password'], $data['time'], $data['gift_id']) = $this->getInput(
			array('plat_user_name', 'password', 'time', 'gift_id'), 'post');
		$sign =  $this->getInput('sign');
	
		if (empty($data['plat_user_name']) || empty($data['password'])){
			echo json_encode(array('code'=>-1, 'msg'=>'参数不全或异常'));
			exit;
		}

		$sign_key = $this->api_check_user_sign($data);

		// $log_arr = $data;
		// $log_arr['sign_key'] = $sign_key;
		// $log_arr['sign_key_old'] = $sign_key_old;
		//日志
		// $redis_obj = $this->getRedis();
		// $redis_obj->setLogContent(json_encode($log_arr));

		//签名错误
		if($sign_key != $sign){
			echo json_encode(array('code'=>-1, 'msg'=>'签名错误'));
			exit;
		}
		
		return $data;
    }

    private function _getSyncPost() {
		$data = array();
		list($data['plat_user_name'], $data['time']) = $this->getInput(
			array('plat_user_name', 'time'), 'post');
		$sign =  $this->getInput('sign');
	
		if (empty($data['plat_user_name'])){
			echo json_encode(array('code'=>-1, 'msg'=>'参数不全或异常'));
			exit;
		}

		$sign_key = $this->api_check_user_sign($data);
		//签名错误
		if($sign_key != $sign){
			echo json_encode(array('code'=>-1, 'msg'=>'签名错误'));
			exit;
		}
		
		return $data;
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

	/**
	* api签名
	* @param $data array 数据
	*/
	public function api_check_user_sign($data){
		$config = Wekit::C('site');
		ksort($data);
		$sign_str = '';
		foreach ($data as $key => $value) {
			$sign_str .= "{$key}={$value}&";
		}
		$sign_str = rtrim($sign_str, '&');

		return md5($sign_str.$config['securityKey']);
	}

}
?>