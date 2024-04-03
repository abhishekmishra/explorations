--- pipepair.lua - Implements a pair of pipes.
--
-- date: 02/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'
local Pipe = require 'pipe'

-- The gap between the pipes
local GAP_HEIGHT = 90

-- The PipePair class
local PipePair = Class('PipePair')

-- The constructor
function PipePair:initialize(y)
    -- start the pipes beyond the right edge of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y is the position of the top pipe
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', y),
        ['lower'] = Pipe('bottom', y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- flag to indicate if the pipe pair is past the screen, and can be removed
    self.remove = false

    -- flag to indicate if the pipe pair has been scored
    self.scored = false
end

-- Update the pipe pair
function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    else
        self.remove = true
    end
end

-- Draw the pipe pair
function PipePair:draw()
    for _, pipe in pairs(self.pipes) do
        pipe:draw()
    end
end

return PipePair
