function onCreate()
	makeLuaSprite('bg','poops/blooteg/back',-550,-300)
	makeLuaSprite('stage','poops/blooteg/mesa',-550,-300)
	makeLuaSprite('gorl','poops/blooteg/azucar',-220,240)
	makeLuaSprite('nut','poops/blooteg/nut',200,560)

	scaleObject('bg',1.2,1.2)
	scaleObject('stage',1.2,1.2)
	scaleObject('gorl',0.55,0.55)
	scaleObject('nut',0.22,0.22)

	addLuaSprite('bg',false)
	addLuaSprite('stage',false)
	addLuaSprite('gorl',false)
	addLuaSprite('nut',false)
end