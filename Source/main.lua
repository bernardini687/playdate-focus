import 'CoreLibs/graphics'
import 'CoreLibs/timer'

local gfx         <const> = playdate.graphics
local workMinutes <const> = 0.2 -- 25
local restMinutes <const> = 0.1 -- 5
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

local function isWorkTimer()
    return timer.duration == millisecondsFromMinutes(workMinutes)
end

local function resetTimer(minutes)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(millisecondsFromMinutes(minutes))
end
resetTimer(workMinutes)

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
