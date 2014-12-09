package ;

import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

import Game;

/**
 * ...
 * @author Tipyx
 */
class Input
{
	public var a			: Bool = false;
	
	public var left			: Bool = false;
	public var right		: Bool = false;
	public var up			: Bool = false;
	public var down			: Bool = false;
	public var space		: Bool = false;
	
	var game	: Game;

	public function new() 
	{
		this.game = Game.ME;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	private function onKeyDown(e:KeyboardEvent):Void {
		this.game = Game.ME;
		
		if (e.keyCode == Keyboard.A)		a = true;
		if (e.keyCode == Keyboard.LEFT)		left = true;
		if (e.keyCode == Keyboard.RIGHT)	right = true;
		if (e.keyCode == Keyboard.UP)		up = true;
		if (e.keyCode == Keyboard.DOWN)		down = true;
	}
	
	private function onKeyUp(e:KeyboardEvent):Void {
		this.game = Game.ME;
		
		if (e.keyCode == Keyboard.A)		a = false;
		if (e.keyCode == Keyboard.LEFT)		left = false;
		if (e.keyCode == Keyboard.RIGHT)	right = false;
		if (e.keyCode == Keyboard.UP)		up = false;
		if (e.keyCode == Keyboard.DOWN)		down = false;
		if (e.keyCode == Keyboard.SPACE)	game.doSwitchButton();
	}
	
	public function destroy() {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
}