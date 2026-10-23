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
Main.Size = UDim2.new(0, 280, 0, 320)
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

-- ==================== 清理 ====================
getgenv().igClean = function()
    AL = false
    if CON then pcall(function() CON:Disconnect() end) end
    for _, c in ipairs(CN) do pcall(function() c:Disconnect() end) end
    CN = {}
    EN.esp = false
    EN.al = false
    ec()
    rsA()
    rsW()
    IGW.on = false
    if ScreenGui then ScreenGui:Destroy() end
    if notifySound then notifySound:Destroy() end
end

Notify("加载完成", "点击右下角圆点或按 Insert 隐藏/显示")

-- ==================== 悬浮开关圆点 ====================
local ToggleDot = Instance.new("TextButton")
ToggleDot.Name = "ToggleDot"
ToggleDot.Size = UDim2.new(0, 36, 0, 36)
ToggleDot.Position = UDim2.new(1, -50, 1, -50)
ToggleDot.AnchorPoint = Vector2.new(1, 1)
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
