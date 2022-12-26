#if sys
package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Cache extends MusicBeatState
{
	public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var shitz:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		//FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();

		shitz = new FlxText(12, 630, 30000, "Loading...", 12);
		shitz.scrollFactor.set();
		shitz.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(shitz);

		//#if cpp
		if(FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")) != null)
		{
			new FlxTimer().start(5,function(tmr:FlxTimer)
			{
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")))
					{
						if (!i.endsWith(".png"))
							continue;
						images.push(i);
						shitz.text = "Caching Characters n Shit... " + i; 
					}
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/philly/")))
					{
						if (!i.endsWith(".png"))
							continue;
						images.push(i);
						shitz.text = "Caching Week3 Stuff... " + i; 
					}
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/limo/")))
					{
						if (!i.endsWith(".png"))
							continue;
						images.push(i);
						shitz.text = "Caching Week4 Stuff... " + i; 
					}
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/christmas")))
					{
						if (!i.endsWith(".png"))
							continue;
						images.push(i);
						shitz.text = "Caching Week5 Stuff... " + i; 
					}
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/weeb/")))
					{
						if (!i.endsWith(".png"))
							continue;
						images.push(i);
						shitz.text = "Caching Week6 Stuff... " + i; 
					}
					for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/music/")))
					{
						music.push(i);
						shitz.text = "Caching Songs... " + i;
					}
					//#end
					
					sys.thread.Thread.create(() -> {
						cache();
					});
			});
			
		}
		else
		{
			shitz.text = shitz.text + " - BTW library is null";
		}

		super.create();
	}

	override function update(elapsed) 
	{
		super.update(elapsed);
	}

	function cache()
	{
		#if !linux

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
		}



		for (i in music)
		{
			trace(i);
		}


		#end
		FlxTween.tween(shitz,{alpha: 0},2);
		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
					
				FlxG.switchState(new TitleState());
			});
	}

}
#end