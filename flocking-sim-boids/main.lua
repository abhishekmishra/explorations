--- main.lua: Flocking Simulation in LÖVE using boids. Based on a video by
-- Daniel Shiffman on the Coding Train youtube channel.
--
-- date: 23/3/2024
-- author: Abhishek Mishra

local Class = require('middleclass')
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

-- A Control Panel Class which extends Layout
local ControlPanel = Class('ControlPanel', Layout)

function ControlPanel:initialize(w, h)
    Layout.initialize(self, Rect(0, 0, w, h),
        {
            layout = 'column',
            bgColor = { 0.1, 0.1, 0.5 },
        }
    )

    -- sliders
    self.alignmentSlider = nil
    self.cohesionSlider = nil
    self.separationSlider = nil

    -- slider labels
    local alignmentLabel
    local cohesionLabel
    local separationLabel
    self.fpsLabel = nil

    alignmentLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Alignment:',
            bgColor = { 0.2, 0.2, 0, 1 },
            align = 'center'
        }
    )
    self:addChild(alignmentLabel)

    self.alignmentSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 1.5,
            currentValue = 0.5,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    self.alignmentSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        alignmentLabel:setText('Alignment: ' .. value)
    end)

    self:addChild(self.alignmentSlider)
    -- set initial Alignment
    alignmentLabel:setText('Alignment: ' .. self.alignmentSlider.currentValue)


    local emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )
    self:addChild(emptyPanel)

    cohesionLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Cohesion:',
            bgColor = { 0.2, 0.2, 0, 1 },
            align = 'center'
        }
    )

    self:addChild(cohesionLabel)

    self.cohesionSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 1,
            currentValue = 0.1,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    self.cohesionSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        cohesionLabel:setText('Cohesion: ' .. value)
    end)

    self:addChild(self.cohesionSlider)
    -- set initial Cohesion
    cohesionLabel:setText('Cohesion: ' .. self.cohesionSlider.currentValue)

    emptyPanel = Panel(
        Rect(0, 0, cpWidth, 20),
        {
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )
    self:addChild(emptyPanel)

    separationLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'Separation:',
            bgColor = { 0.2, 0.2, 0, 1 },
            align = 'center'
        }
    )

    self:addChild(separationLabel)

    self.separationSlider = Slider(
        Rect(0, 0, cpWidth, 20),
        {
            minValue = 0,
            maxValue = 1,
            currentValue = 0.4,
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )

    self.separationSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        separationLabel:setText('Separation: ' .. value)
    end)

    self:addChild(self.separationSlider)
    -- set initial Separation
    separationLabel:setText('Separation: ' .. self.separationSlider.currentValue)

    emptyPanel = Panel(
        Rect(0, 0, cpWidth, 200),
        {
            bgColor = { 0.2, 0.2, 0, 1 }
        }
    )
    self:addChild(emptyPanel)

    self.fpsLabel = Text(
        Rect(0, 0, cpWidth, 20),
        {
            text = 'FPS: 0',
            bgColor = { 0.2, 0.2, 0, 1 },
            align = 'center'
        }
    )
    self:addChild(self.fpsLabel)
end

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
            bgColor = { 0.1, 0.1, 0.1 },
            layout = 'row',
        }
    )

    boidPanel = Layout(
        Rect(0, 0, cw - cpWidth, ch),
        {
            bgColor = { 0.1, 0.5, 0.1 },
        }
    )
    top:addChild(boidPanel)

    controlPanel = ControlPanel(cpWidth, ch)

    top:addChild(controlPanel)

    top:show()

    initBoids()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    top:update(dt)

    for _, boid in ipairs(boids) do
        boid:edges()
        boid:flock(boids, controlPanel.alignmentSlider, controlPanel.cohesionSlider, controlPanel.separationSlider)
        boid:update()
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    --update fps
    controlPanel.fpsLabel:setText('FPS: ' .. love.timer.getFPS())

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
