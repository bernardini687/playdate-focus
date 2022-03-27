import 'CoreLibs/graphics'
import 'CoreLibs/timer'

local gfx         <const> = playdate.graphics
local font        <const> = gfx.font.new('Fonts/Mikodacs-Clock')
local workMinutes <const> = 25
local restMinutes <const> = 5
local paused              = true
local timer, text

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

local function resetTimer(milliseconds)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(milliseconds)
end
resetTimer(millisecondsFromMinutes(workMinutes))

gfx.setFont(font)

local function setupText()
    local w, h = gfx.getTextSize('44:44') -- `4` looks like the largest digit in the font.
    text = gfx.image.new(w, h)
end

local function drawText(content)
    text:clear(gfx.kColorWhite)
    gfx.pushContext(text)
        gfx.drawText(content, 0, 0)
    gfx.popContext()
    text:drawCentered(214, 120) -- Add a small offset to the right of the vertical center.
end

setupText()
playdate.display.setInverted(true)
function playdate.update()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)

    drawText(m..':'..s)

    if timer.timeLeft == 0 then
        if isWorkTimer() then
            resetTimer(millisecondsFromMinutes(restMinutes))
        else
            resetTimer(millisecondsFromMinutes(workMinutes))
        end
    end

    if paused then
        timer:pause()
        playdate.stop()
    end

    playdate.timer.updateTimers()
end

function playdate.AButtonDown()
    paused = not paused
    if not paused then
        resetTimer(timer.timeLeft)
        playdate.start()
    end
end
