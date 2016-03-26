-- This helper module provides methods to delay game actions
local helper = { timers = {} }


-- Wait for a delay seconds before calling function
function helper.waitFor (self, delay, func, ...)
    table.insert(self.timers, { delay = delay, func = func, params = {...} })
end


-- Wait for all game dialogue to end before calling function
function helper.waitForSpeech (self, func, ...)
    table.insert(self.timers, { speech = true, delay = 0, func = func, params = {...} })
end


-- Update the timers and call any that have elapsed
function helper.update (self, dt)
    for ix, timer in ipairs(self.timers) do
        -- reduce delay for timers, or for speech waits
        if not timer.speech or (timer.speech and not slime:someoneTalking()) then
            timer.delay = timer.delay - dt
            if timer.delay < 0 then
                table.remove(self.timers, ix)
                timer.func(unpack(timer.params))
            end
        end
    end
end

return helper