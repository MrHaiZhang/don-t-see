<?php

/**
 * 帖子基础dao服务
 *
 * @author Jianmin Chen <sky_hold@163.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.phpwind.com
 * @version $Id: PwPostsDao.php 24251 2013-01-23 09:07:13Z jinlong.panjl $
 * @package forum
 *
 * 2017.10.24 增加查询分级回复列表
 * 增加是否有敏感词的查询
 * 2017.12.19 增加某一级回复的楼层数
 */

class PwPostsDao extends PwBaseDao {
	
	protected $_table = 'bbs_posts';
	protected $_pk = 'pid';
	protected $_dataStruct = array('pid', 'fid', 'tid', 'disabled', 'ischeck', 'ifshield', 'replies', 'useubb', 'aids', 'rpid', 'subject', 'content', 'like_count', 'sell_count', 'created_time', 'created_username', 'created_userid', 'created_ip', 'reply_notice', 'modified_time', 'modified_username', 'modified_userid', 'modified_ip', 'reminds', 'word_version', 'ipfrom', 'manage_remind', 'topped', 'app_mark', 'sensitive1','sensitive2', 'hide_other');
	
	public function getPost($pid) {
		return $this->_get($pid);
	}

	public function fetchPost($pids) {
		return $this->_fetch($pids, 'pid');
	}

	public function getPostByTid($tid, $limit, $offset, $asc) {
		$orderby = $asc ? 'ASC' : 'DESC';
		$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND disabled=0 ORDER BY created_time %s %s', $this->getTable(), $orderby , $this->sqlLimit($limit, $offset));
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->queryAll(array($tid), 'pid');
	}

	//分级查回复(个数、偏移量、升序排列、上级回复id、热门排序、回复id)
	public function getPostByTidGroup($tid, $limit, $offset, $asc, $rpid = 0, $hot = flase, $pid = 0) {
		$orderby = $asc ? 'ASC' : 'DESC';
		if($pid > 0){		//查单条
			$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND disabled=0 AND pid='.$pid, $this->getTable());
			$smt = $this->getConnection()->createStatement($sql);
			$post_data = $smt->queryAll(array($tid), 'pid');

			//总的数据
			$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND rpid='.$rpid.' ORDER BY created_time ASC', $this->getTable());

			$smt = $this->getConnection()->createStatement($sql);
			$readdb_list = $smt->queryAll(array($tid));

			//获取楼层
			foreach($post_data as $key=>$value){
				$post_data[$key]['lou'] = array_search($value, $readdb_list)+1;
			}
			return $post_data;

			return $smt->queryAll(array($tid), 'pid');
		} else if($hot){		//没有自增id，热门回复需要查楼层。。。
			$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND disabled=0 AND replies>0 AND rpid='.$rpid.' ORDER BY replies %s %s', $this->getTable(), $orderby , $this->sqlLimit($limit, $offset));

			$smt = $this->getConnection()->createStatement($sql);
			$hot_list = $smt->queryAll(array($tid), 'pid');

			//总的数据
			$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND rpid='.$rpid.' ORDER BY created_time ASC', $this->getTable());

			$smt = $this->getConnection()->createStatement($sql);
			$readdb_list = $smt->queryAll(array($tid));

			//循环获取楼层
			foreach($hot_list as $key=>$value){
				$hot_list[$key]['lou'] = array_search($value, $readdb_list)+1;
			}
			return $hot_list;
		} else{
			$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND disabled=0 AND rpid='.$rpid.' ORDER BY created_time %s %s', $this->getTable(), $orderby , $this->sqlLimit($limit, $offset));

			$smt = $this->getConnection()->createStatement($sql);
			return $smt->queryAll(array($tid), 'pid');
		}
	}

	//一级回复总数
	public function getPostByTidGroupCount($tid) {
		$sql = $this->_bindTable('SELECT COUNT(*) as count FROM %s WHERE tid=? AND rpid=0');
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($tid));
	}

	//某一级回复的楼层数
	public function getPostByTidGroupLou($tid, $pid){
		$sql = $this->_bindTable('SELECT COUNT(*) as count FROM %s WHERE tid=? AND pid<=? AND rpid=0');
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($tid, $pid));
	}

	public function countPostByUidAndList($uid, $start_time = false, $end_time = false, $disabled = false, $reply = false) {
		$sql = 'SELECT COUNT(*) FROM %s WHERE created_userid=?';
		$disabled !== false && $sql .= ' AND disabled='.$disabled;
		$reply !== false && $sql .= ' AND rpid='.$reply;
		if($start_time && $end_time){
			$sql .= ' AND created_time<'.$end_time.' AND created_time>'.$start_time;
		}
		$sql = $this->_bindTable($sql);
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($uid));
	}

	public function countPostByUid($uid) {
		$sql = 'SELECT COUNT(*) FROM %s WHERE created_userid=? AND disabled=0';
		$sql = $this->_bindTable($sql);
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($uid));
	}

	public function getPostByUid($uid, $limit, $offset) {
		$sql = $this->_bindSql('SELECT * FROM %s WHERE created_userid=? AND disabled=0 ORDER BY created_time DESC %s', $this->getTable(), $this->sqlLimit($limit, $offset));
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->queryAll(array($uid), 'pid');
	}
	
	public function countPostByTidAndUid($tid, $uid) {
		$sql = $this->_bindTable('SELECT COUNT(*) FROM %s WHERE tid=? AND created_userid=? AND disabled=0');
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($tid, $uid));
	}

	public function countPostByTidUnderPid($tid, $pid) {
		$sql = $this->_bindTable('SELECT COUNT(*) FROM %s WHERE tid=? AND pid<? AND disabled=0');
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue(array($tid, $pid));
	}

	public function getPostByTidAndUid($tid, $uid, $limit, $offset, $asc) {
		$orderby = $asc ? 'ASC' : 'DESC';
		$sql = $this->_bindSql('SELECT * FROM %s WHERE tid=? AND disabled=0 AND created_userid=? ORDER BY created_time %s %s', $this->getTable(), $orderby , $this->sqlLimit($limit, $offset));
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->queryAll(array($tid, $uid), 'pid');
	}

	public function addPost($fields) {
		return $this->_add($fields);
	}

	public function updatePost($pid, $fields, $increaseFields = array()) {
		$this->_update($pid, $fields, $increaseFields);
	}

	public function batchUpdatePost($pids, $fields, $increaseFields = array()) {
		return $this->_batchUpdate($pids, $fields, $increaseFields);
	}

	public function batchUpdatePostByTid($tids, $fields, $increaseFields = array()) {
		$fields = $this->_filterStruct($fields);
		$increaseFields = $this->_filterStruct($increaseFields);
		if (!$fields && !$increaseFields) {
			return false;
		}
		$sql = $this->_bindSql('UPDATE %s SET %s WHERE tid IN %s', $this->getTable(), $this->sqlMerge($fields, $increaseFields), $this->sqlImplode($tids));
		$this->getConnection()->execute($sql);
		return true;
	}

	public function revertPost($tids) {
		$sql = $this->_bindSql('UPDATE %s SET disabled=ischeck^1 WHERE tid IN %s', $this->getTable(), $this->sqlImplode($tids));
		return $this->getConnection()->execute($sql);
	}
	
	public function batchDeletePost($pids) {
		return $this->_batchDelete($pids);
	}

	public function batchDeletePostByTid($tids) {
		$sql = $this->_bindSql('DELETE FROM %s WHERE tid IN %s', $this->getTable(), $this->sqlImplode($tids));
		$this->getConnection()->execute($sql);
		return true;
	}

	/**************** 以下是搜索 *******************\
	\**************** 以下是搜索 *******************/

	public function countSearchPost($field) {
		list($where, $arg) = $this->_buildCondition($field);
		$sql = $this->_bindSql('SELECT COUNT(*) AS sum FROM %s WHERE %s', $this->getTable(), $where);
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->getValue($arg);
	}

	public function searchPost($field, $orderby, $limit, $offset) {
		list($where, $arg) = $this->_buildCondition($field);
		$order = $this->_buildOrderby($orderby);
		$sql = $this->_bindSql('SELECT * FROM %s WHERE %s %s %s', $this->getTable(), $where, $order, $this->sqlLimit($limit, $offset));
		$smt = $this->getConnection()->createStatement($sql);
		return $smt->queryAll($arg, 'pid');
	}

	protected function _buildCondition($field) {
		$where = '1';
		$arg = array();
		foreach ($field as $key => $value) {
			switch ($key) {
				case 'fid':
					$where .= ' AND fid' . $this->_sqlIn($value, $arg);
					break;
				case 'tid':
					$where .= ' AND tid' . $this->_sqlIn($value, $arg);
					break;
				case 'disabled':
					$where .= ' AND disabled=?';
					$arg[] = $value;
					break;
				case 'created_userid':
					$where .= ' AND created_userid' . $this->_sqlIn($value, $arg);
					break;
				case 'sensitive_keyword1':
					$where .= ' AND `sensitive1` LIKE ?';
					$arg[] = "%$value%";
					break;
				case 'sensitive_keyword2':
					$where .= ' AND `sensitive2` LIKE ?';
					$arg[] = "%$value%";
					break;
				case 'hasSensitive':
					$where .= " AND `sensitive{$value}` !=''";
					break;
				case 'rpid':
					$value == -1 && $where .= ' AND `rpid` > 0';
					$value == 0 && $where .= ' AND `rpid` = 0';
					break;
				case 'title_keyword':
					$where .= ' AND subject LIKE ?';
					$arg[] = "%$value%";
					break;
				case 'content_keyword':
					$where .= ' AND content LIKE ?';
					$arg[] = "%$value%";
					break;
				case 'title_and_content_keyword':
					$where .= ' AND (subject LIKE ? OR content LIKE ?)';
					$arg[] = "%$value%";
					$arg[] = "%$value%";
					break;
				case 'created_time_start':
					$where .= ' AND created_time>?';
					$arg[] = $value;
					break;
				case 'created_time_end':
					$where .= ' AND created_time<?';
					$arg[] = $value;
					break;
				case 'created_ip':
					$where .= ' AND a.created_ip LIKE ?';
					$arg[] = "$value%";
					break;
			}
		}
		return array($where, $arg);
	}

	protected function _buildOrderby($orderby) {
		$array = array();
		foreach ($orderby as $key => $value) {
			switch ($key) {
				case 'created_time':
					$array[] = 'created_time ' . ($value ? 'ASC' : 'DESC');
					break;
			}
		}
		return $array ? ' ORDER BY ' . implode(',', $array) : '';
	}

	protected function _sqlIn($value, &$arg) {
		if (is_array($value)) {
			return ' IN ' . $this->sqlImplode($value);
		}
		$arg[] = $value;
		return '=?';
	}
}