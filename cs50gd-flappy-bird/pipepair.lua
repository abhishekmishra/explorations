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
        Pipe(y),
        Pipe(y + PIPE_HEIGHT + GAP_HEIGHT)
    }
end