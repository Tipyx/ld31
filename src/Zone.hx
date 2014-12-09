package ;

import mt.deepnight.slb.HSpriteBE;

/**
 * ...
 * @author Tipyx
 */
class Zone extends h2d.Sprite
{
	public static var ALL	: Array<Zone>		= [];
	
	var arHS				: Array<HSpriteBE>;
	
	public var arBanned		: Array<{cX:Int, cY:Int}>;
	
	public var wid			: Int;
	public var hei			: Int;
	public var cX			: Int;
	public var cY			: Int;
	
	public var isActivated	: Bool;
	
	public var num			: Int;

	public function new(id:String, cX:Int, cY:Int) {
		super();
		this.cY = cY;
		this.cX = cX;
		
		this.num = Std.parseInt(id.substr(4));
		
		arHS = [];
		
		arBanned = [];
		
		isActivated = true;
		
		var game = Game.ME;
		
		var hsLD = Settings.SLB_LD.getBitmapData(id);
		wid = hsLD.width;
		hei = hsLD.height;
		
		for (i in 0...wid) {
			for (j in 0...hei) {
				switch (hsLD.getPixel(i, j)) {
					case 0xAAAAAA : // EMPTY
						arBanned.push( { cX:i + cX, cY:j + cY } );
						
					case 0x000000 : // WALL
						addHS(i, j, "classicWall");
						
						Manager.ADD_WALL(i + cX, j + cY);
						
					case 0xFF0000 :	// EXIT
						addHS(i, j, "exit");
						
						Manager.EXIT = { cX:i + cX, cY:j + cY };
						
					case 0x9C711D : // LIBRARY
						addHS(i, j, "library");
						
						Manager.ADD_WALL(i + cX, j + cY);
						
					case 0x79D8FF : // SERVEUR
						var hs = addHS(i, j, Std.random(2) == 0 ? "serverOff" : "serverOn");
						
						var tp = game.createTinyProcess();
						tp.onUpdate = function() {
							if (Std.random(Settings.FPS * 30) == 0) {
								if (hs.groupName.indexOf("serverOff") != -1)
									hs.set("serverOn");
								else
									hs.set("serverOff");
									
								if (!Zone.GET(4).isActivated)
									hs.set(hs.groupName + "Night");
							}
						}
						
						Manager.ADD_WALL(i + cX, j + cY);
						
					case 0xFF00FF : // SWITCH
						var hs = addHS(i, j, "button");
						hs.changePriority(Settings.GRID_HEIGHT + 1);
						
						Manager.ADD_BUTTON(num, i + cX, j + cY);
					
					case 0xFFFFFF : // FLOOR
						//var floor = Settings.SLB_LD.hbe_get(game.bm, "floor");
						var hs = addHS(i, j, "floorParquet");
						hs.changePriority(Settings.GRID_HEIGHT + 1);
						
					case 0x00FF00 : // TREADMILL UP
						var wall = Settings.SLB_LD.hbe_getAndPlay(game.bm, "treadmill");
						wall.rotation = -3.14 / 2;
						wall.a.setCurrentAnimSpeed(0.8);
						wall.setCenter(0.5, 0.5);
						wall.x = Manager.GRID_TO_PIXEL(i + cX) + Std.int(Settings.SIZE_CASE / 2);
						wall.y = Manager.GRID_TO_PIXEL(j + cY) + Std.int(Settings.SIZE_CASE / 2);
						wall.changePriority(Settings.GRID_HEIGHT + 1);
						arHS.push(wall);
						
						Manager.ADD_TREADMILL("up", i + cX, j + cY);
						
					case 0x008D2F : // TREADMILL DOWN
						var wall = Settings.SLB_LD.hbe_getAndPlay(game.bm, "treadmill");
						wall.rotation = 3.14 / 2;
						wall.a.setCurrentAnimSpeed(0.8);
						wall.setCenter(0.5, 0.5);
						wall.x = Manager.GRID_TO_PIXEL(i + cX) + Std.int(Settings.SIZE_CASE / 2);
						wall.y = Manager.GRID_TO_PIXEL(j + cY) + Std.int(Settings.SIZE_CASE / 2);
						wall.changePriority(Settings.GRID_HEIGHT + 1);
						arHS.push(wall);
						
						Manager.ADD_TREADMILL("down", i + cX, j + cY);
						
					case 0x00C643 : // TREADMILL LEFT
						var wall = Settings.SLB_LD.hbe_getAndPlay(game.bm, "treadmill");
						wall.rotation = 3.14;
						wall.a.setCurrentAnimSpeed(0.8);
						wall.setCenter(0.5, 0.5);
						wall.x = Manager.GRID_TO_PIXEL(i + cX) + Std.int(Settings.SIZE_CASE / 2);
						wall.y = Manager.GRID_TO_PIXEL(j + cY) + Std.int(Settings.SIZE_CASE / 2);
						wall.changePriority(Settings.GRID_HEIGHT + 1);
						arHS.push(wall);
						
						Manager.ADD_TREADMILL("left", i + cX, j + cY);
						
					case 0x00561D : // TREADMILL RIGHT
						var wall = Settings.SLB_LD.hbe_getAndPlay(game.bm, "treadmill");
						wall.a.setCurrentAnimSpeed(0.8);
						wall.setCenter(0.5, 0.5);
						wall.x = Manager.GRID_TO_PIXEL(i + cX) + Std.int(Settings.SIZE_CASE / 2);
						wall.y = Manager.GRID_TO_PIXEL(j + cY) + Std.int(Settings.SIZE_CASE / 2);
						wall.changePriority(Settings.GRID_HEIGHT + 1);
						arHS.push(wall);
						
						Manager.ADD_TREADMILL("right", i + cX, j + cY);
						
					case 0xBCE4F9 : // CLOAKROOM
						
						addHS(i, j, "vestiaire");
						addHS(i, j, "floorParquet");
						
						Manager.ADD_WALL(i + cX, j + cY);
						
					case 0x3F3F3F, 0x515151, 0x737373, 0x808080, 0x8b8b8b, 0x9e9e9e : // REST ROOM
						var n = 0;
						switch (hsLD.getPixel(i, j)) {
							case 0x3F3F3F : n = 0;
							case 0x515151 : n = 1;
							case 0x737373 : n = 2;
							case 0x808080 : n = 3;
							case 0x8b8b8b : n = 4;
							case 0x9e9e9e : n = 5;
						}
						
						addHS(i, j, "game", n);
						addHS(i, j, "floorParquet");
						
						Manager.ADD_WALL(i + cX, j + cY);
						
					default :
						throw "No Sprite with id " + hsLD.getPixel(i, j);
				}
			}
		}
		
		disable();
		
		ALL.push(this);
	}
	
	function addHS(i:Int, j:Int, id:String, ?f:Int = 0):HSpriteBE {
		var hs = Settings.SLB_LD.hbe_get(Game.ME.bm, id, f);
		hs.setCenter(0, 1);
		hs.x = Manager.GRID_TO_PIXEL(i + cX);
		hs.y = Manager.GRID_TO_PIXEL(j + cY) + Settings.SIZE_CASE;
		hs.changePriority(Settings.GRID_HEIGHT - (j + cY));
		arHS.push(hs);
		
		return hs;
	}
	
	public function toggle() {
		if (isActivated)
			disable();
		else
			enable();
	}
	
	public function enable() {
		if (!isActivated) {
			isActivated = true;
			for (hs in arHS) {
				var n = hs.groupName.indexOf("Night");
				hs.set(hs.groupName.substring(0, n), hs.frame);
			}			
		}
	}
	
	public function disable() {
		if (isActivated) {
			isActivated = false;
			for (hs in arHS)
				hs.set(hs.groupName + "Night", hs.frame);
		}
	}
	
	public function isBanned(newCX:Int, newCY:Int):Bool {
		for (b in arBanned)
			if (newCX == b.cX && newCY == b.cY)
				return true;
				
		return false;
	}
	
	public function isInThisZone(newCX:Int, newCY:Int):Bool {
		for (b in arBanned)
			if (newCX == b.cX && newCY == b.cY)
				return false;
		
		if (newCX >= cX && newCX < cX + wid
		&&	newCY >= cY && newCY < cY + hei) {
			return true;
		}
		else
			return false;
	}
	
	public function update() {
		
	}
	
// STATIC
	public static function GET(num:Int) {
		for (z in ALL)
			if (z.num == num)
				return z;
				
		throw "No Zone with the num " + num;
	}

	public static function UPDATE() {
		for (z in ALL)
			z.update();
	}
}