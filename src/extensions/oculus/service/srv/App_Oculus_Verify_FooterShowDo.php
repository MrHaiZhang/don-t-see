<?php
defined('WEKIT_VERSION') or exit(403);
/**
 * 全局->验证码->验证策略
 *
 * @author Conqu3r <>
 * @copyright 
 * @license 
 */
class App_Oculus_Verify_FooterShowDo {
    
    /**
     * @param array $config 需要设置的策略,每一个扩展项格式:key=>title
     * @return array
     */
    public function app_OculusDo() {            
            $config = Wekit::load('config.PwConfig')->getValues('app_oculus');
            $appkey = $config['afs_key'];
            $codejs = <<<JS
            <link rel="stylesheet" href="//g.alicdn.com/sd/ncpc/nc.css?t=20160822">
            <style> .nc-post-margin{margin-bottom:10px;} </style>
            <script src="//g.alicdn.com/sd/ncpc/nc.js?t=20160822"></script>
                        
JS;
            $m=Wind::getApp()->getResponse()->getData('_aCloud_');
            $mc=$m['m'].'/'.$m['c'];
            $a = $m['a'];
            $uid = @Wekit::app()->getLoginUser()->uid;
            switch ($mc) {
            case 'u/register':
                    if ($config['is_reg_open'] == "1" ) {
                        $btn_id = "register_id_nc";
                        $codejs .= $this->Other_Login_Output($appkey, $btn_id).$this->Register_Output($appkey, $btn_id);
                    }
                    break;
            case 'u/login':
                    if ($config['is_login_open'] == "1") {
                        $btn_id = "login_id_nc";
                        $codejs .= $this->Other_Login_Output($appkey, $btn_id).$this->Login_Output($appkey, $btn_id);   
                    }
                    break;
            case 'bbs/post':
                    if ($config['is_bbspost_open'] == "1" && $a == 'run') {
                        $btn_id = "J_post_sub_nc";
                        $codejs .= $this->Other_Login_Output($appkey, $btn_id).$this->Post_Output($appkey, $btn_id);;
                    }
                    break;
            default:
                    break;
            }
            echo $codejs;
    }
        /*
        操作登录页面的JS信息，克隆滑动验证条样式
         *           */
        public function Login_Output($appkey, $oculus_nc_id){
            $JS_Attr = $this->JS_Attrabite($appkey, $oculus_nc_id);
            $Login_JS = <<<JS
            <script type="text/javascript">
                window.onload = Wind.use('jquery', function(){ 
                        $("#J_login_qa").before('<dl class="cc"><dt><label>滑动验证：</label></dt><dd><div id="$oculus_nc_id"></div></dd></dl>');
                        $JS_Attr;
                        })
            </script>
                    
JS;
            return $Login_JS;
        }
        /*操作注册页面的JS信息，克隆滑动验证条样式*/
        public function Register_Output($appkey, $oculus_nc_id){
            $JS_Attr = $this->JS_Attrabite($appkey, $oculus_nc_id);
            $Register_JS = <<<JS
            <script type="text/javascript">
                 window.onload = Wind.use('jquery',function(){
                        $(".btn_submit").parent().parent("dl").before('<dl class><dt><label>滑动验证：</label></dt><dd><span class="must_red">*</span><div id="$oculus_nc_id"></div></dd></dl>');
                        $JS_Attr;
                    })
            </script>
JS;
            return $Register_JS;
        }
        /*操作发帖页面*/
        public function Post_Output($appkey, $oculus_nc_id){
            $JS_Attr = $this->JS_Attrabite($appkey, $oculus_nc_id);
            $Post_JS = <<<JS
            <script type="text/javascript">
                 window.onload = Wind.use('jquery',function(){
                        $("#J_post_sub").parent().before('<dl class="nc-post-margin"><dd><span class="must_red">*</span><div id="$oculus_nc_id"></div></dd></dl>');
                        $JS_Attr;
                    })
            </script>
JS;
            return $Post_JS;            
            
        }
        /*操作回帖页面*/
        public function Reply_Output($appkey, $oculus_nc_id){
            $JS_Attr = $this->JS_Attrabite($appkey, $oculus_nc_id);
            $Reply_JS = <<<JS
            <script type="text/javascript">
                 window.onload = function(){
                        $("#J_reply_quick_btn").parent().before('<dl class="nc-post-margin"><dd><span class="must_red">*</span><div id="$oculus_nc_id"></div></dd></dl></dd></dl>');
                        $JS_Attr;
                    }
            </script>
JS;
           return $Reply_JS;  
        }
        /*操作其它页面登录POP*/
        public function Other_Login_Output($appkey, $oculus_nc_id){
            $style = $oculus_nc_id == 'J_qlogin_login_nc' ? 'overflow:visible;float:left;' : '';
             $JS_Attr = $this->JS_Attrabite($appkey, $oculus_nc_id, 240);
            $Other_Login_JS = <<<JS
            <script type="text/javascript">  
            Wind.use('jquery', function(){
                    $("body").one("mouseenter", "#J_qlogin_pop", function(){
                        $("#J_qlogin_qa").before('<dl class><dt><label>验证：</label></dt><dd style="$style"><span class="must_red">*</span><div id="$oculus_nc_id"></div></dd></dl>');
                        $JS_Attr;
                    })
            })
            </script>
JS;
           return $Other_Login_JS;            
        }
        /*整体初始化JS信息*/
        public function JS_Attrabite($appkey, $oculus_nc_id, $customWidth =NULL){
            $width = $customWidth ? $customWidth : 300;
            $_nc_plugin_init = <<<JS
                   var random_nc = new noCaptcha();
                   try{
                    random_nc.init({
                        renderTo: '$oculus_nc_id',
                        appkey: '$appkey',
                        customWidth: $width,
                        closeImage:false,
                        scene: 'bbs',
                        is_Opt: 1,
                        language: 'cn',
                        callback: function (data) {
                            var insertparent = document.getElementById('$oculus_nc_id');
                            var wrapper = document.createElement("div");
                            wrapper.style.display = 'none';
                            wrapper.innerHTML = '<input name = "sessionId" value = ' + data.csessionid  + ' type = "hidden"/>' +
                                    '<input name = "sig" value = ' + data.sig  + ' type = "hidden"/>' +
                                    '<input name = "_NC" value ='+$oculus_nc_id+'  type = "hidden"/>' +
                                    '<input name = "app_token" value = '+umx.getToken()+' type = "hidden"/>';
                            insertparent.appendChild(wrapper);
                        }
                    });
                    window["$oculus_nc_id"] = random_nc;
                   }catch(e){
                        console.log(e)
                   }
                   
JS;
            return $_nc_plugin_init;
        }
}

?>
