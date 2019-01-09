<?php
defined('WEKIT_VERSION') || exit('Forbidden');

/**
 * Enter description here ...
 *
 * @author jinlong.panjl <jinlong.panjl@aliyun-inc.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.phpwind.com
 * @version $Id$
 * @package wind
 */
Wind::import('ADMIN:library.AdminBaseController');
Wind::import('SRV:forum.srv.operation.PwDeleteTopic');
Wind::import('SRV:forum.srv.operation.PwDeleteReply');
Wind::import('SRV:forum.srv.dataSource.PwFetchTopicByTid');
Wind::import('SRV:forum.srv.dataSource.PwFetchReplyByPid');

class ArticleController extends AdminBaseController {
	
	private $perpage = 20;

	public function run() {
		$fid = '';
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setTemplate('article_searchthread');
	}

	// 导出帖子数据
	public function exportthreadAction() {
		$thread_data = $this->searchthreadAction('export');
		$thread_id_list = array_keys($thread_data);
		$thread_data = $this->_getThreadDs()->fetchThread($thread_id_list, 3);
		$thread_data = $this->getNickName($thread_data);
		$thread_data = array_values($thread_data);

		Wind::import('APPS:wap.library.Classes.PHPExcel');
		$objPHPExcel = new PHPExcel();
		//设置当前的sheet
		$objPHPExcel->setActiveSheetIndex(0);
		//获取操作对象
		$objAction = $objPHPExcel->getActiveSheet();

		$objAction->setCellValue('A1', '帖子id');
		$objAction->setCellValue('B1', '标题');
		$objAction->setCellValue('C1', '作者');
		$objAction->setCellValue('D1', '作者昵称');
		$objAction->setCellValue('E1', '内容');
		$objAction->setCellValue('F1', '发帖时间');
		$objAction->setCellValue('G1', '回复');
		$objAction->setCellValue('H1', '点赞');
		$objAction->setCellValue('I1', '查看');
		$objAction->setCellValue('J1', '敏感词1');
		$objAction->setCellValue('K1', '敏感词2');
		$objAction->setCellValue('L1', '是否有图');
		
		foreach ($thread_data as $key=>$value) {
			$reply_data = $this->workReply($value['content']);

			$has_pic = 0;
			//判断是否有图
			if(preg_match('/<img.+?src="(.+?)"/s', $reply_data['content'])){
				$has_pic = 1;
			}

			//导出excel处理
			if(strpos($reply_data['content'], '=') === 0){
				$reply_data['content'] = '\''.$reply_data['content'];
			}

			$objAction->setCellValue('A'.($key+2), $value['tid']);
			$objAction->setCellValue('B'.($key+2), htmlspecialchars_decode($value['subject']));
			$objAction->setCellValue('C'.($key+2), $value['created_username']);
			$objAction->setCellValue('D'.($key+2), $value['nickname']);
			$objAction->setCellValue('E'.($key+2), $reply_data['content']);
			$objAction->setCellValue('F'.($key+2), Pw::time2str($value['created_time'], 'Y-m-d H:i:s'));
			$objAction->setCellValue('G'.($key+2), $value['replies']);
			$objAction->setCellValue('H'.($key+2), $value['like_count']);
			$objAction->setCellValue('I'.($key+2), $value['hits']);
			$objAction->setCellValue('J'.($key+2), $value['sensitive1']);
			$objAction->setCellValue('K'.($key+2), $value['sensitive2']);
			$objAction->setCellValue('L'.($key+2), $has_pic);

			//设置左对齐
			$objAction->getStyle('A'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('B'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('C'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('J'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
		}
		
		//创建Excel输入对象 
		$write = new PHPExcel_Writer_Excel5($objPHPExcel); 
		$filename = sprintf('%s.xls',date('Y-m-d', time()).'-帖子');
		header('Last-Modified: '.gmdate('D, d M Y H:i:s',Pw::getTime()).' GMT');
		header('Cache-control: no-cache');
		header('Content-Encoding: none');
		header('Content-Disposition: attachment; filename="'.$filename.'"');
		header("Content-Type:application/force-download");  
	    header("Content-Type:application/vnd.ms-execl");  
	    header("Content-Type:application/octet-stream");  
	    header("Content-Type:application/download");
	    header("Content-Transfer-Encoding:binary");
		$write->save('php://output');
		exit;
	}

	// 导出回复数据
	public function exportreplyAction() {
		$reply_data = $this->searchreplyAction('export');
		$reply_data = $this->getNickName($reply_data);
		$reply_list = array_values($reply_data);

		//获取帖子标题
		$thread_id_list = array();
		foreach ($reply_list as $key => $value) {
			$thread_id_list[] = $value['tid'];
		}
		array_unique($thread_id_list);
		$thread_data = $this->_getThreadDs()->fetchThread($thread_id_list, 1);
		$thread_data = array_values($thread_data);

		Wind::import('APPS:wap.library.Classes.PHPExcel');
		$objPHPExcel = new PHPExcel();

		//设置当前的sheet
		$objPHPExcel->setActiveSheetIndex(0);
		//获取操作对象
		$objAction = $objPHPExcel->getActiveSheet();

		$objAction->setCellValue('A1', '帖子id');
		$objAction->setCellValue('B1', '帖子标题');
		$objAction->setCellValue('C1', '回复楼层');
		$objAction->setCellValue('D1', '回复内容');
		$objAction->setCellValue('E1', '回复作者');
		$objAction->setCellValue('F1', '作者昵称');
		$objAction->setCellValue('G1', '回复时间');
		$objAction->setCellValue('H1', '被回复作者');
		$objAction->setCellValue('I1', '被回复内容');
		$objAction->setCellValue('J1', '回复');
		$objAction->setCellValue('K1', '点赞');
		$objAction->setCellValue('L1', '敏感词1');
		$objAction->setCellValue('M1', '敏感词2');
		$objAction->setCellValue('N1', '是否有图');
		//$objAction->setCellValue('L1', '是否删除');

		
		foreach ($reply_list as $key=>$value) {
			//获取当前页的最高楼层
			if($value['rpid'] == 0){
				$lou = $this->_getThreadDs()->getPostByTidGroupLou($value['tid'], $value['pid']);
			} else{
				$lou = '';
			}

			//$value['disabled'] = $value['disabled'] == 0 ? '否' : '是';

			$reply_data = array();
			$objAction->setCellValue('A'.($key+2), $value['tid']);
			foreach ($thread_data as $kk => $vv) {
				if($vv['tid'] == $value['tid']){
					$objAction->setCellValue('B'.($key+2), htmlspecialchars_decode($vv['subject']));
				}
			}
			$reply_data = $this->workReply($value['content']);
			$has_pic = 0;
			//判断是否有图
			if(preg_match('/<img.+?src="(.+?)"/s', $reply_data['content'])){
				$has_pic = 1;
			}

			//导出excel处理
			if(strpos($reply_data['content'], '=') === 0){
				$reply_data['content'] = '\''.$reply_data['content'];
			}

			$objAction->setCellValue('C'.($key+2), $lou);
			$objAction->setCellValue('D'.($key+2), $reply_data['content']);
			$objAction->setCellValue('E'.($key+2), $value['created_username']);
			$objAction->setCellValue('F'.($key+2), $value['nickname']);
			$objAction->setCellValue('G'.($key+2), Pw::time2str($value['created_time'], 'Y-m-d H:i:s'));
			$objAction->setCellValue('H'.($key+2), $reply_data['reply_name']);
			$objAction->setCellValue('I'.($key+2), $reply_data['reply_content']);
			$objAction->setCellValue('J'.($key+2), $value['replies']);
			$objAction->setCellValue('K'.($key+2), $value['like_count']);
			$objAction->setCellValue('L'.($key+2), $value['sensitive1']);
			$objAction->setCellValue('M'.($key+2), $value['sensitive2']);
			$objAction->setCellValue('N'.($key+2), $has_pic);
			//$objAction->setCellValue('L'.($key+2), $value['disabled']);

			//设置左对齐
			$objAction->getStyle('A'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('B'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('D'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			$objAction->getStyle('H'.($key+2))->getAlignment()->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
		}

		
		//创建Excel输入对象 
		$write = new PHPExcel_Writer_Excel5($objPHPExcel); 
		$filename = sprintf('%s.xls',date('Y-m-d', time()).'-回复');
		header('Last-Modified: '.gmdate('D, d M Y H:i:s',Pw::getTime()).' GMT');
		header('Cache-control: no-cache');
		header('Content-Encoding: none');
		header('Content-Disposition: attachment; filename="'.$filename.'"');
		header("Content-Type:application/force-download");  
	    header("Content-Type:application/vnd.ms-execl");  
	    header("Content-Type:application/octet-stream");  
	    header("Content-Type:application/download");
	    header("Content-Transfer-Encoding:binary");
		$write->save('php://output');
		exit;
	}

	public function threadadvancedAction() {
		$fid = '';
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setTemplate('article_searchthread_advanced');
	}
	
	public function searchthreadAction($export = '') {
		list($page, $perpage, $keyword, $created_username, $time_start, $time_end, $fid, $digest, $created_userid, $created_ip, $hits_start, $hits_end, $replies_start, $replies_end, $sensitive, $hasSensitive) = $this->getInput(array('page', 'perpage', 'keyword', 'created_username', 'time_start', 'time_end', 'fid', 'digest', 'created_userid', 'created_ip', 'hits_start', 'hits_end', 'replies_start', 'replies_end', 'sensitive', 'hasSensitive'));
		if ($created_username) {
			$user = $this->_getUserDs()->getUserByName($created_username);
			if (!$user) $this->showError(array('USER:exists.not', array('{username}' => $created_username)));
			if ($created_userid) {
				($created_userid != $user['uid']) && $this->showError('USER:username.notequal.uid');
			}
			$created_userid = $user['uid'];
		}
		// dm条件
		Wind::import('SRV:forum.vo.PwThreadSo');
		$dm = new PwThreadSo();
		$keyword && $dm->setKeywordOfTitleOrContent(htmlspecialchars($keyword));
		if ($fid) {
			$forum = Wekit::load('forum.PwForum')->getForum($fid);
			if ($forum['type'] != 'category') {
				$dm->setFid($fid);
			} else {
				$srv = Wekit::load('forum.srv.PwForumService');
				$fids = array(0);
				$forums = $srv->getForumsByLevel($fid, $srv->getForumMap());
				foreach ($forums as $value) {
					$fids[] = $value['fid'];
				}
				$dm->setFid($fids);
			}
		}
		$created_userid && $dm->setAuthorId($created_userid);
		$time_start && $dm->setCreateTimeStart(Pw::str2time($time_start));
		$time_end && $dm->setCreateTimeEnd(Pw::str2time($time_end));
		$digest && $dm->setDigest($digest);
		$hits_start && $dm->setHitsStart($hits_start);
		$hits_end && $dm->setHitsEnd($hits_end);
		$replies_start && $dm->setRepliesStart($replies_start);
		$replies_end && $dm->setRepliesEnd($replies_end);
		$created_ip && $dm->setCreatedIp($created_ip);
		$dm->setDisabled(0)->orderbyCreatedTime(false);
		if($hasSensitive == 1){
			$sensitive && $dm->setSensitive1($sensitive);
		} else{
			$sensitive && $dm->setSensitive2($sensitive);
		}
		$hasSensitive && $dm->setHasSensitive($hasSensitive);
		$count = $this->_getThreadDs()->countSearchThread($dm);
		if ($count) {
			$page = $page ? $page : 1;
			$perpage = $perpage ? $perpage : $this->perpage;
			list($start, $limit) = Pw::page2limit($page, $perpage);
			$threads = $this->_getThreadDs()->searchThread($dm,$limit,$start);
		}
		if($export == 'export'){
			return $threads;
		}
		$this->setOutput($count, 'count');
		$this->setOutput($page, 'page');
		$this->setOutput($perpage, 'perpage');
		$this->setOutput(array(
			'keyword' => $keyword, 
			'created_username' => $created_username, 
			'time_start' => $time_start, 
			'time_end' => $time_end, 
			'fid' => $fid, 
			'digest' => $digest, 
			'created_userid' => $created_userid, 
			'created_ip' => $created_ip, 
			'hits_start' => $hits_start,
			'hits_end' => $hits_end, 
			'replies_start' => $replies_start, 
			'replies_end' => $replies_end,
			'sensitive' => $sensitive,
		), 'args');

		$this->setOutput($hasSensitive, 'hasSensitive');
		
		$this->setOutput($this->_getFroumService()->getForumList($fid), 'forumList');
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setOutput($threads, 'threads');
	}
	
	public function removeAction() {
		
	}
	
	public function deletethreadAction() {
		$isDeductCredit = $this->getInput('isDeductCredit');
		$tids = $this->getInput('tids', 'post');
		if (!is_array($tids) || !count($tids)) {
			$this->showError('operate.select');
		}
		$service = new PwDeleteTopic(new PwFetchTopicByTid($tids), new PwUserBo($this->loginUser->uid));
		$service->setRecycle(true)->setIsDeductCredit((bool)$isDeductCredit)->execute();
				
		$this->showMessage('operate.success');
	}

	//批量回帖
	public function replythreadAction() {
		$replyContent = $this->getInput('replyContent');
		$tids = $this->getInput('tids', 'post');
		if (!is_array($tids) || !count($tids)) {
			$this->showError('operate.select');
		}
		if(mb_strlen(trim($replyContent),'utf8') < 2){
			$this->showError('至少输入2个字');
		}

		$true_count = 0;
		$false_count = 0;
		Wind::import('SRV:forum.srv.PwPost');
		Wind::import('SRV:forum.srv.post.PwReplyPost');
		$user_obj = new PwUserBo($this->loginUser->uid);
		foreach ($tids as $key => $tid) {
			$postAction = new PwReplyPost($tid, $user_obj, false);		//不检测内容重复
			$pwPost = new PwPost($postAction);
			
			$postDm = $pwPost->getDm();
			$postDm->setContent($replyContent);
			
			if (($result = $pwPost->execute($postDm)) !== true) {
				$false_count++;
			} else{
				$true_count++;
			}
		}
			
		$this->showMessage("成功{$true_count}条，失败{$false_count}条");
	}

	//批量压贴
	//form src/applications/bbs/controller/ManageController.php
	public function docombinedAction() {
		$tids = $this->getInput('tids', 'post');
		if (!is_array($tids) || !count($tids)) {
			$this->showError('operate.select');
		}

		Wind::import('SRV:forum.srv.dataSource.PwFetchTopicByTid');
		Wind::import('SRV:forum.srv.PwThreadManage');
		$user_obj = new PwUserBo($this->loginUser->uid);
		$manage = new PwThreadManage(new PwFetchTopicByTid($tids), $user_obj);
		$do = $this->_getDownManage($manage);
		
		$manage->appendDo($do);
		
		if (($result = $manage->execute()) !== true) {
			$this->showError("操作失败");
		} else{
			$this->showMessage("操作成功");
		}
	}

	protected function _getDownManage($manage) {
		Wind::import('SRV:forum.srv.manage.PwThreadManageDoDown');
		$do = new PwThreadManageDoDown($manage);
		
		$downtime = '-9999999';
		$downed = 1;

		$do->setDowntime($downtime)->setDowned($downed);

		return $do;
	}
	
	public function replylistAction() {
		$fid = '';
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setTemplate('article_searchreply');
	}
	
	public function replyadvancedAction() {
		$fid = '';
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setTemplate('article_searchreply_advanced');
	}
	
	public function searchreplyAction($export = '') {
		list($page, $perpage, $keyword, $fid, $created_username, $created_time_start, $created_time_end, $created_userid, $created_ip, $tid, $sensitive, $hasSensitive, $replyId) = $this->getInput(array('page', 'perpage', 'keyword', 'fid', 'created_username', 'created_time_start', 'created_time_end', 'created_userid', 'created_ip', 'tid', 'sensitive', 'hasSensitive', 'replyId'));
		if ($created_username) {
			$user = $this->_getUserDs()->getUserByName($created_username);
			if (!$user) $this->showError('USER:username.empty');
			if ($created_userid) {
				($created_userid != $user['uid']) && $this->showError('USER:username.notequal.uid');
			}
			$created_userid = $user['uid'];
		}
		// dm条件
		Wind::import('SRV:forum.vo.PwPostSo');
		$dm = new PwPostSo();
		$dm->setDisabled(0)->orderbyCreatedTime(false);
		$keyword && $dm->setKeywordOfTitleOrContent(htmlspecialchars($keyword));
		if ($fid) {
			$forum = Wekit::load('forum.PwForum')->getForum($fid);
			if ($forum['type'] != 'category') {
				$dm->setFid($fid);
			} else {
				$srv = Wekit::load('forum.srv.PwForumService');
				$fids = array(0);
				$forums = $srv->getForumsByLevel($fid, $srv->getForumMap());
				foreach ($forums as $value) {
					$fids[] = $value['fid'];
				}
				$dm->setFid($fids);
			}
		}
		$created_userid && $dm->setAuthorId($created_userid);
		$created_time_start && $dm->setCreateTimeStart(Pw::str2time($created_time_start));
		$created_time_end && $dm->setCreateTimeEnd(Pw::str2time($created_time_end));
		$tid && $dm->setTid($tid);
		$created_ip && $dm->setCreatedIp($created_ip);
		if($hasSensitive == 1){
			$sensitive && $dm->setSensitive1($sensitive);
		} else{
			$sensitive && $dm->setSensitive2($sensitive);
		}
		$hasSensitive && $dm->setHasSensitive($hasSensitive);
		isset($replyId) && $dm->setReplyId($replyId);
		
		$count = $this->_getThreadDs()->countSearchPost($dm);
		if ($count) {
			$page = $page ? $page : 1;
			$perpage = $perpage ? $perpage : $this->perpage;
			list($start, $limit) = Pw::page2limit($page, $perpage);
			$posts = $this->_getThreadDs()->searchPost($dm,$limit,$start);
		}
		if($export == 'export'){
			return $posts;
		}

		$this->setOutput($count, 'count');
		$this->setOutput($page, 'page');
		$this->setOutput($perpage, 'perpage');
		$this->setOutput(array(
			'keyword' => $keyword, 
			'created_username' => $created_username, 
			'created_time_start' => $created_time_start, 
			'created_time_end' => $created_time_end, 
			'fid' => $fid, 
			'created_userid' => $created_userid, 
			'created_ip' => $created_ip, 
			'tid' => $tid,
			'sensitive' => $sensitive,
			'replyId' => $replyId,
			'perpage'=> $perpage
		), 'args');

		$this->setOutput($hasSensitive, 'hasSensitive');
		
		$this->setOutput($this->_getFroumService()->getForumList($fid), 'forumList');
		$this->setOutput($this->_getFroumService()->getForumOption($fid), 'option_html');
		$this->setOutput($posts, 'posts');
	}
	
	/**
	 * Enter description here ...
	 *
	 */
	public function deletereplyAction() {
		$isDeductCredit = $this->getInput('isDeductCredit');
		$pids = $this->getInput('pids', 'post');
		if (!is_array($pids) || !count($pids)) {
			$this->showError('operate.select');
		}
		$service = new PwDeleteReply(new PwFetchReplyByPid($pids), new PwUserBo($this->loginUser->uid));
		$service->setRecycle(true)->setIsDeductCredit((bool)$isDeductCredit)->execute();
		$this->showMessage('operate.success');
	}

	/**
	 * 对其他用户隐藏评论
	 *
	 */
	public function hidereplyAction() {
		$pids = $this->getInput('pids', 'post');
		if (!is_array($pids) || !count($pids)) {
			$this->showError('operate.select');
		}

		Wind::import('SRV:forum.srv.dataSource.PwFetchReplyByPid');
		Wind::import('SRV:forum.srv.PwThreadManage');
		$user_obj = new PwUserBo($this->loginUser->uid);
		$manage = new PwThreadManage(new PwFetchReplyByPid($pids), $user_obj);
		$do = $this->_gethideManage($manage);
		
		$manage->appendDo($do);


		if (($result = $manage->check()) !== true) {
			$this->showError($result->getError());
			$this->showMessage("操作失败");
		} else{
			$manage->execute();
			$this->showMessage('操作成功');
		}
	}

	protected function _gethideManage($manage) {
		Wind::import('SRV:forum.srv.manage.PwThreadManageDoHideReply');
		$do = new PwThreadManageDoHideReply($manage);

		$hide_other = 1;

		$do->setHideOther($hide_other);

		return $do;
	}

	/**
	 * Enter description here ...
	 *
	 * @return PwThread
	 */
	private function _getThreadDs(){
		return Wekit::load('forum.PwThread');
	}
	
	private function _getUserDs(){
		return Wekit::load('user.PwUser');
	}
	
	protected function _getFroumService() {
		return Wekit::load('forum.srv.PwForumService');
	}

	//加工评论数据
	public function workReply($content){
		$reply_name = '';
		$reply_content = '';

		if(strpos($content, '[/quote]') !== false){
			$content_arr = explode('[/quote]', $content);
			$content = $content_arr[1];

			//回复的回复
			$re_data = explode(',', $content_arr[0]);
			$re_data = explode(']', $re_data[1]);
			$replyid = $re_data[0];
			$reply_post = Wekit::load('thread.PwThread')->getPost($replyid);

			$reply_name = $reply_post['created_username'];
			$reply_data = $this->workReply($reply_post['content']);
			$reply_content = $reply_data['content'];
		}

		//加工二次回复的回复
		if(strpos($content, '[/quote2]') !== false){
			$content_arr = explode('[/quote2]', $content);
			$content = $content_arr[1];

			//被回复的回复
			$re_data = explode('[quote2]', $content_arr[0]);
			$replyid = $re_data[1];
			$reply_post = Wekit::load('thread.PwThread')->getPost($replyid);

			$reply_name = $reply_post['created_username'];
			$reply_data = $this->workReply($reply_post['content']);
			$reply_content = $reply_data['content'];
		}

		$return_arr = array(
			'content'=>htmlspecialchars_decode($content),
			'reply_name'=>$reply_name,
			'reply_content'=>$reply_content,
			);

        return $return_arr;
    }

    //批量获取昵称
    public function getNickName($data_list){
    	$uid_list = array();
    	foreach ($data_list as $key => $value) {
    		$uid_list[] = $value['created_userid'];
    	}
    	$uid_list = array_values(array_flip(array_flip($uid_list)));

    	$created_info = Wekit::load('user.PwUser')->fetchUserByUid($uid_list, PwUser::FETCH_INFO);
    	foreach ($data_list as $key => $value) {
    		foreach ($created_info as $kk => $vv) {
    			if($value['created_userid'] == $kk){
    				$data_list[$key]['nickname'] = $vv['nickname'];
    			}
    		}
    	}
    	
    	return $data_list;
    }
}
?>