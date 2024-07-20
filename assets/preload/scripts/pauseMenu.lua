--you shouldn't touch anything bro
-- shut the fuck up.

local curSelected = 0

function onCreatePost()
    makeLuaSprite('bgalpha')
    makeGraphic('bgalpha', screenWidth, screenHeight, '000000')
    setObjectCamera('bgalpha', 'other')
    setProperty('bgalpha.alpha', 0.6)

    makeLuaSprite('pauseText', 'pauseAssets/Pause_line', 0, 0)
    setObjectCamera('pauseText', 'other')
    setGraphicSize('pauseText', screenWidth, screenHeight)
    setProperty('pauseText.antialiasing', false)

    makeLuaSprite('separator', 'pauseAssets/Pause_triangol', 0, 0)
    setObjectCamera('separator', 'other')
    setGraphicSize('separator', screenWidth, screenHeight)
    setProperty('separator.antialiasing', false)

    makeLuaSprite('resume', 'pauseAssets/Continue', 0, 0)
    setObjectCamera('resume', 'other')
    scaleObject('resume', 0.7, 0.7)
    setProperty('resume.antialiasing', false)

    makeLuaSprite('restart', 'pauseAssets/Restart', 0, 0)
    setObjectCamera('restart', 'other')
    scaleObject('restart', 0.7, 0.7)
    setProperty('restart.antialiasing', false)

    makeLuaSprite('exit', 'pauseAssets/Exit', 0, 0)
    setObjectCamera('exit', 'other')
    scaleObject('exit', 0.7, 0.7)
    setProperty('exit.antialiasing', false)

    makeAnimatedLuaSprite('minisonic', 'pauseAssets/Mini Sonic', 0, 0)
    addAnimationByPrefix('minisonic', 'idle1', 'waiting0000', 1, true)
    addAnimationByPrefix('minisonic', 'idle2', 'waiting0001', 1, true)
    addAnimationByPrefix('minisonic', 'start', 'start', 10, true)
    setObjectCamera('minisonic', 'other')
    scaleObject('minisonic', 2.5, 2.5)
    setProperty('minisonic.antialiasing', false)

    setProperty('resume.y', screenHeight/5)
    setProperty('restart.y', screenHeight/2.25)
    setProperty('exit.y', screenHeight/1.43)

    setProperty('resume.x', 980)
    setProperty('restart.x', 995)
    setProperty('exit.x', 1050)
end

function onCustomSubstateUpdate(n, e)
    if n == 'pauseMenu' then
        if curSelected == 2 then
            depende = 35
        else
            depende = 20
        end

        setProperty('minisonic.y', 140+(180*curSelected))
        setProperty('minisonic.x', 930+(depende*curSelected))

        if keyJustPressed('down') then
            changeSelection(1)

            if curSelected > 2 then
                curSelected = 0
            end
        end
        if keyJustPressed('up') then
            changeSelection(-1)

            if curSelected < 0 then
                curSelected = 2
            end
        end

        if keyJustPressed('accept') then
            if curSelected == 0 then
                closePause()
            elseif curSelected == 1 then
                restartSong()
            elseif curSelected == 2 then
                exitSong()
            end
        end
    end
end

function openPause()
    openCustomSubstate('pauseMenu', true)

    addLuaSprite('bgalpha', true)
    addLuaSprite('pauseText', true)
    addLuaSprite('separator', true)

    addLuaSprite('resume', true)
    addLuaSprite('restart', true)
    addLuaSprite('exit', true)

    addLuaSprite('minisonic', true)
    playAnim('minisonic', 'start', true)
    runTimer('woowaiting', 1, 1)
end

function closePause()
    closeCustomSubstate()

    removeLuaSprite('bgalpha', false)
    removeLuaSprite('pauseText', false)
    removeLuaSprite('separator', false)

    removeLuaSprite('resume', false)
    removeLuaSprite('restart', false)
    removeLuaSprite('exit', false)

    removeLuaSprite('minisonic', false)

    cancelTimer('woowaiting')
    cancelTimer('change1')
    cancelTimer('change2')
end

function changeSelection(change)
    curSelected = curSelected+change
end

--other things that you shouldn't touch frfr
function onPause()
    openPause()
    return Function_Stop
end

function onTimerCompleted(t)
    if t == 'woowaiting' then
        playAnim('minisonic', 'idle1', true)
        runTimer('change1', 0.5, 1)
    end
    if t == 'change1' then
        playAnim('minisonic', 'idle2', true)
        runTimer('change2', 0.5, 1)
    end
    if t == 'change2' then
        playAnim('minisonic', 'idle1', true)
        runTimer('change1', 0.5, 1)
    end
end