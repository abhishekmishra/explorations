--- main.lua: A Maurer Rose Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

local n
local d

--- love.load: Called once at the start of the simulation
function love.load()
    n = 0
    d = 0
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    n = n + 0.01
    d = d + 0.05
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    love.graphics.push()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    love.graphics.translate(love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2)

    local points = {}

    for i = 0, 361 do
        local k = i * d
        local r = 150 * math.sin(math.rad(n * k))
        local x = r * math.cos(math.rad(k))
        local y = r * math.sin(math.rad(k))
        table.insert(points, x)
        table.insert(points, y)
    end

    love.graphics.setColor(0.8, 0.7, 0.7)
    love.graphics.setLineWidth(0.1)
    love.graphics.line(points)

    -- trace the main path
    -- points = {}

    -- for i = 0, 361 do
    --     local k = i
    --     local r = 150 * math.sin(math.rad(n * k))
    --     local x = r * math.cos(math.rad(k))
    --     local y = r * math.sin(math.rad(k))
    --     table.insert(points, x)
    --     table.insert(points, y)
    -- end

    -- love.graphics.setColor(0.9, 0, 0.9, 0.5)
    -- love.graphics.setLineWidth(4)
    -- love.graphics.line(points)

    love.graphics.pop()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end