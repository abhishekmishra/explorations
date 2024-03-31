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
local queryRect = Rectangle(100, 100, 50, 50)

--- love.load: Called once at the start of the simulation
function love.load()
    local boundary = Rectangle(200, 200, 200, 200)
    qt = QuadTree(boundary, 4)

    for i = 1, 300 do
        local p = Point(math.random(0, love.graphics.getWidth()),
            math.random(0, love.graphics.getHeight()))
        qt:insert(p)
    end
    for i = 1, 100 do
        local p = Point(i * love.graphics.getWidth() / 100,
            i * love.graphics.getHeight() / 100)
        qt:insert(p)
    end
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
    qt:draw(true)

    -- draw the query rectangle
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('line', queryRect.x - queryRect.w,
        queryRect.y - queryRect.h, queryRect.w * 2, queryRect.h * 2)

    -- query the QuadTree with the query rectangle
    local points = qt:query(queryRect)
    love.graphics.setColor(0, 1, 0)
    for _, p in ipairs(points) do
        love.graphics.points(p.x, p.y)
    end
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
    -- if right mouse button is pressed then updated query rectangle to mouse position
    if button == 2 then
        queryRect.x = x
        queryRect.y = y
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        mouseDragging = false
    end
end