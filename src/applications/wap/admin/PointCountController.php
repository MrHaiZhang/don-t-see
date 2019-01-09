<?php
Wind::import('ADMIN:library.AdminBaseController');
/**
 * 后台用户积分统计Controller
 *
 */
class PointCountController extends AdminBaseController {
	
	public function run() {

		//积分组
		Wind::import('SRV:credit.bo.PwCreditBo');
		$pwCreditBo = PwCreditBo::getInstance();

		$credit_num = $this->getInput('credit_num');		//积分字段
		$credit_num < 1 && $credit_num = 1;
		$group_num = $this->getInput('group_num');		//分组区间值
		$group_num < 1 && $group_num = 100;

		$userDs = Wekit::load('user.PwUser');
		$maxCreditUser = $userDs->getCreditMax($credit_num);
		$maxCreditUser = array_values($maxCreditUser);
		$maxCredit = $maxCreditUser[0]['credit'.$credit_num];

		$group_list = array();
		$start = 0;
		$end = $group_num;
		while ( $start < $maxCredit) {
			$creditCount = $userDs->getCreditCount($start, $end);
			$group_list[] = array(
				'start'=>$start,
				'end'=>$end,
				'count'=>$creditCount,
				);
			$start = $end;
			$end += $group_num;
		}

		$this->setOutput($group_num, 'group_num');
		$this->setOutput($pwCreditBo->cType, 'pwCreditBo');
		$this->setOutput($group_list, 'group_list');
		$this->setTemplate('user_point_count');
	}

}