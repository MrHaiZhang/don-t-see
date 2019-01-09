<?php
defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('SRV:forum.srv.threadList.PwThreadDataSource');

/**
 * 帖子列表数据接口 / 普通列表
 *
 * @author Jianmin Chen <sky_hold@163.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.phpwind.com
 * @version $Id: PwCommonThread.php 16394 2012-08-23 06:28:06Z long.shi $
 * @package forum
 *
 * 2017.10.14 增加查询热门帖子列表
 */

class PwCommonThread extends PwThreadDataSource {
	
	protected $forum;
	protected $specialSortTids;
	protected $count;
	protected $notice_count = 0;

	public function __construct($forum, $orderby = '') {
		$this->forum = $forum;
		$this->specialSortTids = array_keys($this->_getSpecialSortDs()->getSpecialSortByFid($forum->fid));
		$this->count = count($this->specialSortTids);
		/*更改帖子总数*/
		//去除公告帖子
		$notice_list = $this->getNoticeData();
		$notice_list = array_keys($notice_list);
		foreach ($this->specialSortTids as $key => $value) {
			if(in_array($value, $notice_list)){
				unset($this->specialSortTids[$key]);
				$this->notice_count++;
			}
		}

		if($orderby == 'hotpost'){
			$hot_count = $this->_getThreadDs()->getThreadByFidHotCount($this->forum->fid);
			$this->forum->foruminfo['threads'] = $hot_count;
		}
	}

	public function getTotal() {
		return $this->forum->foruminfo['threads'] + $this->count - $this->notice_count;
	}

	//增加第三个参数查热门帖子
	public function getData($limit, $offset, $hotpost = false) {
		$this->count -= $this->notice_count;
		$threaddb = array();
		if ($offset < $this->count) {
			$array = $this->_getThreadDs()->fetchThreadByTid($this->specialSortTids, $limit, $offset);
			foreach ($array as $key => $value) {
				$value['issort'] = true;
				$threaddb[] = $value;
			}
			$limit -= count($threaddb);
		}
		$offset -= min($this->count, $offset);
		if ($limit > 0) {
			//查询
			if($hotpost){
				$array = $this->_getThreadDs()->getThreadByFidHot($this->forum->fid, $limit, $offset, 3);
			} else{
				$array = $this->_getThreadDs()->getThreadByFid($this->forum->fid, $limit, $offset, 3);
			}
			
			foreach ($array as $key => $value) {
				$threaddb[] = $value;
			}
		}
		return $threaddb;
	}

	//获取公告贴子
	public function getNoticeData() {
		$notice_list = $this->_getThreadDs()->getThreadByFidNotice($this->forum->fid);
		return $notice_list;
	}

	protected function _getThreadDs() {
		return Wekit::load('forum.PwThread');
	}

	protected function _getSpecialSortDs() {
		return Wekit::load('forum.PwSpecialSort');
	}
}