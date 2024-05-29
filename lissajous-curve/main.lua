--- main.lua: <Empty> Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

-- All imports and module scope variables go here.


--- love.load: Called once at the start of the simulation
function love.load()
end



--- love.update: Called every frame, updates the simulation
function love.update(dt)
end



--- love.draw: Called every frame, draws the simulation
function love.draw()
    local text = "Empty Simulation"
    local tw = love.graphics.getFont():getWidth(text)
    -- write empty simulation in the middle of the screen
    love.graphics.print(text,
        love.graphics.getWidth() / 2 - tw / 2,
        love.graphics.getHeight() / 2 - 12)
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- main.lua: <Empty> Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

-- All imports and module scope variables go here.


--- love.load: Called once at the start of the simulation
function love.load()
end



--- love.update: Called every frame, updates the simulation
function love.update(dt)
end



--- love.draw: Called every frame, draws the simulation
function love.draw()
    local text = "Empty Simulation"
    local tw = love.graphics.getFont():getWidth(text)
    -- write empty simulation in the middle of the screen
    love.graphics.print(text,
        love.graphics.getWidth() / 2 - tw / 2,
        love.graphics.getHeight() / 2 - 12)
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

-- All imports and module scope variables go here.


--- love.load: Called once at the start of the simulation
function love.load()
end



--- love.update: Called every frame, updates the simulation
function love.update(dt)
end



--- love.draw: Called every frame, draws the simulation
function love.draw()
    local text = "Lissajous Curves Simulation"
    local tw = love.graphics.getFont():getWidth(text)
    -- write empty simulation in the middle of the screen
    love.graphics.print(text,
        love.graphics.getWidth() / 2 - tw / 2,
        love.graphics.getHeight() / 2 - 12)
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

