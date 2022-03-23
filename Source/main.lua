import 'CoreLibs/graphics'
import 'CoreLibs/timer'

local gfx         <const> = playdate.graphics
local font        <const> = gfx.font.new('Fonts/Roobert-24-Medium') -- Why numerals-font isn't working?
local workMinutes <const> = 25
local restMinutes <const> = 5
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

local function resetTimer(minutes)
    if timer then
        timer:remove()
    end
    timer = playdate.timer.new(millisecondsFromMinutes(minutes))
end
resetTimer(workMinutes)

gfx.setFont(font)

local function setupText()
    local w, h = gfx.getTextSize('00:00')
    text = gfx.image.new(w, h)
end

local function drawText(content)
    text:clear(gfx.kColorWhite)
    gfx.pushContext(text)
        gfx.drawText(content, 0, 0)
    gfx.popContext()
    text:scaledImage(3):drawCentered(200, 120)
end

setupText()
playdate.display.setInverted(true)
function playdate.update()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)

    drawText(m..':'..s)

    if timer.timeLeft == 0 then
        if isWorkTimer() then
            resetTimer(restMinutes)
        else
            resetTimer(workMinutes)
        end
    end

    playdate.timer.updateTimers()
end
