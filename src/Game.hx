package ;

import h2d.Text;

import mt.deepnight.HProcess;
import mt.deepnight.Process;

import Foe;
import Manager;

/**
 * ...
 * @author Tipyx
 */
class Game extends HProcess
{
	public static var ME	: Game;

	var input			: Input;
	
	var hero			: Hero;
	
	public var arFoe	: Array<Foe>;
	
	var arZone			: Array<Zone>;
	
	public var bm		: h2d.SpriteBatch;
	public var bmFX 	: h2d.SpriteBatch;
	
	public var tweener	: mt.motion.Tweener;
	
	var isGameEnded		: Bool;
	var textExit		: h2d.Text;
	var textSpace		: h2d.Text;

	public function new() 
	{
		super();
		
		ME = this;
		
		isGameEnded = false;
		
		input = Main.ME.input;
		
		tweener = new mt.motion.Tweener();
		
		bm = new h2d.SpriteBatch(Settings.SLB_LD.tile);
		bm.filter = true;
		root.addChild(bm);
		
		bmFX = new h2d.SpriteBatch(Settings.SLB_LD.tile);
		bmFX.filter = true;
		bmFX.blendMode = SoftOverlay;
		root.addChild(bmFX);
		
		init();
		
		reset();
		
		SoundManager.PLAY_MUSIC();
	}
	
	function init() {
		Manager.INIT_GRID();
		
		arZone = [];
		
	// ZONES
		for (l in Settings.DATA_LD.levels) {
			var zone = new Zone(l.id, l.cX, l.cY);
			arZone.push(zone);
		}
		
	// HERO
		hero = new Hero();
		
	// FOE
		arFoe = [];
		
		for (i in 0...2) {
			var foe = new Foe(Zone.GET(4));
			arFoe.push(foe);			
		}
		
		var foe = new Foe(Zone.GET(7));
		arFoe.push(foe);
		
		for (i in 0...2) {
			var foe = new Foe(Zone.GET(8));
			arFoe.push(foe);			
		}
		
		var foe = new Foe(Zone.GET(6));
			arFoe.push(foe);
			
		textExit = new h2d.Text(Settings.FONT, root);
		textExit.text = "Exit";
		textExit.x = Manager.GRID_TO_PIXEL(35);
		textExit.y = Manager.GRID_TO_PIXEL(25);
			
		textSpace = new h2d.Text(Settings.FONT, root);
		textSpace.text = "SPACE";
		textSpace.x = Manager.GRID_TO_PIXEL(23) - Std.int(textSpace.textWidth / 2);
		textSpace.y = Manager.GRID_TO_PIXEL(13);
	}
	
	public function reset() {
		for (z in Zone.ALL)
			z.disable();
			
		Zone.GET(1).enable();
		hero.initNewPosition(16, 15);
		
		//Zone.GET(1).enable();
		//Zone.GET(2).enable();
		//Zone.GET(3).enable();
		//Zone.GET(4).enable();
		//Zone.GET(5).enable();
		//Zone.GET(6).enable();
		//Zone.GET(7).enable();
		//Zone.GET(8).enable();
		//Zone.GET(9).enable();
		//Zone.GET(10).enable();
		//Zone.GET(11).enable();
			
		for (f in arFoe)
			f.reset();
	}
	
	public function showEndGame() {
		isGameEnded = true;
		
		for (e in bm.getElements()) {
			var t = tweener.create();
			t.delay(Std.random(10));
			t.to(irnd(3, 8) * Settings.FPS, e.y = -100);
		}
		
		for (e in bmFX.getElements()) {
			var t = tweener.create();
			t.to(0.2 * Settings.FPS, e.alpha = 0);
		}
		
		textExit.visible = textSpace.visible = false;
	}
	
	public function doSwitchButton() {
		if (!isGameEnded) {
			for (s in Manager.AR_SWITCH)
				if (s.cX == hero.cX && s.cY == hero.cY) {
					for (z in s.ar)
						Zone.GET(z).toggle();
					SoundManager.SWITCH();
					textSpace.visible = false;
					return;
				}			
		}
	}
	
	override function update() {
		if (!isGameEnded) {
			if (input.left && !hero.lockMove)
				hero.dX -= hero.speed;
			if (input.right && !hero.lockMove)
				hero.dX += hero.speed;
				
			if (input.up && !hero.lockMove)
				hero.dY -= hero.speed;
			if (input.down && !hero.lockMove)
				hero.dY += hero.speed;
			
		// Entity Update
			hero.update();
			
			for (f in arFoe)
				f.update();			
		}
			
		tweener.update();
		
		Settings.SLB_LD.updateChildren();
	
		super.update();
	}
}