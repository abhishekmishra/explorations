--- main.lua: CS50GD Episode 01 - Flappy Bird in LÖVE2D
-- date: 2/4/2024
-- author: Abhishek Mishra

-- We use a lua library called push to handle the window resolution.
-- This allows us to program the game in a fixed resolution,
-- and let the library scale the window at runtime to a window resolution.
local push = require 'push'

-- Now let us setup the window resolution (which can be changed later)
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- The virtual resolution is the resolution we are programming the game in.
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Load the ground and background images
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

--- love.load: Called once at the start of the simulation
function love.load()
    -- We set the filtering to nearest neighbour to avoid blurring
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Now the title
    love.window.setTitle('CS50GD: Episode 01: Flappy Bird')

    -- The following incantation sets up the window using the push library
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

--- love.resize: Called when the window is resized
-- We will delegate the resizing to the push library
function love.resize(w, h)
    push:resize(w, h)
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- Start rendering at virtual resolution
    push:start()

    -- Draw the background
    love.graphics.draw(background, 0, 0)

    -- Draw the ground
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    -- End rendering at virtual resolution
    push:finish()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
