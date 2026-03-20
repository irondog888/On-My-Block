function onCreate()
	makeLuaSprite('bg','stageAssets/stageNight/cielo',-750,-160)
	makeLuaSprite('truss','stageAssets/stageNight/cosa',-750,-160)
	makeLuaSprite('stage','stageAssets/stageNight/ese',-750,-160)
	makeLuaSprite('lights','stageAssets/stageNight/lua',-750,-160)
	makeAnimatedLuaSprite('crowd','stageAssets/stageNight/pipol_naig',-750,-160)
	addAnimationByPrefix('crowd','bop','Upper Crowd Bob',12,false)
	makeLuaSprite('logo','stageAssets/stageNight/logo_colab',450,-10)
	makeLuaSprite('screen','',208,-13)
	makeGraphic('screen',1100,495,'000000')

	scaleObject('bg',1.5,1.5)
	scaleObject('truss',1.35,1.35)
	scaleObject('stage',1.35,1.35)
	scaleObject('lights',1.35,1.35)
	scaleObject('crowd',3,3)
	scaleObject('logo',1.36,1.36)

	setScrollFactor('bg',0.5,1)
	setScrollFactor('lights',1.1,1)
	setScrollFactor('crowd',1.2,1)

	addLuaSprite('bg',false)
	addLuaSprite('truss',false)
	addLuaSprite('stage',false)
	addLuaSprite('screen',false)
	addLuaSprite('logo',false)
	addLuaSprite('lights',true)
	addLuaSprite('crowd',true)
end

function onBeatHit()
	if (curBeat % 2 == 0) then
		playAnim('crowd','bop')
	end
end