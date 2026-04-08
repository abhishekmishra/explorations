local Vehicle = require 'vehicle'

local v

function love.load()
    v = Vehicle()
end

function love.update(dt)
end

function love.draw()
    v:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
