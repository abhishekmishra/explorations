local Class = require 'middleclass'

local Vehicle = Class('Vehicle')

function Vehicle:initialize()

end

function Vehicle:draw()
    love.graphics.push()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 100, 100, 50)

    love.graphics.pop()
end

return Vehicle
