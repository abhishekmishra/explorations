--- main.lua: Snowflakes Simulation in LÖVE
-- date: 09/04/2024
-- author: Abhishek Mishra

local SnowFlake = require 'snowflake'

-- table to hold all the snowflakes
local snowflakes

-- font for credits
local creditsFont

-- number of snowflakes to create
local NUM_SNOWFLAKES = 3000

--- createSnowflake: Create a new snowflake
-- @return SnowFlake: A new snowflake object
local function createSnowflake()
    return SnowFlake:new(
        math.random(0, love.graphics.getWidth()),
        math.random(-love.graphics.getHeight(),
            love.graphics.getHeight() / 10),
        math.random(1, 3))
end

--- love.load: Called once at the start of the simulation
function love.load()
    -- create the snowflakes for the simulation
    snowflakes = {}
    for i = 1, NUM_SNOWFLAKES do
        table.insert(snowflakes, createSnowflake())
    end

    creditsFont = love.graphics.newFont(12)

    -- load music and play
    local music = love.audio.newSource("A Lucid Dream.ogg", "stream")
    music:setLooping(true)
    love.audio.play(music)
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    for _, snowflake in ipairs(snowflakes) do
        snowflake:update(dt)
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    love.graphics.setColor(0.8, 0.9, 1)
    for _, snowflake in ipairs(snowflakes) do
        snowflake:draw()
    end

    -- draw text at the bottom of the screen to show credits
    love.graphics.setColor(0.7, 0.5, 0.5)
    -- set credits font
    love.graphics.setFont(creditsFont)
    love.graphics.print("Snowflakes Simulation in LÖVE by ne0l4t3r4l", 10, love.graphics.getHeight() - 50)
    love.graphics.print("Pixel-art snowflakes by https://opengameart.org/users/alxl", 10, love.graphics.getHeight() - 35)
    love.graphics.print("Background Score - \"The Lucid Dream\" by https://opengameart.org/users/caliderium", 10, love.graphics.getHeight() - 20)

    -- draw text at the bottom-right of the screen to show FPS
    love.graphics.setColor(0.5, 0.4, 0.4)
    love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - 50, love.graphics.getHeight() - 20)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
