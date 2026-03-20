function onCreatePost()
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
    		setShaderFloat(object, 'saturation', -50)
    		setShaderFloat(object, 'contrast', 0)
    		setShaderFloat(object, 'brightness', 0)
			
            setShaderFloat(object, 'ang', math.rad(90))
    		setShaderFloat(object, 'str', 1)
    		setShaderFloat(object, 'dist', 0)
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
				setShaderFloat(object, 'dist', 0)
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
