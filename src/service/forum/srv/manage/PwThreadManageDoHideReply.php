<?php

Wind::import('SRV:forum.srv.manage.PwThreadManageDo');
Wind::import('SRV:forum.dm.PwReplyDm');

/**
 * 帖子管理操作-压帖
 *
 * from src\service\forum\srv\manage\PwThreadManageDoDown.php
 * @package forum
 */

class PwThreadManageDoHideReply extends PwThreadManageDo {
	
	protected $pids;
	protected $hide_other;

	public function check($permission) {
		if (!$this->srv->user->comparePermission(Pw::collectByKey($this->srv->data, 'created_userid'))) {
			return new PwError('permission.level.down', array('{grouptitle}' => $this->srv->user->getGroupInfo('name')));
		}
		return true;
	}

	public function gleanData($value) {
		$this->pids[] = $value['pid'];
	}

	public function setHideOther($hide_other) {
		$this->hide_other = $hide_other;
		return $this;
	}
	
	public function run() {
		$dm = new PwReplyDm(true);
		$dm->setHideOther($this->hide_other);
		Wekit::load('forum.PwThread')->batchUpdatePost($this->pids, $dm);
		
		Wekit::load('log.srv.PwLogService')->addThreadManageLog($this->srv->user, 'hidereply', $this->srv->getData(), '', '', true);
	}
}