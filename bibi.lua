-- Load the Universal UI Library
local UniversalUI = loadstring(game:HttpGet("https://scriptblox.com/script/Universal-Script-ui-library-15556"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Variables
local teleportTargets = {
    "Alien", "Alien Chest", "Alien Shelf", "Alpha Wolf", "Alpha Wolf Pelt", "Anvil Base", "Apple", "Bandage", "Bear", "Berry",
    "Bolt", "Broken Fan", "Broken Microwave", "Bunny", "Bunny Foot", "Cake", "Carrot", "Chair Set", "Chest", "Chilli",
    "Coal", "Coin Stack", "Crossbow Cultist", "Cultist", "Cultist Gem", "Deer", "Fuel Canister", "Giant Sack", "Good Axe", "Iron Body",
    "Item Chest", "Item Chest2", "Item Chest3", "Item Chest4", "Item Chest6", "Laser Fence Blueprint", "Laser Sword", "Leather Body", "Log", "Lost Child",
    "Lost Child2", "Lost Child3", "Lost Child4", "Medkit", "Meat? Sandwich", "Morsel", "Old Car Engine", "Old Flashlight", "Old Radio", "Oil Barrel",
    "Raygun", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Riot Shield", "Sapling", "Seed Box", "Sheet Metal", "Spear",
    "Steak", "Stronghold Diamond Chest", "Tyre", "UFO Component", "UFO Junk", "Washing Machine", "Wolf", "Wolf Corpse", "Wolf Pelt"
}
local AimbotTargets = {"Alien", "Alpha Wolf", "Wolf", "Crossbow Cultist", "Cultist", "Bunny", "Bear", "Polar Bear"}
local espEnabled = false
local npcESPEnabled = false
local ignoreDistanceFrom = Vector3.new(0, 0, 0)
local minDistance = 50
local AutoTreeFarmEnabled = false

-- Create the UI Window
local Window = UniversalUI.new({
    Title = "Grizz Hub",
    SubTitle = "99 Nights in the Forest",
    Tabs = {"Home", "Teleport", "Player", "Auto Farm", "Kill Aura", "Item ESP", "Mob ESP", "Visuals", "Misc"}
})

-- Virtual input
local VirtualInputManager = game:GetService("VirtualInputManager")
function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Safe Zone
local safezoneBaseplates = {}
local baseplateSize = Vector3.new(2048, 1, 2048)
for dx = -1, 1 do
    for dz = -1, 1 do
        local pos = Vector3.new(dx * baseplateSize.X, 100, dz * baseplateSize.Z)
        local baseplate = Instance.new("Part")
        baseplate.Name = "SafeZoneBaseplate"
        baseplate.Size = baseplateSize
        baseplate.Position = pos
        baseplate.Anchored = true
        baseplate.CanCollide = true
        baseplate.Transparency = 1
        baseplate.Color = Color3.fromRGB(255, 255, 255)
        baseplate.Parent = workspace
        table.insert(safezoneBaseplates, baseplate)
    end
end

-- ESP Functions
local function createESP(item)
    local adorneePart
    if item:IsA("Model") then
        if item:FindFirstChildWhichIsA("Humanoid") then return end
        adorneePart = item:FindFirstChildWhichIsA("BasePart")
    elseif item:IsA("BasePart") then
        adorneePart = item
    else
        return
    end

    local distance = (adorneePart.Position - ignoreDistanceFrom).Magnitude
    if distance < minDistance then return end

    if not item:FindFirstChild("ESP_Billboard") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = adorneePart
        billboard.Size = UDim2.new(0, 50, 0, 20)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = item.Name
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        billboard.Parent = item
    end

    if not item:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 85, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0
        highlight.Adornee = item:IsA("Model") and item or adorneePart
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = item
    end
end

local function toggleESP(state)
    espEnabled = state
    for _, item in pairs(workspace:GetDescendants()) do
        if table.find(teleportTargets, item.Name) then
            if espEnabled then
                createESP(item)
            else
                if item:FindFirstChild("ESP_Billboard") then item.ESP_Billboard:Destroy() end
                if item:FindFirstChild("ESP_Highlight") then item.ESP_Highlight:Destroy() end
            end
        end
    end
end

-- NPC ESP
local npcBoxes = {}
local function createNPCESP(npc)
    if not npc:IsA("Model") or npc:FindFirstChild("HumanoidRootPart") == nil then return end
    local root = npc:FindFirstChild("HumanoidRootPart")
    if npcBoxes[npc] then return end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 85, 0)
    box.Filled = false
    box.Visible = true

    local nameText = Drawing.new("Text")
    nameText.Text = npc.Name
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = true

    npcBoxes[npc] = {box = box, name = nameText}

    npc.AncestryChanged:Connect(function(_, parent)
        if not parent and npcBoxes[npc] then
            npcBoxes[npc].box:Remove()
            npcBoxes[npc].name:Remove()
            npcBoxes[npc] = nil
        end
    end)
end

local function toggleNPCESP(state)
    npcESPEnabled = state
    if not state then
        for npc, visuals in pairs(npcBoxes) do
            if visuals.box then visuals.box:Remove() end
            if visuals.name then visuals.name:Remove() end
        end
        npcBoxes = {}
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if table.find(AimbotTargets, obj.Name) and obj:IsA("Model") then
                createNPCESP(obj)
            end
        end
    end
end

-- Home Tab
local Home = Window.Tabs.Home

Home:AddButton({
    Title = "Teleport to Campfire",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
    end
})

Home:AddButton({
    Title = "Teleport to Grinder",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(16.1,4,-4.6))
    end
})

Home:AddToggle({
    Title = "Item ESP",
    Callback = function(state)
        toggleESP(state)
    end
})

Home:AddToggle({
    Title = "NPC ESP",
    Callback = function(state)
        toggleNPCESP(state)
    end
})

Home:AddToggle({
    Title = "Auto Tree Farm",
    Callback = function(state)
        AutoTreeFarmEnabled = state
    end
})

Home:AddToggle({
    Title = "Show Safe Zone",
    Callback = function(state)
        for _, baseplate in ipairs(safezoneBaseplates) do
            baseplate.Transparency = state and 0.8 or 1
            baseplate.CanCollide = state
        end
    end
})

-- Aimbot
local AimbotEnabled = false
Home:AddToggle({
    Title = "Aimbot (Right Click)",
    Callback = function(state)
        AimbotEnabled = state
    end
})

-- Fly
local flying, flyConnection = false, nil
local speed = 60
local function startFlying()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bodyGyro = Instance.new("BodyGyro", hrp)
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flyConnection = RunService.RenderStepped:Connect(function()
        local moveVec = Vector3.zero
        local camCF = camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += camCF.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= camCF.UpVector end
        bodyVelocity.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * speed or Vector3.zero
        bodyGyro.CFrame = camCF
    end)
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

Home:AddToggle({
    Title = "Fly (WASD + Space + Shift)",
    Callback = function(state)
        flying = state
        if flying then startFlying() else stopFlying() end
    end
})

-- Teleport Tab
local Teleport = Window.Tabs.Teleport

for _, itemName in ipairs(teleportTargets) do
    Teleport:AddButton({
        Title = "TP to " .. itemName,
        Callback = function()
            local closest, shortest = nil, math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == itemName and obj:IsA("Model") then
                    local cf = nil
                    if pcall(function() cf = obj:GetPivot() end) then
                    else
                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part then cf = part.CFrame end
                    end
                    if cf then
                        local dist = (cf.Position - ignoreDistanceFrom).Magnitude
                        if dist >= minDistance and dist < shortest then
                            closest = obj
                            shortest = dist
                        end
                    end
                end
            end
            if closest then
                local cf = nil
                if pcall(function() cf = closest:GetPivot() end) then
                else
                    local part = closest:FindFirstChildWhichIsA("BasePart")
                    if part then cf = part.CFrame end
                end
                if cf then
                    LocalPlayer.Character:PivotTo(cf + Vector3.new(0, 5, 0))
                end
            end
        end
    })
end

-- Player Tab
local Player = Window.Tabs.Player

Player:AddSlider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

Player:AddSlider({
    Title = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

Player:AddToggle({
    Title = "Speed Hack (50)",
    Callback = function(state)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = state and 50 or 16
        end
    end
})

-- Auto Farm Tab
local AutoFarm = Window.Tabs["Auto Farm"]

AutoFarm:AddToggle({
    Title = "Auto Feed Campfire",
    Callback = function(state)
    end
})

AutoFarm:AddToggle({
    Title = "Auto Cook Food",
    Callback = function(state)
    end
})

AutoFarm:AddToggle({
    Title = "Auto Grind Machine",
    Callback = function(state)
    end
})

AutoFarm:AddToggle({
    Title = "Auto Eat Food",
    Callback = function(state)
    end
})

AutoFarm:AddToggle({
    Title = "Auto Biofuel",
    Callback = function(state)
    end
})

-- Kill Aura Tab
local KillAura = Window.Tabs["Kill Aura"]

local killAuraEnabled = false
KillAura:AddToggle({
    Title = "Kill Aura",
    Callback = function(state)
        killAuraEnabled = state
    end
})

KillAura:AddSlider({
    Title = "Kill Aura Radius",
    Min = 20,
    Max = 200,
    Default = 50,
    Callback = function(value)
    end
})

-- Item ESP Tab
local ItemESP = Window.Tabs["Item ESP"]

ItemESP:AddToggle({
    Title = "Advanced Item ESP",
    Callback = function(state)
    end
})

ItemESP:AddDropdown({
    Title = "Teleport Item to You",
    Options = teleportTargets,
    Callback = function(option)
    end
})

-- Mob ESP Tab
local MobESP = Window.Tabs["Mob ESP"]

MobESP:AddToggle({
    Title = "Mob Highlighter",
    Callback = function(state)
    end
})

MobESP:AddDropdown({
    Title = "Teleport Mob to You",
    Options = AimbotTargets,
    Callback = function(option)
    end
})

-- Visuals Tab
local Visuals = Window.Tabs.Visuals

Visuals:AddToggle({
    Title = "Player ESP",
    Callback = function(state)
    end
})

Visuals:AddToggle({
    Title = "Player Chams",
    Callback = function(state)
    end
})

-- FOV Circle
local FOVRadius = 100
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(128, 255, 0)
FOVCircle.Thickness = 1
FOVCircle.Radius = FOVRadius
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false

Visuals:AddToggle({
    Title = "FOV Circle",
    Callback = function(state)
        if FOVCircle then
            FOVCircle.Visible = state
        end
    end
})

Visuals:AddSlider({
    Title = "FOV Circle Radius",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(value)
        FOVRadius = value
        if FOVCircle then
            FOVCircle.Radius = value
        end
    end
})

-- Misc Tab
local Misc = Window.Tabs.Misc

Misc:AddDropdown({
    Title = "Extra Scripts",
    Options = {"Infinite Yield", "Emote GUI", "Turtle Spy", "Anti AFK"},
    Callback = function(option)
        if option == "Infinite Yield" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        elseif option == "Emote GUI" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dimension-sources/random-scripts-i-found/refs/heads/main/r6%20animations"))()
        elseif option == "Turtle Spy" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
        elseif option == "Anti AFK" then
            local virtualUser = game:GetService('VirtualUser')
            game:GetService('Players').LocalPlayer.Idled:connect(function()
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

Misc:AddButton({
    Title = "Teleport to Stronghold",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(100, 50, 100))
    end
})

Misc:AddButton({
    Title = "Teleport to Diamond Chest",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(120, 50, 100))
    end
})

Misc:AddToggle({
    Title = "Auto Stronghold Timer",
    Callback = function(state)
    end
})

-- Initialize the UI
Window:Init()

print("Grizz Hub loaded successfully!")
