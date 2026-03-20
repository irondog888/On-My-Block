
	function onCreatePost()

		if stringStartsWith(version, '0.7') then
			stage = getPropertyFromClass('states.PlayState', 'curStage')
		else
			stage = getPropertyFromClass('PlayState', 'curStage')
		end
	
		--black bg
		makeLuaSprite('blue', 'blue', getPropertyFromClass('flixel.FlxG', 'width') * -0.5, getPropertyFromClass('flixel.FlxG', 'height') * -0.5)
		makeGraphic('blue', getPropertyFromClass('flixel.FlxG', 'width') * 2, getPropertyFromClass('flixel.FlxG', 'height') * 2, 'ADD8E6')
		
		setScrollFactor('black', 0)
		setProperty('blue.scale.x', 5)
		setProperty('blue.scale.y', 5)
	
		if getProperty('gf.visible') == false then
			setObjectOrder('blue', getObjectOrder('gfGroup'))
		elseif getProperty('dad.visible') == true then
			setObjectOrder('blue', getObjectOrder('dadGroup'))
		else
			setObjectOrder('blue', getObjectOrder('boyfriendGroup'))
		end
	
		addLuaSprite('blue', false)
		setProperty('blue.alpha', 0)

	end

function onEvent(name,value1,value2)
      if name == "backgroundfadeblue" then
		


			if getProperty('blue.alpha') == 0 then
				doTweenAlpha('blue','blue',1,value2,'linear')
			else

				setProperty('blue.alpha', 1)

			end
			if getProperty('blue.alpha') == 1 then

				doTweenAlpha('blue','blue',0,value2,'linear')


			end
	end
end