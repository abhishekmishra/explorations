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
local RaycastingPanel = require('raycastingpanel')

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
