function onCreate()
	makeLuaSprite('sky','poops/alley/noche',-560,-300)
	makeLuaSprite('bg2','poops/alley/edificio 2',-650,-200)
	makeLuaSprite('bg1','poops/alley/edificio 1',-650,-200)
	makeLuaSprite('stage','poops/alley/nosé, pero está najimi',-750,-400)

	scaleObject('sky',0.9,0.9)
	scaleObject('bg2',0.9,0.9)
	scaleObject('bg1',0.9,0.9)
	scaleObject('stage',0.9,0.9)

	setScrollFactor('bg1', 0.3, 0.6)
	setScrollFactor('bg2', 0.2, 0.4)
	setScrollFactor('sky',0,0.0)

	addLuaSprite('sky',false)
	addLuaSprite('bg2',false)
	addLuaSprite('bg1',false)
	addLuaSprite('stage',false)
end