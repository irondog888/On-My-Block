function onEvent(name, value1, value2)
	if name == 'ShowLight' then
    		makeLuaSprite('light','light',0,0)
    		scaleObject('light',0.85,0.85)
    		setScrollFactor('light',0.3,0.3)
    		addLuaSprite('light')
    		setObjectCamera('light', 'hud')
		precacheImage('light')

	end
end