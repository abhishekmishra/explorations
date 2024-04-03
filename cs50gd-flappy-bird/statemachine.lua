--- statemachine.lua - Implements a simple state machine
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- The StateMachine class
local StateMachine = Class('StateMachine')

-- The constructor
function StateMachine:initialize(states)
    self.states = states or {}
    self.current = nil
end

-- Change the state
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], 'State ' .. stateName .. ' does not exist')

    -- create an empty table if enterParams is not provided
    enterParams = enterParams or {}

    -- add the state machine to the enterParams, such that a global reference
    -- to the state machine is not required.
    enterParams.Machine = self

    -- exit the current state if it exists
    if self.current then
        self.current:exit()
    end

    -- change the state
    self.current = self.states[stateName]()

    -- enter the new state
    self.current:enter(enterParams)
end

-- Update the current state
function StateMachine:update(dt)
    self.current:update(dt)
end

-- Draw the current state
function StateMachine:draw()
    self.current:draw()
end

return StateMachine