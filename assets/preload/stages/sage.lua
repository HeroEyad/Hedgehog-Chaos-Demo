function onCreate()
	makeLuaSprite('background', 'Sage_Bg', 100, 440)
    scaleObject('background', 4.2, 4.2);
    addLuaSprite('background', false)

    makeAnimatedLuaSprite('gf', 'GfTv', 0, 0);
	addAnimationByPrefix('gf', 'Idle', 'iddle', 24, true);
    addAnimationByPrefix('gf', 'heart', 'hearth', 24, true);
    scaleObject('gf', 2.5, 2.5);
    setObjectCamera('gf', 'hud')
	objectPlayAnimation('gf','Idle',true)
    addLuaSprite('gf', true)

    makeAnimatedLuaSprite('peppino', 'Peppino sage animations', 1600, 200);
	addAnimationByPrefix('peppino', 'Idle', 'idle 1', 24, true);
    addAnimationByPrefix('peppino', 'huh', 'idle 2', 24, true);
	objectPlayAnimation('peppino','Idle',true)
    addLuaSprite('peppino', false)

    makeAnimatedLuaSprite('snickicon', 'SnickIcon', 540, 640);
    scaleObject('snickicon', 2, 2);
	addAnimationByPrefix('snickicon', 'Idle', '', 24, true);
	objectPlayAnimation('snickicon','Idle',true)
    setObjectCamera('snickicon', 'hud')
    addLuaSprite('snickicon', true)

    makeAnimatedLuaSprite('bficon', 'BfIcon',  640, 640);
    scaleObject('bficon', 2, 2);
	addAnimationByPrefix('bficon', 'Idle', '', 24, true);
	objectPlayAnimation('bficon','Idle',true)
    setObjectCamera('bficon', 'hud')
    addLuaSprite('bficon', true)
end

function onUpdatePost()
    cameraSetTarget('dad')
    P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
	P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    for i=0,3 do
        setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
        setPropertyFromGroup('opponentStrums', i, 'x', -9999)
    end
    setProperty('iconP2.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('scoreTxt.x', 9999)
    setProperty('bficon.x',P1Mult - 110)
    setProperty('snickicon.x',P2Mult + 110)
end