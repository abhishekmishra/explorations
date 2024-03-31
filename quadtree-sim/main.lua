--- main.lua: QuadTree Simulation in LÖVE
-- date: 30/3/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Point = nl.Vector

-- require the QuadTree module
local q = require('quadtree')
local QuadTree = q.QuadTree
local Rectangle = q.Rectangle

-- global variable to hold the QuadTree
local qt
local mouseDragging = false

--- love.load: Called once at the start of the simulation
function love.load()
    local boundary = Rectangle(200, 200, 200, 200)
    qt = QuadTree(boundary, 4)

    -- for i = 1, 100 do
    --     local p = Point(math.random(0, love.graphics.getWidth()),
    --         math.random(0, love.graphics.getHeight()))
    --     qt:insert(p)
    -- end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- if the mouse is being dragged, then add 5 random points around
    -- the mouse position
    if mouseDragging then
        for i = 1, 5 do
            local p = Point(love.mouse.getX() + math.random(-5, 5),
                love.mouse.getY() + math.random(-5, 5))
            qt:insert(p)
        end
    end

    -- set point size to 5
    love.graphics.setPointSize(5)
    love.graphics.setColor(1, 1, 1)

    -- draw the QuadTree
    qt:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        mouseDragging = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        mouseDragging = false
    end
end