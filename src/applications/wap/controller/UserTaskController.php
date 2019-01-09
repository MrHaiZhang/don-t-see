<?php

/**
 * 用户积分任务
 * form bbs\src\applications\task\controller\IndexController.php
 * 2017.12.12
 */
class UserTaskController extends PwBaseController {
	private $perpage = 20;

	/* (non-PHPdoc)
	 * @see PwBaseController::beforeAction()
	 */
	public function beforeAction($handlerAdapter) {
		parent::beforeAction($handlerAdapter);
		if (!$this->loginUser->isExists()) {
			$this->forwardAction('wap/login/run');
		}
		if (0 == Wekit::C('site', 'task.isOpen')) {
			//$this->showError('TASK:app.no.open');
		}
		$this->setOutput($this->perpage, 'perpage');
	}
	
	/* (non-PHPdoc)
	 * @see WindController::run()
	 */
	public function run() {
		$page = $this->_getPage();
		/* @var $taskDs PwTaskUser */
		$taskDs = Wekit::load('task.PwTaskUser');
		//查询是位与运算
		$count = $taskDs->countMyTasksByStatus($this->loginUser->uid, 7);
		$list = array();
		if ($count > 0) {
			$totalPage = ceil($count/$this->perpage);
			$page = $page < 1 ? 1 : ($page > $totalPage ? intval($totalPage) : $page);
			/*@var $taskService PwTaskService */
			$taskService = Wekit::load('task.srv.PwTaskService');
			$list = $taskService->getMyTaskListWithStatu($this->loginUser->uid, 7, $page, $this->perpage);
		}

		foreach ($list as $key => $value) {
			if($value['conditions']['child'] == 'punch'){
				unset($list[$key]);
			}
		}

		//签到
		$punch = unserialize($this->loginUser->info['punch']);

		$config = Wekit::C()->getValues('site');
		Wind::import('SRV:credit.bo.PwCreditBo');
		$creditBo = PwCreditBo::getInstance();
		foreach ($creditBo->cType as $key => $value) {
			if($config['punch.reward']['type'] == $key){
				$config['punch.reward']['type_name'] = $value;
				break;
			}
		}

		Wind::import('SRV:wap.HomeRequest');
		$home_request = new HomeRequest();
		$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));

		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setOutput($this->loginUser, 'loginUser');
		$this->setOutput($punch, 'punch');
		$this->setOutput($config, 'config');
		$this->setOutput(time(), 'time');
		$this->setOutput($count, 'count');
		$this->setOutput($list, 'list');
		$this->setOutput($this->_getTaskMode(), 'modes');
		$this->setTemplate('community_acc_point');
		
		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');

		$title_seo = $lang->getMessage('SEO:task.index.run.title');
		$title_arr = explode(' - ', $title_seo, 2);
		$title_seo = '我的积分 - '.$title_arr[1];
		$seoBo->setCustomSeo($title_seo, '', '');
		//$seoBo->setCustomSeo($lang->getMessage('SEO:task.index.run.title'), '', '');
		Wekit::setV('seo', $seoBo);
	}
	
	/**
	 * 获得页数
	 *
	 * @return int
	 */
	private function _getPage() {
		$page = intval($this->getInput('page'));
		($page < 1) && $page = 1;
		$this->setOutput($page, 'page');
		$this->setOutput($this->perpage, 'perpage');
		return $page;
	}
	
	/**
	 * 获得任务的模式
	 *
	 * @return array
	 */
	private function _getTaskMode() {
		$mode = array(1 => array('class' => 'task_mode_end', 'button' => '去做任务'),//已经领取
			2 => array('class' => 'task_mode_expired', 'button' => '已过期'),//已经关闭
			3 => array('class' => 'task_mode_expired', 'button' => '已过期'),//已经过期
			4 => array('class' => 'task_mode_end', 'button' => '继续完成'),//正在进行中
			5 => array('class' => 'task_mode_arrow', 'button' => '领取奖励'));//已完成
		return $mode;
	}
}
?>