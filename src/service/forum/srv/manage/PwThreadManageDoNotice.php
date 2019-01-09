<?php

Wind::import('SRV:forum.srv.manage.PwThreadManageDo');
Wind::import('SRV:forum.dm.PwTopicDm');

/**
 * 帖子管理操作-官方
 *
 * from src\service\forum\srv\manage\PwThreadManageDoDigest
 */

class PwThreadManageDoNotice extends PwThreadManageDo {
	
	public $notice;

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
		return (isset($permission['notice']) && $permission['notice']) ? true : false;
	}
	
	/**
	 * 设置公告
	 *
	 * @param int $notice
	 * @return PwThreadManageDonotice
	 */
	public function setNotice($notice) {
		$this->notice = intval($notice);
		return $this;
	}

	/* (non-PHPdoc)
	 * @see PwThreadManageDo::gleanData()
	 */
	public function gleanData($value) {
		if ($value['notice'] == $this->notice) return;
		$this->tids[] = $value['tid'];
		$this->threads[] = $value;
	}
	
	/* (non-PHPdoc)
	 * @see PwThreadManageDo::run()
	 */
	public function run() {
		if ($this->tids) {
			$topicDm = new PwTopicDm(true);
			$topicDm->setNotice($this->notice);
			Wekit::load('forum.PwThread')->batchUpdateThread($this->tids, $topicDm, PwThread::FETCH_MAIN);
			$this->_addManageLog();
		}
	}
	
	
	/**
	 * 添加日志的
	 */
	private function _addManageLog() {
		if ($this->notice == 1) {
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