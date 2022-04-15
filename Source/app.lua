import 'CoreLibs/timer'

import 'dynamicText'
import 'soundManager'

-- local menu          <const> = playdate.getSystemMenu()
-- local store         <const> = playdate.datastore.read()
local timer         <const> = playdate.timer
local clock         <const> = DynamicText(200, 120, 'Mikodacs-Clock')
local workIntervals <const> = {'0.2', '25', '30', '20'}
local restIntervals <const> = {'0.1', '5', '10', '15'}

local workMinutes   = workIntervals[1]
local restMinutes   = restIntervals[1]
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
    resetTimer(millisecondsFromMinutes(workMinutes))
end

local function resetRestTimer()
    isWorkSession = false
    resetTimer(millisecondsFromMinutes(restMinutes))
end

-- public methods:

function App:setup()
    -- menu:addOptionsMenuItem('work time', workIntervals, nil, function(choice)
    --     workMinutes = choice
    --     startWorkTimer()
    --     updateClock()
    --     isPause = true
    -- end)
    -- menu:addOptionsMenuItem('rest time', restIntervals, nil, function(choice)
    --     restMinutes = choice
    --     startRestTimer()
    --     updateClock()
    --     isPause = true
    -- end)

    resetWorkTimer()
    playdate.setAutoLockDisabled(true)
    playdate.display.setInverted(isWorkSession)
    playdate.display.setRefreshRate(15)
end

function App:run()
    if isPaused then
        self:pause()
    end

    updateClock()

    if activeTimer.timeLeft == 0 then
        SoundManager:play(SoundManager.kTimerEnd)
        isPaused = true

        if isWorkSession then
            resetRestTimer()
        else
            resetWorkTimer()
        end
        activeTimer:pause()
        playdate.display.setInverted(isWorkSession)
    end

    sprite.update()
    timer.updateTimers()
end

function App:resumeOrPause()
    isPaused = not isPaused

    if isPaused then
        SoundManager:play(SoundManager.kPause)
        activeTimer:pause()
    else
        SoundManager:play(SoundManager.kResume)
        self:resume()
    end
end

function App:pause()
    -- print('pause: '..activeTimer.timeLeft) -- DEBUG
    playdate.setAutoLockDisabled(false)
    playdate.stop() -- prevents the next playdate.update() callback
end

function App:resume()
    -- print('resume: '..activeTimer.timeLeft) -- DEBUG
    resetTimer(activeTimer.timeLeft)
    playdate.setAutoLockDisabled(true)
    playdate.start()
end

-- function App:write()
--     playdate.datastore.write({})
-- end

-- function playdate.gameWillPause() -- DEBUG
--     print('pause: '..activeTimer.timeLeft)
-- end

-- function playdate.gameWillResume() -- DEBUG
--     print('resume: '..activeTimer.timeLeft)
-- end
