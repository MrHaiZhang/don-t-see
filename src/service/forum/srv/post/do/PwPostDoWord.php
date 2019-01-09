<?php
Wind::import('SRV:forum.srv.post.do.PwPostDoBase');
Wind::import('SRV:word.PwWord');

/**
 * 发帖子检测敏感词
 *
 * @author jinlong.panjl <jinlong.panjl@aliyun-inc.com>
 * @copyright ©2003-2103 phpwind.com
 * @license http://www.phpwind.com
 * @version $Id$
 * @package wind
 *
 * 增加记录敏感词
 */
class PwPostDoWord extends PwPostDoBase {
	protected $_isVerified = 0;
	protected $_confirm = 0;
	protected $_word = 0;
	protected $_tagnames = array();
	
	public function __construct(PwPost $pwpost, $verifiedWord = 0, $tagnames = array()) {
		$this->_confirm = $verifiedWord;
		$this->_tagnames = $tagnames;
	}

	public function check($postDm) {
		$content = $data['subject'];
		$wordFilter = Wekit::load('SRV:word.srv.PwWordFilter');
		
		if ($this->_tagnames) {
			$content = $content.implode('', $this->_tagnames);
		}
		$banedStrLen = strlen($content);
		$content = $content.$data['content'];
		list($type, $words, $isTip, $type_arr) = $wordFilter->filterWord($content);
		if (!$type) return true; 
		$words = array_unique($words);
		foreach ($words as $k => $v) {
			if ($k < $banedStrLen) {
				return new PwError('WORD:title.tag.error',array('{wordstr}' => implode(',', $words)));
			}
		}
		$errorTip = $isTip ? 'WORD:content.error.tip' : 'WORD:content.error';
		switch ($type) {
			case 1:
				return new PwError($errorTip,array('{wordstr}' => implode(',', $words)));
			case 2:
				$this->_isVerified = 1;
				if ($this->_confirm) {
					return true;
				}
				return new PwError($errorTip,array('{wordstr}' => implode(',', $words)),array('isVerified' => $this->_isVerified));
			case 3:	
				$this->_word = 1;
			case 4:	
			case 5:	
				$postDm = $postDm->setSensitive1(implode(',', $type_arr[4]));
				$postDm = $postDm->setSensitive2(implode(',', $type_arr[5]));
				return $postDm;
			case 43:	
				$this->_word = 1;
				$postDm = $postDm->setSensitive1(implode(',', $type_arr[4]));
				$postDm = $postDm->setSensitive2(implode(',', $type_arr[5]));
				return $postDm;
			default:
				return true;
		}
		return true;
	}
	
	public function dataProcessing($postDm) {
		$word_version = $this->_word ? 0 : (int)Wekit::C('bbs', 'word_version');
		$this->_isVerified && $postDm->setDisabled(1);
		$postDm->setWordVersion($word_version);
		return $postDm;
	}
}
