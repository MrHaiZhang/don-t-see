<?php

class App_Oculus_CommonDB {

//保存类实例的静态成员变量
    private static $_instance;
    public $dbpre;
    public $charset;

//private标记的构造方法
    private function __construct() {
        $db_conf = include WEKIT_PATH.'../conf/database.php';
        $username = $db_conf['user'];
        $password = $db_conf['pwd'];
        $this->charset = $db_conf['charset'];
        $this->dbpre = $db_conf['tableprefix'];
        $engine = $db_conf['engine'];
        $dsn = explode(";", $db_conf['dsn']);
        //    var_dump($dsn);
        $host = trim(substr($dsn[0],strpos($dsn[0], "=")+1));
        $dbname = trim(substr($dsn[1],strpos($dsn[1], "=")+1));
        $port = trim(substr($dsn[2],strpos($dsn[2], "=")+1));
        //    var_dump($host,$dbname,$port);exit;
        //    echo "连接数据库...<br>";
        $con = mysql_connect($host.":".$port,$username,$password) or die('Could not connect: ' . mysql_error());
        mysql_select_db($dbname, $con) or die('Can\'t use foo : ' . mysql_error());
        //    echo "设置查询字符集...<br>";
        $result = mysql_query("SET character_set_connection= 'utf8', character_set_results= 'utf8', character_set_client=BINARY, sql_mode=''") or die("Invalid query: " . mysql_error());
        $result = mysql_query("SET NAMES 'utf8'") or die("Invalid query: " . mysql_error());
    }

//创建__clone方法防止对象被复制克隆
    public function __clone() {
        trigger_error('Clone is not allow!', E_USER_ERROR);
    }

//单例方法,用于访问实例的公共的静态方法
    public static function getInstance() {
        if (!(self::$_instance instanceof self)) {
            self::$_instance = new self;
        }
        return self::$_instance;
    }

    public function query($sql) {
        $result = mysql_query($sql) or die("Invalid query: " . mysql_error());
        $res = array();
        while ($row = mysql_fetch_array($result,MYSQL_ASSOC)) {
            $res[] = $row;
        }
        
        return $res;
    }
    
    public function getConfig(){
        $res = $this->query("SELECT * FROM `".$this->dbpre."common_config` WHERE namespace='app_oculus'");
        $result = array();
        foreach($res as $v){
            $result[$v['name']] = $v['value'];
        }
        
        return $result;
    }

}


