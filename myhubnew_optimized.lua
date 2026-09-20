--// Hybrid Atmosphere GUI yesyeysyeyeys
--// Standalone LocalScript

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Remove old GUI
local OldGui = PlayerGui:FindFirstChild("HybridAtmosphereGUI")
if OldGui then
    OldGui:Destroy()
end

--// Settings
local Settings = {
    Enabled = true,
    Density = 0.25,
    Haze = 1.2,
    Glare = 0.15,
    Offset = 0.1,
    Brightness = 2,
    Color = Color3.fromRGB(199, 210, 255),
    Decay = Color3.fromRGB(120, 140, 180)
}

--// Atmosphere
local Atmosphere = Lighting:FindFirstChild("HybridAtmosphere")

if not Atmosphere then
    Atmosphere = Instance.new("Atmosphere")
    Atmosphere.Name = "HybridAtmosphere"
    Atmosphere.Parent = Lighting
end

local function Apply()
    Atmosphere.Enabled = Settings.Enabled
    Atmosphere.Density = Settings.Density
    Atmosphere.Haze = Settings.Haze
    Atmosphere.Glare = Settings.Glare
    Atmosphere.Offset = Settings.Offset
    Atmosphere.Color = Settings.Color
    Atmosphere.Decay = Settings.Decay
    Lighting.Brightness = Settings.Brightness
end

Apply()

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "HybridAtmosphereGUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(330, 410)
Main.Position = UDim2.new(0.5, -165, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(55, 55, 65)
Stroke.Thickness = 1
Stroke.Parent = Main

--// Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.fromOffset(15, 8)
Title.BackgroundTransparency = 1
Title.Text = "Hybrid Atmosphere"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 20)
Subtitle.Position = UDim2.fromOffset(15, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Lighting & Environment"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 150)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

--// Scroll
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -115)
Scroll.Position = UDim2.fromOffset(10, 65)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.CanvasSize = UDim2.new()
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Scroll

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 5)
Padding.PaddingRight = UDim.new(0, 5)
Padding.Bottom = UDim.new(0, 10)
Padding.Parent = Scroll

--// Helper
local function CreateLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(215, 215, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Scroll
    return Label
end

local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    Button.Text = text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 12
    Button.AutoButtonColor = true
    Button.Parent = Scroll

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Button

    Button.MouseButton1Click:Connect(callback)
    return Button
end

local function CreateSlider(name, minimum, maximum, default, callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 48)
    Holder.BackgroundTransparency = 1
    Holder.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -65, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Holder

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.fromOffset(60, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.fromOffset(0, 30)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.fromScale(
        (default - minimum) / (maximum - minimum), 1
    )
    Fill.BackgroundColor3 = Color3.fromRGB(145, 110, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.fromOffset(16, 16)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(
        (default - minimum) / (maximum - minimum), 0, 0.5, 0
    )
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.Text = ""
    Knob.AutoButtonColor = false
    Knob.Parent = Bar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local Value = default
    local Dragging = false

    local function SetValue(v)
        Value = math.clamp(v, minimum, maximum)
        Value = math.round(Value * 100) / 100

        local Percent = (Value - minimum) / (maximum - minimum)

        Fill.Size = UDim2.fromScale(Percent, 1)
        Knob.Position = UDim2.new(Percent, 0, 0.5, 0)
        ValueLabel.Text = string.format("%.2f", Value)

        callback(Value)
    end

    local function UpdateFromX(x)
        local Percent = math.clamp(
            (x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0, 1
        )
        SetValue(minimum + (maximum - minimum) * Percent)
    end

    Knob.MouseButton1Down:Connect(function()
        Dragging = true
    end)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            UpdateFromX(input.Position.X)
            Dragging = true
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if Dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            UpdateFromX(input.Position.X)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    SetValue(default)
    return Holder
end

--// Toggle
local Toggle = CreateButton("Atmosphere: ON", function()
    Settings.Enabled = not Settings.Enabled
    Atmosphere.Enabled = Settings.Enabled
    Toggle.Text = "Atmosphere: " .. (Settings.Enabled and "ON" or "OFF")
end)

--// Sliders
CreateSlider("Density", 0, 1, Settings.Density, function(v)
    Settings.Density = v
    Atmosphere.Density = v
end)

CreateSlider("Haze", 0, 10, Settings.Haze, function(v)
    Settings.Haze = v
    Atmosphere.Haze = v
end)

CreateSlider("Glare", 0, 10, Settings.Glare, function(v)
    Settings.Glare = v
    Atmosphere.Glare = v
end)

CreateSlider("Offset", -1, 1, Settings.Offset, function(v)
    Settings.Offset = v
    Atmosphere.Offset = v
end)

CreateSlider("Brightness", 0, 10, Settings.Brightness, function(v)
    Settings.Brightness = v
    Lighting.Brightness = v
end)

CreateLabel("Presets")

CreateButton("Soft Atmosphere", function()
    Settings.Density = 0.15
    Settings.Haze = 0.8
    Settings.Glare = 0.1
    Settings.Offset = 0

    Settings.Color = Color3.fromRGB(199, 210, 255)
    Settings.Decay = Color3.fromRGB(120, 140, 180)

    Apply()
end)

CreateButton("Dark Atmosphere", function()
    Settings.Density = 0.4
    Settings.Haze = 2
    Settings.Glare = 0.05
    Settings.Offset = 0

    Settings.Color = Color3.fromRGB(100, 110, 150)
    Settings.Decay = Color3.fromRGB(50, 60, 90)

    Apply()
end)

CreateButton("Reset Atmosphere", function()
    Settings.Enabled = true
    Settings.Density = 0.25
    Settings.Haze = 1.2
    Settings.Glare = 0.15
    Settings.Offset = 0.1
    Settings.Brightness = 2

    Settings.Color = Color3.fromRGB(199, 210, 255)
    Settings.Decay = Color3.fromRGB(120, 140, 180)

    Apply()
    Toggle.Text = "Atmosphere: ON"
end)

--// Drag window
local UIS = game:GetService("UserInputService")
local Dragging = false
local DragStart
local StartPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local Delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

print("Hybrid Atmosphere GUI loaded!")
