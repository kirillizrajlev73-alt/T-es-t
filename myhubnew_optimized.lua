--// Hybrid Atmosphere + GUI
--// Injectable (executor) / LocalScript compatible

--// Защита от повторного запуска
if _G.HybridAtmosphereLoaded then
    local old = _G.HybridAtmosphereGui
    if old and old.Parent then old:Destroy() end
end
_G.HybridAtmosphereLoaded = true

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--// ============ SETTINGS ============
local Settings = {
    Enabled = true,

    Density = 0.25,
    Haze = 1.2,
    Glare = 0.15,
    Offset = 0.1,

    Color = Color3.fromRGB(199, 210, 255),
    Decay = Color3.fromRGB(120, 140, 180),

    AmbientEnabled = true,
    Ambient = Color3.fromRGB(120, 120, 140),
    OutdoorAmbient = Color3.fromRGB(100, 110, 140),

    BrightnessEnabled = true,
    Brightness = 2,

    FogEnabled = false,
    FogColor = Color3.fromRGB(180, 190, 220),
    FogStart = 0,
    FogEnd = 1000
}

local AtmosphereName = "HybridAtmosphere"

--// ============ CORE ============
local function GetAtmosphere()
    local atmosphere = Lighting:FindFirstChild(AtmosphereName)
    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = AtmosphereName
        atmosphere.Parent = Lighting
    end
    return atmosphere
end

local function ApplyAtmosphere()
    local atmosphere = GetAtmosphere()

    atmosphere.Enabled = Settings.Enabled
    atmosphere.Density = Settings.Density
    atmosphere.Haze = Settings.Haze
    atmosphere.Glare = Settings.Glare
    atmosphere.Offset = Settings.Offset
    atmosphere.Color = Settings.Color
    atmosphere.Decay = Settings.Decay

    if Settings.AmbientEnabled then
        Lighting.Ambient = Settings.Ambient
        Lighting.OutdoorAmbient = Settings.OutdoorAmbient
    end

    if Settings.BrightnessEnabled then
        Lighting.Brightness = Settings.Brightness
    end

    Lighting.FogColor = Settings.FogColor

    if Settings.FogEnabled then
        Lighting.FogStart = Settings.FogStart
        Lighting.FogEnd = Settings.FogEnd
    else
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    end
end

local function SetAtmosphereEnabled(state)
    Settings.Enabled = state
    GetAtmosphere().Enabled = state
end

local function UpdateAtmosphere(property, value)
    if Settings[property] == nil then
        warn("Unknown Atmosphere setting: " .. tostring(property))
        return
    end
    Settings[property] = value
    ApplyAtmosphere()
end

ApplyAtmosphere()

--// ============ GUI ============
--// Определяем родителя (executor или обычный LocalScript)
local function GetGuiParent()
    if gethui then
        return gethui()
    elseif LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    else
        return game:GetService("CoreGui")
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HybridAtmosphereGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GetGuiParent()

_G.HybridAtmosphereGui = ScreenGui

--// ============ ПАЛИТРА ============
local COLORS = {
    Bg = Color3.fromRGB(20, 22, 30),
    Bg2 = Color3.fromRGB(30, 33, 45),
    Accent = Color3.fromRGB(120, 160, 255),
    Text = Color3.fromRGB(230, 235, 245),
    Sub = Color3.fromRGB(150, 160, 180),
    Slider = Color3.fromRGB(60, 70, 100),
}

--// ============ MAIN FRAME ============
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 460)
Main.Position = UDim2.new(0, 30, 0, 100)
Main.BackgroundColor3 = COLORS.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = COLORS.Accent
UIStroke.Transparency = 0.6
UIStroke.Thickness = 1
UIStroke.Parent = Main

--// ============ TITLE BAR ============
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = COLORS.Bg2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

--// Hide bottom corners of title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = COLORS.Bg2
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hybrid Atmosphere"
Title.TextColor3 = COLORS.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

--// Toggle button (enable/disable atmosphere)
local EnableBtn = Instance.new("TextButton")
EnableBtn.Size = UDim2.new(0, 60, 0, 24)
EnableBtn.Position = UDim2.new(1, -70, 0, 8)
EnableBtn.BackgroundColor3 = COLORS.Accent
EnableBtn.Text = "ON"
EnableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableBtn.TextSize = 12
EnableBtn.Font = Enum.Font.GothamBold
EnableBtn.BorderSizePixel = 0
EnableBtn.Parent = TitleBar

local EnableBtnCorner = Instance.new("UICorner")
EnableBtnCorner.CornerRadius = UDim.new(0, 6)
EnableBtnCorner.Parent = EnableBtn

EnableBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    SetAtmosphereEnabled(Settings.Enabled)
    EnableBtn.Text = Settings.Enabled and "ON" or "OFF"
    EnableBtn.BackgroundColor3 = Settings.Enabled and COLORS.Accent or Color3.fromRGB(80, 80, 90)
end)

--// Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -100, 0, 8)
MinBtn.BackgroundColor3 = COLORS.Slider
MinBtn.Text = "—"
MinBtn.TextColor3 = COLORS.Text
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

--// ============ SCROLL ============
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = COLORS.Accent
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 4)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.Parent = Scroll

--// ============ SECTION HELPER ============
local function CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -8, 0, 24)
    Section.BackgroundTransparency = 1
    Section.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Accent
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Section

    return Section
end

--// ============ SLIDER ============
local function CreateSlider(labelText, min, max, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -8, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 16)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 55, 0, 16)
    ValueLabel.Position = UDim2.new(1, -55, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = COLORS.Sub
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Container

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, 0, 0, 6)
    BarBg.Position = UDim2.new(0, 0, 0, 26)
    BarBg.BackgroundColor3 = COLORS.Slider
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Container

    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(1, 0)
    BarBgCorner.Parent = BarBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = COLORS.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 2
    Knob.Parent = BarBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local dragging = false

    local function UpdateFromX(x)
        local rel = math.clamp((x - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * rel
        value = math.floor(value * 100 + 0.5) / 100
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        Knob.Position = UDim2.new(rel, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return Container
end

--// ============ TOGGLE ============
local function CreateToggle(labelText, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -8, 0, 28)
    Container.BackgroundTransparency = 1
    Container.Parent = Scroll

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 44, 0, 22)
    Btn.Position = UDim2.new(1, -44, 0.5, -11)
    Btn.BackgroundColor3 = default and COLORS.Accent or Color3.fromRGB(60, 65, 80)
    Btn.Text = default and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Btn.Parent = Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and COLORS.Accent or Color3.fromRGB(60, 65, 80)
        callback(state)
    end)

    return Container
end

--// ============ BUILD UI ============
CreateSection("ATMOSPHERE")

CreateSlider("Density", 0, 1, Settings.Density, function(v)
    Settings.Density = v
    ApplyAtmosphere()
end)

CreateSlider("Haze", 0, 10, Settings.Haze, function(v)
    Settings.Haze = v
    ApplyAtmosphere()
end)

CreateSlider("Glare", 0, 1, Settings.Glare, function(v)
    Settings.Glare = v
    ApplyAtmosphere()
end)

CreateSlider("Offset", -1, 1, Settings.Offset, function(v)
    Settings.Offset = v
    ApplyAtmosphere()
end)

CreateSection("LIGHTING")

CreateToggle("Ambient", Settings.AmbientEnabled, function(state)
    Settings.AmbientEnabled = state
    ApplyAtmosphere()
end)

CreateSlider("Brightness", 0, 10, Settings.Brightness, function(v)
    Settings.Brightness = v
    ApplyAtmosphere()
end)

CreateSection("FOG")

CreateToggle("Fog Enabled", Settings.FogEnabled, function(state)
    Settings.FogEnabled = state
    ApplyAtmosphere()
end)

CreateSlider("Fog End", 0, 5000, Settings.FogEnd, function(v)
    Settings.FogEnd = v
    if Settings.FogEnabled then ApplyAtmosphere() end
end)

--// ============ MINIMIZE ============
local minimized = false
local originalSize = Main.Size

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Scroll.Visible = false
        Main.Size = UDim2.new(0, 320, 0, 40)
        MinBtn.Text = "+"
    else
        Scroll.Visible = true
        Main.Size = originalSize
        MinBtn.Text = "—"
    end
end)

--// ============ HOTKEY (RightShift — toggle GUI) ============
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

--// ============ EXPORTS ============
--// Доступно извне (в т.ч. через executor)
_G.HybridAtmosphere = {
    Settings = Settings,
    Apply = ApplyAtmosphere,
    Enable = SetAtmosphereEnabled,
    Update = UpdateAtmosphere,
    Gui = ScreenGui,
    Frame = Main,
}
