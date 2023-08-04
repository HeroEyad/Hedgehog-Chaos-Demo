package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flash.text.TextField;
import flixel.util.FlxColor;

class GalleryState extends MusicBeatState
{
	var bg:FlxSprite;
	var box:FlxSprite;
	var image:FlxSprite;
	var charText:FlxText;
	var songText:FlxText;

	var curSelected:Int = 0;
	var max:Int = 3;
	var min:Int = 0;
	var diffi:Int = 2;
	var options:Array<String> = ['art', 'scrapped stuff', 'fan art', 'bios'];
    var hcbgg:HCBGG;
	override function create()
	{
        var hcbgg = new HCBGG();
        add(hcbgg);

		bg = new FlxSprite().loadGraphic(Paths.image("title/Yellow"));
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;

		var spike = new FlxSprite().loadGraphic(Paths.image("title/Blue"));
		spike.screenCenter(Y);
        spike.x = -300;
		spike.antialiasing = FlxG.save.data.antialiasing;
		add(spike);

		image = new FlxSprite().loadGraphic(Paths.image("freeplay-encore/freeplay/bopeebo"));
		image.setGraphicSize(Std.int(image.width * 0.5));
		image.screenCenter(Y);
		image.x = -300;
		image.antialiasing = FlxG.save.data.antialiasing;
		add(image);

		box = new FlxSprite().loadGraphic(Paths.image("title/Border"));
		box.screenCenter(Y);
        box.scale.x = 0.5;
        box.scale.y = 0.5;
		box.x = 600;
		box.antialiasing = FlxG.save.data.antialiasing;
		add(box);

		songText = new FlxText(30 , 10, FlxG.width, options[curSelected]);
		songText.setFormat(Paths.font("NiseSegaSonic.TTF"), 50, FlxColor.BLUE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.YELLOW);
		songText.screenCenter(Y);
		songText.x = -300;
		add(songText);

		super.create();
	}

	override function update(elapsed:Float)
	{
		songText.text = options[curSelected];
		if (controls.BACK)
			MusicBeatState.switchState(new MainMenuState());
		if (controls.ACCEPT)
			doshit();
		if (controls.UI_RIGHT_P)
			if (curSelected >= max) {
				curSelected = min;
			 }
			 else {
				curSelected = curSelected + 1;
			}
		if (controls.UI_LEFT_P)
			if (curSelected <= min) {
				curSelected = max;
			 }
			 else {
				curSelected = curSelected - 1;
			}
		if (controls.ACCEPT)
			doshit();
		super.update(elapsed);
	}

	function doshit()
	{
        if (curSelected == 0){
            MusicBeatState.switchState(new JustGalleryTest());
        }
	}
}