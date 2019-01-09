<?php

Wind::import('APPS:.profile.controller.BaseProfileController');
Wind::import('SRV:credit.bo.PwCreditBo');

/**
 * 积分记录、礼包领取记录模块
 * 2017.12.19
 *
 * form src\applications\profile\controller\CreditController.php
 */
class RecordController extends PwBaseController {
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
		$load_type = $this->getInput('load_type');
		$page = intval($this->getInput('page'));
		$page < 1 && $page = 1;

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$gift_list = $this->getGiftLog();

		$credit_list = $this->getCreditLog($page);

		Wind::import('SRV:wap.HomeRequest');
		$home_request = new HomeRequest();
		$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));


		$this->setOutput($load_type, 'load_type');
		$this->setOutput($this->loginUser, 'loginUser');
		$this->setOutput($gift_list, 'gift_list');
		$this->setOutput($credit_list, 'credit_list');
		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');
		$this->setTemplate('community_game_gift_record');
		
		//seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$seoBo->init('bbs', 'forumlist');
		Wekit::setV('seo', $seoBo);
	}

	public function AjaxRunAction(){
		$type = $this->getInput('type');
		$page = intval($this->getInput('page'));
		$page < 1 && $page = 1;

		if($type == 'gift'){
			$data_list = $this->getGiftLog();
		} else{
			$data_list = $this->getCreditLog($page);
		}

		echo json_encode($data_list);
		exit;
	}

	/**
	 * 积分日志
	 */
	public function getCreditLog($page) {
		$perpage = $this->perpage;
		list($offset, $limit) = Pw::page2limit($page, $perpage);

		Wind::import('SRV:credit.srv.PwCreditOperationConfig');
		Wind::import('SRV:credit.vo.PwCreditLogSc');
		
		$sc = new PwCreditLogSc();

		$count = Wekit::load('credit.PwCreditLog')->countLogByUid($this->loginUser->uid);
		$log = Wekit::load('credit.PwCreditLog')->getLogByUid($this->loginUser->uid, $limit, $offset);

		$credit_list = array();
		if($count <= $page*$this->perpage){
			$credit_list['is_bottom'] = 1;
		} else{
			$credit_list['is_bottom'] = 0;
		}

		$data_list = $credit_list['data'];
		foreach ($log as $key => $value) {
			$log[$key]['created_time'] = Pw::time2str($log[$key]['created_time']);

			if($value['logtype'] == 'punch'){
				$log[$key]['logname'] = '每日签到';
			} elseif($value['logtype'] == 'gain_gift'){
				$log[$key]['logname'] = '获取礼包';
			} elseif($value['logtype'] == 'admin_set'){
				$con_arr = explode('-', $value['descrip']);
				$con_arr = explode(';', $con_arr[1]);
				$log[$key]['logname'] = $con_arr[0];
			} elseif($value['logtype'] == 'task_reward'){
				$content_arr = explode('完成任务', $value['descrip']);
				$content_arr[1] && $content_arr2 = explode('获得奖励', $content_arr[1]);
				$content_arr2[0] && $log[$key]['logname'] = $content_arr2[0];
			} else{
				unset($log[$key]);
				//$log[$key]['logname'] = '神秘奖励';
			}
		}
		$credit_list['data'] = array_values($log);
		$credit_list['page'] = $page;
		if(!is_array($log) || !$log){
			$credit_list['code'] = -1;
		} else{
			$credit_list['code'] = 1;
		}

		return $credit_list;
	}


	//获取礼包领取记录
	public function getGiftLog(){
		$ajax = $this->getInput('ajax');		//是否ajax
		$current_id = intval($this->getInput('current_id'));		//最后的礼包id

		//网站配置
		$config = Wekit::C()->getValues('site');
		$appweb = $config['info.appweb'];		//官网域名
		$securityKey = $config['securityKey'];		//秘钥

		$post_data = array(
			'plat_user_name'=>$this->loginUser->username,
			'sign_type'=>'NG',
			'ajax'=>$ajax,
			'perpage'=>$this->perpage,
			'current_id'=>$current_id,
			'ticket'=>md5($this->loginUser->username.$securityKey),
			);

		$post_url = $appweb.'/index.php?c=bbsapi&a=api_get_user_gift';

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
?>