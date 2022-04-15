import 'CoreLibs/timer'

import 'dynamicText'
import 'soundManager'

-- local menu          <const> = playdate.getSystemMenu()
-- local store         <const> = playdate.datastore.read()
local timer         <const> = playdate.timer
local clock         <const> = DynamicText(200, 120, 'Mikodacs-Clock')
local workIntervals <const> = {'0.2', '25', '30', '20'}
local restIntervals <const> = {'0.1', '5', '10', '15'}

local workMinutes   = App.workIntervals[1]
local restMinutes   = App.restIntervals[1]
local isPaused      = true
local isWorkSession = true
local activeTimer

App = {}

-- private functions:

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
    if activeTimer then
        activeTimer:remove()
    end
    activeTimer = timer.new(ms)
end

local function updateClock()
    local m, s = minutesAndSecondsFromMilliseconds(activeTimer.timeLeft)
    m, s       = addLeadingZero(m), addLeadingZero(s)
    local text = m..':'..s

    if text ~= clock.content then
        clock:setContent(text)
    end
end

local function resetWorkTimer()
    isWorkSession = true
    playdate.display.setInverted(isWorkSession) -- TODO: see if it's the same to put this inside `resetTimer()`
    resetTimer(millisecondsFromMinutes(workMinutes))
end

local function resetRestTimer()
    isWorkSession = false
    playdate.display.setInverted(isWorkSession) -- TODO: see if it's the same to put this inside `resetTimer()`
    resetTimer(millisecondsFromMinutes(restMinutes))
end

-- public methods:

function App:setup()
    -- TODO: add options menu item
    resetWorkTimer()
    -- TODO?: playdate.display.setRefreshRate(10)
end

function App:run()
    if isPaused then
        activeTimer:pause()
        playdate.display.flush() -- TODO: try to remove this and see if anything changes!
        playdate.stop() -- prevents the next playdate.update() callback
    end

    updateClock()

    if activeTimer.timeLeft == 0 then
        isPaused = true
        SoundManager:play(SoundManager.kTimerEnd)

        if isWorkSession then
            resetRestTimer()
        else
            resetWorkTimer()
        end
    end

    sprite.update()
    timer.updateTimers()
end

function App:resumeOrPause()
    isPaused = not isPaused

    if isPaused then
        SoundManager:play(SoundManager.kPause)
    else
        SoundManager:play(SoundManager.kResume)
        resetTimer(activeTimer.timeLeft)
        playdate.start()
    end
end

-- function App:write()
-- end
