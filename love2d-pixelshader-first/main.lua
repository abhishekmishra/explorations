--- main.lua: A simple love2d shader example with some basic shaders.
--
-- date: 26/2/2024
-- author: Abhishek Mishra

local function createShaderProgram(programName, shaderCode)
    local shader = love.graphics.newShader(shaderCode)
    local program = {
        name = programName,
        shader = shader
    }
    return program
end

local identityShader = love.filesystem.read("shader/identity.glsl")
local grayscaleShader = love.filesystem.read("shader/grayscale.glsl")

local programs = {
    createShaderProgram("Identity", identityShader),
    createShaderProgram("Grayscale", grayscaleShader)
}

local currentId
local currentProgram
local cw, ch

function love.load()
    currentId = 1
    currentProgram = programs[currentId]
    cw, ch = love.graphics.getWidth(), love.graphics.getHeight()
end

function love.update()

end

function love.draw()
    love.graphics.setShader(currentProgram.shader)

    --draw something here
    love.graphics.setColor(0.1, 0.15, 0.2, 1)
    love.graphics.rectangle("fill", 100, 100, 200, 100)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 100, 200, 200, 100)

    love.graphics.setShader()

    --draw the name of the current shader at the top left of the screen
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.print('Shader: ' .. currentProgram.name, 10, 10)

    -- show fps
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('FPS: ' .. love.timer.getFPS(),
        cw - 50, ch - 20)
end

local function nextShader()
    currentId = currentId + 1
    if currentId > #programs then
        currentId = 1
    end
    currentProgram = programs[currentId]
end

local function prevShader()
    currentId = currentId - 1
    if currentId < 1 then
        currentId = #programs
    end
    currentProgram = programs[currentId]
end

--- escape to exit
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