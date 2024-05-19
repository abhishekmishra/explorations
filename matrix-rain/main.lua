--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainSheet = require 'rainsheet'


local cw, ch

local sheet


function love.load()
    cw, ch = love.graphics.getDimensions()

    local numRows = 50
    local numCols = 50
    local maxRainSpeed = 350

    -- create a font and set it as the active font
    -- with the default face, but size is equal to cw/numCols
    local font = love.graphics.newFont(cw/numCols)
    love.graphics.setFont(font)

    sheet = RainSheet({
        numRows = numRows,
        numCols = numCols,
        maxVy = maxRainSpeed,
        cw = cw,
        ch = ch
    })
end



function love.update(dt)
    sheet:update(dt)
end



function love.draw()
    sheet:draw()
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

