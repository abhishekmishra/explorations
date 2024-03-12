--- main.lua: Circle Packing Simulation in LÖVE
-- date: 12/3/2024
-- author: Abhishek Mishra

-- require the Circle class
local Circle = require 'circle'

-- canvas dimensions
local cw, ch

-- list of circles
local circles = {}


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
        x = love.math.random(0, cw)
        y = love.math.random(0, ch)
        r = love.math.random(5, 50)
        attempts = attempts + 1
    until isValidCircle(x, y, r) or attempts > maxAttempts

    -- if we have reached the maximum number of attempts, return nil
    if attempts > maxAttempts then
        return nil
    end

    -- create a new circle and return it
    return Circle:new(x, y, r)
end

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    cw, ch = love.graphics.getDimensions()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    -- add a new circle every 5 frames
    if love.timer.getFPS() % 5 == 0 then
        local newCircle = createCircle()
        if newCircle then
            table.insert(circles, newCircle)
        end
    end

    -- grow the circles
    for i = 1, #circles do
        circles[i]:update(dt)
        circles[i]:grow(0.1)
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- set the background color
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw the circle
    for i = 1, #circles do
        circles[i]:draw()
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
