local zooms = {
    boyfriend = nil,
    gf = nil,
    dad = nil
}
local curFocus = ''
function setZoom(zoom,target)
    if target == 'bf' then
        target = 'boyfriend'
    end
    if target == nil then
        for char, charZoom in pairs(zooms) do
            zooms[char] = zoom
        end
    else
        zooms[target] = zoom
    end
    if zoom ~= nil and (target == curFocus or target == nil) then
        setProperty('defaultCamZoom',zoom)
    end
end
function onEvent(name,v1,v2)
    if name == 'Set Cam Zoom' then
        local zoom = tonumber(v1)
        v2 = string.lower(v2)
        if v2 == '' then
            setZoom(nil)
            setProperty('defaultCamZoom',zoom)
        elseif v2 ~= '' then
            if v2 == 'bf' then
                v2 = 'boyfriend'
            end
            if v2 == 'dad' and not mustHitSection or v2 == 'boyfriend' and mustHitSection or v2 == 'gf' and gfSection == true then
                setProperty('defaultCamZoom',zoom)
            end
            setZoom(zoom,string.lower(v2))
        end
    end
end
function doZoom(focus)
    if zooms[focus] ~= nil then
        setProperty('defaultCamZoom',zooms[focus])
    end
end
function onMoveCamera(focus)
    if curFocus ~= focus and curSection > 0 then
        curFocus = focus
        doZoom(focus)
    end
end