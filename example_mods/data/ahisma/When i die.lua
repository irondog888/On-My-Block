--EXAMPLE OF HOW VOICELINES SHOULD LOOK IN THE SOUNDS FOLDER 4 DUMMIES: "mm1.ogg, mm2.ogg, mm3.ogg"

local nameprefix = "niko" -- the beginning of the filename for all voiceclips put in the sounds folder
local maxvoicelines = 3 -- set this to how many voicelines you are using (this will identify the number at the end of each sound file)

--Script By: MizMaz (and some help from the Psych Engine Discord)
--no need to credit me on your mod or anything, its a pretty simple script after all

--NO TOUCHY BEYOND THIS LINEY--
local randomshit = nameprefix.. getRandomInt(1,maxvoicelines)
function onGameOverStart()
runTimer("fuckasstimer", 3)
runTimer("shitasstimer", 2.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
      if tag == "fuckasstimer" then
       playSound(randomshit, 1, "tagyouritbitch")
    end
      if tag == "shitasstimer" then
       soundFadeOut(nil, 1, 0.3)
    end
end

function onSoundFinished(tag)
        if tag == "tagyouritbitch" then
        soundFadeIn(nil, 1, 0.3, 1)
    end
end

