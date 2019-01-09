<?php
defined('WEKIT_VERSION') || exit('Forbidden');

/**
 * controller 基类
 *
 * @author Jianmin Chen <sky_hold@163.com>
 * @license http://www.phpwind.com
 * @version $Id: PwBaseController.php 29863 2013-07-02 03:28:46Z gao.wanggao $
 * @package lib.base.controller
 */
class PwBaseController extends WindController {

	/**
	 * 当前用户信息
	 *
	 * @var PwUserBo $loginUser
	 */
	protected $loginUser;
	protected $_m;
	protected $_c;
	protected $_a;
	protected $_mc;
	protected $_mca;
	protected $redis_obj = null;
	
	/*
	 * (non-PHPdoc) @see WindSimpleController::beforeAction()
	 */
	public function beforeAction($handlerAdapter) {
		//$this->getWxLogin();

		$this->_m = $handlerAdapter->getModule();
		$this->_c = $handlerAdapter->getController();
		$this->_a = $handlerAdapter->getAction();
		$this->_mc = $this->_m . '/' . $this->_c;
		$this->_mca = $this->_mc . '/' . $this->_a;
		
		$this->loginUser = Wekit::getLoginUser();
		$this->setTheme('site', null);

		$this->setOutput(time(), 'time_v');

		//登录数据处理
		if ($this->loginUser && $this->loginUser->isExists()) {
			
			//获取csrf_token
			if($_COOKIE['csrf_token'] == ''){
				Pw::setCookie('csrf_token', Wind::getComponent('windToken')->saveToken('csrf_token'));
			}

			$redis_obj = $this->getRedis();
			$userInfo = Wekit::load('user.PwUser')->getUserByUid($this->loginUser->uid, PwUser::FETCH_INFO);
			$userData = array(
				'username'=>$this->loginUser->info['username'],
				'ident_id'=>$this->loginUser->info['ident_id'],
				'mobile'=>$userInfo['mobile'],
				'nickname'=>$userInfo['nickname'],
				);

			$user_list = $redis_obj->getUserUpDayCount($userData['username']);
			if($userData['username'] != $user_list['username']){
				//更新登录cookie
				$name = 'winduser';
				$pre = Wekit::C('site', 'cookie.pre');
				$pre && $name = $pre . '_' . $name;
				Pw::setCookie('winduser', $_COOKIE[$name], 60*60*24*7);

				//更新任务
				Wind::import('SRV:user.srv.PwLoginService');
				$pls_obj = new PwLoginService();
				$pls_obj->runDo('welcome', $this->loginUser,$this->getRequest()->getClientIp());

				//设置日活跃用户
				$redis_obj->setUserUpDayCount($userData);

				//触发计划任务
				$url_arr = Wekit::url();
				$runCron_url = $url_arr->base.'/index.php?m=cron';

				$ch = curl_init();
				$timeout = 1;
				curl_setopt ($ch, CURLOPT_URL, $runCron_url);
				curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
				$file_contents = curl_exec($ch);
				curl_close($ch);
			}
			
		}
		
	}


	/**
	 * 显示信息
	 *
	 * @param string $message 消息信息
	 * @param string $referer 跳转地址
	 * @param boolean $referer 是否刷新页面
	 * @see WindSimpleController::showMessage()
	 */
	protected function showMessage($message = '', $referer = '', $refresh = false) {
		$this->addMessage('success', 'state');
		$this->addMessage($this->forward->getVars('data'), 'data');
		$this->addMessage($this->forward->getVars('html'), 'html');
		$this->showError($message, $referer, $refresh);
	}

	/**
	 * 显示错误
	 *
	 * @param string $error 消息信息
	 * @param string $referer 跳转地址
	 * @param boolean $referer 是否刷新页面
	 */
	protected function showError($error = '', $referer = '', $refresh = false) {
		if ($referer && !WindValidator::isUrl($referer)) {
			$_referer = explode('#', $referer, 2);
			$referer = WindUrlHelper::createUrl($_referer[0], array(), 
				isset($_referer[1]) ? $_referer[1] : '');
		}
		$this->addMessage($referer, 'referer');
		$this->addMessage($refresh, 'refresh');
		parent::showMessage($error);
	}
	
	/*
	 * (non-PHPdoc) @see WindSimpleController::setDefaultTemplateName()
	 */
	protected function setDefaultTemplateName($handlerAdapter) {
		$this->setTemplate($handlerAdapter->getController() . '_' . $handlerAdapter->getAction());
	}
	
	/*
	 * (non-PHPdoc) @see WindSimpleController::afterAction()
	 */
	public function afterAction($handlerAdapter) {
		$this->setOutput($this->loginUser, 'loginUser');
	}

	/**
	 * action Hook 注册
	 *
	 * @param string $registerKey 扩展点别名
	 * @param PwBaseHookService $bp        	
	 * @throws PwException
	 * @return void
	 */
	protected function runHook($registerKey, $bp) {
		if (!$registerKey) return;
		if (!$bp instanceof PwBaseHookService) {
			throw new PwException('class.type.fail', 
				array(
					'{parm1}' => 'src.library.base.PwBaseController.runHook', 
					'{parm2}' => 'PwBaseHookService', 
					'{parm3}' => get_class($bp)));
		}
		if (!$filters = PwHook::getRegistry($registerKey)) return;
		if (!$filters = PwHook::resolveActionHook($filters, $bp)) return;
		$args = func_get_args();
		$_filters = array();
		foreach ($filters as $key => $value) {
			$args[0] = isset($value['method']) ? $value['method'] : '';
			$_filters[] = array('class' => $value['class'], 'args' => $args);
		}
		$this->resolveActionFilter($_filters);
	}
	


	/**
	 * 风格设置
	 *
	 * 设置当前页面风格，需要两个参数，$type风格类型，$theme该类型下风格
	 *
	 * @see WindSimpleController::setTheme()
	 * @param string $type 风格类型(site,space,area...)
	 * @param string $theme 风格别名
	 */
	protected function setTheme($type, $theme) {
		$config = Wekit::C('site');
		$themePack = $config['theme.' . $type . '.pack'];
		$themePack = 'THEMES:' . $themePack;

		// 风格预览，管理员权限
		if ($style = Pw::getCookie('style_preview')) {
			list($s_theme, $s_type) = explode('|', $style, 2);
			if ($s_type == $type) {
				$theme = $s_theme;
				Wekit::C()->site->set('theme.' . $type . '.default', $theme);
			}
		}
		if (!$theme) $theme = $config['theme.' . $type . '.default'];
		parent::setTheme($theme, $themePack);
	}

	//返回redis对象
	public function getRedis(){
		if($this->redis_obj == null){
			$config = 'APPS:wap.conf.RedisConf.php';
			$config = include_once Wind::getRealPath($config, true);
			Wind::import('APPS:wap.library.MyRedis');
			$this->redis_obj = new MyRedis($g_c);
		}
		return $this->redis_obj;
	}

	//获取微信登录
	public function getWxLogin(){
		$code = $this->getInput('code', 'get');
		$state = $this->getInput('state', 'get');

		$AppId = 'wx4107c483a73ca363';
		$AppSecret = '534a44daaf6502ad33c3b0a45aa30076';

		if(!$_COOKIE['wx_refresh_token'] && !$code){
			$this->getWxCode($AppId, $AppSecret);
		} else if($state == $_COOKIE['wx_state'] && $code){
			$url = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid={$AppId}&secret={$AppSecret}&code={$code}&grant_type=authorization_code';

			$ch = curl_init();
			$timeout = 10;
			curl_setopt ($ch, CURLOPT_URL, $url);
			curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
			curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, false);
			$file_contents = curl_exec($ch);
			curl_close($ch);
			echo $file_contents;
			$return_arr = json_decode($file_contents, true);

			if($return_arr['access_token'] && $return_arr['refresh_token']){
				Pw::setCookie('wx_access_token', $return_arr['access_token'], 60*60*2);
				Pw::setCookie('wx_refresh_token', $return_arr['refresh_token'], 60*60*24*30);
			} else{
				$this->getWxCode($AppId, $AppSecret);
			}
		}
	}

	//获取微信登录code
	public function getWxCode(){
		$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
		$redirect_uri = urlencode("$protocol$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]");

		$state = rand(0, 10000);
		Pw::setCookie('wx_state', $state, 60*10);

		$url = "https://open.weixin.qq.com/connect/qrconnect?appid={$AppId}&redirect_uri={$redirect_uri}&response_type=code&scope=snsapi_login&state={$state}#wechat_redirect";
		header('location:'.$url);
	}
}