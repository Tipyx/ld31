package ;

import mt.deepnight.slb.BLib;
import mt.deepnight.slb.assets.TexturePacker;

/**
 * ...
 * @author Tipyx
 */

typedef DataJSON = {
	levels:Array<{id:String, cX:Int, cY:Int}>
}
 
class Settings
{
	public static var FPS				:Int	= 60;
	
	public static var SIZE_CASE			: Int	= 32;
	public static var GRID_WIDTH 		: Int	= Std.int(mt.Metrics.w() / SIZE_CASE);
	public static var GRID_HEIGHT 		: Int	= Std.int(mt.Metrics.h() / SIZE_CASE);
	
	public static var SLB_LD			: BLib;
	
	public static var DATA_LD			: DataJSON;
	
	public static var FONT				: h2d.Font;
	
	public static var AR_FOES_WAY		: Array<Array<{cX:Int, cY:Int, wait:Int}>> = [
		[{cX:37, cY:14, wait:1 * Settings.FPS}],		// Level 1
	];
	
	public static function CREATE() {
		SLB_LD = TexturePacker.importXml("assets/ld.xml");
		
		var js = openfl.Assets.getBytes("assets/ld.json");
		var jsString = js.toString();
		DATA_LD = haxe.Json.parse(jsString);
		
	// FONT
		var openflFont = openfl.Assets.getFont("assets/font.TTF");
		FONT = hxd.res.FontBuilder.getFont(openflFont.fontName, 20, { antiAliasing : false , chars : hxd.Charset.DEFAULT_CHARS } );
	}
	
}