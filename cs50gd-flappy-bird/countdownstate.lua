--- countdownstate.lua - The countdown state for the Flappy Bird game.
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Import the BaseState class
local BaseState = require 'basestate'

-- This is how long the countdown will be shown on the screen
-- (unit is seconds)
local COUNTDOWN_TIME = 0.75

local CountdownState = Class('CountdownState', BaseState)

-- The constructor
function CountdownState:initialize(config)
    -- superclass constructor
    BaseState.initialize(self, config)

    -- count shown on the screen
    self.count = 3

    -- the countdown timer
    self.timer = 0
end

-- update the countdown state
function CountdownState:update(dt)
    -- update the timer
    self.timer = self.timer + dt

    -- if the timer has exceeded the countdown time
    -- decrement the count
    if self.timer > COUNTDOWN_TIME then
        self.count = self.count - 1

        -- reset the timer
        self.timer = 0

        -- if the count is 0, transition to the play state
        if self.count == 0 then
            self.Machine:change('play')
        end
    end
end

-- draw the countdown state
function CountdownState:draw()
    -- set the font to the huge font
    love.graphics.setFont(self.config.hugeFont)

    -- draw the count
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end

return CountdownState