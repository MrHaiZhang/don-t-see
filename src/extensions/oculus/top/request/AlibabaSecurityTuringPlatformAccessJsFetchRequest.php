<?php
defined('WEKIT_VERSION') or exit(403);
/**
 * TOP API: alibaba.security.turing.platform.access.js.fetch request
 * 
 * @author auto create
 * @since 1.0, 2017.01.16
 */
class AlibabaSecurityTuringPlatformAccessJsFetchRequest
{
	private $platformJsParam;
	
	private $apiParas = array();
	
	public function setPlatformJsParam($platformJsParam)
	{
		$this->platformJsParam = $platformJsParam;
		$this->apiParas["platform_js_param"] = $platformJsParam;
	}

	public function getPlatformJsParam()
	{
		return $this->platformJsParam;
	}

	public function getApiMethodName()
	{
		return "alibaba.security.turing.platform.access.js.fetch";
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
