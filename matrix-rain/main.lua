--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainSheet = require 'rainsheet'


local cw, ch
local fpsOn
local sheet


function love.load()
    cw, ch = love.graphics.getDimensions()

    fpsOn = false

    local numRows = 40
    local numCols = cw / (ch/numRows)
    local maxRainSpeed = (ch/numRows) * 20

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

    -- draw fps
    if fpsOn then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("FPS: "..tostring(love.timer.getFPS()), cw - 100, ch - 25)
    end
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    -- check for modifiers
    CTRL_KEY = ""
    SHIFT_KEY = ""
    ALT_KEY = ""
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        CTRL_KEY = "CTRL"
    end

    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        SHIFT_KEY = "SHIFT"
    end

    if love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt") then
        ALT_KEY = "ALT"
    end

    if CTRL_KEY and key == "f" then
        fpsOn = not fpsOn
    end
end

