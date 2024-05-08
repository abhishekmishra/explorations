--- main.lua: <Empty> Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

-- All imports and module scope variables go here.

-- canvas dimensions
local cw, ch



--- love.load: Called once at the start of the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.load()
    cw, ch = love.graphics.getDimensions()
end



--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
end



--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    -- draw a circle by drawing line segments
    -- at every segment turn by a small angle
    -- before drawing the next one.
    -- use this to draw a circle like a polygon
    -- using the love.graphics.polygon function
    love.graphics.push()
    love.graphics.translate(cw/2, ch/2)
    local angle_delta = 0.1
    local segments = 2 * math.pi / angle_delta
    -- generate the vertices for the circle
    local vertices = {}
    for i = 1, segments do
        local radius = math.random(50, 100)
        local x = radius * math.cos(i * angle_delta)
        local y = radius * math.sin(i * angle_delta)
        table.insert(vertices, x)
        table.insert(vertices, y)
    end
    -- draw the circle
    love.graphics.polygon("line", vertices)
    love.graphics.pop()
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

