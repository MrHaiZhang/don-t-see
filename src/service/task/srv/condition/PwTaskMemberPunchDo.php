<?php
Wind::import('SRV:task.srv.PwTaskComplete');
Wind::import('SRV:task.srv.base.PwTaskCompleteInterface');
/**
 * 用户打卡签到任务
 *
 * @author Shi Long <long.shi@alibaba-inc.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.windframework.com
 * @version $Id: PwTaskMemberPunchDo.php 18618 2012-09-24 09:31:00Z jieyin $
 * @package service.task.srv.condition
 */
class PwTaskMemberPunchDo implements PwTaskCompleteInterface {
	
	protected $redis_obj = null;

	/**
	 * @param PwUserInfoDm $dm
	 */
	public function doPunch($dm) {
		if (!Wekit::C('site', 'task.isOpen')) return true;
		$punchData = @unserialize($dm->getField('punch'));
		if (!$punchData || !is_array($punchData)) return false;
		/* @var $bo PwUserBo */
		$bo = Wekit::getLoginUser();
		//帮别人打卡不算完成任务
		if ($dm->uid != $bo->uid) return false;

		//判断是否签到七天
		$this->getRedis();
		$user_punch = $this->redis_obj->getUserPunch();		//签到数记录
		if($user_punch[$bo->uid] != 7){
			return false;
		}

		$bp = new PwTaskComplete($bo->uid, $this);
		$bp->doTask('member', 'punch');
	}
	
	/* (non-PHPdoc)
	 * @see PwTaskCompleteInterface::doTask()
	 */
	public function doTask($conditions, $step) {
		$step['percent'] = '100%';
		return array('isComplete' => true, 'step' => $step);
	}

	//返回redis对象
	private function getRedis(){
		if($this->redis_obj == null){
			$config = 'APPS:wap.conf.RedisConf.php';
			$config = include Wind::getRealPath($config, true);
			Wind::import('APPS:wap.library.MyRedis');
			$this->redis_obj = new MyRedis($g_c);
		}
		return $this->redis_obj;
	}
	
}

?>