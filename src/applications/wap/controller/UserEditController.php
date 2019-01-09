<?php
Wind::import('APPS:.profile.controller.BaseProfileController');
Wind::import('SRV:user.srv.PwUserProfileService');
Wind::import('SRV:user.validator.PwUserValidator');
Wind::import('SRV:user.PwUserBan');
Wind::import('APPS:profile.service.PwUserProfileExtends');

/**
 * 手机端用户信息
 * form src\applications\profile\controller\IndexController.php
 * 2017.11.02
 */
class UserEditController extends BaseProfileController {

	public function beforeAction($handlerAdapter) {
		$fid = intval($this->getInput('fid'));		//版块id
		$this->setOutput($fid, 'fid');
		parent::beforeAction($handlerAdapter);
		//不让页面乱跳
		$this->setLayout('');
		$this->setCurrentLeft('profile');
	}

	public function run() {
		$userInfo = Wekit::load('user.PwUser')->getUserByUid($this->loginUser->uid, PwUser::FETCH_INFO);
		$userInfo = array_merge($this->loginUser->info, $userInfo);
		
		//上传图片的相关信息
		$windidApi = $this->_getWindid();
		$this->setOutput($windidApi->showFlash($this->loginUser->uid, 0), 'avatarArr');

		$this->setOutput(time(), 'time_v');
		$this->setOutput($userInfo, 'userinfo');
		$this->setTemplate('community_user_change');

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$seoBo->setCustomSeo($lang->getMessage('SEO:profile.index.run.title'), '', '');
		Wekit::setV('seo', $seoBo);
	}
	
	/** 
	 * 编辑用户信息
	 */
	public function dorunAction() {
		$this->getRequest()->isPost() || $this->showError('operate.fail');

		$userDm = new PwUserInfoDm($this->loginUser->uid);
		$userDm->setGender($this->getInput('gender', 'post'));
		list($nickname, $sensitive) = $this->checkNickname(trim($this->getInput('nickname', 'post')));
		$userDm->setNickname($nickname);
		$sensitive && $userDm->setSensitive(implode(',', $sensitive));
		$mobile = $this->getInput('mobile', 'post');

		if ($mobile) {
			$r = PwUserValidator::isMobileValid($mobile);
			
			if ($r instanceof PwError){
				if($r->getError() == 'USER:mobile.error.formate'){
					$return_arr = array(
						'state'=>'word',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				}
				$this->showError($r->getError());
			} 
		}
		$userDm->setMobile($mobile);
		
		$result = $this->_editUser($userDm, PwUser::FETCH_MAIN + PwUser::FETCH_INFO);
		if ($result instanceof PwError) {
			$this->showError($result->getError());
		} else {
			$return_arr = array(
				'state'=>'success',
				'msg'=>'',
				);
			echo json_encode($return_arr);
			exit;
			// $this->loginUser->info = array_merge($this->loginUser->info, $userDm->getData());
			// $this->showMessage('USER:user.edit.profile.success');
		}
	}

	/** 
	 * 设置用户头像为未审核
	 */
	public function hascheckAction() {
		$this->getRequest()->isPost() || $this->showError('operate.fail');

		$userDm = new PwUserInfoDm($this->loginUser->uid);
		$userDm->setHeadcheck(1);
		
		
		$result = $this->_editUser($userDm, PwUser::FETCH_INFO);
		if ($result instanceof PwError) {
			$this->showError($result->getError());
		} else {
			//本来不应该在这，正式环境找不到失败原因，放弃了
			PwSimpleHook::getInstance('update_avatar')->runDo($userDm->uid); //服务端发送通知
			$return_arr = array(
				'state'=>'success',
				'msg'=>'',
				);
			echo json_encode($return_arr);
			exit;
		}
	}

	/**
	 * 编辑用户信息
	 *
	 * @param PwUserInfoDm $dm
	 * @param int $type
	 * @return boolean|PwError
	 */
	private function _editUser($dm, $type = PwUser::FETCH_MAIN) {
		/* @var $userDs PwUser */
		$userDs = Wekit::load('user.PwUser');
		$result = $userDs->editUser($dm, $type);
		if ($result instanceof PwError) return $result;
		/*用户资料设置完成-基本资料-service钩子点:s_PwUserService_editUser*/
		PwSimpleHook::getInstance('profile_editUser')->runDo($dm);
		return true;
	}


	private function _getWindid() {
		return WindidApi::api('avatar');
	}

	/**
	 * 检查用户昵称
	 * @param  [type] $nickname [用户昵称]
	 * @return [bool]           
	 */
	private function checkNickname($nickname){
		if($nickname == ''){
			return '';
		}

		//敏感词检查
		Wind::import('SRV:word.srv.PwWordFilter');
		$wordf_obj = new PwWordFilter();
		list($type, $words, $isTip) = $wordf_obj->filterWord($nickname);

		if(mb_strlen($nickname, 'UTF8') > 8 || mb_strlen($nickname, 'UTF8') < 2){
			$return_arr = array(
				'state'=>'nn_out',
				'msg'=>'',
				);
			echo json_encode($return_arr);
			exit;
		}
		
		$preg = "/^(?!_)(?!.*?_$)[a-zA-Z0-9_\x{4e00}-\x{9fa5}]*$/u";
		if(preg_match($preg, $nickname)){
			return array($nickname, $words);
		} else{
			$return_arr = array(
				'state'=>'nn_fail',
				'msg'=>preg_match($preg, $nickname),
				);
			echo json_encode($return_arr);
			exit;
		}
	}
}	