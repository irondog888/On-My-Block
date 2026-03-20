function onCreate()
	makeLuaSprite('Perusalen','Cerru/Cerru',-1383,0)
	makeLuaSprite('imss','Cerru/imss',0,0)
	
	scaleObject('Perusalen',2.51,1.8)
	scaleObject('imss',	2.5,2.79)
	

	setScrollFactor('Perusalen',0.5,1)
	setScrollFactor('imss',0.5,1)
	

	addLuaSprite('Perusalen',false)
	addLuaSprite('imss',false)

end

