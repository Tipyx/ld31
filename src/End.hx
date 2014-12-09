package ;

import h2d.Sprite;
import mt.deepnight.HProcess;
import mt.deepnight.Process;

import h2d.Text;

/**
 * ...
 * @author Tipyx
 */
class End extends HProcess
{

	public function new() 
	{
		super();
		
		var text = new h2d.Text(Settings.FONT);
		text.text = "Thank you for playing !";
		text.text += "\n \n";
		text.text += "Please leave a comment";
		text.text += "\n \n";
		text.text += "I like feedbacks, the positive, but even more, the negative :D !";
		text.text += "\n \n";
		text.text += "\n \n";
		text.text += "Oh, and sorry, no hard mode this time,";
		text.text += "\n \n";
		text.text += "I preferred spend my time on better art !";
		text.text += "\n \n";
		text.text += "Nope... ?";
		text.x = text.y = 100;
		text.x = Std.int((mt.Metrics.w() - text.textWidth) / 2);
		text.y = Std.int((mt.Metrics.h() - text.textHeight) / 2);
		text.textAlign = Align.Center;
		root.addChild(text);
	}
}