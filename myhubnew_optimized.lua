local UserInputService, CurrentCamera, n1, n2, u13, n3, u15, u16, u17, v18, v25, u29, u31, u32, u61, u62, t3, t4, v68, v78, u120, n17, u126, u127, u128, v145, u147, u148, u149, u150, u151, u156, u172, u173, u174, u175, u176, u177, u178, v183, u184, u185, u186, u187, u188, u189, u198, u199, id, u201, u202, u205, u206, u207, u208, u209, u210, u211, u212, v232, v239, v244, u252, u257, u263, u270, u276, u281, u287, u293, v301, v302
-- Shared bullet-tracer state (accessible by both __namecall hook and Shoot button)
local _BT = nil
local _bullettracerlol = nil

do
    local u9, u10, u99, u105, u110, u116, u157
    local Players = game:GetService('Players')
    local Workspace, RunService, LocalPlayer, u129, u130, u131, u162, u163, u164, u165, u166, u167, u168, u169, t25, v220, uDim2, t26

    do
        local u98, u104, u222
        local v125, uDim2_2

        do
            local u218
            local v21, v115, t17

            do
                local Lighting, TextLabel

                do
                    local ReplicatedStorage = game:GetService('ReplicatedStorage')

                    Workspace = game:GetService('Workspace')
                    UserInputService = game:GetService('UserInputService')
                    RunService = game:GetService('RunService')
                    Lighting = game:GetService('Lighting')
                    LocalPlayer = Players.LocalPlayer
                    CurrentCamera = Workspace.CurrentCamera
                    u9 = false
                    u10 = false
                    n1 = 200
                    n2 = 200
                    u13 = false
                    n3 = 70
                    u15 = false
                    u16 = false
                    u17 = true
                    --[[
    CrystalHub UI adapter
    WindUI has been replaced by the supplied NeverLose UI.
    Existing feature code keeps its original control API through this adapter.
]]
local NeverLose = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/kirillizrajlev73-alt/Ul_onlypastamyneverlose/refs/heads/main/Ui.lua"
))()

-- Keep a shared reference available to the button/config section below.
getgenv().CrystalHubNeverLose = NeverLose

v18 = {}

function v18:SetTheme(_) end

function v18:Notify(cfg)
    local notifier = NeverLose:CreateNotification()
    if notifier and notifier.new then
        notifier.new({
            Title = cfg.Title or "CrystalHub",
            Content = cfg.Content or "",
            Duration = cfg.Duration or 3,
            Logo = NeverLose.GlobalLogo,
        })
    end
end

local function makeControlAdapter(section)
    local api = {}

    function api:Paragraph(cfg)
        cfg = cfg or {}
        local text = tostring(cfg.Title or "")
        if cfg.Content and cfg.Content ~= "" then
            text = text .. "\\n" .. tostring(cfg.Content)
        end
        return section:AddLabel(text, true)
    end

    function api:Toggle(cfg)
        cfg = cfg or {}
        return section:AddLabel(tostring(cfg.Title or "Toggle")):AddToggle({
            Default = cfg.Default == true,
            Flag = cfg.Flag,
            Callback = cfg.Callback,
        })
    end

    function api:Button(cfg)
        cfg = cfg or {}
        -- NeverLose exposes AddButton directly on the section item,
        -- while AddLabel returns a handler (which has toggles/sliders/dropdowns).
        return section:AddButton({
            Name = tostring(cfg.Title or "Button"),
            Icon = cfg.Icon or "chevron-large-right",
            Callback = cfg.Callback,
            ToolTip = cfg.Description,
        })
    end

    function api:Dropdown(cfg)
        cfg = cfg or {}
        local item = section:AddLabel(tostring(cfg.Title or "Dropdown"))
        local control = item:AddDropdown({
            Default = cfg.Value,
            Values = cfg.Values or {},
            Multi = cfg.Multi == true,
            Flag = cfg.Flag,
            Callback = cfg.Callback,
        })

        function control:Refresh(values)
            self:SetValues(values or {})
        end

        function control:Select(value)
            self:SetValue(value)
        end

        return control
    end

    function api:Slider(cfg)
        cfg = cfg or {}
        local value = cfg.Value or {}
        return section:AddLabel(tostring(cfg.Title or "Slider")):AddSlider({
            Flag = "control_123",Min = value.Min or 0,
            Max = value.Max or 100,
            Default = value.Default or value.Min or 0,
            Rounding = cfg.Rounding or 0,
            Type = cfg.Suffix or "",
            Callback = cfg.Callback,
        })
    end

    function api:ColorPicker(cfg)
        cfg = cfg or {}
        return section:AddLabel(tostring(cfg.Title or "Color")):AddColorPicker({
            Default = cfg.Default or Color3.fromRGB(255,255,255),
            Flag = cfg.Flag,
            Callback = cfg.Callback,
        })
    end

    function api:Divider() end

    return api
end

function v18:CreateWindow(cfg)
    cfg = cfg or {}

    local window = NeverLose:CreateWindow({
        Logo = NeverLose.GlobalLogo,
        Name = cfg.Title or "CrystalHub",
        Content = cfg.Author or "Mmv And Mm2",
        Size = cfg.Size or UDim2.fromOffset(400, 300),
        ConfigFolder = cfg.Folder or "CrystalHub",
        Enable3DRenderer = false,
        Keybind = "Insert",
    })

    local adapter = {
        _window = window,
        _tabs = {},
    }

    function adapter:Section(_)
        return self
    end

    -- Section name map: tab title -> { left name, right name }
    local sectionNames = {
        ["Main"]           = { "COMBAT",       "PLAYER"        },
        ["Fling/Teleport"] = { "FLING",        "TELEPORT"      },
        ["Visuals"]        = { "VISUALS",       "COMBAT VISUAL" },
    }

    function adapter:Tab(cfg2)
        cfg2 = cfg2 or {}

        local tab = window:AddTab({
            Name = cfg2.Title or "Tab",
            Icon = cfg2.Icon or "grid",
        })

        local names = sectionNames[cfg2.Title]

        -- Tabs NOT in the map get a single left section (original behaviour)
        if not names then
            local section = tab:AddSection({
                Name     = (cfg2.Title or "MAIN"):upper(),
                Position = "left",
            })
            local controls = makeControlAdapter(section)
            controls._tab     = tab
            controls._section = section
            self._tabs[#self._tabs + 1] = controls
            return controls
        end

        -- Two-column layout for Main / Fling-Teleport / Rage
        local sectionLeft = tab:AddSection({
            Name     = names[1],
            Position = "left",
        })

        local sectionRight = tab:AddSection({
            Name     = names[2],
            Position = "right",
        })

        local leftControls  = makeControlAdapter(sectionLeft)
        local rightControls = makeControlAdapter(sectionRight)

        local columnControls = {
            _tab          = tab,
            _sectionLeft  = sectionLeft,
            _sectionRight = sectionRight,
            _left         = leftControls,
            _right        = rightControls,
            _counter      = 0,
        }

        local function nextCol(self2)
            self2._counter = self2._counter + 1
            return (self2._counter % 2 == 1) and self2._left or self2._right
        end

        function columnControls:Toggle(cfg3)      return nextCol(self):Toggle(cfg3)      end
        function columnControls:Button(cfg3)       return nextCol(self):Button(cfg3)       end
        function columnControls:Dropdown(cfg3)     return nextCol(self):Dropdown(cfg3)     end
        function columnControls:Slider(cfg3)       return nextCol(self):Slider(cfg3)       end
        function columnControls:ColorPicker(cfg3)  return nextCol(self):ColorPicker(cfg3)  end
        function columnControls:Paragraph(cfg3)    return nextCol(self):Paragraph(cfg3)    end

        function columnControls:Divider()
            leftControls:Divider()
            rightControls:Divider()
        end

        self._tabs[#self._tabs + 1] = columnControls
        return columnControls
    end

    function adapter:ToggleInterface()
        return window:ToggleInterface()
    end

    return adapter
end

do
    local _ = v18
end
                    do
                        local u20 = UserInputService

                        function v21(p1)
                            local u362 = nil
                            local p2Position = nil
                            local Position = nil
                            local InputBegan = p1.InputBegan
                            local u366 = p1

                            InputBegan:Connect(function(p2)
                                if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
                                    u362 = true
                                    p2Position = p2.Position
                                    Position = u366.Position
                                end
                            end)

                            local InputChanged = p1.InputChanged
                            local u368 = p1

                            InputChanged:Connect(function(p3)
                                if u362 then
                                    if p3.UserInputType == Enum.UserInputType.MouseMovement or p3.UserInputType == Enum.UserInputType.Touch then
                                        local v838 = p3.Position - p2Position

                                        u368.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v838.X, Position.Y.Scale, Position.Y.Offset + v838.Y)
                                    end

                                    return
                                end
                            end)
                            u20.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                    u362 = false
                                end
                            end)
                        end
                    end
                    do
                        local u22 = UserInputService
                        local u23 = v18
                        local u24 = v21

                        function v25(p4, p5, p6, p7, p8, p9, p10)
                            local v377 = 'RuzSlider_' .. p4:gsub('%s+', '_')
                            local v378 = game.CoreGui:FindFirstChild(v377)

                            if not v378 then
                                local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

                                ScreenGui.Name = v377
                                ScreenGui.ResetOnSpawn = false
                                ScreenGui.DisplayOrder = 55
                                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                                local Frame = Instance.new('Frame', ScreenGui)

                                Frame.Size = UDim2.new(0, 300, 0, 175)
                                Frame.Position = UDim2.new(0.5, -150, 0.35, 0)
                                Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                                Frame.BackgroundTransparency = 0.08
                                Frame.BorderSizePixel = 0
                                Instance.new('UICorner', Frame).CornerRadius = UDim.new(0, 10)

                                local UIStroke = Instance.new('UIStroke', Frame)

                                UIStroke.Color = Color3.fromRGB(220, 38, 38)
                                UIStroke.Thickness = 1.5
                                UIStroke.Transparency = 0.15

                                local TextLabel2 = Instance.new('TextLabel', Frame)

                                TextLabel2.Size = UDim2.new(1, -44, 0, 36)
                                TextLabel2.Position = UDim2.new(0, 12, 0, 0)
                                TextLabel2.BackgroundTransparency = 1
                                TextLabel2.Text = 'CrystalHub  \u{2014}  ' .. p4
                                TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                                TextLabel2.Font = Enum.Font.GothamBold
                                TextLabel2.TextSize = 14
                                TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

                                local TextButton = Instance.new('TextButton', Frame)

                                TextButton.Size = UDim2.new(0, 28, 0, 28)
                                TextButton.Position = UDim2.new(1, -34, 0, 4)
                                TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
                                TextButton.Text = 'X'
                                TextButton.TextColor3 = Color3.new(1, 1, 1)
                                TextButton.Font = Enum.Font.GothamBold
                                TextButton.TextSize = 13
                                Instance.new('UICorner', TextButton).CornerRadius = UDim.new(0, 6)

                                local MouseButton1Click = TextButton.MouseButton1Click
                                local u385 = ScreenGui

                                MouseButton1Click:Connect(function()
                                    u385:Destroy()
                                end)

                                local u386 = p7
                                local TextLabel3 = Instance.new('TextLabel', Frame)

                                TextLabel3.Size = UDim2.new(1, 0, 0, 22)
                                TextLabel3.Position = UDim2.new(0, 0, 0, 38)
                                TextLabel3.BackgroundTransparency = 1
                                TextLabel3.Text = p4 .. ':  ' .. tostring(p7)
                                TextLabel3.TextColor3 = Color3.fromRGB(210, 210, 210)
                                TextLabel3.Font = Enum.Font.Gotham
                                TextLabel3.TextSize = 13

                                local Frame2 = Instance.new('Frame', Frame)

                                Frame2.Size = UDim2.new(1, -30, 0, 10)
                                Frame2.Position = UDim2.new(0, 15, 0, 72)
                                Frame2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                                Frame2.BorderSizePixel = 0
                                Instance.new('UICorner', Frame2).CornerRadius = UDim.new(1, 0)

                                local v390 = (p7 - p5) / (p6 - p5)
                                local Frame3 = Instance.new('Frame', Frame2)

                                Frame3.Size = UDim2.new(v390, 0, 1, 0)
                                Frame3.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
                                Frame3.BorderSizePixel = 0
                                Instance.new('UICorner', Frame3).CornerRadius = UDim.new(1, 0)

                                local TextButton2 = Instance.new('TextButton', Frame2)

                                TextButton2.Size = UDim2.new(0, 26, 0, 26)
                                TextButton2.Position = UDim2.new(v390, -13, 0.5, -13)
                                TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                TextButton2.Text = ''
                                TextButton2.AutoButtonColor = false
                                TextButton2.BorderSizePixel = 0
                                Instance.new('UICorner', TextButton2).CornerRadius = UDim.new(1, 0)

                                local u393 = Frame2
                                local u394 = p5
                                local u395 = p6
                                local u396 = p8
                                local u397 = TextButton2
                                local u398 = p4

                                local function v399(p11)
                                    local v841 = (p11 - u393.AbsolutePosition.X) / u393.AbsoluteSize.X
                                    local v842 = math.clamp(v841, 0, 1)
                                    local v843 = u394 + v842 * (u395 - u394)

                                    u386 = math.round(v843)

                                    if u396 and u396 > 0 then
                                        local v844 = u386 / u396

                                        u386 = math.round(v844) * u396
                                    end

                                    local v845 = (u386 - u394) / (u395 - u394)

                                    Frame3.Size = UDim2.new(v845, 0, 1, 0)
                                    u397.Position = UDim2.new(v845, -13, 0.5, -13)
                                    TextLabel3.Text = u398 .. ':  ' .. tostring(u386)
                                end

                                local u400 = false

                                TextButton2.InputBegan:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                        u400 = true
                                    end
                                end)

                                local InputBegan = Frame2.InputBegan
                                local u402 = v399

                                InputBegan:Connect(function(p12)
                                    if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
                                        u400 = true

                                        u402(p12.Position.X)
                                    end
                                end)

                                local InputChanged = u22.InputChanged
                                local u404 = v399

                                InputChanged:Connect(function(p13)
                                    if u400 then
                                        if p13.UserInputType == Enum.UserInputType.MouseMovement or p13.UserInputType == Enum.UserInputType.Touch then
                                            u404(p13.Position.X)
                                        end

                                        return
                                    end
                                end)
                                u22.InputEnded:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                        u400 = false
                                    end
                                end)

                                local Frame4 = Instance.new('Frame', Frame)

                                Frame4.Size = UDim2.new(1, -20, 0, 36)
                                Frame4.Position = UDim2.new(0, 10, 0, 126)
                                Frame4.BackgroundTransparency = 1

                                local TextButton3 = Instance.new('TextButton', Frame4)

                                TextButton3.Size = UDim2.new(0.48, 0, 1, 0)
                                TextButton3.BackgroundColor3 = Color3.fromRGB(20, 160, 20)
                                TextButton3.Text = 'Apply'
                                TextButton3.TextColor3 = Color3.new(1, 1, 1)
                                TextButton3.Font = Enum.Font.GothamBold
                                TextButton3.TextSize = 13
                                Instance.new('UICorner', TextButton3).CornerRadius = UDim.new(0, 6)

                                local MouseButton1Click2 = TextButton3.MouseButton1Click
                                local u408 = p9
                                local u409 = p4

                                MouseButton1Click2:Connect(function()
                                    u408(u386)

                                    local v853 = u409 .. ' set to ' .. u386

                                    u23:Notify({
                                        Title = 'CrystalHub',
                                        Content = tostring(v853),
                                        Duration = 3,
                                        Icon = 'bell',
                                    })
                                end)

                                local TextButton4 = Instance.new('TextButton', Frame4)

                                TextButton4.Size = UDim2.new(0.48, 0, 1, 0)
                                TextButton4.Position = UDim2.new(0.52, 0, 0, 0)
                                TextButton4.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
                                TextButton4.Text = 'Reset'
                                TextButton4.TextColor3 = Color3.new(1, 1, 1)
                                TextButton4.Font = Enum.Font.GothamBold
                                TextButton4.TextSize = 13
                                Instance.new('UICorner', TextButton4).CornerRadius = UDim.new(0, 6)

                                local MouseButton1Click3 = TextButton4.MouseButton1Click
                                local u412 = ScreenGui

                                MouseButton1Click3:Connect(function()
                                    p10()
                                    u412:Destroy()
                                end)
                                u24(Frame)

                                return
                            end

                            v378:Destroy()
                        end
                    end
                    do
                        local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

                        ScreenGui.Name = 'RuzLGStar'
                        ScreenGui.ResetOnSpawn = false
                        ScreenGui.DisplayOrder = 40
                        TextLabel = Instance.new('TextLabel', ScreenGui)
                    end

                    TextLabel.Size = UDim2.new(0, 28, 0, 28)
                    TextLabel.Position = UDim2.new(1, -34, 0, 4)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.Text = '\u{2605}'
                    TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 22
                    TextLabel.Visible = false

                    do
                        local t2, n4, u82
                        local Part = Instance.new('Part')

                        Part.Name = 'RuzPredictionPart'
                        Part.Size = Vector3.new(0.5, 0.5, 0.5)
                        Part.Anchored = true
                        Part.CanCollide = false
                        Part.Transparency = 1
                        Part.Parent = Workspace
                        u29 = nil

                        do
                            local v35

                            do
                                local u30 = Workspace

                                u31 = nil
                                u32 = nil

                                local color3 = Color3.fromRGB(255, 215, 0)

                                local function u34(p14)
                                    if u29 then
                                        u29:Destroy()

                                        u29 = nil
                                    end

                                    local Part2 = Instance.new('Part')

                                    Part2.Name = 'RuzGunMarker'
                                    Part2.Size = Vector3.new(1.5, 0.15, 1.5)
                                    Part2.Anchored = true
                                    Part2.CanCollide = false
                                    Part2.CastShadow = false
                                    Part2.Material = Enum.Material.Neon
                                    Part2.Color = Color3.fromRGB(50, 255, 80)
                                    Part2.Transparency = 0.25
                                    Part2.CFrame = CFrame.new(p14)
                                    Part2.Parent = u30

                                    local spawn = task.spawn
                                    local u416 = Part2

                                    spawn(function()
                                        local _t = 0
                                        while u416 and u416.Parent do
                                            _t = _t + 0.05
                                            if _t > 1 then _t = 0 end
                                            u416.Transparency = 0.25 + 0.5 * math.sin(_t * math.pi)
                                            task.wait(0.03)
                                        end
                                    end)

                                    u29 = Part2
                                end

                                function v35(p15)
                                    if u17 then
                                        if u31 then
                                            u31:Destroy()

                                            u31 = nil
                                        end
                                        if u32 then
                                            u32:Destroy()

                                            u32 = nil
                                        end

                                        local Highlight = Instance.new('Highlight')

                                        Highlight.Adornee = p15
                                        Highlight.FillColor = color3
                                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                        Highlight.FillTransparency = 0.35
                                        Highlight.OutlineTransparency = 0
                                        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                        Highlight.Parent = p15
                                        u31 = Highlight

                                        local v419 = p15:FindFirstChild('Handle') or (p15:IsA('Model') and p15.PrimaryPart or p15:FindFirstChildWhichIsA('BasePart')) or p15:IsA('BasePart') and p15

                                        if not v419 then
                                            if p15:IsA('Model') then
                                                u34(p15:GetModelCFrame().Position + Vector3.new(0, 0.1, 0))
                                            end

                                            return
                                        end

                                        u34(v419.Position + Vector3.new(0, 0.1, 0))

                                        local BillboardGui = Instance.new('BillboardGui')

                                        BillboardGui.Adornee = v419
                                        BillboardGui.Size = UDim2.new(0, 130, 0, 36)
                                        BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
                                        BillboardGui.AlwaysOnTop = true
                                        BillboardGui.MaxDistance = 300
                                        BillboardGui.Parent = v419

                                        local Frame = Instance.new('Frame', BillboardGui)

                                        Frame.Size = UDim2.new(1, 0, 1, 0)
                                        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                        Frame.BackgroundTransparency = 0.4
                                        Frame.BorderSizePixel = 0
                                        Instance.new('UICorner', Frame).CornerRadius = UDim.new(0, 6)

                                        local UIStroke = Instance.new('UIStroke', Frame)

                                        UIStroke.Color = color3
                                        UIStroke.Thickness = 1.5
                                        UIStroke.Transparency = 0.1

                                        local TextLabel4 = Instance.new('TextLabel', Frame)

                                        TextLabel4.Size = UDim2.new(1, 0, 1, 0)
                                        TextLabel4.BackgroundTransparency = 1
                                        TextLabel4.Text = 'GUN ON MAP'
                                        TextLabel4.TextColor3 = color3
                                        TextLabel4.Font = Enum.Font.GothamBlack
                                        TextLabel4.TextSize = 13
                                        TextLabel4.TextStrokeTransparency = 0.4
                                        TextLabel4.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                        u32 = BillboardGui

                                        return
                                    end
                                end
                            end
                            do
                                local _ = Workspace
                                local _ = v35
                                local _ = v18
                            end
                            do
                                local u42

                                do
                                    local t1 = {}
                                    local u40 = v35
                                    local u41 = v18

                                    function u42(p16)
                                        if not t1[p16] then
                                            t1[p16] = true

                                            p16.ChildAdded:Connect(function(child)
                                                if child.Name == 'GunDrop' then
                                                    task.wait(0.1)

                                                    if u17 then
                                                        u40(child)
                                                    end

                                                    u41:Notify({
                                                        Title = 'CrystalHub',
                                                        Content = tostring('Gun dropped on the map!'),
                                                        Duration = 3,
                                                        Icon = 'bell',
                                                    })
                                                end
                                                if child:IsA('Model') or child:IsA('Folder') then
                                                    u42(child)
                                                end
                                            end)
                                            p16.ChildRemoved:Connect(function(child)
                                                if child.Name == 'GunDrop' then
                                                    if u31 then
                                                        u31:Destroy()

                                                        u31 = nil
                                                    end
                                                    if u32 then
                                                        u32:Destroy()

                                                        u32 = nil
                                                    end
                                                    if u29 then
                                                        u29:Destroy()

                                                        u29 = nil
                                                    end
                                                end
                                            end)

                                            for _, child in ipairs(p16:GetChildren())do
                                                if child:IsA('Model') or child:IsA('Folder') then
                                                    u42(child)
                                                end
                                            end

                                            return
                                        end
                                    end
                                end

                                u42(Workspace)

                                local ChildAdded = Workspace.ChildAdded
                                local u44 = u42
                                local u45 = v35
                                local u46 = v18

                                ChildAdded:Connect(function(p17)
                                    if p17:IsA('Model') or p17:IsA('Folder') then
                                        u44(p17)
                                    end
                                    if p17.Name == 'GunDrop' then
                                        task.wait(0.1)

                                        if u17 then
                                            u45(p17)
                                        end

                                        u46:Notify({
                                            Title = 'CrystalHub',
                                            Content = tostring('Gun dropped on the map!'),
                                            Duration = 3,
                                            Icon = 'bell',
                                        })
                                    end
                                end)
                            end
                            do
                                local spawn = task.spawn
                                local u48 = Workspace
                                local u49 = v35
                                local u50 = v18

                                spawn(function()
                                    task.wait(1.5)

                                    local GunDrop = u48:FindFirstChild('GunDrop', true)

                                    if GunDrop then
                                        if u17 then
                                            u49(GunDrop)
                                        end

                                        u50:Notify({
                                            Title = 'CrystalHub',
                                            Content = tostring('Gun dropped on the map!'),
                                            Duration = 3,
                                            Icon = 'bell',
                                        })
                                    end
                                end)
                            end
                            do
                                local u51 = Workspace
                                local u52 = v35
                                local u53 = v18

                                for _, player in ipairs(Players:GetPlayers())do
                                    if player ~= LocalPlayer then
                                        task.spawn(function(p18)
                                            local u431 = p18

                                            if p18.Character then
                                                local Character = p18.Character

                                                if Character then
                                                    local Humanoid = Character:WaitForChild('Humanoid', 5)

                                                    if Humanoid then
                                                        local Died = Humanoid.Died
                                                        local u435 = p18
                                                        local u436 = Character

                                                        Died:Connect(function()
                                                            if u435.Backpack:FindFirstChild('Gun') or u436:FindFirstChild('Gun') then
                                                                task.delay(0.8, function()
                                                                    local GunDrop = u51:FindFirstChild('GunDrop', true)

                                                                    if GunDrop then
                                                                        if u17 then
                                                                            u52(GunDrop)
                                                                        end

                                                                        u53:Notify({
                                                                            Title = 'CrystalHub',
                                                                            Content = tostring('Gun dropped on the map!'),
                                                                            Duration = 3,
                                                                            Icon = 'bell',
                                                                        })
                                                                    end
                                                                end)
                                                            end
                                                        end)
                                                    end
                                                end
                                            end

                                            p18.CharacterAdded:Connect(function(character)
                                                if character then
                                                    local Humanoid = character:WaitForChild('Humanoid', 5)

                                                    if Humanoid then
                                                        local Died = Humanoid.Died
                                                        local u862 = character

                                                        Died:Connect(function()
                                                            if u431.Backpack:FindFirstChild('Gun') or u862:FindFirstChild('Gun') then
                                                                task.delay(0.8, function()
                                                                    local GunDrop = u51:FindFirstChild('GunDrop', true)

                                                                    if GunDrop then
                                                                        if u17 then
                                                                            u52(GunDrop)
                                                                        end

                                                                        u53:Notify({
                                                                            Title = 'CrystalHub',
                                                                            Content = tostring('Gun dropped on the map!'),
                                                                            Duration = 3,
                                                                            Icon = 'bell',
                                                                        })
                                                                    end
                                                                end)
                                                            end
                                                        end)

                                                        return
                                                    end

                                                    return
                                                end
                                            end)
                                        end, player)
                                    end
                                end
                            end

                            local PlayerAdded = Players.PlayerAdded
                            local u57 = LocalPlayer
                            local u58 = Workspace
                            local u59 = v35
                            local u60 = v18

                            PlayerAdded:Connect(function(p19)
                                if p19 ~= u57 then
                                    local u438 = p19

                                    if p19.Character then
                                        local Character = p19.Character

                                        if Character then
                                            local Humanoid = Character:WaitForChild('Humanoid', 5)

                                            if Humanoid then
                                                local Died = Humanoid.Died
                                                local u442 = p19
                                                local u443 = Character

                                                Died:Connect(function()
                                                    if u442.Backpack:FindFirstChild('Gun') or u443:FindFirstChild('Gun') then
                                                        task.delay(0.8, function()
                                                            local GunDrop = u58:FindFirstChild('GunDrop', true)

                                                            if GunDrop then
                                                                if u17 then
                                                                    u59(GunDrop)
                                                                end

                                                                u60:Notify({
                                                                    Title = 'CrystalHub',
                                                                    Content = tostring('Gun dropped on the map!'),
                                                                    Duration = 3,
                                                                    Icon = 'bell',
                                                                })
                                                            end
                                                        end)
                                                    end
                                                end)
                                            end
                                        end
                                    end

                                    p19.CharacterAdded:Connect(function(character)
                                        if character then
                                            local Humanoid = character:WaitForChild('Humanoid', 5)

                                            if Humanoid then
                                                local Died = Humanoid.Died
                                                local u866 = character

                                                Died:Connect(function()
                                                    if u438.Backpack:FindFirstChild('Gun') or u866:FindFirstChild('Gun') then
                                                        task.delay(0.8, function()
                                                            local GunDrop = u58:FindFirstChild('GunDrop', true)

                                                            if GunDrop then
                                                                if u17 then
                                                                    u59(GunDrop)
                                                                end

                                                                u60:Notify({
                                                                    Title = 'CrystalHub',
                                                                    Content = tostring('Gun dropped on the map!'),
                                                                    Duration = 3,
                                                                    Icon = 'bell',
                                                                })
                                                            end
                                                        end)
                                                    end
                                                end)

                                                return
                                            end

                                            return
                                        end
                                    end)
                                end
                            end)

                            u61 = false
                            u62 = nil
                            t2 = {}
                            n4 = 0
                            t3 = {
                                Murderer = true,
                                Sheriff = true,
                                Hero = true,
                                Innocent = true,
                                Self = true,
                            }
                            t4 = {
                                Murderer = Color3.fromRGB(255, 40, 40),
                                Sheriff = Color3.fromRGB(40, 130, 255),
                                Hero = Color3.fromRGB(255, 215, 0),
                                Innocent = Color3.fromRGB(0, 220, 0),
                            }

                            local u67 = Players

                            function v68()
                                for _, player in ipairs(u67:GetPlayers())do
                                    if player.Character then
                                        local CrystalHub_ESP = player.Character:FindFirstChild('CrystalHub_ESP')

                                        if CrystalHub_ESP then
                                            CrystalHub_ESP:Destroy()
                                        end
                                    end
                                end

                                t2 = {}
                                n4 = 0
                            end
                        end
                        do
                            local u69 = ReplicatedStorage
                            local u70 = v18
                            local u71 = RunService
                            local u72 = Players

                            local function u73(p20)
                                local s1 = 'Innocent'
                                local v446 = t2[p20.Name]

                                if v446 then
                                    local v447 = v446.Role or (v446.role or (v446.Team or ''))
                                    local v448 = tostring(v447):lower()

                                    if v448:find('murd') then
                                        return 'Murderer'
                                    end
                                    if v448:find('sheriff') or v448:find('gun') then
                                        return 'Sheriff'
                                    end
                                    if v448:find('hero') then
                                        s1 = 'Hero'
                                    end
                                end

                                return s1
                            end

                            local u74 = t3
                            local u75 = LocalPlayer

                            local function u76(p21, p22)
                                local v451 = p21:FindFirstChild('CrystalHub_ESP') or Instance.new('Highlight')

                                v451.Name = 'CrystalHub_ESP'
                                v451.Parent = p21
                                v451.FillColor = p22
                                v451.FillTransparency = 0.7
                                v451.OutlineColor = Color3.fromRGB(255, 255, 255)
                                v451.OutlineTransparency = 0.15
                                v451.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            end

                            local u77 = t4

                            function v78()
                                local GetCurrentPlayerData = u69:FindFirstChild('GetCurrentPlayerData', true)

                                if GetCurrentPlayerData and GetCurrentPlayerData:IsA('RemoteFunction') then
                                    if u62 then
                                        u62:Disconnect()

                                        u62 = nil
                                    end

                                    local Heartbeat = u71.Heartbeat
                                    local u459 = GetCurrentPlayerData

                                    u62 = Heartbeat:Connect(function()
                                        if u61 then
                                            if tick() - n4 > 0.5 then
                                                local ok, result = pcall(function()
                                                    return u459:InvokeServer()
                                                end)

                                                if ok and type(result) == 'table' then
                                                    t2 = result
                                                end

                                                n4 = tick()
                                            end

                                            for _, player in ipairs(u72:GetPlayers())do
                                                if player.Character then
                                                    local v871 = u73(player)
                                                    local v872 = u74[v871]

                                                    if player == u75 and not u74.Self then
                                                        v872 = false
                                                    end
                                                    if not v872 then
                                                        local CrystalHub_ESP = player.Character:FindFirstChild('CrystalHub_ESP')

                                                        if CrystalHub_ESP then
                                                            CrystalHub_ESP:Destroy()
                                                        end
                                                    else
                                                        u76(player.Character, u77[v871])
                                                    end
                                                end
                                            end

                                            return
                                        end
                                    end)

                                    return
                                end

                                u70:Notify({
                                    Title = 'CrystalHub',
                                    Content = tostring('ESP remote not found!'),
                                    Duration = 3,
                                    Icon = 'bell',
                                })

                                u61 = false
                            end
                        end
                        do
                            local _ = v68
                            local _ = v78
                            local _ = v68

                            u82 = nil

                            local u83 = LocalPlayer
                            local u84 = Players
                            local RenderStepped = RunService.RenderStepped

                            local function u86()
                                local Character = u83.Character
                                local v464 = Character and Character:FindFirstChild('HumanoidRootPart')

                                if v464 then
                                    local v466 = u83.Backpack:FindFirstChild('Knife') or u83.Character and u83.Character:FindFirstChild('Knife')
                                    local v468 = u83.Backpack:FindFirstChild('Gun') or u83.Character and u83.Character:FindFirstChild('Gun')
                                    local v469 = nil
                                    local n5 = (1/0)

                                    for _, player in ipairs(u84:GetPlayers())do
                                        if player ~= u83 and player.Character then
                                            local Character2 = player.Character
                                            local Humanoid = Character2:FindFirstChildOfClass('Humanoid')

                                            if Humanoid and Humanoid.Health > 0 then
                                                local HumanoidRootPart = Character2:FindFirstChild('HumanoidRootPart')

                                                if HumanoidRootPart then
                                                    local v476 = player.Backpack:FindFirstChild('Knife') or player.Character and player.Character:FindFirstChild('Knife')
                                                    local v477 = player.Backpack:FindFirstChild('Gun') or player.Character and player.Character:FindFirstChild('Gun')
                                                    local Magnitude = (HumanoidRootPart.Position - v464.Position).Magnitude
                                                    local v479 = false

                                                    if not v466 then
                                                        if not v468 then
                                                            if v476 then
                                                                v479 = true
                                                                Magnitude = Magnitude - 1000
                                                            end
                                                            if v477 then
                                                                v479 = true
                                                            end
                                                        elseif v477 or v476 then
                                                            v479 = true
                                                        end
                                                    elseif v476 then
                                                        v479 = true
                                                    end
                                                    if v479 and Magnitude < n5 then
                                                        n5 = Magnitude
                                                        v469 = Character2
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    if not v469 then
                                        for _, player in ipairs(u84:GetPlayers())do
                                            if player ~= u83 and player.Character then
                                                local Character3 = player.Character
                                                local Humanoid = Character3:FindFirstChildOfClass('Humanoid')
                                                local HumanoidRootPart = Character3:FindFirstChild('HumanoidRootPart')

                                                if Humanoid and Humanoid.Health > 0 and HumanoidRootPart then
                                                    local Magnitude = (HumanoidRootPart.Position - v464.Position).Magnitude

                                                    if Magnitude < n5 then
                                                        n5 = Magnitude
                                                        v469 = Character3
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    return v469
                                end

                                return nil
                            end

                            local u87 = LocalPlayer
                            local u88 = Part

                            -- Поиск цели вынесен в Heartbeat (не блокирует рендер)
                            RunService.Heartbeat:Connect(function()
                                u82 = u86()
                            end)

                            -- RenderStepped только обновляет позицию Part (лёгкая операция)
                            RenderStepped:Connect(function()
                                local v486 = u82

                                if v486 then
                                    local Character = u87.Character
                                    local v488 = Character and Character:FindFirstChild('HumanoidRootPart')

                                    if v488 then
                                        local v489 = v486:FindFirstChild('UpperTorso') or (v486:FindFirstChild('Torso') or v486:FindFirstChild('HumanoidRootPart'))
                                        local Humanoid = v486:FindFirstChildOfClass('Humanoid')

                                        if v489 then
                                            local Position = v489.Position
                                            local v492 = (Position - v488.Position).Magnitude / 250

                                            if u13 then
                                                local ok, result = pcall(function()
                                                    return u87:GetNetworkPing()
                                                end)

                                                if ok and result then
                                                    v492 = v492 + result * 0.5
                                                end
                                            end

                                            local AssemblyLinearVelocity = v489.AssemblyLinearVelocity

                                            if Humanoid then
                                                local State = Humanoid:GetState()

                                                if State == Enum.HumanoidStateType.Freefall or State == Enum.HumanoidStateType.Jumping then
                                                    AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y * 0.35, AssemblyLinearVelocity.Z)
                                                end
                                            end

                                            u88.CFrame = CFrame.new(Position + AssemblyLinearVelocity * v492)

                                            return
                                        end

                                        return
                                    end

                                    return
                                end
                            end)
                        end

                        local u89 = LocalPlayer
                        local u90 = v18
                        local u91 = Part
                        local u92 = LocalPlayer
                        local u93 = v18
                        local u94 = Players
                        local u95 = LocalPlayer

                        local function u96()
                            local Character = u92.Character

                            if Character then
                                local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

                                if HumanoidRootPart then
                                    local v507 = u92.Backpack:FindFirstChild('Knife') or Character:FindFirstChild('Knife')

                                    if v507 then
                                        if Character ~= v507.Parent then
                                            Character.Humanoid:EquipTool(v507)
                                            task.wait(0)
                                        end

                                        local v508 = u82

                                        if not u82 then
                                            local n6 = (1/0)

                                            for _, player in ipairs(u94:GetPlayers())do
                                                if player ~= u92 and player.Character then
                                                    local HumanoidRootPart2 = player.Character:FindFirstChild('HumanoidRootPart')
                                                    local Humanoid = player.Character:FindFirstChildOfClass('Humanoid')

                                                    if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
                                                        local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

                                                        if Magnitude < n6 then
                                                            n6 = Magnitude
                                                            v508 = player.Character
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        if v508 then
                                            local HumanoidRootPart3 = v508:FindFirstChild('HumanoidRootPart')

                                            if HumanoidRootPart3 then
                                                local v516 = v508:FindFirstChild('UpperTorso') or (v508:FindFirstChild('Torso') or HumanoidRootPart3)
                                                local AssemblyLinearVelocity = HumanoidRootPart3.AssemblyLinearVelocity
                                                local Magnitude = (v516.Position - HumanoidRootPart.Position).Magnitude
                                                local n7 = 0

                                                if u13 then
                                                    local ok, result = pcall(function()
                                                        return u92:GetNetworkPing()
                                                    end)

                                                    n7 = ok and result or 0
                                                end

                                                local u522 = v516.Position + Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z) * (Magnitude / 65 + n7 * 0.5)
                                                local _pcall = pcall
                                                local u524 = v507
                                                local u525 = HumanoidRootPart

                                                pcall(function()
                                                    local KnifeThrown = u524:WaitForChild('Events'):WaitForChild('KnifeThrown')
                                                    local cFrame = CFrame.new(u525.Position, u522)
                                                    local v881 = (function(...)
                                                        local t5 = {...}

                                                        t5.n = select('#', ...)

                                                        return t5
                                                    end)(CFrame.new(u522))

                                                    KnifeThrown:FireServer(cFrame, unpack(v881, 1, v881.n))
                                                end)

                                                return
                                            end

                                            return
                                        end

                                        u93:Notify({
                                            Title = 'CrystalHub',
                                            Content = tostring('No target found!'),
                                            Duration = 3,
                                            Icon = 'bell',
                                        })

                                        return
                                    end

                                    u93:Notify({
                                        Title = 'CrystalHub',
                                        Content = tostring('No knife in inventory!'),
                                        Duration = 3,
                                        Icon = 'bell',
                                    })

                                    return
                                end

                                return
                            end
                        end
                        local function u97()
                            local Character = u89.Character

                            if Character then
                                local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

                                if HumanoidRootPart then
                                    local v499 = u89.Backpack:FindFirstChild('Gun') or Character:FindFirstChild('Gun')

                                    if v499 then
                                        if u82 then
                                            if Character ~= v499.Parent then
                                                Character.Humanoid:EquipTool(v499)
                                                task.wait(0)
                                            end

                                            local CFramePosition = u91.CFrame.Position
                                            local v501 = HumanoidRootPart.Position + Vector3.new(0, 1, 0)
                                            local cFrame = CFrame.new(v501, CFramePosition)
                                            local _pcall = pcall
                                            local u504 = v499

                                            pcall(function()
                                                local Shoot = u504:WaitForChild('Shoot')
                                                local v876 = (function(...)
                                                    local t6 = {...}

                                                    t6.n = select('#', ...)

                                                    return t6
                                                end)(CFrame.new(CFramePosition))

                                                Shoot:FireServer(cFrame, unpack(v876, 1, v876.n))

                                                -- Bullet tracer: срабатывает при нажатии кнопки Shoot
                                                if _BT and _BT.Enabled and _bullettracerlol then
                                                    local gun  = u504
                                                    local h    = gun:FindFirstChild("Handle")
                                                    local sPos = h and h.Position or v501
                                                    local ePos = CFramePosition
                                                    task.spawn(_bullettracerlol, sPos, ePos)
                                                end
                                            end)

                                            return
                                        end

                                        u90:Notify({
                                            Title = 'CrystalHub',
                                            Content = tostring('No target found.'),
                                            Duration = 3,
                                            Icon = 'bell',
                                        })

                                        return
                                    end

                                    u90:Notify({
                                        Title = 'CrystalHub',
                                        Content = tostring('No gun in inventory!'),
                                        Duration = 3,
                                        Icon = 'bell',
                                    })

                                    return
                                end

                                return
                            end
                        end

                        function u98()
                            if u95.Character then
                                if not u95.Backpack:FindFirstChild('Knife') and (not u95.Character or not u95.Character:FindFirstChild('Knife')) then
                                    u97()

                                    return
                                end

                                u96()

                                return
                            end
                        end
                    end

                    u99 = false

                    do
                        local u100 = LocalPlayer
                        local u101 = UserInputService
                        local u102 = CurrentCamera
                        local u103 = RunService

                        function u104()
                            if u99 then
                                return
                            end

                            local Character = u100.Character

                            if not Character then
                                return
                            end

                            local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

                            if not HumanoidRootPart then
                                return
                            end

                            u99 = true

                            local g539

                            if u101.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                                local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
                                local v530 = HumanoidRootPartCFrame * CFrame.Angles(0, 3.141592653589793, 0)

                                for i = 1, 4 do
                                    HumanoidRootPart.CFrame = HumanoidRootPartCFrame:Lerp(v530, i / 4)

                                    u103.RenderStepped:Wait()
                                end
                            else
                                local CFrame2 = u102.CFrame
                                local LookVector = CFrame2.LookVector
                                local vector3 = Vector3.new(-LookVector.X, LookVector.Y, -LookVector.Z)
                                local cFrame = CFrame.lookAt(CFrame2.Position, CFrame2.Position + vector3)
                                local n8 = 1
                                local n9 = 5
                                local n10 = 1

                                g539 = nil

                                if false then
                                    if true then
                                        g539 = true
                                    end
                                elseif not (n8 <= n9) then
                                    g539 = true
                                end
                                if not g539 then
                                    if not g539 then
                                        repeat
                                            while true do
                                                u102.CFrame = CFrame2:Lerp(cFrame, n8 / 5)

                                                u103.RenderStepped:Wait()

                                                n8 = n8 + n10

                                                if n10 > 0 then
                                                    break
                                                end
                                                if not (n9 <= n8) then
                                                    g539 = true
                                                end
                                                if g539 then
                                                    break
                                                end
                                            end

                                            if g539 then
                                                break
                                            end
                                        until not (n8 <= n9)
                                    end
                                end
                            end

                            g539 = false

                            task.wait(0.15)

                            u99 = false
                        end

                        u105 = false

                        local u106 = LocalPlayer
                        local u107 = UserInputService
                        local u108 = CurrentCamera
                        local u109 = RunService

                        function u110()
                            local v540 = nil
                            local RenderStepped = nil
                            local v542 = nil
                            local v543 = nil

                            if u105 then
                                return
                            end

                            local Character = u106.Character

                            if not Character then
                                return
                            end

                            local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

                            if not HumanoidRootPart then
                                return
                            end

                            local Humanoid = Character:FindFirstChildOfClass('Humanoid')

                            if not Humanoid then
                                return
                            end

                            u105 = true

                            local v547 = u107.MouseBehavior == Enum.MouseBehavior.LockCenter
                            local _, v549, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()
                            local CFrame3 = u108.CFrame
                            local g590 = nil
                            local g566

                            if not v547 then
                                local v552 = v549 - 1.5707963267948966

                                for i = 1, 7 do
                                    local _ = i / 7
                                    local _ = RenderStepped ^ 2
                                    local cFrame = CFrame.new(HumanoidRootPart.Position)
                                    local fromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ

                                    v543 = v549 + (v552 - v549) * v540
                                    v542 = fromEulerAnglesYXZ(0, v543, 0)
                                    HumanoidRootPart.CFrame = cFrame * v542
                                    RenderStepped = u109.RenderStepped

                                    RenderStepped:Wait()
                                end
                            else
                                local Unit = Vector3.new(CFrame3.LookVector.X, 0, CFrame3.LookVector.Z).Unit
                                local new = Vector3.new
                                local RightVectorX = CFrame3.RightVector.X
                                local RightVectorZ = CFrame3.RightVector.Z
                                local Unit2 = new(RightVectorX, 0, RightVectorZ).Unit
                                local n11 = 1
                                local n12 = 7
                                local n13 = 1

                                g566 = nil

                                if false then
                                    if true then
                                        g566 = true
                                    end
                                elseif not (n11 <= n12) then
                                    g566 = true
                                end
                                if not g566 then
                                    if not g566 then
                                        repeat
                                            while true do
                                                local _ = n11 / 7
                                                local _ = v542 ^ 2
                                                local lookAt = CFrame.lookAt
                                                local CFramePosition = u108.CFrame.Position

                                                v543 = u108.CFrame.Position + Unit:Lerp(Unit2, RightVectorZ).Unit
                                                u108.CFrame = lookAt(CFramePosition, v543)
                                                v542 = u109.RenderStepped

                                                v542:Wait()

                                                n11 = n11 + n13

                                                if n13 > 0 then
                                                    break
                                                end
                                                if not (n12 <= n11) then
                                                    g566 = true
                                                end
                                                if g566 then
                                                    break
                                                end
                                            end

                                            if g566 then
                                                break
                                            end
                                        until not (n11 <= n12)
                                    end
                                end
                            end

                            g566 = false

                            local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

                            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 55, AssemblyLinearVelocity.Z)

                            local _pcall = pcall
                            local u574 = Humanoid

                            pcall(function()
                                u574:ChangeState(Enum.HumanoidStateType.Jumping)
                            end)
                            task.wait(0.12)

                            if not v547 then
                                local _, v576, _ = HumanoidRootPart.CFrame:ToEulerAnglesYXZ()

                                for i = 1, 5 do
                                    local _ = i / 5
                                    local _ = v543 ^ 2

                                    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * CFrame.fromEulerAnglesYXZ(0, v576 + (v549 - v576) * v542, 0)
                                    v543 = u109.RenderStepped

                                    v543:Wait()
                                end
                            else
                                local Unit = Vector3.new(CFrame3.LookVector.X, 0, CFrame3.LookVector.Z).Unit
                                local new = Vector3.new
                                local LookVectorX = u108.CFrame.LookVector.X
                                local CFrame4 = u108.CFrame
                                local LookVectorZ = CFrame4.LookVector.Z
                                local Unit3 = new(LookVectorX, 0, LookVectorZ).Unit
                                local n14 = 1
                                local n15 = 5
                                local n16 = 1

                                if false then
                                    if true then
                                        g590 = true
                                    end
                                elseif not (n14 <= n15) then
                                    g590 = true
                                end
                                if not g590 then
                                    if not g590 then
                                        repeat
                                            while true do
                                                local _ = n14 / 5
                                                local _ = CFrame4 ^ 2

                                                u108.CFrame = CFrame.lookAt(u108.CFrame.Position, u108.CFrame.Position + Unit3:Lerp(Unit, LookVectorZ).Unit)
                                                CFrame4 = u109.RenderStepped

                                                CFrame4:Wait()

                                                n14 = n14 + n16

                                                if n16 > 0 then
                                                    break
                                                end
                                                if not (n15 <= n14) then
                                                    g590 = true
                                                end
                                                if g590 then
                                                    break
                                                end
                                            end

                                            if g590 then
                                                break
                                            end
                                        until not (n14 <= n15)
                                    end
                                end
                            end

                            g590 = false

                            task.wait(0.1)

                            u105 = false
                        end
                    end

                    local spawn = task.spawn
                    local u112 = ReplicatedStorage

                    spawn(function()
                        while true do
                            task.wait(2)
                            pcall(function()
                                u112.Remotes.Extras.ReplicateToy:InvokeServer('FakeBomb')
                                u112.Remotes.Extras.ReplicateToy:InvokeServer('GoldBomb')
                            end)
                        end
                    end)

                    local u113 = LocalPlayer
                    local u114 = v18

                    function v115(p23, p24)
                        local Character = u113.Character

                        if Character then
                            local v596 = u113.Backpack:FindFirstChild(p23) or Character:FindFirstChild(p23)

                            if v596 then
                                local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

                                if HumanoidRootPart then
                                    if Character ~= v596.Parent then
                                        Character.Humanoid:EquipTool(v596)
                                        task.wait()
                                    end

                                    local _pcall = pcall
                                    local u599 = v596
                                    local u600 = HumanoidRootPart

                                    pcall(function()
                                        u599.Remote:FireServer(CFrame.new(u600.Position + u600.CFrame.LookVector * 1.5 + Vector3.new(0, -3, 0)), 50)
                                    end)
                                    Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

                                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, 62, HumanoidRootPart.AssemblyLinearVelocity.Z)

                                    if not p24 then
                                        task.spawn(function()
                                            u10 = true

                                            task.wait(21)

                                            u10 = false
                                        end)

                                        return
                                    end

                                    task.spawn(function()
                                        u9 = true

                                        task.wait(4)

                                        u9 = false
                                    end)

                                    return
                                end

                                return
                            end

                            local v601 = 'No ' .. p23 .. ' found!'

                            u114:Notify({
                                Title = 'CrystalHub',
                                Content = tostring(v601),
                                Duration = 3,
                                Icon = 'bell',
                            })

                            return
                        end
                    end

                    u116 = false

                    local u117 = nil
                    local u118 = RunService

                    local function v119(p25)
                        local Humanoid = p25:WaitForChild('Humanoid')

                        if u117 then
                            u117:Disconnect()
                        end

                        local RenderStepped = u118.RenderStepped
                        local u605 = Humanoid

                        local u901 = false

                        u117 = RenderStepped:Connect(function()
                            if u116 then
                                u901 = true

                                local State = u605:GetState()

                                u605.WalkSpeed = (State == Enum.HumanoidStateType.Jumping or State == Enum.HumanoidStateType.Freefall) and (u605.MoveDirection.Magnitude > 0 and n2) or 16

                                return
                            end
                            if u901 then
                                u901 = false
                                u605.WalkSpeed = 16
                            end
                        end)
                    end

                    LocalPlayer.CharacterAdded:Connect(v119)

                    if LocalPlayer.Character then
                        task.spawn(v119, LocalPlayer.Character)
                    end

                    u120 = false

                    local u121 = nil

                    n17 = 0.5

                    local u123 = RunService
                    local u124 = CurrentCamera

                    function v125(p26)
                        u120 = p26

                        if not p26 then
                            if u121 then
                                u121:Disconnect()

                                u121 = nil
                            end

                            return
                        end
                        if u121 then
                            u121:Disconnect()
                        end

                        u121 = u123.RenderStepped:Connect(function()
                            u124.CFrame = u124.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, n17, 0, 0, 0, 1)
                        end)
                    end
                end

                u126 = v25
                u127 = v125
                u128 = v18
                u129 = Workspace
                u130 = v18
                u131 = LocalPlayer

                do
                    -- ===================== SKYBOX ASSETS =====================
                    local SkyboxAssets = {
                        ["Black Storm"] = { Bk="rbxassetid://15502511288", Dn="rbxassetid://15502508460", Ft="rbxassetid://15502510289", Lf="rbxassetid://15502507918", Rt="rbxassetid://15502509398", Up="rbxassetid://15502511911" },
                        ["HD"] = { Bk="http://www.roblox.com/asset/?id=16553658937", Dn="http://www.roblox.com/asset/?id=16553660713", Ft="http://www.roblox.com/asset/?id=16553662144", Lf="http://www.roblox.com/asset/?id=16553664042", Rt="http://www.roblox.com/asset/?id=16553665766", Up="http://www.roblox.com/asset/?id=16553667750" },
                        ["Snow"] = { Bk="http://www.roblox.com/asset/?id=155657655", Dn="http://www.roblox.com/asset/?id=155674246", Ft="http://www.roblox.com/asset/?id=155657609", Lf="http://www.roblox.com/asset/?id=155657671", Rt="http://www.roblox.com/asset/?id=155657619", Up="http://www.roblox.com/asset/?id=155674931" },
                        ["Blue Space"] = { Bk="rbxassetid://15536110634", Dn="rbxassetid://15536112543", Ft="rbxassetid://15536116141", Lf="rbxassetid://15536114370", Rt="rbxassetid://15536118762", Up="rbxassetid://15536117282" },
                        ["Realistic"] = { Bk="rbxassetid://653719502", Dn="rbxassetid://653718790", Ft="rbxassetid://653719067", Lf="rbxassetid://653719190", Rt="rbxassetid://653718931", Up="rbxassetid://653719321" },
                        ["Stormy"] = { Bk="http://www.roblox.com/asset/?id=18703245834", Dn="http://www.roblox.com/asset/?id=18703243349", Ft="http://www.roblox.com/asset/?id=18703240532", Lf="http://www.roblox.com/asset/?id=18703237556", Rt="http://www.roblox.com/asset/?id=18703235430", Up="http://www.roblox.com/asset/?id=18703232671" },
                        ["Pink"] = { Bk="rbxassetid://12216109205", Dn="rbxassetid://12216109875", Ft="rbxassetid://12216109489", Lf="rbxassetid://12216110170", Rt="rbxassetid://12216110471", Up="rbxassetid://12216108877" },
                        ["Sunset"] = { Bk="rbxassetid://600830446", Dn="rbxassetid://600831635", Ft="rbxassetid://600832720", Lf="rbxassetid://600886090", Rt="rbxassetid://600833862", Up="rbxassetid://600835177" },
                        ["Arctic"] = { Bk="http://www.roblox.com/asset/?id=225469390", Dn="http://www.roblox.com/asset/?id=225469395", Ft="http://www.roblox.com/asset/?id=225469403", Lf="http://www.roblox.com/asset/?id=225469450", Rt="http://www.roblox.com/asset/?id=225469471", Up="http://www.roblox.com/asset/?id=225469481" },
                        ["Space"] = { Bk="http://www.roblox.com/asset/?id=166509999", Dn="http://www.roblox.com/asset/?id=166510057", Ft="http://www.roblox.com/asset/?id=166510116", Lf="http://www.roblox.com/asset/?id=166510092", Rt="http://www.roblox.com/asset/?id=166510131", Up="http://www.roblox.com/asset/?id=166510114" },
                        ["Roblox Default"] = { Bk="rbxasset://textures/sky/sky512_bk.tex", Dn="rbxasset://textures/sky/sky512_dn.tex", Ft="rbxasset://textures/sky/sky512_ft.tex", Lf="rbxasset://textures/sky/sky512_lf.tex", Rt="rbxasset://textures/sky/sky512_rt.tex", Up="rbxasset://textures/sky/sky512_up.tex" },
                        ["Red Night"] = { Bk="http://www.roblox.com/asset/?id=401664839", Dn="http://www.roblox.com/asset/?id=401664862", Ft="http://www.roblox.com/asset/?id=401664960", Lf="http://www.roblox.com/asset/?id=401664881", Rt="http://www.roblox.com/asset/?id=401664901", Up="http://www.roblox.com/asset/?id=401664936" },
                        ["Deep Space 1"] = { Bk="http://www.roblox.com/asset/?id=149397692", Dn="http://www.roblox.com/asset/?id=149397686", Ft="http://www.roblox.com/asset/?id=149397697", Lf="http://www.roblox.com/asset/?id=149397684", Rt="http://www.roblox.com/asset/?id=149397688", Up="http://www.roblox.com/asset/?id=149397702" },
                        ["Pink Skies"] = { Bk="http://www.roblox.com/asset/?id=151165214", Dn="http://www.roblox.com/asset/?id=151165197", Ft="http://www.roblox.com/asset/?id=151165224", Lf="http://www.roblox.com/asset/?id=151165191", Rt="http://www.roblox.com/asset/?id=151165206", Up="http://www.roblox.com/asset/?id=151165227" },
                        ["Purple Sunset"] = { Bk="rbxassetid://264908339", Dn="rbxassetid://264907909", Ft="rbxassetid://264909420", Lf="rbxassetid://264909758", Rt="rbxassetid://264908886", Up="rbxassetid://264907379" },
                        ["Blue Night"] = { Bk="http://www.roblox.com/asset/?id=12064107", Dn="http://www.roblox.com/asset/?id=12064152", Ft="http://www.roblox.com/asset/?id=12064121", Lf="http://www.roblox.com/asset/?id=12063984", Rt="http://www.roblox.com/asset/?id=12064115", Up="http://www.roblox.com/asset/?id=12064131" },
                        ["Blossom Daylight"] = { Bk="http://www.roblox.com/asset/?id=271042516", Dn="http://www.roblox.com/asset/?id=271077243", Ft="http://www.roblox.com/asset/?id=271042556", Lf="http://www.roblox.com/asset/?id=271042310", Rt="http://www.roblox.com/asset/?id=271042467", Up="http://www.roblox.com/asset/?id=271077958" },
                        ["Blue Nebula"] = { Bk="http://www.roblox.com/asset?id=135207744", Dn="http://www.roblox.com/asset?id=135207662", Ft="http://www.roblox.com/asset?id=135207770", Lf="http://www.roblox.com/asset?id=135207615", Rt="http://www.roblox.com/asset?id=135207695", Up="http://www.roblox.com/asset?id=135207794" },
                        ["Blue Planet"] = { Bk="rbxassetid://218955819", Dn="rbxassetid://218953419", Ft="rbxassetid://218954524", Lf="rbxassetid://218958493", Rt="rbxassetid://218957134", Up="rbxassetid://218950090" },
                        ["Deep Space 2"] = { Bk="http://www.roblox.com/asset/?id=159248188", Dn="http://www.roblox.com/asset/?id=159248183", Ft="http://www.roblox.com/asset/?id=159248187", Lf="http://www.roblox.com/asset/?id=159248173", Rt="http://www.roblox.com/asset/?id=159248192", Up="http://www.roblox.com/asset/?id=159248176" },
                        ["Summer"] = { Bk="rbxassetid://16648590964", Dn="rbxassetid://16648617436", Ft="rbxassetid://16648595424", Lf="rbxassetid://16648566370", Rt="rbxassetid://16648577071", Up="rbxassetid://16648598180" },
                        ["Galaxy"] = { Bk="rbxassetid://15983968922", Dn="rbxassetid://15983966825", Ft="rbxassetid://15983965025", Lf="rbxassetid://15983967420", Rt="rbxassetid://15983966246", Up="rbxassetid://15983964246" },
                        ["Stylized"] = { Bk="rbxassetid://18351376859", Dn="rbxassetid://18351374919", Ft="rbxassetid://18351376800", Lf="rbxassetid://18351376469", Rt="rbxassetid://18351376457", Up="rbxassetid://18351377189" },
                        ["Minecraft"] = { Bk="rbxassetid://8735166756", Dn="http://www.roblox.com/asset/?id=8735166707", Ft="http://www.roblox.com/asset/?id=8735231668", Lf="http://www.roblox.com/asset/?id=8735166755", Rt="http://www.roblox.com/asset/?id=8735166751", Up="http://www.roblox.com/asset/?id=8735166729" },
                        ["Cloudy Rain"] = { Bk="http://www.roblox.com/asset/?id=4498828382", Dn="http://www.roblox.com/asset/?id=4498828812", Ft="http://www.roblox.com/asset/?id=4498829917", Lf="http://www.roblox.com/asset/?id=4498830911", Rt="http://www.roblox.com/asset/?id=4498830417", Up="http://www.roblox.com/asset/?id=4498831746" },
                        ["Black Cloudy Rain"] = { Bk="http://www.roblox.com/asset/?id=149679669", Dn="http://www.roblox.com/asset/?id=149681979", Ft="http://www.roblox.com/asset/?id=149679690", Lf="http://www.roblox.com/asset/?id=149679709", Rt="http://www.roblox.com/asset/?id=149679722", Up="http://www.roblox.com/asset/?id=149680199" },
                    }
                    -- Build t7 list for picker (using Up face as color preview reference)
                    local t7 = {}
                    local skyColorMap = {
                        ["Black Storm"]={30,30,40}, ["HD"]={100,160,220}, ["Snow"]={200,220,240},
                        ["Blue Space"]={40,80,180}, ["Realistic"]={120,170,220}, ["Stormy"]={60,60,80},
                        ["Pink"]={220,100,160}, ["Sunset"]={230,120,60}, ["Arctic"]={180,210,240},
                        ["Space"]={20,20,60}, ["Roblox Default"]={100,180,255}, ["Red Night"]={160,30,30},
                        ["Deep Space 1"]={20,20,50}, ["Pink Skies"]={220,140,180}, ["Purple Sunset"]={140,60,180},
                        ["Blue Night"]={30,60,140}, ["Blossom Daylight"]={180,220,200}, ["Blue Nebula"]={60,100,200},
                        ["Blue Planet"]={60,120,200}, ["Deep Space 2"]={20,20,60}, ["Summer"]={100,200,240},
                        ["Galaxy"]={80,40,160}, ["Stylized"]={120,180,240}, ["Minecraft"]={100,180,240},
                        ["Cloudy Rain"]={100,110,120}, ["Black Cloudy Rain"]={30,30,35},
                    }
                    local skyboxOrder = {"Black Storm","HD","Snow","Blue Space","Realistic","Stormy","Pink","Sunset","Arctic","Space","Roblox Default","Red Night","Deep Space 1","Pink Skies","Purple Sunset","Blue Night","Blossom Daylight","Blue Nebula","Blue Planet","Deep Space 2","Summer","Galaxy","Stylized","Minecraft","Cloudy Rain","Black Cloudy Rain"}
                    for i, name in ipairs(skyboxOrder) do
                        local c = skyColorMap[name] or {128,128,128}
                        t7[i] = { name=name, id=name, color=Color3.fromRGB(c[1],c[2],c[3]) }
                    end

                    local u140 = nil
                    local u141 = false
                    local u142 = Lighting;

                    (function()
                        local Sky = u142:FindFirstChildOfClass('Sky')

                        if Sky then
                            u140 = {
                                SkyboxBk = Sky.SkyboxBk,
                                SkyboxDn = Sky.SkyboxDn,
                                SkyboxFt = Sky.SkyboxFt,
                                SkyboxLf = Sky.SkyboxLf,
                                SkyboxRt = Sky.SkyboxRt,
                                SkyboxUp = Sky.SkyboxUp,
                            }
                        end
                    end)()

                    local u143 = Lighting
                    local u144 = v18

                    function v145()
                        for _, child in pairs(u143:GetChildren())do
                            if child:IsA('Sky') or child:IsA('Atmosphere') or child:IsA('Clouds') then
                                child:Destroy()
                            end
                        end

                        if u140 then
                            local Sky = Instance.new('Sky', u143)

                            for k, v in pairs(u140)do
                                Sky[k] = v
                            end
                        end

                        u141 = false

                        u144:Notify({
                            Title = 'CrystalHub',
                            Content = tostring('Skybox restored to default.'),
                            Duration = 3,
                            Icon = 'bell',
                        })
                    end

                    local u146 = Lighting

                    function u147(p27)
                        for _, child in pairs(u146:GetChildren())do
                            if child:IsA('Sky') or child:IsA('Atmosphere') or child:IsA('Clouds') then
                                child:Destroy()
                            end
                        end

                        local Sky = Instance.new('Sky', u146)
                        Sky.Name = 'CrystalHub_CustomSky'

                        -- p27 is either a skybox name (from SkyboxAssets) or a raw asset ID string
                        local faces = SkyboxAssets[tostring(p27)]
                        if faces then
                            Sky.SkyboxBk = faces.Bk
                            Sky.SkyboxDn = faces.Dn
                            Sky.SkyboxFt = faces.Ft
                            Sky.SkyboxLf = faces.Lf
                            Sky.SkyboxRt = faces.Rt
                            Sky.SkyboxUp = faces.Up
                        else
                            local v625 = 'rbxassetid://' .. tostring(p27)
                            Sky.SkyboxBk = v625
                            Sky.SkyboxDn = v625
                            Sky.SkyboxFt = v625
                            Sky.SkyboxLf = v625
                            Sky.SkyboxRt = v625
                            Sky.SkyboxUp = v625
                        end
                        Sky.SunTextureId = ''
                        Sky.MoonTextureId = ''
                        Sky.SunAngularSize = 0
                        Sky.StarCount = 0
                        u146.ClockTime = 14
                        u146.Brightness = 2
                        u146.GlobalShadows = false
                        u146.FogEnd = 999999
                        u141 = true
                    end

                    u148 = v18
                    u149 = v145
                    u150 = t7
                    u151 = v21

                    local u152 = false
                    local u153 = nil
                    local u154 = RunService
                    local u155 = LocalPlayer

                    -- ── ANTI-FLING (shitaro) ──────────────────────────────
                    do
                        local _af_players    = game:GetService("Players")
                        local _af_run        = game:GetService("RunService")
                        local _af_ws         = workspace
                        local _af_lp         = _af_players.LocalPlayer

                        local anti_fling     = false
                        local _af_void_orig  = _af_ws.FallenPartsDestroyHeight

                        local FLING_MAX_VEL  = 700
                        local FLING_MAX_ANG  = 90
                        local FLING_SNAP_DIST = 60
                        local FLING_HOLD     = 0.25
                        local FLING_SAFE_VEL = 250

                        local fling_cache    = {}
                        local fling_reg      = {}
                        local fling_conns    = {}
                        local fling_attached = false
                        local fling_safe_cf  = nil
                        local fling_hold_until = 0
                        local fling_active_since = 0

                        local function _af_get_hrp()
                            local c = _af_lp.Character
                            return c and c:FindFirstChild("HumanoidRootPart")
                        end

                        local function _af_fling_busy()
                            if os.clock() < (getgenv().VELOCITY_DESYNC_UNTIL or 0) then return true end
                            if (getgenv().FLING_ACTIVE or 0) > 0 then
                                local now = os.clock()
                                if fling_active_since == 0 then fling_active_since = now end
                                if now - fling_active_since < 20 then return true end
                                getgenv().FLING_ACTIVE = 0; fling_active_since = 0; return false
                            end
                            fling_active_since = 0; return false
                        end

                        local function _af_kill_part(p)
                            if fling_cache[p] == nil then fling_cache[p] = p.CanCollide end
                            if p.CanCollide then p.CanCollide = false end
                        end

                        local function _af_unregister(model)
                            local entry = fling_reg[model]
                            if not entry then return end
                            fling_reg[model] = nil
                            for i = 1, #entry.conns do pcall(function() entry.conns[i]:Disconnect() end) end
                            for p in pairs(entry.parts) do
                                local v = fling_cache[p]; fling_cache[p] = nil
                                if v ~= nil and p.Parent then pcall(function() p.CanCollide = v end) end
                            end
                            table.clear(entry.parts)
                        end

                        local function _af_register(model)
                            if not anti_fling or not model then return end
                            if fling_reg[model] or model == _af_lp.Character then return end
                            local entry = { parts = {}, conns = {} }
                            fling_reg[model] = entry
                            local function add(d)
                                if d:IsA("BasePart") and not entry.parts[d] then
                                    entry.parts[d] = true
                                    if anti_fling then pcall(_af_kill_part, d) end
                                end
                            end
                            for _, d in model:GetDescendants() do pcall(add, d) end
                            local function push(c) entry.conns[#entry.conns + 1] = c end
                            push(model.DescendantAdded:Connect(function(d) if anti_fling then pcall(add, d) end end))
                            push(model.DescendantRemoving:Connect(function(d)
                                if entry.parts[d] then entry.parts[d] = nil; fling_cache[d] = nil end
                            end))
                            push(model.AncestryChanged:Connect(function(_, parent)
                                if not parent then _af_unregister(model) end
                            end))
                        end

                        local function _af_is_body(m)
                            return m ~= _af_lp.Character
                                and m:IsA("Model")
                                and m:FindFirstChildOfClass("Humanoid") ~= nil
                        end

                        local function _af_scan()
                            for _, pl in _af_players:GetPlayers() do
                                if pl ~= _af_lp and pl.Character then _af_register(pl.Character) end
                            end
                            for _, m in _af_ws:GetChildren() do
                                if _af_is_body(m) then _af_register(m) end
                            end
                        end

                        local function _af_sweep()
                            for model, entry in pairs(fling_reg) do
                                if not model.Parent or model == _af_lp.Character then
                                    _af_unregister(model)
                                else
                                    for p in pairs(entry.parts) do
                                        if p.Parent then
                                            if p.CanCollide then
                                                if fling_cache[p] == nil then fling_cache[p] = true end
                                                p.CanCollide = false
                                            end
                                        else entry.parts[p] = nil; fling_cache[p] = nil end
                                    end
                                end
                            end
                        end

                        local function _af_guard(full)
                            local hrp = _af_get_hrp()
                            if not hrp or not hrp.Parent then fling_safe_cf = nil; return end
                            if _af_fling_busy() then fling_safe_cf = nil; return end
                            local lin = hrp.AssemblyLinearVelocity
                            local ang = hrp.AssemblyAngularVelocity
                            local spike = lin.Magnitude > FLING_MAX_VEL or ang.Magnitude > FLING_MAX_ANG
                            local now = os.clock()
                            if spike then fling_hold_until = now + FLING_HOLD end
                            if spike or now < fling_hold_until then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                if full and fling_safe_cf then
                                    if (hrp.Position - fling_safe_cf.Position).Magnitude > FLING_SNAP_DIST then
                                        hrp.CFrame = fling_safe_cf
                                    end
                                end
                            elseif full and lin.Magnitude < FLING_SAFE_VEL then
                                fling_safe_cf = hrp.CFrame
                            end
                        end

                        local function _af_detach()
                            fling_attached = false
                            for i = 1, #fling_conns do pcall(function() fling_conns[i]:Disconnect() end) end
                            table.clear(fling_conns)
                        end

                        local function _af_attach()
                            if fling_attached then return end
                            fling_attached = true
                            local function push(c) fling_conns[#fling_conns + 1] = c end
                            local function watch(pl)
                                if pl == _af_lp then return end
                                push(pl.CharacterAdded:Connect(function(c) if anti_fling then _af_register(c) end end))
                                push(pl.CharacterRemoving:Connect(function(c) _af_unregister(c) end))
                            end
                            for _, pl in _af_players:GetPlayers() do watch(pl) end
                            push(_af_players.PlayerAdded:Connect(function(pl)
                                watch(pl)
                                if anti_fling and pl.Character then _af_register(pl.Character) end
                            end))
                            push(_af_players.PlayerRemoving:Connect(function(pl)
                                if pl.Character then _af_unregister(pl.Character) end
                            end))
                            push(_af_ws.ChildAdded:Connect(function(m)
                                if not anti_fling then return end
                                task.defer(function()
                                    if anti_fling and m.Parent == _af_ws and _af_is_body(m) then _af_register(m) end
                                end)
                            end))
                            push(_af_lp.CharacterAdded:Connect(function(c)
                                _af_unregister(c); fling_safe_cf = nil; fling_hold_until = 0
                                if anti_fling then task.defer(_af_scan) end
                            end))
                            _af_scan()
                        end

                        local function _af_restore()
                            _af_detach()
                            for model in pairs(fling_reg) do _af_unregister(model) end
                            table.clear(fling_reg)
                            for p, v in pairs(fling_cache) do
                                if p and p.Parent then pcall(function() p.CanCollide = v end) end
                            end
                            table.clear(fling_cache)
                            fling_safe_cf = nil; fling_hold_until = 0
                        end

                        _af_run.Stepped:Connect(function()
                            if anti_fling then
                                if not fling_attached then pcall(_af_attach) end
                                pcall(_af_sweep)
                                pcall(_af_guard, true)
                            end
                        end)

                        _af_run.Heartbeat:Connect(function()
                            if anti_fling then pcall(_af_guard, false) end
                        end)

                        getgenv().ANTI_FLING = {
                            enable = function(v)
                                anti_fling = v
                                if v then _af_attach() else _af_restore() end
                            end,
                            unload = function()
                                anti_fling = false
                                pcall(function() _af_ws.FallenPartsDestroyHeight = _af_void_orig end)
                                _af_restore()
                            end,
                        }
                    end

                    -- u156 теперь делегирует в ANTI_FLING
                    function u156(p28)
                        if getgenv().ANTI_FLING then
                            getgenv().ANTI_FLING.enable(p28)
                        end
                    end
                end

                getgenv().RuzOldPos = nil
                getgenv().RuzFPDH = Workspace.FallenPartsDestroyHeight
                u157 = false

                local u158 = LocalPlayer
                local u159 = v18
                local u160 = Workspace

                local function v161(p29)
                    if not u157 then
                        local Character = u158.Character

                        if Character then
                            local Humanoid = Character:FindFirstChildOfClass('Humanoid')

                            if Humanoid then
                                local RootPart = Humanoid.RootPart

                                if RootPart then
                                    local Character4 = p29.Character

                                    if Character4 then
                                        local Humanoid2 = Character4:FindFirstChildOfClass('Humanoid')
                                        local v663 = Humanoid2 and Humanoid2.RootPart
                                        local Head = Character4:FindFirstChild('Head')
                                        local Accessory = Character4:FindFirstChildOfClass('Accessory')
                                        local v666 = Accessory and Accessory:FindFirstChild('Handle')

                                        if RootPart.Velocity.Magnitude < 50 then
                                            getgenv().RuzOldPos = RootPart.CFrame
                                        end
                                        if not Humanoid2 or not Humanoid2.Sit then
                                            local v667 = Head or (v666 or Humanoid2)

                                            if v667 then
                                                u160.CurrentCamera.CameraSubject = v667
                                            end
                                            if Character4:FindFirstChildWhichIsA('BasePart') then
                                                local u668 = RootPart
                                                local u669 = Character

                                                local function u670(p30, p31, p32)
                                                    u668.CFrame = CFrame.new(p30.Position) * p31 * p32

                                                    local _pcall = pcall
                                                    local u900 = p30
                                                    local u901 = p31
                                                    local u902 = p32

                                                    pcall(function()
                                                        u669:SetPrimaryPartCFrame(CFrame.new(u900.Position) * u901 * u902)
                                                    end)

                                                    u668.Velocity = Vector3.new(90000000, 900000000, 90000000)
                                                    u668.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
                                                end

                                                local u671 = RootPart

                                                u157 = true
                                                u160.FallenPartsDestroyHeight = (0 / 0)

                                                local BodyVelocity = Instance.new('BodyVelocity')

                                                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                                                BodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                                BodyVelocity.Parent = RootPart

                                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                                                local v673 = v663 or (Head or v666)

                                                if not v673 then
                                                    local v674 = p29.Name .. ' \u{2014} no valid fling part.'

                                                    u159:Notify({
                                                        Title = 'CrystalHub',
                                                        Content = tostring(v674),
                                                        Duration = 3,
                                                        Icon = 'bell',
                                                    })
                                                else
                                                    (function(p33)
                                                        local v904 = tick() + 2.5
                                                        local n18 = 0

                                                        while u671 and Humanoid2 do
                                                            local Magnitude = p33.Velocity.Magnitude

                                                            if not (Magnitude < 40) then
                                                                local MoveDirection = Humanoid2.MoveDirection
                                                                local WalkSpeed = Humanoid2.WalkSpeed

                                                                u670(p33, CFrame.new(MoveDirection.X * WalkSpeed * 0.12, 3, MoveDirection.Z * WalkSpeed * 0.12), CFrame.Angles(1.5707963267948966, 0, 0))

                                                                u671.Velocity = Vector3.new(900000000, 900000000, 900000000)

                                                                task.wait()
                                                                u670(p33, CFrame.new(-MoveDirection.X * WalkSpeed * 0.06, -3, -MoveDirection.Z * WalkSpeed * 0.06), CFrame.Angles(0, 0, 0))

                                                                u671.Velocity = Vector3.new(900000000, 900000000, 900000000)

                                                                task.wait()
                                                                u670(p33, CFrame.new(MoveDirection.X * WalkSpeed * 0.18, 3, MoveDirection.Z * WalkSpeed * 0.18), CFrame.Angles(1.5707963267948966, 0, 0))

                                                                u671.Velocity = Vector3.new(900000000, 900000000, 900000000)

                                                                task.wait()
                                                                u670(p33, CFrame.new(-MoveDirection.X * WalkSpeed * 0.06, -3, -MoveDirection.Z * WalkSpeed * 0.06), CFrame.Angles(0, 0, 0))

                                                                u671.Velocity = Vector3.new(900000000, 900000000, 900000000)

                                                                task.wait()
                                                            else
                                                                n18 = n18 + 100

                                                                u670(p33, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection * Magnitude / 1.25, CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                                u670(p33, CFrame.new(0, -1.5, 0) + Humanoid2.MoveDirection * Magnitude / 1.25, CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                                u670(p33, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection * Magnitude / 1.25, CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                                u670(p33, CFrame.new(0, -1.5, 0) + Humanoid2.MoveDirection * Magnitude / 1.25, CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                                u670(p33, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                                u670(p33, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(n18), 0, 0))
                                                                task.wait()
                                                            end
                                                            if v904 < tick() then
                                                                return
                                                            end
                                                        end
                                                    end)(v673)
                                                end

                                                BodyVelocity:Destroy()
                                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

                                                u160.CurrentCamera.CameraSubject = Humanoid

                                                if getgenv().RuzOldPos then
                                                    local n19 = 0

                                                    repeat
                                                        n19 = n19 + 1
                                                        RootPart.CFrame = getgenv().RuzOldPos * CFrame.new(0, 0.5, 0)

                                                        local _pcall = pcall
                                                        local u677 = Character

                                                        pcall(function()
                                                            u677:SetPrimaryPartCFrame(getgenv().RuzOldPos * CFrame.new(0, 0.5, 0))
                                                        end)
                                                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

                                                        for _, child in ipairs(Character:GetChildren())do
                                                            if child:IsA('BasePart') then
                                                                child.Velocity = Vector3.new()
                                                                child.RotVelocity = Vector3.new()
                                                            end
                                                        end

                                                        task.wait()
                                                    until n19 > 30 or (RootPart.Position - getgenv().RuzOldPos.p).Magnitude < 25

                                                    u160.FallenPartsDestroyHeight = getgenv().RuzFPDH

                                                    u159:Notify({
                                                        Title = 'CrystalHub',
                                                        Content = tostring('Returned to previous position.'),
                                                        Duration = 3,
                                                        Icon = 'bell',
                                                    })
                                                end

                                                u157 = false

                                                return
                                            end

                                            return
                                        end

                                        local v680 = p29.Name .. ' is sitting, skipped.'

                                        u159:Notify({
                                            Title = 'CrystalHub',
                                            Content = tostring(v680),
                                            Duration = 3,
                                            Icon = 'bell',
                                        })

                                        return
                                    end

                                    return
                                end

                                return
                            end

                            return
                        end

                        return
                    end
                end

                u162 = v18
                u163 = Players
                u164 = LocalPlayer
                u165 = v161
                u166 = v18
                u167 = Players
                u168 = LocalPlayer
                u169 = v161

                local t15 = {
                    GlobalShadows = Lighting.GlobalShadows,
                    Brightness = Lighting.Brightness,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                }
                local t16 = {}

                u172 = nil
                u173 = Lighting
                u174 = t15
                u175 = Workspace

                function u176(p34)
                    if p34:IsA('BasePart') then
                        if not t16[p34] then
                            t16[p34] = {
                                Material = p34.Material,
                                CastShadow = p34.CastShadow,
                            }
                        end

                        p34.Material = Enum.Material.SmoothPlastic
                        p34.CastShadow = false
                    end
                    if p34:IsA('Decal') or p34:IsA('Texture') then
                        if not t16[p34] then
                            t16[p34] = {
                                Transparency = p34.Transparency,
                            }
                        end

                        p34.Transparency = 1
                    end
                end

                u177 = TextLabel
                u178 = v18

                local u179 = Lighting
                local u180 = t15
                local u181 = TextLabel
                local u182 = v18

                function v183()
                    u15 = false

                    pcall(function()
                        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
                    end)

                    u179.GlobalShadows = u180.GlobalShadows
                    u179.Brightness = u180.Brightness
                    u179.Ambient = u180.Ambient
                    u179.OutdoorAmbient = u180.OutdoorAmbient

                    if u172 then
                        u172:Disconnect()

                        u172 = nil
                    end

                    for k, v in pairs(t16)do
                        if k and k.Parent then
                            local _pcall = pcall
                            local u699 = v
                            local u700 = k

                            pcall(function()
                                for k2, v2 in pairs(u699)do
                                    u700[k2] = v2
                                end
                            end)
                        end
                    end

                    t16 = {}
                    u181.Visible = false

                    u182:Notify({
                        Title = 'CrystalHub',
                        Content = tostring('Low Graphics OFF'),
                        Duration = 3,
                        Icon = 'bell',
                    })
                end

                u184 = v183
                u185 = Lighting
                u186 = v18
                u187 = Lighting
                u188 = t15
                u189 = v18
                t17 = {}

                local t18 = {
                    name = 'Neon Cyan',
                    id = '11770890197',
                }
                local t19 = {
                    name = 'Electric Purple',
                    id = '11770691141',
                }
                local t20 = {
                    name = 'Precision Dot',
                    id = '10878218308',
                }
                local t21 = {
                    name = 'Aim Cross',
                    id = '10891594349',
                }
                local t22 = {
                    name = 'Blue Spec',
                    id = '11720475063',
                }
                local t23 = {
                    name = 'Circle Dot',
                    id = '10831379335',
                }
                local t24 = {
                    name = 'Green Hit',
                    id = '8375241602',
                }

                t17[1] = t18
                t17[2] = t19
                t17[3] = t20
                t17[4] = t21
                t17[5] = t22
                t17[6] = t23
                t17[7] = t24
            end

            u198 = false
            u199 = false
            id = t17[1].id
            u201 = nil
            u202 = nil

            local u203 = RunService

            local function v204()
                if u202 then
                    u202:Disconnect()

                    u202 = nil
                end
                if not u199 or not u201 or not u201.Parent then
                    if u201 then
                        u201.Rotation = 0
                    end

                    return
                end

                u202 = u203.RenderStepped:Connect(function()
                    if u201 and u201.Parent and u201.Visible then
                        u201.Rotation = u201.Rotation + 4
                    end
                end)
            end

            u205 = RunService
            u206 = UserInputService
            u207 = LocalPlayer
            u208 = v204
            u209 = v18
            u210 = v204
            u211 = t17
            u212 = v21

            local CrystalHub_BtnLayer = game.CoreGui:FindFirstChild('CrystalHub_BtnLayer')

            if CrystalHub_BtnLayer then
                CrystalHub_BtnLayer:Destroy()
            end

            local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

            ScreenGui.Name = 'CrystalHub_BtnLayer'
            ScreenGui.ResetOnSpawn = false
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.DisplayOrder = 10

            local u215 = ScreenGui

            t25 = {}

            -- Button position persistence
            local _BTN_POS_FILE = "CrystalHub_btnpos.txt"

            -- Simple key=xs,xo,ys,yo per line serializer (no HttpService needed)
            local function _serializePos(tbl)
                local lines = {}
                for name, v in pairs(tbl) do
                    lines[#lines+1] = name.."="..v.xs..","..v.xo..","..v.ys..","..v.yo
                end
                return table.concat(lines, "\n")
            end

            local function _deserializePos(raw)
                local out = {}
                for line in (raw.."\n"):gmatch("([^\n]*)\n") do
                    local name, xs, xo, ys, yo = line:match("^(.-)=([^,]+),([^,]+),([^,]+),([^,]+)$")
                    if name then
                        out[name] = {
                            xs = tonumber(xs) or 0,
                            xo = tonumber(xo) or 0,
                            ys = tonumber(ys) or 0,
                            yo = tonumber(yo) or 0,
                        }
                    end
                end
                return out
            end

            -- Resolve file API (differs between exploits)
            local _writefile = (typeof(writefile) == "function" and writefile)
                            or (syn and syn.write_file)
                            or (typeof(savefile) == "function" and savefile)
                            or nil
            local _readfile  = (typeof(readfile)  == "function" and readfile)
                            or (syn and syn.read_file)
                            or nil
            local _isfile    = (typeof(isfile)    == "function" and isfile)
                            or (syn and syn.is_file)
                            or function(p)
                                if not _readfile then return false end
                                local ok = pcall(_readfile, p)
                                return ok
                            end

            local function _saveBtnPositions()
                if not _writefile then
                    warn("[CrystalHub] writefile not available — positions not saved")
                    return
                end
                local tbl = {}
                for name, entry in pairs(t25) do
                    if entry and entry.btn and entry.btn.Parent then
                        local pos = entry.btn.Position
                        tbl[name] = {
                            xs = pos.X.Scale,
                            xo = math.round(pos.X.Offset),
                            ys = pos.Y.Scale,
                            yo = math.round(pos.Y.Offset),
                        }
                    end
                end
                local ok, err = pcall(_writefile, _BTN_POS_FILE, _serializePos(tbl))
                if ok then
                    print("[CrystalHub] Button positions saved.")
                else
                    warn("[CrystalHub] Failed to save positions: " .. tostring(err))
                end
            end

            local _btnSavedPos = {}
            pcall(function()
                if _readfile and _isfile(_BTN_POS_FILE) then
                    _btnSavedPos = _deserializePos(_readfile(_BTN_POS_FILE))
                    local n = 0
                    for _ in pairs(_btnSavedPos) do n = n + 1 end
                    print("[CrystalHub] Button positions loaded: " .. n .. " entries")
                end
            end)

            local function _loadBtnPos(name, default)
                local s = _btnSavedPos[name]
                if s then
                    print("[CrystalHub] Restoring position for: " .. name)
                    return UDim2.new(s.xs, s.xo, s.ys, s.yo)
                end
                return default
            end

            -- Shared button-position state for creation, dragging and NeverLose config.
            local _buttonConfigPositions = {}

            local u217 = UserInputService

            -- Single global drag-end listener: saves positions on every mouse release
            local _dragActive = false
            u217.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    if _dragActive then
                        _dragActive = false

                        -- Keep the NeverLose flag state in sync immediately after dragging.
                        for name, entry in pairs(t25) do
                            if entry and entry.btn and entry.btn.Parent then
                                local pos = entry.btn.Position
                                _buttonConfigPositions[name] = {
                                    XScale = pos.X.Scale,
                                    XOffset = pos.X.Offset,
                                    YScale = pos.Y.Scale,
                                    YOffset = pos.Y.Offset,
                                }
                            end
                        end

                        task.defer(_saveBtnPositions)
                    end
                end
            end)

            function u218(p35)
                local u740 = nil
                local p36Position = nil
                local Position = nil
                local InputBegan = p35.InputBegan
                local u744 = p35

                InputBegan:Connect(function(p36)
                    if p36.UserInputType == Enum.UserInputType.MouseButton1 or p36.UserInputType == Enum.UserInputType.Touch then
                        u740 = true
                        _dragActive = true
                        p36Position = p36.Position
                        Position = u744.Position
                    end
                end)

                local InputChanged = p35.InputChanged
                local u746 = p35

                InputChanged:Connect(function(p37)
                    if u740 then
                        if p37.UserInputType == Enum.UserInputType.MouseMovement or p37.UserInputType == Enum.UserInputType.Touch then
                            local v923 = p37.Position - p36Position

                            u746.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v923.X, Position.Y.Scale, Position.Y.Offset + v923.Y)
                        end

                        return
                    end
                end)
                u217.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        u740 = false
                    end
                end)
            end

            local u219 = t25

            function v220(p38, p39, p40, p41, p42)
                if u219[p38] then
                    u219[p38].btn:Destroy()

                    u219[p38] = nil
                end

                local TextButton = Instance.new('TextButton', u215)

                TextButton.Name = 'RuzBtn_' .. p38
                TextButton.Size = p40
                local _cfgPos = _buttonConfigPositions[p38]
                if _cfgPos then
                    TextButton.Position = UDim2.new(
                        _cfgPos.XScale,
                        _cfgPos.XOffset,
                        _cfgPos.YScale,
                        _cfgPos.YOffset
                    )
                else
                    TextButton.Position = _loadBtnPos(p38, p39)
                end
                TextButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                TextButton.BackgroundTransparency = 0.08
                TextButton.Text = ''
                TextButton.AutoButtonColor = false
                TextButton.BorderSizePixel = 0
                Instance.new('UICorner', TextButton).CornerRadius = UDim.new(0, p40.Y.Offset * 0.32)

                local UIStroke = Instance.new('UIStroke', TextButton)

                UIStroke.Color = Color3.fromRGB(50, 50, 50)
                UIStroke.Thickness = 1.0
                UIStroke.Transparency = 0.6
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                local TextLabel = Instance.new('TextLabel', TextButton)

                TextLabel.Name = 'Lbl'
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = p42
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.Font = Enum.Font.GothamBlack

                local v755 = p40.Y.Offset * 0.18

                TextLabel.TextSize = math.max(12, v755)
                TextLabel.TextYAlignment = Enum.TextYAlignment.Center
                TextLabel.TextXAlignment = Enum.TextXAlignment.Center

                u218(TextButton)

                u219[p38] = {
                    btn = TextButton,
                    stroke = UIStroke,
                    lbl = TextLabel,
                }

                return u219[p38]
            end

            local u221 = RunService

            function u222(p43, p44)
                local YOffset = p43.btn.Size.Y.Offset
                local v759 = YOffset * 0.55
                local v760 = math.floor(v759)
                local ImageLabel = Instance.new('ImageLabel', p43.btn)

                ImageLabel.Name = 'SpinImg'
                ImageLabel.Size = UDim2.new(0, v760, 0, v760)
                ImageLabel.Position = UDim2.new(0.5, -v760 / 2, 0.5, -v760 / 2)
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.Image = 'rbxassetid://' .. tostring(p44)
                p43.img = ImageLabel
                p43.lbl.Size = UDim2.new(1, 0, 0.28, 0)
                p43.lbl.Position = UDim2.new(0, 0, 0.72, 0)

                local lbl = p43.lbl
                local v763 = YOffset * 0.12

                lbl.TextSize = math.max(9, v763)

                local spawn = task.spawn
                local u765 = ImageLabel

                spawn(function()
                    while u765 and u765.Parent do
                        u765.Rotation = u765.Rotation + 4
                        task.wait(0.03)
                    end
                end)

                return ImageLabel
            end

            uDim2_2 = UDim2.new(0, 110, 0, 110)
            uDim2 = UDim2.new(0, 72, 0, 72)
            t26 = {
                GoldBomb = UDim2.new(0.5, -210, 0.78, 0),
                NormalBomb = UDim2.new(0.5, -110, 0.78, 0),
                Shoot = UDim2.new(0.5, -10, 0.78, 0),
                ESP = UDim2.new(0.5, 90, 0.78, 16),
                Flick = UDim2.new(0.5, 154, 0.78, 16),
                Speed = UDim2.new(0.5, -278, 0.78, 16),
                Stretch = UDim2.new(0.5, -214, 0.78, 16),
                GrabGun = UDim2.new(0.5, 90, 0.68, 16),
                WallHop = UDim2.new(0.5, 154, 0.68, 16),
                FlingMurderer = UDim2.new(0.5, -278, 0.68, 16),
                FlingSheriff = UDim2.new(0.5, -214, 0.68, 16),
            }

            -- Store each button position as a primitive STRING flag.
            -- NeverLose configs serialize primitive values reliably.
            local _buttonPositionFlags = {
                GoldBomb = "crystalhub_pos_GoldBomb",
                NormalBomb = "crystalhub_pos_NormalBomb",
                Shoot = "crystalhub_pos_Shoot",
                ESP = "crystalhub_pos_ESP",
                Flick = "crystalhub_pos_Flick",
                Speed = "crystalhub_pos_Speed",
                Stretch = "crystalhub_pos_Stretch",
                GrabGun = "crystalhub_pos_GrabGun",
                WallHop = "crystalhub_pos_WallHop",
                FlingMurderer = "crystalhub_pos_FlingMurderer",
                FlingSheriff = "crystalhub_pos_FlingSheriff",
            }

            local function _encodeButtonPos(pos)
                if not pos then return "" end
                return tostring(pos.XScale or 0) .. ";" ..
                       tostring(pos.XOffset or 0) .. ";" ..
                       tostring(pos.YScale or 0) .. ";" ..
                       tostring(pos.YOffset or 0)
            end

            local function _decodeButtonPos(value)
                if type(value) ~= "string" then return nil end
                local xs, xo, ys, yo = value:match("^([^;]+);([^;]+);([^;]+);([^;]+)$")
                if not xs then return nil end
                return {
                    XScale = tonumber(xs) or 0,
                    XOffset = tonumber(xo) or 0,
                    YScale = tonumber(ys) or 0,
                    YOffset = tonumber(yo) or 0,
                }
            end

            if _NL and _NL.Flags then
                for name, flagName in pairs(_buttonPositionFlags) do
                    _NL.Flags[flagName] = {
                    GetValue = function()
                        local entry = t25[name]
                        if entry and entry.btn and entry.btn.Parent then
                            local pos = entry.btn.Position
                            return _encodeButtonPos({
                                XScale = pos.X.Scale,
                                XOffset = pos.X.Offset,
                                YScale = pos.Y.Scale,
                                YOffset = pos.Y.Offset,
                            })
                        end

                        return _encodeButtonPos(_buttonConfigPositions[name])
                    end,

                    SetValue = function(value)
                        local saved = _decodeButtonPos(value)
                        if not saved then return end

                        _buttonConfigPositions[name] = saved

                        local entry = t25[name]
                        if entry and entry.btn and entry.btn.Parent then
                            entry.btn.Position = UDim2.new(
                                saved.XScale, saved.XOffset,
                                saved.YScale, saved.YOffset
                            )
                        end
                    end,
                    }
                end
            end

            local u226 = t25
            local u227 = v220
            local u228 = t26
            local u229 = uDim2_2
            local u230 = v18
            local u231 = v115

            function v232(p45)
                if p45 then
                    u227('GoldBomb', u228.GoldBomb, u229, Color3.fromRGB(255, 215, 0), 'GOLD\nJUMP')
                    u226.GoldBomb.btn.MouseButton1Click:Connect(function()
                        if not u9 then
                            u231('GoldBomb', true)

                            return
                        end

                        u230:Notify({
                            Title = 'CrystalHub',
                            Content = tostring('Gold Bomb on cooldown.'),
                            Duration = 3,
                            Icon = 'bell',
                        })
                    end)

                    return
                end
                if u226.GoldBomb then
                    u226.GoldBomb.btn:Destroy()

                    u226.GoldBomb = nil
                end
            end

            local u233 = t25
            local u234 = v220
            local u235 = t26
            local u236 = uDim2_2
            local u237 = v18
            local u238 = v115

            function v239(p46)
                if p46 then
                    u234('NormalBomb', u235.NormalBomb, u236, Color3.fromRGB(0, 170, 255), 'NORMAL\nJUMP')
                    u233.NormalBomb.btn.MouseButton1Click:Connect(function()
                        if not u10 then
                            u238('FakeBomb', false)

                            return
                        end

                        u237:Notify({
                            Title = 'CrystalHub',
                            Content = tostring('Normal Bomb on cooldown.'),
                            Duration = 3,
                            Icon = 'bell',
                        })
                    end)

                    return
                end
                if u233.NormalBomb then
                    u233.NormalBomb.btn:Destroy()

                    u233.NormalBomb = nil
                end
            end
        end

        local u240 = t25
        local u241 = v220
        local u242 = t26
        local u243 = uDim2_2

        function v244(p47)
            if p47 then
                local v769 = u241('Shoot', u242.Shoot, u243, Color3.fromRGB(255, 255, 255), 'SHOOT')

                u222(v769, 5159914132)
                v769.btn.MouseButton1Click:Connect(u98)

                return
            end
            if u240.Shoot then
                u240.Shoot.btn:Destroy()

                u240.Shoot = nil
            end
        end

        local u245 = t25
        local u246 = v220
        local u247 = t26
        local u248 = uDim2
        local u249 = v78
        local u250 = v68
        local u251 = v18

        function u252(p48)
            if p48 then
                u246('ESP', u247.ESP, u248, Color3.fromRGB(10, 140, 30), 'ESP\nOFF')
                u245.ESP.btn.MouseButton1Click:Connect(function()
                    local v926 = not u61

                    u61 = v926

                    if not v926 then
                        if u62 then
                            u62:Disconnect()

                            u62 = nil
                        end

                        task.delay(0.1, u250)
                    else
                        u249()
                    end

                    local v927 = u61 and 'ESP ON' or 'ESP OFF'

                    u251:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v927),
                        Duration = 3,
                        Icon = 'bell',
                    })
                end)

                return
            end
            if u245.ESP then
                u245.ESP.btn:Destroy()

                u245.ESP = nil
            end
        end

        local u253 = t25
        local u254 = v220
        local u255 = t26
        local u256 = uDim2

        function u257(p49)
            if p49 then
                u254('Flick', u255.Flick, u256, Color3.fromRGB(180, 50, 255), 'FLICK')
                u253.Flick.btn.MouseButton1Click:Connect(u104)

                return
            end
            if u253.Flick then
                u253.Flick.btn:Destroy()

                u253.Flick = nil
            end
        end

        local u258 = t25
        local u259 = v220
        local u260 = t26
        local u261 = uDim2
        local u262 = v18

        function u263(p50)
            if p50 then
                u259('Speed', u260.Speed, u261, Color3.fromRGB(0, 140, 120), 'SPEED')
                u258.Speed.btn.MouseButton1Click:Connect(function()
                    u116 = not u116

                    local v928 = u116 and 'Speed Glitch ON' or 'Speed Glitch OFF'

                    u262:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v928),
                        Duration = 3,
                        Icon = 'bell',
                    })
                end)

                return
            end
            if u258.Speed then
                u258.Speed.btn:Destroy()

                u258.Speed = nil
            end
        end

        local u264 = t25
        local u265 = v220
        local u266 = t26
        local u267 = uDim2
        local u268 = v125
        local u269 = v18

        function u270(p51)
            if p51 then
                u265('Stretch', u266.Stretch, u267, Color3.fromRGB(200, 80, 0), 'STRETCH')
                u264.Stretch.btn.MouseButton1Click:Connect(function()
                    u120 = not u120

                    u268(u120)

                    local v929 = u120 and 'Stretch ON' or 'Stretch OFF'

                    u269:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v929),
                        Duration = 3,
                        Icon = 'bell',
                    })
                end)

                return
            end
            if u264.Stretch then
                u264.Stretch.btn:Destroy()

                u264.Stretch = nil
            end
        end
    end

    local u271 = t25
    local u272 = v220
    local u273 = t26
    local u274 = uDim2

    local function u275()
        local GunDrop = u129:FindFirstChild('GunDrop', true)

        if GunDrop then
            local Character = u131.Character
            local v611 = Character and Character:FindFirstChild('HumanoidRootPart')

            if v611 then
                local v613

                if not GunDrop:IsA('BasePart') then
                    local v612 = GunDrop:FindFirstChild('Handle') or (GunDrop:FindFirstChildWhichIsA('BasePart') or GunDrop.PrimaryPart)

                    v613 = v612 and v612.Position or GunDrop:GetModelCFrame().Position
                else
                    v613 = GunDrop.Position
                end
                if v613 then
                    local CFrame5 = v611.CFrame

                    v611.CFrame = CFrame.new(v613 + Vector3.new(0, 2, 0))

                    task.wait(0.2)

                    v611.CFrame = CFrame5

                    u130:Notify({
                        Title = 'CrystalHub',
                        Content = tostring('Teleported to gun!'),
                        Duration = 3,
                        Icon = 'bell',
                    })

                    return
                end

                u130:Notify({
                    Title = 'CrystalHub',
                    Content = tostring('Gun position not found!'),
                    Duration = 3,
                    Icon = 'bell',
                })

                return
            end

            return
        end

        u130:Notify({
            Title = 'CrystalHub',
            Content = tostring('No gun on map!'),
            Duration = 3,
            Icon = 'bell',
        })
    end

    function u276(p52)
        if p52 then
            u272('GrabGun', u273.GrabGun, u274, Color3.fromRGB(200, 120, 0), 'GRAB\nGUN')
            u271.GrabGun.btn.MouseButton1Click:Connect(u275)

            return
        end
        if u271.GrabGun then
            u271.GrabGun.btn:Destroy()

            u271.GrabGun = nil
        end
    end

    local u277 = t25
    local u278 = v220
    local u279 = t26
    local u280 = uDim2

    function u281(p53)
        if p53 then
            u278('WallHop', u279.WallHop, u280, Color3.fromRGB(0, 210, 210), 'WALL\nHOP')
            u277.WallHop.btn.MouseButton1Click:Connect(u110)

            return
        end
        if u277.WallHop then
            u277.WallHop.btn:Destroy()

            u277.WallHop = nil
        end
    end

    local u282 = t25
    local u283 = v220
    local u284 = t26
    local u285 = uDim2

    local function u286()
        if not u157 then
            for _, player in ipairs(u163:GetPlayers())do
                if player ~= u164 and player.Character and (player.Backpack:FindFirstChild('Knife') or player.Character and player.Character:FindFirstChild('Knife')) then
                    local Humanoid = player.Character:FindFirstChildOfClass('Humanoid')

                    if Humanoid and Humanoid.Health > 0 then
                        local v684 = 'Flinging: ' .. player.Name

                        u162:Notify({
                            Title = 'CrystalHub',
                            Content = tostring(v684),
                            Duration = 3,
                            Icon = 'bell',
                        })
                        task.spawn(u165, player)

                        return
                    end
                end
            end

            u162:Notify({
                Title = 'CrystalHub',
                Content = tostring('No knife player found!'),
                Duration = 3,
                Icon = 'bell',
            })

            return
        end

        u162:Notify({
            Title = 'CrystalHub',
            Content = tostring('Fling in progress...'),
            Duration = 3,
            Icon = 'bell',
        })
    end

    function u287(p54)
        if p54 then
            u283('FlingMurderer', u284.FlingMurderer, u285, Color3.fromRGB(255, 50, 50), 'FLING\nMURD')
            u282.FlingMurderer.btn.MouseButton1Click:Connect(u286)

            return
        end
        if u282.FlingMurderer then
            u282.FlingMurderer.btn:Destroy()

            u282.FlingMurderer = nil
        end
    end

    local u288 = t25
    local u289 = v220
    local u290 = t26
    local u291 = uDim2

    local function u292()
        if not u157 then
            for _, player in ipairs(u167:GetPlayers())do
                if player ~= u168 and player.Character and (player.Backpack:FindFirstChild('Gun') or player.Character and player.Character:FindFirstChild('Gun')) then
                    local Humanoid = player.Character:FindFirstChildOfClass('Humanoid')

                    if Humanoid and Humanoid.Health > 0 then
                        local v688 = 'Flinging: ' .. player.Name

                        u166:Notify({
                            Title = 'CrystalHub',
                            Content = tostring(v688),
                            Duration = 3,
                            Icon = 'bell',
                        })
                        task.spawn(u169, player)

                        return
                    end
                end
            end

            u166:Notify({
                Title = 'CrystalHub',
                Content = tostring('No gun player found!'),
                Duration = 3,
                Icon = 'bell',
            })

            return
        end

        u166:Notify({
            Title = 'CrystalHub',
            Content = tostring('Fling in progress...'),
            Duration = 3,
            Icon = 'bell',
        })
    end

    function u293(p55)
        if p55 then
            u289('FlingSheriff', u290.FlingSheriff, u291, Color3.fromRGB(40, 130, 255), 'FLING\nSHERIF')
            u288.FlingSheriff.btn.MouseButton1Click:Connect(u292)

            return
        end
        if u288.FlingSheriff then
            u288.FlingSheriff.btn:Destroy()

            u288.FlingSheriff = nil
        end
    end

    local Heartbeat = RunService.Heartbeat
    local u295 = t25
    local u296 = LocalPlayer
    local u297 = UserInputService
    local u298 = Workspace
    local u299 = Players

    -- Throttle UI обновления: не чаще 15 раз в секунду (экономит CPU)
    local _uiLastTick = 0
    -- Кеш предыдущих значений для пропуска лишних записей в свойства
    local _uiCache = {}

    local function _setLbl(key, lbl, text)
        if _uiCache[key..'_t'] ~= text then
            lbl.Text = text
            _uiCache[key..'_t'] = text
        end
    end
    local function _setColor(key, lbl, stroke, color)
        if _uiCache[key..'_c'] ~= color then
            lbl.TextColor3 = color
            stroke.Color = color
            _uiCache[key..'_c'] = color
        end
    end

    Heartbeat:Connect(function()
        local _now = tick()
        if _now - _uiLastTick < 0.066 then return end -- ~15 FPS для UI
        _uiLastTick = _now

        if u295.GoldBomb then
            _setLbl('gb', u295.GoldBomb.lbl, u9 and 'WAIT...' or 'GOLD\nJUMP')
        end
        if u295.NormalBomb then
            _setLbl('nb', u295.NormalBomb.lbl, u10 and 'WAIT...' or 'NORMAL\nJUMP')
        end
        if u295.Shoot and u295.Shoot.img then
            local v779 = u296.Backpack:FindFirstChild('Knife') or u296.Character and u296.Character:FindFirstChild('Knife')
            local _shootImg = v779 and 'rbxassetid://9695655416' or 'rbxassetid://5159914132'
            if _uiCache['sh_img'] ~= _shootImg then
                u295.Shoot.img.Image = _shootImg
                _uiCache['sh_img'] = _shootImg
            end
            _setLbl('sh', u295.Shoot.lbl, v779 and 'THROW' or 'SHOOT')
        end
        if u295.ESP then
            local v780 = u61 and Color3.fromRGB(50, 220, 80) or Color3.fromRGB(10, 140, 30)
            _setLbl('esp', u295.ESP.lbl, u61 and 'ESP\nON' or 'ESP\nOFF')
            _setColor('esp', u295.ESP.lbl, u295.ESP.stroke, v780)
        end
        if u295.Flick then
            local v781 = u297.MouseBehavior == Enum.MouseBehavior.LockCenter
            local v782 = u99 and Color3.fromRGB(255, 120, 0) or (v781 and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(180, 50, 255))
            _setLbl('fl', u295.Flick.lbl, u99 and 'WAIT...' or 'FLICK')
            _setColor('fl', u295.Flick.lbl, u295.Flick.stroke, v782)
        end
        if u295.WallHop then
            local v783 = u297.MouseBehavior == Enum.MouseBehavior.LockCenter
            local v784 = u105 and Color3.fromRGB(255, 120, 0) or (v783 and Color3.fromRGB(0, 255, 220) or Color3.fromRGB(0, 210, 210))
            _setLbl('wh', u295.WallHop.lbl, u105 and 'WAIT...' or 'WALL\nHOP')
            _setColor('wh', u295.WallHop.lbl, u295.WallHop.stroke, v784)
        end
        if u295.Speed then
            local v785 = u116 and Color3.fromRGB(0, 220, 200) or Color3.fromRGB(0, 140, 120)
            _setLbl('sp', u295.Speed.lbl, u116 and 'SPEED\nON' or 'SPEED')
            _setColor('sp', u295.Speed.lbl, u295.Speed.stroke, v785)
        end
        if u295.Stretch then
            local v786 = u120 and Color3.fromRGB(255, 140, 30) or Color3.fromRGB(200, 80, 0)
            _setLbl('st', u295.Stretch.lbl, u120 and 'STRETCH\nON' or 'STRETCH')
            _setColor('st', u295.Stretch.lbl, u295.Stretch.stroke, v786)
        end
        if u295.GrabGun then
            local GunDrop = u298:FindFirstChild('GunDrop', true)
            local v788 = GunDrop and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 100, 0)
            _setLbl('gg', u295.GrabGun.lbl, GunDrop and 'GRAB\nGUN' or 'NO\nGUN')
            _setColor('gg', u295.GrabGun.lbl, u295.GrabGun.stroke, v788)
        end
        if u295.FlingMurderer then
            local v789 = false
            for _, player in ipairs(u299:GetPlayers())do
                if player ~= u296 and (player.Backpack:FindFirstChild('Knife') or player.Character and player.Character:FindFirstChild('Knife')) then
                    v789 = true
                    break
                end
            end
            local v792 = u157 and Color3.fromRGB(255, 180, 0) or (v789 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(200, 20, 20))
            _setLbl('fm', u295.FlingMurderer.lbl, u157 and 'FLING...' or (v789 and 'FLING\nMURD' or 'NO\nMURD'))
            _setColor('fm', u295.FlingMurderer.lbl, u295.FlingMurderer.stroke, v792)
        end
        if u295.FlingSheriff then
            local v793 = false
            for _, player in ipairs(u299:GetPlayers())do
                if player ~= u296 and (player.Backpack:FindFirstChild('Gun') or player.Character and player.Character:FindFirstChild('Gun')) then
                    v793 = true
                    break
                end
            end
            local v796 = u157 and Color3.fromRGB(255, 180, 0) or (v793 and Color3.fromRGB(40, 130, 255) or Color3.fromRGB(10, 80, 200))
            _setLbl('fs', u295.FlingSheriff.lbl, u157 and 'FLING...' or (v793 and 'FLING\nSHERIF' or 'NO\nSHERIF'))
            _setColor('fs', u295.FlingSheriff.lbl, u295.FlingSheriff.stroke, v796)
        end
    end)
    v18:Notify({
        Title = 'CrystalHub Mmv And Mm2',
        Content = 'v7.3 loaded!\\nBombs and Shoot auto-loaded.\\nOpen menu to configure everything.',
        Duration = 5,
    })


    local v300 = v18:CreateWindow({
        Title = 'CrystalHub',
        Author = 'Mmv And Mm2',
        Folder = 'CrystalHub',
        Size = UDim2.fromOffset(700, 550),
    }):Section({
        Title = 'CrystalHub',
        Opened = true,
    })

    -- Top watermark/overlay (tap it to open/close the GUI).
    do
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Stats = game:GetService("Stats")
        local LocalPlayer = Players.LocalPlayer

        local guiParent
        pcall(function()
            if typeof(gethui) == "function" then
                guiParent = gethui()
            end
        end)
        if not guiParent then
            guiParent = game:GetService("CoreGui")
        end

        local oldOverlay = guiParent:FindFirstChild("CrystalHubOpenButton")
        if oldOverlay then
            oldOverlay:Destroy()
        end

        local overlayGui = Instance.new("ScreenGui")
        overlayGui.Name = "CrystalHubOpenButton"
        overlayGui.ResetOnSpawn = false
        overlayGui.IgnoreGuiInset = true
        overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        overlayGui.DisplayOrder = 999999
        overlayGui.Parent = guiParent

        -- The same style as the reference: one slim dark bar across the top.
        local overlay = Instance.new("TextButton")
        overlay.Name = "CrystalHubOverlay"
        overlay.Size = UDim2.new(0, 530, 0, 42)
        overlay.Position = UDim2.new(1, -10, 0, 7)
        overlay.AnchorPoint = Vector2.new(1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        overlay.BackgroundTransparency = 0.16
        overlay.BorderSizePixel = 0
        overlay.AutoButtonColor = false
        overlay.Text = ""
        overlay.Parent = overlayGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = overlay

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(70, 70, 80)
        stroke.Transparency = 0.45
        stroke.Parent = overlay

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 7)
        padding.PaddingRight = UDim.new(0, 7)
        padding.Parent = overlay

        local list = Instance.new("UIListLayout")
        list.FillDirection = Enum.FillDirection.Horizontal
        list.VerticalAlignment = Enum.VerticalAlignment.Center
        list.HorizontalAlignment = Enum.HorizontalAlignment.Left
        list.Padding = UDim.new(0, 3)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = overlay

        local function makeLabel(name, text, order, width, bold)
            local label = Instance.new("TextLabel")
            label.Name = name
            label.LayoutOrder = order
            label.Size = UDim2.new(0, width, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
            label.Text = text
            label.TextSize = 11
            label.TextColor3 = Color3.fromRGB(215, 215, 225)
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.Parent = overlay
            return label
        end

        local logo = makeLabel("Logo", "▣", 1, 18, true)
        logo.TextColor3 = Color3.fromRGB(120, 140, 255)

        local fpsLabel = makeLabel("FPS", "-- FPS", 2, 50, true)
        local pingLabel = makeLabel("Ping", "-- MS", 3, 52, true)
        local memoryLabel = makeLabel("Memory", "-- MB", 4, 60, false)
        local playerLabel = makeLabel("Player", LocalPlayer and LocalPlayer.Name or "Player", 5, 85, true)
        local profileLabel = makeLabel("Profile", "● Default", 6, 70, false)
        local infoLabel = makeLabel("Info", "CrystalHub", 7, 70, true)
        local timeLabel = makeLabel("Time", "--:--", 8, 45, false)
        local menuLabel = makeLabel("Menu", "≡", 9, 24, true)
        menuLabel.TextSize = 17

        -- Keep the information compact on small/mobile screens.
        local function updateScale()
            local camera = workspace.CurrentCamera
            if not camera then return end
            local width = camera.ViewportSize.X
            local size = width < 600 and 10 or 11
            for _, child in ipairs(overlay:GetChildren()) do
                if child:IsA("TextLabel") then
                    child.TextSize = (child == menuLabel and size + 7 or size)
                end
            end
        end
        updateScale()
        pcall(function()
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
        end)

        local frames = 0
        local lastFpsUpdate = os.clock()
        local fps = 0

        local function getPing()
            local value = nil
            pcall(function()
                local network = Stats:FindFirstChild("Network")
                local serverStats = network and network:FindFirstChild("ServerStatsItem")
                local item = serverStats and serverStats:FindFirstChild("Data Ping")
                if item then
                    value = item:GetValue()
                end
            end)
            return value
        end

        local updateConnection
        updateConnection = RunService.RenderStepped:Connect(function()
            frames += 1
            local now = os.clock()
            local elapsed = now - lastFpsUpdate
            if elapsed >= 0.5 then
                fps = math.floor(frames / elapsed + 0.5)
                frames = 0
                lastFpsUpdate = now

                fpsLabel.Text = string.format("%d FPS", fps)

                local ping = getPing()
                if ping then
                    pingLabel.Text = string.format("%d MS", math.floor(ping + 0.5))
                else
                    pingLabel.Text = "-- MS"
                end

                local memory = 0
                pcall(function()
                    memory = Stats:GetTotalMemoryUsageMb()
                end)
                memoryLabel.Text = string.format("%d MB", math.floor(memory + 0.5))

                timeLabel.Text = os.date("%H:%M")
            end
        end)

        overlay.Activated:Connect(function()
            pcall(function()
                v300:ToggleInterface()
            end)
        end)

        overlay.MouseButton1Down:Connect(function()
            overlay.BackgroundTransparency = 0.04
        end)
        overlay.MouseButton1Up:Connect(function()
            overlay.BackgroundTransparency = 0.16
        end)

        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                overlay.BackgroundTransparency = 0.04
            end
        end)
        overlay.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                overlay.BackgroundTransparency = 0.16
            end
        end)

        overlay.Destroying:Connect(function()
            if updateConnection then
                updateConnection:Disconnect()
            end
        end)
    end

    v301 = v300:Tab({
        Title = 'Main',
        Icon = 'grid',
    })
    v302 = v300:Tab({
        Title = 'ESP',
        Icon = 'eye',
    })

    v303 = v300:Tab({
        Title = 'Fling/Teleport',
        Icon = 'person-teleport',
    })

    local v304 = v300:Tab({
        Title = 'Rage',
        Icon = 'sword',
    })


    -- CrystalHub AutoFarm
    do
        local AFPlayers = game:GetService("Players")
        local AFRunService = game:GetService("RunService")
        local AFTweenService = game:GetService("TweenService")
        local AFLocalPlayer = AFPlayers.LocalPlayer

        local AFSettings = {
            AutoFarmEnabled = false,
            FarmMode = "Underground",
            TweenSpeed = 25,
            AutoReset = true,
            AvoidMurder = false,
            AntiAfkEnabled = false,
            AntiAfkInterval = 120,
            UndergroundOffset = 4,
            MaxDistance = 600,
            CoinLimit = 40,
        }

        local AFState = {
            isFarming = false,
            isActivelyFlying = false,
            currentTargetCoin = nil,
            ignoredCoins = {},
            currentTween = nil,
            antiAfkRunning = false,
        }

        -- Anti-AFK: keeps the player from being kicked for idling.
        local AFVirtualUser = game:GetService("VirtualUser")

        AFLocalPlayer.Idled:Connect(function()
            if not AFSettings.AntiAfkEnabled then return end
            pcall(function()
                AFVirtualUser:CaptureController()
                AFVirtualUser:ClickButton2(Vector2.new())
            end)
        end)

        local function afStartAntiAfk()
            if AFState.antiAfkRunning then return end
            AFState.antiAfkRunning = true

            task.spawn(function()
                while AFSettings.AntiAfkEnabled do
                    local waitTime = AFSettings.AntiAfkInterval + math.random(0, 30)
                    task.wait(waitTime)
                    if not AFSettings.AntiAfkEnabled then break end

                    local character = AFLocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function()
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end)
                    end
                end

                AFState.antiAfkRunning = false
            end)
        end

        local function afGetTorso(char)
            if not char then return nil end
            return char:FindFirstChild("Torso")
                or char:FindFirstChild("LowerTorso")
                or char:FindFirstChild("HumanoidRootPart")
        end

        local function afGetCurrentCoins()
            local ok, result = pcall(function()
                local gui = AFLocalPlayer.PlayerGui:FindFirstChild("MainGUI")
                local gameGui = gui and gui:FindFirstChild("Game")
                local coinBags = gameGui and gameGui:FindFirstChild("CoinBags")
                local container = coinBags and coinBags:FindFirstChild("Container")
                local coin = container and container:FindFirstChild("Coin")
                local currencyFrame = coin and coin:FindFirstChild("CurrencyFrame")
                local icon = currencyFrame and currencyFrame:FindFirstChild("Icon")
                local coinsText = icon and icon:FindFirstChild("Coins")
                return coinsText and coinsText.Text or 0
            end)
            return ok and (tonumber(result) or 0) or 0
        end

        local function afIsRoundOver()
            local pGui = AFLocalPlayer:FindFirstChild("PlayerGui")
            local victoryGui = pGui and pGui:FindFirstChild("Victory")
            if victoryGui then
                for _, child in ipairs(victoryGui:GetChildren()) do
                    if child:IsA("GuiObject") and child.Visible then
                        return true
                    end
                end
            end
            return false
        end

        local function afIsBagFull()
            local pGui = AFLocalPlayer:FindFirstChild("PlayerGui")
            local mainGui = pGui and pGui:FindFirstChild("MainGUI")
            local lobby = mainGui and mainGui:FindFirstChild("Lobby")
            local dock = lobby and lobby:FindFirstChild("Dock")
            local coinBags = dock and dock:FindFirstChild("CoinBags")
            local notification = coinBags and coinBags:FindFirstChild("FullBagNotification")
            return notification and notification.Visible == true or false
        end

        local function afHasNearbyMurderer()
            if not AFSettings.AvoidMurder then return false end

            local char = AFLocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end

            for _, player in ipairs(AFPlayers:GetPlayers()) do
                if player ~= AFLocalPlayer and player.Character then
                    local otherHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    local backpack = player:FindFirstChild("Backpack")
                    if otherHRP and (otherHRP.Position - hrp.Position).Magnitude <= 10 then
                        if player.Character:FindFirstChild("Knife")
                            or (backpack and backpack:FindFirstChild("Knife")) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function afGetNearestCoin(torso)
            local container
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "CoinContainer" then
                    container = obj
                    break
                end
            end
            if not container then return nil end

            local nearestCoin
            local minDist = math.huge

            for _, coin in ipairs(container:GetChildren()) do
                if coin.Name == "Coin_Server"
                    and coin:IsA("BasePart")
                    and not AFState.ignoredCoins[coin] then

                    local dist = (torso.Position - coin.Position).Magnitude
                    if dist < minDist and dist <= AFSettings.MaxDistance then
                        minDist = dist
                        nearestCoin = coin
                    end
                end
            end

            return nearestCoin
        end

        local function afApplyFlightPhysics(char)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return CFrame.identity end

            local bv = hrp:FindFirstChild("CrystalHubFarmBV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "CrystalHubFarmBV"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end

            local bg = hrp:FindFirstChild("CrystalHubFarmBG")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "CrystalHubFarmBG"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 50000
                bg.Parent = hrp

                local _, rotY, _ = hrp.CFrame:ToOrientation()
                bg.CFrame =
                    CFrame.new(hrp.Position)
                    * CFrame.Angles(0, rotY, 0)
                    * CFrame.Angles(math.rad(-90), 0, 0)
            end

            return bg.CFrame.Rotation
        end

        local function afRemovePhysics()
            local char = AFLocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("CrystalHubFarmBV")
                local bg = hrp:FindFirstChild("CrystalHubFarmBG")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                hrp.Anchored = false
            end
        end

        local function afSetupNoclip()
            local char = AFLocalPlayer.Character
            if not char then return end

            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid.PlatformStand = true end

            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        local function afFlyToPoint(targetPos, targetCoin, hrp, torso, lockedRotation)
            local dist = (torso.Position - targetPos).Magnitude
            local duration = math.max(dist / math.max(AFSettings.TweenSpeed, 1), 0.05)
            local tween = AFTweenService:Create(
                hrp,
                TweenInfo.new(duration, Enum.EasingStyle.Linear),
                {CFrame = CFrame.new(targetPos) * lockedRotation}
            )

            AFState.currentTween = tween
            local reached = false
            local connection

            tween:Play()

            connection = AFRunService.Heartbeat:Connect(function()
                if not AFState.isFarming
                    or not targetCoin
                    or not targetCoin:IsDescendantOf(workspace) then
                    pcall(function() tween:Cancel() end)
                    connection:Disconnect()
                    return
                end

                if firetouchinterest then
                    pcall(function()
                        firetouchinterest(torso, targetCoin, 0)
                        firetouchinterest(torso, targetCoin, 1)
                    end)
                end

                if (torso.Position - targetPos).Magnitude <= 1.5 then
                    reached = true
                    pcall(function() tween:Cancel() end)
                    connection:Disconnect()
                end
            end)

            while connection.Connected and AFState.isFarming do
                AFRunService.Heartbeat:Wait()
            end

            return reached
        end

        local function afTweenToCoin(coin)
            if not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then
                return false
            end

            local char = AFLocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return false end

            local target = coin.Position + Vector3.new(0, 2, 0)
            if (hrp.Position - target).Magnitude < 5 then
                return true
            end

            if AFState.currentTween then
                pcall(function() AFState.currentTween:Cancel() end)
            end

            local duration = math.max(
                (hrp.Position - target).Magnitude / math.max(AFSettings.TweenSpeed, 1),
                0.05
            )

            AFState.currentTween = AFTweenService:Create(
                hrp,
                TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {CFrame = CFrame.new(target)}
            )

            hum.Sit = true
            AFState.currentTween:Play()

            local done = false
            local connection
            connection = AFState.currentTween.Completed:Connect(function()
                done = true
                connection:Disconnect()
            end)

            local started = os.clock()
            while not done and AFState.isFarming do
                task.wait(0.1)

                if not coin.Parent or not coin:FindFirstChild("TouchInterest") then
                    pcall(function() AFState.currentTween:Cancel() end)
                    hum.Sit = false
                    return false
                end

                if os.clock() - started > 30 then
                    pcall(function() AFState.currentTween:Cancel() end)
                    hum.Sit = false
                    return false
                end
            end

            hum.Sit = false
            return done
        end

        local function afCollectCoin(coin)
            local char = AFLocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not coin or not coin.Parent then return end

            if firetouchinterest then
                pcall(function()
                    firetouchinterest(hrp, coin, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, coin, 1)
                end)
            end
        end

        local function afStopFarming()
            AFState.isFarming = false
            AFState.isActivelyFlying = false
            AFState.currentTargetCoin = nil

            if AFState.currentTween then
                pcall(function() AFState.currentTween:Cancel() end)
                AFState.currentTween = nil
            end

            afRemovePhysics()

            local char = AFLocalPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end
        end

        local function afStartFarming()
            if AFState.isFarming then return end

            AFState.isFarming = true
            table.clear(AFState.ignoredCoins)

            task.spawn(function()
                while AFState.isFarming do
                    task.wait()

                    local success = pcall(function()
                        if afHasNearbyMurderer() then
                            AFState.isActivelyFlying = false
                            AFState.currentTargetCoin = nil
                            afRemovePhysics()

                            local char = AFLocalPlayer.Character
                            local hum = char and char:FindFirstChild("Humanoid")
                            if hum then hum.Sit = false end

                            task.wait(1)
                            return
                        end

                        local char = AFLocalPlayer.Character
                        if not char then return end

                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local torso = afGetTorso(char)
                        local humanoid = char:FindFirstChild("Humanoid")

                        if not hrp or not torso or not humanoid or humanoid.Health <= 0 then
                            AFState.isActivelyFlying = false
                            AFState.currentTargetCoin = nil
                            afRemovePhysics()
                            task.wait(1)
                            return
                        end

                        if afIsRoundOver() or afIsBagFull() then
                            AFState.isActivelyFlying = false
                            AFState.currentTargetCoin = nil
                            afRemovePhysics()
                            humanoid.Sit = false
                            task.wait(1)
                            return
                        end

                        if AFSettings.AutoReset and afGetCurrentCoins() >= AFSettings.CoinLimit then
                            humanoid.Health = 0
                            task.wait(5)
                            return
                        end

                        local targetCoin = afGetNearestCoin(torso)
                        if not targetCoin or not targetCoin:IsDescendantOf(workspace) then
                            AFState.isActivelyFlying = false
                            AFState.currentTargetCoin = nil
                            afRemovePhysics()
                            humanoid.Sit = false
                            task.wait(0.5)
                            return
                        end

                        AFState.isActivelyFlying = true
                        AFState.currentTargetCoin = targetCoin

                        local reachedTarget = false

                        if AFSettings.FarmMode == "Underground" then
                            afSetupNoclip()
                            local lockedRotation = afApplyFlightPhysics(char)
                            local targetPos =
                                targetCoin.Position
                                - Vector3.new(0, AFSettings.UndergroundOffset, 0)

                            reachedTarget = afFlyToPoint(
                                targetPos,
                                targetCoin,
                                hrp,
                                torso,
                                lockedRotation
                            )
                        else
                            reachedTarget = afTweenToCoin(targetCoin)
                            if reachedTarget and AFState.isFarming and humanoid.Health > 0 then
                                afCollectCoin(targetCoin)
                            end
                        end

                        if reachedTarget and AFState.isFarming and humanoid.Health > 0 then
                            AFState.ignoredCoins[targetCoin] = true
                            task.delay(5, function()
                                AFState.ignoredCoins[targetCoin] = nil
                            end)
                            task.wait(0.2)
                        end

                        AFState.currentTargetCoin = nil
                    end)

                    if not success then
                        AFState.isActivelyFlying = false
                        AFState.currentTargetCoin = nil
                        afRemovePhysics()
                        task.wait(1)
                    end
                end
            end)
        end

        AFRunService.Stepped:Connect(function()
            if not AFState.isFarming
                or not AFState.isActivelyFlying
                or AFSettings.FarmMode ~= "Underground" then
                return
            end

            local char = AFLocalPlayer.Character
            if not char then return end

            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then humanoid.PlatformStand = true end

            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        local AutoFarmTab = v300:Tab({
            Title = "AutoFarm",
            Icon = 'two-arrows-loop-clockwise',
        })

        AutoFarmTab:Paragraph({
            Title = "AutoFarm",
        })

        AutoFarmTab:Toggle({
            Flag = "anti_afk",Title = "Anti AFK",
            Default = AFSettings.AntiAfkEnabled,
            Callback = function(value)
                AFSettings.AntiAfkEnabled = value
                if value then
                    afStartAntiAfk()
                end
            end,
        })

        AutoFarmTab:Toggle({
            Flag = "auto_farm",Title = "Auto Farm",
            Default = AFSettings.AutoFarmEnabled,
            Callback = function(value)
                AFSettings.AutoFarmEnabled = value

                if value then
                    afStartFarming()
                    v18:Notify({
                        Title = "CrystalHub",
                        Content = "AutoFarm ON",
                        Duration = 3,
                        Icon = "check",
                    })
                else
                    afStopFarming()
                    v18:Notify({
                        Title = "CrystalHub",
                        Content = "AutoFarm OFF",
                        Duration = 3,
                        Icon = "x",
                    })
                end
            end,
        })

        -- WindUI uses Values/Value for Dropdowns.
        AutoFarmTab:Dropdown({
            Flag = "farm_mode",Title = "Farm Mode",
            Values = {"Underground", "Sit"},
            Value = AFSettings.FarmMode,
            Callback = function(value)
                if value == "Underground" or value == "Sit" then
                    AFSettings.FarmMode = value
                end
            end,
        })

        -- Use WindUI's supported Slider format.
        AutoFarmTab:Slider({
            Flag = "tween_speed",Title = "Tween Speed",
            Step = 1,
            IsTooltip = true,
            IsTextbox = true,
            Value = {
                Min = 10,
                Max = 100,
                Default = AFSettings.TweenSpeed,
            },
            Callback = function(value)
                value = tonumber(value)
                if value then
                    AFSettings.TweenSpeed = math.clamp(math.floor(value), 10, 100)
                end
            end,
        })

        AutoFarmTab:Toggle({
            Flag = "auto_reset",Title = "Auto Reset",
            Default = AFSettings.AutoReset,
            Callback = function(value)
                AFSettings.AutoReset = value
            end,
        })

        AutoFarmTab:Toggle({
            Flag = "avoid_murder",Title = "Avoid Murder",
            Default = AFSettings.AvoidMurder,
            Callback = function(value)
                AFSettings.AvoidMurder = value
            end,
        })

        -- Coin limit is intentionally a 40/50 selector instead of a slider.
        AutoFarmTab:Dropdown({
            Flag = "coin_limit",Title = "Coin Limit",
            Values = {"40", "50"},
            Value = tostring(AFSettings.CoinLimit),
            Callback = function(value)
                local limit = tonumber(value)
                if limit == 40 or limit == 50 then
                    AFSettings.CoinLimit = limit
                end
            end,
        })

        -- Anti-AFK запускается только вручную через Toggle
    end

    -- ═══════════════════════════════════════════
    -- RAGE TAB: VELOCITY SPOOF
    -- ═══════════════════════════════════════════
    do
        -- ── Velocity Spoof (дословно из оригинала) ───────────────────
        local _vs_run_service  = game:GetService("RunService")
        local _vs_players      = game:GetService("Players")
        local _vs_lp           = _vs_players.LocalPlayer

        local _vs_render_stepped      = _vs_run_service.RenderStepped
        local _vs_render_stepped_wait = _vs_render_stepped.Wait
        local _vs_vector3_new         = Vector3.new
        local _vs_vector3_zero        = Vector3.zero
        local _vs_math_random         = math.random
        local _vs_clock               = os.clock

        local _vs_anti_aim    = {}
        local _vs_local_fps   = 200
        local _vs_local_parts = {}
        local _vs_stomping    = false
        local _vs_purchasing  = false

        local _vs_fake_position_sender_rate_old
        pcall(function()
            _vs_fake_position_sender_rate_old = getfflag("S2PhysicsSenderRate")
        end)

        local function _vs_round(num, decimals)
            local mult = 10^(decimals or 0)
            return math.floor(num * mult + 0.5 - (num < 0 and 1 or 0)) / mult
        end

        local function _vs_remove(tbl, index)
            local length = #tbl
            for i = index, length - 1 do
                tbl[i] = tbl[i + 1]
            end
            tbl[length] = nil
        end

        local function LPH_ATTRIBUTES() end
        local function VM() end
        local NONE = nil

        -- ── Пресет и флаг ─────────────────────────────────────────────
        local _vs_velocity_desync_type   = "low"
        local _vs_velocity_desync_rotate = false

        local _vs_do_velocity_desync = function(dt, hrp)
            LPH_ATTRIBUTES(VM(NONE))
            if hrp and not _vs_stomping and not _vs_purchasing
                and (getgenv().FLING_ACTIVE or 0) == 0 then

                pcall(function()
                    setfflag("S2PhysicsSenderRate", tostring(_vs_round(_vs_local_fps, 1)))
                end)
                pcall(function()
                    sethiddenproperty(hrp, "NetworkIsSleeping", false)
                end)

                local old_lin = hrp.AssemblyLinearVelocity
                local old_ang = hrp.AssemblyAngularVelocity

                local vel = _vs_velocity_desync_type == "y high" and _vs_vector3_new(0, 16384, 0)
                    or _vs_velocity_desync_type == "limit" and _vs_vector3_new(
                        _vs_math_random(-9223372036854775808, 9223372036854775807),
                        _vs_math_random(-9223372036854775808, 9223372036854775807),
                        _vs_math_random(-9223372036854775808, 9223372036854775807)
                    )
                    or _vs_velocity_desync_type == "low" and _vs_vector3_new(
                        _vs_math_random(1,2) == 1 and -300 or 300,
                        _vs_math_random(1,2) == 1 and -300 or 300,
                        _vs_math_random(1,2) == 1 and -300 or 300
                    )
                    or _vs_velocity_desync_type == "high" and _vs_vector3_new(
                        _vs_math_random(1,2) == 1 and -16384 or 16384,
                        _vs_math_random(1,2) == 1 and -14384 or 16384,
                        _vs_math_random(1,2) == 1 and -16384 or 16384
                    )
                    or _vs_velocity_desync_type == "zero" and _vs_vector3_zero
                    or _vs_vector3_zero

                getgenv().VELOCITY_DESYNC_UNTIL = _vs_clock() + 0.35
                hrp.AssemblyLinearVelocity = vel
                if _vs_velocity_desync_rotate then
                    hrp.AssemblyAngularVelocity = vel
                end

                _vs_render_stepped_wait(_vs_render_stepped)
                hrp.AssemblyLinearVelocity = old_lin
                hrp.AssemblyAngularVelocity = old_ang
                getgenv().VELOCITY_DESYNC_UNTIL = _vs_clock() + 0.05
            end
        end

        local function _vs_velocity_desync_enable(value)
            for i = 1, #_vs_anti_aim do
                if _vs_anti_aim[i] == _vs_do_velocity_desync then
                    _vs_remove(_vs_anti_aim, i)
                    break
                end
            end
            if value then
                _vs_anti_aim[#_vs_anti_aim + 1] = _vs_do_velocity_desync
            else
                pcall(function()
                    setfflag("S2PhysicsSenderRate", _vs_fake_position_sender_rate_old or "15")
                end)
            end
        end

        -- ── Инициализация персонажа ────────────────────────────────────
        local function _vs_init_character(character)
            if not character then return end
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                _vs_local_parts["HumanoidRootPart"] = hrp
                _vs_local_parts["Humanoid"]         = character:WaitForChild("Humanoid", 5)
            end
        end

        _vs_init_character(_vs_lp.Character)
        _vs_lp.CharacterAdded:Connect(_vs_init_character)

        -- ── Heartbeat ──────────────────────────────────────────────────
        local _vs_last_fps = _vs_clock()
        _vs_run_service.Heartbeat:Connect(function(dt)
            local diff = _vs_clock() - _vs_last_fps
            if diff > 0 then _vs_local_fps = 1 / diff end
            _vs_last_fps = _vs_clock()

            local hrp = _vs_local_parts["HumanoidRootPart"]
            for i = 1, #_vs_anti_aim do
                local func = _vs_anti_aim[i]
                if func then
                    task.spawn(func, dt, hrp)
                end
            end
        end)

        -- ── Глобальное API (совместимость с FLING_ACTIVE guard) ────────
        getgenv().VELOCITY_SPOOF = {
            enable    = function(v)      _vs_velocity_desync_enable(v) end,
            setPreset = function(preset) _vs_velocity_desync_type = preset end,
            setRotate = function(v)      _vs_velocity_desync_rotate = v end,
        }

        -- ── UI ────────────────────────────────────────────────────────
        v304:Paragraph({ Title = "Velocity Spoof" })

        v304:Toggle({
            Flag    = "velocity_spoof_enable",
            Title   = "Enable Velocity Spoof",
            Default = false,
            Callback = function(val)
                _vs_velocity_desync_enable(val)
                v18:Notify({
                    Title   = "CrystalHub",
                    Content = "Velocity Spoof " .. (val and "ON" or "OFF"),
                    Duration = 3,
                    Icon    = "bell",
                })
            end,
        })

        v304:Dropdown({
            Flag   = "velocity_spoof_preset",
            Title  = "Preset",
            Values = { "low", "high", "y high", "limit", "zero" },
            Value  = "low",
            Callback = function(val)
                _vs_velocity_desync_type = val
            end,
        })

        v304:Toggle({
            Flag    = "velocity_spoof_rotate",
            Title   = "Rotate Spoof",
            Default = false,
            Callback = function(val)
                _vs_velocity_desync_rotate = val
            end,
        })
    end

    -- ═══════════════════════════════════════════
    -- RAGE TAB: SPINBOT
    -- ═══════════════════════════════════════════
    do
        local sbEnabled    = false
        local sbSpeed      = 16.67  -- 50% от 1/3 * 50
        local sbConnection = nil

        v304:Divider()

        v304:Paragraph({ Title = "SpinBot" })

        v304:Toggle({
            Flag    = "spinbot",
            Title   = "SpinBot",
            Default = false,
            Callback = function(val)
                sbEnabled = val

                local char     = LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                if val then
                    if humanoid then
                        humanoid.AutoRotate = false
                    end
                    if not sbConnection then
                        sbConnection = RunService.Heartbeat:Connect(function(dt)
                            if not sbEnabled then return end
                            local c   = LocalPlayer.Character
                            local hrp = c and c:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = hrp.CFrame * CFrame.fromEulerAnglesXYZ(0, sbSpeed * dt, 0)
                            end
                        end)
                    end
                else
                    if sbConnection then
                        sbConnection:Disconnect()
                        sbConnection = nil
                    end
                    if humanoid then
                        humanoid.AutoRotate = true
                    end
                end

                v18:Notify({
                    Title   = "CrystalHub",
                    Content = "SpinBot " .. (val and "ON" or "OFF"),
                    Duration = 3,
                    Icon    = "bell",
                })
            end,
        })

        v304:Slider({
            Flag     = "spin_speed",
            Title    = "Spin Speed",
            IsTooltip = true,
            IsTextbox = true,
            Value    = { Min = 1, Max = 100, Default = 50 },
            Callback = function(val)
                sbSpeed = (tonumber(val) or 50) * (1 / 3)
            end,
        })
    end

-- ── FLING column (left) ──────────────────────────────────────
    v303._left:Paragraph({ Title = 'Fling Players' })

    do
        local flingNames = {}
        local flingSelected = nil

        local flingDropdown
        local function rebuildFlingList()
            flingNames = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(flingNames, player.Name)
                end
            end
            table.sort(flingNames)

            if flingSelected and not table.find(flingNames, flingSelected) then
                flingSelected = nil
            end
            if flingDropdown then
                flingDropdown:Refresh(flingNames)
                if flingSelected then
                    flingDropdown:Select(flingSelected)
                end
            end
        end

        rebuildFlingList()

        flingDropdown = v303._left:Dropdown({
            Flag = "select_player_2", Title = 'Select Player',
            Values = flingNames,
            Value = flingSelected,
            Callback = function(value) flingSelected = value end,
        })

        v303._left:Button({
            Title = 'Fling Selected Player',
            Description = 'Fling the selected player',
            Callback = function()
                if not flingSelected then
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = 'Select a player first!',
                        Duration = 3,
                        Icon = 'bell',
                    })
                    return
                end

                if u157 then
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = 'Fling is already in progress!',
                        Duration = 3,
                        Icon = 'bell',
                    })
                    return
                end

                local target = Players:FindFirstChild(flingSelected)

                if target and target.Character then
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = tostring('Flinging: ' .. target.Name),
                        Duration = 3,
                        Icon = 'bell',
                    })
                    task.spawn(u165, target)
                else
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = 'Player left or has no character!',
                        Duration = 3,
                        Icon = 'bell',
                    })
                end
            end,
        })

        v303._left:Button({
            Title = 'Refresh Fling List',
            Description = 'Update the player list',
            Callback = rebuildFlingList,
        })

        Players.PlayerAdded:Connect(function()
            task.delay(0.3, rebuildFlingList)
        end)

        Players.PlayerRemoving:Connect(function()
            task.delay(0.3, rebuildFlingList)
        end)
    end

-- ── TELEPORT column (right) ──────────────────────────────────
    v303._right:Paragraph({ Title = 'Teleport Players' })

    do
        local teleportNames = {}
        local teleportSelected = nil

        local teleportDropdown
        local function rebuildTeleportNames()
            teleportNames = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(teleportNames, player.Name)
                end
            end
            table.sort(teleportNames)
            if teleportSelected and not table.find(teleportNames, teleportSelected) then
                teleportSelected = nil
            end
            if teleportDropdown then
                teleportDropdown:Refresh(teleportNames)
                if teleportSelected then
                    teleportDropdown:Select(teleportSelected)
                end
            end
        end

        rebuildTeleportNames()

        teleportDropdown = v303._right:Dropdown({
            Flag = "select_player", Title = 'Select Player',
            Values = teleportNames,
            Value = teleportSelected,
            Callback = function(value) teleportSelected = value end,
        })

        v303._right:Button({
            Title = 'Teleport to Player',
            Description = 'Teleport to the selected player',
            Callback = function()
                if not teleportSelected then
                    v18:Notify({ Title = 'CrystalHub', Content = 'Select a player first!', Duration = 3, Icon = 'bell' })
                    return
                end
                local target = Players:FindFirstChild(teleportSelected)
                local character = LocalPlayer.Character
                local targetCharacter = target and target.Character
                local hrp = character and character:FindFirstChild('HumanoidRootPart')
                local targetHRP = targetCharacter and targetCharacter:FindFirstChild('HumanoidRootPart')
                if not (hrp and targetHRP) then
                    v18:Notify({ Title = 'CrystalHub', Content = 'Player or character not found!', Duration = 3, Icon = 'bell' })
                    return
                end
                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                v18:Notify({ Title = 'CrystalHub', Content = 'Teleported to: ' .. target.Name, Duration = 3, Icon = 'bell' })
            end,
        })

        v303._right:Button({
            Title = 'Refresh Teleport List',
            Description = 'Update the player list',
            Callback = function() rebuildTeleportNames() end,
        })

        Players.PlayerAdded:Connect(function()
            task.delay(0.3, rebuildTeleportNames)
        end)
        Players.PlayerRemoving:Connect(function()
            task.delay(0.3, rebuildTeleportNames)
        end)
    end

    -- Visuals tab: ready for the user's Visuals code.
    local VisualsTab = v300:Tab({
        Title = 'Visuals',
        Icon = 'diamond-simplified',
    })

    -- ============================================================
    --  AURA SYSTEM (WindUI native)
    -- ============================================================
    do
        local _player  = game:GetService("Players").LocalPlayer
        local _uis     = game:GetService("UserInputService")

        local aura_ids = {
            angel     = "97658130917593",
            starlight = "134645216613107",
            heavenly  = "139300897520961",
            ribbon    = "132069507632161",
            sakura    = "81755778619404",
            wind      = "80694081850877",
            flow      = "119913533725648",
            star      = "73754563740680",
        }
        local aura_order = {"angel","starlight","heavenly","ribbon","sakura","wind","flow","star"}

        local aura_cache     = {}
        local aura_particles = {}
        local aura_color     = Color3.fromRGB(133, 220, 255)
        local aura_active    = false
        local selected_auras = {}
        for _, name in ipairs(aura_order) do selected_auras[name] = false end

        -- ── Core helpers ──────────────────────────────────────
        local function clearAura()
            for _, p in ipairs(aura_particles) do pcall(function() p:Destroy() end) end
            aura_particles = {}
        end

        local function loadAura(name)
            if aura_cache[name] then return aura_cache[name] end
            local id = aura_ids[name]; if not id then return nil end
            local ok, res = pcall(game.GetObjects, game, "rbxassetid://"..id)
            if ok and res and res[1] then aura_cache[name] = res[1]; return res[1] end
        end

        local function colorAura(model, color)
            local seq = ColorSequence.new(color)
            for _, d in ipairs(model:GetDescendants()) do
                if d:IsA("PointLight") then d.Color = color
                elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then d.Color = seq end
            end
        end

        local function applyAura()
            clearAura()
            if not aura_active then return end
            local char = _player.Character; if not char then return end
            local real_char = char
            if char.Parent ~= workspace then
                real_char = nil
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == _player.Name then
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hrp and hrp:IsA("BasePart") then real_char = obj; break end
                    end
                end
            end
            if not real_char then return end
            for _, name in ipairs(aura_order) do
                if selected_auras[name] then
                    local m = loadAura(name)
                    if m then
                        colorAura(m, aura_color)
                        local cl = m:Clone()
                        for _, part in ipairs(cl:GetChildren()) do
                            local target = real_char:FindFirstChild(part.Name)
                            if target and target:IsA("BasePart") then
                                for _, child in ipairs(part:GetChildren()) do
                                    child.Parent = target; table.insert(aura_particles, child)
                                end
                            end
                        end
                        cl:Destroy()
                    end
                end
            end
        end

        _player.CharacterAdded:Connect(function()
            task.wait(0.5); applyAura()
        end)

        -- ── WindUI Controls ───────────────────────────────────
        VisualsTab._left:Paragraph({
            Title = "Aura Selector",
        })

        -- Master ON/OFF
        VisualsTab._left:Toggle({
            Flag = "enable_auras",Title = "Enable Auras",
            Description = "Apply selected auras to your character",
            Default = false,
            Callback = function(state)
                aura_active = state
                applyAura()
            end,
        })

        -- Individual aura toggles
        VisualsTab._left:Paragraph({
            Title = "Aura List",
        })

        for _, name in ipairs(aura_order) do
            local auraName = name
            VisualsTab._left:Toggle({
                Flag = "control_4735",Title = auraName:sub(1,1):upper()..auraName:sub(2),
                Default = false,
                Callback = function(state)
                    selected_auras[auraName] = state
                    applyAura()
                end,
            })
        end

        -- Quick presets
        VisualsTab._left:Paragraph({
            Title = "Color Presets",
        })

        local colorPresets = {"Default (Blue)","Red","Green","Gold","Purple","White","Rainbow (cycle)"}

        VisualsTab._left:Dropdown({
            Flag = "color_preset",Title = "Color Preset",
            Description = "Pick a preset color",
            Values = colorPresets,
            Value = "Default (Blue)",
            Callback = function(val)
                if val == "Default (Blue)" then
                    aura_color = Color3.fromRGB(133, 220, 255)
                elseif val == "Red" then
                    aura_color = Color3.fromRGB(255, 60, 60)
                elseif val == "Green" then
                    aura_color = Color3.fromRGB(60, 255, 100)
                elseif val == "Gold" then
                    aura_color = Color3.fromRGB(255, 200, 50)
                elseif val == "Purple" then
                    aura_color = Color3.fromRGB(180, 60, 255)
                elseif val == "White" then
                    aura_color = Color3.fromRGB(255, 255, 255)
                elseif val == "Rainbow (cycle)" then
                    task.spawn(function()
                        local hue = 0
                        while aura_active do
                            hue = (hue + 0.005) % 1
                            aura_color = Color3.fromHSV(hue, 1, 1)
                            applyAura()
                            task.wait(0.05)
                        end
                    end)
                    return
                end
                applyAura()
            end,
        })

        -- Clear button
        VisualsTab._left:Button({
            Title = "Clear All Auras",
            Description = "Remove all aura effects from character",
            Callback = function()
                clearAura()
                v18:Notify({
                    Title = "CrystalHub",
                    Content = "Auras cleared.",
                    Duration = 2,
                    Icon = "eye",
                })
            end,
        })
    end
    -- ============================================================
    --  END AURA SYSTEM
    -- ============================================================
VisualsTab._left:Divider()
VisualsTab._left:Paragraph({
    Title = 'Skybox',
})
VisualsTab._left:Button({
    Title = 'Open Skybox Picker',
    Description = 'Color preview list \u{2014} click to apply instantly',
    Callback = function()
        local RuzSkyboxPicker = game.CoreGui:FindFirstChild('RuzSkyboxPicker')

        if not RuzSkyboxPicker then
            local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

            ScreenGui.Name = 'RuzSkyboxPicker'
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 62

            local Frame = Instance.new('Frame', ScreenGui)

            Frame.Size = UDim2.new(0, 310, 0, 420)
            Frame.Position = UDim2.new(0.5, -155, 0.04, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Frame.BackgroundTransparency = 0.06
            Frame.BorderSizePixel = 0
            Instance.new('UICorner', Frame).CornerRadius = UDim.new(0, 12)

            local UIStroke = Instance.new('UIStroke', Frame)

            UIStroke.Color = Color3.fromRGB(220, 38, 38)
            UIStroke.Thickness = 1.5

            local TextLabel = Instance.new('TextLabel', Frame)

            TextLabel.Size = UDim2.new(1, -44, 0, 38)
            TextLabel.Position = UDim2.new(0, 12, 0, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = 'CrystalHub  \u{2014}  Skybox Picker'
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            local TextButton = Instance.new('TextButton', Frame)

            TextButton.Size = UDim2.new(0, 28, 0, 28)
            TextButton.Position = UDim2.new(1, -34, 0, 5)
            TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            TextButton.Text = 'X'
            TextButton.TextColor3 = Color3.new(1, 1, 1)
            TextButton.Font = Enum.Font.GothamBold
            TextButton.TextSize = 13
            Instance.new('UICorner', TextButton).CornerRadius = UDim.new(0, 6)

            local MouseButton1Click = TextButton.MouseButton1Click
            local u633 = ScreenGui

            MouseButton1Click:Connect(function()
                u633:Destroy()
            end)

            local TextBox = Instance.new('TextBox', Frame)

            TextBox.Size = UDim2.new(1, -20, 0, 34)
            TextBox.Position = UDim2.new(0, 10, 0, 44)
            TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TextBox.Text = ''
            TextBox.PlaceholderText = 'Enter custom Skybox ID, press Enter...'
            TextBox.TextColor3 = Color3.new(1, 1, 1)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 13
            TextBox.ClearTextOnFocus = false
            Instance.new('UICorner', TextBox).CornerRadius = UDim.new(0, 6)
            Instance.new('UIStroke', TextBox).Color = Color3.fromRGB(80, 80, 80)

            local FocusLost = TextBox.FocusLost
            local u636 = TextBox

            FocusLost:Connect(function(p68)
                if p68 and u636.Text ~= '' then
                    u147(u636.Text)

                    local v888 = 'Custom skybox applied \u{2014} ID: ' .. u636.Text

                    u148:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v888),
                        Duration = 3,
                        Icon = 'bell',
                    })

                    u636.Text = ''
                end
            end)

            local TextButton5 = Instance.new('TextButton', Frame)

            TextButton5.Size = UDim2.new(1, -20, 0, 28)
            TextButton5.Position = UDim2.new(0, 10, 0, 84)
            TextButton5.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TextButton5.Text = 'Restore Default Sky'
            TextButton5.TextColor3 = Color3.fromRGB(200, 200, 200)
            TextButton5.Font = Enum.Font.GothamBold
            TextButton5.TextSize = 12
            Instance.new('UICorner', TextButton5).CornerRadius = UDim.new(0, 6)

            local MouseButton1Click4 = TextButton5.MouseButton1Click
            local u639 = ScreenGui

            MouseButton1Click4:Connect(function()
                u149()
                u639:Destroy()
            end)

            local Frame5 = Instance.new('Frame', Frame)

            Frame5.Size = UDim2.new(1, -20, 0, 1)
            Frame5.Position = UDim2.new(0, 10, 0, 118)
            Frame5.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Frame5.BorderSizePixel = 0

            local ScrollingFrame = Instance.new('ScrollingFrame', Frame)

            ScrollingFrame.Size = UDim2.new(1, -14, 1, -126)
            ScrollingFrame.Position = UDim2.new(0, 7, 0, 124)
            ScrollingFrame.BackgroundTransparency = 1
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.ScrollBarThickness = 4
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #u150 * 56)

            local UIListLayout = Instance.new('UIListLayout', ScrollingFrame)

            UIListLayout.Padding = UDim.new(0, 6)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for i, v in ipairs(u150)do
                local TextButton6 = Instance.new('TextButton', ScrollingFrame)

                TextButton6.Size = UDim2.new(1, -8, 0, 48)
                TextButton6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                TextButton6.Text = ''
                TextButton6.AutoButtonColor = false
                TextButton6.LayoutOrder = i
                Instance.new('UICorner', TextButton6).CornerRadius = UDim.new(0, 8)

                local UIStroke2 = Instance.new('UIStroke', TextButton6)

                UIStroke2.Color = v.color
                UIStroke2.Thickness = 1

                local Frame6 = Instance.new('Frame', TextButton6)

                Frame6.Size = UDim2.new(0, 34, 0, 34)
                Frame6.Position = UDim2.new(0, 8, 0.5, -17)
                Frame6.BackgroundColor3 = v.color
                Frame6.BorderSizePixel = 0
                Instance.new('UICorner', Frame6).CornerRadius = UDim.new(0, 6)

                local TextLabel5 = Instance.new('TextLabel', TextButton6)

                TextLabel5.Size = UDim2.new(1, -58, 0, 22)
                TextLabel5.Position = UDim2.new(0, 50, 0, 6)
                TextLabel5.BackgroundTransparency = 1
                TextLabel5.Text = v.name
                TextLabel5.TextColor3 = Color3.fromRGB(210, 210, 210)
                TextLabel5.Font = Enum.Font.GothamBold
                TextLabel5.TextSize = 14
                TextLabel5.TextXAlignment = Enum.TextXAlignment.Left

                local TextLabel6 = Instance.new('TextLabel', TextButton6)

                TextLabel6.Size = UDim2.new(1, -58, 0, 14)
                TextLabel6.Position = UDim2.new(0, 50, 1, -18)
                TextLabel6.BackgroundTransparency = 1
                TextLabel6.Text = 'ID: ' .. v.id
                TextLabel6.TextColor3 = Color3.fromRGB(100, 100, 100)
                TextLabel6.Font = Enum.Font.Gotham
                TextLabel6.TextSize = 10
                TextLabel6.TextXAlignment = Enum.TextXAlignment.Left

                local MouseButton1Click5 = TextButton6.MouseButton1Click
                local u651 = v
                local u652 = ScrollingFrame
                local u653 = UIStroke2
                local u654 = TextButton6
                local u655 = TextLabel5

                MouseButton1Click5:Connect(function()
                    u147(u651.id)

                    local v889 = 'Skybox applied: ' .. u651.name

                    u148:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v889),
                        Duration = 3,
                        Icon = 'bell',
                    })

                    for _, child in ipairs(u652:GetChildren())do
                        if child:IsA('TextButton') then
                            local UIStroke3 = child:FindFirstChildOfClass('UIStroke')

                            if UIStroke3 then
                                UIStroke3.Thickness = 1
                                UIStroke3.Color = Color3.fromRGB(80, 80, 80)
                            end

                            child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        end
                    end

                    u653.Thickness = 2
                    u653.Color = Color3.fromRGB(220, 38, 38)
                    u654.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
                    u655.TextColor3 = Color3.fromRGB(255, 80, 80)
                end)
            end

            u151(Frame)

            return
        end

        RuzSkyboxPicker:Destroy()
    end,
})

local t30 = {
    Flag = "restore_default_sky",
    Title = 'Restore Default Sky',
}
local u310 = v145

function t30.Callback()
    u310()
end

VisualsTab._left:Button(t30)
VisualsTab._right:Paragraph({
    Title = 'Crosshair',
})

local t31 = {
    Flag = "enable_custom_crosshair",
    Title = 'Enable Custom Crosshair',
    Description = 'Visible only while ShiftLock is on',
    Default = false,
}

local function u312()
    local RuzCrosshairDisplay = game.CoreGui:FindFirstChild('RuzCrosshairDisplay')

    if RuzCrosshairDisplay then
        RuzCrosshairDisplay:Destroy()
    end
    if u202 then
        u202:Disconnect()

        u202 = nil
    end

    local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

    ScreenGui.Name = 'RuzCrosshairDisplay'
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 25
    ScreenGui.IgnoreGuiInset = true
    u201 = Instance.new('ImageLabel', ScreenGui)
    u201.AnchorPoint = Vector2.new(0.5, 0.5)
    u201.Position = UDim2.new(0.5, 0, 0.5, 0)
    u201.Size = UDim2.new(0, 42, 0, 42)
    u201.BackgroundTransparency = 1
    u201.Image = 'rbxassetid://' .. id
    u201.ZIndex = 10
    u201.Visible = false

    -- Кешируем ссылку на Crosshair чтобы не делать FindFirstChild каждый кадр
    local _crosshairRef = nil
    local _crosshairLastVisible = nil
    local _crosshairLastMouseIcon = nil

    u205.RenderStepped:Connect(function()
        if u201 and u201.Parent then
            local v914 = u206.MouseBehavior == Enum.MouseBehavior.LockCenter

            -- Скрываем встроенный кроссхейр (кешируем поиск)
            if not _crosshairRef then
                local PlayerGui = u207:FindFirstChild('PlayerGui')
                if PlayerGui then
                    local GameTopbar = PlayerGui:FindFirstChild('GameTopbar')
                    if GameTopbar then
                        _crosshairRef = GameTopbar:FindFirstChild('Crosshair')
                    end
                end
            end
            if _crosshairRef and _crosshairRef.Parent then
                _crosshairRef.Visible = false
            else
                _crosshairRef = nil -- сброс кеша если удалили
            end

            local v917 = u198 and (v914 or false)

            -- Обновляем только при изменении (избегаем лишних записей в свойства)
            if _crosshairLastVisible ~= v917 then
                u201.Visible = v917
                _crosshairLastVisible = v917
            end
            if _crosshairLastMouseIcon ~= (not v917) then
                u206.MouseIconEnabled = not v917
                _crosshairLastMouseIcon = not v917
            end

            return
        end
    end)
    u208()
end

local u313 = v18
local u314 = UserInputService

function t31.Callback(p69)
    u198 = p69

    if not p69 then
        local RuzCrosshairDisplay = game.CoreGui:FindFirstChild('RuzCrosshairDisplay')

        if RuzCrosshairDisplay then
            RuzCrosshairDisplay:Destroy()

            u201 = nil
        end
        if u202 then
            u202:Disconnect()

            u202 = nil
        end

        u314.MouseIconEnabled = true

        u313:Notify({
            Title = 'CrystalHub',
            Content = tostring('Crosshair OFF'),
            Duration = 3,
            Icon = 'bell',
        })

        return
    end

    u312()
    u313:Notify({
        Title = 'CrystalHub',
        Content = tostring('Crosshair ON \u{2014} enable ShiftLock to see it!'),
        Duration = 3,
        Icon = 'bell',
    })
end

VisualsTab._right:Toggle(t31)
VisualsTab._right:Button({
    Title = 'Open Cursor Picker',
    Description = 'Visual grid with spin toggle \u{2014} click to apply',
    Callback = function()
        local RuzCursorPicker = game.CoreGui:FindFirstChild('RuzCursorPicker')

        if not RuzCursorPicker then
            local ScreenGui = Instance.new('ScreenGui', game.CoreGui)

            ScreenGui.Name = 'RuzCursorPicker'
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 60

            local Frame = Instance.new('Frame', ScreenGui)

            Frame.Size = UDim2.new(0, 300, 0, 460)
            Frame.Position = UDim2.new(0.5, -150, 0.04, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Frame.BackgroundTransparency = 0.06
            Frame.BorderSizePixel = 0
            Instance.new('UICorner', Frame).CornerRadius = UDim.new(0, 12)

            local UIStroke = Instance.new('UIStroke', Frame)

            UIStroke.Color = Color3.fromRGB(220, 38, 38)
            UIStroke.Thickness = 1.5

            local TextLabel = Instance.new('TextLabel', Frame)

            TextLabel.Size = UDim2.new(1, -44, 0, 38)
            TextLabel.Position = UDim2.new(0, 12, 0, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = 'CrystalHub  \u{2014}  Cursor Picker'
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            local TextButton = Instance.new('TextButton', Frame)

            TextButton.Size = UDim2.new(0, 28, 0, 28)
            TextButton.Position = UDim2.new(1, -34, 0, 5)
            TextButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            TextButton.Text = 'X'
            TextButton.TextColor3 = Color3.new(1, 1, 1)
            TextButton.Font = Enum.Font.GothamBold
            TextButton.TextSize = 13
            Instance.new('UICorner', TextButton).CornerRadius = UDim.new(0, 6)

            local MouseButton1Click = TextButton.MouseButton1Click
            local u715 = ScreenGui

            MouseButton1Click:Connect(function()
                u715:Destroy()
            end)

            local TextBox = Instance.new('TextBox', Frame)

            TextBox.Size = UDim2.new(1, -20, 0, 34)
            TextBox.Position = UDim2.new(0, 10, 0, 44)
            TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TextBox.Text = ''
            TextBox.PlaceholderText = 'Enter custom Cursor ID, press Enter...'
            TextBox.TextColor3 = Color3.new(1, 1, 1)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 13
            TextBox.ClearTextOnFocus = false
            Instance.new('UICorner', TextBox).CornerRadius = UDim.new(0, 6)
            Instance.new('UIStroke', TextBox).Color = Color3.fromRGB(80, 80, 80)

            local FocusLost = TextBox.FocusLost
            local u718 = TextBox

            FocusLost:Connect(function(p70)
                if p70 and u718.Text ~= '' then
                    id = u718.Text

                    if u198 and u201 then
                        u201.Image = 'rbxassetid://' .. u718.Text
                    end

                    u209:Notify({
                        Title = 'CrystalHub',
                        Content = tostring('Custom cursor applied \u{2014} enable ShiftLock to see it!'),
                        Duration = 3,
                        Icon = 'bell',
                    })

                    u718.Text = ''
                end
            end)

            local Frame7 = Instance.new('Frame', Frame)

            Frame7.Size = UDim2.new(1, -20, 0, 30)
            Frame7.Position = UDim2.new(0, 10, 0, 84)
            Frame7.BackgroundTransparency = 1

            local TextLabel7 = Instance.new('TextLabel', Frame7)

            TextLabel7.Size = UDim2.new(1, -64, 1, 0)
            TextLabel7.BackgroundTransparency = 1
            TextLabel7.Text = 'Spin Crosshair'
            TextLabel7.TextColor3 = Color3.fromRGB(200, 200, 200)
            TextLabel7.Font = Enum.Font.GothamBold
            TextLabel7.TextSize = 13
            TextLabel7.TextXAlignment = Enum.TextXAlignment.Left

            local TextButton7 = Instance.new('TextButton', Frame7)

            TextButton7.Size = UDim2.new(0, 54, 0, 26)
            TextButton7.Position = UDim2.new(1, -54, 0.5, -13)
            TextButton7.BackgroundColor3 = u199 and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
            TextButton7.Text = u199 and 'ON' or 'OFF'
            TextButton7.TextColor3 = Color3.new(1, 1, 1)
            TextButton7.Font = Enum.Font.GothamBold
            TextButton7.TextSize = 12
            Instance.new('UICorner', TextButton7).CornerRadius = UDim.new(0, 8)

            local MouseButton1Click6 = TextButton7.MouseButton1Click
            local u723 = TextButton7

            MouseButton1Click6:Connect(function()
                u199 = not u199
                u723.BackgroundColor3 = u199 and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
                u723.Text = u199 and 'ON' or 'OFF'

                u210()

                local v919 = 'Crosshair Spin: ' .. (u199 and 'ON' or 'OFF')

                u209:Notify({
                    Title = 'CrystalHub',
                    Content = tostring(v919),
                    Duration = 3,
                    Icon = 'bell',
                })
            end)

            local Frame8 = Instance.new('Frame', Frame)

            Frame8.Size = UDim2.new(1, -20, 0, 1)
            Frame8.Position = UDim2.new(0, 10, 0, 120)
            Frame8.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Frame8.BorderSizePixel = 0

            local ScrollingFrame = Instance.new('ScrollingFrame', Frame)

            ScrollingFrame.Size = UDim2.new(1, -14, 1, -128)
            ScrollingFrame.Position = UDim2.new(0, 7, 0, 126)
            ScrollingFrame.BackgroundTransparency = 1
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.ScrollBarThickness = 4

            local new = UDim2.new
            local v727 = #u211 / 2

            ScrollingFrame.CanvasSize = new(0, 0, 0, math.ceil(v727) * 118 + 10)

            local UIGridLayout = Instance.new('UIGridLayout', ScrollingFrame)

            UIGridLayout.CellSize = UDim2.new(0, 128, 0, 110)
            UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
            UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for i, v in ipairs(u211)do
                local v731 = id == v.id
                local TextButton8 = Instance.new('TextButton', ScrollingFrame)

                TextButton8.Size = UDim2.new(0, 128, 0, 110)
                TextButton8.BackgroundColor3 = v731 and Color3.fromRGB(55, 15, 15) or Color3.fromRGB(20, 20, 20)
                TextButton8.Text = ''
                TextButton8.AutoButtonColor = false
                TextButton8.LayoutOrder = i
                Instance.new('UICorner', TextButton8).CornerRadius = UDim.new(0, 8)

                local UIStroke4 = Instance.new('UIStroke', TextButton8)

                UIStroke4.Color = v731 and Color3.fromRGB(220, 38, 38) or Color3.fromRGB(50, 50, 50)
                UIStroke4.Thickness = v731 and 1.8 or 1.2

                local ImageLabel = Instance.new('ImageLabel', TextButton8)

                ImageLabel.Size = UDim2.new(0, 58, 0, 58)
                ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
                ImageLabel.Position = UDim2.new(0.5, 0, 0, 8)
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.Image = 'rbxassetid://' .. v.id

                local TextLabel8 = Instance.new('TextLabel', TextButton8)

                TextLabel8.Size = UDim2.new(1, -6, 0, 28)
                TextLabel8.Position = UDim2.new(0, 3, 1, -30)
                TextLabel8.BackgroundTransparency = 1
                TextLabel8.Text = v.name .. (v731 and ' \u{2713}' or '')
                TextLabel8.TextColor3 = v731 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(200, 200, 200)
                TextLabel8.Font = Enum.Font.GothamBold
                TextLabel8.TextSize = 11
                TextLabel8.TextWrapped = true

                local MouseButton1Click7 = TextButton8.MouseButton1Click
                local u737 = v
                local u738 = ScreenGui

                MouseButton1Click7:Connect(function()
                    id = u737.id

                    if u198 and u201 then
                        u201.Image = 'rbxassetid://' .. u737.id
                    end

                    local v920 = 'Cursor: ' .. u737.name .. ' \u{2014} enable ShiftLock to see it!'

                    u209:Notify({
                        Title = 'CrystalHub',
                        Content = tostring(v920),
                        Duration = 3,
                        Icon = 'bell',
                    })
                    u738:Destroy()
                end)
            end

            u212(Frame)

            return
        end

        RuzCursorPicker:Destroy()
    end,
})

-- ═══════════════════════════════════════════
-- BULLET TRACERS (VisualsTab)
-- Хук через hookfunction на FireServer конкретных MM2 ремотов:
--   Gun   → Gun.Shoot           FireServer(shootCF, targetCF)
--   Knife → Knife.Events.KnifeThrown  FireServer(throwCF, targetCF)
-- targetCF — второй аргумент, его .Position = точка попадания
-- ═══════════════════════════════════════════
do
    local TweenService = game:GetService("TweenService")

    local BT = {
        Enabled      = false,
        Color        = Color3.fromRGB(255, 50, 50),
        Size         = 0.12,
        Transparency = 0,
        TimeAlive    = 0.6,
        TextureID    = "rbxassetid://6880875456",
    }
    _BT = BT  -- expose to outer scope so Shoot button can read BT.Enabled

    -- ── Beam-рисовалка ──────────────────────────────────────────────────
    local function bullettracerlol(startPos, endPos)
        local sp = Instance.new("Part")
        sp.Name = "BulletStart" sp.Anchored = true sp.CanCollide = false
        sp.CanTouch = false sp.CanQuery = false sp.Massless = true
        sp.Transparency = 1 sp.Size = Vector3.new(0.2,0.2,0.2)
        sp.Position = startPos sp.Parent = Workspace

        local ep = Instance.new("Part")
        ep.Name = "BulletEnd" ep.Anchored = true ep.CanCollide = false
        ep.CanTouch = false ep.CanQuery = false ep.Massless = true
        ep.Transparency = 1 ep.Size = Vector3.new(0.2,0.2,0.2)
        ep.Position = endPos ep.Parent = Workspace

        local beam = Instance.new("Beam")
        beam.Attachment0   = Instance.new("Attachment", sp)
        beam.Attachment1   = Instance.new("Attachment", ep)
        beam.FaceCamera    = true
        beam.LightEmission = 1
        beam.Color         = ColorSequence.new(BT.Color)
        beam.Texture       = BT.TextureID
        beam.Transparency  = NumberSequence.new(BT.Transparency)
        beam.Width0        = BT.Size
        beam.Width1        = BT.Size
        beam.Parent        = sp

        task.delay(BT.TimeAlive, function()
            if beam and beam.Parent then
                local tw = TweenService:Create(beam,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { Width0 = 0, Width1 = 0 })
                tw:Play()
                tw.Completed:Wait()
            end
            if sp   and sp.Parent   then sp:Destroy()   end
            if ep   and ep.Parent   then ep:Destroy()   end
            if beam and beam.Parent then beam:Destroy() end
        end)
    end
    _bullettracerlol = bullettracerlol  -- expose to outer scope for Shoot button

    -- ── Хук: сохраняем rawFireServer ДО подмены метатаблицы ─────────────
    local shootRemoteRef = nil
    -- Берём оригинальный FireServer как чистую функцию через Instance напрямую
    local rawFireServer = Instance.new("RemoteEvent").FireServer

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall

    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "FireServer" and BT.Enabled and self == shootRemoteRef then
            local args = { ... }
            local dirCF    = args[1]
            local targetCF = args[2]

            local startPos, endPos

            pcall(function()
                local char = LocalPlayer.Character
                local gun  = char and char:FindFirstChild("Gun")
                local h    = gun and gun:FindFirstChild("Handle")
                startPos   = h and h.Position
            end)

            if typeof(targetCF) == "CFrame" then
                endPos = targetCF.Position
            elseif typeof(dirCF) == "CFrame" then
                endPos = dirCF.Position + dirCF.LookVector * 200
            end

            if startPos and endPos then
                task.spawn(bullettracerlol, startPos, endPos)
            end

            -- Вызываем оригинал напрямую через rawFireServer — не через метатаблицу
            return rawFireServer(self, ...)
        end

        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)

    -- Находим Gun.Shoot при подборе оружия
    local function watchChar(char)
        if not char then return end
        shootRemoteRef = nil

        local function tryFindShoot(tool)
            if not tool or tool.Name ~= "Gun" then return end
            pcall(function()
                local remote = tool:WaitForChild("Shoot", 5)
                if remote and remote:IsA("RemoteEvent") then
                    shootRemoteRef = remote
                end
            end)
        end

        for _, obj in ipairs(char:GetChildren()) do
            task.spawn(tryFindShoot, obj)
        end
        char.ChildAdded:Connect(function(obj)
            task.spawn(tryFindShoot, obj)
        end)

        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, obj in ipairs(bp:GetChildren()) do
                task.spawn(tryFindShoot, obj)
            end
            bp.ChildAdded:Connect(function(obj)
                task.spawn(tryFindShoot, obj)
            end)
        end
    end

    watchChar(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(function(char)
        shootRemoteRef = nil
        task.wait(1)
        watchChar(char)
    end)

    -- ── UI ──────────────────────────────────────────────────────────────
    VisualsTab._right:Paragraph({ Title = "Bullet Tracers" })

    VisualsTab._right:Toggle({
        Flag = "enable_bullet_tracers", Title = "Enable Bullet Tracers",
        Default  = false,
        Callback = function(val)
            BT.Enabled = val
            v18:Notify({
                Title    = "CrystalHub",
                Content  = "Bullet Tracers " .. (val and "ON" or "OFF"),
                Duration = 3,
                Icon     = "bell",
            })
        end,
    })

    VisualsTab._right:ColorPicker({
        Flag = "tracer_color", Title = "Tracer Color",
        Default  = BT.Color,
        Callback = function(col) BT.Color = col end,
    })

    VisualsTab._right:Slider({
        Flag = "tracer_width", Title = "Tracer Width",
        Value    = { Min = 1, Max = 20, Default = 12 },
        Rounding = 0,
        Callback = function(val) BT.Size = val * 0.01 end,
    })

    VisualsTab._right:Slider({
        Flag = "tracer_duration_0_1s", Title = "Tracer Duration (×0.1s)",
        Value    = { Min = 1, Max = 30, Default = 6 },
        Rounding = 0,
        Callback = function(val) BT.TimeAlive = val * 0.1 end,
    })

    VisualsTab._right:Slider({
        Flag = "tracer_transparency", Title = "Tracer Transparency",
        Value    = { Min = 0, Max = 9, Default = 0 },
        Rounding = 0,
        Callback = function(val) BT.Transparency = val * 0.1 end,
    })
end
-- ═══════════════════════════════════════════

-- ══════════════ CHINA HAT (VisualsTab) ══════════════
do
    local _ChinaHat = {
        enabled      = false,
        hatColor     = Color3.fromRGB(255, 105, 180),
        lightColor   = Color3.fromRGB(255, 105, 180),
        lightBrightness = 0,
        lightRange   = 12,
        scale        = Vector3.new(1.7, 1.1, 1.7),
    }

    local _hatCone = nil

    local function _RemoveHat()
        if _hatCone and _hatCone.Parent then
            _hatCone:Destroy()
        end
        _hatCone = nil
    end

    local function _CreateHat(Character)
        _RemoveHat()
        local Head = Character:FindFirstChild("Head")
        if not Head then return end

        local Cone = Instance.new("Part")
        Cone.Size       = Vector3.new(1, 1, 1)
        Cone.Material   = Enum.Material.Neon
        Cone.Transparency = 0.2
        Cone.Anchored   = false
        Cone.CanCollide = false
        Cone.Color      = _ChinaHat.hatColor
        Cone.Name       = "CrystalHub_ChinaHat"

        local Mesh = Instance.new("SpecialMesh")
        Mesh.MeshType = Enum.MeshType.FileMesh
        Mesh.MeshId   = "rbxassetid://1033714"
        Mesh.Scale    = _ChinaHat.scale
        Mesh.Parent   = Cone

        local Weld = Instance.new("Weld")
        Weld.Part0  = Head
        Weld.Part1  = Cone
        Weld.C0     = CFrame.new(0, 0.9, 0)
        Weld.Parent = Cone

        local Light = Instance.new("PointLight")
        Light.Color      = _ChinaHat.lightColor
        Light.Brightness = _ChinaHat.lightBrightness
        Light.Range      = _ChinaHat.lightRange
        Light.Shadows    = true
        Light.Parent     = Cone

        Cone.Parent = Character
        _hatCone    = Cone
    end

    local _charConn = nil

    local function _ApplyHat()
        local lp  = Players.LocalPlayer
        local chr = lp and lp.Character
        if chr then _CreateHat(chr) end
        if _charConn then _charConn:Disconnect() end
        _charConn = lp.CharacterAdded:Connect(function(character)
            if _ChinaHat.enabled then
                character:WaitForChild("Head", 10)
                _CreateHat(character)
            end
        end)
    end

    VisualsTab._left:Divider()
    VisualsTab._left:Paragraph({ Title = "China Hat", Content = "Decorative hat on your character" })

    VisualsTab._left:Toggle({
        Flag = "enable_china_hat",Title   = "Enable China Hat",
        Default = false,
        Callback = function(val)
            _ChinaHat.enabled = val
            if val then
                _ApplyHat()
            else
                _RemoveHat()
                if _charConn then _charConn:Disconnect() _charConn = nil end
            end
            v18:Notify({
                Title   = "CrystalHub",
                Content = val and "China Hat ON" or "China Hat OFF",
                Duration = 3,
                Icon    = "bell",
            })
        end,
    })

    VisualsTab._left:ColorPicker({
        Flag = "hat_color",Title   = "Hat Color",
        Default = Color3.fromRGB(255, 105, 180),
        Callback = function(col)
            _ChinaHat.hatColor = col
            if _hatCone and _hatCone.Parent then
                _hatCone.Color = col
            end
        end,
    })

    VisualsTab._left:ColorPicker({
        Flag = "light_color",Title   = "Light Color",
        Default = Color3.fromRGB(255, 105, 180),
        Callback = function(col)
            _ChinaHat.lightColor = col
            if _hatCone and _hatCone.Parent then
                local light = _hatCone:FindFirstChildOfClass("PointLight")
                if light then light.Color = col end
            end
        end,
    })

    VisualsTab._left:Slider({
        Flag = "light_brightness",Title    = "Light Brightness",
        Value    = { Min = 0, Max = 10, Default = 0 },
        Rounding = 0,
        Callback = function(val)
            _ChinaHat.lightBrightness = val
            if _hatCone and _hatCone.Parent then
                local light = _hatCone:FindFirstChildOfClass("PointLight")
                if light then light.Brightness = val end
            end
        end,
    })

    VisualsTab._left:Slider({
        Flag = "light_range",Title    = "Light Range",
        Value    = { Min = 0, Max = 60, Default = 12 },
        Rounding = 0,
        Callback = function(val)
            _ChinaHat.lightRange = val
            if _hatCone and _hatCone.Parent then
                local light = _hatCone:FindFirstChildOfClass("PointLight")
                if light then light.Range = val end
            end
        end,
    })
end
-- ═══════════════════════════════════════════════════════

-- ============================================================
-- AMBIENCE SYSTEM (Visuals - Column 1)
-- ============================================================
do
	getgenv().WORLD_FOG_END = 1000
	getgenv().WORLD_FULLBRIGHT_ENABLED = false
	getgenv().WORLD_AMBIENT_ENABLED = false
	getgenv().WORLD_AMBIENT_COLOR = Color3.fromRGB(128, 128, 128)
	
	local lighting = game:GetService("Lighting")
	local originalFogColor = lighting.FogColor
	local originalFogStart = lighting.FogStart
	local originalFogEnd = lighting.FogEnd
	local originalBrightness = lighting.Brightness
	local originalAmbient = lighting.Ambient
	local originalOutdoorAmbient = lighting.OutdoorAmbient
	local originalGlobalShadows = lighting.GlobalShadows
	local originalClockTime = lighting.ClockTime
	local originalColorShift_Bottom = lighting.ColorShift_Bottom
	local originalColorShift_Top = lighting.ColorShift_Top
	local originalEnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale
	local originalEnvironmentSpecularScale = lighting.EnvironmentSpecularScale
	local originalGeographicLatitude = lighting.GeographicLatitude
	local originalExposureCompensation = lighting.ExposureCompensation
	
	local shader_enabled = false
	local shader_type = "morning"
	local shader_connection = nil
	local original_effects = {}
	local created_effects = {}
	
	local bloom_effect = nil
	local blur_effect = nil
	local colorcor_effect = nil
	local depth_effect = nil
	local atmosphere_effect = nil
	local cloud_effect = nil
	
	local shaders = {
		morning = {
			yfbghj = Color3.fromRGB(10, 10, 10),
			khnbfth = 1.5,
			tgvbyd = 7.5,
			hgyghkg = Color3.fromRGB(0, 0, 0),
			yfbhjku = Color3.fromRGB(200, 200, 200),
			ygyyfgvhbjytrt = 0.1,
			sdfcddc = 0.1,
			hyhnngtf = Color3.fromRGB(10, 10, 10),
			ghuybhuyhj = 44,
			hdfr7thgr = 0.3,
			hgnujuu7thgr = true,
			fhnchvhfjsd = -0.02,
			ugtbbjhygt = 0.8,
			tfbghuugbnjhg = -0.5,
			fvrtccvghghj = Color3.fromRGB(100, 150, 200),
			jnfdhbnfcvh = 0.2,
			fvtyghj = 5,
			ygbhnj = 0.8,
			njnfg = 2,
			jdfkd = 0.5,
			fvgsdfg = 15,
			sdkvkflv = 5,
			hbjhd = 0.5,
			shdbsnjfc = 0.2,
			skdjfkdm = 0.5,
			sjdjncdjf = Color3.fromRGB(70, 120, 170),
			efjdjfk = Color3.fromRGB(10, 50, 100),
			sejfd = 0.3,
			jddfjsd = 1,
			gyhgtg = 0.6,
			ygbhggv = 0.36,
			jghbjhgyfd = Color3.fromRGB(255, 255, 255)
		},
		midday = {
			yfbghj = Color3.fromRGB(2, 2, 2),
			khnbfth = 3.25,
			tgvbyd = 8,
			hgyghkg = Color3.fromRGB(0, 0, 0),
			yfbhjku = Color3.fromRGB(255, 247, 237),
			ygyyfgvhbjytrt = 0.203,
			sdfcddc = 0.255,
			hyhnngtf = Color3.fromRGB(51, 54, 67),
			ghuybhuyhj = -15.12,
			hdfr7thgr = 0.85,
			hgnujuu7thgr = true,
			fhnchvhfjsd = 0.1,
			ugtbbjhygt = 0.5,
			tfbghuugbnjhg = -0.3,
			fvrtccvghghj = Color3.fromRGB(242, 243, 243),
			jnfdhbnfcvh = 0.3,
			fvtyghj = 10,
			ygbhnj = 0.8,
			njnfg = 5,
			jdfkd = 0.277,
			fvgsdfg = 21.54,
			sdkvkflv = 16.77,
			hbjhd = 0.277,
			shdbsnjfc = 0.364,
			skdjfkdm = 0.556,
			sjdjncdjf = Color3.fromRGB(175, 221, 255),
			efjdjfk = Color3.fromRGB(13, 105, 172),
			sejfd = 0.36,
			jddfjsd = 0.72,
			gyhgtg = 0.75,
			ygbhggv = 0.26,
			jghbjhgyfd = Color3.fromRGB(255, 255, 255)
		},
		evening = {
			yfbghj = Color3.fromRGB(2, 2, 2),
			khnbfth = 2.25,
			tgvbyd = 16,
			hgyghkg = Color3.fromRGB(0, 0, 0),
			yfbhjku = Color3.fromRGB(255, 247, 237),
			ygyyfgvhbjytrt = 0.203,
			sdfcddc = 0.215,
			hyhnngtf = Color3.fromRGB(0, 0, 0),
			ghuybhuyhj = 45,
			hdfr7thgr = 0.65,
			hgnujuu7thgr = true,
			fhnchvhfjsd = 0.1,
			ugtbbjhygt = 0.5,
			tfbghuugbnjhg = -0.3,
			fvrtccvghghj = Color3.fromRGB(255, 205, 185),
			jnfdhbnfcvh = 0.3234,
			fvtyghj = 10,
			ygbhnj = 0.813,
			njnfg = 5,
			jdfkd = 0.217,
			fvgsdfg = 21.54,
			sdkvkflv = 16.77,
			hbjhd = 0.277,
			shdbsnjfc = 0.364,
			skdjfkdm = 5.556,
			sjdjncdjf = Color3.fromRGB(199, 175, 166),
			efjdjfk = Color3.fromRGB(44, 39, 33),
			sejfd = 0.36,
			jddfjsd = 1.72,
			gyhgtg = 0.55,
			ygbhggv = 0.43,
			jghbjhgyfd = Color3.fromRGB(199, 175, 166)
		},
		night = {
			yfbghj = Color3.fromRGB(33, 33, 33),
			khnbfth = 3.25,
			tgvbyd = 20,
			hgyghkg = Color3.fromRGB(0, 0, 0),
			yfbhjku = Color3.fromRGB(255, 247, 237),
			ygyyfgvhbjytrt = 0.203,
			sdfcddc = 0.255,
			hyhnngtf = Color3.fromRGB(51, 54, 67),
			ghuybhuyhj = -15,
			hdfr7thgr = 0.85,
			hgnujuu7thgr = true,
			fhnchvhfjsd = -0.06,
			ugtbbjhygt = -0.02,
			tfbghuugbnjhg = -0.2,
			fvrtccvghghj = Color3.fromRGB(242, 243, 243),
			jnfdhbnfcvh = 0.34,
			fvtyghj = 10,
			ygbhnj = 0.813,
			njnfg = 5,
			jdfkd = 0.217,
			fvgsdfg = 11.54,
			sdkvkflv = 16.77,
			hbjhd = 0.277,
			shdbsnjfc = 0.264,
			skdjfkdm = 0.156,
			sjdjncdjf = Color3.fromRGB(175, 221, 255),
			efjdjfk = Color3.fromRGB(13, 105, 172),
			sejfd = 0.36,
			jddfjsd = 1.72,
			gyhgtg = 0.65,
			ygbhggv = 0.33,
			jghbjhgyfd = Color3.fromRGB(255, 255, 255)
		}
	}
	
	local function ensure_effects()
		if not bloom_effect or not bloom_effect.Parent then
			bloom_effect = lighting:FindFirstChildOfClass("BloomEffect")
			if not bloom_effect then
				bloom_effect = Instance.new("BloomEffect")
				bloom_effect.Enabled = false
				bloom_effect.Parent = lighting
				created_effects.bloom = true
			end
		end
		if not blur_effect or not blur_effect.Parent then
			blur_effect = lighting:FindFirstChildOfClass("BlurEffect")
			if not blur_effect then
				blur_effect = Instance.new("BlurEffect")
				blur_effect.Enabled = false
				blur_effect.Size = 0
				blur_effect.Parent = lighting
				created_effects.blur = true
			end
		end
		if not colorcor_effect or not colorcor_effect.Parent then
			colorcor_effect = lighting:FindFirstChildOfClass("ColorCorrectionEffect")
			if not colorcor_effect then
				colorcor_effect = Instance.new("ColorCorrectionEffect")
				colorcor_effect.Enabled = false
				colorcor_effect.Parent = lighting
				created_effects.colorcor = true
			end
		end
		if not depth_effect or not depth_effect.Parent then
			depth_effect = lighting:FindFirstChildOfClass("DepthOfFieldEffect")
			if not depth_effect then
				depth_effect = Instance.new("DepthOfFieldEffect")
				depth_effect.Enabled = false
				depth_effect.Parent = lighting
				created_effects.depth = true
			end
		end
		if not atmosphere_effect or not atmosphere_effect.Parent then
			atmosphere_effect = lighting:FindFirstChildOfClass("Atmosphere")
			if not atmosphere_effect then
				atmosphere_effect = Instance.new("Atmosphere")
				atmosphere_effect.Parent = lighting
				created_effects.atmosphere = true
			end
		end
		if workspace.Terrain and (not cloud_effect or not cloud_effect.Parent) then
			cloud_effect = workspace.Terrain:FindFirstChildOfClass("Clouds")
			if not cloud_effect then
				cloud_effect = Instance.new("Clouds")
				cloud_effect.Cover = 0
				cloud_effect.Density = 0
				cloud_effect.Parent = workspace.Terrain
				created_effects.cloud = true
			end
		end
	end
	
	local function save_original_effects()
		bloom_effect = lighting:FindFirstChildOfClass("BloomEffect")
		blur_effect = lighting:FindFirstChildOfClass("BlurEffect")
		colorcor_effect = lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		depth_effect = lighting:FindFirstChildOfClass("DepthOfFieldEffect")
		atmosphere_effect = lighting:FindFirstChildOfClass("Atmosphere")
		if workspace.Terrain then
			cloud_effect = workspace.Terrain:FindFirstChildOfClass("Clouds")
		end
		
		if colorcor_effect then
			original_effects.colorcor = {
				Brightness = colorcor_effect.Brightness,
				Contrast = colorcor_effect.Contrast,
				Saturation = colorcor_effect.Saturation,
				TintColor = colorcor_effect.TintColor,
				Enabled = colorcor_effect.Enabled
			}
		end
		if bloom_effect then
			original_effects.bloom = {
				Intensity = bloom_effect.Intensity,
				Size = bloom_effect.Size,
				Threshold = bloom_effect.Threshold,
				Enabled = bloom_effect.Enabled
			}
		end
		if blur_effect then
			original_effects.blur = {
				Size = blur_effect.Size,
				Enabled = blur_effect.Enabled
			}
		end
		if depth_effect then
			original_effects.depth = {
				FarIntensity = depth_effect.FarIntensity,
				FocusDistance = depth_effect.FocusDistance,
				InFocusRadius = depth_effect.InFocusRadius,
				NearIntensity = depth_effect.NearIntensity,
				Enabled = depth_effect.Enabled
			}
		end
		if atmosphere_effect then
			original_effects.atmosphere = {
				Density = atmosphere_effect.Density,
				Offset = atmosphere_effect.Offset,
				Color = atmosphere_effect.Color,
				Decay = atmosphere_effect.Decay,
				Glare = atmosphere_effect.Glare,
				Haze = atmosphere_effect.Haze
			}
		end
		if cloud_effect then
			original_effects.cloud = {
				Cover = cloud_effect.Cover,
				Density = cloud_effect.Density,
				Color = cloud_effect.Color
			}
		end
	end
	
	local shader_fog_inf = math.huge
	local shader_fog_color = Color3.fromRGB(255, 255, 255)

	local function apply_shader(shader_data)
		ensure_effects()
		local v = shader_data.yfbghj
		if lighting.Ambient ~= v then lighting.Ambient = v end
		v = shader_data.khnbfth
		if lighting.Brightness ~= v then lighting.Brightness = v end
		v = shader_data.tgvbyd
		if lighting.ClockTime ~= v then lighting.ClockTime = v end
		v = shader_data.hgyghkg
		if lighting.ColorShift_Bottom ~= v then lighting.ColorShift_Bottom = v end
		v = shader_data.yfbhjku
		if lighting.ColorShift_Top ~= v then lighting.ColorShift_Top = v end
		v = shader_data.ygyyfgvhbjytrt
		if lighting.EnvironmentDiffuseScale ~= v then lighting.EnvironmentDiffuseScale = v end
		v = shader_data.sdfcddc
		if lighting.EnvironmentSpecularScale ~= v then lighting.EnvironmentSpecularScale = v end
		v = shader_data.hyhnngtf
		if lighting.OutdoorAmbient ~= v then lighting.OutdoorAmbient = v end
		v = shader_data.ghuybhuyhj
		if lighting.GeographicLatitude ~= v then lighting.GeographicLatitude = v end
		v = shader_data.hdfr7thgr
		if lighting.ExposureCompensation ~= v then lighting.ExposureCompensation = v end
		v = shader_data.hgnujuu7thgr
		if lighting.GlobalShadows ~= v then lighting.GlobalShadows = v end
		if lighting.FogEnd ~= shader_fog_inf then lighting.FogEnd = shader_fog_inf end
		if lighting.FogColor ~= shader_fog_color then lighting.FogColor = shader_fog_color end
		if lighting.FogStart ~= shader_fog_inf then lighting.FogStart = shader_fog_inf end
		
		if colorcor_effect then
			v = shader_data.fhnchvhfjsd
			if colorcor_effect.Brightness ~= v then colorcor_effect.Brightness = v end
			v = shader_data.ugtbbjhygt
			if colorcor_effect.Contrast ~= v then colorcor_effect.Contrast = v end
			v = shader_data.tfbghuugbnjhg
			if colorcor_effect.Saturation ~= v then colorcor_effect.Saturation = v end
			v = shader_data.fvrtccvghghj
			if colorcor_effect.TintColor ~= v then colorcor_effect.TintColor = v end
			if colorcor_effect.Enabled ~= true then colorcor_effect.Enabled = true end
		end
		if bloom_effect then
			v = shader_data.jnfdhbnfcvh
			if bloom_effect.Intensity ~= v then bloom_effect.Intensity = v end
			v = shader_data.fvtyghj
			if bloom_effect.Size ~= v then bloom_effect.Size = v end
			v = shader_data.ygbhnj
			if bloom_effect.Threshold ~= v then bloom_effect.Threshold = v end
			if bloom_effect.Enabled ~= true then bloom_effect.Enabled = true end
		end
		if blur_effect then
			v = shader_data.njnfg
			if blur_effect.Size ~= v then blur_effect.Size = v end
			if blur_effect.Enabled ~= false then blur_effect.Enabled = false end
		end
		if depth_effect then
			v = shader_data.jdfkd
			if depth_effect.FarIntensity ~= v then depth_effect.FarIntensity = v end
			v = shader_data.fvgsdfg
			if depth_effect.FocusDistance ~= v then depth_effect.FocusDistance = v end
			v = shader_data.sdkvkflv
			if depth_effect.InFocusRadius ~= v then depth_effect.InFocusRadius = v end
			v = shader_data.hbjhd
			if depth_effect.NearIntensity ~= v then depth_effect.NearIntensity = v end
			if depth_effect.Enabled ~= true then depth_effect.Enabled = true end
		end
		if atmosphere_effect then
			v = shader_data.shdbsnjfc
			if atmosphere_effect.Density ~= v then atmosphere_effect.Density = v end
			v = shader_data.skdjfkdm
			if atmosphere_effect.Offset ~= v then atmosphere_effect.Offset = v end
			v = shader_data.sjdjncdjf
			if atmosphere_effect.Color ~= v then atmosphere_effect.Color = v end
			v = shader_data.efjdjfk
			if atmosphere_effect.Decay ~= v then atmosphere_effect.Decay = v end
			v = shader_data.sejfd
			if atmosphere_effect.Glare ~= v then atmosphere_effect.Glare = v end
			v = shader_data.jddfjsd
			if atmosphere_effect.Haze ~= v then atmosphere_effect.Haze = v end
		end
		if cloud_effect then
			v = shader_data.gyhgtg
			if cloud_effect.Cover ~= v then cloud_effect.Cover = v end
			v = shader_data.ygbhggv
			if cloud_effect.Density ~= v then cloud_effect.Density = v end
			v = shader_data.jghbjhgyfd
			if cloud_effect.Color ~= v then cloud_effect.Color = v end
		end
	end
	
	local function restore_original()
		if original_effects.colorcor and colorcor_effect then
			for prop, value in pairs(original_effects.colorcor) do
				colorcor_effect[prop] = value
			end
		elseif created_effects.colorcor and colorcor_effect then
			colorcor_effect:Destroy()
			colorcor_effect = nil
			created_effects.colorcor = nil
		end
		if original_effects.bloom and bloom_effect then
			for prop, value in pairs(original_effects.bloom) do
				bloom_effect[prop] = value
			end
		elseif created_effects.bloom and bloom_effect then
			bloom_effect:Destroy()
			bloom_effect = nil
			created_effects.bloom = nil
		end
		if original_effects.blur and blur_effect then
			for prop, value in pairs(original_effects.blur) do
				blur_effect[prop] = value
			end
		elseif created_effects.blur and blur_effect then
			blur_effect:Destroy()
			blur_effect = nil
			created_effects.blur = nil
		end
		if original_effects.depth and depth_effect then
			for prop, value in pairs(original_effects.depth) do
				depth_effect[prop] = value
			end
		elseif created_effects.depth and depth_effect then
			depth_effect:Destroy()
			depth_effect = nil
			created_effects.depth = nil
		end
		if original_effects.atmosphere and atmosphere_effect then
			for prop, value in pairs(original_effects.atmosphere) do
				atmosphere_effect[prop] = value
			end
		elseif created_effects.atmosphere and atmosphere_effect then
			atmosphere_effect:Destroy()
			atmosphere_effect = nil
			created_effects.atmosphere = nil
		end
		if original_effects.cloud and cloud_effect then
			for prop, value in pairs(original_effects.cloud) do
				cloud_effect[prop] = value
			end
		elseif created_effects.cloud and cloud_effect then
			cloud_effect:Destroy()
			cloud_effect = nil
			created_effects.cloud = nil
		end
	end

    local ambience_enabled = false
    local ambience_style = "morning"

    local function setAmbience(enabled)
        ambience_enabled = enabled
        if enabled then
            local data = shaders[ambience_style]
            if data then
                apply_shader(data)
            end
        else
            restore_original()
        end
    end

    VisualsTab._left:Divider()
    VisualsTab._left:Paragraph({
        Title = "Ambience",
        Content = "Lighting and atmosphere presets"
    })

    VisualsTab._left:Toggle({
        Flag = "ambience_enabled",
        Title = "Enable Ambience",
        Description = "Apply the selected lighting preset",
        Default = false,
        Callback = function(state)
            setAmbience(state)
        end,
    })

    VisualsTab._left:Dropdown({
        Flag = "ambience_style",
        Title = "Ambience Style",
        Values = {"morning", "midday", "evening", "night"},
        Value = "morning",
        Callback = function(value)
            ambience_style = value
            if ambience_enabled then
                setAmbience(true)
            end
        end,
    })
end
-- ============================================================
-- END AMBIENCE SYSTEM
-- ============================================================

-- ── COMBAT column (left) ──────────────────────────────────────
v301._left:Paragraph({ Title = 'Combat Buttons' })

    local t27 = {
        Flag = "show_gold_bomb",
        Title = 'Show Gold Bomb',
        Default = false,
    }
    local u304 = v232

    function t27.Callback(p56)
        u304(p56)
    end

    v301._left:Toggle(t27)

    local t28 = {
        Flag = "show_normal_bomb",
        Title = 'Show Normal Bomb',
        Default = false,
    }
    local u306 = v239

    function t28.Callback(p57)
        u306(p57)
    end

    v301._left:Toggle(t28)

    local t29 = {
        Flag = "show_shoot_throw",
        Title = 'Show Shoot/Throw',
        Default = false,
    }
    local u308 = v244

    function t29.Callback(p58)
        u308(p58)
    end

    v301._left:Toggle(t29)
end

v301._left:Toggle({
    Flag = "load_grab_gun", Title = 'Load Grab Gun',
    Default = false,
    Callback = function(p61) u276(p61) end,
})

v301._left:Toggle({
    Flag = "auto_ping_prediction",
    Title = 'Auto Ping Prediction',
    Description = 'Adds ping offset to shoot and throw',
    Default = false,
    Callback = function(p75)
        u13 = p75
        v18:Notify({
            Title = 'CrystalHub',
            Content = p75 and 'Ping Prediction ON' or 'Ping Prediction OFF',
            Duration = 3, Icon = 'bell',
        })
    end,
})

-- ── WALLBANG (FORCE SHOOT) ────────────────────────────────────
do
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local collection = game:GetService("CollectionService")
local stats = game:GetService("Stats")
local lp = players.LocalPlayer

-- ==== НАСТРОЙКИ ====
local S = {
    enabled = false,
    predict = true,
    force = true,
    auto_on = false,
    auto_delay = 0,
    am_sheriff = false,
    fire_gap = 0,
    last_shot = 0,
    stand_off = 3,
}

local MAX_RANGE = 300

-- ==== ТРЕЙС ====
local ray_params = RaycastParams.new()
ray_params.FilterType = Enum.RaycastFilterType.Exclude
ray_params.IgnoreWater = false

local ignore_base, ignore_work = {}, {}
local ignore_time = 0

local function refresh_ignore()
    local now = os.clock()
    if #ignore_base > 0 and now - ignore_time < 0.5 then return end
    ignore_time = now
    table.clear(ignore_base)
    local char = lp.Character
    if char then ignore_base[1] = char end
    local ok, tagged = pcall(function() return collection:GetTagged("WeaponPassthrough") end)
    if ok and type(tagged) == "table" then
        for k = 1, #tagged do ignore_base[#ignore_base + 1] = tagged[k] end
    end
end

local function trace(origin, direction)
    refresh_ignore()
    table.clear(ignore_work)
    for k = 1, #ignore_base do ignore_work[k] = ignore_base[k] end
    local result = nil
    for _ = 1, 6 do
        ray_params.FilterDescendantsInstances = ignore_work
        result = workspace:Raycast(origin, direction, ray_params)
        if not result then break end
        local inst = result.Instance
        if not inst then break end
        local ok, tr = pcall(function() return inst.Transparency end)
        if not ok or tr ~= 1 then break end
        ignore_work[#ignore_work + 1] = inst
    end
    return result
end

local function gun_attachment()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    return hrp:FindFirstChild("GunRaycastAttachment"), hrp
end

local function origin_cframe()
    local att, hrp = gun_attachment()
    if att then return att.WorldCFrame end
    if hrp then return hrp.CFrame end
    return nil
end

local function grav()
    local ok, g = pcall(function() return workspace.Gravity end)
    if ok and type(g) == "number" and g > 0 then return g end
    return 0
end

-- ==== ТРЕКИНГ ЦЕЛИ ====
local target_player, target_char, target_part, target_hum = nil, nil, nil, nil
local round_mod = nil

local function get_round()
    if round_mod then return round_mod end
    local ok, m = pcall(function()
        return require(rs:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))
    end)
    if ok and type(m) == "table" then round_mod = m end
    return round_mod
end

local function holds(container, name)
    return container ~= nil and container:FindFirstChild(name) ~= nil
end

local function lp_has_gun()
    return holds(lp.Character, "Gun") or holds(lp:FindFirstChildOfClass("Backpack"), "Gun")
end

local function refresh_target()
    local found = nil
    local m = get_round()
    local data = m and m.PlayerData or nil
    if type(data) == "table" then
        local me = data[lp.Name]
        S.am_sheriff = (me ~= nil and (me.Role == "Sheriff" or me.Role == "Hero")) or lp_has_gun()
        for name, d in pairs(data) do
            if type(d) == "table" and d.Role == "Murderer" and not d.Dead then
                found = players:FindFirstChild(name)
                break
            end
        end
    else
        S.am_sheriff = lp_has_gun()
    end
    if not found then
        for _, plr in ipairs(players:GetPlayers()) do
            if plr ~= lp and holds(plr.Character, "Knife") then
                found = plr
                break
            end
        end
    end
    if found ~= target_player then
        target_player = found
        target_char = nil
        target_part = nil
        target_hum = nil
    end
    if not found then return end
    local char = found.Character
    if char ~= target_char then
        target_char = char
        target_part = nil
        target_hum = nil
    end
    if not char then return end
    if not target_part or not target_part.Parent then
        target_part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end
    if not target_hum or not target_hum.Parent then
        target_hum = char:FindFirstChildOfClass("Humanoid")
    end
end

local function target_alive()
    if not target_part or not target_part.Parent then return false end
    if not target_hum or not target_hum.Parent then return false end
    return target_hum.Health > 0
end

-- ==== ПРЕДИКЦИЯ (снапшоты, фит, кинематика) ====
local P = {
    snap = 48,
    ring = 48,
    hit_r = 2.1,
    pad = 2.6,
    min_span = 5,
    max_span = 90,
    acc_t = 0.15,
    acc_max = 280,
    acc_min = 40,
    speed_floor = 26,
    speed_head = 1.3,
}

local snap_t = table.create(P.snap, 0)
local snap_p = table.create(P.snap, Vector3.zero)
local snap_n = 0
local snap_i = 0

local TR = {
    part = nil, pos = nil, time = 0, vel = Vector3.zero, gap = 0,
    ready = false, fresh = Vector3.zero, air = false, air_since = 0,
    jumping = false, jump_v = 0, fresh_ok = false, turn = 0,
    spoof = 0, clr = 0, air_edge = 0, jump_fresh = false,
}

local SK = {
    vt = table.create(P.ring, 0), dx = table.create(P.ring, 0),
    dz = table.create(P.ring, 0), vn = 0, vi = 0,
}

local EC = { ping = 0, rtt = 0, jitter = 0, seen = false, step = 0, step_seen = false }

local function step_push(dt)
    if dt <= 0 or dt > 0.5 then return end
    if EC.step_seen then EC.step = EC.step * 0.85 + dt * 0.15
    else EC.step = dt; EC.step_seen = true end
end

local function sample_span()
    local span = math.max(EC.step, TR.gap)
    if span <= 0 then return 0 end
    return span
end

local ground_params = RaycastParams.new()
ground_params.FilterType = Enum.RaycastFilterType.Exclude
ground_params.IgnoreWater = true
local ground_filter = {}

local function ground_below(pos, reach)
    table.clear(ground_filter)
    local n = 0
    local char = target_char
    if char then n = n + 1; ground_filter[n] = char end
    local mine = lp.Character
    if mine then n = n + 1; ground_filter[n] = mine end
    ground_params.FilterDescendantsInstances = ground_filter
    local res = workspace:Raycast(pos, Vector3.new(0, -reach, 0), ground_params)
    if res then return res.Position.Y end
    return nil
end

local function snap_push(now, pos)
    snap_i = snap_i % P.snap + 1
    snap_t[snap_i] = now; snap_p[snap_i] = pos
    if snap_n < P.snap then snap_n = snap_n + 1 end
end

local function snap_get(k)
    local idx = (snap_i - k - 1) % P.snap + 1
    return snap_t[idx], snap_p[idx]
end

local function fit_velocity()
    if snap_n < 3 then return nil end
    local newest = snap_get(0)
    local used = 0; local sum_d = 0
    local win = sample_span() * 4
    for k = 0, snap_n - 1 do
        local t = snap_get(k)
        if newest - t > win then break end
        used = used + 1; sum_d = sum_d + t - newest
    end
    if used < 3 then return nil end
    local mean_d = sum_d / used
    local num = Vector3.zero; local den = 0
    for k = 0, used - 1 do
        local t, p = snap_get(k)
        local d = t - newest - mean_d
        num = num + p * d; den = den + d * d
    end
    if den < 1e-8 then return nil end
    return num / den, -mean_d
end

local function recent_velocity()
    if snap_n < 2 then return nil end
    local newest, head = snap_get(0)
    local fallback, fallback_age = nil, nil
    local target_span = sample_span() * 2
    local max_span = target_span * 2
    for k = 1, snap_n - 1 do
        local t, p = snap_get(k)
        local dt = newest - t
        if dt > max_span then break end
        if dt > 0 then
            fallback = (head - p) / dt; fallback_age = dt * 0.5
            if dt >= target_span then return fallback, fallback_age end
        end
    end
    return fallback, fallback_age
end

local KIN = { ok = false, ax = 0, az = 0, smax = 0 }

local function kin_clear() KIN.ok = false; KIN.ax = 0; KIN.az = 0; KIN.smax = 0 end

local function fit_kin()
    if snap_n < 5 then return nil end
    local t0 = snap_get(0)
    local win = math.max(sample_span() * 5, 0.12)
    local scale = win
    local n, s1, s2, s3, s4 = 0, 0, 0, 0, 0
    local bx0, bx1, bx2 = 0, 0, 0; local bz0, bz1, bz2 = 0, 0, 0
    for k = 0, snap_n - 1 do
        local t, p = snap_get(k)
        local age = t0 - t
        if age > win then break end
        local u = -age / scale; local u2 = u * u
        n = n + 1; s1 = s1 + u; s2 = s2 + u2; s3 = s3 + u2 * u; s4 = s4 + u2 * u2
        bx0 = bx0 + p.X; bx1 = bx1 + p.X * u; bx2 = bx2 + p.X * u2
        bz0 = bz0 + p.Z; bz1 = bz1 + p.Z * u; bz2 = bz2 + p.Z * u2
    end
    if n < 5 then return nil end
    local det = n * (s2 * s4 - s3 * s3) - s1 * (s1 * s4 - s3 * s2) + s2 * (s1 * s3 - s2 * s2)
    if math.abs(det) < 1e-9 then return nil end
    local function solve(b0, b1, b2)
        local d1 = n * (b1 * s4 - s3 * b2) - b0 * (s1 * s4 - s3 * s2) + s2 * (s1 * b2 - b1 * s2)
        local d2 = n * (s2 * b2 - b1 * s3) - s1 * (s1 * b2 - b1 * s2) + b0 * (s1 * s3 - s2 * s2)
        return d1 / det, d2 / det
    end
    local cx1, cx2 = solve(bx0, bx1, bx2)
    local cz1, cz2 = solve(bz0, bz1, bz2)
    local vx, vz = cx1 / scale, cz1 / scale
    local ax, az = 2 * cx2 / (scale * scale), 2 * cz2 / (scale * scale)
    if vx ~= vx or vz ~= vz or ax ~= ax or az ~= az then return nil end
    return Vector3.new(vx, 0, vz), Vector3.new(ax, 0, az)
end

local function kin_update()
    local kv, ka = fit_kin()
    if not kv then KIN.ok = false; KIN.ax = 0; KIN.az = 0; return nil end
    KIN.ok = true
    local sp = math.sqrt(kv.X * kv.X + kv.Z * kv.Z)
    if sp > KIN.smax then KIN.smax = sp else KIN.smax = KIN.smax * 0.985 + sp * 0.015 end
    if ka and not TR.air then
        local am = math.sqrt(ka.X * ka.X + ka.Z * ka.Z)
        local ax, az = ka.X, ka.Z
        if am > P.acc_max and am > 0 then ax = ax * P.acc_max / am; az = az * P.acc_max / am end
        KIN.ax = KIN.ax * 0.5 + ax * 0.5; KIN.az = KIN.az * 0.5 + az * 0.5
    else KIN.ax = KIN.ax * 0.5; KIN.az = KIN.az * 0.5 end
    return kv
end

local function snap_vel(k)
    local t0, p0 = snap_get(k); local t1, p1 = snap_get(k + 1)
    local d = t0 - t1
    if d <= 0 then return nil end
    return (p0 - p1) / d, d
end

local function vert_accel()
    if snap_n < 3 then return nil end
    local v0, d0 = snap_vel(0); local v1, d1 = snap_vel(1)
    if not v0 or not v1 then return nil end
    local span = (d0 + d1) * 0.5
    if span <= 1e-4 then return nil end
    return (v0.Y - v1.Y) / span
end

local function air_vy()
    if snap_n < 2 then return nil end
    local edge = TR.air_edge
    if edge <= 0 then return nil end
    local g = grav()
    local newest, head = snap_get(0)
    local want = sample_span() * 2
    local best = nil
    for k = 1, snap_n - 1 do
        local t, p = snap_get(k)
        if t < edge then break end
        local dt = newest - t
        if dt > 1e-4 then
            best = (head.Y - p.Y) / dt - 0.5 * g * dt
            if dt >= want then break end
        end
    end
    return best
end

local function body_clearance()
    local part = target_part; local hum = target_hum
    if not part or not hum then return 0 end
    local ok, value = pcall(function() return part.Size.Y * 0.5 + hum.HipHeight end)
    if ok and type(value) == "number" and value > 0 then return value end
    return 0
end

local GC = { base = 0, seen = false }
local JL = { v = 0, seen = false }

local function stand_clearance()
    if GC.seen then return GC.base end
    return body_clearance()
end

local function engine_vel(part)
    local ok, v = pcall(function() return part.AssemblyLinearVelocity end)
    if not ok or typeof(v) ~= "Vector3" then
        ok, v = pcall(function() return part.Velocity end)
    end
    if not ok or typeof(v) ~= "Vector3" then return nil end
    if v.Magnitude ~= v.Magnitude then return nil end
    return v
end

local function vel_trust(pv, ev)
    if not pv or not ev then return 0 end
    local ph = Vector3.new(pv.X, 0, pv.Z); local eh = Vector3.new(ev.X, 0, ev.Z)
    local pm, em = ph.Magnitude, eh.Magnitude
    if pm < 1 and em < 1 then return 1 end
    if pm < 1 or em < 1 then return 0 end
    local ratio = em / pm
    if ratio > 1.5 or ratio < 0.6 then return 0 end
    local align = ph.Unit:Dot(eh.Unit)
    if align < 0.7 then return 0 end
    local a = math.clamp((align - 0.7) / 0.25, 0, 1)
    local r = 1 - math.clamp(math.abs(ratio - 1) / 0.4, 0, 1)
    return a * r
end

local function phase_velocity(v, age, air)
    if not v then return nil end
    local y = 0
    if air then y = v.Y - grav() * math.clamp(age or 0, 0, sample_span() * 4) end
    return Vector3.new(v.X, y, v.Z)
end

local function merge_vel(fit, fit_age, fast, fast_age, engine, engine_age, air)
    local stable = phase_velocity(fit, fit_age, air)
    local instant = phase_velocity(fast, fast_age, air)
    local turn = 0
    if stable and instant then
        local sh = Vector3.new(stable.X, 0, stable.Z); local ih = Vector3.new(instant.X, 0, instant.Z)
        if sh.Magnitude > 1 and ih.Magnitude > 1 then
            turn = math.acos(math.clamp(sh.Unit:Dot(ih.Unit), -1, 1)) / math.pi
        end
    end
    local base = instant or stable
    if not base then return Vector3.zero, 0, nil, 0 end
    if stable and instant then
        local agility = math.clamp(turn * 2.2, 0, 1)
        base = stable:Lerp(instant, 0.4 + 0.6 * agility)
    end
    local trust = 0
    if engine then
        local live = phase_velocity(engine, engine_age, air)
        trust = vel_trust(base, live)
        if trust > 0 and air then
            base = Vector3.new(base.X, base.Y, base.Z):Lerp(Vector3.new(base.X, live.Y, base.Z), trust * 0.35)
        end
    end
    return base, turn, instant or stable, trust
end

local function vel_push(now, hx, hz)
    SK.vi = SK.vi % P.ring + 1
    SK.vt[SK.vi] = now; SK.dx[SK.vi] = hx; SK.dz[SK.vi] = hz
    if SK.vn < P.ring then SK.vn = SK.vn + 1 end
end

local function track_clear()
    TR.part = nil; TR.pos = nil; TR.vel = Vector3.zero; TR.gap = 0
    TR.ready = false; TR.fresh = Vector3.zero; TR.air = false
    TR.jumping = false; TR.jump_v = 0; TR.fresh_ok = false; TR.turn = 0
    TR.spoof = 0; TR.clr = 0; TR.air_edge = 0; TR.jump_fresh = false
    GC.base = 0; GC.seen = false; JL.v = 0; JL.seen = false
    snap_n = 0; snap_i = 0; SK.vn = 0; SK.vi = 0
    kin_clear()
end

local function track_seed(part, pos, now)
    TR.part = part; TR.pos = pos; TR.time = now; TR.vel = Vector3.zero
    TR.fresh = Vector3.zero; TR.fresh_ok = false; TR.turn = 0
    TR.jump_v = 0; TR.gap = 0; TR.ready = false; TR.spoof = 0
    TR.air_edge = 0; TR.jump_fresh = false
    GC.base = 0; GC.seen = false
    snap_n = 0; snap_i = 0
    kin_clear()
    snap_push(now, pos)
end

local function track_fresh(now)
    local part = target_part
    if not part or not part.Parent then TR.fresh_ok = false; return end
    local pos = part.Position
    local g = grav()
    local sv = snap_vel(0)
    local vy = sv and sv.Y or 0
    local accel = vert_accel()
    local falling = accel ~= nil and accel < -g * 0.5
    local guess = stand_clearance()
    local reach = guess + 6 + math.abs(vy) * sample_span() * 4
    local air
    local gy = ground_below(pos, reach)
    if gy then
        local clr = pos.Y - gy
        TR.clr = clr
        if math.abs(vy) < 1 and not falling then
            if GC.seen then
                if clr < GC.base then GC.base = GC.base * 0.7 + clr * 0.3
                else GC.base = GC.base * 0.98 + clr * 0.02 end
            else GC.base = clr; GC.seen = true end
        end
        local floor = GC.seen and GC.base or guess
        local tol = math.max(floor * 0.35, 1)
        air = clr > floor + tol
        if not air and falling and math.abs(vy) > 4 and clr > floor + 0.35 then air = true end
    else air = true end
    if air ~= TR.air then
        TR.air_edge = now
        if air then
            TR.air_since = now; TR.jump_fresh = true
            TR.jump_v = JL.seen and JL.v or math.max(vy, 0)
        else TR.jump_fresh = false; TR.jump_v = 0 end
    end
    TR.air = air
    TR.jumping = air and (vy > 1 or (TR.jump_v - g * math.max(0, now - TR.air_since)) > 1)
end

local function track(now)
    local part = target_part
    if not part or not part.Parent then if TR.part then track_clear() end; return end
    track_fresh(now)
    local pos = part.Position
    if part ~= TR.part or not TR.pos then track_seed(part, pos, now); return end
    local dt = now - TR.time
    if dt > 0.75 or (pos - TR.pos).Magnitude > 140 then track_seed(part, pos, now); return end
    if dt <= 0 then return end
    if (pos - TR.pos).Magnitude == 0 then
        if TR.gap > 0 and dt >= TR.gap then TR.vel = Vector3.zero; TR.fresh = Vector3.zero end
        return
    end
    step_push(dt); TR.gap = dt
    snap_push(now, pos); TR.pos = pos; TR.time = now
    local fit, fit_age = fit_velocity()
    local fast, fast_age = recent_velocity()
    local engine = engine_vel(part)
    local fresh, turn, instant, trust = merge_vel(fit, fit_age, fast, fast_age, engine, sample_span() * 0.5, TR.air)
    local kv = kin_update()
    if kv then fresh = Vector3.new(kv.X, fresh.Y, kv.Z) end
    if engine and trust <= 0 then
        if TR.spoof < 20 then TR.spoof = TR.spoof + 1 end
    elseif TR.spoof > 0 then TR.spoof = TR.spoof - 1 end
    if TR.air then
        local vy = air_vy()
        if vy then
            fresh = Vector3.new(fresh.X, vy, fresh.Z)
            local since = math.max(0, now - TR.air_edge)
            if TR.jump_fresh and since <= 0.2 then
                local impulse = vy + grav() * since
                if impulse > 1 then
                    if JL.seen then JL.v = JL.v * 0.7 + impulse * 0.3
                    else JL.v = impulse; JL.seen = true end
                    if impulse > TR.jump_v then TR.jump_v = impulse end
                end
            else TR.jump_fresh = false end
        end
    end
    TR.vel = fresh; TR.ready = fit ~= nil or fast ~= nil
    TR.fresh = TR.vel; TR.fresh_ok = TR.ready; TR.turn = turn
    local raw = instant or fresh
    vel_push(now, raw.X, raw.Z)
end

-- ==== ПИНГ ====
local function raw_rtt()
    local a, b
    local ok, ms = pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    if ok and type(ms) == "number" and ms == ms and ms > 4 and ms < 800 then a = ms / 1000 end
    local fine, value = pcall(function() return lp:GetNetworkPing() end)
    if fine and type(value) == "number" and value == value and value > 0 then
        local rtt = value * 2
        if rtt > 0.004 and rtt < 0.8 then b = rtt end
    end
    if a and b then return (a + b) * 0.5 end
    return a or b
end

local function sample_ping()
    local rtt = raw_rtt()
    if not rtt or rtt ~= rtt then return end
    rtt = math.clamp(rtt, 0, 1)
    if EC.seen then
        EC.jitter = EC.jitter * 0.9 + math.abs(rtt - EC.rtt) * 0.1
        EC.rtt = EC.rtt * 0.82 + rtt * 0.18
    else EC.rtt = rtt; EC.jitter = 0; EC.seen = true end
    EC.ping = EC.rtt
end

local function lead_time()
    if not EC.seen then return 0 end
    local stale = 0
    if TR.time > 0 and EC.step_seen then
        stale = math.clamp(os.clock() - TR.time, 0, EC.step)
    end
    return math.clamp(EC.rtt + EC.jitter * 0.5 + stale, 0, 1)
end

local function rotate_y(v, ang)
    local c, s = math.cos(ang), math.sin(ang)
    return Vector3.new(v.X * c - v.Z * s, v.Y, v.X * s + v.Z * c)
end

local function dir_stats(win)
    if SK.vn < 4 then return 1, 0 end
    win = math.max(win, sample_span() * 3)
    local newest = SK.vt[SK.vi]
    local sx, sz, n = 0, 0, 0
    local prev = nil; local turn, turn_n = 0, 0; local oldest = newest
    for k = 0, SK.vn - 1 do
        local idx = (SK.vi - k - 1) % P.ring + 1
        local t = SK.vt[idx]
        if newest - t > win then break end
        local hx, hz = SK.dx[idx], SK.dz[idx]
        local m = math.sqrt(hx * hx + hz * hz)
        if m > 0 then
            sx = sx + hx / m; sz = sz + hz / m; n = n + 1
            local ang = math.atan2(hz, hx)
            if prev then
                local d = ang - prev
                while d > math.pi do d = d - 6.2831853 end
                while d < -math.pi do d = d + 6.2831853 end
                turn = turn + d; turn_n = turn_n + 1
            end
            prev = ang; oldest = t
        end
    end
    if n < 2 then return 1, 0 end
    local coh = math.clamp(math.sqrt(sx * sx + sz * sz) / n, 0, 1)
    local omega = 0
    local elapsed = newest - oldest
    if turn_n >= 1 and elapsed > 1e-3 then omega = -turn / elapsed end
    return coh, omega
end

-- ==== ПРЕДИКЦИЯ ТОЧКИ ====
local function predict_from(base, sa, sb, fh, now)
    local span = math.max(0, sa + sb)
    local g = grav()
    local dir = fh
    if dir.Magnitude == 0 then dir = Vector3.new(TR.vel.X, 0, TR.vel.Z) end
    local x, z
    if span > 0 and KIN.ok then
        local age = math.clamp(now - TR.time, 0, sample_span() * 2)
        local ax, az = KIN.ax, KIN.az
        if TR.air or math.sqrt(ax * ax + az * az) < P.acc_min then ax, az = 0, 0 end
        local vx = dir.X + ax * age; local vz = dir.Z + az * age
        local ta = math.min(span, P.acc_t)
        local dx = vx * span + 0.5 * ax * ta * ta
        local dz = vz * span + 0.5 * az * ta * ta
        local reach = math.sqrt(dx * dx + dz * dz)
        local cap = math.max(KIN.smax * P.speed_head, P.speed_floor) * span
        if reach > cap and reach > 1e-6 then dx = dx * cap / reach; dz = dz * cap / reach end
        x = base.X + dx; z = base.Z + dz
    else
        local hspan = span
        if span > 0 and dir.Magnitude > 0 and not TR.air then
            local coh, omega = dir_stats(span)
            local conf = math.clamp(coh, 0, 1) * (1 - math.clamp(TR.turn, 0, 1) * 0.5)
            if omega ~= 0 then
                dir = rotate_y(dir, math.clamp(omega * span * 0.5 * conf, -0.6, 0.6))
            end
            hspan = span * (0.85 + 0.15 * conf)
        end
        x = base.X + dir.X * hspan; z = base.Z + dir.Z * hspan
    end
    local y = base.Y
    if TR.air and span > 0 then
        local vy = TR.vel.Y
        local phase = math.max(0, now - TR.air_since)
        local modeled = TR.jump_v - g * phase
        if TR.jumping and TR.jump_v > 0 and g > 0 and phase <= TR.jump_v / g and modeled > vy then vy = modeled end
        y = base.Y + vy * span - 0.5 * g * span * span
        if y < base.Y then
            local clearance = stand_clearance()
            local reach = base.Y - y + clearance
            local gy = ground_below(Vector3.new(x, base.Y, z), reach)
            if gy then
                local floor = gy + clearance
                if y < floor then y = floor end
            end
        end
    end
    return Vector3.new(x, y, z)
end

-- ==== ГИПОТЕЗЫ ====
local HY = { pos = {}, w = {}, n = 0, weight = 0, primary = nil, stamp = 0, conf = 0 }

local function build_hyps(base, now)
    table.clear(HY.pos); table.clear(HY.w)
    local horizon = S.predict and TR.ready and lead_time() or 0
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    HY.primary = predict_from(base, 0, horizon, fh, now)
    HY.n = 1; HY.pos[1] = HY.primary; HY.w[1] = 1; HY.weight = 1; HY.stamp = now
end

local function score_axis(anchor, axis)
    local covered = 0; local lo, hi = 0, 0
    for k = 1, HY.n do
        local d = HY.pos[k] - anchor
        local a = d:Dot(axis)
        local perp = (d - axis * a).Magnitude
        if perp <= P.hit_r then
            covered = covered + HY.w[k]
            if a < lo then lo = a end
            if a > hi then hi = a end
        end
    end
    return covered, lo, hi
end

local axis_pool = {}

local function corridor_axes(anchor)
    table.clear(axis_pool)
    local n = 0
    local function add(v)
        if typeof(v) ~= "Vector3" or v.Magnitude < 1e-4 then return end
        local u = v.Unit
        for k = 1, n do if axis_pool[k]:Dot(u) > 0.985 then return end end
        n = n + 1; axis_pool[n] = u
    end
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    if TR.air then add(TR.fresh) end
    add(fh)
    for k = 1, HY.n do add(HY.pos[k] - anchor) end
    add(TR.fresh); add(Vector3.new(0, 1, 0))
    return n
end

local function build_corridor(now)
    local part = target_part
    if not part or not part.Parent then return nil end
    local base = part.Position
    build_hyps(base, now)
    local anchor = HY.primary or base
    local count = corridor_axes(anchor)
    local best_axis, best_cov, best_lo, best_hi = nil, -1, 0, 0
    for k = 1, count do
        local axis = axis_pool[k]
        local cov, lo, hi = score_axis(anchor, axis)
        if cov > best_cov then best_axis, best_cov, best_lo, best_hi = axis, cov, lo, hi end
    end
    if not best_axis then return nil end
    HY.conf = HY.weight > 0 and best_cov / HY.weight or 0
    local pad = P.pad
    local origin = anchor + best_axis * (best_lo - pad)
    local aim = anchor + best_axis * (best_hi + pad)
    if (aim - origin).Magnitude < 4 then origin = anchor - best_axis * 4; aim = anchor + best_axis * 4 end
    return origin, aim, HY.conf, anchor
end

local pred_off = Vector3.zero
local pred_stamp = 0

local function lead_offset()
    local part = target_part
    if not part or not part.Parent then return Vector3.zero end
    if not S.predict or not TR.ready then return Vector3.zero end
    local base = part.Position
    local now = os.clock()
    local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    local point = predict_from(base, 0, lead_time(), fh, now)
    local off = point - base
    pred_stamp = now; pred_off = off
    return pred_off
end

-- ==== LOS / AIM ====
local function los_clear(origin, point)
    if not origin or not point then return false end
    local delta = point - origin
    local dist = delta.Magnitude
    if dist < 0.5 then return true end
    if dist > MAX_RANGE then return false end
    local hit = trace(origin, delta)
    if not hit then return true end
    local inst = hit.Instance
    local char = target_char
    if inst and char and (inst == char or inst:IsDescendantOf(char)) then return true end
    return (hit.Position - origin).Magnitude >= dist - 0.75
end

local hit_names = {
    "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso", "Head",
    "RightUpperArm", "LeftUpperArm", "Right Arm", "Left Arm",
    "RightUpperLeg", "LeftUpperLeg", "Right Leg", "Left Leg",
    "RightLowerLeg", "LeftLowerLeg",
}

local hit_parts = {}
local hit_count = 0
local hit_char = nil

local function refresh_parts()
    local char = target_char
    if char == hit_char then return end
    table.clear(hit_parts); hit_count = 0; hit_char = char
    if not char then return end
    for k = 1, #hit_names do
        local part = char:FindFirstChild(hit_names[k])
        if part and part:IsA("BasePart") then hit_count = hit_count + 1; hit_parts[hit_count] = part end
    end
end

local function pick_point(origin, strict)
    refresh_parts()
    if hit_count == 0 then return nil end
    local off = lead_offset()
    local first = nil
    for k = 1, hit_count do
        local part = hit_parts[k]
        if not part.Parent then hit_char = nil
        else
            local point = part.Position + off
            if not origin then return point end
            if not first then first = point end
            if los_clear(origin, point) then return point end
        end
    end
    if strict then return nil end
    return first
end

-- ==== FORCE / WALLBANG ====
local force_att = nil
local force_saved = nil
local force_stamp = 0

local function restore_origin()
    local att = force_att
    if not att then return end
    local saved = force_saved
    force_att = nil; force_saved = nil
    if saved then pcall(function() if att.Parent then att.CFrame = saved end end) end
end

local function push_origin(cf)
    local att = gun_attachment()
    if not att then return false end
    if force_att and force_att ~= att then restore_origin() end
    if not force_att then
        local ok, saved = pcall(function() return att.CFrame end)
        if not ok or typeof(saved) ~= "CFrame" then return false end
        force_att = att; force_saved = saved
    end
    force_stamp = os.clock()
    local ok = pcall(function() att.WorldCFrame = cf end)
    if not ok then restore_origin(); return false end
    task.defer(restore_origin)
    return true
end

local function is_target_hit(inst)
    local char = target_char
    if not inst or not char then return false end
    return inst == char or inst:IsDescendantOf(char)
end

local function force_clear(origin, aim)
    local hit = trace(origin, aim - origin)
    if not hit then return false end
    return is_target_hit(hit.Instance)
end

local function force_velocity()
    if TR.fresh_ok and TR.fresh.Magnitude > 0.5 then return TR.fresh end
    if TR.ready and TR.vel.Magnitude > 0.5 then return TR.vel end
    return Vector3.zero
end

local function resolve_force()
    local part = target_part
    if not part or not part.Parent then return nil end
    local live = part.Position
    local now = os.clock()
    local origin, aim, conf, anchor = build_corridor(now)
    if origin and aim then
        local axis = aim - origin
        local span = axis.Magnitude
        if span > 1e-3 then
            local u = axis / span
            local mark = anchor or live
            local behind = (mark - origin):Dot(u)
            if behind < P.pad then origin = origin - u * (P.pad - behind) end
            local ahead = (aim - mark):Dot(u)
            if ahead < P.min_span then aim = mark + u * P.min_span end
            local want = S.stand_off
            while want > 0 do
                local probe = origin - u * want
                if (aim - probe).Magnitude <= P.max_span
                    and los_clear(probe, mark)
                    and los_clear(probe, live) then
                    origin = probe; break
                end
                want = want - 3
            end
            if (aim - origin).Magnitude > P.max_span then origin = aim - u * P.max_span end
            return CFrame.new(origin, aim), CFrame.new(aim), conf or 0, mark
        end
    end
    local vel = force_velocity()
    local dir = Vector3.new(0, -1, 0)
    if vel.Magnitude > 3 then dir = vel.Unit
    else
        local mine = origin_cframe()
        if mine then
            local delta = live - mine.Position
            if delta.Magnitude > 2 then dir = delta.Unit end
        end
    end
    local back = live - dir * 6
    local front = live + dir * math.max(P.min_span, vel.Magnitude * lead_time() + 8)
    if not force_clear(back, front) then back = live - dir * 2.5 end
    return CFrame.new(back, front), CFrame.new(front), 0, live
end

local function shot_shift(dt)
    if not S.predict or not TR.ready or dt <= 0 then return Vector3.zero end
    local shift = Vector3.new(TR.vel.X * dt, 0, TR.vel.Z * dt)
    if TR.air then
        local g = grav()
        local horizon = lead_time()
        local vy = TR.vel.Y
        local phase = math.max(0, os.clock() - TR.air_since)
        local modeled = TR.jump_v - g * phase
        if TR.jumping and TR.jump_v > 0 and g > 0 and phase <= TR.jump_v / g and modeled > vy then vy = modeled end
        shift = Vector3.new(shift.X, vy * dt - g * horizon * dt - 0.5 * g * dt * dt, shift.Z)
    end
    return shift
end

local function compensate_force(origin_cf, aim_cf, started)
    local shift = shot_shift(math.max(0, os.clock() - started))
    if shift == Vector3.zero then return origin_cf, aim_cf end
    local origin = origin_cf.Position + shift
    local aim = aim_cf.Position + shift
    return CFrame.new(origin, aim), CFrame.new(aim)
end

local function resolve_shot()
    if not S.enabled or not S.am_sheriff or not target_alive() then return nil end
    if S.force then
        local started = os.clock()
        local origin_cf, aim_cf = resolve_force()
        if origin_cf and aim_cf then
            origin_cf, aim_cf = compensate_force(origin_cf, aim_cf, started)
            if push_origin(origin_cf) then return aim_cf end
        end
    end
    local cf = origin_cframe()
    local aim = pick_point(cf and cf.Position or nil, false)
    if not aim then return nil end
    return CFrame.new(aim)
end

local function compensate_resolve(cf)
    if S.force or typeof(cf) ~= "CFrame" then return cf end
    return CFrame.new(cf.Position + shot_shift(math.max(0, os.clock() - pred_stamp)))
end

-- ==== ХУКИ ====
local weapon_service = nil
local orig_mouse, orig_screen = nil, nil
local hook_mouse, hook_screen = nil, nil

local function get_weapon_service()
    if weapon_service then return weapon_service end
    local ok, m = pcall(function()
        return require(rs:WaitForChild("ClientServices"):WaitForChild("WeaponService"))
    end)
    if ok and type(m) == "table" then weapon_service = m end
    return weapon_service
end

local function install_hooks()
    local m = get_weapon_service()
    if not m then return end
    if not hook_mouse then
        hook_mouse = function(self, ...)
            sample_ping()
            local ok, cf = pcall(resolve_shot)
            if ok and cf then return compensate_resolve(cf) end
            return orig_mouse(self, ...)
        end
        hook_screen = function(self, x, y, ...)
            sample_ping()
            local ok, cf = pcall(resolve_shot)
            if ok and cf then return compensate_resolve(cf) end
            return orig_screen(self, x, y, ...)
        end
    end
    pcall(function() setreadonly(m, false) end)
    if type(m.GetMouseTargetCFrame) == "function" and m.GetMouseTargetCFrame ~= hook_mouse then
        orig_mouse = m.GetMouseTargetCFrame
        pcall(function() m.GetMouseTargetCFrame = hook_mouse end)
    end
    if type(m.GetTargetPosition) == "function" and m.GetTargetPosition ~= hook_screen then
        orig_screen = m.GetTargetPosition
        pcall(function() m.GetTargetPosition = hook_screen end)
    end
end

-- ==== АВТО-ВЫСТРЕЛ ====
local last_fire_stamp = 0
local want_since = 0

local function get_gun()
    local char = lp.Character
    if char then local g = char:FindFirstChild("Gun"); if g then return g, true end end
    local bp = lp:FindFirstChildOfClass("Backpack")
    if bp then local g = bp:FindFirstChild("Gun"); if g then return g, false end end
    return nil, false
end

local function fire_gun(gun, start_cf, aim_cf)
    if not gun or not start_cf or not aim_cf then return false end
    local remote = gun:FindFirstChild("Shoot")
    if not remote or not remote:IsA("RemoteEvent") then return false end
    return (pcall(function() remote:FireServer(start_cf, aim_cf) end))
end

local function auto_step(now)
    if not S.auto_on or not S.enabled or not S.am_sheriff or not target_alive() then want_since = 0; return end
    local gun, equipped = get_gun()
    if not gun then want_since = 0; return end
    if not equipped then
        want_since = 0
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(gun) end) end
        return
    end
    if want_since == 0 then want_since = now end
    local hold = S.auto_delay
    if hold < S.fire_gap then hold = S.fire_gap end
    local since = last_fire_stamp > 0 and last_fire_stamp or S.last_shot
    if now - since < hold then return end
    if S.force then
        local started = os.clock()
        local origin_cf, aim_cf = resolve_force()
        if not origin_cf or not aim_cf then return end
        origin_cf, aim_cf = compensate_force(origin_cf, aim_cf, started)
        if fire_gun(gun, origin_cf, aim_cf) then S.last_shot = now end
        return
    end
    local cf = origin_cframe()
    if not cf then return end
    local aim = pick_point(cf.Position, true)
    if not aim then return end
    local aim_cf = compensate_resolve(CFrame.new(aim))
    if fire_gun(gun, cf, aim_cf) then S.last_shot = now end
end

-- ==== ЦИКЛ ====
local watch_conns = {}

local function clear_watch()
    for k = 1, #watch_conns do pcall(function() watch_conns[k]:Disconnect() end) end
    table.clear(watch_conns)
end

local function setup_watch()
    clear_watch()
    local m = get_round()
    if m and m.PlayerDataChanged then
        watch_conns[#watch_conns + 1] = m.PlayerDataChanged.Event:Connect(function()
            pcall(refresh_target)
        end)
    end
    watch_conns[#watch_conns + 1] = lp.CharacterAdded:Connect(function()
        task.wait(0.3); pcall(refresh_target)
    end)
end

local next_role, next_hook = 0, 0

local function tick()
    if force_att and os.clock() - force_stamp > 0.05 then restore_origin() end
    if not S.enabled then return end
    local now = os.clock()
    if now >= next_role then next_role = now + 0.2; refresh_target() end
    sample_ping(); track(now)
    if now >= next_hook then next_hook = now + 1; install_hooks() end
    auto_step(now)
end

local main_conn = run.Heartbeat:Connect(function() pcall(tick) end)

-- ==== API ====
getgenv().WALLBANG = {
    enable = function(v)
        S.enabled = v
        if v then
            task.spawn(function()
                pcall(install_hooks); pcall(setup_watch); pcall(refresh_target)
            end)
        else clear_watch(); track_clear() end
    end,
    setPredict = function(v) S.predict = v; if not v then track_clear() end end,
    setForce   = function(v) S.force = v end,
    setAuto    = function(on, delay) S.auto_on = on; if delay then S.auto_delay = delay end end,
    setStandOff = function(v) S.stand_off = v end,
    debug = function()
        local coh, omega = dir_stats(lead_time())
        return {
            target = target_player and target_player.Name or "none",
            ping = EC.ping, rtt = EC.rtt, jitter = EC.jitter, step = EC.step,
            lead = lead_time(), coherence = coh, omega = omega,
            turn = TR.turn, spoof = TR.spoof, clearance = TR.clr,
            jump_v = TR.jump_v, gap = TR.gap, air = TR.air,
            vel_fresh = TR.fresh, vel_pos = TR.vel,
        }
    end,
    unload = function()
        S.enabled = false; S.predict = false; S.force = false; S.auto_on = false
        restore_origin(); clear_watch(); track_clear()
        if main_conn then pcall(function() main_conn:Disconnect() end) end
        local m = weapon_service
        if m then
            pcall(function() setreadonly(m, false) end)
            if orig_mouse  then pcall(function() m.GetMouseTargetCFrame = orig_mouse  end) end
            if orig_screen then pcall(function() m.GetTargetPosition    = orig_screen end) end
        end
    end,
}

task.spawn(function() pcall(install_hooks) end)

    -- ── UI controls ─────────────────────────────────────────────
    v301._left:Divider()
    v301._left:Paragraph({ Title = 'Wallbang', Content = 'Force shoot through walls' })

    v301._left:Toggle({
        Flag    = "wallbang_enable",
        Title   = 'Enable Wallbang',
        Default = false,
        Callback = function(p)
            getgenv().WALLBANG.enable(p)
            v18:Notify({
                Title   = 'CrystalHub',
                Content = p and 'Wallbang ON' or 'Wallbang OFF',
                Duration = 3, Icon = 'bell',
            })
        end,
    })

    v301._left:Toggle({
        Flag    = "wallbang_auto",
        Title   = 'Auto Wallbang',
        Description = 'Automatically fires at murderer',
        Default = false,
        Callback = function(p)
            getgenv().WALLBANG.setAuto(p, 0)
            v18:Notify({
                Title   = 'CrystalHub',
                Content = p and 'Auto Wallbang ON' or 'Auto Wallbang OFF',
                Duration = 3, Icon = 'bell',
            })
        end,
    })

end
-- ── END WALLBANG ──────────────────────────────────────────────

-- ── PLAYER column (right) ─────────────────────────────────────
v301._right:Paragraph({ Title = 'Optional Buttons' })
v301._right:Toggle({
    Flag = "load_esp_toggle", Title = 'Load ESP Toggle',
    Default = false,
    Callback = function(p59) u252(p59) end,
})
v301._right:Toggle({
    Flag = "load_flick", Title = 'Load Flick',
    Default = false,
    Callback = function(p60) u257(p60) end,
})
v301._right:Toggle({
    Flag = "load_speed_glitch", Title = 'Load Speed Glitch',
    Default = false,
    Callback = function(p62) u263(p62) end,
})
v301._right:Toggle({
    Flag = "load_stretch", Title = 'Load Stretch',
    Default = false,
    Callback = function(p63) u270(p63) end,
})
v301._right:Button({
    Title = 'Stretch Resolution Slider',
    Description = '10% = very wide  /  100% = normal',
    Callback = function()
        local v607 = n17 * 100
        local v608 = math.round(v607)

        u126('Stretch Resolution', 10, 100, v608, 5, function(p64)
            n17 = p64 / 100
            if u120 then u127(true) end
            u128:Notify({ Title = 'CrystalHub', Content = 'Stretch set to ' .. p64 .. '%  (1.0 = normal)', Duration = 3, Icon = 'bell' })
        end, function()
            n17 = 0.5
            if u120 then u127(true) end
            u128:Notify({ Title = 'CrystalHub', Content = 'Stretch reset to 50%', Duration = 3, Icon = 'bell' })
        end)
    end,
})
v301._right:Toggle({
    Flag = "load_fling_murderer", Title = 'Load Fling Murderer',
    Default = false,
    Callback = function(p65) u287(p65) end,
})
v301._right:Toggle({
    Flag = "load_fling_sheriff", Title = 'Load Fling Sheriff',
    Default = false,
    Callback = function(p66) u293(p66) end,
})
v301._right:Toggle({
    Flag = "load_wall_hop", Title = 'Load Wall Hop',
    Default = false,
    Callback = function(p67) u281(p67) end,
})

v301._right:Paragraph({ Title = 'Graphics' })

local t32 = {
    Flag = "low_graphics_fps_boost",
    Title = 'Low Graphics (FPS Boost)',
    Default = false,
}

local function u316()
    if u16 then
        u16 = false
        u173.Brightness = u174.Brightness
        u173.GlobalShadows = u174.GlobalShadows
        u173.Ambient = u174.Ambient
        u173.OutdoorAmbient = u174.OutdoorAmbient

        for _, child in pairs(u173:GetChildren())do
            if child:IsA('BloomEffect') or child:IsA('SunRaysEffect') or child:IsA('ColorCorrectionEffect') then
                child:Destroy()
            end
        end
    end

    u15 = true

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        setfpscap(9999)
    end)

    u173.GlobalShadows = false
    u173.Brightness = 2

    for _, descendant in ipairs(u175:GetDescendants())do
        local _pcall = pcall
        local u695 = descendant

        pcall(function()
            u176(u695)
        end)
    end

    if u172 then
        u172:Disconnect()
    end

    u172 = u175.DescendantAdded:Connect(function(descendant)
        task.wait(0.1)

        local u911 = descendant

        pcall(function()
            u176(u911)
        end)
    end)
    u177.Visible = true

    u178:Notify({
        Title = 'CrystalHub',
        Content = tostring('Low Graphics ON \u{2014} FPS boost active'),
        Duration = 3,
        Icon = 'bell',
    })
end

local u317 = v183

function t32.Callback(p71)
    if not p71 then
        u317()

        return
    end

    u316()
end

v301._right:Toggle(t32)

local t33 = {
    Flag = "high_graphics_beautiful",
    Title = 'High Graphics (Beautiful)',
    Default = false,
}

local function u319()
    if u15 then
        u184()
    end

    u16 = true

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
    end)

    u185.GlobalShadows = true
    u185.Brightness = 3.5
    u185.Ambient = Color3.fromRGB(80, 80, 100)
    u185.OutdoorAmbient = Color3.fromRGB(100, 110, 130)

    local v701 = u185:FindFirstChildOfClass('BloomEffect') or Instance.new('BloomEffect', u185)

    v701.Intensity = 0.6
    v701.Size = 24
    v701.Threshold = 0.95

    local v702 = u185:FindFirstChildOfClass('SunRaysEffect') or Instance.new('SunRaysEffect', u185)

    v702.Intensity = 0.25
    v702.Spread = 1

    local v703 = u185:FindFirstChildOfClass('ColorCorrectionEffect') or Instance.new('ColorCorrectionEffect', u185)

    v703.Saturation = 0.2
    v703.Contrast = 0.1
    v703.Brightness = 0.05

    u186:Notify({
        Title = 'CrystalHub',
        Content = tostring('High Graphics ON'),
        Duration = 3,
        Icon = 'bell',
    })
end
local function u320()
    u16 = false

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)

    u187.Brightness = u188.Brightness
    u187.GlobalShadows = u188.GlobalShadows
    u187.Ambient = u188.Ambient
    u187.OutdoorAmbient = u188.OutdoorAmbient

    for _, child in pairs(u187:GetChildren())do
        if child:IsA('BloomEffect') or child:IsA('SunRaysEffect') or child:IsA('ColorCorrectionEffect') then
            child:Destroy()
        end
    end

    u189:Notify({
        Title = 'CrystalHub',
        Content = tostring('High Graphics OFF'),
        Duration = 3,
        Icon = 'bell',
    })
end

function t33.Callback(p72)
    if not p72 then
        u320()

        return
    end

    u319()
end

v301._right:Toggle(t33)

local t34 = {
    Flag = "fov_slider",
    Title = 'FOV Slider',
    Description = 'Mobile-friendly field of view selector',
}
local u322 = v25
local u323 = CurrentCamera
local u324 = v18

function t34.Callback()
    u322('Field of View', 30, 120, n3, 5, function(p73)
        n3 = p73
        u323.FieldOfView = p73
    end, function()
        n3 = 70
        u323.FieldOfView = 70

        u324:Notify({
            Title = 'CrystalHub',
            Content = tostring('FOV reset to 70'),
            Duration = 3,
            Icon = 'bell',
        })
    end)
end

v301._right:Button(t34)
v301._right:Paragraph({ Title = 'Extra Scripts' })

local t35 = {
    Flag = "load_emotes_gui",
    Title = 'Load Emotes GUI',
    Description = '7yd7 emote panel',
}
local u326 = v18

function t35.Callback()
    local ok, result = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua'))()
    end)
    local v814 = ok and 'Emotes GUI loaded!' or 'Error: ' .. tostring(result)

    u326:Notify({
        Title = 'CrystalHub',
        Content = tostring(v814),
        Duration = 3,
        Icon = 'bell',
    })
end

v301._right:Button(t35)

local t36 = {
    Flag = "load_infinite_yield",
    Title = 'Load Infinite Yield',
    Description = 'Admin script',
}
local u328 = v18

function t36.Callback()
    local ok, result = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
    local v817 = ok and 'Infinite Yield loaded!' or 'Error: ' .. tostring(result)

    u328:Notify({
        Title = 'CrystalHub',
        Content = tostring(v817),
        Duration = 3,
        Icon = 'bell',
    })
end

v301._right:Button(t36)

local t37 = {
    Flag = "anti_fling",
    Title = 'Anti-Fling',
    Description = 'Limits velocity to prevent being launched',
    Default = false,
}
local u330 = v18

function t37.Callback(p74)
    u156(p74)

    local v819 = p74 and 'Anti-Fling ON' or 'Anti-Fling OFF'

    u330:Notify({
        Title = 'CrystalHub',
        Content = tostring(v819),
        Duration = 3,
        Icon = 'bell',
    })
end

v301._right:Toggle(t37)

local t39 = {
    Flag = "speed_glitch_slider",
    Title = 'Speed Glitch Slider',
    Description = 'Mobile-friendly speed selector',
}
local u334 = v25
local u335 = v18

function t39.Callback()
    u334('Speed Glitch', 50, 600, n2, 10, function(p76)
        n2 = p76
    end, function()
        n2 = 200
        u335:Notify({ Title = 'CrystalHub', Content = 'Speed reset to 200', Duration = 3, Icon = 'bell' })
    end)
end

v301._right:Button(t39)
v301._right:Dropdown({
    Flag = "velocity_cap_anti_fling", Title = 'Velocity Cap (Anti-Fling)',
    Options = { '50', '100', '150', '200', '300', '500' },
    Default = '200',
    Callback = function(p77)
        n1 = tonumber(p77) or 200
    end,
})


local t40 = {
    Flag = "enable_esp",
    Title = 'Enable ESP',
    Default = false,
}
local u337 = v78
local u338 = v68
local u339 = v18

function t40.Callback(p78)
    u61 = p78

    if not p78 then
        if u62 then
            u62:Disconnect()

            u62 = nil
        end

        task.delay(0.1, u338)
    else
        u337()
    end

    local v824 = p78 and 'ESP ON' or 'ESP OFF'

    u339:Notify({
        Title = 'CrystalHub',
        Content = tostring(v824),
        Duration = 3,
        Icon = 'bell',
    })
end

v302:Toggle(t40)
v302:Divider()

local t41 = {
    Flag = "show_murderer",
    Title = 'Show Murderer',
    Default = true,
}
local u341 = t3

function t41.Callback(p79)
    u341.Murderer = p79
end

v302:Toggle(t41)

local t42 = {
    Flag = "show_sheriff",
    Title = 'Show Sheriff',
    Default = true,
}
local u343 = t3

function t42.Callback(p80)
    u343.Sheriff = p80
end

v302:Toggle(t42)

local t43 = {
    Flag = "show_hero",
    Title = 'Show Hero',
    Default = true,
}
local u345 = t3

function t43.Callback(p81)
    u345.Hero = p81
end

v302:Toggle(t43)

local t44 = {
    Flag = "show_innocents",
    Title = 'Show Innocents',
    Default = true,
}
local u347 = t3

function t44.Callback(p82)
    u347.Innocent = p82
end

v302:Toggle(t44)

local t45 = {
    Flag = "show_self",
    Title = 'Show Self',
    Default = true,
}
local u349 = t3

function t45.Callback(p83)
    u349.Self = p83
end

v302:Toggle(t45)

local t46 = {
    Flag = "dropped_gun_esp",
    Title = 'Dropped Gun ESP',
    Description = 'Highlight and label when a gun is on the map',
    Default = true,
}
local u351 = v18

function t46.Callback(p84)
    u17 = p84

    if not p84 then
        if u31 then
            u31:Destroy()

            u31 = nil
        end
        if u32 then
            u32:Destroy()

            u32 = nil
        end
        if u29 then
            u29:Destroy()

            u29 = nil
        end
    end

    local v831 = p84 and 'Gun ESP ON' or 'Gun ESP OFF'

    u351:Notify({
        Title = 'CrystalHub',
        Content = tostring(v831),
        Duration = 3,
        Icon = 'bell',
    })
end

v302:Toggle(t46)
v302:Divider()

local t47 = {
    Flag = "murderer_color",
    Title = 'Murderer Color',
    Default = Color3.fromRGB(255, 40, 40),
}
local u353 = t4

function t47.Callback(p85)
    u353.Murderer = p85
end

v302:ColorPicker(t47)

local t48 = {
    Flag = "sheriff_color",
    Title = 'Sheriff Color',
    Default = Color3.fromRGB(40, 130, 255),
}
local u355 = t4

function t48.Callback(p86)
    u355.Sheriff = p86
end

v302:ColorPicker(t48)

local t49 = {
    Flag = "hero_color",
    Title = 'Hero Color',
    Default = Color3.fromRGB(255, 215, 0),
}
local u357 = t4

function t49.Callback(p87)
    u357.Hero = p87
end

v302:ColorPicker(t49)

local t50 = {
    Flag = "innocent_color",
    Title = 'Innocent Color',
    Default = Color3.fromRGB(0, 220, 0),
}
local u359 = t4

function t50.Callback(p88)
    u359.Innocent = p88
end

v302:ColorPicker(t50)

-- ════════════════════════════════════════
--            GUI SETTINGS TAB
-- ════════════════════════════════════════
do
    local guiSettingsTab = v300:Tab({
        Title = 'GUI Settings',
        Icon  = 'settings',
    })

    -- ── Watermark section (left) ──────────────────────────────────────────
    local wmSection = guiSettingsTab._left or guiSettingsTab

    wmSection:Paragraph({ Title = 'Watermark', Content = 'Control the top bar overlay' })

    -- Watermark visible toggle
    local _wmGui = game:GetService("CoreGui"):FindFirstChild("CrystalHubOpenButton")
        or (typeof(gethui) == "function" and gethui():FindFirstChild("CrystalHubOpenButton"))
        or nil

    local function getOverlay()
        local parent
        pcall(function()
            if typeof(gethui) == "function" then parent = gethui() end
        end)
        if not parent then parent = game:GetService("CoreGui") end
        local sg = parent:FindFirstChild("CrystalHubOpenButton")
        return sg and sg:FindFirstChild("CrystalHubOverlay") or nil
    end

    wmSection:Toggle({
        Flag    = "watermark_visible",
        Title   = 'Show Watermark',
        Default = true,
        Callback = function(p)
            local ov = getOverlay()
            if ov then ov.Visible = p end
        end,
    })

    -- Watermark width slider (300 – 700 px)
    wmSection:Slider({
        Flag  = "watermark_width",
        Title = 'Watermark Width',
        Value = { Min = 200, Max = 700, Default = 530 },
        Rounding = 0,
        Suffix = 'px',
        Callback = function(val)
            local ov = getOverlay()
            if ov then
                ov.Size = UDim2.new(0, val, 0, ov.Size.Y.Offset)
            end
        end,
    })

    -- Watermark height slider (28 – 60 px)
    wmSection:Slider({
        Flag  = "watermark_height",
        Title = 'Watermark Height',
        Value = { Min = 24, Max = 70, Default = 42 },
        Rounding = 0,
        Suffix = 'px',
        Callback = function(val)
            local ov = getOverlay()
            if ov then
                ov.Size = UDim2.new(0, ov.Size.X.Offset, 0, val)
            end
        end,
    })

    -- Watermark transparency slider (0 – 90 %)
    wmSection:Slider({
        Flag  = "watermark_transparency",
        Title = 'Watermark Transparency',
        Value = { Min = 0, Max = 90, Default = 16 },
        Rounding = 0,
        Suffix = '%',
        Callback = function(val)
            local ov = getOverlay()
            if ov then ov.BackgroundTransparency = val / 100 end
        end,
    })

    -- ── GUI Size Presets section (right) ─────────────────────────────────
    local psSection = (guiSettingsTab._right or guiSettingsTab)

    psSection:Paragraph({ Title = 'GUI Size Presets', Content = 'Pick a window size preset' })

    local guiSizePresets = {
        { name = 'Compact  (400×300)',  w = 400,  h = 300  },
        { name = 'Small    (500×380)',  w = 500,  h = 380  },
        { name = 'Default  (700×550)',  w = 700,  h = 550  },
        { name = 'Large    (860×620)',  w = 860,  h = 620  },
        { name = 'Wide     (960×500)',  w = 960,  h = 500  },
    }

    -- Helper: resize the NeverLose window frame (best-effort)
    local function applyGuiSize(w, h)
        local nl = getgenv().CrystalHubNeverLose
        pcall(function()
            -- NeverLose stores its main frame in .Frame or ._frame
            local frame = nl and (nl.Frame or nl._frame or nl.Main)
            if frame and frame:IsA("GuiObject") then
                frame.Size = UDim2.fromOffset(w, h)
            end
        end)
        v18:Notify({
            Title   = 'CrystalHub',
            Content = 'GUI size set to ' .. w .. ' × ' .. h,
            Duration = 3,
            Icon    = 'bell',
        })
    end

    for _, preset in ipairs(guiSizePresets) do
        local p = preset
        psSection:Button({
            Title    = p.name,
            Callback = function() applyGuiSize(p.w, p.h) end,
        })
    end

    psSection:Divider()

    -- Custom size sliders
    psSection:Paragraph({ Title = 'Custom Size' })

    local _customW = 400
    local _customH = 300

    psSection:Slider({
        Flag  = "custom_gui_width",
        Title = 'Width',
        Value = { Min = 300, Max = 1100, Default = 400 },
        Rounding = 0,
        Suffix = 'px',
        Callback = function(val) _customW = val end,
    })

    psSection:Slider({
        Flag  = "custom_gui_height",
        Title = 'Height',
        Value = { Min = 200, Max = 750, Default = 300 },
        Rounding = 0,
        Suffix = 'px',
        Callback = function(val) _customH = val end,
    })

    psSection:Button({
        Title    = 'Apply Custom Size',
        Callback = function() applyGuiSize(_customW, _customH) end,
    })
end

task.wait(0.4)
v232(false)
v239(false)
v244(false)
v18:Notify({
    Title = 'CrystalHub',
    Content = tostring('CrystalHub Ready!'),
    Duration = 3,
    Icon = 'bell',
})
print('[CrystalHub] v1.0 loaded.')
