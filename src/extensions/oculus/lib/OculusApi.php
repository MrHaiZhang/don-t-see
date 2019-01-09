<?php
class OculusApi {

    public function check_oculus_risk($token, $sessionId ,$sig, $afs_key  ) {
        Wind::import('EXT:oculus.top.TopClient');
        $top_client = new TopClient();
        $top_client->format = 'json';

        Wind::import('EXT:oculus.top.request.AlibabaSecurityJaqAfsCheckRequest');
        $req = new AlibabaSecurityJaqAfsCheckRequest();
        $req->setPlatform("3");
        $req->setToken($token);
        $req->setSessionId($sessionId);
        $req->setSig($sig);
        $req->setAfsKey($afs_key);
        $resp = $top_client->execute($req);

        if(isset($resp->data)) {
            if($resp->data) {
                return 1;
            } else {
                return - 1;
            }
        } else {
            return 0;
        }

	}
}
