-- Made by HeroEyad

local healthBarProperties = {
    numDivisions = 10000,
    flipX = false,
    angle = 180,
    scaleX = -1,
    percent = 50,
    x = 0,
    width = 0
}

local function onCreatePost()
    setProperty('healthBar.numDivisions', healthBarProperties.numDivisions)
end

local function updateFlipStatus()
    return getProperty('healthBar.flipX') or 
           getProperty('healthBar.angle') == healthBarProperties.angle or 
           getProperty('healthBar.scale.x') == healthBarProperties.scaleX
end

local function updateHealthPercent(e)
    local currentHealth = getProperty('health') * 50
    healthBarProperties.percent = math.interpolate(healthBarProperties.percent, math.max(currentHealth, 0), e * 10)
    healthBarProperties.percent = math.min(healthBarProperties.percent, 100)
    setProperty('healthBar.percent', healthBarProperties.percent)
end

local function calculateIconPositions()
    local usePer = (healthBarProperties.flipX and healthBarProperties.percent or mapValue(healthBarProperties.percent, 0, 100, 100, 0)) * 0.01
    local part1 = getProperty('healthBar.x') + (getProperty('healthBar.width') * usePer)
    return {
        part1 + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26,
        part1 - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2
    }
end

local function updateIconPositions(iconPositions)
    for i = 1, 2 do
        setProperty('iconP'..i..'.x', iconPositions[healthBarProperties.flipX and ((i % 2) + 1) or i])
        setProperty('iconP'..i..'.flipX', healthBarProperties.flipX)
    end
end

function onUpdatePost(e)
    healthBarProperties.flipX = updateFlipStatus()
    updateHealthPercent(e)
    local iconPositions = calculateIconPositions()
    updateIconPositions(iconPositions)
end

function math.interpolate(a, b, t) -- yooo thanks for these unholywandrer04
    return (b - a) * t + a
end

function mapValue(v, str1, stp1, str2, stp2)
    return str2 + (v - str1) * ((stp2 - str2) / (stp1 - str1))
end
