
local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

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

local Window = WindUI:CreateWindow({
    Title = "GrizzHub | 99 Nights in the Forest",
    Folder = "GrizzHub",
    IconSize = 22*2,
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open GrizzHub",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"), 
            Color3.fromHex("#e7ff2f")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

Window:Tag({
    Title = "GrizzHub",
    Icon = "crown",
    Color = Color3.fromHex("#FFD700")
})

local HomeSection = Window:Section({
    Title = "Main Features",
})

local HomeTab = HomeSection:Tab({
    Title = "Home",
    Icon = "home",
    IconColor = Color3.fromHex("#FF6B35"),
})

HomeTab:Button({
    Title = "Teleport to Campfire",
    Icon = "flame",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
    end
})

HomeTab:Space()

HomeTab:Button({
    Title = "Teleport to Grinder",
    Icon = "settings",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(16.1, 4, -4.6))
    end
})

HomeTab:Space()

HomeTab:Toggle({
    Title = "Item ESP",
    Icon = "eye",
    Callback = function(value)
        print("Item ESP:", value)
    end
})

HomeTab:Toggle({
    Title = "NPC ESP",
    Icon = "users",
    Callback = function(value)
        print("NPC ESP:", value)
    end
})

HomeTab:Toggle({
    Title = "Auto Tree Farm",
    Icon = "tree",
    Callback = function(value)
        print("Auto Tree Farm:", value)
    end
})

HomeTab:Toggle({
    Title = "Aimbot (Right Click)",
    Icon = "target",
    Callback = function(value)
        print("Aimbot:", value)
    end
})

HomeTab:Toggle({
    Title = "Fly (WASD + Space + Shift)",
    Icon = "bird",
    Callback = function(value)
        print("Fly:", value)
    end
})

local TeleportSection = Window:Section({
    Title = "Teleport",
})

local TeleportTab = TeleportSection:Tab({
    Title = "Teleport",
    Icon = "map-pin",
    IconColor = Color3.fromHex("#4ECDC4"),
})

TeleportTab:Section({
    Title = "Item Teleports",
    TextSize = 16,
})

local teleportGroups = {}
local currentGroup

for i, itemName in ipairs(teleportTargets) do
    if i % 10 == 1 then
        currentGroup = TeleportTab:Group({})
        teleportGroups[#teleportGroups + 1] = currentGroup
    end
    
    if currentGroup then
        currentGroup:Button({
            Title = "TP to " .. itemName,
            Icon = "arrow-right",
            Callback = function()
                print("Teleporting to:", itemName)
            end
        })
        
        if i % 10 ~= 0 and i ~= #teleportTargets then
            currentGroup:Space()
        end
    end
end

local PlayerSection = Window:Section({
    Title = "Player",
})

local PlayerTab = PlayerSection:Tab({
    Title = "Player",
    Icon = "user",
    IconColor = Color3.fromHex("#1A936F"),
})

PlayerTab:Slider({
    Title = "WalkSpeed",
    Icon = "zap",
    Step = 1,
    Value = {
        Min = 16,
        Max = 300,
        Default = 16,
    },
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:Space()

PlayerTab:Slider({
    Title = "JumpPower",
    Icon = "arrow-up",
    Step = 5,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50,
    },
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

PlayerTab:Space()

PlayerTab:Toggle({
    Title = "Speed Hack (50)",
    Icon = "zap",
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value and 50 or 16
        end
    end
})

local AutoFarmSection = Window:Section({
    Title = "Auto Farm",
})

local AutoFarmTab = AutoFarmSection:Tab({
    Title = "Auto Farm",
    Icon = "refresh-cw",
    IconColor = Color3.fromHex("#FFD166"),
})

AutoFarmTab:Toggle({
    Title = "Auto Feed Campfire",
    Icon = "flame",
    Callback = function(value)
        print("Auto Feed Campfire:", value)
    end
})

AutoFarmTab:Space()

AutoFarmTab:Toggle({
    Title = "Auto Cook Food",
    Icon = "utensils",
    Callback = function(value)
        print("Auto Cook Food:", value)
    end
})

AutoFarmTab:Space()

AutoFarmTab:Toggle({
    Title = "Auto Grind Machine",
    Icon = "settings",
    Callback = function(value)
        print("Auto Grind Machine:", value)
    end
})

AutoFarmTab:Space()

AutoFarmTab:Toggle({
    Title = "Auto Eat Food",
    Icon = "heart",
    Callback = function(value)
        print("Auto Eat Food:", value)
    end
})

AutoFarmTab:Space()

AutoFarmTab:Toggle({
    Title = "Auto Biofuel",
    Icon = "droplet",
    Callback = function(value)
        print("Auto Biofuel:", value)
    end
})

local CombatSection = Window:Section({
    Title = "Combat",
})

local CombatTab = CombatSection:Tab({
    Title = "Kill Aura",
    Icon = "swords",
    IconColor = Color3.fromHex("#EF476F"),
})

CombatTab:Toggle({
    Title = "Kill Aura",
    Icon = "target",
    Callback = function(value)
        print("Kill Aura:", value)
    end
})

CombatTab:Space()

CombatTab:Slider({
    Title = "Kill Aura Radius",
    Icon = "maximize-2",
    Step = 5,
    Value = {
        Min = 20,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        print("Kill Aura Radius:", value)
    end
})

local ItemsSection = Window:Section({
    Title = "Items",
})

local ItemsTab = ItemsSection:Tab({
    Title = "Items",
    Icon = "package",
    IconColor = Color3.fromHex("#118AB2"),
})

ItemsTab:Toggle({
    Title = "Advanced Item ESP",
    Icon = "eye",
    Callback = function(value)
        print("Advanced Item ESP:", value)
    end
})

ItemsTab:Space()

ItemsTab:Dropdown({
    Title = "Teleport Item to You",
    Icon = "download",
    Values = teleportTargets,
    Callback = function(option)
        print("Selected item:", option)
    end
})

local MobsSection = Window:Section({
    Title = "Mobs",
})

local MobsTab = MobsSection:Tab({
    Title = "Mobs",
    Icon = "ghost",
    IconColor = Color3.fromHex("#6A0572"),
})

MobsTab:Toggle({
    Title = "Mob Highlighter",
    Icon = "highlight",
    Callback = function(value)
        print("Mob Highlighter:", value)
    end
})

MobsTab:Space()

MobsTab:Dropdown({
    Title = "Teleport Mob to You",
    Icon = "download",
    Values = AimbotTargets,
    Callback = function(option)
        print("Selected mob:", option)
    end
})

local VisualsSection = Window:Section({
    Title = "Visuals",
})

local VisualsTab = VisualsSection:Tab({
    Title = "Visuals",
    Icon = "eye",
    IconColor = Color3.fromHex("#9B5DE5"),
})

VisualsTab:Toggle({
    Title = "Player ESP",
    Icon = "users",
    Callback = function(value)
        print("Player ESP:", value)
    end
})

VisualsTab:Space()

VisualsTab:Toggle({
    Title = "Player Chams",
    Icon = "box",
    Callback = function(value)
        print("Player Chams:", value)
    end
})

VisualsTab:Space()

VisualsTab:Toggle({
    Title = "FOV Circle",
    Icon = "circle",
    Callback = function(value)
        print("FOV Circle:", value)
    end
})

VisualsTab:Space()

VisualsTab:Slider({
    Title = "FOV Circle Radius",
    Icon = "maximize-2",
    Step = 10,
    Value = {
        Min = 50,
        Max = 300,
        Default = 100,
    },
    Callback = function(value)
        print("FOV Radius:", value)
    end
})

local MiscSection = Window:Section({
    Title = "Miscellaneous",
})

local MiscTab = MiscSection:Tab({
    Title = "Misc",
    Icon = "more-horizontal",
    IconColor = Color3.fromHex("#06D6A0"),
})

MiscTab:Dropdown({
    Title = "Extra Scripts",
    Icon = "code",
    Values = {"Infinite Yield", "Emote GUI", "Turtle Spy", "Anti AFK"},
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

MiscTab:Space()

MiscTab:Button({
    Title = "Teleport to Stronghold",
    Icon = "castle",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(100, 50, 100))
    end
})

MiscTab:Space()

MiscTab:Button({
    Title = "Teleport to Diamond Chest",
    Icon = "gem",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(120, 50, 100))
    end
})

MiscTab:Space()

MiscTab:Toggle({
    Title = "Auto Stronghold Timer",
    Icon = "clock",
    Callback = function(value)
        print("Auto Stronghold Timer:", value)
    end
})

MiscTab:Space()

MiscTab:Button({
    Title = "Show Safe Zone",
    Icon = "shield",
    Callback = function()
        local baseplateSize = Vector3.new(2048, 1, 2048)
        local centerPos = Vector3.new(0, 100, 0)
        
        for dx = -1, 1 do
            for dz = -1, 1 do
                local pos = centerPos + Vector3.new(dx * baseplateSize.X, 0, dz * baseplateSize.Z)
                local baseplate = Instance.new("Part")
                baseplate.Name = "SafeZoneBaseplate"
                baseplate.Size = baseplateSize
                baseplate.Position = pos
                baseplate.Anchored = true
                baseplate.CanCollide = true
                baseplate.Transparency = 0.8
                baseplate.Color = Color3.fromRGB(255, 255, 255)
                baseplate.Parent = workspace
            end
        end
    end
})

print("GrizzHub loaded successfully!")
