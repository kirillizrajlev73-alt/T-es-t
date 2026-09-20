
-- Matcha Atmosphere GUI Testжыжыжыж
-- CrystalHub

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем предыдущее тестовое GUI
local old = playerGui:FindFirstChild("MatchaTestGUI")
if old then old:Destroy() end

-- Сохраняем исходное освещение
local original = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

local enabled = false
local density = 0.4
local haze = 2
local glare = 1
local tint = Color3.fromRGB(173, 216, 230)

local function get(name)
    return Lighting:FindFirstChild(name)
end

local function removeEffects()
    for _, name in ipairs({
        "NebulaAtmosphere",
        "NebulaBloom",
        "NebulaColorCorrection"
    }) do
        local obj = get(name)
        if obj then obj:Destroy() end
    end
end

local function apply()
    removeEffects()

    if not enabled then
        Lighting.Ambient = original.Ambient
        Lighting.OutdoorAmbient = original.OutdoorAmbient
        Lighting.FogStart = original.FogStart
        Lighting.FogEnd = original.FogEnd
        Lighting.FogColor = original.FogColor
        return
    end

    local a = Instance.new("Atmosphere")
    a.Name = "NebulaAtmosphere"
    a.Density = density
    a.Haze = haze
    a.Glare = glare
    a.Color = tint
    a.Decay = tint
    a.Offset = 0.25
    a.Parent = Lighting

    local b = Instance.new("BloomEffect")
    b.Name = "NebulaBloom"
    b.Intensity = 0.7
    b.Size = 24
    b.Threshold = 1
    b.Parent = Lighting

    local c = Instance.new("ColorCorrectionEffect")
    c.Name = "NebulaColorCorrection"
    c.Saturation = 0.5
    c.Contrast = 0.2
    c.TintColor = tint
    c.Parent = Lighting

    Lighting.Ambient = tint
    Lighting.OutdoorAmbient = tint
    Lighting.FogStart = 100
    Lighting.FogEnd = 500
    Lighting.FogColor = tint
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MatchaTestGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 300)
frame.Position = UDim2.new(0.5, -140, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Matcha Atmosphere"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function button(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 38)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    b.MouseButton1Click:Connect(callback)
    return b
end

local status = button("Enable Matcha: OFF", 45, function()
    enabled = not enabled
    status.Text = "Enable Matcha: " .. (enabled and "ON" or "OFF")
    apply()
end)

button("Density +", 90, function()
    density = math.clamp(density + 0.05, 0, 1)
    if enabled then apply() end
end)

button("Density -", 135, function()
    density = math.clamp(density - 0.05, 0, 1)
    if enabled then apply() end
end)

button("Haze +", 180, function()
    haze = math.clamp(haze + 0.25, 0, 10)
    if enabled then apply() end
end)

button("Haze -", 225, function()
    haze = math.clamp(haze - 0.25, 0, 10)
    if enabled then apply() end
end)

button("Reset / Disable", 270, function()
    enabled = false
    density = 0.4
    haze = 2
    glare = 1
    status.Text = "Enable Matcha: OFF"
    apply()
end)
