function onCreate()
	makeLuaSprite('bg','night/sky',-750,-160)
	makeLuaSprite('truss','night/reja',-750,-160)
	makeLuaSprite('pantalla','night/floor',-750,-160)
	makeLuaSprite('stage','night/idk',-750,-160)
	makeLuaSprite('lights','night/light_off',-750,-160)
	makeAnimatedLuaSprite('crowd','night/pendejos',-750,-160)
	addAnimationByPrefix('crowd','bop','Upper Crowd Bob',24,false)
	makeAnimatedLuaSprite('logo','night/logo',450,20)
	addAnimationByPrefix('logo','bop','logo bumin',24,false)

	makeAnimatedLuaSprite('ax','night/ax',1200,20)
	addAnimationByPrefix('ax','idle','idle',24,false)
    addAnimationByPrefix('ax','Hey', 'hey', 24, false);

	addAnimationByIndices('ax', 'idle', 'Ax stage', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13')
	addAnimationByIndices('ax', 'Hey', 'Ax stage', '14, 15, 16, 17 , 18, 19, 20, 21, 22, 23, 24, 25, 26, 27')

	-- Fuck por que coño se mueve ax
	makeLuaSprite('screen','',160,-10)
	makeGraphic('screen',1090,495,'000000')
	makeAnimatedLuaSprite('crowd2','night/pendejos2',-750,-160)
	addAnimationByPrefix('crowd2','bop','Bob',24,false)



	
	scaleObject('bg',1.3,1.3)
	scaleObject('truss',1.3,1.3)
	scaleObject('stage',1.3,1.3)
	scaleObject('pantalla',1.3,1.3)
	scaleObject('lights',1.3,1.3)
	scaleObject('crowd',1.3,1.3)
	scaleObject('crowd2',1.3,1.3)
	scaleObject('ax',1,1)


	setScrollFactor('bg',0.5,1)
	setScrollFactor('gf',1,1)
	setScrollFactor('lights',1.1,1)
	setScrollFactor('crowd',1.2,1)
	setScrollFactor('crowd2',1.2,1)

	addLuaSprite('bg',false)
	addLuaSprite('truss',false)
	addLuaSprite('stage',false)
	addLuaSprite('pantalla',false)
	addLuaSprite('screen',false)
	addLuaSprite('logo',false)
	addLuaSprite('ax',false)
	addLuaSprite('lights',true)
	addLuaSprite('crowd',true)
	addLuaSprite('crowd2',true)
	


---cheider como en v-slice 
	
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
        for i, object in ipairs({'boyfriend', 'dad', 'gf','ax'}) do
            setSpriteShader(object, 'dropShadow')
    		setShaderFloat(object, 'hue', 0)
    		setShaderFloat(object, 'saturation', 0)
    		setShaderFloat(object, 'contrast', 0)
    		setShaderFloat(object, 'brightness', -60)
			
            setShaderFloat(object, 'ang', math.rad(90))
    		setShaderFloat(object, 'str', 1)
    		setShaderFloat(object, 'dist', 15)
    		setShaderFloat(object, 'thr', 0.1)

			setShaderFloat(object, 'AA_STAGES', 2)
			setShaderFloatArray(object, 'dropColor', {29 / 255, 21 / 255, 58 / 255})
			runHaxeFunction('setShaderFrameInfo', {object})

			local imageFile = stringSplit(getProperty(object..'.imageFile'), '/')
			if checkFileExists('images/characters/masks/'..imageFile[#imageFile]..'_mask.png') then
				setShaderSampler2D(object, 'altMask', 'characters/masks/'..imageFile[#imageFile]..'_mask')
				setShaderFloat(object, 'thr2', 1)
				setShaderBool(object, 'useMask', true)
			else
				setShaderBool(object, 'useMask', false)
			end
			if object == 'boyfriend' then
				setShaderFloat(object, 'ang', math.rad(90))
				setShaderFloat(object, 'dist', 40)
			end

			if object == 'dad' then
				setShaderFloat(object, 'ang', math.rad(135))
    			setShaderFloat(object, 'thr', 0.2)
			end
			if _G[object..'Name'] =='gf' then
				setShaderFloat(object, 'thr', 0.3)
				setShaderFloat(object, 'dist', 20)
				setShaderFloatArray(object, 'dropColor', {255 / 255, 255 / 255, 255 / 255})
			end
			
		end
	end
end
--- hey
function onEvent(name)
    if name == 'Hey!' then
        playAnim('ax', 'Hey')
		 playAnim('dad', 'hey')
        setProperty('ax.specialAnim', true)
		setProperty('dad.specialAnim', true)
    end
end
--- bop
function onBeatHit()
	if (curBeat % 2 == 0) then
		playAnim('crowd','bop')
		playAnim('crowd2','bop')
		playAnim('logo','bop')
		playAnim('ax','idle')
	end
end