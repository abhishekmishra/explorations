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
    self.v = v or { x = 200, y = 50 }
end

--- Metaball:draw: Draw the metaball
function Metaball:draw()
    -- draw the metaball
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("line", self.x, self.y, self.r)
end

--- Metaball:update: Update the metaball
function Metaball:update(dt)
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- bounce off the walls
    if (self.x - self.r) < 0 or (self.x + self.r) > cw then
        self.v.x = -(self.v.x)
    end
    if (self.y - self.r) < 0 or (self.y + self.r) > ch then
        self.v.y = -(self.v.y)
    end

    -- check if position is beyond the canvas then clamp it
    if self.x < self.r then
        self.x = self.r
    elseif self.x > cw - self.r then
        self.x = cw - self.r
    end

    if self.y < self.r then
        self.y = self.r
    elseif self.y > ch - self.r then
        self.y = ch - self.r
    end

    -- update the position
    self.x = self.x + self.v.x * dt
    self.y = self.y + self.v.y * dt
end

local balls
local numBalls = 5

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    balls = {}
    -- create the metaballs
    for i = 1, numBalls do
        local r = love.math.random(ch / 16, ch / 4)
        local x = love.math.random(r, cw - r)
        local y = love.math.random(r, ch - r)
        local v = {
            x = love.math.random(-cw / 3, cw / 3),
            y = love.math.random(-ch / 3, ch / 3)
        }
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

    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- love.graphics.setColor(1, 1, 1, 1)

    -- lets create an isosurface
    local data = love.image.newImageData(cw, ch)
    for i = 0, cw - 1 do -- remember: start at 0
        for j = 0, ch - 1 do
            local fSum = 0
            -- calculate distance from the center of the metaball
            for _, b in ipairs(balls) do
                local d = math.sqrt((i - b.x) ^ 2 + (j - b.y) ^ 2)
                fSum = fSum + (b.r / d)
            end

            -- normalize fSum
            fSum = fSum / #balls
            -- print(fSum)

            data:setPixel(i, j, fSum, fSum, fSum, 1)
        end
    end

    -- create an image from the data
    local img = love.graphics.newImage(data)

    -- draw the image
    love.graphics.draw(img, 0, 0)

    -- -- draw the metaballs
    -- for _, b in ipairs(balls) do
    --     b:draw()
    -- end
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
    if s <= 0 then return v, v, v end
    h = h * 6
    local c = v * s
    local x = (1 - math.abs((h % 2) - 1)) * c
    local m, r, g, b = (v - c), 0, 0, 0
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
    return r + m, g + m, b + m
end
