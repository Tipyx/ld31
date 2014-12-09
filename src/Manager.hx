package ;

/**
 * ...
 * @author Tipyx
 */

enum TypeCase {
	TCNormal;
	TCWall;
	TCButton;
	TCTreadmill(way:String);
}
 
class Manager
{
	public static var AR_GRID	: Array<{type:TypeCase, cX:Int, cY:Int}> = [];
	public static var AR_SWITCH	: Array<{ar:Array<Int>, cX:Int, cY:Int}> = [];
	public static var EXIT		: { cX:Int, cY:Int };
	
	public static function INIT_GRID() {
		for (i in 0...Settings.GRID_WIDTH)
			for (j in 0...Settings.GRID_HEIGHT)
				AR_GRID.push( {type:TypeCase.TCNormal, cX:i, cY:j,  } );
	}

	public static function GRID_TO_PIXEL(c:Int):Int {
		return c * Settings.SIZE_CASE;
	}
	
	public static function ADD_WALL(cX:Int, cY:Int) {
		for (g in AR_GRID)
			if (g.cX == cX && g.cY == cY) {
				g.type = TypeCase.TCWall;
				return;
			}
				
		throw "No TypeCase in " + cX + " " + cY;
	}
	
	public static function ADD_BUTTON(numZone:Int, cX:Int, cY:Int) {
		for (g in AR_GRID)
			if (g.cX == cX && g.cY == cY) {
				g.type = TypeCase.TCButton;
				switch (numZone) {
					case 1	: AR_SWITCH.push( { ar:[2, 11], cX:cX, cY:cY } );
					case 2	: AR_SWITCH.push( { ar:[3, 5], cX:cX, cY:cY } );
					case 3	: AR_SWITCH.push( { ar:[4], cX:cX, cY:cY } );
					case 4	: AR_SWITCH.push( { ar:[9], cX:cX, cY:cY } );
					case 5	: AR_SWITCH.push( { ar:[7], cX:cX, cY:cY } );
					case 6	: AR_SWITCH.push( { ar:[3, 5, 10], cX:cX, cY:cY } );
					case 7	: AR_SWITCH.push( { ar:[5, 6], cX:cX, cY:cY } );
					case 8	:
					case 9	:
					case 10	: AR_SWITCH.push( { ar:[5, 8], cX:cX, cY:cY } );
					case 11	:
				}
				return;
			}
				
		throw "No TypeCase in " + cX + " " + cY;
	}
	
	public static function ADD_TREADMILL(string:String, cX:Int, cY:Int) {
		for (g in AR_GRID)
			if (g.cX == cX && g.cY == cY) {
				g.type = TypeCase.TCTreadmill(string);
				return;
			}
				
		throw "No TypeCase in " + cX + " " + cY;
	}
	
	public static function IS_COLLIDE(newCX:Int, newCY:Int):Bool {
		for (g in AR_GRID)
			if (g.cX == newCX && g.cY == newCY) {
				switch (g.type) {
					case TypeCase.TCNormal, TypeCase.TCButton, TypeCase.TCTreadmill :
						return false;
					case TypeCase.TCWall :
						return true;
				}
			}
				
		throw "No TypeCase in " + newCX + " " + newCY;
	}
	
	public static function IS_IN_ZONE_ACTIVATED(newCX:Int, newCY:Int):Bool {
		var b = false;
		
		for (z in Zone.ALL)
			if (z.isInThisZone(newCX, newCY) && z.isActivated)
				b = true;
			
		return b;
	}
}