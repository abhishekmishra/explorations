--- main.lua: Hexagon grid exploration
-- date: 2025-09-09
-- author: Abhishek Mishra

local Camera = require "camera"

--- The list of angle of the vertices of the hexagon tile from its center
local hexagonAngles = {
    0,
    math.pi/3,
    2 * math.pi/3,
    math.pi,
    4 * math.pi/3,
    5 * math.pi/3,
}

local tiles = {}
local font

--- Create a hexagon tile given the axial coordinates and radius (s)
-- right now does nothing except return the table with
-- the coords, the center and the vertices
-- @param q
-- @param r
-- @param s
local function createHexagonTile(q, r, s)
    q = q or 0
    r = r or 0
    s = s or 10

    -- calculate the center position
    local cx = s * (3/2) * q
    local cy = s * math.sqrt(3) * (r + (q/2))

    -- calculate the positions of the vertices using the angles
    local vertices = {}
    for _, angle in ipairs(hexagonAngles) do
        local vx = cx + (s * math.cos(angle))
        local vy = cy + (s * math.sin(angle))
        table.insert(vertices, vx)
        table.insert(vertices, vy)
    end

    -- return the hexagon
    return {
        q = q,
        r = r,
        cx = cx,
        cy = cy,
        vertices = vertices
    }
end

--- Draw a hexagon tile hex with the given radius s
-- @param hex hexagon
local function drawHexagonTile (hex)
    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("fill", hex.vertices)
    love.graphics.setColor(1, 0, 0)
    love.graphics.setLineWidth(3)
    love.graphics.polygon("line", hex.vertices)
    love.graphics.setColor(0, 0, 1)
    if not hex.text then
        hex.text = love.graphics.newText(font, hex.q .. ", " .. hex.r)
    end
    love.graphics.draw(hex.text, hex.cx - hex.text:getWidth()/2, hex.cy - hex.text:getHeight()/2)
end

local cam

--- love.load: Called once at the start of the simulation
function love.load()
    font = love.graphics.newFont(12)

    cam = Camera{
        x = 0, y = 0, scale = 1,
        minScale = 0.2, maxScale = 5,
        wheelStep = 1.12,
        enableInertia = true,
        damp = 6,
    }

    -- Example bounds (a 2000x2000 world centered at 0)
    cam:setBounds({-1000, -1000, 1000, 1000})

    -- create a hundred tiles,
    -- with the axial coords calculated to fit in a rectangular grid
    for i = -10, 10 do
        for j = -10, 10 do
            local q = j
            local r = i - math.floor(j/2)
            table.insert(tiles, createHexagonTile(q, r, 30))
        end
    end
    -- for _, pt in ipairs(tiles[1].vertices) do
    --     print(pt)
    -- end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    love.graphics.clear(0.12, 0.12, 0.12)
    cam:attach()

    -- draw grid/background
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", -1000, -1000, 2000, 2000)

    for _, v in ipairs(tiles) do
        drawHexagonTile(v)
    end

    -- draw camera center marker
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill", cam.x, cam.y, 5)

    cam:detach()

    -- UI overlay (screen-space)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format("Scale: %.2f  Pos: (%.1f, %.1f)\nDrag: left mouse, Wheel to zoom\nArrows/WASD to pan", cam.scale, cam.x, cam.y), 10, 10)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    -- zoom in and out with +/-
    if key == "=" or key == "kp+" then
        cam:zoomAt(1.1, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    elseif key == "-" or key == "kp-" then
        cam:zoomAt(1/1.1, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    end
end

function love.mousepressed(x,y,button)
    cam:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
    cam:mousereleased(x,y,button)
end

function love.mousemoved(x,y,dx,dy, istouch)
    cam:mousemoved(x,y,dx,dy)
end

function love.wheelmoved(dx, dy)
    cam:wheelmoved(dx, dy)
end