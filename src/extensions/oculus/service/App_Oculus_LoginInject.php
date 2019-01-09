<?php


defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('EXT:oculus.service.App_Oculus_LoginHook');

class App_Oculus_LoginInject extends PwBaseHookInjector {

    public function run(){
//        exit(1);
        $App_Oculus_LoginHook = new App_Oculus_LoginHook($this->bp);
//        var_dump($App_Oculus_LoginHook);
        return $App_Oculus_LoginHook;
    }
}