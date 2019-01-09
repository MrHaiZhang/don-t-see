<?php
defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('SRV:user.dm.PwUserInfoDm');

/**
 * 请求官网接口
 *
 * @author haizhang
 */
class HomeRequest {

	/**
	 * 向官网同步积分
	 * @param String $post_data 		//用户数据
	 * @return [array] []
	 */
	public function synHomeCredit($post_data){
		$post_data['sign'] = $this->api_check_user_sign($post_data);

		$config = Wekit::C()->getValues('site');
		$post_url = $config['info.appweb'].'/index.php?c=bbsapi&a=api_syn_credit';
		$return_data = $this->sample_curl($post_url, $post_data);
		return $return_data;
	}

	/**
	 * 获取官网用户积分
	 * @param String $post_data 		//用户数据
	 */
	public function getHomeCredit($post_data){
		$post_data['sign'] = $this->api_check_user_sign($post_data);

		$config = Wekit::C()->getValues('site');
		$post_url = $config['info.appweb'].'/index.php?c=bbsapi&a=api_get_credit';
		$return_data = $this->sample_curl($post_url, $post_data);
		return $return_data;
	}

	/**
	 * 向官网同步已完成任务
	 * @param String $post_data 		//用户数据
	 * @return [array] []
	 */
	public function synHomeTask($post_data){
		$post_data['sign'] = $this->api_check_user_sign($post_data);

		$config = Wekit::C()->getValues('site');
		$post_url = $config['info.appweb'].'/index.php?c=bbsapi&a=api_syn_task';
		$return_data = $this->sample_curl($post_url, $post_data);
		return $return_data;
	}

	private function sample_curl($post_url, $post_data, $timeout = 30){
		$curl = curl_init($post_url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($post_data));
		curl_setopt($curl, CURLOPT_TIMEOUT, $timeout);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
		$content = curl_exec($curl);
		curl_close($curl);
		$return_data = json_decode($content, true);
		return $return_data;
	}

	/**
	* api签名
	* @param $data array 数据
	*/
	private function api_check_user_sign($data){
		$config = Wekit::C('site');
		ksort($data);
		$sign_str = '';
		foreach ($data as $key => $value) {
			$sign_str .= "{$key}={$value}&";
		}
		$sign_str = rtrim($sign_str, '&');

		return md5($sign_str.$config['securityKey']);
	}

	/**
	 * 返回官网对应的任务标识
	 * @param  [string] $child  [论坛任务标识]
	 * @return [string] [description]
	 */
	public function getHomeTaskName($child){
		$task_list = array(
			'avatar' => 'bbs_header',
			'postThread' => 'bbs_day_thread',
			'reply' => 'bbs_day_post',
			'profile' => 'bbs_nickname',
		);

		return $task_list[$child];
	}
}
