--- main.lua: A Metaballs Simulation in LÖVE
-- TODO: Add a description of the program here
-- date: 1/3/2024
-- author: Abhishek Mishra

-- require middleclass
local class = require("middleclass")

--- Metaball: A class to represent a metaball
local Metaball = class("Metaball")

--- Metaball:initialize: Constructor for the Metaball class
function Metaball:initialize(x, y, r, v)
    self.x = x
    self.y = y
    self.r = r

    -- velocity
    self.v = v or {x = 200, y = 50}
end

--- Metaball:draw: Draw the metaball
function Metaball:draw()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- draw the metaball
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, self.r)
end

--- Metaball:update: Update the metaball
function Metaball:update(dt)
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- update the position
    self.x = self.x + self.v.x * dt
    self.y = self.y + self.v.y * dt

    -- bounce off the walls
    if (self.x - self.r) < 0 or (self.x + self.r) > cw then
        self.v.x = -(self.v.x)
    end
    if (self.y - self.r) < 0 or (self.y + self.r) > ch then
        self.v.y = -(self.v.y)
    end
end

local balls
local numBalls = 1

--- love.load: Called once at the start of the simulation
function love.load()
    balls = {}
    -- create the metaballs
    for i = 1, numBalls do
        local r = love.math.random(2, 50)
        local x = love.math.random(r, love.graphics.getWidth() - r)
        local y = love.math.random(r, love.graphics.getHeight() - r)
        local v = {x = love.math.random(-200, 200), y = love.math.random(-200, 200)}
        local b = Metaball:new(x, y, r, v)
        table.insert(balls, b)
    end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    for _, b in ipairs(balls) do
        b:update(dt)
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- fill the background with black
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw the metaballs
    for _, b in ipairs(balls) do
        b:draw()
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- Converts HSV to RGB. (input and output range: 0 - 1)
-- see https://love2d.org/wiki/HSV_color
function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end
