<?php


defined('WEKIT_VERSION') || exit('Forbidden');

//Wind::import('SRV:user.srv.login.PwUserLoginDoBase');
include_once WEKIT_PATH.'service/user/srv/login/PwUserLoginDoBase.php';
include_once WEKIT_PATH.'service/user/srv/PwLoginService.php';

class App_Oculus_LoginHook extends PwUserLoginDoBase {
    public $config = array();
    public function __construct(PwLoginService  $pwpost,$if_return = false) {
//        $this->config = Wekit::load('config.PwConfig')->getValues('app_oculus');
        Wind::import('EXT:oculus.service.App_Oculus_CommonDB');//兼容windid模式
        $app_oculus_common_db = App_Oculus_CommonDB::getInstance();
        $this->config = $app_oculus_common_db->getConfig();//滑动验证插件配置
        /* 1.0 版本appkey获取
        $this->appkey = $this->config['oculus_appkey'];
        $this->oculus_appsecret = $this->config['oculus_appsecret'];
        $this->oculus_accesskeyid = $this->config['oculus_accesskeyid'];
        $this->oculus_accesskeysecret = $this->config['oculus_accesskeysecret'];
         * 
         */
        
        $this->error_message = '';
        $this->beforeAction($if_return);
    }
    
    public function beforeAction($if_return = false){
        if ($this->config['is_login_open'] == "1") {
            $sessionId = Wind::getApp()->getRequest()->getRequest("sessionId");
            $sig = Wind::getApp()->getRequest()->getRequest("sig");
            $_NC = Wind::getApp()->getRequest()->getRequest("_NC");
            $app_token = Wind::getApp()->getRequest()->getRequest("app_token");
            if($sessionId == null || $sig ==null || $app_token ==null){
                if($if_return){
                    $this->error_message = '错误：滑块未滑动,请滑动滑块！';
                    return;
                }else{
                    echo json_encode(array('referer'=>'', 'refresh'=>false, 'state'=>'fail', 'message'=>'错误：滑块未滑动,请滑动滑块！', '__error'=>'')); 
                    exit(1);
                }
                
            }
            $this->_Check_Risk();
            $OculusApi = new OculusApi();
            $response = $OculusApi->check_oculus_risk( $app_token , $sessionId , $sig, $this->config["afs_key"] );
            if($response != 1){
                if($response == -1){
                    if($if_return){
                        $this->error_message = '错误：滑动验证不通过,请再次滑动！';
                    }else{
                        echo json_encode(array('referer'=>'', 'refresh'=>false, 'state'=>'fail', 'message'=>'错误：滑动验证不通过,请再次滑动！', '__error'=>'')); 
                        exit(1);
                    }
                }else if($response == 0){
                    if($if_return){
                        $this->error_message = '错误：请不要再次提交！滑动验证已使用过，请刷新之后在使用！';
                    }else{
                        echo json_encode(array('referer'=>'', 'refresh'=>false, 'state'=>'fail', 'message'=>'错误：请不要再次提交！滑动验证已使用过，请刷新之后在使用！', '__error'=>'')); 
                        exit(1);
                    }        
                }
            }
        }
    }
    
    private function _Check_Risk(){
        return  Wind::import('EXT:oculus.lib.OculusApi');
    }
}