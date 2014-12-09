package ;

/**
 * ...
 * @author Tipyx
 */
class Entity
{
	static var OFFSET_X 		: Float		= 0.3;
	static var OFFSET_Y 		: Float		= 0.3;
	
	public var speed 			: Float		= 0;
	public var maxSpeed		: Float		= 0;
	
	public var cX		: Int;
	public var cY		: Int;
	
	public var rX		: Float;
	public var rY		: Float;
	
	public var dX		: Float;
	public var dY		: Float;
	
	public var xx		: Int;
	public var yy		: Int;
	
	var mainHS				: mt.deepnight.slb.HSpriteBE;
	
	var isHero			: Bool;

	public function new() {
		isHero = false;
	}
	
	public function initNewPosition(newCX:Int, newCY:Int) {
		cX = newCX;
		cY = newCY;
		
		rX = 0.5;
		rY = 0.5;
		
		dX = 0;
		dY = 0;
		
		mainHS.changePriority(Settings.GRID_HEIGHT - cY);
	}
	
	function hasCollision(newCX:Int, newCY:Int):Bool {
		return Manager.IS_COLLIDE(newCX, newCY) || (!Manager.IS_IN_ZONE_ACTIVATED(newCX, newCY) && isHero);
	}
	
	public function destroy() {
		mainHS.destroy();
		mainHS = null;
	}
	
	public function update() {
		var frict = 0.80;
		
		// X component
		rX += dX;
		dX *= frict;
		if (dX > maxSpeed)
			dX = maxSpeed;
		if (dX < -maxSpeed)
			dX = -maxSpeed;
		if (dX > -0.005 && dX < 0.005)
			dX = 0;
		
		if (dX != 0) {
			if (hasCollision(cX - 1, cY) && rX <= OFFSET_X) {
				dX = 0;
				rX = OFFSET_X;
			}
			if (hasCollision(cX + 1, cY) && rX >= (1 - OFFSET_X)) {
				dX = 0;
				rX = 1 - OFFSET_X;
			}
			
			while (rX < 0) {
				cX--;
				rX++;
			}
			while (rX > 1) {
				cX++;
				rX--;
			}			
		}
		
		// Y component
		rY += dY;
		dY *= frict;
		if (dY > maxSpeed)
			dY = maxSpeed;
		if (dY < -maxSpeed)
			dY = -maxSpeed;
		if (dY > -0.005 && dY < 0.005)
			dY = 0;
		
		if (dY != 0 ) {
			if (hasCollision(cX, cY - 1) && rY <= OFFSET_Y) {
				dY = 0;
				rY = OFFSET_Y;
			}
			if (hasCollision(cX, cY + 1) && rY >= (1 - OFFSET_Y)) {
				dY = 0;
				rY = 1 - OFFSET_Y;
			}
			
			while (rY < 0) {
				cY--;
				mainHS.changePriority(Settings.GRID_HEIGHT - cY);
				rY++;
			}
			while (rY > 1) {
				cY++;
				mainHS.changePriority(Settings.GRID_HEIGHT - cY);
				rY--;
			}			
		}
		
		xx = Std.int((cX + rX) * Settings.SIZE_CASE);
		yy = Std.int((cY + rY) * Settings.SIZE_CASE);
		mainHS.x = xx;
		mainHS.y = yy;
	}
	
}