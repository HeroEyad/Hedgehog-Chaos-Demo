function onCreatePost()
	makeLuaSprite('aaa', 'nose', 0, -100);
addLuaSprite('aaa', false);
setObjectCamera("aaa", "other");
scaleObject('aaa', 1.25,1.25);
		setProperty('camHUD.x',-50)
		setProperty('camHUD.y', 30)
end
function onUpdatePost()
		setProperty('camOther.zoom',1.0)
		setProperty('camHUD.zoom',0.8)
		setProperty('camGame.zoom',0.6)
end