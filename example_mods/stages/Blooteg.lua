function onCreate()
	makeLuaSprite('bg','poops/blooteg/back',-550,-300)
	makeLuaSprite('stage','poops/blooteg/mesa',-550,-300)
	makeLuaSprite('gorl','poops/blooteg/azucar',-250,0)
	makeLuaSprite('nut','poops/blooteg/nut',550,400)
	makeAnimatedLuaSprite('silly','poops/blooteg/Fumos',850,200)
	addAnimationByPrefix('silly','bop','dance',24,false)

	scaleObject('bg',1.2,1.2)
	scaleObject('stage',1.2,1.2)
	scaleObject('gorl',0.8,0.8)
	scaleObject('nut',0.35,0.35)
	scaleObject('silly',0.55,0.55)

	setObjectOrder('gfGroup',2)

	setScrollFactor('gfGroup',1,1)
	setScrollFactor('bg',0.9,0.9)

	addLuaSprite('bg',false)
	addLuaSprite('stage',false)
	addLuaSprite('gorl',false)
	addLuaSprite('nut',false)
	addLuaSprite('silly',false)
end

function onBeatHit()
	if (curBeat % 2 == 0) then
		playAnim('silly','bop')
	end
end