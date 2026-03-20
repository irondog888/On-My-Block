function onCreate()
	if songName == 'blooteg' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'rei-dead');
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'rei_dies')
	elseif songName == 'Aye' then
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'dead');
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'nobody_wants_to_kill_you')
		
local gameoverSongs = {
  "gameOver2801",
   "gameOver2802",
    "gameOver2803",
     "gameOver2804",
      "gameOver2805",
       "gameOver2806",
        "gameOver2807"
  
}

local gameoverSong = gameoverSongs[getRandomInt(1, #gameoverSongs)];
setPropertyFromClass("substates.GameOverSubstate", "loopSoundName", gameoverSong)
setPropertyFromClass("substates.GameOverSubstate", "endSoundName", gameoverSong.."End")

	end
end