
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKeyboard;
import flixel.input.keyboard.FlxKeyList;
import flixel.addons.transition.FlxTransitionableState;
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


class OptionsMenu extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Gameplay', 'UI', 'Controls', 'Accesibilty'];
	private var grpItems:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;

	override function create()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpItems = new FlxTypedGroup<Alphabet>();
		add(grpItems);

		for (i in 0...textMenuItems.length)
		{
			var label:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			label.isMenuItem = true;
			label.targetY = i;
			label.screenCenter(X);
			grpItems.add(label);
			//if (controlsStrings[i].indexOf('set') != -1)
			//{
				//var repstring:String = controlsStrings[i].substring(3) + ': ' + controlsStrings[i + 1];
				//trace(repstring.charAt(repstring.length - 1));
			//}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
		
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			switch(curSelected)
			{
				case 0:
					trace('go to Gameplay');
				case 1:
					trace('go to UI');
				case 2:
					FlxG.switchState(new KeybindState());
				case 3:
					trace('go to accesibilty');
					
			}
		}
		else
		{
			if (controls.BACK)
			{
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				FlxG.switchState(new MainMenuState());
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
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
			curSelected = grpItems.length - 1;
		if (curSelected >= grpItems.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpItems.members)
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
