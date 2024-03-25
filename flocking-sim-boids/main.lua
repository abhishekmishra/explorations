--- main.lua: Flocking Simulation in LÖVE using boids. Based on a video by
-- Daniel Shiffman on the Coding Train youtube channel.
--
-- date: 23/3/2024
-- author: Abhishek Mishra

local Boid = require('boid')
local nl = require('ne0luv')
local Layout = nl.Layout
local Rect = nl.Rect
local Slider = nl.Slider
local Panel = nl.Panel
local Text = nl.Text

local cw, ch
local top
local boidPanel
local controlPanel
local cpWidth = 150

-- sliders
local maxForceSlider
local maxSpeedSlider
local perceptionSlider

-- slider labels
local maxForceLabel
local maxSpeedLabel
local perceptionLabel


-- random seed
math.randomseed(os.time())

local boids

local function initBoids()
    boids = {}
    for i = 1, 100 do
        local b = Boid(boidPanel)
        b.maxForce = maxForceSlider.currentValue
        b.maxSpeed = maxSpeedSlider.currentValue
        b.perceptionRadius = perceptionSlider.currentValue
        table.insert(boids, b)
    end
end

--- love.load: Called once at the start of the simulation
function love.load()
    cw, ch = love.graphics.getWidth(), love.graphics.getHeight()
    top = Layout(
        Rect(0, 0, cw, ch),
        {
            bgColor = {0.1, 0.1, 0.1},
            layout = 'row',
        }
    )

    boidPanel = Layout(
        Rect(0, 0, cw - cpWidth, ch),
        {
            bgColor = {0.1, 0.5, 0.1},
        }
    )
    top:addChild(boidPanel)

    controlPanel = Layout(
        Rect(0, 0, cpWidth, ch),
        {
            layout = 'column',
            bgColor = {0.1, 0.1, 0.5},
        }
    )

    maxForceLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Max Force:',
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(maxForceLabel)

    maxForceSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 10,
            currentValue = 2,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    maxForceSlider:addChangeHandler(function(value)
        initBoids()
        maxForceLabel:setText('Max Force: ' .. value)
    end)

    controlPanel:addChild(maxForceSlider)
    -- set initial max force
    maxForceLabel:setText('Max Force: ' .. maxForceSlider.currentValue)


    local emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(emptyPanel)

    maxSpeedLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Max Speed:',
            bgColor = {0.2, 0.2, 0, 1}
        }
    )

    controlPanel:addChild(maxSpeedLabel)

    maxSpeedSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 10,
            currentValue = 0.1,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    maxSpeedSlider:addChangeHandler(function(value)
        initBoids()
        maxSpeedLabel:setText('Max Speed: ' .. value)
    end)

    controlPanel:addChild(maxSpeedSlider)
    -- set initial max speed
    maxSpeedLabel:setText('Max Speed: ' .. maxSpeedSlider.currentValue)

    emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(emptyPanel)

    perceptionLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Perception:',
            bgColor = {0.2, 0.2, 0, 1}
        }
    )

    controlPanel:addChild(perceptionLabel)

    perceptionSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 500,
            currentValue = 1,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    perceptionSlider:addChangeHandler(function(value)
        initBoids()
        perceptionLabel:setText('Perception: ' .. value)
    end)

    controlPanel:addChild(perceptionSlider)
    -- set initial perception
    perceptionLabel:setText('Perception: ' .. perceptionSlider.currentValue)

    top:addChild(controlPanel)

    top:show()

    initBoids()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    top:update(dt)

    for _, boid in ipairs(boids) do
        boid:edges()
        boid:flock(boids)
        boid:update()
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    top:draw()

    for _, boid in ipairs(boids) do
        boid:show()
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- love.mousepressed: Called when a mouse button is pressed
function love.mousepressed(x, y, button, istouch, presses)
    top:mousepressed(x, y, button, istouch, presses)
end

--- love.mousereleased: Called when a mouse button is released
function love.mousereleased(x, y, button, istouch, presses)
    top:mousereleased(x, y, button, istouch, presses)
end

--- love.mousemoved: Called when the mouse is moved
function love.mousemoved(x, y, dx, dy, istouch)
    top:mousemoved(x, y, dx, dy, istouch)
end