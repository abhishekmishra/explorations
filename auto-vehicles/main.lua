local Vehicle = require 'vehicle'
local Vector = require 'vector'

local v

function love.load()
    v = Vehicle(100, 100)
end

function love.update(dt)
    v:applyForce(Vector(1, 1))
    v:update(dt)
end

function love.draw()
    v:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
