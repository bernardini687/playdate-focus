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

function playdate.deviceWillLock()
    App:pause()
end

function playdate.deviceDidUnlock()
    App:resume()
end

-- function playdate.gameWillTerminate()
--     App:write()
-- end

-- function playdate.deviceWillSleep()
--     App:write()
-- end
