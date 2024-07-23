function onCreate()
	makeLuaSprite('background', 'Sage_Bg', 100, 440)
    scaleObject('background', 4.3, 4.3);
    addLuaSprite('background', false)

    makeLuaSprite('someNew', 'someNew')
    screenCenter("someNew", 'xy')
    scaleObject('someNew', 45, 45)
    setObjectCamera("someNew", 'game')
    setProperty('someNew.alpha', 0)
    addLuaSprite("someNew", true)

    makeLuaSprite('sagebar', 'Sage-healthbar', 300, 630)
    scaleObject('sagebar', 2, 2);
    setObjectCamera('sagebar', 'other')
    addLuaSprite('sagebar', true)

    makeAnimatedLuaSprite('gf', 'GfTv', 0, 0);
	addAnimationByPrefix('gf', 'Idle', 'iddle', 24, true);
    addAnimationByPrefix('gf', 'heart', 'hearth', 24, true);
    scaleObject('gf', 2.5, 2.5);
    setObjectCamera('gf', 'hud')
	objectPlayAnimation('gf','Idle',true)
    addLuaSprite('gf', true)

end

function onStepHit() 
    if curStep == 896 then       
        doTweenAlpha('disappear', 'camHUD', 0, 1, linear)
        doTweenAlpha("someNew", "someNew", 1, 1, linear)
        doTweenAlpha("badboysbadboys", "sagebar", 0, 1, linear)
    end
        
    if curStep == 1152 then
        cameraFlash('game', 'FFFFFF', 1, true)
        setProperty('someNew.alpha', 0)
        setProperty('sagebar.alpha', 1) -- ok firemaster why the fuck did you set the bar on the other cam im losing myself
        setProperty('background.alpha', 0.7)
        setCharacterY("dad", 690)
    end
end

function onUpdatePost()
cameraSetTarget('dad')
setProperty('healthBarBG.visible', false)
setProperty('healthBar.scale.x', 1.05)
setProperty('healthBar.scale.y', 3)
for i=0,3 do
    setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
    setPropertyFromGroup('opponentStrums', i, 'x', -9999)
end
setProperty('iconP2.visible', false)
setProperty('iconP1.visible', false)
setProperty('healthBar.x', 329)
setProperty('healthBar.y', 650)
setProperty('scoreTxt.x', 9999)
end