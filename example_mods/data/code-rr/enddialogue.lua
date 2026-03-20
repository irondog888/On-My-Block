local playDialogue = true

function onEndSong()
    if playDialogue and isStoryMode then
        playDialogue = false
        startDialogue('dialogueEnd', 'breakfast') -- breakfast is the music name
        return Function_Stop
    end
end