package;
import flixel.FlxG;
import Controls.Control;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

class SaveConfig
{
    


    //Config Vars

    //Keybind functionality
    public static var playerKeybinds:Array<FlxKey> = [A,S,W,D];
    public static var keysLoaded:Bool = false;

    //Gameplay settings
    public static var Antialiasing:Bool;
    public static var FPS:Int;



    public static function setKeybinds(key:Int,control:Control,keyPostiion:Int)
    {
        PlayerSettings.player1.controls.replaceBinding(control, Keys, key,playerKeybinds[keyPostiion]);
        playerKeybinds[keyPostiion] = key;
        trace('[ operation successful ]' +' ' + control + ' is now binded to ' + key);
        trace('keybinds are now [ ' + playerKeybinds + ' ]');
    }
    public static function saveKeybinds()
    {
        FlxG.save.data.keybinds = playerKeybinds;
    }
    public static function loadKeybinds()
    {
        if(FlxG.save.data.keybinds != null)
        {
            playerKeybinds =  FlxG.save.data.keybinds;
            setKeybinds(playerKeybinds[0], Control.UP,0);
            setKeybinds(playerKeybinds[1], Control.LEFT,1);
            setKeybinds(playerKeybinds[2], Control.DOWN,2);
            setKeybinds(playerKeybinds[3], Control.RIGHT,3);
            trace('keybinds succesfully loaded' + 'keys are now ' +'[ ' + playerKeybinds + ' ]');
        }
        else
        {
            trace('Keybinds not loaded, Either non-exitstant(meaning default ones) or Internal error');
        }
    }
    public static function savePreferences()
    {
        var getShit = "[Keybinds]";
        for (i in playerKeybinds)
        {
            getShit += i + ", ";
        }
        getShit = getShit + "\n" + "[AA] - " + Antialiasing + "\n" + "[FPS] - " + FPS;
        
        FlxG.log.add(getShit);
        //File.saveContent('assets/config/playerControls.json', getShit);
		var save:FlxSave = new FlxSave();
		save.bind('binds', 'StrPointless');
		save.data.keys = playerKeybinds;
        trace(save.data.keys);
		save.flush();
		FlxG.log.add("binds Saved");
    }
    public static function loadPreferences()
    {
        var save:FlxSave = new FlxSave();
		save.bind('binds', 'StrPointless');
        FlxG.log.add("Keys recieved " + save.data.keys);
        playerKeybinds = save.data.keys;
    }
    public static function getKeybindsFromPrefs(keys:Array<FlxKey>)
    {
        //trace(keys);
        playerKeybinds = keys;
        setKeybinds(keys[0], Control.UP,0);
        setKeybinds(keys[1], Control.LEFT,1);
        setKeybinds(keys[2], Control.DOWN,2);
        setKeybinds(keys[3], Control.RIGHT,3);
    }
}