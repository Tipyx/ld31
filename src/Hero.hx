package ;

import Manager;
import Foe;

/**
 * ...
 * @author Tipyx
 */
 
class Hero extends Entity
{
	var bmp:h2d.Bitmap;
	public var lockMove	: Bool;
	
	public function new() {
		super();
		
		isHero = true;
		
		speed = 0.06;
		maxSpeed = 0.06;
		
		var game = Game.ME;
		
		lockMove = false;
		
		mainHS = Settings.SLB_LD.hbe_getAndPlay(game.bm, "hero2");
		mainHS.setCenter(0.5, -0.25);
		mainHS.a.setGeneralSpeed(0.15);
		
	#if debug
		bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFF0000, 32, 32));
		bmp.alpha = 0.5;
		//game.root.addChild(bmp);
	#end
		
		initNewPosition(0, 0);
	}
	
	function checkDetected(f:Foe):Bool {
		var a = Math.atan2(yy - f.yy, xx - f.xx);
		var d = mt.MLib.toDeg(a);
		
		if (mt.deepnight.Lib.distanceSqr(xx, yy, f.xx, f.yy) < 100 * 100) {
			var b = false;
			switch (f.orientation) {
				case Orientation.DOWN	:
					if (d > 50 && d < 130)
						b = true;
				case Orientation.LEFT :
					if (d > 140 || d < -140)
						b = true;
				case Orientation.RIGHT :
					if (d < 40 && d > -40)
						b = true;
				case Orientation.UP :
					if (d < -50 && d > -130)
						b = true;
			}
			
			if (b) {
				for (l in mt.deepnight.Bresenham.getThinLine(cX, cY, f.cX, f.cY))
					if (Manager.IS_COLLIDE(l.x, l.y))
						return false;
						
				return true;
			}
			else
				return false;
		}
		else
			return false;
	}
	
	override public function update() {
		super.update();
		
		mainHS.y = yy - Settings.SIZE_CASE;
		
	#if debug
		bmp.x = xx - 16;
		bmp.y = yy - 16;
	#end
	
		if ((dX != 0 || dY != 0)
		&&	(Main.ME.input.down
		||	Main.ME.input.up
		||	Main.ME.input.left
		||	Main.ME.input.right))
			SoundManager.FOOTSTEP();
	
		if (dX > 0)
			mainHS.scaleX = -1;
		else if (dX < 0)
			mainHS.scaleX = 1;
		
		for (g in Manager.AR_GRID)
			if (g.cX == cX && g.cY == cY) {
				switch (g.type) {
					case TypeCase.TCTreadmill(way) :
						lockMove = true;
						dX = dY = 0;
						switch (way) {
							case "up" :		
								rX = 0.5;
								dY = -0.1;
							case "down" :
								rX = 0.5;
								dY =  0.1;
							case "left" :	
								rY = 0.5;
								dX = -0.1;
							case "right" :
								rY = 0.5;
								dX =  0.1;
						}
					case TypeCase.TCButton, TypeCase.TCNormal, TypeCase.TCWall :
						lockMove = false;
				}
			}
			
		for (f in Game.ME.arFoe)
			if (checkDetected(f)) { // ON LOOSE
				SoundManager.WASTED();
				new mt.heaps.fx.Shake(Game.ME.root, 2, 0);
				FX.SHOW_RED_SCREEN();
				Game.ME.reset();
			}
			
		if (cX == Manager.EXIT.cX && cY == Manager.EXIT.cY)
			Game.ME.showEndGame();
	}
}