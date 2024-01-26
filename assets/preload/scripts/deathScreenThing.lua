local circleOffsets = {460, 450} --X, Y
local gameOverTextOffsets = {410, 80} --X, Y

function onGameOverStart()
	makeLuaSprite('Pcircle', 'death/purple_circle', circleOffsets[1], circleOffsets[2])
	addLuaSprite('Pcircle', false)
	scaleObject('Pcircle', 0.5, 0.5)

	makeLuaSprite('gameText', 'death/GAME', (gameOverTextOffsets[1])-500, gameOverTextOffsets[2])
	addLuaSprite('gameText', false)
	scaleObject('gameText', 0.3, 0.3)

	makeLuaSprite('overText', 'death/OVER', ((gameOverTextOffsets[1]+getProperty('gameText.width'))+20)+500, gameOverTextOffsets[2])
	addLuaSprite('overText', false)
	scaleObject('overText', 0.3, 0.3)

	doTweenX('gametween', 'gameText', gameOverTextOffsets[1], 0.2, 'linear')
	doTweenX('overtween', 'overText', (gameOverTextOffsets[1]+getProperty('gameText.width'))+20, 0.2, 'linear')

	if songName == 'breakfast' then
		startVideo('sunkover')
	end
end