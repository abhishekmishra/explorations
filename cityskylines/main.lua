--- main.lua: City Skyline Animation in LÖVE
-- date: 16/6/2025
-- author: Abhishek Mishra

local cw, ch

--- Create a building at a random position,
-- with random dimensions
-- random appearance (colour, opacity)
-- random number of floors
-- and random number of windows
local function create_building()
    local building = {}
    building.position = {
        x = math.random(0, cw - 100),
        y = math.random(0, ch - 200)
    }
    building.size = {
        width = math.random(50, 100),
        height = math.random(100, 200)
    }
    building.color = {
        r = math.random(100, 255),
        g = math.random(100, 255),
        b = math.random(100, 255),
        a = math.random(150, 255)
    }
    building.floors = math.random(3, 10)
    building.windows = math.random(5, 20)
    return building
end

function love.load()
    cw, ch = love.graphics.getDimensions()
end

function love.update(dt)
end

function love.draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
