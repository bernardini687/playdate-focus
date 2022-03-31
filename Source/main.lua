import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'soundManager'

local gfx           <const> = playdate.graphics
local font          <const> = gfx.font.new('Fonts/Mikodacs-Clock')
local menu          <const> = playdate.getSystemMenu()
local workIntervals <const> = {'25', '30', '20'}
local restIntervals <const> = { '5', '10', '15'}
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

local function drawText()
    local m, s = minutesAndSecondsFromMilliseconds(timer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)
    local txt  = m..':'..s
    local w, h = gfx.getTextSize(txt)
    local img  = gfx.image.new(w + 50, h) -- Add extra space around the text to cover for wider numbers.

    img:clear(gfx.kColorWhite)
    gfx.pushContext(img)
        gfx.drawText(txt, 25, 0)
    gfx.popContext()
    img:drawCentered(200, 120)
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
gfx.setFont(font)
startWorkTimer()
menu:addOptionsMenuItem('work time', workIntervals, nil, function(choice)
    workMinutes = choice
    startWorkTimer()
    drawText()
    isPause = true
end)
menu:addOptionsMenuItem('rest time', restIntervals, nil, function(choice)
    restMinutes = choice
    startRestTimer()
    drawText()
    isPause = true
end)

function playdate.update()
    drawText()

    if isPause then
        timer:pause()
        playdate.stop()
    end

    if timer.timeLeft == 0 then
        isPause = true
        SoundManager:playSound(SoundManager.kTimerEnd)

        if isWork then
            startRestTimer()
        else
            startWorkTimer()
        end
    end

    playdate.timer.updateTimers()
end

local function resumeOrPause()
    isPause = not isPause

    if isPause then
        SoundManager:playSound(SoundManager.kPause)
    else
        SoundManager:playSound(SoundManager.kResume)
        resetTimer(timer.timeLeft)
        playdate.start()
    end
end

function playdate.AButtonDown()
    resumeOrPause()
end

function playdate.BButtonDown()
    resumeOrPause()
end
