function onCreatePost()
	makeLuaSprite('xed', 'paint', 0, 0);
addLuaSprite('xed', false);
setObjectCamera("xed", "other");
scaleObject('xed', 0.94,0.94);
		--setProperty('camHUD.x',-50)
		setProperty('camHUD.y', 30)
end
function onUpdatePost()
		setProperty('camOther.zoom',1.0)
		setProperty('camHUD.zoom',0.73)
		setProperty('camGame.zoom',0.8)
end