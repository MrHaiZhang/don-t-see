<?php
defined('WEKIT_VERSION') || exit('Forbidden');


Wind::import('ADMIN:library.AdminBaseController');


class ManagecountController extends AdminBaseController {
	
	private $perpage = 20;

	//管理统计
	//form src\applications\log\admin\ManageController.php
	public function run(){
		$sName = $this->getInput('created_user');
		$start_time = $this->getInput('start_time');
		$end_time = $this->getInput('end_time');

		$start_time ? $start_time = Pw::str2time($start_time, 'Y-m-d') : $start_time = Pw::str2time(Pw::time2str(Pw::getTime(), 'Y-m-d'));
		$end_time ? $end_time =  Pw::str2time($end_time, 'Y-m-d')+60*60*24 : $end_time = Pw::str2time(Pw::time2str(Pw::getTime(), 'Y-m-d'))+60*60*24;
		$log_start_time = Pw::time2str($start_time, 'Y-m-d H:i:s');
		$log_end_time = Pw::time2str($end_time, 'Y-m-d H:i:s');

		$groupDs = Wekit::load('usergroup.PwUserGroups');
		$groups = $groupDs->getNonUpgradeGroups();
		$gid = array();
		foreach ($groups as $key => $value) {
			if($value['name'] == '论坛客服'){
				$gid[] = $value['gid'];
			}
			if($value['name'] == '运营'){
				$gid[] = $value['gid'];
			}
		}

		Wind::import('SRV:user.vo.PwUserSo');
		$page = intval($this->getInput('page'));
		($page < 1) && $page = 1;

		$vo = new PwUserSo();
		$gid && $vo->setGid($gid);		//论坛客服组
		$sName && $vo->setUsername($sName);

		
		/* @var $searchDs PwUserSearch */
		$searchDs = Wekit::load('user.PwUserSearch');
		$count = $searchDs->countSearchUser($vo);
		$totalPage = ceil($count/$this->perpage);
		$page > $totalPage && $page = $totalPage;
		list($start, $limit) = Pw::page2limit($page, $this->perpage);
		$result = $searchDs->searchUserAllData($vo, $limit, $start);	


		
		$pwthread_obj = Wekit::load('forum.PwThread');
		Wind::import('SRV:log.so.PwLogSo');
		$logDs = Wekit::load('log.PwLog');
		$logSo = new PwLogSo();
		foreach ($result as $key=>$value) {
			//回复数量
			$result[$key]['reply_all'] = $pwthread_obj->countPostByUidAndList($value['uid'], $start_time, $end_time, 0, false);
			//回帖数量
			$result[$key]['reply_thread'] = $pwthread_obj->countPostByUidAndList($value['uid'], $start_time, $end_time, 0, 0);
			//回楼层数量
			$result[$key]['reply_lou'] = $result[$key]['reply_all'] - $result[$key]['reply_thread'];

			$logSo->setEndTime($log_end_time)
				->setStartTime($log_start_time)
				->setCreatedUsername($value['username']);
			//管理操作数
			$result[$key]['manage_count'] = $logDs->coutSearch($logSo);
		}

		$this->setOutput($page, 'page');
		$this->setOutput($this->perpage, 'perpage');
		$this->setOutput($count, 'count');
		$this->setOutput($result, 'list');
		$this->setOutput(Pw::time2str($start_time, 'Y-m-d'), 'start_time');
		$this->setOutput(Pw::time2str($end_time, 'Y-m-d'), 'end_time');
		$this->setOutput($sName, 'created_user');
		$this->setTemplate('managecount_run');
	}
}
?>