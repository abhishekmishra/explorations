--- titlescreenstate.lua - The title screen state for the Flappy Bird game.
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Import the BaseState class
local BaseState = require 'basestate'

local TitleScreenState = Class('TitleScreenState', BaseState)

-- The constructor
function TitleScreenState:initialize(config)
    -- superclass constructor
    BaseState.initialize(self, config)
end

-- update the title screen
function TitleScreenState:update(dt)
    -- transition to the play state if the space/enter key is pressed
    if love.keyboard.wasPressed('space')
        or love.keyboard.wasPressed('return') then
        self.Machine:change('countdown')
    end
end

-- draw the title screen
function TitleScreenState:draw()
    -- set the font to the large font
    love.graphics.setFont(self.config.flappyFont)

    -- draw the title
    love.graphics.printf('Flappy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    -- set the font to the small font
    love.graphics.setFont(self.config.mediumFont)

    -- draw the instructions
    love.graphics.printf('Press Enter/Space to Play',
        0, 100, VIRTUAL_WIDTH, 'center')
end

return TitleScreenState