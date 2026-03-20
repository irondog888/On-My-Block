function onEvent(name, value1, value2)
	if name == 'ShowRain' then
		precacheImage('rain')
    		makeAnimatedLuaSprite('rain','rain',0,0)
    		scaleObject('rain',0.9,0.9)
    		setScrollFactor('rain',0.7,1.5)
    		luaSpriteAddAnimationByPrefix('rain','loop','rain loop')
    		addLuaSprite('rain')
    		setProperty('rain.alpha', 0)
    		doTweenAlpha('rainnnnn', 'rain', 0.9, value2, 'linear')
    		setObjectCamera('rain', 'hud')

	end
end