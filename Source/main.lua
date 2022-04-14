import 'CoreLibs/timer'

gfx    = playdate.graphics
sprite = gfx.sprite

import 'dynamicText'
import 'soundManager'

local fontName      <const> = 'Mikodacs-Clock'
local menu          <const> = playdate.getSystemMenu()
local workIntervals <const> = {'0.2', '25', '30', '20'}
local restIntervals <const> = {'0.1', '5', '10', '15'}
local clock         <const> = DynamicText(200, 120, fontName)

local workMinutes           = workIntervals[1]
local restMinutes           = restIntervals[1]
local isPause, isWork       = true, true
local timer

local function millisecondsFromMinutes(minutes)
    return 1000 * 60 * minutes
end

local function minutesAndSecondsFromMilliseconds(ms)
    local  s <const> = math.floor(ms / 1000) % 60
    local  m <const> = math.floor(ms / (1000 * 60)) % 60
    return m, s
end

local function addLeadingZero(num)
    if num < 10 then
        return '0'..num
    end
    return num
end

local function resetTimer(ms)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(ms)
end

local function updateClock()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)
    local txt  = m..':'..s

    clock:setContent(txt)
end

local function startWorkTimer()
    isWork = true
    playdate.display.setInverted(isWork)
    resetTimer(millisecondsFromMinutes(workMinutes))
end

local function startRestTimer()
    isWork = false
    playdate.display.setInverted(isWork)
    resetTimer(millisecondsFromMinutes(restMinutes))
end

-- Setup:
startWorkTimer()
menu:addOptionsMenuItem('work time', workIntervals, nil, function(choice)
    workMinutes = choice
    startWorkTimer()
    updateClock()
    isPause = true
end)
menu:addOptionsMenuItem('rest time', restIntervals, nil, function(choice)
    restMinutes = choice
    startRestTimer()
    updateClock()
    isPause = true
end)

function playdate.update()
    updateClock()

    if isPause then
        timer:pause()
    end

    if timer.timeLeft == 0 then
        isPause = true
        SoundManager:play(SoundManager.kTimerEnd)

        if isWork then
            startRestTimer()
        else
            startWorkTimer()
        end
    end

    playdate.timer.updateTimers()
    sprite.update()
end

local function resumeOrPause()
    isPause = not isPause

    if isPause then
        SoundManager:play(SoundManager.kPause)
    else
        SoundManager:play(SoundManager.kResume)
        resetTimer(timer.timeLeft)
    end
end

function playdate.AButtonDown()
    resumeOrPause()
end

function playdate.BButtonDown()
    resumeOrPause()
end
