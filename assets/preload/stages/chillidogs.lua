function onCreate()
makeLuaSprite('TMclouds', 'TMclouds', -500, -200) ;
setScrollFactor('TMclouds', 1, 1);
scaleLuaSprite('TMclouds', 1, 1);
addLuaSprite('TMclouds', false);

makeLuaSprite('TMtree', 'TMtree', -500, -200) ;
setScrollFactor('TMtree', 1, 1);
scaleLuaSprite('TMtree', 1, 1);
addLuaSprite('TMtree', false);

makeLuaSprite('TMground', 'TMground', -500, -200) ;
setScrollFactor('TMground', 1, 1);
scaleLuaSprite('TMground', 1, 1);
addLuaSprite('TMground', false);

end

function onUpdate()
doTweenX('TMcloudsIN', 'TMclouds', 1000, 1, 'SineInOut', 'PINGPONG')
end