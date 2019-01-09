<?php
Wind::import('ADMIN:library.AdminBaseController');
Wind::import('SRV:user.vo.PwUserSo');
Wind::import('SRV:user.dm.PwUserInfoDm');

/**
 * 用户头像审核
 * form src\applications\u\admin\ManageController.php
 * 2017.11.02
 */

class UserHeaderController extends AdminBaseController {
	
	private $perpage = 10;

	/* (non-PHPdoc)
	 * @see WindController::run()
	 */
	public function run() {
		list($page, $perpage) = $this->getInput(array('page', 'perpage'));
		$page = $page ? $page : 1;
		$perpage = $perpage > 0 ? $perpage : $this->perpage;
		$vo = new PwUserSo();
		$vo->setHeadcheck(1);
		$page = intval($page) == 0 ? 1 : abs(intval($page));
		/* @var $searchDs PwUserSearch */
		$searchDs = Wekit::load('SRV:user.PwUserSearch');
		$count = $searchDs->countSearchUser($vo);
		$result = array();
		if (0 < $count) {
			$totalPage = ceil($count/$perpage);
			$page > $totalPage && $page = $totalPage;
			/* @var $searchDs PwUserSearch */
			list($start, $limit) = Pw::page2limit($page, $perpage);
			$result = $searchDs->searchUser($vo, $limit, $start);
		}

		$this->setOutput($count, 'count');
		$this->setOutput($page, 'page');
		$this->setOutput($perpage, 'perpage');
		$this->setOutput(time(), 'time_v');
		$this->setOutput($result, 'list');
	}
	
	
	/** 
	 * 批量审核
	 *
	 */
	public function docheckAction() {
		$uids = $this->getInput('uid', 'post');
		$disagree = $this->getInput('disagree', 'get');		//是否不通过
		if (!$uids) $this->showError('operate.select');

		$userDs = Wekit::load('user.PwUser');
		foreach ($uids as $_temp) {
			if($disagree == 1){
				//恢复系统头像
				Wekit::load('user.srv.PwUserService')->restoreDefualtAvatar($_temp);
			}
			$userDm = new PwUserInfoDm($_temp);
			$userDm->setHeadcheck(0);
			$result = $userDs->editUser($userDm, PwUser::FETCH_INFO);
		}
		$this->showMessage('operate.success');
	}

}