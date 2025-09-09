-- camera.lua
-- Simple zoomable, pannable camera for Love2D
local camera = {}
camera.__index = camera

function camera.new(opts)
    opts = opts or {}
    local self = setmetatable({
        x = opts.x or 0,
        y = opts.y or 0,
        scale = opts.scale or 1,
        minScale = opts.minScale or 0.25,
        maxScale = opts.maxScale or 4,
        wheelStep = opts.wheelStep or 1.1, -- zoom factor per wheel tick
        dragging = false,
        dragStart = {x = 0, y = 0}, -- screen coords when drag started
        camStart = {x = 0, y = 0}, -- camera pos when drag started
        vx = 0, vy = 0, -- velocity for inertia
        damp = opts.damp or 8, -- damping for inertia (higher = quicker stop)
        bounds = opts.bounds, -- {xMin, yMin, xMax, yMax} in world coords (optional)
        enableInertia = opts.enableInertia or false
    }, camera)
    return self
end

-- Apply camera transform (call before drawing world objects)
function camera:attach()
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

-- Revert transform
function camera:detach()
    love.graphics.pop()
end

-- Convert screen coords (pixels, e.g. mouse) -> world coords
function camera:screenToWorld(sx, sy)
    local cx = (sx - love.graphics.getWidth()/2) / self.scale + self.x
    local cy = (sy - love.graphics.getHeight()/2) / self.scale + self.y
    return {x = cx, y = cy}
end

-- Convert world coords -> screen coords
function camera:worldToScreen(wx, wy)
    local sx = (wx - self.x) * self.scale + love.graphics.getWidth()/2
    local sy = (wy - self.y) * self.scale + love.graphics.getHeight()/2
    return {x = sx, y = sy}
end

-- Move camera by world delta
function camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
    self:_clampToBounds()
end

-- Set camera position
function camera:setPosition(x, y)
    self.x = x; self.y = y
    self:_clampToBounds()
end

-- Zoom centered on screen coordinate (sx, sy). factor >1 zooms in.
function camera:zoomAt(factor, sx, sy)
    sx = sx or love.mouse.getX()
    sy = sy or love.mouse.getY()

    -- world position under the screen point before scale change
    local before = self:screenToWorld(sx, sy)

    self.scale = math.max(self.minScale, math.min(self.maxScale, self.scale * factor))

    -- world position under the screen point after scale change
    local after = self:screenToWorld(sx, sy)

    -- adjust camera so the point under the mouse stays the same world point
    self.x = self.x + (before.x - after.x)
    self.y = self.y + (before.y - after.y)

    self:_clampToBounds()
end

-- Handle mouse pressed (call from love.mousepressed)
function camera:mousepressed(sx, sy, button)
    if button == 1 then
        self.dragging = true
        self.dragStart.x, self.dragStart.y = sx, sy
        self.camStart.x, self.camStart.y = self.x, self.y
        self.vx, self.vy = 0, 0
    end
end

-- Handle mouse released (call from love.mousereleased)
function camera:mousereleased(sx, sy, button)
    if button == 1 then
        self.dragging = false
        -- optionally compute inertia velocity from last movement (optional)
    end
end

-- Handle mouse moved (call from love.mousemoved)
function camera:mousemoved(sx, sy, dx, dy)
    if self.dragging then
        -- dx,dy are screen deltas; convert to world deltas
        local worldDx = -dx / self.scale
        local worldDy = -dy / self.scale
        self.x = self.x + worldDx
        self.y = self.y + worldDy

        if self.enableInertia then
            -- set velocity proportional to movement
            self.vx = worldDx * 60 -- approx pixels/sec (tweak as needed)
            self.vy = worldDy * 60
        end

        self:_clampToBounds()
    end
end

-- Handle wheel moved (call from love.wheelmoved)
function camera:wheelmoved(dx, dy)
    if dy ~= 0 then
        local factor = self.wheelStep ^ dy
        local mx, my = love.mouse.getPosition()
        self:zoomAt(factor, mx, my)
    end
end

-- Set boundaries for the camera in world coordinates: {xMin, yMin, xMax, yMax}
function camera:setBounds(bounds)
    self.bounds = bounds
    self:_clampToBounds()
end

function camera:_clampToBounds()
    if not self.bounds then return end
    -- compute visible half sizes in world coords
    local hw = (love.graphics.getWidth() / 2) / self.scale
    local hh = (love.graphics.getHeight() / 2) / self.scale
    local xMin, yMin, xMax, yMax = unpack(self.bounds)
    -- ensure camera.x,y keeps screen inside bounds
    self.x = math.max(xMin + hw, math.min(xMax - hw, self.x))
    self.y = math.max(yMin + hh, math.min(yMax - hh, self.y))
end

-- Update camera (call from love.update(dt))
function camera:update(dt)
    if self.enableInertia and not self.dragging then
        -- apply velocity and damping
        if math.abs(self.vx) > 0.01 or math.abs(self.vy) > 0.01 then
            self.x = self.x + self.vx * dt
            self.y = self.y + self.vy * dt
            -- exponential damping
            local k = math.exp(-self.damp * dt)
            self.vx = self.vx * k
            self.vy = self.vy * k
            self:_clampToBounds()
        else
            self.vx, self.vy = 0, 0
        end
    end
end

return setmetatable({new = camera.new}, {__call = function(_,...) return camera.new(...) end})