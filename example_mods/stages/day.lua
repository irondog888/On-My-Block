function onCreate()
	makeLuaSprite('bg','day/sky',-750,-160)
	makeLuaSprite('truss','day/reja',-750,-160)
	makeLuaSprite('pantalla','day/floor',-750,-160)
	makeLuaSprite('stage','day/idk',-750,-160)
	makeLuaSprite('lights','day/lights_on',-750,-160)
	makeAnimatedLuaSprite('crowd','day/pendejos',-750,-160)
	addAnimationByPrefix('crowd','bop','Upper Crowd Bob',24,false)
	makeAnimatedLuaSprite('logo','day/logo',450,20)
	addAnimationByPrefix('logo','bopi','logo bumin',24,false)
	makeLuaSprite('screen','',160,-10)
	makeGraphic('screen',1090,495,'000000')
	---use de Base el original de Gumple y lo fucione con el que hice en V-slice Lo jajaja
	makeAnimatedLuaSprite('crowd2','day/pendejos2',-750,-160)
	addAnimationByPrefix('crowd2','bop','Bob',24,false)

	scaleObject('bg',1.3,1.3)
	scaleObject('truss',1.3,1.3)
	scaleObject('stage',1.3,1.3)
	scaleObject('pantalla',1.3,1.3)
	scaleObject('lights',1.3,1.3)
	scaleObject('crowd',1.3,1.3)
	scaleObject('crowd2',1.3,1.3)


	setScrollFactor('bg',0.5,1)
	setScrollFactor('lights',1.1,1)
	setScrollFactor('crowd',1.2,1)
	setScrollFactor('crowd2',1.2,1)
	setScrollFactor('gf',1,1)

	addLuaSprite('bg',false)
	addLuaSprite('truss',false)
	addLuaSprite('stage',false)
	addLuaSprite('pantalla',false)
	addLuaSprite('screen',false)
	addLuaSprite('logo',false)
	addLuaSprite('lights',true)
	addLuaSprite('crowd',true)
	addLuaSprite('crowd2',true)
	if shadersEnabled == true then
		runHaxeCode([[
            import flixel.math.FlxAngle;
			function setShaderFrameInfo(objectName:String) {
				var object:FlxSprite;
				switch(objectName) {
					case 'boyfriend':
                    	object = game.boyfriend;
                	case 'dad':
                    	object = game.dad;
                	case 'gf':
                    	object = game.gf;
                	default:
                    	object = game.getLuaObject(objectName);
				}

				object.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
            	{
					if (object.shader != null) {
						object.shader.setFloatArray('uFrameBounds', [object.frame.uv.x, object.frame.uv.y, object.frame.uv.width, object.frame.uv.height]);
                		object.shader.setFloat('angOffset', object.frame.angle * FlxAngle.TO_RAD);
					}
            	}
			}
        ]])

		initLuaShader('dropShadow')
        for i, object in ipairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(object, 'dropShadow')
    		setShaderFloat(object, 'hue', 0)
    		setShaderFloat(object, 'saturation', 10)
    		setShaderFloat(object, 'contrast', 0)
    		setShaderFloat(object, 'brightness', 10)
			
            setShaderFloat(object, 'ang', math.rad(90))
    		setShaderFloat(object, 'str', 1)
    		setShaderFloat(object, 'dist', 15)
    		setShaderFloat(object, 'thr', 0.1)

			setShaderFloat(object, 'AA_STAGES', 2)
			setShaderFloatArray(object, 'dropColor', {254 / 255, 255 / 255, 234 / 255})
			runHaxeFunction('setShaderFrameInfo', {object})

			local imageFile = stringSplit(getProperty(object..'.imageFile'), '/')
			if checkFileExists('images/characters/masks/'..imageFile[#imageFile]..'_mask.png') then
				setShaderSampler2D(object, 'altMask', 'characters/masks/'..imageFile[#imageFile]..'_mask')
				setShaderFloat(object, 'thr2', 1)
				setShaderBool(object, 'useMask', true)
			else
				setShaderBool(object, 'useMask', false)
			end

			if object  =='gf' then
				setShaderFloat(object, 'dist', 10)
			end
			if object == 'boyfriend' then
				setShaderFloat(object, 'ang', math.rad(90))
			end

			if object == 'dad' then
				setShaderFloat(object, 'ang', math.rad(90))
    			
			end
		end
	end
end

function onBeatHit()
	if (curBeat % 2 == 0) then
		playAnim('crowd','bop')
		playAnim('crowd2','bop')
		playAnim('logo','bopi')
	end
end