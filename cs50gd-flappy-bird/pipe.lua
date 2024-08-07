--- pipe.lua - implements the Pipe class for the Flappy Bird game (based on the
-- Pipe class from episode 01 in GD50 course by Colton Ogden)
--
-- date: 02/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- The Pipe Image
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- The Pipe Speed (only on the x-axis)
PIPE_SPEED = 60

-- hardcoding the pipe width and height
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

-- The Pipe class
local Pipe = Class('Pipe')

-- The Pipe constructor
function Pipe:initialize(orientation, y)
    self.orientation = orientation

    -- The x position of the pipe, just outside the right edge of the screen
    self.x = VIRTUAL_WIDTH

    -- The y position of the pipe
    self.y = y

    -- Dimensions the pipe
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
end

-- Update the pipe
function Pipe:update(dt)
    -- This is empty as the pipe is updated by the PipePair class
end

-- Draw the pipe
function Pipe:draw()
    -- draw the pipe at the x and y position
    -- if the orientation is 'top', we draw the pipe upside down
    -- by setting the scale factor to -1 on the y-axis
    -- and also adjusting the y position
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, 1, self.orientation == 'top' and -1 or 1)
end

return Pipe
