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
        -- divide by 2 to speed up moving through the sequence
        return (3 * n + 1) / 2
    end
end

local cw, ch
local angle = 0.1
local len = 4

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
    love.graphics.setLineWidth(0.1)
    for i = 1, 10000 do
        love.graphics.origin()
        love.graphics.translate(cw / 2, ch)
        local n = i
        local sequence = {}
        while n ~= 1 do
            table.insert(sequence, n)
            n = collatz(n)
        end
        table.insert(sequence, 1)

        -- Visualize the collatz points list in the reverse order.
        for j = #sequence, 1, -1 do
            local v = sequence[j]
            if v % 2 == 0 then
                love.graphics.rotate(angle)
                love.graphics.setColor(1, 1, 1, 0.2)
            else
                love.graphics.rotate(-angle)
                love.graphics.setColor(1, 1, 1, 0.2)
            end
            love.graphics.line(0, 0, 0, -len)
            love.graphics.translate(0, -len)
        end
    end
end

-- escape to exit
-- "s" to save a screenshot
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "s" then
        love.graphics.captureScreenshot('collatz-' .. os.time() .. ".png")
    end
end
