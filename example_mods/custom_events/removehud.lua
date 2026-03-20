function onEvent(name, value1, value2)
	if name == 'removehud' and not lowQuality then		
		if value1 == '1' then 
		setProperty('scoreTxt.visible', false);
		setProperty('healthBar.visible', false);
		setProperty('healthBarBG.visible', false);
		setProperty('iconP1.visible', false);
		setProperty('iconP2.visible', false);
		setProperty('timeBar.visible', false);
		setProperty('timeBarBG.visible', false);
		setProperty('timeTxt.visible', false);
		end

		if value1 == '2' then 
		setProperty('scoreTxt.visible', true);
		setProperty('healthBar.visible', true);
		setProperty('healthBarBG.visible', true);
		setProperty('iconP1.visible', true);
		setProperty('iconP2.visible', true);
		setProperty('timeBar.visible', true);
		setProperty('timeBarBG.visible', true);
		setProperty('timeTxt.visible', true);
		end
	end
end