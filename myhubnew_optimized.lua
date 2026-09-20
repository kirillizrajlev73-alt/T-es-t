
-- CrystalHub Atmosphere Test
-- Juju + Matcha + Face Card style
-- Separate visual test

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup previous test
local oldGui = playerGui:FindFirstChild("AtmosphereTestGUI")
if oldGui then
    oldGui:Destroy()
end

local folderName = "CrystalAtmosphereTest"

local function removeEffects()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:GetAttribute("CrystalTest") then
            obj:Destroy()
        end
    end
end

local function createAtmosphere(name, settings)
    removeEffects()

    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = name
    atmosphere:SetAttribute("CrystalTest", true)

    for property, value in pairs(settings) do
        atmosphere[property] = value
    end

    atmosphere.Parent = Lighting
    return atmosphere
end

local function juju()
    return createAtmosphere("JujuAtmosphere", {
        Color = Color3.fromRGB(255, 255, 255),
        Decay = Color3.fromRGB(120, 120, 120),
        Density = 0.35,
        Haze = 1,
        Glare = 10,
        Offset = 0
    })
end

local function matcha()
    removeEffects()

    local atmosphere = createAtmosphere("MatchaAtmosphere", {
        Color = Color3.fromRGB(173, 216, 230),
        Decay = Color3.fromRGB(173, 216, 230),
        Density = 0.4,
        Haze = 2,
        Glare = 1,
        Offset = 0.25
    })

    local bloom = Instance.new("BloomEffect")
    bloom.Name = "MatchaBloom"
    bloom:SetAttribute("CrystalTest", true)
    bloom.Intensity = 0.7
    bloom.Size = 24
    bloom.Threshold = 1
    bloom.Parent = Lighting

    local correction = Instance.new("ColorCorrectionEffect")
    correction.Name = "MatchaColorCorrection"
    correction:SetAttribute("CrystalTest", true)
    correction.Saturation = 0.5
    correction.Contrast = 0.2
    correction.TintColor = Color3.fromRGB(173, 216, 230)
    correction.Parent = Lighting

    return atmosphere
end

local function faceCard()
    return createAtmosphere("FaceCardAtmosphere", {
        Color = Color3.fromRGB(255, 255, 255),
        Decay = Color3.fromRGB(120, 120, 120),
        Density = 0.35,
        Haze = 1,
        Glare = 10,
        Offset = 0
    })
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AtmosphereTestGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 230)
frame.Position = UDim2.new(0.5, -115, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Atmosphere Test"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.fromOffset(10, y)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

createButton("Juju Atmosphere", 45, juju)
createButton("Matcha / Nebula", 90, matcha)
createButton("Face Card", 135, faceCard)

createButton("Disable All", 180, function()
    removeEffects()
end)
