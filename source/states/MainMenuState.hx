package states;

import mikolka.compatibility.ModsHelper;
import mikolka.vslice.freeplay.FreeplayState;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0'; // This is also used for Discord RPC
	public static var pSliceVersion:String = '2.0.1'; 
	public static var funkinVersion:String = '0.5.1'; // Version of funkin' we are emulationg
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var standeez:FlxTypedGroup<FlxSprite>;
	var poopY:Array<Float> = [];
	var bg:FlxSprite;
	var bgTween:FlxTween = null;
	var gearTween:FlxTween = null;
	var standeeTweenIn:FlxTween = null;
	var standeeTweenOut:FlxTween = null;

	var optionShit:Array<String> = [
		'story',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	public function new(isDisplayingRank:Bool = false) {

		//TODO
		super();
	}
	override function create()
	{
		Paths.clearUnusedMemory();
		ModsHelper.clearStoredWithoutStickers();
		
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end


		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 0.45));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var omb:FlxSprite = new FlxSprite(390,100).loadGraphic(Paths.image('mainmenu/menuLogo'));
		omb.antialiasing = ClientPrefs.data.antialiasing;
		omb.setGraphicSize(Std.int(omb.width * 0.3));
		omb.updateHitbox();
		omb.screenCenter(Y);
		add(omb);

		standeez = new FlxTypedGroup<FlxSprite>();
		add(standeez);

		for (i in 0...optionShit.length)
		{
			var standee:FlxSprite = new FlxSprite(500, 0).loadGraphic(Paths.image('mainmenu/standee_' + optionShit[i]));
			standee.antialiasing = ClientPrefs.data.antialiasing;
			standee.alpha = 0;
			standee.updateHitbox();
			standee.screenCenter(Y);
			poopY.push(standee.y);
			standee.y += 100;
			if (i == 2){
				standee.scale.set(0.5,0.5);
				standee.x -= 200;
			}
			standeez.add(standee); //poops
		}

		var bgL:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menuLeft'));
		bgL.antialiasing = ClientPrefs.data.antialiasing;
		bgL.setGraphicSize(Std.int(bgL.width * 0.39));
		bgL.updateHitbox();
		bgL.screenCenter();
		add(bgL);

		var bgR:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menuRight'));
		bgR.antialiasing = ClientPrefs.data.antialiasing;
		bgR.setGraphicSize(Std.int(bgR.width * 0.39));
		bgR.updateHitbox();
		bgR.screenCenter();
		add(bgR);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-50, -40);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.setGraphicSize(Std.int(menuItem.width*0.45));
			menuItem.updateHitbox();
		}

		var psychVer:FlxText = new FlxText(0, FlxG.height - 18, FlxG.width, "Psych Engine " + psychEngineVersion, 12);
		var fnfVer:FlxText = new FlxText(0, FlxG.height - 18, FlxG.width, 'v${funkinVersion} (P-slice ${pSliceVersion})', 12);

		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		psychVer.scrollFactor.set();
		fnfVer.scrollFactor.set();
		add(psychVer);
		add(fnfVer);
		//var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' ", 12);
	
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		addTouchPad('LEFT_FULL', 'A_B_E');

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			//if (FreeplayState.vocals != null)
				//FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.UI_LEFT_P || controls.UI_RIGHT_P){
				if (curSelected == 3){
					changeItem(-1);
				}
				else {
					changeItem(3 - curSelected);
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				
				
				selectedSomethin = true;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					switch (optionShit[curSelected])
					{
						case 'story':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':{
							persistentDraw = true;
							persistentUpdate = false;
							// Freeplay has its own custom transition
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;

							openSubState(new FreeplayState());
							subStateOpened.addOnce(state -> {
								for (i in 0...menuItems.members.length) {
									menuItems.members[i].revive();
									menuItems.members[i].alpha = 1;
									menuItems.members[i].visible = true;
									selectedSomethin = false;
								}
								changeItem(0);
							});
							
						}

						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				
			}
			if (touchPad.buttonE.justPressed || controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();

		standeeTweenOut = FlxTween.tween(standeez.members[curSelected], {alpha: 0,y:poopY[curSelected]+100}, 0.4, {ease: FlxEase.quadOut});

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();

		FlxTween.cancelTweensOf(standeez.members[curSelected]);

		if (bgTween != null) 
			bgTween.cancel();
		if (gearTween != null)
			gearTween.cancel();
		if (standeeTweenIn != null)
			standeeTweenIn.cancel();

		standeeTweenIn = FlxTween.tween(standeez.members[curSelected], {alpha: 1, y:poopY[curSelected]}, 0.4, {ease: FlxEase.quadOut});

		if (curSelected == 3) {
			gearTween = FlxTween.tween(menuItems.members[3], {angle: 90}, 0.4, {ease: FlxEase.quadOut});
		} else {
			gearTween = FlxTween.tween(menuItems.members[3], {angle: 0}, 0.4, {ease: FlxEase.quadOut});
		}
	}
}
