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
local RaycastingSystem = require('raycastingsystem')
local RaycastingPanel = require('raycastingpanel')
local RenderingPanel = require('renderingpanel')

local layout
local raycastingSystem

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- create a layout panel
    layout = nl.Layout(nl.Rect(0, 0, cw, ch), {
        layout = 'row',
    })

    -- create the raycasting panel
    raycastingSystem = RaycastingSystem(cw / 2, ch)
    local raycastingPanel = RaycastingPanel(raycastingSystem, 0, 0, cw / 2, ch)
    local renderingPanel = RenderingPanel(raycastingSystem, 0, 0, cw / 2, ch)

    -- add the raycasting panel to the layout
    layout:addChild(raycastingPanel)
    layout:addChild(renderingPanel)
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    -- update the layout
    layout:update(dt)

    -- update the raycasting system
    raycastingSystem:update(dt)
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

    if key == "r" then
        raycastingSystem:createWalls()
    end

    if key == "space" then
        raycastingSystem.autoMove = not raycastingSystem.autoMove
    end

    -- pass the key to the layout
    layout:keypressed(key)
end
