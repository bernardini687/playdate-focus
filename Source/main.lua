import 'CoreLibs/graphics'
import 'CoreLibs/timer'

local gfx         <const> = playdate.graphics
local workMinutes <const> = 0.2 -- 25
local restMinutes <const> = 0.1 -- 5

local timer
local function resetTimer(minutes)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(1000 * 60 * minutes)
end
resetTimer(workMinutes)

function minutesAndSecondsFromMilliseconds(ms)
    local  s <const> = math.floor(ms / 1000) % 60
    local  m <const> = math.floor(ms / (1000 * 60)) % 60
    return m, s
end

function addLeadingZero(num)
    if num < 10 then
        return '0'..num
    end
    return num
end

function isWorkTimer()
    return timer.duration == 1000 * 60 * workMinutes
end

function playdate.update()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)

    gfx.clear()
    gfx.drawText(m..':'..s, 0, 0)

    if timer.timeLeft == 0 then
        if isWorkTimer() then
            resetTimer(restMinutes)
        else
            resetTimer(workMinutes)
        end
    end

    playdate.timer.updateTimers()
end

-- 1. [COACH] crank-controlled timer
-- 2. [FOCUS] simple pomodoro timer flow
