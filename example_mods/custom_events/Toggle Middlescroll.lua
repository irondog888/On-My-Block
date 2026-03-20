local on
function onEvent(n, v1, v2)
	if n ~= 'Toggle Middlescroll' or middlescroll then return end
	on = not on
	local d = stepCrochet * (tonumber(v1) > 0 and tonumber(v1) or 0.0001) * 0.001 / playbackRate
	if on then
		for i = 0, 7 do
			noteTweenX('mid_'..i, i, i > 3 and 412 + 112*(i-4) or -469 + 112*i, d, v2)
		end
	else
		for i = 0, 7 do
			noteTweenX('unmid_'..i, i, _G['default'..(i > 3 and 'Player' or 'Opponent')..'StrumX'..(i > 3 and i-4 or i)], d, v2)
		end
	end
end