--- main.lua: Image Circle Packing Simulation in LÖVE
-- based on the circle-packing project in explorations
-- This follows video#2 in the coding train circle packing series
--
-- date: 14/3/2024
-- author: Abhishek Mishra

-- require the Circle class
local Circle = require 'circle'

-- canvas dimensions
local cw, ch

-- list of circles
local circles = {}

-- image to be used for the circles
local imageData

local running = false

--- check if a circle is valid, i.e., it doesn't overlap with any existing circles
-- nor is it inside any existing circle
-- @param x: x-coordinate of the center of the circle
-- @param y: y-coordinate of the center of the circle
-- @param r: radius of the circle
-- @return: true if the circle is valid, false otherwise
local function isValidCircle(x, y, r)
    for i = 1, #circles do
        local dx = circles[i].x - x
        local dy = circles[i].y - y
        local distance = math.sqrt(dx * dx + dy * dy)
        if distance < circles[i].r + r then
            return false
        end
    end
    return true
end

--- create a new circle while ensuring that it doesn't overlap with any existing circles
-- nor is it inside any existing circle
local function createCircle()
    local x, y, r
    local attempts = 0
    local maxAttempts = 100

    -- try to create a new circle
    repeat
        x = love.math.random(1, cw)
        y = love.math.random(1, ch)
        r = love.math.random(1, 5)
        attempts = attempts + 1
    until isValidCircle(x, y, r) or attempts > maxAttempts

    -- if we have reached the maximum number of attempts, return nil
    if attempts > maxAttempts then
        return nil
    end

    -- create a new circle and return it
    return Circle:new(x, y, r, imageData:getPixel(x - 1, y - 1))
end

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    cw, ch = love.graphics.getDimensions()

    -- load the tiger image
    imageData = love.image.newImageData('tiger.jpg')
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    if not running then
        return
    end

    -- -- add a new circle every 5 frames
    -- if love.timer.getFPS() % 5 == 0 then

    -- try to add 10 new circles every frame
    for i = 1, 10 do
        local newCircle = createCircle()
        if newCircle then
            table.insert(circles, newCircle)
        end
    end

    -- grow the circles
    for i = 1, #circles do
        circles[i]:update(dt)
        -- if the circle is growing check if it is now touching another circle
        -- if it is touching then stop growing
        if circles[i]._growing then
            for j = 1, #circles do
                if i ~= j then
                    local dx = circles[i].x - circles[j].x
                    local dy = circles[i].y - circles[j].y
                    local distance = math.sqrt(dx * dx + dy * dy)
                    if distance < circles[i].r + circles[j].r then
                        circles[i]._growing = false
                        break
                    end
                end
            end
        end
        circles[i]:grow(0.1)
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- if not running, display the message to start the simulation
    if not running then
        love.graphics.print("Press Space to start the simulation", 50,
            love.graphics.getHeight() / 2)
        return
    end

    -- set the background color
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw the circle
    for i = 1, #circles do
        circles[i]:draw()
    end
end

-- escape to exit
-- press space to toggle the simulation
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        running = not running
    end
end
