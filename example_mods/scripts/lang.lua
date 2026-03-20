local langInfo = nil
local isPixel = false
local langs = {
	['Español (México)'] = {
		path = 'es-MX/';
		ratings = {'ratings/sick'; 'ratings/good'; 'ratings/bad'; 'ratings/shit'};
		countdown = {'ui/ready'; 'ui/set'; 'ui/go'};
		ratingOffset = {x = 45; y = -4};
	};
}

function goodNoteHit(_, _, _, sustain)
	if not sustain and langHas('ratingOffset') and getProperty('showRating') then
		local ratingIndex = getProperty('comboGroup.length') - (getProperty('showCombo') and 2 or 1)
		if getProperty('showComboNum') then ratingIndex = ratingIndex - (combo >= 1000 and 4 or 3) end
		
		local member = 'comboGroup.members[' .. ratingIndex .. ']'
		setProperty(member .. '.x', getProperty(member .. '.x') - (langInfo.ratingOffset.x or 0))
		setProperty(member .. '.y', getProperty(member .. '.y') - (langInfo.ratingOffset.y or 0))
	end
end
function onCountdownTick(tick)
	if langHas('countdown') and tick > 0 and tick < 4 then
		local cd = {'Ready', 'Set', 'Go'}
		local cdItem = 'countdown' .. cd[tick]
		loadGraphic(cdItem, (isPixel and 'pixelUI/' or '') .. langInfo.path .. langInfo.countdown[tick] .. (isPixel and '-pixel' or ''))
		screenCenter(cdItem)
	end
end

-- backend
function langHas(key) return (langInfo and langInfo[key]) end
function onCreatePost()
	isPixel = getPropertyFromClass('states.PlayState', 'isPixelStage')
	initLang(getModSetting('transgraphics'))
end
function onGameOver()
	if keyboardPressed('CONTROL') then
		setHealth(1)
		return Function_Stop
	end
end
function onUpdate()
	if langInfo and keyboardJustPressed('R') and keyboardPressed('CONTROL') then
		reloadLangGraphics()
		debugPrint('graphics reloaded!', '66ff33')
	end
end
function reloadLangGraphics()
	local reloadImages = {}
	for _, set in ipairs{'ratings', 'countdown'} do
		for _, rating in ipairs(langInfo[set]) do
			table.insert(reloadImages, (isPixel and 'pixelUI/' or '') .. langInfo.path .. rating .. (isPixel and '-pixel' or ''))
		end
	end
	runHaxeCode([[
		import openfl.utils.Assets;
		for (img in images) {
			var imgPath = 'images/' + img + '.png';
			if (Paths.currentTrackedAssets.exists(imgPath)) {
				var asset = Paths.currentTrackedAssets.get(imgPath);
				Paths.currentTrackedAssets.remove(imgPath);
				Assets.cache.removeBitmapData(imgPath);
				FlxG.bitmap._cache.remove(imgPath);
				asset.destroy();
			}
			Paths.image(img);
		}
	]], {images = reloadImages})
end
function initLang(lang)
	langInfo = langs[lang]
	if langInfo then
		for i, rating in ipairs(langInfo.ratings) do
			local newGraphic = langInfo.path .. rating
			setProperty('ratingsData[' .. (i - 1) .. '].image', newGraphic)
		end
		reloadLangGraphics()
	end
end