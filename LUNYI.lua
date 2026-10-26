-- 纯手写简单 UI
local function createUI()
    local ok, err = pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "FarmUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = lp:WaitForChild("PlayerGui")

        local Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.Size = UDim2.new(0, 220, 0, 110)
        Main.Position = UDim2.new(0.5, -110, 0.5, -55)
        Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Main.BorderSizePixel = 0
        Main.Active = true
        Main.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Main

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Title.BorderSizePixel = 0
        Title.Text = "轮椅 Farm"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = Main

        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 8)
        TitleCorner.Parent = Title

        local Close = Instance.new("TextButton")
        Close.Size = UDim2.new(0, 30, 0, 30)
        Close.Position = UDim2.new(1, -30, 0, 0)
        Close.BackgroundTransparency = 1
        Close.Text = "X"
        Close.TextColor3 = Color3.fromRGB(255, 80, 80)
        Close.Font = Enum.Font.GothamBold
        Close.TextSize = 16
        Close.Parent = Main

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, -20, 0, 40)
        ToggleBtn.Position = UDim2.new(0, 10, 0, 45)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleBtn.BorderSizePixel = 0
        ToggleBtn.Text = "轮椅: 关闭"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Font = Enum.Font.Gotham
        ToggleBtn.TextSize = 14
        ToggleBtn.Parent = Main

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = ToggleBtn

        local enabled = false
        ToggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                on()
                ToggleBtn.Text = "轮椅: 开启"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 40)
            else
                off()
                ToggleBtn.Text = "轮椅: 关闭"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)

        Close.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            if getgenv().farmClean then
                getgenv().farmClean()
            end
        end)

        -- 简易拖拽
        local dragging, dragStart, startPos
        Main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end)
        Main.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end)
    if not ok then
        warn("UI创建失败:", err)
    end
end

createUI()

getgenv().farmClean = function()
    AL = false
    off()
    for _, c in ipairs(CN) do
        pcall(function() c:Disconnect() end)
    end
    CN = {}
    local pg = lp:FindFirstChild("PlayerGui")
    if pg then
        local ui = pg:FindFirstChild("FarmUI")
        if ui then ui:Destroy() end
    end
end
