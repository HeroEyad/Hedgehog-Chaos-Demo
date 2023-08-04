package;

import flixel.addons.display.FlxBackdrop;
// credits to HeroEyad and GamerPablito
class HCBG extends FlxBackdrop
{
	public function new()
	{
		super(Paths.image('blueshit') #if (flixel < "5.0.0"), 0, 0, true, false #end);
		scrollFactor.set(0, 0.8);
		velocity.x = 50;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
