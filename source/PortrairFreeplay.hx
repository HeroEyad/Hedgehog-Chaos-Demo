package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;

using StringTools;

class PortrairFreeplay extends FlxSprite
{
    
    private var boxName:String = "placeholder";

    public var lerpMenu:Bool = false;
    public var changeY:Bool = true;

    public var changeX:Bool = true;

    public var targetY:Int = 0;

    public var distancePerItem:FlxPoint = new FlxPoint(20, 500);
    public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations

    public function new(x:Float,y:Float,portairName:String = "placeholder", ?text:Bool = false, ?sizeText:Int = 32)
    {
        
        super(x,y);
        this.startPosition.x = x;
        this.startPosition.y = y;
        createPortair(portairName, text);
    }

    private function createPortair(name:String, ?text:Bool = false) {
        var scl = 0.2;

        var sprString:String = name.toLowerCase().replace(" ","_");

        switch(sprString){
            case 'huh_neat' | 'really_3d':
                scl -= 0.05;
        }

        if(!Paths.fileExists('images/Freeplay/portrair/' + sprString + '.png', IMAGE)) sprString = "placeholder";

        loadGraphic(Paths.image('Freeplay/portrair/' + sprString));
        setGraphicSize(Std.int(width * scl),Std.int(height * scl));
        updateHitbox();
    }

	override function update(elapsed:Float)
        {
            if (lerpMenu)
            {
                var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
                if(changeY) 
                    y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);
                if(changeX) 
                    screenCenter(X);
            }
            super.update(elapsed);      
        }
    public function snapToPosition()
    {
        if (lerpMenu)
        {
            if(changeY) 
               y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
            if(changeX) 
                screenCenter(X);
         }
        
    }
}

class PortrairFreeplayText extends FlxText {
    public var lerpMenu:Bool = false;
    public var changeY:Bool = false;

    public var changeX:Bool = true;

    public var targetY:Int = 0;

    public var distancePerItem:FlxPoint = new FlxPoint(500, 0);
    public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations

    public function new(x:Float,y:Float, textName:String = "NO-SONG", size:Int){
        super(x,y);

        this.text = textName;
        this.startPosition.x = x;
        this.startPosition.y = y;

        autoSize = true;
        // fieldWidth = FlxG.width/2-150;
		setFormat(Paths.font("sonikku-plus.ttf"), size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        borderSize += 1.2;
    }

    override function update(elapsed:Float)
    {
        if (lerpMenu)
        {
            var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
            if(changeY) y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);

            if(changeX) 
                x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);
        }
        super.update(elapsed);      
    }

    public function snapToPosition()
    {
        if (lerpMenu)
        {
            if(changeY) y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;

            if(changeX) 
				x = (targetY * distancePerItem.x) + startPosition.x;
        }   
    }
}