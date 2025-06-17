--- main.lua: City Skyline Animation in LÖVE
-- date: 16/6/2025
-- author: Abhishek Mishra

local cw, ch
local canvas

--- Convert RGB values to a color in the range 0..1 for each component.
-- Using love.math.colorFromBytes we can specify color components in the range 0..255.
-- love.graphics.setColor(love.math.colorFromBytes(128, 234, 255))

local function get_colour_from_bytes(col)
    local r, g, b, a = col.r or 0, col.g or 0, col.b or 0, col.a or 255
    local cr, cg, cb, ca = love.math.colorFromBytes(r, g, b, a)
    return { r = cr, g = cg, b = cb, a = ca }
end

--- seed the random number generator
math.randomseed(os.time())

--- Convert HSV to RGB
--- @param h: hue (0-360)
--- @param s: saturation (0-1)
--- @param v: value/brightness (0-1)
--- @return r, g, b: RGB values (0-1)
local function hsv_to_rgb(h, s, v)
    local r, g, b
    local i = math.floor(h / 60) % 6
    local f = h / 60 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    else
        r, g, b = v, p, q
    end
    
    return r, g, b
end

--- get random window colour using HSV variations
--- generates colors centered around three window types: dark, warm orange, cool blue
--- @return table: a table containing r, g, b, a values
local function get_random_window_colour_hsv()
    local window_type = math.random(1, 3)
    local r, g, b
    
    if window_type == 1 then
        -- Dark windows (lights out) - very low value/brightness
        local hue = math.random() * 360  -- any hue (doesn't matter much for dark colors)
        local saturation = 0.1 + math.random() * 0.3  -- low saturation (0.1-0.4)
        local value = 0.0 + math.random() * 0.15      -- very low brightness (0.0-0.15)
        r, g, b = hsv_to_rgb(hue, saturation, value)
    elseif window_type == 2 then
        -- Warm orange lights
        local hue = 15 + math.random() * 45    -- orange-yellow range (15-60°)
        local saturation = 0.7 + math.random() * 0.3  -- high saturation (0.7-1.0)
        local value = 0.6 + math.random() * 0.4       -- medium-high brightness (0.6-1.0)
        r, g, b = hsv_to_rgb(hue, saturation, value)
    else
        -- Cool blue lights
        local hue = 180 + math.random() * 60   -- blue-cyan range (180-240°)
        local saturation = 0.4 + math.random() * 0.6  -- medium-high saturation (0.4-1.0)
        local value = 0.5 + math.random() * 0.5       -- medium-high brightness (0.5-1.0)
        r, g, b = hsv_to_rgb(hue, saturation, value)
    end
    
    return {
        r = r,
        g = g,
        b = b,
        a = 1
    }
end

--- get random window colour (original version)
--- chooses among a set of predefined colours
--- @return table: a table containing r, g, b, a values
local function get_random_window_colour()
    -- declare a list of 3 colours black, orange, and light blue
    local colours = {
        get_colour_from_bytes({ r = 0, g = 0, b = 0, a = 255 }),      -- black
        get_colour_from_bytes({ r = 255, g = 165, b = 0, a = 255 }),  -- orange
        get_colour_from_bytes({ r = 173, g = 216, b = 230, a = 255 }) -- light blue
    }
    -- choose a random colour from the list
    local index = math.random(1, #colours)
    return colours[index]
end

--- get random building colour using HSV color space
--- generates more vibrant and varied colors than RGB
--- @return table: a table containing r, g, b, a values
local function get_random_building_colour_hsv()
    -- Generate random HSV values
    local hue = math.random() * 360              -- Full hue range (0-360)
    local saturation = 0.3 + math.random() * 0.7 -- 0.3-1.0 for good color saturation
    local value = 0.4 + math.random() * 0.5      -- 0.4-0.9 for visible buildings

    -- Convert HSV to RGB using our custom function
    local r, g, b = hsv_to_rgb(hue, saturation, value)

    return {
        r = r,
        g = g,
        b = b,
        a = 1
    }
end

--- Create a building at a random position,
-- with random dimensions
-- random appearance (colour, opacity)
-- random number of num_floors
-- and random number of num_windows
local function create_building()
    local building = {}
    building.position = {
        x = math.random(0, cw - (0.1 * cw)),
        y = math.random(0, ch - (0.1 * ch)),
        z = math.random(1, 10)
    }
    building.size = {
        width = math.random(50, 100),
        height = ch - building.position.y
    }

    -- Use random HSV color for more vibrant buildings
    building.color = get_random_building_colour_hsv()

    building.num_floors = math.random(3, 10)
    building.num_windows = math.random(5, 20)

    -- create the windows list to contain its colours
    -- one for each window in the building
    building.windows = {}
    for i = 1, building.num_floors do
        for j = 1, building.num_windows do
            -- get a random window colour using HSV variations
            local window_color = get_random_window_colour_hsv()
            table.insert(building.windows, window_color)
        end
    end
    return building
end

--- draw a building
---- @param building: table containing building properties
local function draw_building(building)
    -- apply colour with a perspective_factor
    local perspective_factor = 1.0 - (building.position.z / 15)
    love.graphics.setColor(
        building.color.r * perspective_factor,
        building.color.g * perspective_factor,
        building.color.b * perspective_factor,
        building.color.a
    )
    love.graphics.rectangle("fill", building.position.x, building.position.y, building.size.width, building.size.height)

    -- Draw num_windows
    local building_cell_width = building.size.width / building.num_windows
    local building_cell_height = building.size.height / building.num_floors
    local window_width_gap = 0.1 * building_cell_width
    local window_height_gap = 0.15 * building_cell_height

    for i = 0, building.num_windows - 1 do
        for j = 0, building.num_floors - 1 do
            local num_window = j * building.num_windows + i + 1
            local window_color = building.windows[num_window]

            love.graphics.setColor(
                window_color.r * perspective_factor,
                window_color.g * perspective_factor,
                window_color.b * perspective_factor,
                window_color.a)
            -- Draw each window
            love.graphics.rectangle("fill",
                building.position.x + i * building_cell_width + window_width_gap,
                building.position.y + j * building_cell_height + window_height_gap,
                building_cell_width - (2 * window_width_gap),
                building_cell_height - (2 * window_height_gap))
        end
    end
end

local skyline = {}

--- create the skyline
--- @return table: a table containing buildings
local function create_skyline()
    local skyline = {}
    for i = 1, 15 do -- create 5 buildings
        table.insert(skyline, create_building())
    end
    -- sort the skyline by z-index (position.z)
    table.sort(skyline, function(a, b) return a.position.z > b.position.z end)
    return skyline
end

--- draw the skyline by drawing each building
-- taking into account the z-index
--- @param skyline: table containing buildings
local function draw_skyline(skyline)
    for _, building in ipairs(skyline) do
        draw_building(building)
    end
end

function love.load()
    cw, ch = love.graphics.getDimensions()
    canvas = love.graphics.newCanvas(cw, ch)

    skyline = create_skyline()
end

function love.update(dt)
end

function love.draw()
    -- -- Set the canvas to draw on
    -- love.graphics.setCanvas(canvas)
    -- love.graphics.clear(0.1, 0.1, 0.2) -- dark background
    draw_skyline(skyline)

    -- Draw skyline text
    love.graphics.setColor(255, 255, 255, 255) -- white text
    love.graphics.setFont(love.graphics.newFont(9))
    love.graphics.print("City Skyline Animation", 10, 10)
    love.graphics.print("Press ESC to exit", 10, 40)
    love.graphics.print("skyline: " .. #skyline, 10, 70)

    -- -- Set back to the default canvas
    -- love.graphics.setCanvas()
    -- love.graphics.draw(canvas)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" then
        skyline = create_skyline()
    end
end
