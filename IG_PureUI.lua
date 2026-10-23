local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 清理旧实例
if getgenv().igClean then pcall(getgenv().igClean) end
getgenv().igOn = true

local AL = true
local CN = {}
local function keep(c)
    table.insert(CN, c)
    return c
end

-- 通知音效
local notifySound = Instance.new("Sound")
notifySound.SoundId = "rbxassetid://6895079853"
notifySound.Volume = 2
notifySound.Parent = CoreGui

local function Notify(title, msg)
    pcall(function() notifySound:Play() end)
    print("[IG] " .. title .. ": " .. msg)
end

-- ==================== 功能变量 ====================
local IG = { on = false }
local IGW = { on = false }
local AM = nil
local CON = nil
local REC = {}
local RECA = {}

local EN = { esp = false, al = false }
local EA = {}
local EL = {}

-- ==================== 无视攻击逻辑 ====================
local function g(o)
    if o:IsA("BasePart") then
        if RECA[o] == nil then RECA[o] = { c = o.CanCollide } end
        pcall(function()
            o.CanTouch = false
            o.CanCollide = false
        end)
    end
end

local function rsA()
    for p, v in pairs(RECA) do
        pcall(function()
            p.CanTouch = true
            p.CanCollide = v.c
        end)
    end
    RECA = {}
end

local function sw(a)
    for _, d in ipairs(a:GetDescendants()) do g(d) end
end

local function gw(o)
    if o:IsA("BasePart") then
        if REC[o] == nil then REC[o] = { c = o.CanCollide } end
        pcall(function()
            o.CanTouch = false
            o.CanCollide = false
        end)
    end
end

local function swW()
    for _, d in ipairs(Workspace:GetDescendants()) do gw(d) end
end

local function rsW()
    for p, v in pairs(REC) do
        pcall(function()
            p.CanTouch = true
            p.CanCollide = v.c
        end)
    end
    REC = {}
end

keep(Workspace.DescendantAdded:Connect(function(o)
    if IGW.on then gw(o) end
end))

local function bind(a)
    if CON then pcall(function() CON:Disconnect() end) end
    AM = a
    CON = a.DescendantAdded:Connect(function(o)
        if IG.on then g(o) end
    end)
    sw(a)
end

task.spawn(function()
    while AL do
        if IG.on then
            if not AM or not AM.Parent then
                local a = Workspace:FindFirstChild("AttackModel")
                if a then bind(a) end
            else
                sw(AM)
            end
            for p in pairs(RECA) do
                if not p.Parent then RECA[p] = nil end
            end
        end
        task.wait(IG.on and 0.5 or 1)
    end
end)

task.spawn(function()
    while AL do
        task.wait(1)
        if not IG.on and not IGW.on then
            if next(RECA) ~= nil then rsA() end
            if next(REC) ~= nil then rsW() end
        end
    end
end)

-- ==================== ESP / 锁定逻辑 ====================
local function eo()
    return Workspace:FindFirstChild("Enemyalive")
end

local function eb(o)
    if o:IsA("BasePart") then return o end
    local p = o.PrimaryPart
    if p then return p end
    p = o:FindFirstChild("HumanoidRootPart")
    if p then return p end
    return o:FindFirstChildWhichIsA("BasePart", true)
end

local function ek(o)
    local d = EA[o]
    if not d then return end
    if d.h then pcall(function() d.h:Destroy() end) end
    if d.b then pcall(function() d.b:Destroy() end) end
    EA[o] = nil
end

local function ea(o)
    if EA[o] then return end
    local p = eb(o)
    if not p then return end

    local h = Instance.new("Highlight")
    h.FillColor = Color3.new(1, 1, 1)
    h.OutlineColor = Color3.new(1, 1, 1)
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    pcall(function() h.Parent = o end)

    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 32, 0, 32)
    b.StudsOffset = Vector3.new(0, p.Size.Y / 2 + 2.5, 0)
    b.AlwaysOnTop = true
    b.Adornee = p
    b.Parent = p

    local a = Instance.new("TextLabel")
    a.Size = UDim2.new(1, 0, 1, 0)
    a.BackgroundTransparency = 1
    a.Text = "▼"
    a.TextColor3 = Color3.fromRGB(255, 0, 0)
    a.TextStrokeTransparency = 0
    a.TextScaled = true
    a.Font = Enum.Font.GothamBold
    a.Parent = b

    EA[o] = { h = h, b = b }
end

local function es()
    local f = eo()
    if not f then return end
    local seen = {}
    local function wk(p)
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("Model") or c:IsA("BasePart") then
                seen[c] = true
                if not EA[c] then ea(c) end
            elseif c:IsA("Folder") then
                wk(c)
            end
        end
    end
    wk(f)
    for o in pairs(EA) do
        if not seen[o] then ek(o) end
    end
end

local function ec()
    for o in pairs(EA) do ek(o) end
end

local function eu()
    EL = {}
    local f = eo()
    if not f then return end
    local function wk(p)
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("Model") then
                local b = eb(c)
                if b then table.insert(EL, b) end
            elseif c:IsA("BasePart") then
                table.insert(EL, c)
            elseif c:IsA("Folder") then
                wk(c)
            end
        end
    end
    wk(f)
end

task.spawn(function()
    while AL do
        if EN.esp then es() end
        if EN.al then eu() end
        task.wait(0.5)
    end
end)

keep(RunService.RenderStepped:Connect(function()
    if not EN.al then return end
    local c = LocalPlayer.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not r then return end

    local bp, bd = nil, math.huge
    for i = 1, #EL do
        local p = EL[i]
        if p.Parent then
            local d = (p.Position - r.Position).Magnitude
            if d < bd then bd = d; bp = p end
        end
    end
    if not bp then return end

    local cm = Workspace.CurrentCamera
    if not cm then return end
    cm.CFrame = CFrame.lookAt(cm.CFrame.Position, bp.Position)
end))

-- ==================== 纯手写 UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IG_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 500)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(60, 60, 70)
Stroke.Thickness = 1
Stroke.Parent = Main

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 8)
TitleFix.Position = UDim2.new(0, 0, 1, -8)
TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "无视攻击"
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- 拖动
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 内容区
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -48)
Content.Position = UDim2.new(0, 8, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

-- 创建开关行
local function CreateToggle(name, default, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 32)
    Row.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 40, 0, 20)
    Toggle.Position = UDim2.new(1, -48, 0.5, -10)
    Toggle.BackgroundColor3 = default and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(55, 55, 65)
    Toggle.Text = ""
    Toggle.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local state = default
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.BackgroundColor3 = state and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(55, 55, 65)
        Knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if callback then callback(state) end
    end)

    return {
        Set = function(v)
            state = v
            Toggle.BackgroundColor3 = state and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(55, 55, 65)
            Knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        end,
        Get = function() return state end
    }
end

-- 创建按钮
local function CreateButton(name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.Parent = Content

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return Btn
end

-- ==================== 绑定功能 ====================
local toggles = {}

toggles.IG = CreateToggle("无视攻击", false, function(v)
    IG.on = v
    if v then
        local a = Workspace:FindFirstChild("AttackModel")
        if a then bind(a) end
        Notify("开启", "无视攻击")
    else
        if CON then pcall(function() CON:Disconnect() end) end
        CON = nil
        AM = nil
        task.delay(0.6, rsA)
        Notify("关闭", "无视攻击")
    end
end)

toggles.IGW = CreateToggle("全图无视", false, function(v)
    IGW.on = v
    if v then
        swW()
        Notify("开启", "全图无视")
    else
        task.delay(0.2, rsW)
        Notify("关闭", "全图无视")
    end
end)

CreateButton("强制恢复", function()
    IG.on = false
    IGW.on = false
    if CON then pcall(function() CON:Disconnect() end) end
    CON = nil
    AM = nil
    toggles.IG.Set(false)
    toggles.IGW.Set(false)
    task.delay(0.6, function()
        rsA()
        rsW()
        Notify("完成", "已恢复")
    end)
end)

toggles.ESP = CreateToggle("敌人 ESP", false, function(v)
    EN.esp = v
    if v then
        es()
        Notify("开启", "敌人 ESP")
    else
        ec()
        Notify("关闭", "敌人 ESP")
    end
end)

toggles.AL = CreateToggle("锁定最近", false, function(v)
    EN.al = v
    Notify(v and "开启" or "关闭", "锁定最近")
end)

-- ==================== 速度 / 跳跃 ====================
local SpeedEnabled = false
local JumpEnabled = false
local SpeedValue = 16
local JumpValue = 50
local OriginalSpeed = nil
local OriginalJump = nil

local function captureOriginal()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if OriginalSpeed == nil then
            OriginalSpeed = hum.WalkSpeed
        end
        if OriginalJump == nil then
            OriginalJump = hum.JumpPower
        end
    end
end

local function applySpeed()
    if not SpeedEnabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SpeedValue
    end
end

local function applyJump()
    if not JumpEnabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = JumpValue
        hum.UseJumpPower = true
    end
end

local function restoreSpeed()
    if OriginalSpeed == nil then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = OriginalSpeed
    end
end

local function restoreJump()
    if OriginalJump == nil then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = OriginalJump
    end
end

-- 角色生成时记录原始值 + 停止飞行
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    captureOriginal()
    if SpeedEnabled then applySpeed() end
    if JumpEnabled then applyJump() end
    if FlyEnabled then
        FlyEnabled = false
        stopFly()
    end
end)

-- 如果角色已经存在，立即记录
if LocalPlayer.Character then
    task.defer(captureOriginal)
end

-- 持续保持（仅开启时）
task.spawn(function()
    while AL do
        if SpeedEnabled then applySpeed() end
        if JumpEnabled then applyJump() end
        task.wait(0.5)
    end
end)

-- 创建输入行（带开关）
local function CreateInputRow(name, defaultVal, onToggle, onValueChange)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    -- 开关
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 36, 0, 18)
    Toggle.Position = UDim2.new(0, 8, 0.5, -9)
    Toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Toggle.Text = ""
    Toggle.Parent = Row
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    -- 名称
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 50, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    -- 输入框
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 70, 0, 24)
    Input.Position = UDim2.new(1, -80, 0.5, -12)
    Input.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    Input.Text = tostring(defaultVal)
    Input.PlaceholderText = "数值"
    Input.TextColor3 = Color3.fromRGB(200, 220, 200)
    Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    Input.TextSize = 13
    Input.Font = Enum.Font.Gotham
    Input.ClearTextOnFocus = false
    Input.Parent = Row
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 4)
    InputCorner.Parent = Input

    local enabled = false

    local function setEnabled(v)
        enabled = v
        Toggle.BackgroundColor3 = v and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(55, 55, 65)
        Knob.Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        if onToggle then onToggle(v) end
    end

    Toggle.MouseButton1Click:Connect(function()
        setEnabled(not enabled)
    end)

    Input.FocusLost:Connect(function()
        local num = tonumber(Input.Text)
        if num and num > 0 then
            if onValueChange then onValueChange(num) end
        else
            Input.Text = tostring(defaultVal)
            if onValueChange then onValueChange(defaultVal) end
        end
    end)

    return {
        SetEnabled = setEnabled,
        GetEnabled = function() return enabled end,
        SetValue = function(v)
            Input.Text = tostring(v)
            if onValueChange then onValueChange(v) end
        end
    }
end

local speedRow = CreateInputRow("速度", 16, function(v)
    SpeedEnabled = v
    if v then
        applySpeed()
        Notify("开启", "速度修改")
    else
        restoreSpeed()
        Notify("关闭", "已恢复原始速度")
    end
end, function(v)
    SpeedValue = v
    if SpeedEnabled then applySpeed() end
end)

local jumpRow = CreateInputRow("跳跃", 50, function(v)
    JumpEnabled = v
    if v then
        applyJump()
        Notify("开启", "跳跃修改")
    else
        restoreJump()
        Notify("关闭", "已恢复原始跳跃")
    end
end, function(v)
    JumpValue = v
    if JumpEnabled then applyJump() end
end)

-- ==================== 飞行 ====================
local FlyEnabled = false
local FlySpeed = 50
local flyBV, flyBG
local flyConn

local function stopFly()
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        pcall(function()
            for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                hum:SetStateEnabled(state, true)
            end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local animate = char and char:FindFirstChild("Animate")
    if animate then animate.Disabled = false end
end

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hum or not root then return end

    stopFly()

    -- 禁用状态
    pcall(function()
        for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
            hum:SetStateEnabled(state, false)
        end
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
    end)
    hum.PlatformStand = true
    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = true end

    flyBG = Instance.new("BodyGyro")
    flyBG.P = 9e4
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.CFrame = root.CFrame
    flyBG.Parent = root

    flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.zero
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Parent = root

    local ctrl = { f = 0, b = 0, l = 0, r = 0 }

    flyConn = RunService.RenderStepped:Connect(function()
        if not FlyEnabled or not root.Parent then
            stopFly()
            return
        end

        local cam = Workspace.CurrentCamera
        if not cam then return end

        -- 读取输入
        ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
        ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
        ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
        ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0

        local move = Vector3.zero
        if ctrl.f + ctrl.b ~= 0 or ctrl.l + ctrl.r ~= 0 then
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            move = (look * (ctrl.f + ctrl.b) + right * (ctrl.l + ctrl.r)).Unit * FlySpeed
        end

        -- 上下
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, FlySpeed, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            move = move + Vector3.new(0, -FlySpeed, 0)
        end

        flyBV.Velocity = move
        flyBG.CFrame = cam.CFrame
    end)
end

-- ==================== 飞行小面板 ====================
local FlyPanel = Instance.new("Frame")
FlyPanel.Name = "FlyPanel"
FlyPanel.Size = UDim2.new(0, 200, 0, 140)
FlyPanel.Position = UDim2.new(0.5, -100, 0.3, 0)
FlyPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FlyPanel.BorderSizePixel = 0
FlyPanel.Visible = false
FlyPanel.Parent = ScreenGui

local FlyPanelCorner = Instance.new("UICorner")
FlyPanelCorner.CornerRadius = UDim.new(0, 8)
FlyPanelCorner.Parent = FlyPanel

local FlyPanelStroke = Instance.new("UIStroke")
FlyPanelStroke.Color = Color3.fromRGB(60, 60, 70)
FlyPanelStroke.Thickness = 1
FlyPanelStroke.Parent = FlyPanel

-- 标题栏
local FlyTitle = Instance.new("Frame")
FlyTitle.Size = UDim2.new(1, 0, 0, 28)
FlyTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
FlyTitle.BorderSizePixel = 0
FlyTitle.Parent = FlyPanel

local FlyTitleCorner = Instance.new("UICorner")
FlyTitleCorner.CornerRadius = UDim.new(0, 8)
FlyTitleCorner.Parent = FlyTitle

local FlyTitleFix = Instance.new("Frame")
FlyTitleFix.Size = UDim2.new(1, 0, 0, 6)
FlyTitleFix.Position = UDim2.new(0, 0, 1, -6)
FlyTitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
FlyTitleFix.BorderSizePixel = 0
FlyTitleFix.Parent = FlyTitle

local FlyTitleLabel = Instance.new("TextLabel")
FlyTitleLabel.Size = UDim2.new(1, -30, 1, 0)
FlyTitleLabel.Position = UDim2.new(0, 8, 0, 0)
FlyTitleLabel.BackgroundTransparency = 1
FlyTitleLabel.Text = "飞行控制"
FlyTitleLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
FlyTitleLabel.TextSize = 13
FlyTitleLabel.Font = Enum.Font.GothamBold
FlyTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyTitleLabel.Parent = FlyTitle

local FlyClose = Instance.new("TextButton")
FlyClose.Size = UDim2.new(0, 22, 0, 22)
FlyClose.Position = UDim2.new(1, -26, 0, 3)
FlyClose.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
FlyClose.Text = "×"
FlyClose.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyClose.TextSize = 16
FlyClose.Font = Enum.Font.GothamBold
FlyClose.Parent = FlyTitle
local FlyCloseCorner = Instance.new("UICorner")
FlyCloseCorner.CornerRadius = UDim.new(0, 4)
FlyCloseCorner.Parent = FlyClose

FlyClose.MouseButton1Click:Connect(function()
    FlyPanel.Visible = false
    if FlyEnabled then
        FlyEnabled = false
        stopFly()
    end
end)

-- 拖动
local flyDragging, flyDragStart, flyStartPos
FlyTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDragging = true
        flyDragStart = input.Position
        flyStartPos = FlyPanel.Position
    end
end)
FlyTitle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if flyDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - flyDragStart
        FlyPanel.Position = UDim2.new(flyStartPos.X.Scale, flyStartPos.X.Offset + delta.X, flyStartPos.Y.Scale, flyStartPos.Y.Offset + delta.Y)
    end
end)

-- 内容区
local FlyContent = Instance.new("Frame")
FlyContent.Size = UDim2.new(1, -12, 1, -36)
FlyContent.Position = UDim2.new(0, 6, 0, 32)
FlyContent.BackgroundTransparency = 1
FlyContent.Parent = FlyPanel

-- UP / DOWN / Fly 按钮行
local function makeFlyBtn(text, x, y, w, h, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, w, 0, h)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 235)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    return btn
end

local upBtn = makeFlyBtn("UP", 0, 0, 58, 28, Color3.fromRGB(50, 50, 60), FlyContent)
local downBtn = makeFlyBtn("DOWN", 64, 0, 58, 28, Color3.fromRGB(50, 50, 60), FlyContent)
local flyBtn = makeFlyBtn("飞行", 128, 0, 58, 28, Color3.fromRGB(55, 55, 65), FlyContent)

-- 速度行
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 40, 0, 28)
speedLabel.Position = UDim2.new(0, 0, 0, 36)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = FlyContent

local minusBtn = makeFlyBtn("-", 42, 36, 28, 28, Color3.fromRGB(50, 50, 60), FlyContent)
local speedVal = Instance.new("TextLabel")
speedVal.Size = UDim2.new(0, 40, 0, 28)
speedVal.Position = UDim2.new(0, 74, 0, 36)
speedVal.BackgroundTransparency = 1
speedVal.Text = "50"
speedVal.TextColor3 = Color3.fromRGB(180, 220, 180)
speedVal.TextSize = 14
speedVal.Font = Enum.Font.GothamBold
speedVal.Parent = FlyContent

local plusBtn = makeFlyBtn("+", 116, 36, 28, 28, Color3.fromRGB(50, 50, 60), FlyContent)

-- 飞行逻辑
local function updateFlyBtn()
    flyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(55, 55, 65)
    flyBtn.Text = FlyEnabled and "飞行中" or "飞行"
end

flyBtn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        startFly()
        Notify("开启", "飞行")
    else
        stopFly()
        Notify("关闭", "飞行")
    end
    updateFlyBtn()
end)

plusBtn.MouseButton1Click:Connect(function()
    FlySpeed = math.min(FlySpeed + 10, 500)
    speedVal.Text = tostring(FlySpeed)
end)

minusBtn.MouseButton1Click:Connect(function()
    FlySpeed = math.max(FlySpeed - 10, 5)
    speedVal.Text = tostring(FlySpeed)
end)

-- UP / DOWN 持续上升下降
local upHolding, downHolding = false, false

upBtn.MouseButton1Down:Connect(function() upHolding = true end)
upBtn.MouseButton1Up:Connect(function() upHolding = false end)
upBtn.MouseLeave:Connect(function() upHolding = false end)

downBtn.MouseButton1Down:Connect(function() downHolding = true end)
downBtn.MouseButton1Up:Connect(function() downHolding = false end)
downBtn.MouseLeave:Connect(function() downHolding = false end)

-- 把上下控制加入飞行循环
local oldStartFly = startFly
startFly = function()
    oldStartFly()
    -- 额外的上下按住逻辑通过 RenderStepped 处理
end

-- 在现有 flyConn 之外再加一个轻量检查（实际上下已在 startFly 的 RenderStepped 里通过键盘处理）
-- 这里给按钮补一个持续位移
RunService.RenderStepped:Connect(function()
    if not FlyEnabled then return end
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
    if not root or not flyBV then return end

    local extra = Vector3.zero
    if upHolding then extra = extra + Vector3.new(0, FlySpeed, 0) end
    if downHolding then extra = extra + Vector3.new(0, -FlySpeed, 0) end
    if extra.Magnitude > 0 then
        flyBV.Velocity = flyBV.Velocity + extra
    end
end)

-- 主界面按钮打开飞行面板
CreateButton("飞行控制", function()
    FlyPanel.Visible = not FlyPanel.Visible
end)

-- ==================== 清理 ====================
getgenv().igClean = function()
    AL = false
    if CON then pcall(function() CON:Disconnect() end) end
    for _, c in ipairs(CN) do pcall(function() c:Disconnect() end) end
    CN = {}
    EN.esp = false
    EN.al = false
    FlyEnabled = false
    stopFly()
    ec()
    rsA()
    rsW()
    IGW.on = false
    if ScreenGui then ScreenGui:Destroy() end
    if notifySound then notifySound:Destroy() end
end

Notify("加载完成", "点击右上角圆点或按 Insert 隐藏/显示")

-- ==================== 悬浮开关圆点 ====================
local ToggleDot = Instance.new("TextButton")
ToggleDot.Name = "ToggleDot"
ToggleDot.Size = UDim2.new(0, 36, 0, 36)
ToggleDot.Position = UDim2.new(1, -50, 0, 80)
ToggleDot.AnchorPoint = Vector2.new(1, 0)
ToggleDot.BackgroundColor3 = Color3.fromRGB(70, 160, 90)
ToggleDot.Text = ""
ToggleDot.AutoButtonColor = false
ToggleDot.Parent = ScreenGui

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = ToggleDot

local DotStroke = Instance.new("UIStroke")
DotStroke.Color = Color3.fromRGB(100, 200, 120)
DotStroke.Thickness = 2
DotStroke.Parent = ToggleDot

-- 圆点拖动
local dotDragging, dotDragStart, dotStartPos
ToggleDot.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dotDragging = true
        dotDragStart = input.Position
        dotStartPos = ToggleDot.Position
    end
end)
ToggleDot.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dotDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dotDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dotDragStart
        ToggleDot.Position = UDim2.new(
            dotStartPos.X.Scale, dotStartPos.X.Offset + delta.X,
            dotStartPos.Y.Scale, dotStartPos.Y.Offset + delta.Y
        )
    end
end)

-- 点击圆点切换主界面
local function toggleMain()
    Main.Visible = not Main.Visible
    ToggleDot.BackgroundColor3 = Main.Visible and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(80, 80, 90)
    DotStroke.Color = Main.Visible and Color3.fromRGB(100, 200, 120) or Color3.fromRGB(120, 120, 130)
end

ToggleDot.MouseButton1Click:Connect(toggleMain)

-- Insert 键开关 UI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleMain()
    end
end)
