inResults = false
curRank = 'Null'

local canEnd = false
local bfNameJustInCase = 'B.F'
function onCreate()
	--Basically, making everything

	makeLuaSprite('bg', 'resultsmenu/bg')
	setObjectCamera('bg', 'other')
	--setGraphicSize('bg', screenWidth, screenHeight)
	scaleObject('bg', 1, 1)
	setObjectAntialiasing('bg', false)

	makeLuaSprite('separator', 'resultsmenu/separator', 600)
	setObjectCamera('separator', 'other')

	makeLuaSprite('circle', 'resultsmenu/circle')
	setObjectCamera('circle', 'other')
	setObjectAntialiasing('circle', false)
	screenCenter('circle')
	setProperty('circle.x', screenWidth)
	setProperty('circle.y', getProperty('circle.y')-100)

	makeLuaText('bfPassed', bfNameJustInCase..' Has\n\nPassed', 0)
	setObjectCamera('bfPassed', 'other')
	setTextAlignment('bfPassed', 'Left')
	setTextFont('bfPassed', 'sonic-1-title-card.ttf')
	setTextSize('bfPassed', 50)
	setProperty('bfPassed.x', screenWidth)
	setProperty('bfPassed.y', getProperty('circle.y')+50)

	makeLuaText('finalScore', '', 0, -200, 400)
	setObjectCamera('finalScore', 'other')
	setTextAlignment('finalScore', 'Left')
	setTextColor('finalScore', 'FFFF00')
	setTextFont('finalScore', 'sonic-cd-menu-font.ttf')

	makeAnimatedLuaSprite('rank', 'resultsmenu/Cock_And_Ball_torture')
	setObjectCamera('rank', 'other')
	scaleObject('rank', 0.3, 0.3)
	--Adding the ranks here
	addAnimationByPrefix('rank', 'S', 'S rank Bop', 24, true)
	addAnimationByPrefix('rank', 'A', 'A rank', 24, true)
	addAnimationByPrefix('rank', 'B', 'B rank', 24, true)
	addAnimationByPrefix('rank', 'F', 'SHITHEAD Rank', 24, true)
	addAnimationByPrefix('rank', 'Null', 'what fucking rank is this', 24, true)
	setProperty('rank.y', (screenHeight-getProperty('rank.height'))+10)

	makeAnimatedLuaSprite('bfRank', 'resultsmenu/bfRanks/BfSRank')
	addAnimationByPrefix('bfRank', 'idle', 'Thingy', 24, true)
	setObjectCamera('bfRank', 'other')
	scaleObject('bfRank', 0.4, 0.4)
	setProperty('bfRank.x', (screenWidth-getProperty('bfRank.width'))-10)
	setProperty('bfRank.y', (screenHeight-getProperty('bfRank.height')))

	makeLuaText('infoTxt', 'Press R for restart the song. | Press Enter for finish song.', 0, 5)
	setObjectCamera('infoTxt', 'other')
	setTextAlignment('infoTxt', 'Left')
	setTextFont('infoTxt', 'vcr.ttf')
	setProperty('infoTxt.y', screenHeight-(getTextSize('infoTxt')+5))
end

function onEndSong()
	inResults = true
	if not canEnd then
		recalculateRank()

		addLuaSprite('bg', true)
		setProperty('bg.visible', false)
		addLuaSprite('separator', true)
		addLuaSprite('circle', true)
		addLuaText('bfPassed')
		addLuaText('finalScore')
		addLuaText('infoTxt')
		setProperty('infoTxt.alpha', 0)
		doTweenAlpha('hfafuffafafsdfasfa', 'infoTxt', 1, 2, 'linear')

		playSound('songCompleted', 1)

		doTweenX('Xcircle', 'circle', 409, 0.7, 'linear')
		runTimer('NEXT', 0.5)
		runTimer('OHWOW', 5.5)
		return Function_Stop
	else
		return Function_Continue
	end
end

function onUpdatePost()
	if inResults then
		if keyJustPressed('accept') then
			canEnd = true
			endSong()
		end
		if keyJustPressed('reset') then
			restartSong()
		end
	end
	if keyboardJustPressed('SPACE') then
		debugPrint('circle: ', getProperty('circle.x'), ' ', getProperty('circle.y'))
		debugPrint('bfPassed: ', getProperty('bfPassed.x'), ' ', getProperty('bfPassed.y'))
		debugPrint('separator: ', getProperty('separator.x'), ' ', getProperty('separator.y'))
		debugPrint('finalScore: ', getProperty('finalScore.x'), ' ', getProperty('finalScore.y'))
	end
end

function recalculateRank()
	accuracy = math.floor(rating*10000)/100

	if stringEndsWith(ratingFC, 'FC') then
		curRank = 'S'
	elseif accuracy > 100 then
		curRank = 'A'
	elseif accuracy > 80 then
		curRank = 'B'
	elseif accuracy > 30 then
		curRank = 'F'
	else
		curRank = 'Null'
	end

	--SCORE UPDATING LMAOOO
	setTextString('finalScore', 'Score: '..score)
end

function setObjectAntialiasing(object, antialias)
	setProperty(object..'.antialiasing', antialias)
	--debugPrint(object, ' antialiasing: ', antialias)
end

function onTimerCompleted(t)
	if t == 'NEXT' then
		doTweenX('XbfPassed', 'bfPassed', 259, 0.7, 'linear')
		runTimer('NEXT2', 0.5)
	end
	if t == 'NEXT2' then
		doTweenX('XfinalScore', 'finalScore', 200, 0.7, 'linear')
		runTimer('NEXT3', 0.5)
	end
	if t == 'NEXT3' then
		doTweenX('Xseparator', 'separator', 150, 0.7, 'linear')
	end
	if t == 'OHWOW' then
		cameraFlash('other', 'FFFFFF', 1, false)

		setProperty('bg.visible', true)
		addLuaSprite('rank', true)
		addLuaSprite('bfRank', true)
		playAnim('rank', curRank)
		playAnim('bfRank', 'idle')
	end
end