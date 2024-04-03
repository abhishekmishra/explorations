--- basestate.lua is a base class for all states in the game.
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

local BaseState = Class('BaseState')

-- The constructor
function BaseState:initialize(config)
    self.config = config or {}
end

-- Enter the state
function BaseState:enter(params)
    self.enterParams = params
    self.Machine = self.enterParams.Machine
end

-- Exit the state
function BaseState:exit()
    -- empty exit function
end

-- Update the state
function BaseState:update(dt)
    -- empty update function
end

-- Draw the state
function BaseState:draw()
    -- empty draw function
end

return BaseState