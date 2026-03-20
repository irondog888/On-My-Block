function onCountdownTick(swagCounter)
	if swagCounter == 1 then




makeLuaSprite('ready', 'readyc', screenWidth / 1.7 - 369, screenHeight / 1.8 - 185);

setObjectCamera('ready','other');

scaleObject('ready', 1, 1);

doTweenAlpha('elpepe', 'ready', 0, crochet / 1000, 'cubeInOut');

setProperty('countdownReady.visible', false);

addLuaSprite('ready', true);

end

if swagCounter == 2 then -- Set



makeLuaSprite('set', 'setc', screenWidth / 1.7 - 369, screenHeight / 1.8 - 185);

setObjectCamera('set','other');

scaleObject('set', 1, 1);

doTweenAlpha('elpepe', 'set', 0, crochet / 1000, 'cubeInOut');

setProperty('countdownSet.visible', false);

addLuaSprite('set', true);

end

if swagCounter == 3 then -- GO



makeLuaSprite('GO', 'Goc', screenWidth / 2 - 289, screenHeight / 1.6 - 215);

setObjectCamera('GO','other');

scaleObject('GO', 1, 1);

doTweenAlpha('elpepe', 'GO', 0, crochet / 1000, 'cubeInOut');

setProperty('countdownGo.visible', false);

addLuaSprite('GO', true);

end

end