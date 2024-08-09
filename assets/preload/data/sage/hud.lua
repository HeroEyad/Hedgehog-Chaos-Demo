-- Function to create and initialize text elements
function onCreate()
    makeLuaText('s', '', 500, 10, 250)
    addLuaText('s')
    setTextAlignment('s', 'left')
    
    makeLuaText('i', '', 500, 10, 400)
    addLuaText('i')
    setTextAlignment('i', 'left')
	
	setTextFont('s', 'peppino.otf')
	setTextColor('s', 'FFFFFF')
	setTextSize('s', 32)
	
	setTextFont('i', 'peppino.otf')
	setTextColor('i', 'FFFFFF')
	setTextSize('i', 32)
	
	setTextFont('timeTxt', 'peppino.otf')
end

-- Function to update text elements with game statistics
function onUpdate()
    setTextString('s', string.format("Sick: %d\nGood: %d\nBad: %d\nShit: %d\nMisses: %d",
        getProperty('sicks'), getProperty('goods'), getProperty('bads'), getProperty('shits'), getProperty('songMisses')))
        
    setTextString('i', string.format("Accuracy: %.2f%% - %s\nRating: %s\nScore: %d",
        onRound(getProperty('ratingPercent') * 100, 2), getProperty('ratingName'), getProperty('ratingFC'), 
        getProperty('songScore'), onRoundTimer(getPropertyFromClass('Conductor', 'songPosition') - noteOffset)))
end

function onRound(x, n)
    local n = math.pow(10, n or 0)
    local x = x * n
    if x >= 0 then
        x = math.floor(x + 0.5)
    else
        x = math.ceil(x - 0.5)
    end
    return x / n
end

-- Function to convert milliseconds to a formatted time string (MM:SS)
function onRoundTimer(milliseconds)
    local totalseconds = math.floor(milliseconds / 1000)
    local seconds = totalseconds % 60
    local minutes = math.floor(totalseconds / 60) % 60
    return string.format("%02d:%02d", minutes, seconds)
end
