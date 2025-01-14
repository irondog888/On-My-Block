function onCreate()
	makeLuaSprite('bg','poops/stageDay/a',-750,-160)
	makeLuaSprite('truss','poops/stageDay/coso',-750,-160)
	makeLuaSprite('stage','poops/stageDay/esenario',-750,-160)
	makeLuaSprite('lights','poops/stageDay/linternaxd',-750,-160)
	makeAnimatedLuaSprite('crowd','poops/stageDay/fools',-750,-160)
	addAnimationByPrefix('crowd','bop','Upper Crowd Bob',12,false)
	makeAnimatedLuaSprite('logo','poops/stageDay/logo',450,20)
	addAnimationByPrefix('logo','bop','logo bumin',12,false)
	makeLuaSprite('screen','',208,-13)
	makeGraphic('screen',1100,495,'000000')

	scaleObject('bg',1.5,1.5)
	scaleObject('truss',1.5,1.5)
	scaleObject('stage',1.5,1.5)
	scaleObject('lights',1.5,1.5)
	scaleObject('crowd',1.5,1.5)

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
		playAnim('logo','bop')
	end
end