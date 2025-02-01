package states;

import mikolka.compatibility.ModsHelper;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.group.FlxGroup;
import flixel.graphics.FlxGraphic;

import objects.MenuItem;
import objects.MenuCharacter;

import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import substates.StickerSubState;

import backend.StageData;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	//var txtWeekTitle:FlxText; //poops
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var gumple:Int = -1; //poops

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	//var difficultySelectors:FlxGroup;
	//var sprDifficulty:FlxSprite; //poops
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var video_locked:FlxSprite;
	var noise:FlxSound;
	var album:FlxSprite; //poops

	var loadedWeeks:Array<WeekData> = [];

	var stickerSubState:StickerSubState;
	public function new(?stickers:StickerSubState = null)
	{
		super();
	  
		if (stickers != null)
		{
			stickerSubState = stickers;
		}
	}

	override function create()
	{
		Paths.clearUnusedMemory();

		if (stickerSubState != null)
			{
			  //this.persistentUpdate = true;
			  //this.persistentDraw = true;
		
			  openSubState(stickerSubState);
			  ModsHelper.clearStoredWithoutStickers();
			  stickerSubState.degenStickers();
			  FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		else Paths.clearStoredMemory();

		persistentUpdate = persistentDraw = true;
		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Drinking Gallons upon Gallons of Piss", null);
		#end

		final accept:String = controls.mobileC ? "A" : "ACCEPT";
		final reject:String = controls.mobileC ? "B" : "BACK";

		if(WeekData.weeksList.length < 1)
		{
			FlxTransitionableState.skipNextTransIn = true;
			persistentUpdate = false;
			MusicBeatState.switchState(new states.ErrorState("NO LEVELS ADDED FOR STORY MODE\n\nPress " + accept + " to go to the Week Editor Menu.\nPress " + reject + " to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		scoreText = new FlxText(10, FlxG.height - 50, 0, Language.getPhrase('week_score', 'LEVEL SCORE: {1}', [lerpScore]), 36);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32);

		/*txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;*/ //poops

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		bgSprite = new FlxSprite(0, 56);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		//add(grpWeekText); //poops (i just moved this to happen a bit later)

		//var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie); //poops

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks); //bonus

		var num:Int = 0;
		var itemTargetY:Float = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.ID = num;
				weekThing.targetY = itemTargetY;
				itemTargetY += Math.max(weekThing.height, 110) + 10;
				grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				// weekThing.updateHitbox();

				// Needs an offset thingie

				//var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				var lock:FlxSprite = new FlxSprite().loadGraphic(Paths.image('storymenu/newmenu/lock'));
				lock.x = weekThing.width/2 + weekThing.x - lock.width/2; //poops
				/*lock.antialiasing = ClientPrefs.data.antialiasing;
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');*/
				lock.ID = i;
				grpLocks.add(lock); //poops. this section used to be if(locked), but now everything has a lock and it just isn't visible if it's unlocked
				
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		/*difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(850, grpWeekText.members[0].y + 10);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);*/

		Difficulty.resetList();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		/*sprDifficulty = new FlxSprite(0, leftArrow.y);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);*/ //poops

		add(bgYellow);
		add(bgSprite);
		add(grpWeekCharacters);

		video_locked = new FlxSprite(0,0);
		video_locked.loadGraphic(Paths.image('storymenu/newmenu/static'),true,960,480);
		video_locked.animation.add("static", [1, 0, 5, 1, 4, 5, 3, 0, 1, 3, 2, 1, 5, 4, 0, 3, 5, 1, 0, 3, 1, 5, 2, 0, 4, 5, 2, 4, 3, 1, 4, 0, 5, 2, 4, 5, 0, 2, 3, 1, 5, 4, 3, 0, 4, 3, 1, 5, 2, 3], 18, true); //sorta randomized so it doesn't hurt people eyes too much
		video_locked.setGraphicSize(Std.int(FlxG.width - 100));
		video_locked.updateHitbox();
		video_locked.screenCenter();
		video_locked.animation.play("static");

		noise = FlxG.sound.load(Paths.sound("static"));
		noise.volume = 0;
		noise.looped = true;
		noise.play();

		var frameSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/newmenu/story_frame')); //poops
		frameSprite.setGraphicSize(Std.int(FlxG.width));
		frameSprite.updateHitbox();
		frameSprite.screenCenter();

		var trackBox:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/newmenu/tracks_box')); //poops
		trackBox.setGraphicSize(Std.int(FlxG.width));
		trackBox.updateHitbox();
		trackBox.screenCenter();

		var blockText:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/newmenu/omb_text')); //poops
		blockText.setGraphicSize(Std.int(FlxG.width));
		blockText.updateHitbox();
		blockText.screenCenter();

		var storyText:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/newmenu/storymode_text')); //poops
		storyText.setGraphicSize(Std.int(FlxG.width));
		storyText.updateHitbox();
		storyText.screenCenter();

		album = new FlxSprite(FlxG.width-320, FlxG.height-290); //poops
		album.loadGraphic(Paths.image('storymenu/newmenu/album_assets'),true,346,345);
		album.animation.add("bonus", [0], 0, false);
		album.animation.add("cuadra1", [1], 0, false);
		album.animation.add("colab", [2], 0, false);
		album.animation.add("locked", [3], 0, false);
		album.animation.play("locked");
		album.scale.set(0.8,0.8);
		album.updateHitbox();

		add(video_locked);
		add(frameSprite); //all poops
		add(trackBox);
		add(blockText);
		add(storyText);
		add(album);
		add(grpWeekText);
		add(grpLocks);

		/*var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07 + 100, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.data.antialiasing;
		tracksSprite.x -= tracksSprite.width/2;
		add(tracksSprite);*/ //poops

		var tracksSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/newmenu/tracks'));
		tracksSprite.setGraphicSize(Std.int(FlxG.width));
		tracksSprite.updateHitbox();
		tracksSprite.screenCenter();
		tracksSprite.antialiasing = ClientPrefs.data.antialiasing;
		add(tracksSprite); //poops

		//txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
		txtTracklist = new FlxText(0, FlxG.height * 0.73, 0, "", 20); //poops
		txtTracklist.alignment = CENTER;
		txtTracklist.font = Paths.font("vcr.ttf");
		//txtTracklist.color = 0xFFe55777;
		txtTracklist.color = FlxColor.WHITE; //poops
		add(txtTracklist);
		add(scoreText);
		//add(txtWeekTitle); //poops

		changeWeek();
		changeDifficulty();

		addTouchPad('LEFT_FULL', 'A_B_X_Y');

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
		removeTouchPad();
		addTouchPad('LEFT_FULL', 'A_B_X_Y');
	}

	override function update(elapsed:Float)
	{
		if(WeekData.weeksList.length < 1)
		{
			if (controls.BACK && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				MusicBeatState.switchState(new MainMenuState());
			}
			super.update(elapsed);
			return;
		}

		// scoreText.setFormat(Paths.font("vcr.ttf"), 32);
		if(intendedScore != lerpScore)
		{
			lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 30)));
			if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
	
			scoreText.text = Language.getPhrase('week_score', 'LEVEL SCORE: {1}', [lerpScore]);
		}

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			var changeDiff = false;
			if (controls.UI_UP_P)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeDiff = true;
			}

			if (controls.UI_DOWN_P)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeDiff = true;
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}

			/*if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');*/ //poops

			if (controls.UI_RIGHT_P)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P)
				changeDifficulty(-1);
			else if (changeDiff)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL || touchPad.buttonX.justPressed)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
				removeTouchPad();
			}
			else if(controls.RESET || touchPad.buttonY.justPressed)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				removeTouchPad();
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
		
		var offY:Float = grpWeekText.members[curWeek].targetY;
		for (num => item in grpWeekText.members){
			//item.y = FlxMath.lerp(item.targetY - offY + 480, item.y, Math.exp(-elapsed * 10.2));
			if(num - curWeek == 0)
				item.y = FlxMath.lerp(item.targetY - offY + 510, item.y, Math.exp(-elapsed * 10.2));
			else if ((-gumple * (num - curWeek) + loadedWeeks.length) % loadedWeeks.length == 1)
				item.y = grpWeekText.members[curWeek].y - gumple * (item.height+20);
			else if ((gumple * (num - curWeek) + loadedWeeks.length) % loadedWeeks.length == 1)
				item.y = grpWeekText.members[curWeek].targetY - offY + 510 + gumple * (item.height+20); // poops. 

		}

		for (num => lock in grpLocks.members)
			lock.y = grpWeekText.members[lock.ID].y + grpWeekText.members[lock.ID].height/2 - lock.height/2;

		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
			video_locked.alpha = FlxMath.lerp(0, video_locked.alpha, Math.exp(-elapsed * 10.2));

		noise.volume = FlxMath.lerp(video_locked.alpha, noise.volume, Math.exp(-elapsed * 10.2));
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			try
			{
				PlayState.storyPlaylist = songArray;
				PlayState.isStoryMode = true;
				//PlayState.storyDifficultyColor = sprDifficulty.color; //poops?
				//PlayState.storyCampaignTitle = txtWeekTitle.text;
				if(PlayState.storyCampaignTitle == "") PlayState.storyCampaignTitle = "Unnamed week";
				selectedWeek = true;
	
				var diffic = Difficulty.getFilePath(curDifficulty);
				if(diffic == null) diffic = '';
	
				PlayState.storyDifficulty = curDifficulty;
	
				Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			}
			catch(e:Dynamic)
			{
				trace('ERROR! $e');
				return;
			}
			
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].isFlashing = true;
				for (char in grpWeekCharacters.members)
				{
					if (char.character != '' && char.hasConfirmAnimation)
					{
						char.animation.play('confirm');
					}
				}
				stopspamming = true;
			}

			var directory = StageData.forceNextDirectory;
			LoadingState.loadNextDirectory();
			StageData.forceNextDirectory = directory;

			LoadingState.prepareToSong();
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				#if !SHOW_LOADING_SCREEN FlxG.sound.music.stop(); #end
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
			
			#if (MODS_ALLOWED && DISCORD_ALLOWED)
			DiscordClient.loadModRPC();
			#end
		}
		else FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = Difficulty.getString(curDifficulty, false);
		//var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff)); //poops the one below this wasn't me
		//trace(Mods.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		/*if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x + 60;
			sprDifficulty.x += (308 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - sprDifficulty.height + 50;

			FlxTween.cancelTweensOf(sprDifficulty);
			FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 30, alpha: 1}, 0.07);
		}*/ //poops
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 49324858;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (change != 0)
		{
			gumple = change;
			video_locked.alpha = 1;
		}

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = Language.getPhrase('storyname_${leWeek.fileName}', leWeek.storyName);
		//txtWeekTitle.text = leName.toUpperCase();
		//txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10); //poops

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (num => item in grpWeekText.members)
		{
			/*item.alpha = 0.6;
			if (num - curWeek == 0 && unlocked)
				item.alpha = 1;*/
			if (num - curWeek == 0 || (-change * (num - curWeek) + loadedWeeks.length) % loadedWeeks.length == 1) { //poops. cancels tween of previously and currently selected week
				FlxTween.cancelTweensOf(item);
				FlxTween.cancelTweensOf(grpLocks.members[item.ID]);
			}

			if (num - curWeek == 0 && unlocked)
				FlxTween.tween(item, {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
			else if (num - curWeek == 0 && !unlocked) {
				FlxTween.tween(item, {alpha: 0.6}, 0.1, {ease: FlxEase.quadOut});
				FlxTween.tween(grpLocks.members[item.ID], {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
			}
			else {
				FlxTween.tween(item, {alpha: 0}, 0.1, {ease: FlxEase.quadOut}); //poops
				FlxTween.tween(grpLocks.members[item.ID], {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
			}
		}

		if (unlocked)
			album.animation.play(leWeek.fileName);
		else
			album.animation.play("locked");

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		Difficulty.loadFromWeek();
		//difficultySelectors.visible = unlocked; //poops

		if(Difficulty.list.contains(Difficulty.getDefault()))
			curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
		else
			curDifficulty = 0;

		var newPos:Int = Difficulty.list.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		//txtTracklist.x -= FlxG.width * 0.35;
		txtTracklist.x -= FlxG.width * 0.325; //poops

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}
