----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--Give credits if used, silly :3--Unless you want me to appear inside ur house at 4 AM--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

local screenshotMode = false
local hideSnapsHUD = false

local xAdd = 0
local yAdd = 0
local valToAdd = 15
local zoom = 0
local valZoom = 0.05

local currentTime = 0
local keepInPos = false

local songStarted = false

local stuff1 = "backend."
if (version <= "0.6.3") then
	stuff1 = ""
end

function onCreatePost()
	zoom = getProperty("defaultCamZoom")

	makeLuaText("screenshotDebug", "Screenshot Mode Enabled: FALSE", 1280, 20, 20)
	addLuaText("screenshotDebug", true)

	setObjectCamera("screenshotDebug", "camOther")
	setFormat("screenshotDebug", nil, "left", 24)
	setProperty("screenshotDebug.alpha", 0)

	makeLuaSprite("screenDebugBox", nil, 0, 55)
	makeGraphic("screenDebugBox", 300, 160, "000000")
	setProperty("screenDebugBox.alpha", 0.6)
	setProperty("screenDebugBox.visible", false)
	setObjectCamera("screenDebugBox", "camOther")
	addLuaSprite("screenDebugBox", true)

	makeLuaText("curX", "Current X: 0", 1280, 20, 80)
	addLuaText("curX", true)

	setObjectCamera("curX", "camOther")
	setFormat("curX", nil, "left", 24)
	setProperty("curX.visible", false)

	makeLuaText("curY", "Current Y: 0", 1280, 20, 120)
	addLuaText("curY", true)

	setObjectCamera("curY", "camOther")
	setFormat("curY", nil, "left", 24)
	setProperty("curY.visible", false)

	makeLuaText("curZoom", "Current Zoom: 0.9", 1280, 20, 160)
	addLuaText("curZoom", true)

	setObjectCamera("curZoom", "camOther")
	setFormat("curZoom", nil, "left", 24)
	setProperty("curZoom.visible", false)

	--fuck yeah
	makeLuaText("author", "Screenshot Mode made by Shiro", 1280, 20, 680)
	addLuaText("author", true)

	setObjectCamera("author", "camOther")
	setFormat("author", nil, "left", 24)
	setProperty("author.visible", false)
end

function onUpdatePost(elapsed)
	--enable and disable
	if keyboardJustPressed("G") then
		if screenshotMode == false then
			cancelTimer("byeDebug")
			cancelTween("byeDebugTxt")
			currentTime = getPropertyFromClass(stuff1 .. "Conductor", "songPosition")
			setProperty("screenshotDebug.alpha", 1)
			setTextString("screenshotDebug", "Screenshot Mode Enabled: TRUE")
			setProperty("screenDebugBox.visible", true)
			setProperty("curX.visible", true)
			setProperty("curY.visible", true)
			setProperty("curZoom.visible", true)
			setProperty("author.visible", true)
			if songStarted == true then
				runHaxeCode([[
					FlxG.sound.music.volume = 0;
				]])
				setProperty("vocals.volume", 0)
				setProperty("vocals.time", 0)
			end
			runTimer("byeDebug", 2)
			if curStep >= 1 then
				runTimer("setDebPos", 0.025)
			end
			setProperty("camHUD.visible", false)
			screenshotMode = true
		elseif screenshotMode == true then
			cancelTimer("byeDebug")
			cancelTween("byeDebugTxt")
			cancelTimer("setDebPos")
			setProperty("screenshotDebug.alpha", 1)
			setTextString("screenshotDebug", "Screenshot Mode Enabled: FALSE")
			setProperty("screenDebugBox.visible", false)
			setProperty("curX.visible", false)
			setProperty("curY.visible", false)
			setProperty("curZoom.visible", false)
			setProperty("author.visible", false)
			if songStarted == true then
				runHaxeCode([[
					FlxG.sound.music.volume = 1;
				]])
				setProperty("vocals.volume", 1)
				setProperty("vocals.time", currentTime)
			end
			runTimer("byeDebug", 2)
			if keepInPos == true then
				if songStarted == true then
					setPropertyFromClass(stuff1 .. "Conductor", "songPosition", currentTime)
					runHaxeCode([[
						FlxG.sound.music.time = ]] .. currentTime .. [[;
					]])
				end
				keepInPos = false
			end
			triggerEvent("Camera Follow Pos", "", "")
			setProperty("camGame.zoom", getProperty("defaultCamZoom"))
			setProperty("camHUD.visible", true)
			moveCam(0, 0)
			screenshotMode = false
			hideSnapsHUD = false
		end
	end

	--move
	if screenshotMode == true then
		if keepInPos == true then
			setPropertyFromClass(stuff1 .. "Conductor", "songPosition", 0)
			setProperty("vocals.time", 0)
		end
		setProperty("camZooming", false)
		setTextString("curX", "Current X: " .. math.ceil(xAdd * 1))
		setTextString("curY", "Current Y: " .. math.ceil(yAdd * 1))

		--controls the movement of the camera
		if keyboardPressed("SHIFT") then
			valToAdd = 30
		end
		if keyboardReleased("SHIFT") then
			valToAdd = 15
		end
		if keyboardPressed("W") then
			yAdd = yAdd - valToAdd / getProperty("camGame.zoom")
		end
		if keyboardPressed("A") then
			xAdd = xAdd - valToAdd / getProperty("camGame.zoom")
		end
		if keyboardPressed("S") then
			yAdd = yAdd + valToAdd / getProperty("camGame.zoom")
		end
		if keyboardPressed("D") then
			xAdd = xAdd + valToAdd / getProperty("camGame.zoom")
		end

		--hide hud to take screenshots lmao
		if keyboardJustPressed("V") then
			if hideSnapsHUD == false then
				setProperty("screenDebugBox.visible", false)
				setProperty("curX.visible", false)
				setProperty("curY.visible", false)
				setProperty("curZoom.visible", false)
				setProperty("author.visible", false)
				hideSnapsHUD = true
			elseif hideSnapsHUD == true then
				setProperty("screenDebugBox.visible", true)
				setProperty("curX.visible", true)
				setProperty("curY.visible", true)
				setProperty("curZoom.visible", true)
				setProperty("author.visible", true)
				hideSnapsHUD = false
			end
		end

		--to zoom
		if keyboardJustPressed("Z") then
			zoom = zoom + valZoom
		end
		if keyboardJustPressed("X") then
			zoom = zoom - valZoom
		end
		--resets everything technically
		if keyboardJustPressed("C") then
			xAdd = 0
			yAdd = 0
			zoom = getProperty("defaultCamZoom")
			setProperty("screenDebugBox.visible", true)
			setProperty("curX.visible", true)
			setProperty("curY.visible", true)
			setProperty("curZoom.visible", true)
			setProperty("author.visible", true)
			hideSnapsHUD = false
		end

		--to zoom (part 2 super short)
		setProperty("camGame.zoom", zoom)

		--zooming text
		setTextString("curZoom", "Current Zoom: " .. getProperty("camGame.zoom"))

		--basically to avoid crashes because of the zooming
		if zoom > 5 then
			zoom = 5
			setTextString("curZoom", "Current Zoom: 5")
			setProperty("camGame.zoom", 5)
		end
		if zoom < 0.1 then
			zoom = 0.1
			setTextString("curZoom", "Current Zoom: 0.1")
			setProperty("camGame.zoom", 0.1)
		end

		--moves the camera lol
		moveCam(xAdd, yAdd)
	end
end

function onSongStart()
	songStarted = true
	if screenshotMode == true then
		runHaxeCode([[
			FlxG.sound.music.volume = 0;
		]])
		setProperty("vocals.volume", 0)
		setProperty("vocals.time", 0)
		runTimer("setDebPos", 0.025)
	end
end

function onStepHit()
	if screenshotMode == true then
		runHaxeCode([[
			FlxG.sound.music.volume = 0;
		]])
		setProperty("vocals.volume", 0)
		setProperty("vocals.time", 0)
		runTimer("setDebPos", 0.025)
	end
end

function onEndSong()
	if screenshotMode == true then
		return Function_Stop;
	end
end

function onTimerCompleted(tag)
	if tag == "byeDebug" then
		doTweenAlpha("byeDebugTxt", "screenshotDebug", 0, 2, "linear")
	end
	if tag == "setDebPos" then
		setPropertyFromClass(stuff1 .. "Conductor", "songPosition", 0)
		setProperty("vocals.time", 0)
		keepInPos = true
		return updatePost(elapsed)
	end
end

function moveCam(x,y)
	setProperty("camGame.targetOffset.x", x)
	setProperty("camGame.targetOffset.y", y)
end

function setFormat(curTxt,font,align,size,color,bdSize,bdColor,bdType)
	if (font == nil) then
		font = "vcr.ttf"
	end
	if (bdSize == nil) then
		bdSize = 1.25
	end
	if (bdColor == nil) then
		bdColor = "000000"
	end
	if (bdType == nil) then
		bdType = "outline"
	end
	setTextFont(curTxt, font)
	setTextAlignment(curTxt, align)
	setTextSize(curTxt, size)
	setTextColor(curTxt, color)
	setTextBorder(curTxt, bdSize, bdColor, bdType)
end