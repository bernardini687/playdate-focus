gfx    = playdate.graphics
sprite = gfx.sprite

import 'app'

App:setup()

function playdate.update()
    App:run()
end

function playdate.AButtonDown()
    App:resumeOrPause()
end

function playdate.BButtonDown()
    App:resumeOrPause()
end

-- function playdate.gameWillTerminate()
--     App:write()
-- end

-- function playdate.deviceWillSleep()
--     App:write()
-- end

-- Setup:

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
