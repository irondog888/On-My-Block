function onCreate()
	makeLuaSprite('Sky','nevada/sky',-300,0)
	makeLuaSprite('City','nevada/montain',-300,0)
	makeLuaSprite('piso','nevada/floor',0,0)

	scaleObject('Sky',2,2)
	scaleObject('City',	2,2)
	scaleObject('piso',	2,2)

	setScrollFactor('Sky',0.5,1)
	setScrollFactor('City',0.5,1)
	setScrollFactor('gf',1,1)
	

	addLuaSprite('Sky',false)
	addLuaSprite('City',false)
	addLuaSprite('piso',false)
	
end

