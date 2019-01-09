<?php


defined('WEKIT_VERSION') || exit('Forbidden');

Wind::import('EXT:oculus.service.App_Oculus_RegHook');

class App_Oculus_RegInject extends PwBaseHookInjector {

    public function run(){
        $App_Oculus_RegHook = new App_Oculus_RegHook($this->bp);
        return $App_Oculus_RegHook;
    }
}