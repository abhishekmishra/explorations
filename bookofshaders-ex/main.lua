--- main.lua: Load shaders and draw with them.
-- This is an app to load and show shaders from the book "The Book of Shaders"
-- by Patricio Gonzalez Vivo and Jen Lowe.
-- The shaders are loaded from the shader folder.
--
-- (This file is copied over from love2d-pixelshader-first folder and modified)
--
-- date: 28/2/2024
-- author: Abhishek Mishra

--[[
TODO: implement pcall to catch shader errors
see https://love2d.org/forums/viewtopic.php?p=252760#p252760
and https://www.lua.org/manual/5.1/manual.html#pdf-pcall
--]]

--- Load the shader code and return this as a shader program name
-- and shader object pair
--
-- @param programName string: The name of the shader program
-- @param shaderFile string: The file path of the shader code
-- @return table: The shader program object
local function shaderProg(programName, shaderFile)
    local shaderCode = love.filesystem.read(shaderFile)
    local shader = love.graphics.newShader(shaderCode)
    local program = {
        name = programName,
        shader = shader,
        text = love.graphics.newText(love.graphics.getFont(),
            'Shader: ' .. programName)
    }

    -- store the text dimensions
    program.textWidth = program.text:getWidth()
    program.textHeight = program.text:getHeight()
    return program
end

local programs = {
    -- shaderProg("Identity", "shader/identity.glsl"),
    -- shaderProg("Ch 2: Hello World", "shader/ch02-helloworld.glsl"),
    -- shaderProg("Ch 3: Red is Abs(Sin(uTime))", "shader/ch03-redsinfn.glsl"),
    -- shaderProg("Ch 3: Exercise 01: Red is Abs(Sin(uTime)) Faster",
    --     "shader/ch03-ex01-redsinfn-faster.glsl"),
    -- shaderProg("Ch 3: Exercise 02: Red is Abs(Sin(uTime)) No Flicker",
    --     "shader/ch03-ex02-redsinfn-noflicker.glsl"),
    -- shaderProg("Ch 3: Exercise 03: RGB Pulse (Diff freq/channel)",
    --     "shader/ch03-ex03-rgbpulse.glsl"),
    -- shaderProg("Ch 3: Exercise 04: Red Green by Resolution",
    --     "shader/ch03-ex04-rg-byres.glsl"),
    -- shaderProg("Ch 3: Exercise 05: RED GREEN = mouse position",
    --     "shader/ch03-ex05-mousepos.glsl"),
    -- shaderProg("Ch 3: Exercise 06: RG = mouse pos, B = pulse",
    --     "shader/ch03-ex06-mousepulse.glsl"),
    -- shaderProg("Ch 5: Line and Gradient",
    --     "shader/ch05-line.glsl"),
    -- shaderProg("Ch 5: Curved Line (y=x^n) and Gradient",
    --     "shader/ch05-curved-line.glsl"),
    -- shaderProg("Ch 5: Plot exp[red]/log[green]/sqrt[blue] and Gradient",
    --     "shader/ch05-exp-log-sqrt.glsl"),
    shaderProg("Ch 6: Mixtures of two colors",
        "shader/ch06-color-mix.glsl"),
}

local shaderId
local cw, ch
local fpsText = love.graphics.newText(love.graphics.getFont(), 'FPS: 111')
local fpsTextWidth = fpsText:getWidth()
local fpsTextHeight = fpsText:getHeight()
local mousePosition = { x = 0, y = 0 }

--- set the current shader id to 1 and get the canvas size
function love.load()
    shaderId = 1
    cw, ch = love.graphics.getWidth(), love.graphics.getHeight()
end

--- draw a sample drawing with the current shader
function love.draw()
    local currentProgram = programs[shaderId]
    love.graphics.setShader(currentProgram.shader)

    -- send the delta time to the shader if used
    if currentProgram.shader:hasUniform("uDeltaTime") then
        currentProgram.shader:send("uDeltaTime", love.timer.getDelta())
    end

    -- send the time to the shader if used
    if currentProgram.shader:hasUniform("uTime") then
        currentProgram.shader:send("uTime", love.timer.getTime())
    end

    -- send the mouse position to the shader if used
    if currentProgram.shader:hasUniform("uMouse") then
        currentProgram.shader:send("uMouse", { mousePosition.x, mousePosition.y })
    end

    -- draw a white rectangle to fill the screen
    -- this is needed so that the shader is applied to the whole screen
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, cw, ch)

    -- unset the shader for all further drawing
    love.graphics.setShader()

    --draw the name of the current shader at the top left of the screen
    -- first draw a rectangle the size of the text
    love.graphics.setColor(0.45, 0.45, 0.45, 0.7)
    love.graphics.rectangle("fill", 0, 10, currentProgram.textWidth + 20,
        currentProgram.textHeight + 2)
    love.graphics.setColor(0.01, 0.14, 0.015, 1)
    love.graphics.draw(currentProgram.text, 10, 10)

    -- show fps
    -- first draw a rectangle the size of fps text
    love.graphics.setColor(0.45, 0.45, 0.45, 0.7)
    love.graphics.rectangle("fill", 0, ch - 21, fpsTextWidth + 20,
        fpsTextHeight + 2)
    love.graphics.setColor(0.1, 0.1, 0.3, 1)
    love.graphics.print('FPS: ' .. love.timer.getFPS(),
        10, ch - 20)
end

--- change the current shader to the next one
-- if the current shader is the last one, then change to the first one
local function nextShader()
    shaderId = shaderId + 1
    if shaderId > #programs then
        shaderId = 1
    end
end

--- change the current shader to the previous one
-- if the current shader is the first one, then change to the last one
local function prevShader()
    shaderId = shaderId - 1
    if shaderId < 1 then
        shaderId = #programs
    end
end

--- escape to exit
-- space or enter to change the shader
-- left arrow to change to the previous shader
-- right arrow to change to the next shader
function love.keypressed(key)
    if key == "escape" then
        print('Exiting...')
        love.event.quit()
    end

    -- space or enter to change the shader
    if key == "space" or key == "return" or key == "kpenter" then
        nextShader()
    end

    -- left arrow to change the shader
    if key == "left" then
        prevShader()
    end

    -- right arrow to change the shader
    if key == "right" then
        nextShader()
    end
end

--- left click to change the shader
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        nextShader()
    end
end

--- update the mouse position
function love.mousemoved(x, y, dx, dy, istouch)
    mousePosition.x = x
    mousePosition.y = y
end
