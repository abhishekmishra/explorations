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

-- minimap settings (top-right corner)
local minimap = {
    x = 400 - 210,  -- screen x (adjust or compute from love.graphics.getWidth())
    y = 10,          -- screen y
    w = 200,         -- width in pixels
    h = 150,         -- height in pixels
    pad = 4,         -- inner padding
    showObjects = false, -- draw small objects on minimap
}

-- helper: draw minimap and viewport
local function drawMinimap(cam, worldBounds)
    -- worldBounds = {xMin, yMin, xMax, yMax}
    local mx, my, mw, mh = minimap.x, minimap.y, minimap.w, minimap.h
    -- background / border
    love.graphics.push()
    love.graphics.setColor(0,0,0,0.6)
    love.graphics.rectangle("fill", mx-1, my-1, mw+2, mh+2) -- border shadow
    love.graphics.setColor(0.08,0.08,0.08,0.95)
    love.graphics.rectangle("fill", mx, my, mw, mh)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", mx, my, mw, mh)

    -- compute scaling from world -> minimap inner rect
    local innerX = mx + minimap.pad
    local innerY = my + minimap.pad
    local innerW = mw - minimap.pad*2
    local innerH = mh - minimap.pad*2

    local xMin, yMin, xMax, yMax = unpack(worldBounds)
    local worldW = xMax - xMin
    local worldH = yMax - yMin

    -- keep aspect ratio (fit entire world inside minimap)
    local sx = innerW / worldW
    local sy = innerH / worldH
    local scale = math.min(sx, sy)

    -- compute offsets so world (xMin..xMax,yMin..yMax) maps to inner rect center
    local worldPixelW = worldW * scale
    local worldPixelH = worldH * scale
    local offsetX = innerX + (innerW - worldPixelW) / 2
    local offsetY = innerY + (innerH - worldPixelH) / 2

    -- draw simplified world (we'll draw circles from the 'world' table scaled)
    if minimap.showObjects then
        for _, obj in ipairs(world) do
            local px = (obj.x - xMin) * scale + offsetX
            local py = (obj.y - yMin) * scale + offsetY
            local r = math.max(1, (obj.r * scale)) -- keep visible
            love.graphics.setColor(0.85, 0.7, 0.3, 0.9)
            love.graphics.circle("fill", px, py, r)
        end
    end

    -- draw camera viewport rect (what the camera currently sees)
    -- compute world rect currently visible by camera:
    local hw = (love.graphics.getWidth() / 2) / cam.scale
    local hh = (love.graphics.getHeight() / 2) / cam.scale
    local viewLeft  = cam.x - hw
    local viewTop   = cam.y - hh
    local viewRight = cam.x + hw
    local viewBot   = cam.y + hh

    -- map view rect to minimap pixels
    local vx = (viewLeft - xMin) * scale + offsetX
    local vy = (viewTop  - yMin) * scale + offsetY
    local vw = (viewRight - viewLeft) * scale
    local vh = (viewBot  - viewTop ) * scale

    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 0.2, 0.2, 0.95)
    love.graphics.rectangle("line", vx, vy, vw, vh)

    -- small cross showing camera center
    local cx = (cam.x - xMin) * scale + offsetX
    local cy = (cam.y - yMin) * scale + offsetY
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.line(cx-4, cy, cx+4, cy)
    love.graphics.line(cx, cy-4, cx, cy+4)

    love.graphics.pop()
end

-- helper: check if a screen point is inside minimap
local function minimapContains(sx, sy)
    return sx >= minimap.x and sx <= minimap.x + minimap.w and
           sy >= minimap.y and sy <= minimap.y + minimap.h
end

-- helper: convert minimap click -> world coords and center camera there
local function minimapToWorld(sx, sy, worldBounds)
    -- same mapping as drawMinimap; reuse code (or refactor to single function)
    local innerX = minimap.x + minimap.pad
    local innerY = minimap.y + minimap.pad
    local innerW = minimap.w - minimap.pad*2
    local innerH = minimap.h - minimap.pad*2

    local xMin, yMin, xMax, yMax = unpack(worldBounds)
    local worldW = xMax - xMin
    local worldH = yMax - yMin

    local sxScale = innerW / worldW
    local syScale = innerH / worldH
    local scale = math.min(sxScale, syScale)

    local worldPixelW = worldW * scale
    local worldPixelH = worldH * scale
    local offsetX = innerX + (innerW - worldPixelW) / 2
    local offsetY = innerY + (innerH - worldPixelH) / 2

    -- clamp click inside inner area
    local cx = math.max(offsetX, math.min(offsetX + worldPixelW, sx))
    local cy = math.max(offsetY, math.min(offsetY + worldPixelH, sy))

    -- convert to world coords
    local worldX = (cx - offsetX) / scale + xMin
    local worldY = (cy - offsetY) / scale + yMin
    return worldX, worldY
end

-- integrate into love.draw (after cam:detach())
-- drawMinimap(cam, {-1000, -1000, 1000, 1000})

-- integrate into love.mousepressed to allow clicking minimap
-- in love.mousepressed(x,y,button):
-- if button == 1 and minimapContains(x,y) then
--     local wx, wy = minimapToWorld(x,y, {-1000, -1000, 1000, 1000})
--     cam:setPosition(wx, wy)
-- end

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
    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.print(string.format("Scale: %.2f  Pos: (%.1f, %.1f)\nDrag: left mouse, Wheel to zoom\nArrows/WASD to pan", cam.scale, cam.x, cam.y), 10, 10)

    drawMinimap(cam, {-1000, -1000, 1000, 1000})
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
    -- pan with arrow keys or WASD
    local panStep = 20 / cam.scale
    if key == "up" or key == "w" then
        cam:move(0, -panStep)
    elseif key == "down" or key == "s" then
        cam:move(0, panStep)
    elseif key == "left" or key == "a" then
        cam:move(-panStep, 0)
    elseif key == "right" or key == "d" then
        cam:move(panStep, 0)
    end
end

function love.mousepressed(x,y,button)
    cam:mousepressed(x,y,button)
    if button == 1 and minimapContains(x,y) then
        local wx, wy = minimapToWorld(x,y, {-1000, -1000, 1000, 1000})
        cam:setPosition(wx, wy)
    end
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