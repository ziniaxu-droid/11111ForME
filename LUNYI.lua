local P=game:GetService("Players")
local W=game:GetService("Workspace")
local RF=game:GetService("ReplicatedFirst")
local RS=game:GetService("RunService")
local R8=game:GetService("ReplicatedStorage")
local lp=P.LocalPlayer

if getgenv().farmClean then pcall(getgenv().farmClean) end
getgenv().farmClean=nil

local AL=true
local CN={}
local function keep(c)
    CN[#CN+1]=c
    return c
end

local function ac()
    local rs=R8:FindFirstChild("remotes")
    if rs then
        local a=rs:FindFirstChild("anticlient")
        local h=rs:FindFirstChild("hellos")
        if a then pcall(function() a.OnClientInvoke=function() return true end end) end
        if h then
            pcall(function()
                h.OnClientInvoke=function()
                    if not (W:FindFirstChild("attacks") and W.attacks:IsA("Folder")) then return true end
                end
            end)
        end
    end
    if not R8:FindFirstChild("Stat_Changer_Thing") then
        local st=Instance.new("RemoteEvent")
        st.Name="Stat_Changer_Thing"
        st.Parent=R8
    end
    if not getgenv().farmKick then
        getgenv().farmKick=true
        pcall(function()
            local old
            old=hookmetamethod(game,"__namecall",newcclosure(function(s,...)
                if getnamecallmethod()=="Kick" and s==lp then return end
                return old(s,...)
            end))
        end)
    end
end

ac()

task.spawn(function()
    while AL do
        pcall(ac)
        task.wait(1)
    end
end)

local WN={bosses=true,cattacks=true,snt=true,stgs=true,votes=true,["???"]=true,Brian=true,chocosas=true,cloverdance=true,lobby=true,snowthedin=true,FatalP3TpEffectReplicator=true,farmplat=true}
local WK={}
local IG={on=false}
local IH={on=false}
local R1={}
local R2={}
local AR={}
local SP={}
local ST={on=false,busy=false,tp=nil}
local PF={on=false,pz=false,cf=CFrame.new(161.269272,218.317825,15.9927273),sz=Vector3.new(1024,8,1024)}
local AG={on=false,rad=45,dist=50}

for n in pairs(WN) do
    local o=W:FindFirstChild(n)
    if o then WK[o]=true end
end
local ff=RF:FindFirstChild("fakefatal")
if ff then
    local t=ff:FindFirstChild("FatalP3TpEffectReplicator")
    if t then WK[t]=true end
end

local function kp(o)
    local p=o
    while p and p~=W do
        if p.Name=="savestarv2" or p.Name=="savestar" then return true end
        if WK[p] or (p.Parent==W and WN[p.Name]) then return true end
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
        p=p.Parent
    end
    return false
end

local function at(o)
    local p=o
    while p and p~=W do
        if p.Name=="savestarv2" or p.Name=="savestar" then return false end
        if p.Parent==W and p.Name:lower():find("attack") then return true end
        p=p.Parent
    end
    return false
end

local function isp(q)
    if not q:IsA("ProximityPrompt") then return false end
    local p=q.Parent
    while p and p~=W do
        local n=p.Name:lower()
        if n:find("savestar") or n:find("save") or n:find("star") then return true end
        p=p.Parent
    end
    return false
end

local function sb(q)
    local p=q.Parent
    local top=q.Parent
    while p and p~=W do
        local n=p.Name:lower()
        if n:find("savestar") or n:find("save") or n:find("star") then top=p end
        p=p.Parent
    end
    return top
end

for _,d in ipairs(W:GetDescendants()) do
    if isp(d) then SP[d]=true end
end

local function a1(o)
    if not o:IsA("BasePart") then return end
    if kp(o) then return end
    if R1[o]==nil then R1[o]={c=o.CanCollide,t=o.CanTouch} end
    pcall(function()
        o.CanTouch=false
        o.CanCollide=false
    end)
end

local function s1()
    for _,d in ipairs(W:GetDescendants()) do a1(d) end
end

local function r1()
    for p,v in pairs(R1) do
        if p.Parent then
            pcall(function()
                p.CanTouch=v.t
                p.CanCollide=v.c
            end)
        end
    end
    R1={}
end

local function a2(o)
    if not o:IsA("BasePart") then return end
    if not at(o) then return end
    if R2[o]==nil then R2[o]={c=o.CanCollide,t=o.CanTouch} end
    pcall(function()
        o.CanTouch=false
        o.CanCollide=false
        local q=o:FindFirstChildOfClass("TouchTransmitter")
        if q then q:Destroy() end
    end)
end

local function s2()
    for _,c in ipairs(W:GetChildren()) do
        if c.Name:lower():find("attack") then
            for _,d in ipairs(c:GetDescendants()) do a2(d) end
        end
    end
end

local function r2()
    for p,v in pairs(R2) do
        if p.Parent then
            pcall(function()
                p.CanTouch=v.t
                p.CanCollide=v.c
            end)
        end
    end
    R2={}
end

local function t1()
    for p in pairs(R1) do
        if p.Parent then
            if p.CanTouch then p.CanTouch=false end
            if p.CanCollide then p.CanCollide=false end
        else
            R1[p]=nil
        end
    end
end

local function t2()
    for p in pairs(R2) do
        if p.Parent then
            if p.CanTouch then p.CanTouch=false end
            if p.CanCollide then p.CanCollide=false end
            local q=p:FindFirstChildOfClass("TouchTransmitter")
            if q then pcall(function() q:Destroy() end) end
        else
            R2[p]=nil
        end
    end
end

local function ar(c)
    if not c then return end
    for _,p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            if AR[p]==nil then AR[p]=p.CanTouch end
            if p.CanTouch then pcall(function() p.CanTouch=false end) end
        end
    end
end

local function ur()
    for p,v in pairs(AR) do
        if p.Parent then pcall(function() p.CanTouch=v end) end
    end
    AR={}
end

keep(W.DescendantAdded:Connect(function(o)
    if IG.on then a1(o) end
    if IH.on then a2(o) end
    if isp(o) then SP[o]=true end
end))

keep(RS.Heartbeat:Connect(function()
    if IG.on then t1() end
    if IH.on then t2() end
    if ST.busy then
        local c=lp.Character
        local r=c and c:FindFirstChild("HumanoidRootPart")
        if r then
            local q=ST.tp
            if q and q.Parent then
                local ok,pv=pcall(function() return q.Parent:GetPivot().Position end)
                if ok and pv then r.CFrame=CFrame.new(pv+Vector3.new(0,3,0))*r.CFrame.Rotation end
            end
            r.AssemblyLinearVelocity=Vector3.zero
        end
    end
end))

keep(lp.CharacterAdded:Connect(function(c)
    if IH.on then
        task.spawn(function()
            task.wait(0.5)
            if IH.on and c.Parent then pcall(ar,c) end
        end)
    end
end))

task.spawn(function()
    while AL do
        if IH.on then
            pcall(s2)
            pcall(function() ar(lp.Character) end)
        end
        if ST.on then
            for _,d in ipairs(W:GetDescendants()) do
                if isp(d) then SP[d]=true end
            end
        end
        task.wait(0.5)
    end
end)

local OP=OverlapParams.new()
OP.FilterType=Enum.RaycastFilterType.Exclude
local PP
local RP=RaycastParams.new()
RP.FilterType=Enum.RaycastFilterType.Exclude

local function fl(p)
    local f={lp.Character}
    if PP then f[#f+1]=PP end
    local a=W:FindFirstChild("attacks")
    if a then f[#f+1]=a end
    RP.FilterDescendantsInstances=f
    local ok,r=pcall(function() return W:Raycast(p,Vector3.new(0,-800,0),RP) end)
    if ok and r then return r.Position.Y end
    return -1e9
end

local function occ(p)
    if IG.on then return false end
    local f={lp.Character}
    if PP then f[#f+1]=PP end
    OP.FilterDescendantsInstances=f
    local ok,t=pcall(function() return W:GetPartBoundsInRadius(p,2.5,OP) end)
    if not ok then return false end
    local am=W:FindFirstChild("attacks")
    for _,x in ipairs(t) do
        if not (am and x:IsDescendantOf(am)) then
            local k=x.CanCollide
            local o=R1[x]
            if o then k=o.c end
            if k then return true end
        end
    end
    return false
end

local function dg()
    if ST.busy then return end
    local a=W:FindFirstChild("attacks")
    if not a then return end
    local c=lp.Character
    if not c then return end
    local r=c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local p=r.Position
    local lst={}
    local sv=a:FindFirstChild("savestarv2")
    for _,o in ipairs(a:GetDescendants()) do
        if o:IsA("BasePart") and not (sv and o:IsDescendantOf(sv)) then
            local d=(o.Position-p).Magnitude
            if d<AG.rad then lst[#lst+1]={o,d} end
        end
    end
    if #lst<1 then return end
    table.sort(lst,function(x,y) return x[2]<y[2] end)
    local near={}
    for i=1,math.min(#lst,10) do near[i]=lst[i][1] end
    local bp=near[1]
    local dir=Vector3.new(p.X-bp.Position.X,0,p.Z-bp.Position.Z)
    if dir.Magnitude<0.05 then dir=Vector3.new(1,0,0) end
    dir=dir.Unit
    local b=math.atan2(dir.Z,dir.X)
    local cd={}
    for i=0,11 do
        local a2=b+(i%2==1 and -1 or 1)*math.ceil(i/2)*(math.pi/6)
        cd[#cd+1]=p+Vector3.new(math.cos(a2),0,math.sin(a2))*AG.dist
    end
    cd[#cd+1]=p+Vector3.new(0,AG.dist,0)
    cd[#cd+1]=p+Vector3.new(0,AG.dist*1.5,0)
    cd[#cd+1]=p+dir*(AG.dist*0.7)+Vector3.new(0,AG.dist,0)
    cd[#cd+1]=p+dir*AG.dist+Vector3.new(0,AG.dist*1.5,0)
    local best,bs=nil,-1
    local hx=PF.sz.X/2-8
    local hz=PF.sz.Z/2-8
    for _,t in ipairs(cd) do
        if PF.on then
            t=Vector3.new(math.clamp(t.X,PF.cf.X-hx,PF.cf.X+hx),math.max(t.Y,PF.cf.Y),math.clamp(t.Z,PF.cf.Z-hz,PF.cf.Z+hz))
        end
        if t.Y>=fl(t)+1 and not occ(t) then
            local s=1e9
            for _,o in ipairs(near) do
                local d=(o.Position-t).Magnitude
                if d<s then s=d end
            end
            if s>bs then
                bs=s
                best=t
            end
        end
    end
    if not best then return end
    r.CFrame=CFrame.new(best)*r.CFrame.Rotation
    r.AssemblyLinearVelocity=Vector3.zero
end

task.spawn(function()
    while AL do
        if AG.on then pcall(dg) end
        task.wait(0.1)
    end
end)

local function pl()
    if not PF.on then return end
    if not PP or not PP.Parent then
        local q=Instance.new("Part")
        q.Name="farmplat"
        q.Anchored=true
        q.CanCollide=true
        q.CanTouch=false
        q.Transparency=1
        q.Size=PF.sz
        q.CFrame=CFrame.new(PF.cf.Position-Vector3.new(0,PF.sz.Y/2,0))
        q.Parent=W
        PP=q
        WK[q]=true
    end
    if not PP.CanCollide then PP.CanCollide=true end
    local c=lp.Character
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    if not PF.pz then
        local np=Vector3.new(PF.cf.X,PF.cf.Y+3,PF.cf.Z)
        r.CFrame=CFrame.new(np)*r.CFrame.Rotation
        r.AssemblyLinearVelocity=Vector3.zero
        PF.pz=true
    end
    if ST.busy then return end
    local p=r.Position
    local hx=PF.sz.X/2-8
    local hz=PF.sz.Z/2-8
    if math.abs(p.X-PF.cf.X)>hx or math.abs(p.Z-PF.cf.Z)>hz or p.Y<PF.cf.Y-2 then
        local np=Vector3.new(PF.cf.X,PF.cf.Y+3,PF.cf.Z)
        r.CFrame=CFrame.new(np)*r.CFrame.Rotation
        r.AssemblyLinearVelocity=Vector3.zero
    end
end

keep(RS.Heartbeat:Connect(function()
    if PF.on then pcall(pl) end
end))

keep(lp.CharacterAdded:Connect(function() PF.pz=false end))

local function st()
    local c=lp.Character
    local r=c and c:FindFirstChild("HumanoidRootPart")
    local best,bd,fb=nil,1e18,nil
    for q in pairs(SP) do
        if q.Parent then
            if not fb then fb=q end
            if q.Enabled and r then
                local ok,pv=pcall(function() return q.Parent:GetPivot().Position end)
                if ok and pv then
                    local d=(pv-r.Position).Magnitude
                    if d<bd then
                        bd=d
                        best=q
                    end
                elseif not best then
                    best=q
                end
            end
        else
            SP[q]=nil
        end
    end
    local q=best or fb
    if not q then return end
    return {o=sb(q),p=q}
end

local function sr()
    local c=lp.Character
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local t=st()
    if not t then return end
    local pp=t.p
    local s=t.o
    local rt=pp.Parent
    local pos=nil
    if rt:IsA("BasePart") then
        pos=rt.Position
    else
        local ok,pv=pcall(function() return rt:GetPivot().Position end)
        if ok then pos=pv end
    end
    if not pos then return end
    ST.tp=pp
    ST.busy=true
    local op=r.CFrame
    local np=pos+Vector3.new(0,3,0)
    r.CFrame=CFrame.new(np)*r.CFrame.Rotation
    r.AssemblyLinearVelocity=Vector3.zero
    local t0=os.clock()
    while AL and ST.on and rt.Parent and pp.Parent and os.clock()-t0<4 do
        local tp=pp.Parent
        local tpos=nil
        if tp:IsA("BasePart") then
            tpos=tp.Position
        else
            local o2,pv=pcall(function() return tp:GetPivot().Position end)
            if o2 then tpos=pv end
        end
        if tpos and (r.Position-tpos).Magnitude>pp.MaxActivationDistance*0.8 then
            r.CFrame=CFrame.new(tpos)*r.CFrame.Rotation
            r.AssemblyLinearVelocity=Vector3.zero
        end
        if not pp.Enabled then pcall(function() pp.Enabled=true end) end
        pcall(function() fireproximityprompt(pp) end)
        pcall(function()
            pp:InputHoldBegin()
            task.wait(pp.HoldDuration+0.05)
            pp:InputHoldEnd()
        end)
        if not pp.Enabled then break end
        task.wait(0.2)
    end
    local t1=os.clock()
    while AL and s.Parent and rt.Parent and pp.Parent and pp.Enabled and os.clock()-t1<10 do
        task.wait(0.2)
    end
    ST.busy=false
    ST.tp=nil
    if not r.Parent then return end
    r.CFrame=op
    r.AssemblyLinearVelocity=Vector3.zero
    task.wait(1)
end

task.spawn(function()
    while AL do
        if ST.on then pcall(sr) end
        task.wait(0.5)
    end
end)

local function off()
    IG.on=false
    IH.on=false
    AG.on=false
    PF.on=false
    PF.pz=false
    ST.on=false
    ST.busy=false
    ST.tp=nil
    if PP then
        pcall(function() PP:Destroy() end)
        PP=nil
    end
    pcall(ur)
    r1()
    r2()
end

local function on()
    IG.on=true
    pcall(s1)
    IH.on=true
    pcall(s2)
    pcall(ar,lp.Character)
    AG.on=true
    PF.on=true
    PF.pz=false
    pcall(pl)
    ST.on=true
end

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

getgenv().farmClean=function()
    AL=false
    off()
    for _,c in ipairs(CN) do pcall(function() c:Disconnect() end) end
    CN={}
    local pg=lp:FindFirstChild("PlayerGui")
    if pg then
        local ui=pg:FindFirstChild("FarmUI")
        if ui then ui:Destroy() end
    end
end
