<?php

Wind::import('SRV:forum.srv.manage.PwThreadManageDo');
Wind::import('SRV:forum.dm.PwTopicDm');

/**
 * 帖子管理操作-官方
 *
 * from src\service\forum\srv\manage\PwThreadManageDoDigest
 */

class PwThreadManageDoOfficial extends PwThreadManageDo {
	
	public $official;

	protected $tids;
	protected $isDeductCredit = true;
	protected $threads = array();
	
	/**
	 * 构造方法
	 *
	 * @param PwThreadManage $srv
	 */
	public function __construct(PwThreadManage $srv) {
		parent::__construct($srv);
	}
	
	/* (non-PHPdoc)
	 * @see PwThreadManageDo::check()
	 */
	public function check($permission) {
		return (isset($permission['official']) && $permission['official']) ? true : false;
	}
	
	/**
	 * 设置官方
	 *
	 * @param int $official
	 * @return PwThreadManageDoofficial
	 */
	public function setOfficial($official) {
		$this->official = intval($official);
		return $this;
	}

	/* (non-PHPdoc)
	 * @see PwThreadManageDo::gleanData()
	 */
	public function gleanData($value) {
		if ($value['official'] == $this->official) return;
		$this->tids[] = $value['tid'];
		$this->threads[] = $value;
	}
	
	/* (non-PHPdoc)
	 * @see PwThreadManageDo::run()
	 */
	public function run() {
		if ($this->tids) {
			$topicDm = new PwTopicDm(true);
			$topicDm->setOfficial($this->official);
			Wekit::load('forum.PwThread')->batchUpdateThread($this->tids, $topicDm, PwThread::FETCH_MAIN);
			$this->_addManageLog();
		}
	}
	
	/**
	 * 添加日志的
	 */
	private function _addManageLog() {
		if ($this->official == 1) {
			$type = 'degist';
		} else {
			$type = 'undegis';
		}
		/* @var $logSrv PwLogService */
		$logSrv = Wekit::load('log.srv.PwLogService');
		$logSrv->addThreadManageLog($this->srv->user, $type, $this->threads, $this->_reason);
		return true;
	}
}