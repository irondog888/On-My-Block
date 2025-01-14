--[[local dadCamX = 0
local dadCamY = 0
local bfCamX = 0
local bfCamY = 0
local gfCamX = 0
local gfCamY = 0

function onCreate()
    setProperty('boyfriend.alpha',0)
    setProperty('defaultCamZoom',1.05)
    setProperty('camGame.zoom',1.05)
end

function onCreatePost() 
	--editing the values after the getProperty functions will edit the offset of the camera
	dadCamX = getProperty('dad.x') + 500
	dadCamY = getProperty('dad.y') + 250
	bfCamX = getProperty('boyfriend.x') + 150
	bfCamY = getProperty('boyfriend.y') + 100
	gfCamX = getProperty('gf.x') + 420
	gfCamY = getProperty('gf.y') + 200
	triggerEvent('Camera Follow Pos', gfCamX, gfCamY) 
	doTweenX('camFollow.x', 'camFollow', dadCamX, 1, 'quadInOut') 
	doTweenY('camFollow.y', 'camFollow', dadCamY, 1, 'quadInOut') 
end

function onStepHit()
    if curStep == 55 then
        doTweenAlpha('bfVisible','boyfriend',1,0.87,'quadIn')
        setProperty('defaultCamZoom',0.55)
        doTweenZoom('Zoom','game',0.55,0.87,'quadIn')
        doTweenX('camFollowX', 'camFollow', dadCamX, 0.87, 'quadIn')
        doTweenY('camFollowY', 'camFollow', dadCamY, 0.87, 'quadIn') 
    end
end

function onUpdate()
    if getPropertyFromClass("flixel.FlxG","keys.justPressed.SPACE") then
        local camX = getProperty('camGame.x')
        local camY = getProperty('camGame.y')
        debugPrint("Camera Position - X: " .. camX .. ", Y: " .. camY)
        debugPrint("Dad Camera Position - X: " .. dadCamX .. ", Y: " .. dadCamY)
    end
end]]