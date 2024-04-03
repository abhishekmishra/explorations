--- scorestate.lua - The score state for the Flappy Bird game.
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Import the BaseState class
local BaseState = require 'basestate'

local ScoreState = Class('ScoreState', BaseState)

-- The constructor
function ScoreState:initialize(config)
    -- superclass constructor
    BaseState.initialize(self, config)
end

-- enter the score state
function ScoreState:enter(params)
    -- superclass enter
    BaseState.enter(self, params)

    -- update the score state
    self.score = self.enterParams.score
end

-- update the score state
function ScoreState:update(dt)
    -- transition to the title state if the space/enter key is pressed
    if love.keyboard.wasPressed('space')
        or love.keyboard.wasPressed('return') then
        self.Machine:change('title')
    end
end

-- draw the score state
function ScoreState:draw()
    -- set the font to the large font
    love.graphics.setFont(self.config.flappyFont)

    -- draw the title
    love.graphics.printf('Game Over! Khallas!', 0, 64, VIRTUAL_WIDTH, 'center')

    -- set the font to the small font
    love.graphics.setFont(self.config.mediumFont)

    -- draw the score
    love.graphics.printf('Score: ' .. tostring(self.score),
        0, 140, VIRTUAL_WIDTH, 'center')

    -- draw the instructions
    love.graphics.printf('Press Enter/Space to Play Again',
        0, 100, VIRTUAL_WIDTH, 'center')
end

return ScoreState
