--- playstate.lua - Main game state for the Flappy Bird game
--
-- date: 03/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Import the BaseState class
local BaseState = require 'basestate'

-- Import the Bird class
local Bird = require 'bird'

-- Import the PipePair class
local PipePair = require 'pipepair'

local GROUND_HEIGHT = 16

local PlayState = Class('PlayState', BaseState)

--- The constructor
function PlayState:initialize(config)
    -- superclass constructor
    BaseState.initialize(self, config)

    -- empty constructor
    -- The bird object
    self.bird = Bird(self.config.sounds)

    -- The pipe pairs table
    self.pipePairs = {}

    -- The spawn timer
    self.spawnTimer = 0

    -- the score
    self.score = 0

    -- record the last y position of the last pipe pair
    -- start it with a random value
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

--- Update the play state
function PlayState:update(dt)
    -- update the bird
    self.bird:update(dt)

    -- update the spawn timer
    self.spawnTimer = self.spawnTimer + dt

    -- spawn a new pipe pair every 2 seconds
    if self.spawnTimer > 2 then
        -- clamp the y position of the pipe pair to be within the
        -- top 10 and bottom 90 pixels of the screen
        -- such that both the pipes in the pair are visible in any
        -- configuration
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20),
                VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))

        -- reset the spawn timer
        self.spawnTimer = 0
    end

    -- update the pipe pairs
    for k, pipePair in pairs(self.pipePairs) do
        -- score a point if the bird has crossed the pipe pair
        -- but only if it is not already scored
        if not pipePair.scored and self.bird.x > pipePair.x + PIPE_WIDTH then
            self.score = self.score + 1
            pipePair.scored = true

            -- play the score sound
            self.config.sounds['score']:play()
        end

        pipePair:update(dt)
    end

    -- remove the pipe pairs that are past the left edge of the screen
    for k, pipePair in pairs(self.pipePairs) do
        if pipePair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- check for collision
    for _, pipePair in pairs(self.pipePairs) do
        if self.bird:collides(pipePair.pipes['upper']) or
            self.bird:collides(pipePair.pipes['lower']) then
            -- play the explosion and hurt sounds
            self.config.sounds['explosion']:play()
            self.config.sounds['hurt']:play()

            self.enterParams.Machine:change('score', {
                score = self.score
            })
        end
    end

    -- check for collision with the ground
    if self.bird.y + self.bird.height >= VIRTUAL_HEIGHT - GROUND_HEIGHT then
        -- play the explosion and hurt sounds
        self.config.sounds['explosion']:play()
        self.config.sounds['hurt']:play()

        self.enterParams.Machine:change('score', {
            score = self.score
        })
    end
end

--- Draw the play state
function PlayState:draw()
    -- Draw the pipe pairs
    for _, pipePair in pairs(self.pipePairs) do
        pipePair:draw()
    end

    -- Draw the score
    love.graphics.setFont(self.config.flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- Draw the bird
    self.bird:draw()
end

--- Enter the play state
function PlayState:enter(params)
    -- superclass enter
    BaseState.enter(self, params)

    -- enable scrolling
    self.config.scrolling = true
end

--- Exit the play state
function PlayState:exit()
    -- superclass exit
    BaseState.exit(self)

    -- disable scrolling
    self.config.scrolling = false
end

return PlayState
