<?php
Wind::import('SRV:user.srv.bantype.PwUserBanTypeInterface');
Wind::import('SRV:user.dm.PwUserInfoDm');

/**
 * 用户禁止-登陆
 * form src\service\user\srv\bantype\PwUserBanTypeInterface.php
 * 2018.12.07
 */
class PwUserBanLogin implements PwUserBanTypeInterface {
	
	/**
	 * 在用户禁止之后操作
	 * 
	 * @param PwUserBanInfoDm $dm 禁止信息
	 * @return mixed
	 */
	public function afterBan(PwUserBanInfoDm $dm);
	
	/**
	 * 删除禁止记录的时候更新用户相关状态
	 *
	 * @param int $uid
	 * @return mixed
	 */
	public function deleteBan($uid);
	
	/**
	 * 获得禁止的范围
	 *
	 * @param int $fid
	 * @return string
	 */
	public function getExtension($fid);
}