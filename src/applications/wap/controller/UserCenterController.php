<?php
Wind::import('APPS:space.controller.SpaceBaseWapController');

/**
 * 手机端个人中心
 * form src\applications\sapace\controller\*.php
 * form src\applications\my\controller\ArticleController.php
 * 2017.09.28
 */
class UserCenterController extends SpaceBaseWapController {
	
	public function run() {
		$fid = intval($this->getInput('fid'));		//版块id
		$this->setOutput($fid, 'fid');
		//获取发帖数，数据库统计的是发帖和评论总数,$this->space是父级对象
		Wind::import('SRV:forum.srv.PwThreadList');
		list($page, $perpage) = $this->getInput(array('page', 'perpage'));
		!$perpage && $perpage = 20;
		$threadList = new PwThreadList();
		$threadList->setPage($page)->setPerpage($perpage);
		$dataSource = null;
		if ($this->space->spaceUid == $this->loginUser->uid) {
			Wind::import('SRV:forum.srv.threadList.PwMyThread');
			$dataSource = new PwMyThread($this->space->spaceUid);
		} else {
			Wind::import('SRV:forum.srv.threadList.PwSpaceThread');
			$dataSource = new PwSpaceThread($this->space->spaceUid);
		}
		$threadList->execute($dataSource);

		//将发帖数和评论数分开
		$this->space->spaceUser['thread_count'] = $threadList->total;
		$this->space->spaceUser['post_count'] = $this->space->spaceUser['postnum'] - $this->space->spaceUser['thread_count'];

		if($this->space->spaceUser['nickname'] != ''){
			$this->space->spaceUser['username'] = $this->space->spaceUser['nickname'];
		}
		
		//未读总数
		$unreadCount = $this->_getNoticeDs()->getTypeUnreadNoticeCount($this->loginUser->uid, 'all');
		$unreadCount == 0 && $unreadCount = '';

		$redis_obj = $this->getRedis();
		//用户进入用户中心记录
		$frist_in = $redis_obj->getUserFristInUserCenterTF($this->loginUser->uid);
		if(!$frist_in){
			$redis_obj->setUserFristInUserCenter($this->loginUser->uid);
		}

		Wind::import('SRV:wap.HomeRequest');
		$home_request = new HomeRequest();
		$return_arr = $home_request->getHomeCredit(array('username'=>$this->loginUser->username));

		$this->setOutput(time(), 'time');
		$this->setOutput($unreadCount, 'unreadCount');
		$this->setOutput($return_arr['data']['credit'], 'plat_credit');
		$this->setOutput($frist_in, 'frist_in');
		$this->setTemplate('community_user_center');

		// seo设置
		Wind::import('SRV:seo.bo.PwSeoBo');
		$seoBo = PwSeoBo::getInstance();
		$lang = Wind::getComponent('i18n');
		$des = Pw::substrs($this->space->space['space_descrip'], 100, 0, false);
		$seoBo->setCustomSeo($lang->getMessage('SEO:space.index.run.title', array($this->space->space['space_name'])), '', $des);

		Wekit::setV('seo', $seoBo);
	}



	protected function _getNoticeDs(){
		return Wekit::load('message.PwMessageNotices');
	}

}	