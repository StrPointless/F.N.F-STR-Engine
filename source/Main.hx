package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	var fmem:FMEM = new FMEM(10, 10, 0xffffff);

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, Cache));

		#if !mobile
		addChild(fmem);
		#end
		//addChild(new Memory())
	}
}
