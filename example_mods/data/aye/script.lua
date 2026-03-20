aC=false vid='xd'
function onStartCountdown() if not aC and not isStoryMode and not seenCutscene then startVideo(vid) aC=true return Function_Stop end return Function_Continue end