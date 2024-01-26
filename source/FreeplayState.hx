package;

import flixel.tweens.FlxEase;
import flixel.FlxState;
import PortrairFreeplay.PortrairFreeplayText;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;

	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<PortrairFreeplay>;
	private var grpSongsText:FlxTypedGroup<PortrairFreeplayText>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var arrow:FlxSprite;
	var redSpines:FlxBackdrop;
	var textSong:Array<Float> = [];

	var rankSprite:RankMechanic;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), song[3]);
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('Freeplay/Sonic_bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		FlxG.sound.playMusic(Paths.music("freeplayMenu"));

		// var blockbar:FlxSprite = new FlxSprite(bar.x + 100).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		// blockbar.x = (FlxG.width/2)+100;
		// // blockbar.screenCenter(X);
		// add(blockbar);

		grpSongs = new FlxTypedGroup<PortrairFreeplay>();
		add(grpSongs);

		redSpines = new FlxBackdrop(Paths.image('Freeplay/red_spines'),Y);
		redSpines.velocity.y = 40;
		add(redSpines);
		redSpines.x = FlxG.width;

		var xArrow = 10;
		arrow = new FlxSprite().loadGraphic(Paths.image('Freeplay/Arrow'));
		arrow.screenCenter();
		arrow.y += 170 - xArrow;
		arrow.setGraphicSize(Std.int(arrow.width * 0.8));
		arrow.updateHitbox();
		add(arrow);

		FlxTween.tween(arrow, {y: arrow.y + xArrow}, 1,{type: PINGPONG});

		rankSprite = new RankMechanic(950,300,0.05);
		rankSprite.updateHitbox();
		rankSprite.alpha = 0;
		add(rankSprite);

		var bar:FlxBackdrop = new FlxBackdrop(Paths.image('Freeplay/Black_bar'),X);
		// bar.screenCenter(X);
		bar.y = (FlxG.height - bar.height);
		bar.velocity.x = 40;
		// bar.angle = 180+90;
		// // bar.flipX = true;
		add(bar);

		grpSongsText = new FlxTypedGroup<PortrairFreeplayText>();
		add(grpSongsText);

		for (i in 0...songs.length)
		{
			var songPortairt:PortrairFreeplay = new PortrairFreeplay(0, 0, songs[i].songName);
				songPortairt.lerpMenu = true;
				songPortairt.targetY = i - curSelected;
				songPortairt.startPosition.y = ((FlxG.height - songPortairt.height)/2)-80;
				grpSongs.add(songPortairt);
	
				songPortairt.snapToPosition();
	
			var songText:PortrairFreeplayText = new PortrairFreeplayText(-2030, 625, songs[i].songName, 60);
				songText.lerpMenu = true;
				songText.targetY = i - curSelected;
				grpSongsText.add(songText);

				textSong = [songText.x,songText.y];
	
				songText.snapToPosition();
	
			Paths.currentModDirectory = songs[i].folder;
		}

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText((FlxG.width * 0.6)+80, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), grpSongsText.members[0].size - 10, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.borderSize += 1.2;
		scoreText.alpha = 0;

		diffText = new FlxText(FlxG.width, 0, 0, "", 32);
		diffText.setFormat(Paths.font("vcr.ttf"), grpSongsText.members[0].size - 10, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.borderSize += 1.2;
		diffText.alpha = 0;

		add(diffText);

		add(scoreText);
		if(curSelected >= songs.length) curSelected = 0;
		// bg.color = songs[curSelected].color;
		// intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		// changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, songCreator:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, songCreator));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	var holdSem:Bool = true;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'SCORE: \n' + lerpScore + '\n' + '(' + ratingSplit.join('.') + '%)' + '\n\nRANK:';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;
		if (noShowRankButton){
		if(songs.length > 1 && arrowPress)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					// changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				// changeDiff();
			}
		}

		// if (controls.UI_LEFT_P)
		// 	changeDiff(-1);
		// else if (controls.UI_RIGHT_P)
		// 	changeDiff(1);
		// else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			holdSem = !holdSem;
			noShowRankButton = false;
			if (!holdSem){
				persistentUpdate = false;
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.playMusic(Paths.music("freakyMenu"));
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			} else showRank(false);
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			holdSem = !holdSem;
			noShowRankButton = false;
			if (holdSem){
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
				var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
				/*#if MODS_ALLOWED
				if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
				#else
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				#end
					poop = songLowercase;
					curDifficulty = 1;
					trace('Couldnt find file');
				}*/
				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if(colorTween != null) {
					colorTween.cancel();
				}
				
				if (FlxG.keys.pressed.SHIFT){
					LoadingState.loadAndSwitchState(new ChartingState());
				}else{
					LoadingState.loadAndSwitchState(new PlayState());
				}

				FlxG.sound.music.volume = 0;
						
				destroyFreeplayVocals();
			} else showRank(true);
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	var noShowRankButton:Bool = true;
	var arrowPress:Bool = true;

	var scoreTween:Array<FlxTween> = [null,null];
	private function showRank(acceptButton:Bool) {
		// diffText
		var timeTween:Float = 0.5;
		var spaceDiff:Int = 90;

		for (i in 0...scoreTween.length) if (scoreTween[i] != null) scoreTween[i].cancel();
			
		
		if (acceptButton){
			// grpSongsText.members[curSelected].setPosition(850,50);

			// FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			arrowPress = false;
			grpSongsText.members[curSelected].changeX = false;
			FlxTween.tween(grpSongsText.members[curSelected], {x:850 , y: 50}, timeTween,{ease: FlxEase.circInOut,onComplete: function(t:FlxTween) {
				noShowRankButton = true;
				diffText.setPosition(grpSongsText.members[curSelected].x,grpSongsText.members[curSelected].y);

				diffText.text = "BY: " + songs[curSelected].songBy;

				FlxTween.tween(diffText,  {alpha: 1 ,y: diffText.height + spaceDiff}, timeTween, {ease: FlxEase.circOut});
				scoreTween[0] = FlxTween.tween(scoreText, {alpha: 1 ,y: (diffText.height + spaceDiff)+100}, timeTween, {ease:FlxEase.circOut,startDelay:timeTween-0.3, onComplete: function(t:FlxTween){
					#if !switch 
					intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
					intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty); #end
				}});

				var rankScore:String = Highscore.getRank(songs[curSelected].songName, curDifficulty);
				if (rankScore == null) rankScore = 'Null';
				rankSprite.changeRank(rankScore);
				rankSprite.angle = 90;
				scoreTween[1] = FlxTween.tween(rankSprite, {alpha:1, angle: 0}, timeTween, {ease:FlxEase.circOut,startDelay:timeTween});
			}});
			FlxTween.tween(arrow, {alpha:0}, timeTween - 0.2);




			//scoreText

			FlxTween.tween(redSpines, {x:FlxG.width - redSpines.width}, timeTween,{ease: FlxEase.circOut});
			for (group in grpSongs.members){ group.changeX = false;
				FlxTween.tween(group, {x: group.x - 300}, timeTween, {ease: FlxEase.backInOut});
			}
		} else 
		{
			// grpSongsText.members[curSelected].centerOrigin();textSong
			spaceDiff = 20;
			FlxTween.tween(diffText, {alpha: 0, y: diffText.height - spaceDiff}, timeTween, {ease: FlxEase.circOut});
			FlxTween.tween(scoreText, {alpha: 0, y: (diffText.height - spaceDiff)-120}, timeTween, {ease: FlxEase.circOut});
			FlxTween.tween(rankSprite, {alpha:0,angle: 90},timeTween-0.25,{ease: FlxEase.circOut});

			#if !switch
				intendedScore = 0;
				intendedRating = 0.00;
			#end

			FlxTween.tween(grpSongsText.members[curSelected], {x:textSong[0] , y: textSong[1]}, timeTween,{ease: FlxEase.circInOut,onComplete: function(t:FlxTween){
				grpSongsText.members[curSelected].changeX = noShowRankButton = true;
			}});

			arrowPress = true;
			FlxTween.tween(arrow, {alpha:1}, timeTween - 0.2);
			FlxTween.tween(redSpines, {x:FlxG.width}, timeTween,{ease: FlxEase.circIn});
			for (group in grpSongs.members) FlxTween.tween(group,{x:(FlxG.width - group.width) / 2},timeTween,{ease: FlxEase.backInOut,onComplete:function(t:FlxTween){group.changeX = true;}});
		}
		
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		// if(newColor != intendedColor) {
		// 	if(colorTween != null) {
		// 		colorTween.cancel();
		// 	}
		// 	intendedColor = newColor;
		// 	colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
		// 		onComplete: function(twn:FlxTween) {
		// 			colorTween = null;
		// 		}
		// 	});
		// }

		trace(Highscore.getRank(songs[curSelected].songName, curDifficulty));

		// selector.y = (70 * curSelected) + 30;

		diffText.text = songs[curSelected].songName;
		diffText.updateHitbox();

		var bullShit:Int = 0;

		for (i in 0...grpSongsText.members.length)
		{
			grpSongsText.members[i].alpha = 0.6;
		}

		grpSongsText.members[curSelected].alpha = 1;

		// var arrayGroup = [FlxTypedGroup<>];


		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.6;

			if (item.targetY == 0) item.alpha = 1;
		}

		for (item in grpSongsText.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			// item.alpha = 0.6;
	
			// if (item.targetY == 0) item.alpha = 1;
		}

		trace("bullShit: " + bullShit + " targetY: " + grpSongs.members[curSelected].targetY);

		// groupFunc(grpSongs);
		// grpSongs(grpSongsText);
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		// scoreText.x = FlxG.width - scoreText.width - 6;

		// scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		// scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		// diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		// diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var songBy:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int, songBy:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.songBy = songBy;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
		if(this.songBy == null) this.songBy = 'NO CREATOR';
	}
}