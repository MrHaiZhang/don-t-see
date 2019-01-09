<?php
/**
 * the last known user to change this file in the repository  <$LastChangedBy$>
 * @author $Author$ Foxsee@aliyun.com
 * @copyright ?2003-2103 phpwind.com
 * @license http://www.phpwind.com
 * @version $Id$ 
 * @package 
 */
Wind::import('SRV:cron.srv.base.AbstractCronBase');

class PwCronDoRedis extends AbstractCronBase{
	protected $redis_obj = null;
	
	public function run($cronId) {
		$this->getRedis();
		$forumDs = Wekit::load('forum.PwForum');
		$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN);
		foreach ($list as $key => $value) {
			$this->redis_obj->delUserForumDigest($value['fid']);
			$this->redis_obj->delUserForumLike($value['fid']);
		}
		$this->redis_obj->delUserPunch();
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