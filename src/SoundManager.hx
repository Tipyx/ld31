package ;

import mt.flash.Sfx;

/**
 * ...
 * @author Tipyx
 */
class SoundManager
{
	static var SBANK = Sfx.importDirectory("assets");
	
	public static var sFootstep:mt.flash.Sfx;
	public static var sSwitch:mt.flash.Sfx;
	public static var sWasted:mt.flash.Sfx;
	
	public static var sMusic:mt.flash.Sfx;

	public static function CREATE_ALL() {
		sSwitch = SBANK.switchBtn();
		sFootstep = SBANK.footstep2();
		sWasted = SBANK.wasted();
		
		sMusic = SBANK.ambiant();
	}
	
	public static function FOOTSTEP() {
		if (!sFootstep.isPlaying())
			sFootstep.play(1);
	}
	
	public static function SWITCH() {
		sSwitch.play();
	}
	
	public static function WASTED() {
		sWasted.play(0.75);
	}
	
	public static function PLAY_MUSIC() {
		sMusic.playLoop(0.5);
	}
	
	public static function STOP_MUSIC() {
		sMusic.stop();
	}
	
}