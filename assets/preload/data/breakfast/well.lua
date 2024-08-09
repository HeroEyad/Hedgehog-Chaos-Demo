function onCreatePost()
	setProperty('camHUD.alpha', 0)
end

function onStepHit()
if curStep == 127 then
doTweenAlpha('huh', 'camHUD', 1, 0.2, quartIn)
cameraSetTarget('dad')
end
if curStep == 640 then
doTweenAlpha('huh', 'camHUD', 0, 2.5, quartOut)
end
if curStep == 704 then 
doTweenAlpha('huh', 'camHUD', 1, 0.5, quartIn)
end
if curStep == 960 then
cameraFlash('hud', 'FFFFFF', 0.5, true)
end
if curStep == 1215 then
doTweenAlpha('huh', 'camHUD', 0, 1, quartOut)
end
end