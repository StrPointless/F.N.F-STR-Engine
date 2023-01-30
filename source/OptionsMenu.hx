
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
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.util.FlxSignal;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;


class OptionsMenu extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Gameplay', 'UI', 'Controls', 'Accesibilty'];
	var description:Array<String> = ['Customize your in-game playstyle', 'Customize The position and General UI Aspects.', 'Change your keybinds(DO THAT NOW)', 'General Accessibilty Features'];
	private var grpItems:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var descriptionText:FlxText;

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	public static var base:FlxSprite;
	var inSubState:Bool = false;
	var curSubstate:FlxSubState;
	var descBar:FlxSprite;
	var CoolBG:FlxBackdrop = new FlxBackdrop(Paths.image('Main_Checker'), XY);
	var ScrollSpeed:Float = 0.5;
	var menuBG:FlxBackdrop;

	override function create()
	{
		persistentUpdate = persistentDraw = true;
		menuBG =  new FlxBackdrop(Paths.image('menuDesat'), X);//new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		base = new FlxSprite();
		base.frames = Paths.getSparrowAtlas('OptionsMenuAssets/Base');
		base.animation.addByPrefix('idle','Idle', 24);
		base.scale.set(1,1);
		base.animation.play('idle');
		base.scrollFactor.set(1,1);
		//base.screenCenter();
		//add(base);
		CoolBG.screenCenter();
		add(CoolBG);

		descBar = new FlxSprite(0,675).makeGraphic(1280,720,FlxColor.BLACK);
		//descBar.screenCenter();
		descBar.alpha = 0.6;
		descBar.scrollFactor.set(0,0);
		add(descBar);
		descriptionText = new FlxText(0,675,5000, description[0], 12);
		descriptionText.screenCenter(X);
		descriptionText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(descriptionText);
		selectorLeft = new Alphabet(0, 0, '<', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '>', true, false);
		add(selectorRight);
		var settingsLabel = new Alphabet(0, 0, 'Settings', true, false);
		settingsLabel.screenCenter();
		settingsLabel.y -= 300;
		add(settingsLabel);
				
		grpItems = new FlxTypedGroup<Alphabet>();
		add(grpItems);
		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.screenCenter();
			optionText.y += 250;
			grpItems.add(optionText);
		}
		
		super.create();
		changeSelection(0);
		
		subStateClosed.add((curSubstate)->{onSubStateClose();});
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && !inSubState)
		{
			switch(curSelected)
			{
				case 0:
					openSubState(new GameplaySubstate(0,0));
				case 1:
					trace('go to UI');
				case 2:
					openSubState(new KeybindSubstate(0,0));
				case 3:
					trace('go to accesibilty');
					
			}
		}
		else
		{
			if (controls.BACK && !inSubState)
			{
				FlxG.switchState(new MainMenuState());
				SaveConfig.savePreferences();
			}
			if (controls.LEFT_P && !inSubState)
				changeSelection(-1);
			if (controls.RIGHT_P && !inSubState)
				changeSelection(1);
		}
		CoolBG.x -= ScrollSpeed;
		CoolBG.y -= ScrollSpeed;
		menuBG.x -= ScrollSpeed;
	}
	override function openSubState(SubState:FlxSubState)
	{
		curSubstate = SubState;
		super.openSubState(SubState);
		for(i in grpItems)
			{
				FlxTween.tween(i, {x: i.x + 300, y: i.y + 25}, 0.5,{ease: FlxEase.cubeInOut});
				FlxTween.tween(descriptionText, {y: descriptionText.y + 200},0.5, {ease: FlxEase.cubeInOut});
				FlxTween.tween(descBar, {y: 0}, 0.5,{ease: FlxEase.cubeInOut});
				FlxTween.tween(selectorLeft, {x: selectorLeft.x + 300, y: selectorLeft.y + 25}, 0.5,{ease: FlxEase.cubeInOut});
				FlxTween.tween(selectorRight, {x: selectorRight.x + 300, y: selectorRight.y + 25}, 0.5,{ease: FlxEase.cubeInOut});
				inSubState = true;
			}
	}
	function onSubStateClose()
	{
		inSubState = false;
		for(i in grpItems)
		{
			FlxTween.tween(i, {x: i.x - 300, y: i.y - 25}, 0.5,{ease: FlxEase.cubeInOut});
			FlxTween.tween(descriptionText, {y: descriptionText.y - 200},0.5, {ease: FlxEase.cubeInOut});
			FlxTween.tween(descBar, {y: 675}, 0.5,{ease: FlxEase.cubeInOut});
			FlxTween.tween(selectorLeft, {x: selectorLeft.x - 300, y: selectorLeft.y - 25}, 0.5,{ease: FlxEase.cubeInOut});
			FlxTween.tween(selectorRight, {x: selectorRight.x - 300, y: selectorRight.y - 25}, 0.5,{ease: FlxEase.cubeInOut});
		}
	}
	var c_twn:FlxTween;
	function changeSelection(change:Int = 0)
	{
		updateDescriptionText();
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
			item.alpha = 0;
			item.scale.x = 1;
			item.scale.y = 1;
			if(item.ID == curSelected)
			{
				if(c_twn != null)
					c_twn.cancel();
				item.scale.x = 1.2;
				item.scale.y = 1.2;
				c_twn = FlxTween.tween(item.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.sineOut});
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
				descriptionText.text = description[item.ID];
			}
		}
	}
	var d_twn:FlxTween;
	function updateDescriptionText()
	{
		if(d_twn != null)
			d_twn.cancel();
		descriptionText.y = 750;
		d_twn = FlxTween.tween(descriptionText, {y: 675}, 0.25, {ease: FlxEase.sineOut});
	}
}
