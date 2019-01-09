<?php
/**
 * 向趣炫SDK发送数据
 * @package 
 */
Wind::import('SRV:cron.srv.base.AbstractCronBase');

class PwCronDoPostSDK extends AbstractCronBase{
	
	public function run($cronId) {
		$offset = 0;
		$num = 1000;
		$count = 1000;

		while ($count == 1000) {
			$noticeObj = Wekit::load('message.PwMessageNotices');
			$unreadList = $noticeObj->getAllUnreadNoticeCount($offset, $num);
			$count = count($unreadList);
			if($count == 0){
				break;
			}
			$offset++;

			$config = Wekit::C('site');
			$post_data = array();
			$post_data['time'] = time();
			$post_data['data'] = $unreadList;
			$post_data['ticket'] = md5(json_encode($post_data['data']).$post_data['time'].$config['securityKey']);

			if($_SERVER['SERVER_NAME'] == 'bbs.test.q-dazzle.com'){
				$post_url = 'http://sdk.t.q-dazzle.com/api/floatwin_bbs_notice.php';
			} else{
				$post_url = 'http://sdk.user.q-dazzle.com/api/floatwin_bbs_notice.php';
			}
			
			$curl = curl_init($post_url);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($curl, CURLOPT_POST, 1);
			curl_setopt($curl, CURLOPT_POSTFIELDS, array('data'=>urlencode(json_encode($post_data))));
			curl_setopt($curl, CURLOPT_TIMEOUT, 10);
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
			curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
			$file_contents = curl_exec($curl);
			curl_close($curl);
		}
	}
}
?>