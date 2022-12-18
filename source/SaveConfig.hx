package;
import flixel.FlxG;
import Controls.Control;
import flixel.input.keyboard.FlxKey;

class SaveConfig
{
    public static var playerKeybinds:Array<FlxKey> = [A,S,W,D];
    public static var keysLoaded:Bool = false;

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
}