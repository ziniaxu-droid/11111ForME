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
