function onEvent(name, value1, value2)
	if name == 'Sunshine' and value1 == 'a' then
		precacheImage('SayoSunshine')
		makeLuaSprite('Sun', 'SayoSunshine', 0, 0)
		addLuaSprite('Sun')
		setObjectCamera('Sun','camHud')
	end
	if name == 'Sunshine' and value1 == '1' then
		doTweenAlpha('shine-1','Sun',1,0.001,'linear')
		doTweenColor('shine-red','Sun','ffa8ef',0.001,'linear')
		doTweenAlpha('shine-2','Sun',0, 1.25,'linear')
		setProperty('Sun.visible', true)
      end
	if name == 'Sunshine' and value1 == '2' then
		doTweenAlpha('shine-1','Sun',1, 0.001,'linear')
		doTweenColor('shine-red', 'Sun', 'b997f9', 0.001, 'linear');
		doTweenAlpha('shine-2','Sun',0, 1.25,'linear')
      end
	if name == 'Sunshine' and value1 == '3' then
		doTweenAlpha('shine-1','Sun',1, 0.001,'linear')
		doTweenColor('shine-red', 'Sun', '8eefff', 0.001, 'linear')
		doTweenAlpha('shine-2','Sun',0, 1.25,'linear')
      end
	if name == 'Sunshine' and value1 == '4' then
		doTweenAlpha('shine-1','Sun',1, 0.001,'linear')
		doTweenColor('shine-red', 'Sun', '89f572', 0.001, 'linear');
		doTweenAlpha('shine-2','Sun',0, 1.25,'linear')
      end
	if name == 'Sunshine' and value1 == 'b' then
		removeLuaSprite('Sun')
    end
end