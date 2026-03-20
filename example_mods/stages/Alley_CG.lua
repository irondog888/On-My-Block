function onCreate()
	makeLuaSprite('sky','callejon/noche',-560,-300)
	makeLuaSprite('torregemela1','callejon/edificio 2',-650,-200)
	makeLuaSprite('torregemela2','callejon/edificio 1',-650,-200)
	makeLuaSprite('stage','callejon/piso',-750,-400)

	scaleObject('sky',0.9,0.9)
	scaleObject('torregemela1',0.9,0.9)
	scaleObject('torregemela2',0.9,0.9)
	scaleObject('stage',0.9,0.9)

	setScrollFactor('torregemela2', 0.3, 0.6)
	setScrollFactor('torregemela1', 0.2, 0.4)
	setScrollFactor('sky',0,0.0)
	setScrollFactor('gf',1,1)

	
	addLuaSprite('sky',false)
	addLuaSprite('torregemela1',false)
	addLuaSprite('torregemela2',false)
	addLuaSprite('stage',false)
end