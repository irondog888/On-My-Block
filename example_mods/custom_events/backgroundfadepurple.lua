
	function onCreatePost()

		if stringStartsWith(version, '0.7') then
			stage = getPropertyFromClass('states.PlayState', 'curStage')
		else
			stage = getPropertyFromClass('PlayState', 'curStage')
		end
	
		--black bg
		makeLuaSprite('purple', 'purple', getPropertyFromClass('flixel.FlxG', 'width') * -0.5, getPropertyFromClass('flixel.FlxG', 'height') * -0.5)
		makeGraphic('purple', getPropertyFromClass('flixel.FlxG', 'width') * 2, getPropertyFromClass('flixel.FlxG', 'height') * 2, 'A020F0')
		
		setScrollFactor('purple', 0)
		setProperty('purple.scale.x', 5)
		setProperty('purple.scale.y', 5)
	
		if getProperty('gf.visible') == false then
			setObjectOrder('purple', getObjectOrder('gfGroup'))
		elseif getProperty('dad.visible') == true then
			setObjectOrder('purple', getObjectOrder('dadGroup'))
		else
			setObjectOrder('purple', getObjectOrder('boyfriendGroup'))
		end
	
		addLuaSprite('purple', false)
		setProperty('purple.alpha', 0)

	end

function onEvent(name,value1,value2)
      if name == "backgroundfadepurple" then
		


			if getProperty('purple.alpha') == 0 then
				doTweenAlpha('purple','purple',1,value2,'linear')
			else

				setProperty('purple.alpha', 1)

			end
			if getProperty('purple.alpha') == 1 then

				doTweenAlpha('purple','purple',0,value2,'linear')


			end
	end
end