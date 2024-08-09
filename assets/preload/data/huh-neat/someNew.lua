function onCreatePost()

    makeLuaSprite('someNew', 'someNew')
    screenCenter("someNew", 'xy')
    scaleObject('someNew', 45, 45)
    setObjectCamera("someNew", 'other')
    setProperty('someNew.visible', false)
    addLuaSprite("someNew", true)
	
	setProperty('camHUD.alpha', 0)

setTextString('botplayTxt', "WAY PAST UNCOOL!!!")
setTextFont('botplayTxt', "sonic2.ttf")

end


function onStepHit()
if curStep == 120 then
doTweenAlpha('huh', 'camHUD', 1, 0.5, linear)
cameraSetTarget('dad')
end
if curStep == 368 then 
cameraSetTarget('dad')
end
if curStep == 895 then
doTweenAlpha('huh', 'camHUD', 0, 5, quartOut)
end

if curStep == 959 then
setProperty('someNew.visible', true)
end
end