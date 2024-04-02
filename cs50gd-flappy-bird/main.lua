--- main.lua: CS50GD Episode 01 - Flappy Bird in LÖVE2D
-- date: 2/4/2024
-- author: Abhishek Mishra

-- We use a lua library called push to handle the window resolution.
-- This allows us to program the game in a fixed resolution,
-- and let the library scale the window at runtime to a window resolution.
local push = require 'push'

-- The Bird class
local Bird = require 'bird'

-- Now let us setup the window resolution (which can be changed later)
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- The virtual resolution is the resolution we are programming the game in.
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- The background and ground scroll speed in pixels per second
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- background loop back pixel width
local BACKGROUND_LOOPING_POINT = 413

-- Load the ground and background images
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- Keep track of the background scroll and ground scroll
local backgroundScroll = 0
local groundScroll = 0

-- The bird object
local bird

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

    -- Create the bird object
    bird = Bird()

    -- Define a global table to store the keys pressed in the love.keyboard
    -- namespace
    love.keyboard.keysPressed = {}
end

--- love.resize: Called when the window is resized
-- We will delegate the resizing to the push library
function love.resize(w, h)
    push:resize(w, h)
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    -- update the background scroll
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    -- update the ground scroll
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

    -- update the bird
    bird:update(dt)

    -- reset the keys pressed
    love.keyboard.keysPressed = {}
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- Start rendering at virtual resolution
    push:start()

    -- Draw the background, now with the background scroll
    love.graphics.draw(background, -backgroundScroll, 0)

    -- Draw the ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- Draw the bird
    bird:draw()

    -- End rendering at virtual resolution
    push:finish()
end

--- love.keyboard.wasPressed: Global function to check if a key was pressed
-- (checks in the keysPressed table)
-- @param key The key to check
-- @return true if the key was pressed, false otherwise
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- escape to exit
function love.keypressed(key)
    -- update the keys pressed table with this key
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end
