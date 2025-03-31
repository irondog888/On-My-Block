function onCreate()
	makeLuaSprite('bg','poops/blooteg/back',-550,-300)
	makeLuaSprite('stage','poops/blooteg/mesa',-550,-300)
	makeLuaSprite('gorl','poops/blooteg/azucar',-250,0)
	makeLuaSprite('nut','poops/blooteg/nut',650,400)
	makeAnimatedLuaSprite('silly','poops/blooteg/Fumos',850,250)
	addAnimationByPrefix('silly','bop','dance',24,false)
	makeAnimatedLuaSprite('pepino','poops/blooteg/Pepino',250,100)
	addAnimationByIndices('pepino','bopino1','dance',{2,3,4,5,6,7,8,9,10,11,12,13,14},24,false)
	addAnimationByIndices('pepino','bopino2','dance',{15,16,17,18,19,20,21,22,23,24,25,26,27,28,29},24,false)

	scaleObject('bg',1.2,1.2)
	scaleObject('stage',1.2,1.2)
	scaleObject('gorl',0.8,0.8)
	scaleObject('nut',0.35,0.35)
	scaleObject('silly',0.55,0.55)
	scaleObject('pepino',-0.6,0.6)

	setObjectOrder('gfGroup',2)

	setScrollFactor('gfGroup',1,1)
	setScrollFactor('bg',0.9,0.9)

	addLuaSprite('bg',false)
	addLuaSprite('stage',false)
	addLuaSprite('gorl',false)
	addLuaSprite('nut',false)
	addLuaSprite('silly',false)
	addLuaSprite('pepino',false)
end

function onBeatHit()
	if (curBeat % 2 == 1) then
		playAnim('pepino','bopino2')
	end

	if (curBeat % 2 == 0) then
		playAnim('silly','bop')
		playAnim('pepino','bopino1')
	end
end