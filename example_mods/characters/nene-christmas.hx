import states.stages.objects.ABotSpeaker;
import backend.ClientPrefs;
import flixel.FlxG;

var abot:ABotSpeaker;

function onCreate()
{
}

function onCreatePost()
{
    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;

    var curLevel = Paths.currentLevel;

    Paths.setCurrentLevel('weekend1');

    game.gfGroup.y -= 200;
    abot = new ABotSpeaker(game.gfGroup.x - 50, game.gfGroup.y + 550 - 30);
    abot.antialiasing = ClientPrefs.data.antialiasing;
    for (i in [abot.bg, abot.eyeBg, abot.eyes, abot.speaker]) {
        if (i == abot.bg) continue;
        i.shader = game.gf.shader;
    }
    for (i in abot.vizSprites) i.shader = game.gf.shader;
    Paths.setCurrentLevel(curLevel);

    updateABotEye("dad", "true");
    game.addBehindGF(abot);
    game.setOnScripts("abot", abot);

game.gf.scrollFactor.x = 1;
game.gf.scrollFactor.y = 1;
}

	var refershedLol:Bool = false;
	var VULTURE_THRESHOLD = 0.25 * 2;
	var STATE_DEFAULT = 0;
	var STATE_PRE_RAISE = 1;
	var STATE_RAISE = 2;
	var STATE_READY = 3;
	var STATE_LOWER = 4;
	var currentState:Int = STATE_DEFAULT;
	var MIN_BLINK_DELAY:Int = 3;
	var MAX_BLINK_DELAY:Int = 7;
	var blinkCountdown:Int = MIN_BLINK_DELAY;

function onUpdatePost(e)
{
    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;

		if (shouldTransitionState()) {
			transitionState();
		}

if (PlayState.instance.gf.animation.curAnim.finished)
{
onAnimationFinished(PlayState.instance.gf.animation.curAnim.name);
}

if (PlayState.instance.gf.animation.curAnim != null)
{
onAnimationFrame(PlayState.instance.gf.animation.curAnim.name,PlayState.instance.gf.animation.curAnim.curFrame,PlayState.instance.gf.animation.curAnim.frameIndex);
}

if(abot != null)
{
    abot.alpha = game.gf.alpha;
    for (i in [abot.bg, abot.eyeBg, abot.eyes, abot.speaker]) {
        if (i == abot.bg) continue;
        i.color = game.gf.color;
    }
}
}

function onSongStart() {
    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;
    abot.snd = FlxG.sound.music;
}

function onMoveCamera(who) {
    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;
    updateABotEye(who, "false");
}

function updateABotEye(who:String = "dad", finishInstantly:String = "false")
{
if(abot == null) return;

    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;
    
    if (who == "dad") abot.lookLeft(); else abot.lookRight();

    if (finishInstantly == "true") abot.eyes.anim.curFrame = abot.eyes.anim.length - 1;
}

	function shouldTransitionState():Bool {
		return PlayState.instance.boyfriend.curCharacter != "pico-blazin";
	}

	var animationFinished:Bool = false;

	function onAnimationFinished(name:String) {
		switch(currentState) {
			case STATE_RAISE:
				if (name == "raiseKnife") {
					animationFinished = true;
					transitionState();
				}
			case STATE_LOWER:
				if (name == "lowerKnife") {
					animationFinished = true;
					transitionState();
				}
			default:
		}
	}

	function onAnimationFrame(name:String, frameNumber:Int, frameIndex:Int) {
		switch(currentState) {
			case STATE_PRE_RAISE:
				if (name == "danceLeft" && frameNumber == 14) {
					animationFinished = true;
					transitionState();
				}
			default:
		}
	}

	function transitionState() {
		switch (currentState) {
			case STATE_DEFAULT:
				if (PlayState.instance.health <= VULTURE_THRESHOLD) {
					currentState = STATE_PRE_RAISE;
				} else {
					currentState = STATE_DEFAULT;
				}
			case STATE_PRE_RAISE:
				if (PlayState.instance.health > VULTURE_THRESHOLD) {
					currentState = STATE_DEFAULT;
				} else if (animationFinished) {
					currentState = STATE_RAISE;
					PlayState.instance.gf.playAnim('raiseKnife');
					animationFinished = false;
				}
			case STATE_RAISE:
				if (animationFinished) {
					currentState = STATE_READY;
					animationFinished = false;
				}
			case STATE_READY:
				if (PlayState.instance.health > VULTURE_THRESHOLD) {
					currentState = STATE_LOWER;
					PlayState.instance.gf.playAnim('lowerKnife');
				}
			case STATE_LOWER:
				if (animationFinished) {
					currentState = STATE_DEFAULT;
					animationFinished = false;
				}
			default:
				currentState = STATE_DEFAULT;
		}
	}

var hasDanced:Bool = true;

	function dance(forceRestart:Bool) {
		switch(currentState) {
			case STATE_DEFAULT:
				if (hasDanced) {
					PlayState.instance.gf.playAnim('danceRight', forceRestart);
				} else {
					PlayState.instance.gf.playAnim('danceLeft', forceRestart);
				}
				hasDanced = !hasDanced;
			case STATE_PRE_RAISE:
				PlayState.instance.gf.playAnim('danceLeft', false);
				hasDanced = false;
			case STATE_READY:
				if (blinkCountdown == 0) {
					PlayState.instance.gf.playAnim('idleKnife', false);
					blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
				} else {
					blinkCountdown -= 1;
				}
			default:
		}
	}

var gfSpeed:Int = 1;

function onBeatHit()
{
    if (PlayState.SONG.stage == "phillyStreets" || PlayState.SONG.stage == "phillyBlazin") return;
if (PlayState.instance.gfSpeed != 10000000) {
gfSpeed = PlayState.instance.gfSpeed;
PlayState.instance.gfSpeed = 10000000;
}
if(PlayState.instance.gf.specialAnim == false)
{
		if (PlayState.instance.gf != null && curBeat % Math.round(gfSpeed * PlayState.instance.gf.danceEveryNumBeats) == 0 && !PlayState.instance.gf.stunned)
			dance(true);
}
}