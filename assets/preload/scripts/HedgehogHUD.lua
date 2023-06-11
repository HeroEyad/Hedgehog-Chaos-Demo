local ShadowDrop = 70

function onCreatePost()
	noteTweenX("nose1", 0, -1090, 0.001, "linear")
    noteTweenX("nose2", 1, -1090, 0.001, "linear")
    noteTweenX("nose3", 2, -1090, 0.001, "linear")
    noteTweenX("nose4", 3, -1090, 0.001, "linear")
	
    setProperty('healthBar.x', 500)
    setProperty('healthBarBG.x', 500)
    setProperty('scoreTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
	
	setObjectOrder('HB', 4)
	setObjectOrder('healthBar', 3)
	setObjectOrder('healthBarBG', 2)

    quickLuaText('score', 'SCORE', 0, -1200, 520, 60, 'HUD.ttf')
    setTextColor('score', 'fcfc00')
    quickLuaText('scoreColon', ':', 0, getProperty('score.x') + 160, getProperty('score.y'), 60, 'HUD.ttf')
    quickLuaText('score2', '', 0, getProperty('score.x') + 200, getProperty('score.y'), 60, 'HUD.ttf')

    setObjectOrder('score', 10)
    setObjectOrder('scoreColon', 11)
    setObjectOrder('score2', 12)

    setObjectCamera('score', 'hud')
    setObjectCamera('scoreColon', 'hud')
    setObjectCamera('score2', 'hud')

    quickLuaText('time', 'TIME', 0, getProperty('score.x'), getProperty('score.y') + 50, 60, 'HUD.ttf')
    setTextColor('time', 'fcfc00')
    quickLuaText('timeColon', ':', 0, getProperty('score.x') + 160, getProperty('score.y') + 50, 60, 'HUD.ttf')
    quickLuaText('time2', '00:00', 0, getProperty('score.x') + 200, getProperty('score.y') + 50, 60, 'HUD.ttf')

    setObjectOrder('time', 13)
    setObjectOrder('timeColon', 14)
    setObjectOrder('time2', 15)

    setObjectCamera('time', 'hud')
    setObjectCamera('timeColon', 'hud')
    setObjectCamera('time2', 'hud')

    quickLuaText('combo', 'COMBO', 0, getProperty('score.x'), getProperty('time.y') + 50, 60, 'HUD.ttf')
    setTextColor('combo', 'fcfc00')
    quickLuaText('comboColon', ':', 0, getProperty('score.x') + 160, getProperty('time.y') + 50, 60, 'HUD.ttf')
    quickLuaText('combo2', '', 0, getProperty('score.x') + 200, getProperty('time.y') + 50, 60, 'HUD.ttf')

    setObjectOrder('combo',16)
    setObjectOrder('comboColon', 17)
    setObjectOrder('combo2', 18)

    setObjectCamera('combo', 'hud')
    setObjectCamera('comboColon', 'hud')
    setObjectCamera('combo2', 'hud')
	
	
	
	if downscroll then
        setProperty('HB.y', 540)
    end
end

local hitNote = false

function goodNoteHit(id, direction, noteType, isSustainNote)
hitNote = true
end

function noteMiss(id, direction, noteType, isSustainNote)
hitNote = true
end

local currentAccuracyRating = 0

function onUpdatePost()
	setProperty('iconP2.x', 380)
	setProperty('iconP2.y', 550)
	setProperty('iconP1.x', 1080)
	setProperty('iconP1.y', 560)
    setTextString('score2', getProperty('songScore'))

    setTextString('combo2', getProperty('combo'))
	
	--Accuracy Rating System--
	if hitNote == true then
		if getProperty('ratingPercent') == 1 then
		setTextString('AccuracyRating', 'PERFECT!!!')
		end
		if getProperty('ratingPercent') >= 0.9 and getProperty('ratingPercent') < 1 then
		setTextString('AccuracyRating', 'SICK!')
		end
		if getProperty('ratingPercent') >= 0.7 and getProperty('ratingPercent') < 0.9 then
		setTextString('AccuracyRating', 'Good')
		end
		if getProperty('ratingPercent') >= 0.4 and getProperty('ratingPercent') < 0.7 then
		setTextString('AccuracyRating', 'Not Bad')
		end
		if getProperty('ratingPercent') >= 0.1 and getProperty('ratingPercent') < 0.4 then
		setTextString('AccuracyRating', 'Bad')
		end
		if getProperty('ratingPercent') < 0.1 then
		setTextString('AccuracyRating', 'Shitty...')
		end
	end
	--End of Accuracy Rating System--
	if not botPlay then
	setTextString('AccuracyText', getProperty('ratingPercent'))
	end
	if botPlay then
	setTextString('AccuracyText', '')
	setTextString('AccuracyRating', 'BOTPLAY')
	end

    if curStep > 0 then
        setTextString('time2', milliToHuman(math.floor(getPropertyFromClass('Conductor', 'songPosition') - noteOffset)))
    end
        setProperty('score.y', 20)
        setProperty('scoreColon.y', getProperty('score.y'))
        setProperty('score2.y', getProperty('score.y'))

        setProperty('time.y', getProperty('score.y') + 50)
        setProperty('timeColon.y', getProperty('score.y') + 50)
        setProperty('time2.y', getProperty('score.y') + 50)

        setProperty('combo.y', getProperty('time.y') + 50)
        setProperty('comboColon.y', getProperty('time.y') + 50)
        setProperty('combo2.y', getProperty('time.y') + 50)
end

function onCreate()
makeLuaSprite('HB', 'HUD/Healthbar', 350, 379)
setObjectCamera('HB', 'hud')
setScrollFactor('HB', 0.9, 0.9)
scaleObject('HB', 0.9, 0.8)

makeLuaSprite('AccuracyBar', 'HUD/Accuracy Bar', -500, 479) --X = -10
setObjectCamera('AccuracyBar', 'hud')
setScrollFactor('AccuracyBar', 0.9, 0.9)
scaleObject('AccuracyBar', 0.2, 0.2)

addLuaSprite('AccuracyBar', true)

makeLuaSprite('Life', 'HUD/Life Counter', 10, 590)
setObjectCamera('Life', 'hud')
setScrollFactor('Life', 0.9, 0.9)
scaleObject('Life', 0.18, 0.18)
addLuaSprite('Life', true)

makeLuaSprite('LifeIcon', 'icons/LifeCounterIcons/bf', 20, 609)
setObjectCamera('LifeIcon', 'hud')
setScrollFactor('LifeIcon', 0.9, 0.9)
scaleObject('LifeIcon', 0.64, 0.64)
addLuaSprite('LifeIcon', true)

if songName == 'chillidogs' then
removeLuaSprite('LifeIcon', true)
makeLuaSprite('LifeIcon', 'icons/LifeCounterIcons/boifend', 26, 606)
setObjectCamera('LifeIcon', 'hud')
setScrollFactor('LifeIcon', 0.9, 0.9)
scaleObject('LifeIcon', 0.64, 0.64)
addLuaSprite('LifeIcon', true)
end
if songName == 'personel' then
removeLuaSprite('LifeIcon', true)
makeLuaSprite('LifeIcon', 'icons/LifeCounterIcons/bfcold', 25, 606)
setObjectCamera('LifeIcon', 'hud')
setScrollFactor('LifeIcon', 0.9, 0.9)
scaleObject('LifeIcon', 0.64, 0.64)
addLuaSprite('LifeIcon', true)
end

makeLuaText('AccuracyText', getProperty('ratingPercent'), 300, -500, 518) --X = 90
setObjectCamera('AccuracyText', 'hud')
setScrollFactor('AccuracyText', 0.9, 0.9)
setTextSize('AccuracyText', 14)
setTextAlignment('AccuracyText', 'right')
addLuaText('AccuracyText')
setTextFont('AccuracyText', 'sonic2.ttf')
setTextColor('AccuracyText', 'FFFFFF')

makeLuaText('AccuracyRating', '? ? ?', 300, -500, 524) --X = 100
setObjectCamera('AccuracyRating', 'hud')
setScrollFactor('AccuracyRating', 0.9, 0.9)
setTextSize('AccuracyRating', 35)
setTextAlignment('AccuracyRating', 'left')
addLuaText('AccuracyRating')
setTextFont('AccuracyRating', 'HUD.ttf')
setTextColor('AccuracyRating', 'fcfc00')

setProperty('AccuracyText.antialiasing', false)
setProperty('AccuracyRating.antialiasing', false)

runTimer('3', 0.1) --4
runTimer('2', 0.2) --4.5
runTimer('1', 0.3) --5
runTimer('Accuracy1', 0.8)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == '3' then
        doTweenX('scoreGoesIn', 'score', 20, 0.3, 'cubeOut')
        doTweenX('scoreColonGoesIn', 'scoreColon', 20 + 160, 0.4, 'cubeOut')
        doTweenX('score2GoesIn', 'score2', 20 + 200, 0.4, 'cubeOut')
    elseif tag == '2' then
        doTweenX('timeGoesIn', 'time', 20, 0.3, 'cubeOut')
        doTweenX('timeColonGoesIn', 'timeColon', 20 + 160, 0.4, 'cubeOut')
        doTweenX('time2GoesIn', 'time2', 20 + 200, 0.4, 'cubeOut')
    elseif tag == '1' then
        doTweenX('comboGoesIn', 'combo', 20, 0.3, 'cubeOut')
        doTweenX('comboColonGoesIn', 'comboColon', 20 + 160, 0.4, 'cubeOut')
        doTweenX('combo2GoesIn', 'combo2', 20 + 200, 0.4, 'cubeOut')
    end
	if tag == 'Accuracy1' then
    doTweenX('AccuracyGoesIn', 'AccuracyBar', -10, 0.8, 'cubeOut')
	doTweenX('AccuracyRatingGoesIn', 'AccuracyRating', 100, 0.77, 'cubeOut')
	doTweenX('AccuracyTextGoesIn', 'AccuracyText', 90, 0.77, 'cubeOut')
	if botPlay then
	doTweenX('AccuracyRatingGoesIn', 'AccuracyRating', 140, 0.77, 'cubeOut')
	end
	end
end

function quickLuaSprite(tag, image, x, y)
    makeLuaSprite(tag, image, x, y);
	addLuaSprite(tag);
end

function quickLuaText(tag, text, width, x, y, size, font)
    makeLuaText(tag, text, width, x, y);
    setTextSize(tag, size)
    setTextFont(tag, font)
	addLuaText(tag);
end

function milliToHuman(milliseconds) -- https://forums.mudlet.org/viewtopic.php?t=3258
	local totalseconds = math.floor(milliseconds / 1000)
	local seconds = totalseconds % 60
	local minutes = math.floor(totalseconds / 60)
	minutes = minutes % 60
	return string.format("%02d:%02d", minutes, seconds)  
end