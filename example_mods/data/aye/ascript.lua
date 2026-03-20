function onStartCountdown()
if not allowCountdown and isStoryMode and not seenCutscene then -- Block the first countdown
startVideo('xd'); -- your Video's name | video (must be 1280x720) paste into "videos" folder 
allowCountdown = true;
return Function_Stop;
end
return Function_Continue;
end