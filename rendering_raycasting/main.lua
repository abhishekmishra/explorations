--- main.lua: Rendering Raycasting Simulation in LÖVE based on the raycasting
-- exploration. Both are based on the Coding Train's videos on Raycasting and
-- its rendering.
--
-- In this simulation we have two panels, one for the raycasting in a 2d map and
-- the other for 3d rendering of the rays to display the walls.
--
-- date: 28/4/2024
-- author: Abhishek Mishra

-- set the random seed to the current time
math.randomseed(os.time())

-- require the ne0luv library
local nl = require('ne0luv')
-- require the Boundary and Ray class
local Boundary = require('boundary')
local Ray = require('ray')
local Particle = require('particle')
local Class = require('middleclass')

--- A Raycasting panel class
local RaycastingPanel = Class('Raycasting', nl.Panel)

--- Constructor for the Raycasting panel
function RaycastingPanel:initialize(x, y, w, h)
    -- call the parent class constructor
    nl.Panel.initialize(self, nl.Rect(x, y, w, h))

    -- walls
    self:createWalls()

    -- particle
    self.particle = Particle(nl.Vector(self:getWidth() / 2,
        self:getHeight() / 2))

    -- particle offsets to move with noise
    self.xOffset = 0
    self.yOffset = 10000
end

function RaycastingPanel:createWalls()
    local cw = self:getWidth()
    local ch = self:getHeight()

    -- initialize the walls
    self.walls = {}

    -- create some random boundaries
    for _ = 1, 5 do
        local x1 = math.random(0, cw)
        local y1 = math.random(0, ch)
        local x2 = math.random(0, cw)
        local y2 = math.random(0, ch)
        table.insert(self.walls, Boundary(x1, y1, x2, y2))
    end

    -- add walls which form a box the size of the canvas
    table.insert(self.walls, Boundary(0, 0, cw, 0))
    table.insert(self.walls, Boundary(cw, 0,
        cw, ch))
    table.insert(self.walls, Boundary(cw, ch, 0, ch))
    table.insert(self.walls, Boundary(0, ch, 0, 0))
end

-- Panel update
function RaycastingPanel:update(dt)
    -- move the particle with noise
    local x = love.math.noise(self.xOffset) * self:getWidth()
    local y = love.math.noise(self.yOffset) * self:getHeight()
    self.particle:move(x, y)

    -- update the offsets
    self.xOffset = self.xOffset + 0.01
    self.yOffset = self.yOffset + 0.01

    -- cast the rays from the particle
    self.particle:look(self.walls)
end

--- Override the draw method to draw the rays
function RaycastingPanel:draw()
    -- draw the boundaries
    for _, wall in ipairs(self.walls) do
        wall:draw()
    end

    -- draw the particle
    self.particle:draw()
end

function RaycastingPanel:_keypressed(key)
    if key == "r" then
        self:createWalls()
    end
end

local layout

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- create a layout panel
    layout = nl.Layout(nl.Rect(0, 0, cw, ch))

    -- create the raycasting panel
    local raycastingPanel = RaycastingPanel(0, 0, cw/2, ch)

    -- add the raycasting panel to the layout
    layout:addChild(raycastingPanel)
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    -- update the layout
    layout:update(dt)
end

--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    -- draw the layout
    layout:draw()
end

-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    -- pass the key to the layout
    layout:keypressed(key)
end
