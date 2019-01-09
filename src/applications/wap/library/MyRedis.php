<?php
defined('WEKIT_VERSION') || exit('Forbidden');
date_default_timezone_set('PRC');

class MyRedis{
	protected static $mcache;
	protected $host='';
	protected $port='';
	protected $password='';
	protected $expire = '300';
	protected $is_alive = 0;
	protected $redis_header = '';

	public function __construct($g_c) {
		$this->host = $g_c['redis_host'];
		$this->port = $g_c['redis_port'];
		$this->password = $g_c['redis_pwd'];
		$this->redis_header = $g_c['redis_header'];
		$this->is_alive = 1;

		if(empty($this->mcache)){
			$this->mcache =  new Redis();
			try{
				$this->mcache->connect($this->host, $this->port,2);
				$this->mcache->auth($this->password);
			} catch ( Exception $e ){
				if(0 == strncasecmp("Can't connect to",$e->getMessage(),strlen("Can't connect to") ) ){
					$subject = 'qdazzle_home server connect redis fail';
					$content = 'qdazzle_home server connect connect redis fail'. date("Y-m-d")."\n".$_SERVER['HTTP_HOST'];
					$this->is_alive = 0;
				}
			}
		}
	}

	public function __destruct(){
		return  $this->mcache->close();
	}

	public function check_redis_is_alive(){
		if($this->is_alive){
			return true;
		} 
		return false;
	}

	public function keys($key){
		return $this->mcache->keys($key);
	}

	public function get($key){
		$value = json_decode($this->mcache->get($key),1);
		if(empty($value))
		{
			return $this->mcache->get($key); 
		}
		return $value;
	}

	public function setex($key,$expire_time,$value){
		return $this->mcache->setex($key,$expire_time,$value);
	}

	//添加集合元素
	public function sAdd($key,$value)
	{
		return $this->mcache->sAdd($key,$value);
	}

	//移除集合元素
	public function sRemove($key,$value)
	{
		return $this->mcache->sRemove($key,$value);
	}

	//返回集合大小
	public function sSize($key)
	{
		return $this->mcache->sSize($key);
	}

	//返回集合key中的所有成员
	public function sMembers($key)
	{
		return $this->mcache->sMembers($key);
	}

	//链表表头插入
	public function lPush($key,$value)
	{
		return $this->mcache->lPush($key,$value);
	}

	//链表表尾插入
	public function rPush($key,$value)
	{
		return $this->mcache->rPush($key,$value);
	}

	//返回链表大小
	public function lSize($key)
	{
		return $this->mcache->lSize($key);
	}

	//返回列表key中指定区间内的元素
	public function lGetRange($key,$start,$end)
	{
		return $this->mcache->lGetRange($key,$start,$end);
	}

	//移除列表key中指定区间内的元素
	public function lRemove($key,$start,$end)
	{
		return $this->mcache->lRemove($key,$start,$end);
	}

	//移除并返回列表KEY的头元素
	public function lPop($key)
	{
		return $this->mcache->lPop($key);
	}

	//移除并返回列表KEY的尾元素
	public function rPop($key)
	{
		return $this->mcache->rPop($key);
	}
	
	//将哈希表key中的域field的值设为value
	public function hSet($key,$field,$value)
	{
		return $this->mcache->hSet($key,$field,$value);
	}

	//将哈希表key中的域field的值设为value
	public function hKeys($key)
	{
		return $this->mcache->hkeys($key);
	}

	//查看key的生存时间
	public function ttl($key)
	{
		return $this->mcache->ttl($key);
	}

	//将哈希表key中的域field的值设为value
	public function hSetnx($key,$field,$value)
	{
		return $this->mcache->hSetnx($key,$field,$value);
	}

	//将哈希表key中的域field的值增加value
	public function hIncrby($key,$field,$value)
	{
		return $this->mcache->hIncrby($key, $field, $value);
	}

	//返回哈希表key中给定域field的值
	public function hGet($key,$field)
	{
		return $this->mcache->hGet($key,$field);
	}

	//返回哈希表key中给定域field的值
	public function hDel($key,$field)
	{
		return $this->mcache->hDel($key,$field);
	}

	//返回哈希表key中域的数量
	public function hLen($key)
	{
		return $this->mcache->hLen($key);
	}

	//查看哈希表key中，给定域field是否存在
	public function hExists($key,$field)
	{
		return $this->mcache->hExists($key,$field);
	}

	//查看哈希表key中，给定域field是否存在
	public function hVals($key)
	{
		return $this->mcache->hVals($key);
	}

	//选择redis数据库
	public function select($index)
	{
		return $this->mcache->select($index);
	}

	//set key-value
	public function set($Key,$value)
	{
		return $this->mcache->set($Key,$value);
	}

	//监视
	public function watch($arr_key = array())
	{
		if(!empty($arr_key)){
			foreach ($arr_key as $value) {
				$this->mcache->watch($value);
			}
			return true;
		}
		return false;
	}

	//执行事务
	public function multi()
	{
		return $this->mcache->multi();
	}

	//提交事务执行
	public function exec()
	{
		return $this->mcache->exec();
	}

	//取消事务
	public function discard(){
		return $this->mcache->discard();
	}

	public function clean_cache_new(){
		//self::deal_statis_role_data("list_statis_role_key","");
		//$this->mcache->flushdb();
		//self::put_statis_role_to_redis("","");
		return true;
	}

	public function info(){
		return $this->mcache->info();
	}

	public function del($key){
		return $this->mcache->del($key);
	}

	/**
	 * [设置日活跃用户]
	 * @param  [Array] $userInfo [用户信息]
	 * @return [type]           [description]
	 */
	public function setUserUpDayCount($userInfo){
		$day_time = strtotime(date('Y-m-d', time()));
		$key = $this->redis_header."user_up_day_count_".$day_time;
		$field = $userInfo['username'];

		if($this->is_alive){
			$return_tf = $this->mcache->hSetnx($key,$field,json_encode($userInfo));

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expire($key,$day_time + 86400*62 - time());
			}

			return $return_tf;
		}
		return false;
	}

	/**
	 * [返回日活跃用户]
	 * @param  [string] $username [用户名]
	 * @return [type]           [description]
	 */
	public function getUserUpDayCount($username){
		$day_time = strtotime(date('Y-m-d', time()));
		$key = $this->redis_header."user_up_day_count_".$day_time;

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $username)){
				$json_str = '';
			} else{
				$json_str = $this->mcache->hGet($key, $username);
			}
		} else{
			$json_str = '';
		}
		return json_decode($json_str, true);
	}

	/**
	 * [设置日增用户]
	 * @param  [Array] $userInfo [用户信息]
	 * @return [type]           [description]
	 */
	public function setUserDayCount($userInfo){
		$day_time = strtotime(date('Y-m-d', time()));
		$key = $this->redis_header."user_day_count_".$day_time;
		$field = $userInfo['username'];

		if($this->is_alive){
			$return_tf = $this->mcache->hSetnx($key,$field,json_encode($userInfo));

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expire($key,$day_time + 86400*62 - time());
			}

			return $return_tf;
		}
		return false;
	}

	/**
	 * [返回日增用户]
	 * @param  [string] $username [用户名]
	 * @return [type]           [description]
	 */
	public function getUserDayCount($username){
		$day_time = strtotime(date('Y-m-d', time()));
		$key = $this->redis_header."user_day_count_".$day_time;

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $username)){
				$json_str = '';
			} else{
				$json_str = $this->mcache->hGet($key, $username);
			}
		} else{
			$json_str = '';
		}
		return json_decode($json_str, true);
	}

	//设置帖子日发布数
	public function setThreadDayCount(){
		$key = $this->redis_header."thread_day_count";
		if($this->is_alive){
			if($this->mcache->exists($key)==0){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;
	}

	//返回帖子日发布数
	public function getThreadDayCount(){
		$key = $this->redis_header."thread_day_count";
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	//设置评论日发布数
	public function setReplyDayCount(){
		$key = $this->redis_header."reply_day_count";
		if($this->is_alive){
			if($this->mcache->exists($key)==0){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;
	}

	//返回评论日发布数
	public function getReplyDayCount(){
		$key = $this->redis_header."reply_day_count";
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	//设置日点赞数
	public function setLikeDayCount(){
		$key = $this->redis_header."like_day_count";
		if($this->is_alive){
			if($this->mcache->exists($key)==0){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;
	}

	//返回日点赞数
	public function getLikeDayCount(){
		$key = $this->redis_header."like_day_count";
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	//设置专区日访问人数
	public function setForumCount($forum_id){
		$key = $this->redis_header."forum_day_count_".$forum_id;
		if($this->is_alive){
			if($this->mcache->exists($key)==0){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;
	}

	//返回专区日访问人数
	public function getForumCount($forum_id){
		$key = $this->redis_header."forum_day_count_".$forum_id;
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	//设置模块日点击量
	public function setModelCount($model_id){
		$key = $this->redis_header."model_day_count_".$model_id;
		if($this->is_alive){
			if($this->mcache->exists($key)==0){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;
	}

	//返回模块日点击量
	public function getModelCount($model_id){
		$key = $this->redis_header."model_day_count_".$model_id;
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	//设置专区信息
	public function setForumData($forumData){
		$key = $this->redis_header."forum_data";
		if($this->is_alive){
			return $this->mcache->set($key,json_encode($forumData));
		}
		return false;
	}

	//返回专区信息
	public function getForumData(){
		$key = $this->redis_header."forum_data";
		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	/**
	 * [setUserForumDigest 设置各版块用户精华帖子数]
	 * @param [int] $forumid  [版块id]
	 * @param [string] $userid [用户id]
	 * @param [int] $num [增加或减少]
	 */
	public function setUserForumDigest($forumid, $userid, $num = 1){
		$key = $this->redis_header."user_forum_digest_".$forumid;

		if($this->is_alive){

			$this->setUserForumDigestTime($forumid, $userid);
			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, $num);
			} else{
				return $this->mcache->hincrby($key, $userid, $num);
			}

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expireAt($key, 86400*7);
			}

			return $return_tf;
		}
		return false;;
	}

	/**
	 * [setUserForumDigestTime 设置各版块用户精华帖子设置时间]
	 * @param [int] $forumid  [版块id]
	 * @param [string] $userid [用户id]
	 */
	public function setUserForumDigestTime($forumid, $userid){
		$key = $this->redis_header."user_forum_digest_time_".$forumid;

		if($this->is_alive){
			return $this->mcache->hSet($key, $userid, time());
		}
		return false;;
	}

	//返回各版块用户精华帖子数
	public function getUserForumDigest($forumid){
		$key = $this->redis_header."user_forum_digest_".$forumid;

		$list = array();
		if($this->is_alive){
			$list = $this->mcache->hGetAll($key);
			return $list;
		}
		return false;
	}

	//返回各版块用户精华帖子设置时间
	public function getUserForumDigestTime($forumid){
		$key = $this->redis_header."user_forum_digest_time_".$forumid;

		$list = array();
		if($this->is_alive){
			$list = $this->mcache->hGetAll($key);
			return $list;
		}
		return false;
	}

	//清空各版块用户精华帖子数
	public function delUserForumDigest($forumid){
		$key = $this->redis_header."user_forum_digest_".$forumid;

		if($this->is_alive){
			if($this->mcache->exists($key)){
				return $this->mcache->expireAt($key, time() - 1);		
			}
		}
		return false;
	}

	/**
	 * [setUserForumLike 设置各版块用户被喜欢数]
	 * @param [int] $forumid  [版块id]
	 * @param [string] $userid [用户id]
	 * @param [int] $num [增加或减少]
	 */
	public function setUserForumLike($forumid, $userid, $num = 1){
		$key = $this->redis_header."user_forum_like_".$forumid;

		if($this->is_alive){

			$this->setUserForumLikeTime($forumid, $userid);
			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, $num);
			} else{
				return $this->mcache->hincrby($key, $userid, $num);
			}

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expireAt($key, 86400*7);
			}

			return $return_tf;
		}
		return false;;
	}

	/**
	 * [setUserForumLikeTime 设置各版块用户被喜欢时间]
	 * @param [int] $forumid  [版块id]
	 * @param [string] $userid [用户id]
	 */
	public function setUserForumLikeTime($forumid, $userid){
		$key = $this->redis_header."user_forum_like_time_".$forumid;

		if($this->is_alive){
			return $this->mcache->hSet($key, $userid, time());
		}
		return false;;
	}

	//返回各版块用户被喜欢数
	public function getUserForumLike($forumid){
		$key = $this->redis_header."user_forum_like_".$forumid;

		$list = array();
		if($this->is_alive){
			$list = $this->mcache->hGetAll($key);
			return $list;
		}
		return false;
	}

	//返回各版块用户精华帖子设置时间
	public function getUserForumLikeTime($forumid){
		$key = $this->redis_header."user_forum_like_time_".$forumid;

		$list = array();
		if($this->is_alive){
			$list = $this->mcache->hGetAll($key);
			return $list;
		}
		return false;
	}

	//清空各版块用户被喜欢数
	public function delUserForumLike($forumid){
		$key = $this->redis_header."user_forum_like_".$forumid;

		if($this->is_alive){
			if($this->mcache->exists($key)){
				return $this->mcache->expireAt($key, time() - 1);		
			}
		}
		return false;
	}

	/**
	 * [setUserPunch 设置用户签到数]
	 * @param [string] $userid [用户id]
	 */
	public function setUserPunch($userid){
		$key = $this->redis_header."user_punch";

		if($this->is_alive){

			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, 1);
			} else{
				return $this->mcache->hincrby($key, $userid, 1);
			}

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expireAt($key, 86400*7);	
			}

			return $return_tf;
		}
		return false;;
	}

	//返回用户签到数
	public function getUserPunch($userid){
		$key = $this->redis_header."user_punch";

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $userid)){
				$count = 0;
			} else{
				$count = $this->mcache->hGet($key, $userid);
			}
		} else{
			$count = 0;
		}

		return $count;
	}

	//清空用户签到数
	public function delUserPunch(){
		$key = $this->redis_header."user_punch";

		if($this->is_alive){
			if($this->mcache->exists($key)){
				return $this->mcache->expireAt($key, time() - 1);		
			}
		}
		return false;
	}

	/**
	 * [setUserPunch 设置日签到总数]
	 */
	public function setPunchDayCount(){
		$key = $this->redis_header."punch_day_count";

		if($this->is_alive){
			if(!$this->mcache->exists($key)){
				return $this->mcache->setex($key, 86400*5, 1);
			}else{
				return $this->mcache->IncrBy($key,1);
			}
		}
		return false;;
	}

	//返回日签到总数
	public function getPunchDayCount(){
		$key = $this->redis_header."punch_day_count";

		$list = array();
		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return false;
	}

	/**
	 * [setUserFristInThreadList 设置用户进入帖子列表记录]
	 * @param [string] $userid [用户id]
	 */
	public function setUserFristInThreadList($userid){
		$key = $this->redis_header."user_frist_in_threadlist";

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, 1);
			} else{
				return true;
			}
		}
		return false;
	}

	/**
	 * [getUserFristInThreadList 返回用户是否进入过帖子列表]
	 * @param [string] $userid [用户id]
	 */
	public function getUserFristInThreadListTF($userid){
		$key = $this->redis_header."user_frist_in_threadlist";

		$list = array();
		if($this->is_alive){
			if($this->mcache->hExists($key, $userid)){
				return true;
			} else{
				return false;
			}
		}
	}

	/**
	 * [setUserFristInUserCenter 设置用户进入用户中心记录]
	 * @param [string] $userid [用户id]
	 */
	public function setUserFristInUserCenter($userid){
		$key = $this->redis_header."user_frist_in_usercenter";

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, 1);
			} else{
				return true;
			}
		}
		return false;
	}

	/**
	 * [getUserFristInUserCenterTF 返回用户是否进入过用户中心]
	 * @param [string] $userid [用户id]
	 */
	public function getUserFristInUserCenterTF($userid){
		$key = $this->redis_header."user_frist_in_usercenter";

		$list = array();
		if($this->is_alive){
			if($this->mcache->hExists($key, $userid)){
				return true;
			} else{
				return false;
			}
		}
	}

	/**
	 * [setUserFristInGiftCenter 设置用户进入礼包中心记录]
	 * @param [string] $userid [用户id]
	 */
	public function setUserFristInGiftCenter($userid){
		$key = $this->redis_header."user_frist_in_giftcenter";

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $userid)){
				return $this->mcache->hSetnx($key, $userid, 1);
			} else{
				return true;
			}
		}
		return false;
	}

	/**
	 * [getUserFristInGiftCenterTF 返回用户是否进入过礼包中心]
	 * @param [string] $userid [用户id]
	 */
	public function getUserFristInGiftCenterTF($userid){
		$key = $this->redis_header."user_frist_in_giftcenter";

		$list = array();
		if($this->is_alive){
			if($this->mcache->hExists($key, $userid)){
				return true;
			} else{
				return false;
			}
		}
	}

	/**
	 * [setLogContent 设置缓存信息]
	 */
	public function setLogContent($content){
		$key = $this->redis_header."log_content";

		if($this->is_alive){
			return $this->mcache->set($key, $content);
		}
		return false;
	}

	/**
	 * [getLogContent 返回缓存信息]
	 */
	public function getLogContent(){
		$key = $this->redis_header."log_content";

		if($this->is_alive){
			$list = $this->mcache->get($key);
			return $list;
		}
		return '';
	}

	//获取开服信息不显示列表
	public function getNGOpenList(){
		$key = $this->redis_header.'ng_open_list';

		if ($this->is_alive) {
			$open_list = json_decode($this->mcache->get($key), 1);
			if(is_array($open_list)){
				return $open_list;
			} else{
				return array();
			}
		} else{
			return array();
		}
	}

	/**
	 * [setUserPunch 设置用户签到数]
	 * @param [string] $userid [用户id]
	 */
	public function setUserPunchIp($ip){
		$day_time = strtotime(date('Y-m-d', time()));
		$key = $this->redis_header."user_punch_ip_".date('Ymd', $day_time);

		if($this->is_alive){

			if(!$this->mcache->hExists($key, $ip)){
				$return_tf = $this->mcache->hSetnx($key, $ip, 1);
			} else{
				$return_tf = $this->mcache->hincrby($key, $ip, 1);
			}

			if(!$return_tf){
				return false;
			} else{
				$this->mcache->expire($key, 86400*7);	
			}

			return $return_tf;
		}
		return false;;
	}

	/**
	 * [setUserMsg 设置用户信息]
	 * @param [string] $username [用户名]
	 */
	public function setUserMsg($username){
		$key = $this->redis_header."user_msg";

		$user_msg = Wekit::load('user.PwUser')->getUserByName($username, 2);
		if(empty($user_msg)){
			return false;
		}

		if($this->is_alive){
			return $this->mcache->hSet($key, $username, json_encode($user_msg));
		}
		return false;
	}

	//返回用户信息
	public function getUserMsg($username){
		$key = $this->redis_header."user_msg";

		if($this->is_alive){
			if(!$this->mcache->hExists($key, $username)){
				$count = Wekit::load('user.PwUser')->getUserByName($username, 2);
			} else{
				$count = $this->mcache->hGet($key, $username);
				$count = json_decode($count, 1);
			}
		} else{
			$count = array();
		}

		return $count;
	}
}