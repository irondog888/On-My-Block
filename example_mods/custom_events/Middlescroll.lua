--Event made by MinerGalBr (previously MinerGuyBr) in about 1 afternoon.

local defaultPos = {{412, 524, 636, 748, 412, 524, 636, 748}, {92, 204, 316, 428, 732, 844, 956, 1068}}
local optionsChart = {{'On', 'on', 'oN', 'ON', '1', 'y', 'yes'}, {'Off', 'off', 'oFf', 'oFF', 'ofF', '0', 'n', 'no'}}
local oppVis = true
local currentlyEnabled = false

function onCreatePost()
    if version >= '0.6' then
        if version >= '0.7.2' then
            oppVis = getPropertyFromClass('backend.ClientPrefs', 'data.opponentStrums')
        else
            oppVis = getPropertyFromClass('ClientPrefs', 'opponentStrums')
        end
    end
end
function onEvent(n, v1, v2)
    if n == 'Middlescroll' then
        if not middlescroll then
            for i, v in pairs(optionsChart[1]) do
                if v1 == optionsChart[1][i] then
                    currentlyEnabled = false
                end
            end
            for i, v in pairs(optionsChart[2]) do
                if v1 == optionsChart[2][i] then
                    currentlyEnabled = true
                end
            end
            if v1 == '' or v1 == nil then
                currentlyEnabled = not currentlyEnabled
            end
            if v2 == '' or v2 == nil then
                v2 = 1
            end
            if currentlyEnabled then
                if oppVis then
                    for lol = 0, 3 do
                        noteTweenAlpha('trans'..lol, lol, 0, v2, 'cubeInOut')
                    end
                end
                for merm = 0, 7 do
                    noteTweenX('gender'..merm, merm, defaultPos[1][merm+1], v2, 'cubeInOut')
                end
            end
            if not currentlyEnabled then
                if oppVis then
                    for lmao = 0, 3 do
                        noteTweenAlpha('bf X gf'..lmao, lmao, 1, v2, 'cubeInOut')
                    end
                end
                for warriormerm = 0, 7 do
                    noteTweenX('confirmed'..warriormerm, warriormerm, defaultPos[2][warriormerm+1], v2, 'cubeInOut')
                end
            end
		end
    end
end
