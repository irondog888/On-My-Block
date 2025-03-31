local ofs;
local x; local y;
local xx; local yy;

if songName == 'tecno-swing' or songName == 'are-you-with-mei' then
    ofs = 30
    x = 540; y = 520
    xx = 770; yy = 610
end


function goodNoteHit(elapsed)
	local anim = getProperty('boyfriend.animation.curAnim.name')


    if mustHitSection == true then
        --views = views + math.random(10, 200)
        if anim == 'singLEFT' then triggerEvent('Camera Follow Pos', xx-ofs, yy)
        elseif anim == 'singRIGHT' then triggerEvent('Camera Follow Pos', xx+ofs, yy)
        elseif anim == 'singUP' then triggerEvent('Camera Follow Pos', xx, yy-ofs)
        elseif anim == 'singDOWN' then triggerEvent('Camera Follow Pos', xx, yy+ofs) end
    end
end

function opponentNoteHit()
	local anim = getProperty('dad.animation.curAnim.name')


    if mustHitSection == false then
        --views = views + math.random(10, 30*ratingRate)
        if anim == 'singLEFT' then triggerEvent('Camera Follow Pos', x-ofs, y)
        elseif anim == 'singRIGHT' then triggerEvent('Camera Follow Pos', x+ofs, y)
        elseif anim == 'singUP' then triggerEvent('Camera Follow Pos', x, y-ofs)
        elseif anim == 'singDOWN' then triggerEvent('Camera Follow Pos', x, y+ofs) end
    end
end

--I stole this from Murasaki Friday Night Fluffin'