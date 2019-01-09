<?php
defined('WEKIT_VERSION') or exit(403);
/**
 * 后台菜单添加
 *
 * @author  <>
 * @copyright 
 * @license 
 */
class App_Oculus_ConfigDo {
	
	/**
	 * 获取阿里巴巴滑动验证码后台菜单,在应用菜单中
	 *
	 * @param array $config
	 * @return array 
	 */
	public function getAdminMenu($config) {
		$config += array(
			'ext_oculus' => array('阿里巴巴滑动验证码', 'app/manage/*?app=oculus', '', '', 'appcenter'),
			);
		return $config;
	}
}

?>