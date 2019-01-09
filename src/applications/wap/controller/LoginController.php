<?php
Wind::import('SRV:user.PwUser');
Wind::import('SRV:user.srv.PwLoginService');
Wind::import('APPS:u.service.helper.PwUserHelper');
Wind::import('APPS:u.service.PwThirdLoginService');

/**
 * 版块登录
 * form src\applications\u\controller\LoginController.php
 * 2017.10.18
 */
class LoginController extends PwBaseController {

	//验证是否已经登录
	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
		$action = $handlerAdapter->getAction();

		if ($this->loginUser->isExists() && !in_array($action, array('showverify', 'logout', 'show'))) {
			$plat_user_name = $this->getInput('plat_user_name', 'get');
			//带有plat_user_name清除登录状态
			if($plat_user_name != '' && $action == 'apirun'){
				$uid = $this->loginUser->uid;
				$username = $this->loginUser->username;
				$userService = Wekit::load('user.srv.PwUserService');
				$userService->logout();
			} else{

				$inviteCode = $this->getInput('invite');
				if ($inviteCode) {
					$user = Wekit::load('SRV:invite.srv.PwInviteFriendService')->invite($inviteCode, $this->loginUser->uid);
					if ($user instanceof PwError) {
						$this->showError($user->getError());
					}
				}
				
				if ($action == 'fast') {
					$this->showMessage('USER:login.success');
				} elseif ($action == 'welcome') {
					$this->forwardAction('u/login/show');
				} elseif($this->getRequest()->getIsAjaxRequest()) {
					$this->showError('USER:login.exists');
				} else {
					$this->forwardRedirect($this->_filterUrl());
				}
			}
		}
	}

	public function run() {
		//网站配置
		$config = Wekit::C()->getValues('site');
		$this->setOutput($config['info.mobweb'], 'mobweb');

		$this->setOutput($this->_showVerify(), 'verify');
		$this->setOutput('用户登录', 'title');
		$this->setOutput($this->_filterUrl(false), 'url');
		$this->setOutput(PwUserHelper::getLoginMessage(), 'loginWay');
        $this->setOutput($this->getInput('invite'), 'invite');
        $service = new PwThirdLoginService();
        $this->setOutput($service->getPlatforms(), 'thirdlogin');
		$this->setTemplate('login');
		

		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setCustomSeo($lang->getMessage('SEO:u.login.run.title'), '', '');
		Wekit::setV('seo', $seoBo);		
    }


    /**
	 * 提示信息
	 */
	public function showAction() {
		if (Pw::getstatus($this->loginUser->info['status'], PwUser::STATUS_UNCHECK)) {
			$this->showError('USER:login.active.check');
		}
		$this->forwardRedirect($this->_filterUrl());
	}

    /**
	 * 检查用户输入的用户名
	 */
	public function checknameAction() {
		$login = new PwLoginService();
		$info = $login->checkInput($this->getInput('username'));
		//var_dump($info);
		//if (!$info) $this->showError('USER:user.error.-14');
		if (!empty($info['safecv'])) {
			Wind::import('SRV:user.srv.PwRegisterService');
			$registerService = new PwRegisterService();
			$status = PwLoginService::createLoginIdentify($registerService->sysUser($info['uid']));
			$identify = base64_encode($status . '|');
			$this->addMessage($this->_getQuestions(), 'safeCheck');
			$this->addMessage($identify, '_statu');
			$this->showMessage();
		}
		$this->showMessage();
	}

	/**
	 * 接口登录
	 */
    public function apirunAction() {
		$userForm = $this->_getLoginGet();
		
		/* [验证用户名和密码是否正确] */
		/* 密码加密规则
		   官网是MD5加密的，论坛首先用md5加密后再用盐值加密
		 */

		$login = new PwLoginService();
		$this->runHook('c_login_dorun', $login);
		//登录验证,官网用户先不验证，直接返回数据
		$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer'], false);
		if(is_array($isSuccess)){
			if($isSuccess['code'] == '-1'){
				$this->showError('该用户被禁止登陆<br/>请联系客服QQ：800097987');
			}
		}
		
		if ($isSuccess instanceof PwError) {
			//当论坛用户名不存在时请求官网，查询用户是否存在，存在则创建
			if ($isSuccess->getError() == 'USER:user.error.-14') {
				$return_data = $this->getOffUser($userForm['username'], $userForm['password']);

				if(is_array($return_data)){		//官网用户存在且密码正确
					$return_data['password'] = $userForm['password'];
					//$return_data['mail_addr'] = '73442858@qq.com';
					$this->addAction($return_data);
					//重新登录验证
					$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer']);
				}		
			}

			if ($isSuccess instanceof PwError) {
				$this->forwardRedirect('index.php?m=wap');
			}
		} else if($isSuccess['off_user'] == 1){
			//已有官网用户,密码通过请求官网验证
			$return_data = $this->getOffUser($userForm['username'], $userForm['password']);
			//官网用户存在且密码正确
			if(is_array($return_data)){
				//论坛和官网密码不一致，修改论坛密码
				if(WindidUtility::buildPassword($return_data['password'], $isSuccess['salt']) !== $isSuccess['password']){
					$this->doEditAction($isSuccess['uid'], $return_data['password']);
				}
			} 

			//重新登录验证
			$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer']);
			if ($isSuccess instanceof PwError) {
				$this->forwardRedirect('index.php?m=wap');
			}
		}

		Wind::import('SRV:user.srv.PwRegisterService');
		$registerService = new PwRegisterService();
		$info = $registerService->sysUser($isSuccess['uid']);

		if (!$info)  $this->showError('USER:user.syn.error');
		$identity = PwLoginService::createLoginIdentify($info);
		$identity = base64_encode($identity . '|' . $this->getInput('backurl') . '|' . $userForm['rememberme']);
		
		/* [是否需要设置安全问题] */
		/* @var $userService PwUserService */
		$userService = Wekit::load('user.srv.PwUserService');
		//解决浏览器记录用户帐号和密码问题
		if ($isSuccess['safecv'] && !$question) {
			$this->addMessage(true, 'qaE');
			$this->showError('USER:verify.question.empty');
        }

        //该帐号必须设置安全问题
		if (empty($isSuccess['safecv']) && $userService->mustSettingSafeQuestion($info['uid'])) {
			$this->addMessage(array('url' => WindUrlHelper::createUrl('u/login/setquestion', array('v' => 1, '_statu' => $identity))), 'check');
		}
		
		$this->forwardRedirect('index.php?m=wap&c=login&a=welcome&_statu=' . $identity . '&sdk_game_id=' . $userForm['sdk_game_id'] . '&apiurl=' . urlencode($userForm['url']));
	}

    /**
	 * 页面登录
	 */
    public function dorunAction() {
		$userForm = $this->_getLoginForm();
		
		/* [验证验证码是否正确] */
		if ($this->_showVerify()) {
            $veryfy = $this->_getVerifyService();
            if ($veryfy->checkVerify($userForm['code']) !== true) {
				$this->showError('USER:verifycode.error');
			}
		}
		$question = $userForm['question'];
		if ($question == -4) {
			$question = $this->getInput('myquestion', 'post');
		}
		
		/* [验证用户名和密码是否正确] */
		/* 密码加密规则
		   官网是MD5加密的，论坛首先用md5加密后再用盐值加密
		 */
		
		//官网需要先将密码md5加密再传
		$userForm['password'] = md5($userForm['password']);

		$login = new PwLoginService();
		$this->runHook('c_login_dorun', $login);
		//登录验证,官网用户先不验证，直接返回数据
		$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer'], false);
		if(is_array($isSuccess)){
			if($isSuccess['code'] == '-1'){
				$this->showError('该用户被禁止登陆<br/>请联系客服QQ：800097987');
			}
		}
		
		if ($isSuccess instanceof PwError) {
			//当论坛用户名不存在时请求官网，查询用户是否存在，存在则创建
			if ($isSuccess->getError() == 'USER:user.error.-14') {
				$return_data = $this->getOffUser($userForm['username'], $userForm['password']);

				if(is_array($return_data)){		//官网用户存在且密码正确
					$return_data['password'] = $userForm['password'];
					//$return_data['mail_addr'] = '73442858@qq.com';
					$this->addAction($return_data);
					//重新登录验证
					$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer']);
				}		
			}

			if ($isSuccess instanceof PwError) {
				if($isSuccess->getError() == 'USER:user.error.-14'){
					$this->showError('用户名或密码错误');
				} else{
					$this->showError($isSuccess->getError());
				}
			}
		} else if($isSuccess['off_user'] == 1){
			//已有官网用户,密码通过请求官网验证
			$return_data = $this->getOffUser($userForm['username'], $userForm['password']);
			//官网用户存在且密码正确
			if(is_array($return_data)){
				//论坛和官网密码不一致，修改论坛密码
				if(WindidUtility::buildPassword($return_data['password'], $isSuccess['salt']) !== $isSuccess['password']){
					$this->doEditAction($isSuccess['uid'], $return_data['password']);
				}
			} 

			//重新登录验证
			$isSuccess = $login->login($userForm['username'], $userForm['password'], $this->getRequest()->getClientIp(), $question, $userForm['answer']);
			if ($isSuccess instanceof PwError) {
				if($isSuccess->getError() == 'USER:user.error.-14'){
					$this->showError('用户名或密码错误');
				} else{
					$this->showError($isSuccess->getError());
				}
			}
		}
		
		$config = Wekit::C('site');
		if ($config['windid'] != 'local') {
			$localUser = $this->_getUserDs()->getUserByUid($isSuccess['uid'], PwUser::FETCH_MAIN); 
			if ($localUser['username'] && $userForm['username'] != $localUser['username']) $this->showError('USER:user.syn.error');
		}

		Wind::import('SRV:user.srv.PwRegisterService');
		$registerService = new PwRegisterService();
		$info = $registerService->sysUser($isSuccess['uid']);

		if (!$info)  $this->showError('USER:user.syn.error');
		$identity = PwLoginService::createLoginIdentify($info);
		$identity = base64_encode($identity . '|' . $this->getInput('backurl') . '|' . $userForm['rememberme']);
		
		/* [是否需要设置安全问题] */
		/* @var $userService PwUserService */
		$userService = Wekit::load('user.srv.PwUserService');
		//解决浏览器记录用户帐号和密码问题
		if ($isSuccess['safecv'] && !$question) {
			$this->addMessage(true, 'qaE');
			$this->showError('USER:verify.question.empty');
        }

        //该帐号必须设置安全问题
		if (empty($isSuccess['safecv']) && $userService->mustSettingSafeQuestion($info['uid'])) {
			$this->addMessage(array('url' => WindUrlHelper::createUrl('u/login/setquestion', array('v' => 1, '_statu' => $identity))), 'check');
		}
		$this->showMessage('', 'wap/login/welcome?_statu=' . $identity);
	}

    /**
	 * 判断是否需要展示验证码
	 * 
	 * @return boolean
	 */
	private function _showVerify() {
		$config = Wekit::C('verify', 'showverify');
		!$config && $config = array();
        if(in_array('userlogin', $config)==true){
            return true;
        }

        //ip限制,防止撞库; 错误三次,自动显示验证码
        $ipDs = Wekit::load('user.PwUserLoginIpRecode');
        $info = $ipDs->getRecode($this->getRequest()->getClientIp());
        return is_array($info) && $info['error_count']>3 ? true : false;
	}

	/**
	 * 登录成功
	 */
	public function welcomeAction() {
		//去除该ip当日登录错误次数
        $ipDs = Wekit::load('user.PwUserLoginIpRecode');
        $info = $ipDs->updateRecode($this->getRequest()->getClientIp(), Pw::getTime(), 0);

		$identify = $this->checkUserInfo();
		if (Pw::getstatus($this->loginUser->info['status'], PwUser::STATUS_UNACTIVE)) {
			Wind::import('SRV:user.srv.PwRegisterService');
			$identify = PwRegisterService::createRegistIdentify($this->loginUser->uid, $this->loginUser->info['password']);
			$this->forwardAction('u/register/sendActiveEmail', array('_statu' => $identify, 'from' => 'login'), true);
		}
		list(, $refUrl, $rememberme) = explode('|', base64_decode($identify));
		$login = new PwLoginService();
		$login->setLoginCookie($this->loginUser, $this->getRequest()->getClientIp(), $rememberme);
		if (Pw::getstatus($this->loginUser->info['status'], PwUser::STATUS_UNCHECK)) {
			$this->forwardRedirect(WindUrlHelper::createUrl('wap/login/show', array('backurl' => $refUrl)));
		}
		if (!$refUrl) $refUrl = Wekit::url()->base;

		if ($synLogin = $this->_getWindid()->synLogin($this->loginUser->uid)) {
			$this->setOutput($this->loginUser->username, 'username');
			$this->setOutput($refUrl, 'refUrl');
			$this->setOutput($synLogin, 'synLogin');
		} else {
			$sdk_game_id = $this->getInput('sdk_game_id', 'get');
			$url = $this->getInput('apiurl', 'get');
			if(isset($url) && $url != ''){
				$this->forwardRedirect(urldecode($url));
			} else if(isset($sdk_game_id)){
				$forumDs = Wekit::load('forum.PwForum');
				$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN | PwForum::FETCH_STATISTICS);
				$fid = 0;
				//$afid = 0;
				foreach($list as $key => $value){
					if($value['sdk_game_id'] == $sdk_game_id){
						$fid = $value['fid'];
					}
					// if($value['name'] == '综合讨论区' && $value['parentid'] != 0){
					// 	$afid = $value['fid'];
					// }
				}
				if($fid == 0){
					$this->forwardRedirect('index.php?m=wap&c=Index');
				} else{
					$this->forwardRedirect('index.php?m=wap&c=OneGame&fid='.$fid);
				}
			} else{
				$this->forwardRedirect('index.php');
			}
			
			//$this->forwardRedirect($refUrl);
		}
	}

	/**
	 * 退出
	 *
	 * @return void
	 */
	public function logoutAction() {
		$this->setOutput('用户登出', 'title');
		/* @var $userService PwUserService */
		$uid = $this->loginUser->uid;
		$username = $this->loginUser->username;
		$userService = Wekit::load('user.srv.PwUserService');
		if (!$userService->logout()) $this->showMessage('USER:loginout.fail');
		// $url = $this->getInput('backurl');
		// if (!$url) $url = $this->getRequest()->getServer('HTTP_REFERER');
		// if (!$url) $url = WindUrlHelper::createUrl('u/login/run');
	
		if ($synLogout = $this->_getWindid()->synLogout($uid)) {
			$this->setOutput($username, 'username');
			$this->setOutput($url, 'refUrl');
			$this->setOutput($synLogout, 'synLogout');
		} else {
			$this->forwardRedirect($url);
		}
		$this->forwardRedirect('index.php');
	}

	private function _getWindid() {
		return WindidApi::api('user');
	}

	/**
	 * 获得用户DS
	 *
	 * @return PwUser
	 */
	private function _getUserDs() {
		return Wekit::load('user.PwUser');
	}
	
	/**
	 * Enter description here ...
	 *
	 * @return PwCheckVerifyService
	 */
	private function _getVerifyService() {
		return Wekit::load("verify.srv.PwCheckVerifyService");
	}

	/**
	 * 过滤来源URL
	 *
	 * TODO
	 * 
	 * @return string
	 */
	private function _filterUrl($returnDefault = true) {
		$url = $this->getInput('backurl');
		if (!$url) $url = $this->getRequest()->getServer('HTTP_REFERER');
		if ($url) {
			// 排除来自注册页面/自身welcome/show的跳转
			$args = WindUrlHelper::urlToArgs($url);
			if ($args['m'] == 'u' && in_array($args['c'], array('register', 'login'))) {
				$url = '';
			}
		}
		if (!$url && $returnDefault) $url = Wekit::url()->base;
		return $url;
	}

	/**
	 * @return array
	 */
	private function _getLoginForm() {
		$data = array();
		list($data['username'], $data['password'], $data['question'], $data['answer'], $data['code'], $data['rememberme']) = $this->getInput(
			array('username', 'password', 'question', 'answer', 'code', 'rememberme'), 'post');
		if (empty($data['username']) || empty($data['password'])) $this->showError('USER:login.user.require', 'wap/login/run');
		
		return $data;
    }

    /**
	 * @return array
	 */
	private function _getLoginGet() {
		$data = array();
		list($data['username'], $data['password'], $data['ticket'], $data['time'], $data['sdk_game_id'], $data['url']) = $this->getInput(
			array('plat_user_name', 'password', 'ticket', 'time', 'sdk_app_id', 'url'), 'get');
	
		if (empty($data['username']) || empty($data['password'])) $this->forwardRedirect('index.php?m=wap');

		$sign_key = $this->api_check_user_sign($data['username'], $data['password'], $data['time']);
		$sign_key_old = $this->api_check_user_sign_old($data['username'], $data['password'], $data['time']);

		$log_arr = $data;
		$log_arr['sign_key'] = $sign_key;
		$log_arr['sign_key_old'] = $sign_key_old;
		//日志
		// $redis_obj = $this->getRedis();
		// $redis_obj->setLogContent(json_encode($log_arr));

		//签名错误
		if($sign_key != $data['ticket'] && $sign_key_old != $data['ticket']){
			$this->forwardRedirect('index.php?m=wap');
		}
		
		return $data;
    }

    /**
	 * 检查用户信息合法性
	 *
	 * @return string
	 */
	private function checkUserInfo() {
		$identify = $this->getInput('_statu', 'get');
		!$identify && $identify = $this->getInput('_statu', 'post');

		if (!$identify) $this->showError('USER:illegal.request');
		list($identify, $url, $rememberme) = explode('|', base64_decode($identify) . '|');
		list($uid, $password) = PwLoginService::parseLoginIdentify(rawurldecode($identify));
		
// 		$info = $this->_getUserDs()->getUserByUid($uid, PwUser::FETCH_MAIN);
		$this->loginUser = new PwUserBo($uid);
		if (!$this->loginUser->isExists() || Pw::getPwdCode($this->loginUser->info['password']) != $password) {
			$this->showError('USER:illegal.request');
		}
		return base64_encode($identify . '|' . $url . '|' . $rememberme);
	}


    /** 
	 * 添加用户
	 * @param Array $return_data 		//官网用户数据
	 * @return void
	 */
	public function addAction($return_data) {

		Wind::import('SRC:service.user.dm.PwUserInfoDm');
		$dm = new PwUserInfoDm();

		//用户十位数字标识
		Wind::import('SRC:service.user.dao.PwUserDao');
		$dao = new PwUserDao();
		$tf_next = flase;
		$str_ten = $this->randTen();
		while($tf_next ===  flase){
			$ret = $dao->getIdentId($str_ten);
			if($ret != null){
				$str_ten = $this->randTen();
			} else{
				$tf_next = true;
			}
		}
		
		$dm->setUsername($return_data['plat_user_name'])
			->setPassword($return_data['password'])
		    ->setEmail($return_data['mail_addr'])
		    ->setMobile($return_data['bind_phone'])
		    ->setRegdate(Pw::getTime())
			->setRegip($this->getRequest()->getClientIp())
			->setOffuser(1)
			->setIdentId($str_ten);
		$groupid = 0;
		$dm->setGroupid($groupid);
		if ($groupid != 0) {
			// 默认组不保存到groups
			/* @var $groupDs PwUserGroups */
			$groupDs = Wekit::load('usergroup.PwUserGroups');
			$groups = $groupDs->getGroupsByType('default');
			if (!in_array($groupid, array_keys($groups))) {
				$dm->setGroups(array($groupid => 0));
			}
		}
		/* @var $groupService PwUserGroupsService */
		$groupService = Wekit::load('usergroup.srv.PwUserGroupsService');
		$memberid = $groupService->calculateLevel(0);
		$dm->setMemberid($memberid);
			
		$result = Wekit::load('user.PwUser')->addUser($dm);
		if ($result instanceof PwError) {
			if($result->getError() == 'WINDID:code.-6'){		//没有邮箱
				//var_dump($result->getError());
			}else{
				$this->showError($result->getError());
			}
		}

		//设置日增用户
		$redis_obj = $this->getRedis();
		$userData = array(
			'username'=>$return_data['plat_user_name'],
			'ident_id'=>$str_ten,
			'mobile'=>$return_data['bind_phone'],
			'nickname'=>'',
			);
		$redis_obj->setUserDayCount($userData);
		
		//添加站点统计信息
		Wind::import('SRV:site.dm.PwBbsinfoDm');
		$bbsDm = new PwBbsinfoDm();
		$bbsDm->setNewmember($dm->getField('username'))->addTotalmember(1);
		Wekit::load('site.PwBbsinfo')->updateInfo($bbsDm);
		//Wekit::load('user.srv.PwUserService')->restoreDefualtAvatar($result);
		//$this->showMessage('USER:add.success');

		/* @var $groupDs PwUserGroups */
		$groupDs = Wekit::load('usergroup.PwUserGroups');
		$groups = $groupDs->getClassifiedGroups();
		unset($groups['system'][5]);//排除“版主”
		$result = array_merge($groups['special'], $groups['system']);
		$this->setOutput($result, 'groups');
	}

	/**
	 * 返回随机十位数字
	 * @return [string] [description]
	 */
	public function randTen() {
		$str_ten = '';
		for($i = 0; $i < 10; $i++){
			$str_ten .= rand(0, 9);
		}
		return $str_ten;
	}


	/** 
	 * 修改密码
	 * @param Int $uid
	 * @param String $password
	 * @return void
	 */
	public function doEditAction($uid, $password) {
		//$info = $this->checkUser();
		
		Wind::import('SRC:service.user.dm.PwUserInfoDm');
		$dm = new PwUserInfoDm($uid);
		$dm->setPassword($password);

		$pwUser = Wekit::load('user.PwUser');
		$result = $pwUser->editUser($dm);
		if ($result instanceof PwError) {
			$this->showError($result->getError());
		}
		//$isFounder = $this->isFounder($info['username']);
		//$this->showMessage($isFounder ? 'USER:founder.update.success' : 'USER:update.success', 'u/manage/edit?uid=' . $info['uid']);
	}

	/**
	 * 获取官网用户信息
	 * @param String $username 		//用户名
	 * @param String $password 		//用户密码
	 * @return [array] [官网用户信息]
	 */
	public function getOffUser($username, $password){
		$post_data = array(
			'username'=>$username,
			'password'=>$password,
			'sign'=>md5($username.$password.'forum'),
			);

		$config = Wekit::C()->getValues('site');
		$post_url = $config['info.offweb'].'/api/get_user_info.php';

		$curl = curl_init($post_url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post_data));
		curl_setopt($curl, CURLOPT_TIMEOUT, 30);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
		$content = curl_exec($curl);
		curl_close($curl);

		$return_data = json_decode($content, true);
		return $return_data;
	}

	/**
	* api签名
	* @param $plat_user_name string 用户名
	* @param $password string 密码
	* @param $time int 时间
	*/
	public function api_check_user_sign($plat_user_name,$password,$time){
		$config = Wekit::C('site');
		$ticket_arr = array(
			'plat_user_name'=>$plat_user_name,
			'password'=>$password,
			'time'=>$time,
			);
		ksort($ticket_arr);
		return md5(http_build_query($ticket_arr).$config['securityKey']);
	}

	/**
	* api签名
	* @param $plat_user_name string 用户名
	* @param $password string 密码
	* @param $time int 时间
	*/
	public function api_check_user_sign_old($plat_user_name,$password,$time){
		$config = Wekit::C('site');
		$ticket_arr = array(
			'plat_user_name'=>$plat_user_name,
			'password'=>$password,
			'time'=>$time,
			);
		return md5(http_build_query($ticket_arr).$config['securityKey']);
	}

	/**
	 * 官网手机端同步登录
	 * @param String $username 		//用户名
	 * @param String $password 		//用户密码
	 * @return 
	 */
	/*public function getMobLogin($username, $password){
		$post_data = array(
			'account'=>$username,
			'password'=>$password,
			'remember'=>'1',
			);

		$config = Wekit::C()->getValues('site');
		$post_url = $config['info.mobweb'].'/account.php?c=account&a=login';

		$curl = curl_init($post_url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl,CURLOPT_HEADER,1); //将头文件的信息作为数据流输出
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($post_data));
		curl_setopt($curl, CURLOPT_TIMEOUT, 10);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
		$content = curl_exec($curl);
		curl_close($curl);

		$cookie_arr = array();
		preg_match_all('/Set-Cookie:(.*);/iU', $content, $cookie_arr); //正则匹配
		header('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');

		//在上一级域名设置cookie
		$url_str = explode('.', $config['info.url'], 2);
		$urlsite = $url_str[1];

		foreach ($cookie_arr[1] as $key => $value) {
			$cookie_array = explode('=', $value); 
			setCookie(trim($cookie_array[0]), $cookie_array[1], time()+60*60*24*7, '/', $urlsite);
		}

		return $content;
	}*/
}