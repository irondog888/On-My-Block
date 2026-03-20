function onCreate()
	makeLuaSprite('Sky','banco',500,500)
	
	makeLuaSprite('piso','mesa',1200,500)

	scaleObject('Sky',0.95,0.95)
		scaleObject('piso',	0.95,0.95)

	setScrollFactor('Sky',0.5,1)
	setScrollFactor('gf',1,1)
	
	
	

	addLuaSprite('Sky',false)
	
	addLuaSprite('piso',false)
	
	
end

