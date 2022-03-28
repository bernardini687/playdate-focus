import 'CoreLibs/graphics'
import 'CoreLibs/timer'

local gfx         <const> = playdate.graphics
local font        <const> = gfx.font.new('Fonts/Mikodacs-Clock')
local workMinutes <const> = 25
local restMinutes <const> = 5
local paused              = true
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
    return timer.duration == millisecondsFromMinutes(workMinutes) -- TODO: this is buggy because we reset timers and the duration is not predictable anymore :(
end

local function resetTimer(milliseconds)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(milliseconds)
end
resetTimer(millisecondsFromMinutes(workMinutes))

gfx.setFont(font)
local function drawText()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)
    local txt  = m..':'..s
    local w, h = gfx.getTextSize(txt)
    local img  = gfx.image.new(w + 50, h)

    img:clear(gfx.kColorWhite)
    gfx.pushContext(img)
        gfx.drawText(txt, 25, 0)
    gfx.popContext()
    img:drawCentered(200, 120)
end

playdate.display.setInverted(true)
function playdate.update()
    drawText()

    if timer.timeLeft == 0 then
        if isWorkTimer() then
            resetTimer(millisecondsFromMinutes(restMinutes))
            playdate.display.setInverted(false)
            drawText()
            paused = true
        else
            resetTimer(millisecondsFromMinutes(workMinutes))
            playdate.display.setInverted(true)
            drawText()
            paused = true
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
