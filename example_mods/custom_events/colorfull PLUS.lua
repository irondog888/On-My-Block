----------------------------------------------------------------------------------------------------------------------------
							--V1.3
                                                     -------------------
                                                 -- [[ made by StasLk2 ]] --
                                                     -------------------

----------------------------------------------------------------------------------------------------------------------------
function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end
function setColorTransform(obj,RM,GM,BM,R,G,B)
	setProperty(obj..'.colorTransform.redMultiplier',RM)
	setProperty(obj..'.colorTransform.greenMultiplier',GM)
	setProperty(obj..'.colorTransform.blueMultiplier',BM)
	setProperty(obj..'.colorTransform.redOffset',R)
	setProperty(obj..'.colorTransform.greenOffset',G)
	setProperty(obj..'.colorTransform.blueOffset',B)
end
function doTweenColorTransform(lua,obj,RM,GM,BM,R,G,B,time,ease)
	if lua then
	runHaxeCode([[
		FlxTween.tween(game.getLuaObject(']]..obj..[[').colorTransform,{redOffset:]]..R..[[,greenOffset:]]..G..[[,blueOffset:]]..B..[[,redMultiplier:]]..RM..[[,greenMultiplier:]]..GM..[[,blueMultiplier:]]..BM..[[},]]..time..[[,{ease:FlxEase.]]..ease..[[})
	]])
	else
	runHaxeCode([[
		FlxTween.tween(game.]]..obj..[[.colorTransform,{redOffset:]]..R..[[,greenOffset:]]..G..[[,blueOffset:]]..B..[[,redMultiplier:]]..RM..[[,greenMultiplier:]]..GM..[[,blueMultiplier:]]..BM..[[},]]..time..[[,{ease:FlxEase.]]..ease..[[})
	]])
	end
end

local unitedValues = {bg=true,bgR=0,bgG=0,bgB=0,alpha=1,bgAlpha=1,mode='set',tag='tweenTimer',lua=false,obj='all',RM=1,GM=1,BM=1,R=1,G=1,B=1,time=16,ease='linear'}
local numberTable = {'RM','GM','BM','R','G','B','time',alpha,bgAlpha,bgR=0,bgG=0,bgB=0}
local boolTable = {'lua','bg'}
function loadColorValues(v1,v2)
	tableV1 = stringSplit(v1,',')
	for i = 1,#tableV1 do
		_G['tableV1'..i] = stringSplit(tableV1[i],'=')
		for j = 1,#numberTable do if _G['tableV1'..i][1] == numberTable[j] then _G['tableV1'..i][2] = tonumber(_G['tableV1'..i][2]) end end
		for j = 1,#boolTable do if _G['tableV1'..i][1] == boolTable[j] and _G['tableV1'..i][2] == 'true' then _G['tableV1'..i][2] = true
		elseif _G['tableV1'..i][1] == boolTable[j] and _G['tableV1'..i][2] == 'false' then _G['tableV1'..i][2] = false end end
		unitedValues[_G['tableV1'..i][1]] = _G['tableV1'..i][2]
	end
	tableV2 = stringSplit(v2,',')
	for i = 1,#tableV2 do
		_G['tableV2'..i] = stringSplit(tableV2[i],'=')
		for j = 1,#numberTable do if _G['tableV2'..i][1] == numberTable[j] then _G['tableV2'..i][2] = tonumber(_G['tableV2'..i][2]) end end
		for j = 1,#boolTable do if _G['tableV2'..i][1] == boolTable[j] and _G['tableV2'..i][2] == 'true' then _G['tableV2'..i][2] = true
		elseif _G['tableV2'..i][1] == boolTable[j] and _G['tableV2'..i][2] == 'false' then _G['tableV2'..i][2] = false end end
		unitedValues[_G['tableV2'..i][1]] = _G['tableV2'..i][2]
	end
end

local allCharacters = {'dad','gf','boyfriend'}
local appleHasBG = false
function onEvent(name,v1,v2)
if name == 'colorfull PLUS' then
	loadColorValues(v1,v2)
	if unitedValues['mode'] == 'set' then
	if unitedValues['obj'] == 'all' then
		for i = 1,#allCharacters do
		setColorTransform(allCharacters[i],unitedValues['RM'],unitedValues['GM'],unitedValues['BM'],unitedValues['R'],unitedValues['G'],unitedValues['B'])
		setProperty(allCharacters[i]..'.alpha',unitedValues['alpha'])
		end
	else
		setColorTransform(unitedValues['obj'],unitedValues['RM'],unitedValues['GM'],unitedValues['BM'],unitedValues['R'],unitedValues['G'],unitedValues['B'])
		setProperty(unitedValues['obj']..'.alpha',unitedValues['alpha'])
	end
	if unitedValues['bg'] then
		appleHasBG = true
		setColorTransform('goodApleBG',0,0,0,unitedValues['bgR'],unitedValues['bgG'],unitedValues['bgB'])
		setProperty('goodApleBG.alpha',unitedValues['bgAlpha'])
		addLuaSprite('goodApleBG')
	elseif unitedValues['bg'] == false then
		appleHasBG = false
		removeLuaSprite('goodApleBG',false)
	end
	end
	if unitedValues['mode'] == 'tween' then
	if unitedValues['obj'] == 'all' then
		for i = 1,#allCharacters do
		doTweenColorTransform(false,allCharacters[i],unitedValues['RM'],unitedValues['GM'],unitedValues['BM'],unitedValues['R'],unitedValues['G'],unitedValues['B'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		doTweenAlpha(unitedValues['tag']..i,allCharacters[i],unitedValues['alpha'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		end
	else
		doTweenColorTransform(unitedValues['lua'],unitedValues['obj'],unitedValues['RM'],unitedValues['GM'],unitedValues['BM'],unitedValues['R'],unitedValues['G'],unitedValues['B'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		doTweenAlpha(unitedValues['tag'],unitedValues['obj'],unitedValues['alpha'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
	end
	if unitedValues['bg'] then
		if appleHasBG then
			doTweenColorTransform(true,'goodApleBG',0,0,0,unitedValues['bgR'],unitedValues['bgG'],unitedValues['bgB'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
			doTweenAlpha('goodApleBG alpha tween'..getSongPosition(),'goodApleBG',unitedValues['bgAlpha'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		end
		if appleHasBG == false then
			cancelTween('remove goodApleBG')
			setColorTransform('goodApleBG',0,0,0,unitedValues['bgR'],unitedValues['bgG'],unitedValues['bgB'])
			setProperty('goodApleBG.alpha',0)
			addLuaSprite('goodApleBG')
			doTweenAlpha('goodApleBG alpha tween'..getSongPosition(),'goodApleBG',unitedValues['bgAlpha'],unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		end
		appleHasBG = true
	elseif unitedValues['bg'] == false then
		if appleHasBG then
			doTweenAlpha('remove goodApleBG','goodApleBG',0,unitedValues['time']*stepCrochet*0.001,unitedValues['ease'])
		end
		appleHasBG = false
	end
	end
end
end

function onTimerCompleted(tag)
	if tag == 'remove goodApleBG' then
		removeLuaSprite('goodApleBG',false)
	end
end

function onCreatePost()
	makeLuaSprite('goodApleBG',nil,0,0)
	makeGraphic('goodApleBG',16,9,'000000')
	setColorTransform('goodApleBG',0,0,0,unitedValues['bgR'],unitedValues['bgG'],unitedValues['bgB'])
	setScrollFactor('goodApleBG',0,0)
	scaleObject('goodApleBG',81/getProperty('camGame.zoom'),81/getProperty('camGame.zoom'))
	screenCenter('goodApleBG','xy')
end

function onUpdate(elapsed)
	scaleObject('goodApleBG',81/getProperty('camGame.zoom'),81/getProperty('camGame.zoom'))
	screenCenter('goodApleBG','xy')
--debugPrint(unitedValues)
end