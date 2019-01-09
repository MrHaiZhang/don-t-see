<?php
defined('WEKIT_VERSION') or exit(403);
/**
 * TOP API: alibaba.security.turing.platform.access.add.platform.user request
 * 
 * @author auto create
 * @since 1.0, 2017.01.16
 */
class AlibabaSecurityTuringPlatformAccessAddPlatformUserRequest
{
	private $platformUserInfo;
	
	private $apiParas = array();
	
	public function setPlatformUserInfo($platformUserInfo)
	{
		$this->platformUserInfo = $platformUserInfo;
		$this->apiParas["platform_user_info"] = $platformUserInfo;
	}

	public function getPlatformUserInfo()
	{
		return $this->platformUserInfo;
	}

	public function getApiMethodName()
	{
		return "alibaba.security.turing.platform.access.add.platform.user";
	}
	
	public function getApiParas()
	{
		return $this->apiParas;
	}
	
	public function check()
	{
		
	}
	
	public function putOtherTextParam($key, $value) {
		$this->apiParas[$key] = $value;
		$this->$key = $value;
	}
}
