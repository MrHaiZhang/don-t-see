<?php
Wind::import('ADMIN:library.AdminBaseController');
/**
 * 后台用户积分管理Controller
 * from src\applications\message\admin\ManageController.php
 * from src\applications\u\admin\ManageController.php
 *
 * 增加操作理由录入
 */
class GiftExendController extends AdminBaseController {
	private $perpage = 20;
	private $perstep = 10;
	
	public function run() {
		// 用户组
		$userGroup = Wekit::load('usergroup.PwUserGroups');
		$groups = $userGroup->getAllGroups();
		$groupTypes = $userGroup->getTypeNames();
		$memberGroupTypes = $groupGroupTypes = array();
		foreach($groups as $key => $group){ 
			if ($group['type'] == 'member') {
				$group['grouptype'] = 'memberid';
				$members[$key] = $group;
				$memberGroupTypes[$group['type']] = $groupTypes[$group['type']];
			} else {
				$group['grouptype'] = 'groupid';
				$othergroup[$key] = $group;
				$groupGroupTypes = array_diff_key($groupTypes,$memberGroupTypes);
			}
		}

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥
		Wind::import('APPS:wap.controller.GiftController');
		$gift_obj = new GiftController();
		//获取后台发送礼包
		$gift_list = $gift_obj->getWebGift(99999, '', 'admin', $appweb, $securityKey);
		
		$this->setOutput($members, 'members');
		$this->setOutput($othergroup, 'othergroup');
		$this->setOutput($memberGroupTypes, 'memberGroupTypes');
		$this->setOutput($groupGroupTypes, 'groupGroupTypes');
		$this->setOutput((array)$gift_list['data'], 'gift_list');
		$this->setTemplate('gift_exend');
	}
	
	/**
	 * do群发消息
	 *
	 * @return void
	 */
	public function doEditAction() {
		list($type,$gift_id,$step,$countStep) = $this->getInput(array('type','gift_id','step','countStep'));
		$gift_id == 0 && exit(json_encode(array('state'=>'fail', 'message'=>'请选择发放礼包')));
		if ($step > $countStep) {
			$this->showMessage("ADMIN:success");
		}
		$step = $step ? $step : 1;
		switch ($type) {
			case 1:  // 根据用户组
				list($user_groups,$grouptype) = $this->getInput(array('user_groups','grouptype'));
				Wind::import('SRV:user.vo.PwUserSo');
				$vo = new PwUserSo();
				$searchDs = Wekit::load('SRV:user.PwUserSearch');
				if (!$user_groups) $this->showError('Message:user.groups.empty');
				if ($grouptype == 'memberid') {
					$vo->setMemberid($user_groups);
				} else {
					$vo->setGid($user_groups);
				}	
				$count = $searchDs->countSearchUser($vo);
				$countStep = ceil($count/$this->perstep);
				if ($step <= $countStep) {
					list($start, $limit) = Pw::page2limit($step, $this->perstep);
					$userInfos = $searchDs->searchUser($vo, $limit, $start);
				}
				break;
			case 2:  // 根据用户名
				$touser = $this->getInput('touser');
				!$touser && $this->showError('Message:receive.user.empty');
				$touser = explode("\n", $touser);
				$count = count($touser);
				$countStep = ceil($count/$this->perstep);
				if ($step <= $countStep) {
					$userDs = Wekit::load('user.PwUser');
					list($start, $limit) = Pw::page2limit($step, $this->perstep);
					$userInfos = $userDs->fetchUserByName(array_slice($touser, $start, $limit));
				}
				break;
			case 3:  // 根据在线用户(精确在线)
				$onlineService = Wekit::load('online.srv.PwOnlineCountService');
				list($count,$userInfos) = $onlineService->getVisitorList('', $step, $this->perstep, true); 
				$countStep = ceil($count/$this->perstep);
				break;
		}
		$false_str = $this->doGetGiftAction((array)$userInfos, $gift_id);
		if($false_str != ''){
			$false_str .= "\n\r";
		}

		$haveBuild = $step * $this->perstep;
		$haveBuild = ($haveBuild > $count) ? $count : $haveBuild;
		$step++;
		usleep(500);
		$data = array('step' => $step,
					'countStep' => $countStep,
					'count' => $count,
					'haveBuild' => $haveBuild,
					'false_str' => $false_str
				);
		Pw::echoJson(array('data' => $data));exit;
	}


	/**
	 * [doGetGiftAction 发放礼包]
	 * @param  [array] $userInfos  [用户信息]
	 * @param  [int] $gift_id [礼包id]
	 * @return void
	 */
	public function doGetGiftAction($userInfos, $gift_id) {
		if (!$userInfos) {
			return new PwError('Message:user.notfound');
		}

		$false_arr = array();
		if($gift_id <= 0){
			foreach ($userInfos as $info) {
				$false_arr[] = $info['username'];
			}
			return implode("\r\n", $false_arr);
		}

		//操作理由
		$action_reason = $this->getInput('action_reason');

		$noticeService = Wekit::load('message.srv.PwNoticeService');

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥
		Wind::import('APPS:wap.controller.GiftController');
		$gift_obj = new GiftController();
		$gift_list = $gift_obj->getWebGift(99999, '', 'admin', $appweb, $securityKey);
		foreach ($gift_list['data'] as $key => $value) {
			if($gift_id == $value['gift_id']){
				$gift_name = $value['gift_name'];
			}
		}
		$action_reason = str_replace('{gift_name}', $gift_name, $action_reason);

		foreach ($userInfos as $info) {
			$get_gfit_arr = array(
				'gift_id' => $gift_id,
				'plat_user_name' => $info['username'],
				'appweb' => $appweb,
				'securityKey' => $securityKey,
			);
			$code_data = $this->getGiftAction($get_gfit_arr);
			if($code_data && $code_data['code'] == 1){
				$str_action_reason = $action_reason;
				$str_action_reason = str_replace('{code}', $code_data['gift_code'], $str_action_reason);

				$extendParams = array(
					'username' => $info['username'],
					'title'	   => '礼包发送',
					'content' => $str_action_reason,
				);
				$noticeService->sendNotice($info['uid'],'massmessage','',$extendParams);
			} else{
				$false_arr[] = $info['username'];
			}
		}
		return implode("\r\n", $false_arr);
	}

	/**
	 * [doGetGiftAction 发放礼包]
	 * @param  [array] $userInfos  [用户信息]
	 * @param  [int] $gift_id [礼包id]
	 * @return void
	 */
	public function getGiftAction($get_gfit_arr){
		if($get_gfit_arr['gift_id'] <= 0){
			return false;
		}

		$post_data = array(
			'plat_user_name'=>$get_gfit_arr['plat_user_name'],
			'sign_type'=>'NG',
			'gift_id'=>$get_gfit_arr['gift_id'],
			'point_ng'=>'',
			'ip_address'=>bindec(decbin(ip2long($this->get_client_ip()))),
			'ticket'=>md5($get_gfit_arr['plat_user_name'].$get_gfit_arr['securityKey']),
			);
		$post_url = $get_gfit_arr['appweb'].'/index.php?c=bbsapi&a=api_get_gift';

		$content = $this->curlPost($post_url, $post_data);
		$return_data = json_decode($content, true);

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
	
}