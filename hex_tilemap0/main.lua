--- main.lua: Hexagon grid exploration
-- date: 2025-09-09
-- author: Abhishek Mishra

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

--- love.load: Called once at the start of the simulation
function love.load()
    font = love.graphics.newFont(12)

    -- create a hundred tiles,
    -- with the axial coords calculated to fit in a rectangular grid
    for i = 0, 10 do
        for j = 0, 10 do
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
    for k, v in ipairs(tiles) do
        drawHexagonTile(v)
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
