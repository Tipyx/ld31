package ;

import mt.deepnight.slb.HSpriteBE;
import mt.deepnight.PathFinder;
import Manager;

/**
 * ...
 * @author Tipyx
 */

enum Orientation {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}
 
class Foe extends Entity
{
	var game			: Game;
	
	var goal			: { x:Int, y:Int };
	
	var domainEnable	: { cX1:Int, cY1:Int, cX2:Int, cY2:Int };
	
	var path			: Path;
	
	var torch			: mt.deepnight.slb.HSpriteBE;
	
	var t				: mt.motion.Tween;
	var zone			: Zone;
	
	public var orientation : Orientation;
	
	public var pf		: mt.deepnight.PathFinder;

	public function new(zone:Zone) {
		super();
		
		this.zone = zone;
		
		game = Game.ME;
		
		speed = 0.01;
		maxSpeed = 0.01;
		
		domainEnable = null;
		
		orientation = Orientation.DOWN;
		
		mainHS = Settings.SLB_LD.hbe_get(game.bm, "foe");
		mainHS.setCenter(0.5, -0.25);
		
		torch = Settings.SLB_LD.hbe_get(game.bmFX, "torch");
		torch.scaleX = torch.scaleY = 1.5;
		torch.alpha = 0.8;
		torch.setCenter(0.5, 0);
		
		setDomain();
		
		reset();
	}
	
	public function reset() {
		do {
			var gcX = mt.deepnight.Lib.irnd(domainEnable.cX1, domainEnable.cX2);
			var gcY = mt.deepnight.Lib.irnd(domainEnable.cY1, domainEnable.cY2);
			initNewPosition(gcX + zone.cX, gcY + zone.cY);
		} while (Manager.IS_COLLIDE(cX, cY) || zone.isBanned(cX, cY));
		
		goal = null;
		path = [];
		
		orientation = Orientation.DOWN;
		
		torch.rotation = 0;
	}
	
	function setDomain() {
		domainEnable = { cX1:0, cY1:0, cX2:zone.wid - 1, cY2:zone.hei - 1 };
		
		pf = new mt.deepnight.PathFinder(zone.wid, zone.hei);
		for (i in 0...zone.wid)
			for (j in 0...zone.hei)
				for (g in Manager.AR_GRID)
					if (g.cX == zone.cX + i && g.cY == zone.cY + j) {
						var bo = true;
						for (b in zone.arBanned)
							if (b.cX == zone.cX + i && b.cY == zone.cY + j) {
								pf.setCollision(i, j);
								bo = false;
							}
						
						if (bo) {
							switch (g.type) {
								case TypeCase.TCWall, TypeCase.TCTreadmill :
									pf.setCollision(i, j);
								case TypeCase.TCNormal, TypeCase.TCButton :
							}
						}
					}
	}
	
	public function getPath() {
		do {
			var finalGoal = null;
			do {
				var gcX = mt.deepnight.Lib.irnd(domainEnable.cX1, domainEnable.cX2);
				var gcY = mt.deepnight.Lib.irnd(domainEnable.cY1, domainEnable.cY2);
				finalGoal = { x:gcX, y:gcY };
			} while (pf.getCollision(finalGoal.x, finalGoal.y));
			
			path = pf.getPath( { x:cX - zone.cX, y:cY - zone.cY}, finalGoal);			
		} while (path.length == 0);
	}
	
	override public function destroy() {
		super.destroy();
		
		torch.destroy();
		torch = null;
		
		if (t != null)
			t.dispose();
	}
	
	override public function update() {
		super.update();
		
		mainHS.y = yy - Settings.SIZE_CASE;
		
		torch.x = xx;
		torch.y = yy;
		
		if (domainEnable != null) {
			if (goal == null || (cX == goal.x && cY == goal.y)) {
				if (path.length == 0)
					getPath();
				
				var g = path.shift();
				
				goal = { x:g.x + zone.cX, y:g.y + zone.cY };
				
				
				if (t != null)
					t.dispose();
				
				if (goal.x < cX) {
					t = game.tweener.create().to(0.2 * Settings.FPS, torch.rotation = 3.14 / 2);
					t.onComplete = function () { orientation = Orientation.LEFT; };
				}
				else if (goal.x > cX) {
					t = game.tweener.create().to(0.2 * Settings.FPS, torch.rotation = -3.14 / 2);
					t.onComplete = function () { orientation = Orientation.RIGHT; };
				}
				else if (goal.y < cY) {
					t = game.tweener.create().to(0.2 * Settings.FPS, torch.rotation = 3.14);
					t.onComplete = function () { orientation = Orientation.UP; };
				}
				else if (goal.y > cY) {
					t = game.tweener.create().to(0.2 * Settings.FPS, torch.rotation = 0);
					t.onComplete = function () { orientation = Orientation.DOWN; };
				}
					
				return;
			}
			
			if (goal.x < cX || (goal.x == cX && rX > 0.6))
				dX -= speed;
			else if (goal.x > cX || (goal.x == cX && rX < 0.4))
				dX += speed;
			
			if (goal.y < cY || (goal.y == cY && rY > 0.6))
				dY -= speed;
			else if (goal.y > cY || (goal.y == cY && rY < 0.4))
				dY += speed;			
		}
	}
}