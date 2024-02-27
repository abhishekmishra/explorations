--- main.lua: A simple love2d shader example with some basic shaders.
--
-- date: 26/2/2024
-- author: Abhishek Mishra

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
        shader = shader
    }
    return program
end

local programs = {
    shaderProg("Identity", "shader/identity.glsl"),
    shaderProg("Grayscale", "shader/grayscale.glsl"),
    shaderProg("Red Channel", "shader/redchannel.glsl"),
    shaderProg("RGB Bands", "shader/rgbbands.glsl")
}

local shaderId
local cw, ch

-- Load the image to draw
local imgToDraw = love.graphics.newImage("rose.png")

--- set the current shader id to 1 and get the canvas size
function love.load()
    shaderId = 1
    cw, ch = love.graphics.getWidth(), love.graphics.getHeight()
end

--- draw a sample drawing with the current shader
function love.draw()
    local currentProgram = programs[shaderId]
    love.graphics.setShader(currentProgram.shader)

    --draw something here
    love.graphics.setColor(0.1, 0.15, 0.2, 1)
    love.graphics.rectangle("fill", 100, 100, 200, 100)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 100, 200, 200, 100)

    -- draw the image in rose.png
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(imgToDraw, 0, 0, 0, 0.5, 0.5)

    love.graphics.setShader()

    --draw the name of the current shader at the top left of the screen
    love.graphics.setColor(0, 0.1, 0.1, 1)
    love.graphics.print('Shader: ' .. currentProgram.name, 10, 10)

    -- show fps
    love.graphics.setColor(0, 0.2, 0.1, 1)
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