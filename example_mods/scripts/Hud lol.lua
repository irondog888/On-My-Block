
function onCreatePost()
  setTextString('scoreTxt', 'Pejepoints'..score)
  setProperty('scoreTxt.x', 250)
  scaleObject('scoreTxt', 0.9, 0.9)
  setTextBorder("scoreTxt", 2, '000000')
  setPropertyFromClass('lime.app.Application', 'current.window.title', "On my block'")
  setPropertyFromClass('Main', 'fpsVar.visible', false)
  setProperty('timeBar.visible','false')
  setProperty('timeBarBG.visible','false')
end

function onUpdatePost()
  setTextString('scoreTxt', 'Pejepoints:'..score)
  scaleObject('scoreTxt', 0.9, 0.9)
end

function goodNoteHit(id, data, type, sus)
  if sus then
    if getProperty('boyfriend.animation.curAnim.curFrame', 2) then
      setProperty('boyfriend.animation.curAnim.curFrame', 1)
    else
      setProperty('boyfriend.animation.curAnim.curFrame', 1)
    end
  end
end

function opponentNoteHit(id, data, type, sus)
  if sus then
    if getProperty('dad.animation.curAnim.curFrame', 2) then
      setProperty('dad.animation.curAnim.curFrame', 1)
    else
      setProperty('dad.animation.curAnim.curFrame', 1)
    end
  end
end

function opponentNoteHit(id, noteData)
  runHaxeCode([[game.opponentStrums.members[]]..noteData..[[].playAnim('static', true)]]);

end

function onBeatHit()
  if (curBeat % 2 == 0) then
    scaleObject('iconP1', 1.5, 1)
    scaleObject('iconP2', 1, 1.5)
  else
    scaleObject('iconP1', 1, 1.5)
    scaleObject('iconP2', 1.5, 1)
  end
end

function onDestroy()
  setPropertyFromClass('lime.app.Application', 'current.window.title', "Friday Night Funkin': Psych Engine")  
  setPropertyFromClass('Main', 'fpsVar.visible', true)
end