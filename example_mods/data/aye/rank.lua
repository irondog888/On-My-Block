local savedPos = {}
local newPos = {
100,  --rating X coordinate
10,  --rating Y coordinate
-1310,  --combo X coordinate
-240   --combo Y coordinate
}


function onCreate()
if difficultyName == 'Normal' then
end
end
savedPos = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')
for i = 1,4 do
setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset['..(i-1)..']', newPos[i])
end

function onDestroy()
for i = 1,4 do
setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset['..(i-1)..']', savedPos[i])
end
end