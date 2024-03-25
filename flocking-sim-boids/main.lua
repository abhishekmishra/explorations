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
local alignmentSlider
local cohesionSlider
local separationSlider

-- slider labels
local alignmentLabel
local cohesionLabel
local separationLabel
local fpsLabel


-- random seed
math.randomseed(os.time())

local boids

local function initBoids()
    boids = {}
    for i = 1, 300 do
        local b = Boid(boidPanel)
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

    alignmentLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Alignment:',
            bgColor = {0.2, 0.2, 0, 1},
            align = 'center'
        }
    )
    controlPanel:addChild(alignmentLabel)

    alignmentSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 2,
            currentValue = 1.5,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    alignmentSlider:addChangeHandler(function(value)
        alignmentLabel:setText('Alignment: ' .. value)
    end)

    controlPanel:addChild(alignmentSlider)
    -- set initial Alignment
    alignmentLabel:setText('Alignment: ' .. alignmentSlider.currentValue)


    local emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(emptyPanel)

    cohesionLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Cohesion:',
            bgColor = {0.2, 0.2, 0, 1},
            align = 'center'
        }
    )

    controlPanel:addChild(cohesionLabel)

    cohesionSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 2,
            currentValue = 1,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    cohesionSlider:addChangeHandler(function(value)
        cohesionLabel:setText('Cohesion: ' .. value)
    end)

    controlPanel:addChild(cohesionSlider)
    -- set initial Cohesion
    cohesionLabel:setText('Cohesion: ' .. cohesionSlider.currentValue)

    emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(emptyPanel)

    separationLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Separation:',
            bgColor = {0.2, 0.2, 0, 1},
            align = 'center'
        }
    )

    controlPanel:addChild(separationLabel)

    separationSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 2,
            currentValue = 2,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    separationSlider:addChangeHandler(function(value)
        separationLabel:setText('Separation: ' .. value)
    end)

    controlPanel:addChild(separationSlider)
    -- set initial Separation
    separationLabel:setText('Separation: ' .. separationSlider.currentValue)

    emptyPanel = Panel(
        Rect(0, 0, cpWidth, 200),
        {
            bgColor = {0.2, 0.2, 0, 1}
        }
    )
    controlPanel:addChild(emptyPanel)

    fpsLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'FPS: 0',
            bgColor = {0.2, 0.2, 0, 1},
            align = 'center'
        }
    )
    controlPanel:addChild(fpsLabel)

    top:addChild(controlPanel)

    top:show()

    initBoids()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    top:update(dt)

    for _, boid in ipairs(boids) do
        boid:edges()
        boid:flock(boids, alignmentSlider, cohesionSlider, separationSlider)
        boid:update()
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    --update fps
    fpsLabel:setText('FPS: ' .. love.timer.getFPS())

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