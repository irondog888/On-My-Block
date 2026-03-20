local dirs = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
local activeSustain = {player = {-1,-1,-1,-1}, opponent = {-1,-1,-1,-1}}
local shadowTags = {} 
local lastSustainTime = 0

function onUpdatePost(elapsed)
    local songPos = getPropertyFromClass('backend.Conductor', 'songPosition')
    
    if songPos > lastSustainTime + 500 then 
        return 
    end
    
    processGroup('boyfriendGroup', 'player', songPos)
    processGroup('dadGroup', 'opponent', songPos)
    processGroup('gfGroup', nil, songPos)

    for tag, side in pairs(shadowTags) do
        if getProperty(tag .. '.active') ~= nil then
            processIndividual(tag, side, songPos)
        else
            shadowTags[tag] = nil 
        end
    end
end

function processGroup(groupName, side, songPos)
    local len = getProperty(groupName .. '.members.length')
    for i = 0, len - 1 do
        processIndividual(groupName .. '.members[' .. i .. ']', side, songPos)
    end
end

function processIndividual(path, side, songPos)
    local curAnim = getProperty(path .. '.animation.curAnim.name')
    if curAnim == nil or not string.find(curAnim:lower(), 'sing') then 
        if getProperty(path .. '.animation.curAnim.paused') then
            setProperty(path .. '.animation.curAnim.paused', false)
            setProperty(path .. '.specialAnim', false)
        end
        return 
    end

    local dir = -1
    local lowerAnim = curAnim:lower()
    for i = 1, 4 do
        if string.find(lowerAnim, dirs[i]:lower()) then dir = i; break end
    end

    if dir ~= -1 then
        local limit = (side == nil) 
            and math.max(activeSustain.player[dir], activeSustain.opponent[dir]) 
            or activeSustain[side][dir]

        if songPos < limit then
            setProperty(path .. '.holdTimer', 0)
            setProperty(path .. '.animation.curAnim.paused', true)
            setProperty(path .. '.animation.curAnim.curFrame', 0)
            setProperty(path .. '.specialAnim', true)
        elseif getProperty(path .. '.animation.curAnim.paused') then
            setProperty(path .. '.animation.curAnim.paused', false)
            setProperty(path .. '.specialAnim', false)
        end
    end
end

function handleNoteHit(id, dir, isPlayer, type)
    local susLen = getPropertyFromGroup('notes', id, 'sustainLength')
    if susLen > 0 then
        local songPos = getPropertyFromClass('backend.Conductor', 'songPosition')
        local side = isPlayer and 'player' or 'opponent'
        
        local endTime = songPos + susLen - 30
        activeSustain[side][dir + 1] = endTime
        
        if endTime > lastSustainTime then
            lastSustainTime = endTime
        end

        if type ~= '' and type ~= nil then
            local membersLen = getProperty('members.length')
            for i = 0, membersLen - 1 do
                local objPath = 'members['..i..']'
                local anim = getProperty(objPath .. '.animation.curAnim.name')
                if anim ~= nil and string.find(anim:lower(), 'sing') then
                    if not string.find(objPath, 'Group') then
                        shadowTags[objPath] = side
                        break
                    end
                end
            end
        end
    end
end

function goodNoteHit(id, dir, type, isSus) if not isSus then handleNoteHit(id, dir, true, type) end end
function opponentNoteHit(id, dir, type, isSus) if not isSus then handleNoteHit(id, dir, false, type) end end