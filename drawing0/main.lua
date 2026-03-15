local Pointer = require 'Pointer'

local pointer

function love.load()
    love.mouse.setVisible(false)
    pointer = Pointer()
end

function love.update(dt)
end

function love.draw()
    pointer:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
