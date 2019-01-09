<?php
defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('ADMIN:library.AdminBaseController');

Wind::import('SRV:forum.srv.PwPost');

/**
 * 手机端帖子操作
 * form src\applications\bbs\controller\PostController.php
 * 2017.09.28
 */
class ForumNewController extends AdminBaseController {

	public $post;
	
	public function run() {
		$forumDs = Wekit::load('forum.PwForum');
		$list = $forumDs->getCommonForumList(PwForum::FETCH_MAIN | PwForum::FETCH_STATISTICS);
		
		//csrf验证
		$this->setOutput($_COOKIE['csrf_token'], 'csrf_token');
		$this->setOutput($list, 'list');
		$this->setTemplate('community_new_thread');
	}

	/**
	 * 发帖
	 */
	public function doaddAction() {
		list($title, $content, $reply_notice, $hide) = $this->getInput(array('atc_title', 'atc_content', 'reply_notice', 'hide'), 'post');
		$fid = $this->getInput('fid');
		list($type, $activity_time_start, $activity_time_end, $activity_prefix, $activity_type, $activity_content_screen, $activity_return_num, $activity_url) = $this->getInput(array('type', 'activity_time_start', 'activity_time_end', 'activity_prefix', 'activity_type', 'activity_content_screen', 'activity_return_num', 'activity_url'), 'post');

		Wind::import('SRV:forum.srv.post.PwTopicPost');
		Wind::import('SRV:forum.bo.PwUserBo');
		$user_obj = new PwUserBo($this->loginUser->uid);
		$postAction = new PwTopicPost($fid, $user_obj);
		$pwPost = new PwPost($postAction);
		//$this->runHook('c_post_doadd', $pwPost);

		if($type == 1){
			$activity_param = array(
				'activity_time_start'=>$activity_time_start,
				'activity_time_end'=>$activity_time_end,
				'activity_prefix'=>$activity_prefix,
				'activity_type'=>$activity_type,
				'activity_content_screen'=>$activity_content_screen,
				'activity_return_num'=>$activity_return_num,
				'activity_url'=>$activity_url,
				);
			$activity_param = json_encode($activity_param);
		} else{
			$activity_param = '';
		}

		$postDm = $pwPost->getDm();
		$postDm->setTitle($title)
			->setContent($content)
			->setHide($hide)
			->setOfficial(1)
			->setType($type)
			->setActivityParam($activity_param)
			->setReplyNotice(1);

		if($type == 1 && $activity_type != 2){
			$extend = json_encode(array(
				'type' => 4,
			));
			$postDm->setExtend($extend);
		}

		//set topic type
		$topictype_id = $subtopictype ? $subtopictype : $topictype;
		$topictype_id && $postDm->setTopictype($topictype_id);

		if (($result = $pwPost->execute($postDm)) !== true) {
			$res_err = $result->getError();
			//敏感词屏蔽
			if($res_err[0] == 'WORD:title.tag.error' || $res_err[0] == 'WORD:content.error' || $res_err[0] == 'WORD:content.error.tip'){
				$res_data = $result->getData();
				//审核敏感词
				if($res_data['isVerified'] == 1){
					//忽略审核敏感词重新发帖
					$return_arr = array(
						'state'=>'raload',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				} else{
					$return_arr = array(
						'state'=>'word',
						'msg'=>$res_err[1]['{wordstr}'],
						);
					echo json_encode($return_arr);
					exit;
				}
			} else if($res_err[0] == 'BBS:post.content.length.more'){
				$return_arr = array(
					'state'=>'sword',
					'msg'=>'内容最多只能'.$res_err[1]['{max}'].'个字',
					);
				echo json_encode($return_arr);
				exit;
			} else if($res_err == 'BBS:post.content.duplicate'){
				$return_arr = array(
					'state'=>'repeat',
					'msg'=>'请勿发表重复内容',
					);
				echo json_encode($return_arr);
				exit;
			} else{
				$data = $result->getData();
				$data && $this->addMessage($data, 'data');
				$this->showError($result->getError());
			}
		}
		$tid = $pwPost->getNewId();

		$return_arr = array(
			'state'=>'success',
			'url'=>'m=wap&c=ForumNew&tid='.$tid,
			);
		echo json_encode($return_arr);
		exit;
	}
}	