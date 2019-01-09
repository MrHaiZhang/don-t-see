<?php

/**
 * 手机端首页
 * form src\applications\bbs\controller\IndexController.php
 * 2017.09.28
 */
class IndexController extends PwBaseController {

	public $todayposts = 0;
	public $article = 0;
	
	public function run() {
		//计划任务
		$url_arr = Wekit::url();
		$runCron_url = $url_arr->base.'/index.php?m=cron';

		$unRun = $this->getInput('unRun', 'get');
		if(!$unRun){
			$ch = curl_init();
			$timeout = 1;
			curl_setopt ($ch, CURLOPT_URL, $runCron_url);
			curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
			$file_contents = curl_exec($ch);
			curl_close($ch);
		}
		
		

		$forumDs = Wekit::load('forum.PwForum');
		$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN | PwForum::FETCH_STATISTICS);
		foreach($list as $key => $value){
			//版块关注数
			$list[$key]['isIn'] = Wekit::load('forum.PwForumUser')->countUserByFid($value['fid']);
		}
		
		list($cateList, $forumList) = $this->_filterMap($list);

		//我的关注
		$my_forumList = array();
		Wind::import('APPS:bbs.controller.ForumController');
		$myJoinForum = ForumController::splitStringToArray($this->loginUser->info['join_forum']);
		foreach($myJoinForum as $k=>$v){
			foreach($list as $key => $value){
				if($k == $key && $value['isshow'] == 1){
					$my_forumList[] = $value;
					break;
				}
			}
		}
		
		//帖子总览
		//$bbsinfo = Wekit::load('site.PwBbsinfo')->getInfo(1);
		//$this->setOutput($bbsinfo, 'bbsinfo');
		
		$this->setOutput($cateList, 'cateList');
		$this->setOutput($forumList, 'forumList');
		$this->setOutput($my_forumList, 'my_forumList');
		$this->setOutput($this->todayposts, 'todayposts');
		$this->setOutput($this->article, 'article');
		$this->setTemplate('community_game_list');

		//seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$seoBo->init('bbs', 'forumlist');
		Wekit::setV('seo', $seoBo);
	}
	
	/**
	 * 过滤版块信息
	 * 1、过滤掉不显示的版块
	 * 2、将版块按阶级分离
	 * @param array $list
	 * @return array
	 */
	private function _filterMap($list) {
		$cate = $forum = array();
		foreach ($list as $_key => $_item) {
			if (1 != $_item['isshow']) continue;
			$_item['manager'] = $this->_setManages(array_unique(explode(',', $_item['manager'])));
			if ($_item['parentid'] == 0) {
				$cate[$_key] = $_item;
				isset($forum[$_key]) || $forum[$_key] = array();
				$this->todayposts += $_item['todayposts'];
				$this->article += $_item['article'];
			} else {
				$forum[$_item['parentid']][$_key] = $_item;
			}
		}
		return array($cate, $forum);
	}
	
	/**
	 * 设置版块的版主UID
	 *
	 * @param array $manage
	 * @param array $userList
	 * @return array
	 */
	private function _setManages($manage) {
		$_manage = array();
		foreach ($manage as $_v) {
			if ($_v) $_manage[] = $_v;
		}
		return $_manage;
	}
}