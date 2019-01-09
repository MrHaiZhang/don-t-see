<?php
Wind::import('ADMIN:library.AdminBaseController');
/**
 * 后台用户积分管理Controller
 * from src\applications\message\admin\ManageController.php
 * from src\applications\u\admin\ManageController.php
 *
 * 增加操作理由录入
 */
class PointController extends AdminBaseController {
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

		//积分组
		Wind::import('SRV:credit.bo.PwCreditBo');
		$pwCreditBo = PwCreditBo::getInstance();

		$this->setOutput($members, 'members');
		$this->setOutput($othergroup, 'othergroup');
		$this->setOutput($memberGroupTypes, 'memberGroupTypes');
		$this->setOutput($groupGroupTypes, 'groupGroupTypes');
		$this->setOutput($pwCreditBo->cType, 'pwCreditBo');
		$this->setTemplate('user_point');
	}
	
	/**
	 * do群发消息
	 *
	 * @return void
	 */
	public function doEditAction() {
		list($type,$point_type,$point,$step,$countStep) = $this->getInput(array('type','point_type','point','step','countStep'));
		!$point && exit(json_encode(array('state'=>'fail', 'message'=>'修改积分不能为空')));
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
		$result = $this->doEditCreditAction((array)$userInfos,$point_type,$point);
		if ($result instanceof PwError) $this->showError($result->getError());
		$haveBuild = $step * $this->perstep;
		$haveBuild = ($haveBuild > $count) ? $count : $haveBuild;
		$step++;
		usleep(500);
		$data = array('step' => $step,
					'countStep' => $countStep,
					'count' => $count,
					'haveBuild' => $haveBuild
				);
		Pw::echoJson(array('data' => $data));exit;
	}


	/**
	 * [doEditCreditAction 设置用户积分]
	 * @param  [array] $userInfos  [用户信息]
	 * @param  [int] $point_type [积分类型]
	 * @param  [int] $point      [积分修改数]
	 * @return void
	 */
	public function doEditCreditAction($userInfos, $point_type, $point) {
		if (!$userInfos) {
			return new PwError('Message:user.notfound');
		}

		//操作理由
		$action_reason = $this->getInput('action_reason');
		/* @var $pwUser PwUser */
		$pwUser = Wekit::load('user.PwUser');
		foreach ($userInfos as $info) {
			$userCredits = $pwUser->getUserByUid($info['uid'], PwUser::FETCH_DATA);

			$org = isset($userCredits['credit' . $point_type]) ? $userCredits['credit' . $point_type] : 0;
			$point_value = $org + $point;
			
			Wind::import('SRV:credit.bo.PwCreditBo');
			/* @var $creditBo PwCreditBo */
			$creditBo = PwCreditBo::getInstance();
			$creditBo->addLog('admin_set', array($point_type=>$point), new PwUserBo($info['uid']), array('action_reason'=>$action_reason, 'adminname'=>$this->loginUser->username));
			$creditBo->execute(array($info['uid'] => array($point_type=>$point_value)), false);

			//发送用户通知
			$params = array();
			$params['change_type'] = 'change';		//积分修改
			$params['credit'] = $creditBo->cType[$point_type];
			$params['num'] = $point;
			$params['action_reason'] = $action_reason;

			$noticeService = Wekit::load('message.srv.PwNoticeService');
			$noticeService->sendNotice($info['uid'], 'credit', 0, $params);
		}
		return true;
	}
	
}