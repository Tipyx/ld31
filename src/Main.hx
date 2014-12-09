package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author Tipyx
 */

class Main extends Sprite 
{
	public static var ME	: Main;
	
	var engine				: h3d.Engine;
	public var input		: Input;
	
	var MAIN_SCENE			: h2d.Scene;
	
	public function new() 
	{
		super();
		
		ME = this;
		
		input = new Input();
		
		engine = new h3d.Engine();
		engine.onReady = init;
		//engine.backgroundColor = 0x101222;
		//engine.backgroundColor = 0xC0C0C0;
		engine.backgroundColor = 0x000000;
		engine.init();
		
		var stats = new mt.flash.Stats();
	#if debug
		flash.Lib.current.addChild(stats);
	#end
	}
	
	function init() {
		MAIN_SCENE = new h2d.Scene();
		mt.deepnight.HProcess.GLOBAL_SCENE = MAIN_SCENE;
		
		mt.fx.Fx.DEFAULT_MANAGER = new mt.fx.Manager();
		
		Settings.CREATE();
		FX.CREATE();
		
		SoundManager.CREATE_ALL();
		
		var end = new End();
		
		var game = new Game();	
		
		hxd.System.setLoop(update);	
	}
	
	function update() {
		var i = 1;
	#if debug
		input.a ? 10 : 1;
	#end
		
		for (i in 0...i) {
			mt.deepnight.Process.updateAll();
			
			mt.fx.Fx.DEFAULT_MANAGER.update();
		
			engine.render(MAIN_SCENE);			
		}
	}
	
}
