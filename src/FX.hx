package ;

/**
 * ...
 * @author Tipyx
 */
class FX
{
	static var RED_SCREEN	: h2d.Bitmap;
	
	
	public static function CREATE() {
		RED_SCREEN = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFF0000, mt.Metrics.w(), mt.Metrics.h()));
		RED_SCREEN.alpha = 0;
	}

	public static function SHOW_RED_SCREEN() {
		if (RED_SCREEN.parent == null)
			Game.ME.root.addChild(RED_SCREEN);
			
		RED_SCREEN.alpha = 1;
		
		Game.ME.tweener.create().to(0.2 * Settings.FPS, RED_SCREEN.alpha = 0);
	}
	
}