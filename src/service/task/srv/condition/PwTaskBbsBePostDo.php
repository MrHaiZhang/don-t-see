<?php
Wind::import('SRV:forum.srv.post.do.PwPostDoBase');
Wind::import('SRV:task.srv.PwTaskComplete');
Wind::import('SRV:task.srv.base.PwTaskCompleteInterface');
/**
 * 回帖扩展
 *
 * @author Shi Long <long.shi@alibaba-inc.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.windframework.com
 * @version $Id: PwTaskBbsPostDo.php 20491 2012-10-30 08:15:09Z xiaoxia.xuxx $
 * @package service.task.srv.condition
 */
class PwTaskBbsBePostDo extends PwPostDoBase implements PwTaskCompleteInterface {
	
	private $tid;
	private $uid;
	
	public function __construct(PwPost $pwpost) {
		//被回复id
		$this->uid = $pwpost->bereplyuid;
		$this->tid = $pwpost->action->tid;
	}
	
	public function addPost($pid, $tid) {
		if (!Wekit::C('site', 'task.isOpen')) return true;
		$bp = new PwTaskComplete($this->uid, $this);
		$bp->doTask('bbs', 'bereply');
	}
	
	/* (non-PHPdoc)
	 * @see PwTaskCompleteInterface::doTask()
	 */
	public function doTask($conditions, $step) {
		if ($conditions['tid'] != $this->tid && $conditions['tid'] != 0) return false;
		$isComplete = false;
		if (isset($step['percent']) && $step['percent'] == '100%') {
			$isComplete = true;
		} else {
			$step['current'] = isset($step['current']) ? intval($step['current'] + 1) : 1;
			$step['percent'] = intval($step['current'] / $conditions['num'] * 100) . '%';
			$step['percent'] == '100%' && $isComplete = true;
		}
		$step['end_num'] = isset($step['end_num']) ? intval($step['end_num']) : 0;
		return array('isComplete' => $isComplete, 'step' => $step);
	}
}
?>