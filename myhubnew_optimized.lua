local UserInputService, CurrentCamera, n1, n2, u13, n3, u15, u16, u17, v18, v25, u29, u31, u32, u61, u62, t3, t4, v68, v78, u120, n17, u126, u127, u128, v145, u147, u148, u149, u150, u151, u156, u172, u173, u174, u175, u176, u177, u178, v183, u184, u185, u186, u187, u188, u189, u198, u199, id, u201, u202, u205, u206, u207, u208, u209, u210, u211, u212, v232, v239, v244, u252, u257, u263, u270, u276, u281, u287, u293, v301, v302

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
            Min = value.Min or 0,
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
        Size = cfg.Size or UDim2.fromOffset(700, 550),
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

    function adapter:Tab(cfg2)
        cfg2 = cfg2 or {}

        local tab = window:AddTab({
            Name = cfg2.Title or "Tab",
            Type = "Single",
        })

        local section = tab:AddSection({
            Name = cfg2.Title or "MAIN",
            Position = "left",
        })

        local controls = makeControlAdapter(section)
        controls._tab = tab
        controls._section = section
        self._tabs[#self._tabs + 1] = controls

        return controls
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

                    function u156(p28)
                        u152 = p28

                        if not p28 then
                            if u153 then
                                u153:Disconnect()

                                u153 = nil
                            end

                            return
                        end
                        if u153 then
                            u153:Disconnect()
                        end

                        local _antiFlingLastTick = 0
                        u153 = u154.Stepped:Connect(function()
                            if u152 then
                                local _now = tick()
                                -- Throttle: запускать не чаще раза в 0.15 секунд
                                if _now - _antiFlingLastTick < 0.15 then return end
                                _antiFlingLastTick = _now
                                for _, plr in ipairs(Players:GetPlayers()) do
                                    if plr ~= LocalPlayer and plr.Character then
                                        for _, part in ipairs(plr.Character:GetDescendants()) do
                                            if part:IsA('BasePart') then
                                                pcall(function()
                                                    part.CanCollide = false
                                                end)
                                            end
                                        end
                                    end
                                end

                                return
                            end
                        end)
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

            local u217 = UserInputService

            function u218(p35)
                local u740 = nil
                local p36Position = nil
                local Position = nil
                local InputBegan = p35.InputBegan
                local u744 = p35

                InputBegan:Connect(function(p36)
                    if p36.UserInputType == Enum.UserInputType.MouseButton1 or p36.UserInputType == Enum.UserInputType.Touch then
                        u740 = true
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
                TextButton.Position = p39
                TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                TextButton.BackgroundTransparency = 0.6
                TextButton.Text = ''
                TextButton.AutoButtonColor = false
                TextButton.BorderSizePixel = 0
                Instance.new('UICorner', TextButton).CornerRadius = UDim.new(0, p40.Y.Offset * 0.2)

                local UIStroke = Instance.new('UIStroke', TextButton)

                UIStroke.Color = p41
                UIStroke.Thickness = 1.3
                UIStroke.Transparency = 0.5
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                local TextLabel = Instance.new('TextLabel', TextButton)

                TextLabel.Name = 'Lbl'
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = p42
                TextLabel.TextColor3 = p41
                TextLabel.Font = Enum.Font.GothamBold

                local v755 = p40.Y.Offset * 0.14

                TextLabel.TextSize = math.max(10, v755)
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

            uDim2_2 = UDim2.new(0, 88, 0, 88)
            uDim2 = UDim2.new(0, 56, 0, 56)
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

    -- Floating button to open/toggle the CrystalHub GUI.
    -- Uses gethui when available so it also works in common executors.
    do
        local guiParent
        pcall(function()
            if typeof(gethui) == "function" then
                guiParent = gethui()
            end
        end)
        if not guiParent then
            guiParent = game:GetService("CoreGui")
        end

        local oldButtonGui = guiParent:FindFirstChild("CrystalHubOpenButton")
        if oldButtonGui then
            oldButtonGui:Destroy()
        end

        local openGui = Instance.new("ScreenGui")
        openGui.Name = "CrystalHubOpenButton"
        openGui.ResetOnSpawn = false
        openGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        openGui.Parent = guiParent

        local openButton = Instance.new("TextButton")
        openButton.Name = "OpenButton"
        openButton.Size = UDim2.fromOffset(120, 42)
        openButton.Position = UDim2.new(0, 18, 0.5, -21)
        openButton.BackgroundTransparency = 0.08
        openButton.Text = "OPEN GUI"
        openButton.TextSize = 15
        openButton.Font = Enum.Font.GothamBold
        openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        openButton.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
        openButton.BorderSizePixel = 0
        openButton.AutoButtonColor = true
        openButton.Parent = openGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = openButton

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(80, 160, 255)
        stroke.Transparency = 0.15
        stroke.Parent = openButton

        openButton.Activated:Connect(function()
            pcall(function()
                v300:ToggleInterface()
            end)
        end)

        -- Make the button draggable on mouse/touch.
        local dragging = false
        local dragStart
        local startPos

        openButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = openButton.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local delta = input.Position - dragStart
            openButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    v301 = v300:Tab({
        Title = 'Main',
    })
    v302 = v300:Tab({
        Title = 'ESP',
    })

    v303 = v300:Tab({
        Title = 'Fling/Teleport',
    })

    local v304 = v300:Tab({
        Title = 'Rage',
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
        })

        AutoFarmTab:Paragraph({
            Title = "CrystalHub AutoFarm",
            Content = "Автоматический сбор монет. Настройки применяются сразу.",
        })

        AutoFarmTab:Toggle({
            Title = "Anti AFK",
            Default = AFSettings.AntiAfkEnabled,
            Callback = function(value)
                AFSettings.AntiAfkEnabled = value
                if value then
                    afStartAntiAfk()
                end
            end,
        })

        AutoFarmTab:Toggle({
            Title = "Auto Farm",
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
            Title = "Farm Mode",
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
            Title = "Tween Speed",
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
            Title = "Auto Reset",
            Default = AFSettings.AutoReset,
            Callback = function(value)
                AFSettings.AutoReset = value
            end,
        })

        AutoFarmTab:Toggle({
            Title = "Avoid Murder",
            Default = AFSettings.AvoidMurder,
            Callback = function(value)
                AFSettings.AvoidMurder = value
            end,
        })

        -- Coin limit is intentionally a 40/50 selector instead of a slider.
        AutoFarmTab:Dropdown({
            Title = "Coin Limit",
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
    -- RAGE TAB: ANTI-AIM (Matcha-style Desync + Fake Position)
    -- ═══════════════════════════════════════════
    do
        -- ── State ──────────────────────────────────────────────────────
        local aaDesync = {
            Enabled      = false,
            Mode         = "Custom",
            RandomAmount = 20,
            Visualize    = false,
            Line         = false,
            Status       = false,
            Dot          = false,
            CustomX      = 0,
            CustomY      = 0,
            CustomZ      = 0,
        }

        local aaFakePos = {
            Enabled      = false,
            Mode         = "Voidless",
            Version      = "Version 1",
            ReturnDelay  = 0.5,
            Active       = false,
            OriginalPos  = nil,
        }

        -- ── Desync clone (invisible body at fake pos) ──────────────────
        local DesyncClone = nil
        local DesyncHighlight = nil
        local DesyncGlow = nil

        pcall(function()
            DesyncClone = game:GetObjects("rbxassetid://8246626421")[1]
            DesyncClone.Parent = Workspace
            DesyncClone.Humanoid:Destroy()
            DesyncClone.Head.Face:Destroy()
            for _, v in pairs(DesyncClone:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.CanCollide = false
                    v.Transparency = 0
                end
            end
            DesyncClone.HumanoidRootPart.Transparency = 0.5
            DesyncClone.HumanoidRootPart.CFrame = CFrame.new(9999, 9999, 9999)

            DesyncHighlight = Instance.new("Highlight")
            DesyncHighlight.Enabled = false
            DesyncHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            DesyncHighlight.FillColor = Color3.fromRGB(0, 255, 0)
            DesyncHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            DesyncHighlight.FillTransparency = 0.3
            DesyncHighlight.OutlineTransparency = 0
            DesyncHighlight.Adornee = DesyncClone
            DesyncHighlight.Parent = DesyncClone

            DesyncGlow = Instance.new("PointLight")
            DesyncGlow.Color = Color3.fromRGB(0, 255, 100)
            DesyncGlow.Brightness = 4
            DesyncGlow.Range = 2
            DesyncGlow.Parent = DesyncClone.HumanoidRootPart
        end)

        -- ── Drawing overlays ──────────────────────────────────────────
        local aaLine = Drawing.new("Line")
        aaLine.Thickness = 2
        aaLine.Color = Color3.fromRGB(0, 255, 0)
        aaLine.Visible = false
        aaLine.Transparency = 1

        local aaDot = Drawing.new("Circle")
        aaDot.Radius = 6
        aaDot.Thickness = 1.5
        aaDot.NumSides = 16
        aaDot.Color = Color3.fromRGB(0, 255, 100)
        aaDot.Filled = true
        aaDot.Transparency = 1
        aaDot.Visible = false

        local aaStatus = Drawing.new("Text")
        aaStatus.Text = "Desync: OFF"
        aaStatus.Size = 16
        aaStatus.Font = 2
        aaStatus.Color = Color3.fromRGB(255, 0, 0)
        aaStatus.Outline = true
        aaStatus.OutlineColor = Color3.fromRGB(0, 0, 0)
        aaStatus.Center = false
        aaStatus.Visible = false
        aaStatus.Position = Vector2.new(100, 100)

        -- ── Camera setback part (keeps camera at real pos) ────────────
        local desync_setback = Instance.new("Part")
        desync_setback.Name = "CrystalDesyncSetback"
        desync_setback.Size = Vector3.new(2, 2, 1)
        desync_setback.CanCollide = false
        desync_setback.Anchored = true
        desync_setback.Transparency = 1
        desync_setback.Parent = Workspace

        -- ── Status-label drag ─────────────────────────────────────────
        local aaDragging = false
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and aaDesync.Status then
                local mp = UserInputService:GetMouseLocation()
                local tp = aaStatus.Position
                local ts = aaStatus.TextBounds
                if mp.X >= tp.X and mp.X <= tp.X + ts.X and
                   mp.Y >= tp.Y and mp.Y <= tp.Y + ts.Y then
                    aaDragging = true
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                aaDragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if aaDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                aaStatus.Position = UserInputService:GetMouseLocation()
            end
        end)

        -- ── Desync heartbeat ──────────────────────────────────────────
        RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if not char or not hrp then
                if DesyncClone then
                    DesyncClone:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
                    if DesyncHighlight then DesyncHighlight.Enabled = false end
                end
                aaLine.Visible   = false
                aaDot.Visible    = false
                aaStatus.Visible = false
                return
            end

            local oldCFrame   = hrp.CFrame
            local desyncCFrame = oldCFrame

            if aaDesync.Enabled then
                local m = aaDesync.Mode
                if m == "Destroy Cheaters" then
                    desyncCFrame = CFrame.new(9e9, 1, 1) * oldCFrame.Rotation
                elseif m == "Underground" then
                    desyncCFrame = CFrame.new(hrp.Position - Vector3.new(0, 12, 0)) * oldCFrame.Rotation
                elseif m == "Void Spam" then
                    desyncCFrame = math.random(1,2)==1 and oldCFrame
                        or CFrame.new(math.random(10000,50000), math.random(10000,50000), math.random(10000,50000)) * oldCFrame.Rotation
                elseif m == "Void" then
                    desyncCFrame = CFrame.new(hrp.Position + Vector3.new(
                        math.random(-444444,444444),
                        math.random(-444444,444444),
                        math.random(-44444,44444)
                    )) * oldCFrame.Rotation
                elseif m == "Random" then
                    local amt = aaDesync.RandomAmount
                    desyncCFrame = CFrame.new(hrp.Position + Vector3.new(
                        math.random(-amt, amt),
                        math.random(-amt/2, amt/2),
                        math.random(-amt, amt)
                    )) * oldCFrame.Rotation
                elseif m == "Safe Shoot" then
                    desyncCFrame = CFrame.new(hrp.Position - Vector3.new(0,5,0))
                        * CFrame.Angles(math.random(0,360), math.random(0,360), math.rad(180))
                elseif m == "Custom" then
                    desyncCFrame = CFrame.new(hrp.Position - Vector3.new(
                        aaDesync.CustomX, aaDesync.CustomY, aaDesync.CustomZ
                    )) * oldCFrame.Rotation
                end

                hrp.CFrame = desyncCFrame
                Camera.CameraSubject = desync_setback
                RunService.RenderStepped:Wait()
                desync_setback.CFrame = oldCFrame * CFrame.new(0, hrp.Size.Y/2 + 0.5, 0)
                hrp.CFrame = oldCFrame
            end

            -- Visualize clone
            local vizCF = aaDesync.Enabled and desyncCFrame or oldCFrame
            if aaDesync.Visualize and DesyncClone then
                DesyncClone:SetPrimaryPartCFrame(vizCF)
                if DesyncHighlight then DesyncHighlight.Enabled = true end
            elseif DesyncClone then
                if DesyncHighlight then DesyncHighlight.Enabled = false end
                DesyncClone:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
            end

            -- Line
            if aaDesync.Line then
                local sp, on = Camera:WorldToViewportPoint(vizCF.Position)
                local mp = UserInputService:GetMouseLocation()
                if on then
                    aaLine.From    = mp
                    aaLine.To      = Vector2.new(sp.X, sp.Y)
                    aaLine.Visible = true
                else
                    aaLine.Visible = false
                end
            else
                aaLine.Visible = false
            end

            -- Dot
            if aaDesync.Dot then
                local sp, on = Camera:WorldToViewportPoint(vizCF.Position)
                if on then
                    aaDot.Position = Vector2.new(sp.X, sp.Y)
                    aaDot.Visible  = true
                else
                    aaDot.Visible = false
                end
            else
                aaDot.Visible = false
            end

            -- Status text
            if aaDesync.Status then
                aaStatus.Text    = "Desync: " .. (aaDesync.Enabled and "TRUE" or "FALSE")
                aaStatus.Color   = aaDesync.Enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                aaStatus.Visible = true
            else
                aaStatus.Visible = false
            end
        end)

        -- ── Fake Position helpers ─────────────────────────────────────
        local function getFakePosOffset()
            if aaFakePos.Version == "Version 1" then return CFrame.new(100000,100000,100000)
            elseif aaFakePos.Version == "Version 2" then return CFrame.new(50000000,50000000,50000000)
            elseif aaFakePos.Version == "Version 3" then return CFrame.new(9e9,9e9,9e9) end
        end

        local function applyFakePosition()
            if aaFakePos.Active then return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            aaFakePos.Active = true
            aaFakePos.OriginalPos = hrp.CFrame
            local oldFall = Workspace.FallenPartsDestroyHeight
            Workspace.FallenPartsDestroyHeight = -math.huge
            pcall(function() getgenv().Desync = true end)
            if aaFakePos.Mode == "Voidless" then
                local off = getFakePosOffset()
                if off then hrp.CFrame = off end
                task.spawn(function()
                    task.wait(aaFakePos.ReturnDelay)
                    if hrp and aaFakePos.OriginalPos then
                        hrp.CFrame = aaFakePos.OriginalPos
                    end
                    Workspace.FallenPartsDestroyHeight = oldFall
                    aaFakePos.Active = false
                end)
            elseif aaFakePos.Mode == "On the spot" then
                task.spawn(function()
                    task.wait(aaFakePos.ReturnDelay)
                    Workspace.FallenPartsDestroyHeight = oldFall
                    aaFakePos.Active = false
                end)
            end
        end

        local function disableFakePosition()
            aaFakePos.Active = false
            Workspace.FallenPartsDestroyHeight = 0/0
            pcall(function() getgenv().Desync = false end)
        end

        -- ── Camera reset ──────────────────────────────────────────────
        local function resetCamera()
            if LocalPlayer.Character then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end

        -- ══════════════════════════════════════════════════════════════
        -- UI — Desync
        -- ══════════════════════════════════════════════════════════════
        v304:Paragraph({
            Title   = "Anti-Aim",
            Content = "Продвинутый Desync: несколько режимов смещения позиции (Custom, Void, Random…) + Fake Position с визуализацией клона.",
        })

        v304:Toggle({
            Title   = "Desync",
            Default = false,
            Callback = function(val)
                aaDesync.Enabled = val
                if not val then resetCamera() end
                v18:Notify({ Title = "CrystalHub", Content = "Desync " .. (val and "ON" or "OFF"), Duration = 3, Icon = "bell" })
            end,
        })

        v304:Dropdown({
            Title  = "Desync Mode",
            Values = { "Destroy Cheaters", "Underground", "Void Spam", "Void", "Random", "Safe Shoot", "Custom" },
            Value  = "Custom",
            Callback = function(val)
                aaDesync.Mode = val
            end,
        })

        v304:Slider({
            Title   = "Random Amount",
            IsTooltip = true,
            IsTextbox = true,
            Value   = { Min = 1, Max = 1000000, Default = 20 },
            Callback = function(val)
                aaDesync.RandomAmount = tonumber(val) or 20
            end,
        })

        v304:Slider({
            Title   = "Custom X",
            IsTooltip = true,
            IsTextbox = true,
            Value   = { Min = -10000, Max = 10000, Default = 0 },
            Callback = function(val)
                aaDesync.CustomX = tonumber(val) or 0
            end,
        })

        v304:Slider({
            Title   = "Custom Y",
            IsTooltip = true,
            IsTextbox = true,
            Value   = { Min = -10000, Max = 10000, Default = 0 },
            Callback = function(val)
                aaDesync.CustomY = tonumber(val) or 0
            end,
        })

        v304:Slider({
            Title   = "Custom Z",
            IsTooltip = true,
            IsTextbox = true,
            Value   = { Min = -10000, Max = 10000, Default = 0 },
            Callback = function(val)
                aaDesync.CustomZ = tonumber(val) or 0
            end,
        })

        v304:Divider()

        v304:Toggle({
            Title   = "Visualize Desync",
            Default = false,
            Callback = function(val)
                aaDesync.Visualize = val
            end,
        })

        v304:Toggle({
            Title   = "Desync Line",
            Default = false,
            Callback = function(val)
                aaDesync.Line = val
            end,
        })

        v304:Toggle({
            Title   = "Desync Dot",
            Default = false,
            Callback = function(val)
                aaDesync.Dot = val
            end,
        })

        v304:Toggle({
            Title   = "Desync Status Text",
            Default = false,
            Callback = function(val)
                aaDesync.Status = val
            end,
        })

        v304:Divider()

        -- ══════════════════════════════════════════════════════════════
        -- UI — Fake Position
        -- ══════════════════════════════════════════════════════════════
        v304:Paragraph({
            Title   = "Fake Position",
            Content = "Телепортирует персонажа в фейковую позицию и возвращает назад через ReturnDelay сек.",
        })

        v304:Toggle({
            Title   = "Enable Fake Position",
            Default = false,
            Callback = function(val)
                aaFakePos.Enabled = val
                if val then
                    applyFakePosition()
                else
                    disableFakePosition()
                end
                v18:Notify({ Title = "CrystalHub", Content = "Fake Position " .. (val and "ON" or "OFF"), Duration = 3, Icon = "bell" })
            end,
        })

        v304:Dropdown({
            Title  = "FakePos Version",
            Values = { "Version 1", "Version 2", "Version 3" },
            Value  = "Version 1",
            Callback = function(val)
                aaFakePos.Version = val
            end,
        })

        v304:Dropdown({
            Title  = "FakePos Mode",
            Values = { "Voidless", "On the spot" },
            Value  = "Voidless",
            Callback = function(val)
                aaFakePos.Mode = val
            end,
        })

        v304:Slider({
            Title   = "Return Delay (s)",
            IsTooltip = true,
            IsTextbox = true,
            Value   = { Min = 0.1, Max = 3, Default = 0.5 },
            Callback = function(val)
                aaFakePos.ReturnDelay = tonumber(val) or 0.5
            end,
        })
    end

    -- ═══════════════════════════════════════════
    -- RAGE TAB: SPINBOT
    -- ═══════════════════════════════════════════
    do
        local sbEnabled  = false
        local sbSpeed    = 16.67  -- ~50% из 1/3 * 50
        local sbConnection = nil

        v304:Divider()

        v304:Paragraph({
            Title   = "SpinBot",
            Content = "Вращает персонажа по оси Y каждый кадр. Отключает AutoRotate пока активен.",
        })

        v304:Toggle({
            Title   = "SpinBot",
            Default = false,
            Callback = function(val)
                sbEnabled = val

                local char     = LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                if val then
                    -- Отключаем автоповорот
                    if humanoid then
                        humanoid.AutoRotate = false
                    end
                    -- Запускаем соединение
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
                    -- Останавливаем
                    if sbConnection then
                        sbConnection:Disconnect()
                        sbConnection = nil
                    end
                    -- Восстанавливаем AutoRotate
                    if humanoid then
                        humanoid.AutoRotate = true
                    end
                end

                v18:Notify({ Title = "CrystalHub", Content = "SpinBot " .. (val and "ON" or "OFF"), Duration = 3, Icon = "bell" })
            end,
        })

        v304:Slider({
            Title     = "Spin Speed",
            IsTooltip = true,
            IsTextbox = true,
            Value     = { Min = 1, Max = 100, Default = 50 },
            Callback  = function(val)
                -- Масштаб как в оригинале juju: value * (1/3)
                sbSpeed = (tonumber(val) or 50) * (1 / 3)
            end,
        })
    end

    v303:Paragraph({
        Title = 'Teleport Players',
        Content = 'Select a player and teleport to them.',
    })

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

        teleportDropdown = v303:Dropdown({
            Title = 'Select Player',
            Values = teleportNames,
            Value = teleportSelected,
            Callback = function(value)
                teleportSelected = value
            end,
        })

        v303:Button({
            Title = 'Teleport to Player',
            Description = 'Teleport to the selected player',
            Callback = function()
                if not teleportSelected then
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = 'Select a player first!',
                        Duration = 3,
                        Icon = 'bell',
                    })
                    return
                end

                local target = Players:FindFirstChild(teleportSelected)
                local character = LocalPlayer.Character
                local targetCharacter = target and target.Character
                local hrp = character and character:FindFirstChild('HumanoidRootPart')
                local targetHRP = targetCharacter and targetCharacter:FindFirstChild('HumanoidRootPart')

                if not (hrp and targetHRP) then
                    v18:Notify({
                        Title = 'CrystalHub',
                        Content = 'Player or character not found!',
                        Duration = 3,
                        Icon = 'bell',
                    })
                    return
                end

                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                v18:Notify({
                    Title = 'CrystalHub',
                    Content = tostring('Teleported to: ' .. target.Name),
                    Duration = 3,
                    Icon = 'bell',
                })
            end,
        })

        v303:Button({
            Title = 'Refresh Teleport List',
            Description = 'Update the player list',
            Callback = function()
                rebuildTeleportNames()
            end,
        })

        Players.PlayerAdded:Connect(function()
            task.delay(0.3, rebuildTeleportNames)
        end)
        Players.PlayerRemoving:Connect(function()
            task.delay(0.3, rebuildTeleportNames)
        end)
    end

    v303:Paragraph({
        Title = 'Fling Players',
        Content = 'Select a player from the list and press Fling.',
    })

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

        flingDropdown = v303:Dropdown({
            Title = 'Select Player',
            Values = flingNames,
            Value = flingSelected,
            Callback = function(value)
                flingSelected = value
            end,
        })

        v303:Button({
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

        v303:Button({
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

    -- Visuals tab: ready for the user's Visuals code.
    local VisualsTab = v300:Tab({
        Title = 'Visuals',
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
        VisualsTab:Paragraph({
            Title = "Aura Selector",
            Content = "Toggle auras below, pick color, then enable. Supports mixing multiple auras.",
        })

        -- Master ON/OFF
        VisualsTab:Toggle({
            Title = "Enable Auras",
            Description = "Apply selected auras to your character",
            Default = false,
            Callback = function(state)
                aura_active = state
                applyAura()
            end,
        })

        -- Individual aura toggles
        VisualsTab:Paragraph({
            Title = "Aura List",
            Content = "Select one or more auras to stack on your character.",
        })

        for _, name in ipairs(aura_order) do
            local auraName = name
            VisualsTab:Toggle({
                Title = auraName:sub(1,1):upper()..auraName:sub(2),
                Default = false,
                Callback = function(state)
                    selected_auras[auraName] = state
                    applyAura()
                end,
            })
        end

        -- Quick presets
        VisualsTab:Paragraph({
            Title = "Color Presets",
            Content = "One-click color presets for your aura.",
        })

        local colorPresets = {"Default (Blue)","Red","Green","Gold","Purple","White","Rainbow (cycle)"}

        VisualsTab:Dropdown({
            Title = "Color Preset",
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
        VisualsTab:Button({
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
VisualsTab:Divider()
VisualsTab:Paragraph({
    Title = 'Skybox',
    Content = 'Click the button below to open the visual skybox picker.\nSelecting a preset applies it instantly.',
})
VisualsTab:Button({
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
    Title = 'Restore Default Sky',
}
local u310 = v145

function t30.Callback()
    u310()
end

VisualsTab:Button(t30)
VisualsTab:Divider()
VisualsTab:Paragraph({
    Title = 'Crosshair',
    Content = 'Visible only when ShiftLock is active.\nSpin option is inside the picker.',
})

local t31 = {
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

VisualsTab:Toggle(t31)
VisualsTab:Button({
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


    v301:Paragraph({
        Title = 'Auto-Loaded Buttons',
        Content = 'Gold Bomb, Normal Bomb and Shoot/Throw are disabled by default. Enable manually.',
    })

    local t27 = {
        Title = 'Show Gold Bomb',
        Default = false,
    }
    local u304 = v232

    function t27.Callback(p56)
        u304(p56)
    end

    v301:Toggle(t27)

    local t28 = {
        Title = 'Show Normal Bomb',
        Default = false,
    }
    local u306 = v239

    function t28.Callback(p57)
        u306(p57)
    end

    v301:Toggle(t28)

    local t29 = {
        Title = 'Show Shoot/Throw',
        Default = false,
    }
    local u308 = v244

    function t29.Callback(p58)
        u308(p58)
    end

    v301:Toggle(t29)
end

v301:Divider()
v301:Paragraph({
    Title = 'Optional Buttons',
    Content = 'Toggle to add or remove from screen.',
})
v301:Toggle({
    Title = 'Load ESP Toggle',
    Default = false,
    Callback = function(p59)
        u252(p59)
    end,
})
v301:Toggle({
    Title = 'Load Flick',
    Default = false,
    Callback = function(p60)
        u257(p60)
    end,
})
v301:Toggle({
    Title = 'Load Grab Gun',
    Default = false,
    Callback = function(p61)
        u276(p61)
    end,
})
v301:Toggle({
    Title = 'Load Speed Glitch',
    Default = false,
    Callback = function(p62)
        u263(p62)
    end,
})
v301:Toggle({
    Title = 'Load Stretch',
    Default = false,
    Callback = function(p63)
        u270(p63)
    end,
})
v301:Button({
    Title = 'Stretch Resolution Slider',
    Description = '10% = very wide  /  100% = normal',
    Callback = function()
        local v607 = n17 * 100
        local v608 = math.round(v607)

        u126('Stretch Resolution', 10, 100, v608, 5, function(p64)
            n17 = p64 / 100

            if u120 then
                u127(true)
            end

            local v886 = 'Stretch set to ' .. p64 .. '%  (1.0 = normal)'

            u128:Notify({
                Title = 'CrystalHub',
                Content = tostring(v886),
                Duration = 3,
                Icon = 'bell',
            })
        end, function()
            n17 = 0.5

            if u120 then
                u127(true)
            end

            u128:Notify({
                Title = 'CrystalHub',
                Content = tostring('Stretch reset to 50%'),
                Duration = 3,
                Icon = 'bell',
            })
        end)
    end,
})
v301:Toggle({
    Title = 'Load Fling Murderer',
    Default = false,
    Callback = function(p65)
        u287(p65)
    end,
})
v301:Toggle({
    Title = 'Load Fling Sheriff',
    Default = false,
    Callback = function(p66)
        u293(p66)
    end,
})
v301:Toggle({
    Title = 'Load Wall Hop',
    Default = false,
    Callback = function(p67)
        u281(p67)
    end,
})
v301:Divider()
v301:Paragraph({
    Title = 'Graphics',
    Content = 'Low: removes textures, map looks flat, boosts FPS.\nHigh: Bloom, SunRays, enhanced lighting.',
})

local t32 = {
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

v301:Toggle(t32)

local t33 = {
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

v301:Toggle(t33)

local t34 = {
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

v301:Button(t34)
v301:Divider()
v301:Paragraph({
    Title = 'Extra Scripts',
    Content = 'Universal scripts and additional tools.',
})

local t35 = {
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

v301:Button(t35)

local t36 = {
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

v301:Button(t36)
v301:Divider()

local t37 = {
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

v301:Toggle(t37)

local t38 = {
    Title = 'Auto Ping Prediction',
    Description = 'Adds ping offset to shoot and throw',
    Default = false,
}
local u332 = v18

function t38.Callback(p75)
    u13 = p75

    local v821 = p75 and 'Ping Prediction ON' or 'Ping Prediction OFF'

    u332:Notify({
        Title = 'CrystalHub',
        Content = tostring(v821),
        Duration = 3,
        Icon = 'bell',
    })
end

v301:Toggle(t38)

local t39 = {
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

        u335:Notify({
            Title = 'CrystalHub',
            Content = tostring('Speed reset to 200'),
            Duration = 3,
            Icon = 'bell',
        })
    end)
end

v301:Button(t39)
v301:Dropdown({
    Title = 'Velocity Cap (Anti-Fling)',
    Options = {
        '50',
        '100',
        '150',
        '200',
        '300',
        '500',
    },
    Default = '200',
    Callback = function(p77)
        n1 = tonumber(p77) or 200
    end,
})


local t40 = {
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
    Title = 'Show Murderer',
    Default = true,
}
local u341 = t3

function t41.Callback(p79)
    u341.Murderer = p79
end

v302:Toggle(t41)

local t42 = {
    Title = 'Show Sheriff',
    Default = true,
}
local u343 = t3

function t42.Callback(p80)
    u343.Sheriff = p80
end

v302:Toggle(t42)

local t43 = {
    Title = 'Show Hero',
    Default = true,
}
local u345 = t3

function t43.Callback(p81)
    u345.Hero = p81
end

v302:Toggle(t43)

local t44 = {
    Title = 'Show Innocents',
    Default = true,
}
local u347 = t3

function t44.Callback(p82)
    u347.Innocent = p82
end

v302:Toggle(t44)

local t45 = {
    Title = 'Show Self',
    Default = true,
}
local u349 = t3

function t45.Callback(p83)
    u349.Self = p83
end

v302:Toggle(t45)

local t46 = {
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
    Title = 'Murderer Color',
    Default = Color3.fromRGB(255, 40, 40),
}
local u353 = t4

function t47.Callback(p85)
    u353.Murderer = p85
end

v302:ColorPicker(t47)

local t48 = {
    Title = 'Sheriff Color',
    Default = Color3.fromRGB(40, 130, 255),
}
local u355 = t4

function t48.Callback(p86)
    u355.Sheriff = p86
end

v302:ColorPicker(t48)

local t49 = {
    Title = 'Hero Color',
    Default = Color3.fromRGB(255, 215, 0),
}
local u357 = t4

function t49.Callback(p87)
    u357.Hero = p87
end

v302:ColorPicker(t49)

local t50 = {
    Title = 'Innocent Color',
    Default = Color3.fromRGB(0, 220, 0),
}
local u359 = t4

function t50.Callback(p88)
    u359.Innocent = p88
end

v302:ColorPicker(t50)
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
