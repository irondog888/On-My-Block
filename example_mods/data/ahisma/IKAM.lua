--luaDebugMode = true
local settings = {
    -- Camera Position
    Atm = true, -- Active?
    Pos = 30,
    -- Camera Angle
    Agt = true, -- Active?
    Ang = 1,
    -- Camera Zoom per note direction   It's opposite on the player side
    Act = true, -- Active?
    Zo1 = -.02, -- ←
    Zo2 = -.01, -- ↓ 
    Zo3 = .01, -- ↑
    Zo4 = .02, -- →
    -- Smooth Speed    lower = smoother
    SPA = 2, -- Angle
    SPZ = 4, -- Zoom
    --[[
        Multiplier decay after note hit
        Set them to 1 if you prefer stay the cam
        Set them to 0 if you prefer instant goes back
    ]]
    MUL = 0.5, -- Pos
    MAL = 0.5, -- Angle
    MIL = 0.5, -- Zoom
    --[[
        Non focus cam move multiplier      Similar to Raltyro's smooth cam script becuz I'm so obsessed on that feature :3c
        Set them to 0 if you prefer only focused character like mustHitSection only
        Set them to 1 if... Idk highly recommended if both character sings
    ]]
    MulSec = 0.25,
    -- Makes the camera go opposite only for zoom. Kind of useless isn't it?
    Opposit = false,
    -- Which note type will ignore
    -- Ex: {'WhataSigma?', 'SixSeven', 'tungtungtungtungtungtungtungtungtungSahur'}
    NotType = {'No Animation'},
}
--Script by 3piz2uko (No credit needed. Well depends if you wanted it to remember mee!! :3c )








--Nu touchy touchy unless u very nerdy than my goober brain 
local P = {x= 0, y= 0, a= 0, z= 0} -- Player
local O = {x= 0, y= 0, a= 0, z= 0} -- Opponent 
local camLerp = {x= 0, y= 0, a= 0, z= 0} -- Lerp
local directThing = {
    [0] = {ex= -1, wy= 0,  an= -1},
    [1] = {ex= 0,  wy= 1,  an= .5},
    [2] = {ex= 0,  wy= -1, an= -.5},
    [3] = {ex= 1,  wy= 0,  an= 1},
}
local function boundTo(v, lo, hi) return math.max(lo, math.min(hi, v)) end
local function lerp(a, b, t) return a + (b - a) * t end
local function isIgnoredType(t)
    for _,v in ipairs(settings.NotType) do
        if v == t then return true end
    end
    return false
end
local function decay(mx, my, ma, mz, ismustHitSection)
    local mulS = boundTo(settings.MulSec, 0, 1)
    if ismustHitSection then
        mx = mx * settings.MUL
        my = my * settings.MUL
        ma = ma * settings.MAL
        mz = mz * settings.MIL
    else
        mx = mx * (settings.MUL * mulS)
        my = my * (settings.MUL * mulS)
        ma = ma * (settings.MAL * mulS)
        mz = mz * (settings.MIL * mulS)
    end
    return mx, my, ma, mz
end
local function getDir(isPlayer)
    local zumOrds
    if isPlayer then
        zumOrds = settings.Opposit and {1,2,3,4} or {4,3,2,1}
    else
        zumOrds = settings.Opposit and {4,3,2,1} or {1,2,3,4}
    end

    local out = {}
    for d = 0,3 do
        local ref = directThing[d]
        out[d] = {
            ex = ref.ex,
            wy = ref.wy,
            an = ref.an,
            zm = settings["Zo"..zumOrds[d+1]],
        }
    end
    return out
end
local function smooth(current, target, speed, elapsed)--Prevents being too fast/slow depends on the fps
    return current + (target - current) * (1 - math.exp(-speed * elapsed))
end
function onUpdatePost(elapsed)
    local mulS = boundTo(settings.MulSec, 0, 1)
    local pMul = { -- Player side
        Move = mustHitSection and settings.Pos or (settings.Pos * mulS),
        Angl = mustHitSection and settings.Ang or (settings.Ang * mulS),
        Zoom = mustHitSection and 1 or mulS,
    }
    local oMul = { -- Opponent side
        Move = mustHitSection and (settings.Pos * mulS) or settings.Pos,
        Angl = mustHitSection and (settings.Ang * mulS) or settings.Ang,
        Zoom = mustHitSection and mulS or 1,
    }
    -- Decay stuff
    local tx = (P.x * pMul.Move) + (O.x * oMul.Move)
    local ty = (P.y * pMul.Move) + (O.y * oMul.Move)
    local ta = (P.a * pMul.Angl) + (O.a * oMul.Angl)
    local tz = (P.z * pMul.Zoom) + (O.z * oMul.Zoom)

    if settings.Atm then -- Camera X/Y Move
        local camSpid = boundTo(1 / (getProperty('cameraSpeed') ^ 2), 0.04, 1) / playbackRate -- The cam prevents snappy if the cameraSpeed goes higher~
        setProperty('camGame.targetOffset.x', lerp(camLerp.x, tx, camSpid))
        setProperty('camGame.targetOffset.y', lerp(camLerp.y, ty, camSpid))
    end

    if settings.Agt then -- Camera Angle 
        camLerp.a = smooth(camLerp.a, ta, settings.SPA, elapsed)
        setProperty('camGame.angle', camLerp.a)
    end
    
    if settings.Act then -- Camera Zoom     This time this is fixed fr fr no more jittery fr fr fr
        local camZum = getProperty('camGame.zoom')
        local camZim = camZum / (1 + camLerp.z)
        camLerp.z = smooth(camLerp.z, tz, settings.SPZ, elapsed)
        setProperty('camGame.zoom', camZim * (1 + camLerp.z))
    end    
end

function goodNoteHit(id, dir, typ, sus)
    if isIgnoredType(typ) then return end
    local d = getDir(true)[dir]
    P.x, P.y, P.a, P.z = d.ex, d.wy, d.an, d.zm
    runTimer("pld", 0.1)
    runTimer("ply", crochet/1000)
end

function opponentNoteHit(id, dir, typ, sus)
    if isIgnoredType(typ) then return end
    local d = getDir(false)[dir]
    O.x, O.y, O.a, O.z = d.ex, d.wy, d.an, d.zm
    runTimer("opd", 0.1)
    runTimer("opp", crochet/1000)
end

function onTimerCompleted(tag)
    if tag == "opd" then
        O.x, O.y, O.a, O.z = decay(O.x, O.y, O.a, O.z, mustHitSection)
    elseif tag == "pld" then
        P.x, P.y, P.a, P.z = decay(P.x, P.y, P.a, P.z, mustHitSection)
    elseif tag == "opp" then
        O.x, O.y, O.a, O.z = 0,0,0,0
    elseif tag == "ply" then
        P.x, P.y, P.a, P.z = 0,0,0,0
    end
end
