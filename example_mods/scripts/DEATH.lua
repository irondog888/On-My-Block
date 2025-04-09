function onCreate()
	if songName == 'blooteg' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'rei-dead');
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'rei_dies')
	elseif songName == 'Aye' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'dead');
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'nobody_wants_to_kill_you')
	end
end