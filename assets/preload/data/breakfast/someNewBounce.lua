local jumpactive = 0
local reverser = 1
function onUpdate()
if curSection >= 60 then
		songPos = getSongPosition()
		local b = songPos / 1000 * bpm / 120
		local boingy = math.abs(math.sin(b * 2 * math.pi))
		local jumpy = 25*math.sin(b * math.pi * 2 )
				
		for i = 4,7 do
			noteTweenAngle('rotatnotes' .. i, i, jumpy*reverser, 0.01)
			reverser = reverser * -1
		end
		
		noteTweenY('boingy1', 4, defaultPlayerStrumY0-math.abs(jumpy), 0.01)
		noteTweenY('boingy2', 5, defaultPlayerStrumY1-math.abs(jumpy), 0.01)
		noteTweenY('boingy3', 6, defaultPlayerStrumY2-math.abs(jumpy), 0.01)
		noteTweenY('boingy4', 7, defaultPlayerStrumY3-math.abs(jumpy), 0.01)
		end
end

function onCreatePost()
	setProperty('camHUD.alpha', 0)

setTextString('botplayTxt', "WAY PAST UNCOOL!!!")
setTextFont('botplayTxt', "sonic2.ttf")
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