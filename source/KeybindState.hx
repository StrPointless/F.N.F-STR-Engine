package;

import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKeyList;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class KeybindState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var keyStrings:Array<String> = [];
	var bindPositions:Array<String> = ['Left','Down','Up','Right'];

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...bindPositions.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i] + '.', true, false);
			trace( bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i] + '.');
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			//if (controlsStrings[i].indexOf('set') != -1)
			//{
				//var repstring:String = controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1];
				//trace(repstring.charAt(repstring.length - 1));
			//}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
		//trace();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			changeBinding();
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK)
			{
				FlxG.switchState(new OptionsMenu());
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
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i], true, false);
			trace(bindPositions[i] + ' is ' + SaveConfig.playerKeybinds[i]);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			//if (controlsStrings[i].indexOf('set') != -1)
			//{
				//var repstring:String = controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1];
				//trace(repstring.charAt(repstring.length - 1));
			//}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
	}
	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
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
