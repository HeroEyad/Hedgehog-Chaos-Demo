function onEvent(name, value1, value2)
  if name == 'SLAP' then
characterPlayAnim('sonico', 'slap', true)
characterPlayAnim('bf-sonico', 'dodge', true)
  setProperty('health', getProperty('health') - 0.75);
  playSound('slap')
  end
end