<?php
/**
 *	日志类
 */

date_default_timezone_set('Asia/Shanghai');

class Log{
	protected	$log_file;

	public function __construct() {
		$this->log_dir = 'log/'.date('Y_m_d').'/';
	}

	public function check_file($file_name){
		if( !is_file($file_name) ){
			file_put_contents($file_name, '');
		} elseif (!is_writable($file_name)){
			chown($file_name, 'nobody');
			chmod($file_name, 0644);
		}
	}

	public function check_dir($log_dir){
		if(!is_dir($log_dir)){
			mkdir($log_dir,0777,true);
			chown($log_dir, 'nobody');
		}
	}

	public function add_crond_log($path, $module, $contents){
		$file_name = $path.$this->log_dir.$module.'.log';
		self::check_dir($path.$this->log_dir);
		self::check_file($file_name);
		if(is_array($contents)){
			$log_str = json_encode($contents);
		} else {
			$log_str = str_replace("\n", "\t", $contents);
		}
		file_put_contents($file_name, date('Y-m-d H:i:s').'|'.$log_str."\n",FILE_APPEND);
	}

}