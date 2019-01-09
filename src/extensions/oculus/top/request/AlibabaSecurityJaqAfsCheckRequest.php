<?php
defined('WEKIT_VERSION') or exit(403);
/**
 * TOP API: alibaba.security.jaq.afs.check request
 * 
 * @author auto create
 * @since 1.0, 2017.01.18
 */
class AlibabaSecurityJaqAfsCheckRequest
{
	/** 
	 * 用户接入的时候获取的风控key
	 **/
	private $afsKey;
	
	/** 
	 * 上报平台枚举值 1标识Android端 2标识iOS端 3标识PC端及其他
	 **/
	private $platform;
	
	/** 
	 * 会话ID，来自客户端上报
	 **/
	private $sessionId;
	
	/** 
	 * 签名串，来自客户端上报
	 **/
	private $sig;
	
	/** 
	 * token，来自客户端上报
	 **/
	private $token;
	
	private $apiParas = array();
	
	public function setAfsKey($afsKey)
	{
		$this->afsKey = $afsKey;
		$this->apiParas["afs_key"] = $afsKey;
	}

	public function getAfsKey()
	{
		return $this->afsKey;
	}

	public function setPlatform($platform)
	{
		$this->platform = $platform;
		$this->apiParas["platform"] = $platform;
	}

	public function getPlatform()
	{
		return $this->platform;
	}

	public function setSessionId($sessionId)
	{
		$this->sessionId = $sessionId;
		$this->apiParas["session_id"] = $sessionId;
	}

	public function getSessionId()
	{
		return $this->sessionId;
	}

	public function setSig($sig)
	{
		$this->sig = $sig;
		$this->apiParas["sig"] = $sig;
	}

	public function getSig()
	{
		return $this->sig;
	}

	public function setToken($token)
	{
		$this->token = $token;
		$this->apiParas["token"] = $token;
	}

	public function getToken()
	{
		return $this->token;
	}

	public function getApiMethodName()
	{
		return "alibaba.security.jaq.afs.check";
	}
	
	public function getApiParas()
	{
		return $this->apiParas;
	}
	
	public function check()
	{
        Wind::import('EXT:oculus.top.RequestCheckUtil');
		RequestCheckUtil::checkNotNull($this->platform,"platform");
		RequestCheckUtil::checkNotNull($this->sessionId,"sessionId");
		RequestCheckUtil::checkNotNull($this->sig,"sig");
		RequestCheckUtil::checkNotNull($this->token,"token");
	}
	
	public function putOtherTextParam($key, $value) {
		$this->apiParas[$key] = $value;
		$this->$key = $value;
	}
}
