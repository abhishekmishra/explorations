--- main.lua: Collatz Simulation in LÖVE
-- date: 7/3/2024
-- author: Abhishek Mishra

--- Calculate the next collatz number from the given one.
-- @param n: The current number
-- @return: The next number in the collatz sequence
local function collatz(n)
    if n % 2 == 0 then
        return n / 2
    else
        return 3 * n + 1
    end
end

local cw, ch
local angle = math.pi / 3
local len = 10

--- love.load: Called once at the start of the simulation
function love.load()
    cw = love.graphics.getWidth()
    ch = love.graphics.getHeight()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0)
    for i = 1, 1000 do
        love.graphics.origin()
        love.graphics.translate(cw / 2, ch)
        local n = i
        while n ~= 1 do
            n = collatz(n)
            if n % 2 == 0 then
                love.graphics.rotate(angle)
            else
                love.graphics.rotate(-angle)
            end
            love.graphics.setColor(1, 1, 1)
            love.graphics.line(0, 0, 0, -len)
            love.graphics.translate(0, -len)
        end
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
