package;

import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKeyList;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
using StringTools;

class KeybindSubstate extends MusicBeatSubstate
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var keyStrings:Array<String> = [];
	var bindPositions:Array<String> = ['Left','Down','Up','Right'];
	var ready:Bool = false;

	var ogPosition:Float;
	public function new(x:Float,y:Float)
	{
		super();
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		//add(menuBG);
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...bindPositions.length)
		{
			var controlLabel:Alphabet = new Alphabet(0,0, bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i], true, false);
			//trace(bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i]);
			//controlLabel.isMenuItem = true;
			controlLabel.screenCenter();
			controlLabel.y += (100 * (i - (bindPositions.length / 2))) + 50;
			//controlLabel.targetY = i;
			//ogPosition = controlLabel.x;
			//controlLabel.x = controlLabel.x + 1000;
			grpControls.add(controlLabel);
			//if (controlsStrings[i].indexOf('set') != -1)
			//{
				//var repstring:String = controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1];
				//trace(repstring.charAt(repstring.length - 1));
			//}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			//FlxTween.tween(i, {'alpha': 1}, 0.35,{ease: FlxEase.cubeOut});
		}
		changeSelection(0);
		//trace();
	}
	function createBindingText()
	{
		for(i in grpControls)
		{
			if(i.ID == curSelected)
				i.color = FlxColor.GREEN;
		}
	}
	//Not gonna actually delete it.
	function deleteBindingText()
	{
		for(i in grpControls)
		{
			if(i.ID == curSelected)
				i.color = FlxColor.WHITE;
		}
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(!controls.ACCEPT)
			ready = true;
		if (controls.ACCEPT && ready)
		{
			changeBinding();
			createBindingText();
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK)
			{
				for(i in grpControls)
				{
					FlxTween.tween(i, {x: i.x - 1000}, 0.35,{ease: FlxEase.backInOut, onComplete: function(twn:FlxTween)
						{
							close();
						}});
				}
				SaveConfig.saveKeybinds();
				SaveConfig.keysLoaded = true;
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
	}
	function waitingInput():Void
	{
		if (FlxG.keys.justPressed.ANY && FlxG.keys.getIsDown().length > 0 && !FlxG.keys.justPressed.ENTER)
		{
			switch(curSelected)
			{
				case 0:
					SaveConfig.setKeybinds(FlxG.keys.getIsDown()[0].ID,Control.LEFT,0);
				case 1:
					SaveConfig.setKeybinds(FlxG.keys.getIsDown()[0].ID,Control.DOWN,1);
				case 2:
					SaveConfig.setKeybinds(FlxG.keys.getIsDown()[0].ID,Control.UP,2);
				case 3:
					SaveConfig.setKeybinds(FlxG.keys.getIsDown()[0].ID,Control.RIGHT,3);
			}
			isSettingControl = false;
			deleteBindingText();
			reloadList();
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;
	function reloadList()
	{
		remove(grpControls);
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...bindPositions.length)
		{
			var controlLabel:Alphabet = new Alphabet(0,0, bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i], true, false);
			//trace(bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i]);
			//controlLabel.isMenuItem = true;
			controlLabel.screenCenter();
			controlLabel.y += (100 * (i - (bindPositions.length / 2))) + 50;
			//controlLabel.targetY = i;
			grpControls.add(controlLabel);
			controlLabel.scale.set(1.1,1.1);
			FlxTween.tween(controlLabel.scale, {x:1,y:1},0.25,{ease:FlxEase.sineOut});
			//if (controlsStrings[i].indexOf('set') != -1)
			//{
				//var repstring:String = controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1];
				//trace(repstring.charAt(repstring.length - 1));
			//}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		changeSelection(0);
	}
	function changeBinding():Void
	{
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		//ready = true;
		#if !switch
		//NGio.logEvent('Fresh');
		#end

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
