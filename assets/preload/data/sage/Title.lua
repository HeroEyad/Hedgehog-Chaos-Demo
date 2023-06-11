function onCreate()
makeLuaSprite('Black', 'Startscreens/Blackthing', 0, 0);
setObjectCamera('Black', 'other');
scaleObject('Black', 1, 1);
addLuaSprite('Black', true);
setProperty('Black.alpha', 1)

makeAnimatedLuaSprite('Sage', 'Startscreens/Songs/Sage', 0, 0);
addAnimationByPrefix('Sage', 'Sage', 'Sage', 25, true)
objectPlayAnimation('Sage', 'Sage', true);
setObjectCamera('Sage', 'other')
addLuaSprite('Sage', true);
setProperty('Sage.alpha', 0)
end


local allowCountdown = false

function onStartCountdown() --these are the timers for all of the events here, if you want the Title card to be longer or shorter then change it here
  if not allowCountdown then
  runTimer('Titlecard', 0)
  runTimer('TitlecardEnd', 4)
  runTimer('EndVid', 5)
  allowCountdown = true;
  return Function_Stop;
  end
  return Function_Continue;
end


function onTimerCompleted(tag, loops, loopsLeft) -- this is what these timers do when their timer is up
if tag == 'Titlecard' then
playSound('sage-intro')
doTweenAlpha('SageIn', 'Sage', 1, 1, 'linear');
setProperty('skipCountdown', true)
end
if tag == 'TitlecardEnd' then
doTweenAlpha('SageOut', 'Sage', 0, 1, 'linear');
end
if tag == 'EndVid' then
setProperty('Sage.alpha', 0)
setProperty('Black.alpha', 0)
startCountdown()
Papu()
end
end