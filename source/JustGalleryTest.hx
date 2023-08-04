package;

import flixel.*;
import flixel.FlxSprite;
import flixel.text.FlxText;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import sys.FileSystem;
import flixel.addons.ui.FlxInputText;

class JustGalleryTest extends MusicBeatState
{
    var backgroundSprite:FlxSprite;
    var images:Array<ImageInfo>;
    var currentIndex:Int = 0;
    var imageSprite:FlxSprite;
    var shittyText:FlxTypeText;
    var shittyTitle:FlxText;
    var yOffset:Float = 20;
    var bgSprite:FlxSprite;

    override public function create():Void
    {
        backgroundSprite = new FlxSprite(10, 50).loadGraphic(Paths.image("handy"));
        backgroundSprite.setGraphicSize(Std.int(backgroundSprite.width * 1));
        backgroundSprite.screenCenter();
        add(backgroundSprite);

        images = [
            new ImageInfo("gallery/hc1", "Sonichu", "Pikachu Sonic Shit"),
            new ImageInfo("gallery/hc2", "EydoooGaming", "How tf? \n Made by Bitto")
        ];

        imageSprite = new FlxSprite(FlxG.width / 2 - 340, FlxG.height / 2 - 180 - 30).loadGraphic(Paths.image(images[currentIndex].path));
        imageSprite.scale.x = 0.5;
        imageSprite.scale.y = 0.5;
        imageSprite.setGraphicSize(928, 578);
        imageSprite.screenCenter();
        imageSprite.y -= 50.5;
        imageSprite.x -= 2;
        add(imageSprite);

        shittyText = new FlxTypeText(50, FlxG.height - 100, FlxG.width - 100, images[currentIndex].description);
        shittyText.setFormat(Paths.font("sonic2.ttf"), 32, 0x000000, "left"); // Set color to black
        add(shittyText);

        shittyTitle = new FlxText(50, 50, FlxG.width - 100, images[currentIndex].title);
        shittyTitle.setFormat(Paths.font("nise.TTF"), 32, 0xFFFFFF, "left"); // Set color to black
        shittyTitle.x += 50; // Slide the title a little to the right
        add(shittyTitle);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var yOffset:Float = (FlxG.height - imageSprite.height * imageSprite.scale.y) / 4;

        if (FlxG.keys.justPressed.LEFT)
        {
            currentIndex--;
            if (currentIndex < 0)
            {
                currentIndex = images.length - 1;
            }
        }
        else if (FlxG.keys.justPressed.RIGHT)
        {
            currentIndex++;
            if (currentIndex >= images.length)
            {
                currentIndex = 0;
            }
        }

        remove(imageSprite);
        imageSprite = new FlxSprite(FlxG.width / 2 - 340, FlxG.height / 2 - 180 - 30).loadGraphic(Paths.image(images[currentIndex].path));
        imageSprite.setGraphicSize(522, 326);
        imageSprite.screenCenter();
        imageSprite.y -= 50.5;
        imageSprite.x -= 2;
        add(imageSprite);
        shittyText.text = images[currentIndex].description;
        shittyTitle.text = images[currentIndex].title;

        var titleOffsetX:Float = 155;
        var titleOffsetY:Float = -25; 
        shittyTitle.x = 50 + titleOffsetX;
        shittyTitle.y = 50 + titleOffsetY; 

        var descriptionOffsetX:Float = -20;
        var descriptionOffsetY:Float = -100;
        shittyText.x = 50 + descriptionOffsetX;
        shittyText.y = FlxG.height - shittyText.height + descriptionOffsetY;

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
    }
}

class ImageInfo
{
    public var path:String;
    public var title:String;
    public var description:String;

    public function new(path:String, title:String, description:String)
    {
        this.path = path;
        this.title = title;
        this.description = description;
    }
}
