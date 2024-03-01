--- main.lua: A Metaballs Simulation in LÖVE
-- TODO: Add a description of the program here
-- date: 1/3/2024
-- author: Abhishek Mishra

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()
end

--- love.update: Called every frame, updates the simulation
function love.update()
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- fill the background with black
    love.graphics.setBackgroundColor(0, 0, 0)

end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- Converts HSV to RGB. (input and output range: 0 - 1)
-- see https://love2d.org/wiki/HSV_color
function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end
