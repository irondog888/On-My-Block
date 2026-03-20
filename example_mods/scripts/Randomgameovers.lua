
local gameoverSongs = {
  "agentegameovers/28_4",
  "agentegameovers/TRISTEZA Y AFLICCION",
  "Menea tu chapa nikomix",--- jejej 
  "agentegameovers/U N ME",
  "agentegameovers/CaraDePoker_GO",
  "agentegameovers/CDXX Loop",
  "agentegameovers/HIJA DE PERRA",
  "agentegameovers/HM...",
  "agentegameovers/LuccyGmOv",
  "agentegameovers/LOBOTOMIA TYPE BEAT",
  "agentegameovers/mrd2",
  "agentegameovers/mrda2 mas mrda que nunca",
  "agentegameovers/TIBURON GATO",
  "agentegameovers/PERDISTE"
}

local gameoverSong = gameoverSongs[getRandomInt(1, #gameoverSongs)];
setPropertyFromClass("substates.GameOverSubstate", "loopSoundName", gameoverSong)


