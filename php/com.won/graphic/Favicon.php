<?php
// namespace com\won\graphic;
final class com_won_graphic_Favicon{
	
	public function __construct(){
		require_once dirname(__FILE__).'/php-ico/class-php-ico.php';				
	}
	
	public function save($src, $dest){
		$sizes=array(
			array(16,16),
			array(24,24),
			array(32,32),
			array(48,48),
			array(64,64),
			array(96,96),
			array(128,128)
		);
		$phpico = new PHP_ICO($src, $sizes);
		$phpico->save_ico($dest);
	}
	
}
?>