<?php
defined('WEKIT_VERSION') || exit('Forbidden');
Wind::import('SRV:forum.srv.post.do.PwPostDoBase');

class App_Oculus_PostHook extends PwPostDoBase {
    public function __construct(PwPost $pwpost) {
        $this->config = Wekit::load('config.PwConfig')->getValues('app_oculus');
    }
        
    
    public function check($userDm){
        if ($this->config['is_bbspost_open'] == "1") {
            $sessionId = Wind::getApp()->getRequest()->getRequest("sessionId");
            $sig = Wind::getApp()->getRequest()->getRequest("sig");
            $_NC = Wind::getApp()->getRequest()->getRequest("_NC");
            $app_token = Wind::getApp()->getRequest()->getRequest("app_token");
            if($sessionId == null || $sig ==null || $app_token ==null)  return new PwError('错误：滑块未滑动,请滑动滑块！');
            $this->_Check_Risk();
            $OculusApi = new OculusApi();
            $response = $OculusApi->check_oculus_risk( $app_token , $sessionId , $sig, $this->config["afs_key"] );
            if($response != 1){
                if($response == -1){
                    return new PwError('错误：滑动验证不通过！请再次滑动，通过验证！');
                }else if($response == 0){
                    return new PwError('错误：请不要再次提交！滑动验证已使用过，请刷新之后在使用！');
                }
            }
        }
    }
    
    private function _Check_Risk(){
        return Wekit::load('EXT:oculus.lib.OculusApi');
    }
}