<?php


defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('EXT:oculus.service.App_Oculus_PostHook');

class App_Oculus_PostInject extends PwBaseHookInjector {

    public function run(){
        $App_Oculus_PostHook = new App_Oculus_PostHook($this->bp);
        return $App_Oculus_PostHook;
    }
}