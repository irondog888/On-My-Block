function onCreate()
	makeLuaSprite('sky','poops/wasteland/RedSky',-800,-400)
	makeLuaSprite('bg','poops/wasteland/MountainsAndBuildings',-800,-350)
	makeLuaSprite('floor','poops/wasteland/floor',-800,-350)

	scaleObject('sky',1.41,1.41)
	scaleObject('bg',1.41,1.41)
	scaleObject('floor',1.41,1.41)

	setScrollFactor('bg',0.5,0.5)
	setScrollFactor('sky',0.1,0)

	--setProperty('your image name.antialiasing', false);

	addLuaSprite('sky',false)
	addLuaSprite('bg',false)
	addLuaSprite('floor',false)
end