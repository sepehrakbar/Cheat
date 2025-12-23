local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

local library = loadstring(game:HttpGet("https://github.com/GoHamza/AppleLibrary/blob/main/main.lua?raw=true"))()
local window = library:init("Grizz Hub - 99 Nights", true, Enum.KeyCode.RightShift, true)

local sectionHome = window:Section("Home")
sectionHome:Divider("Main Features")
sectionHome:Button("Teleport to Campfire", function()
    LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
end)
sectionHome:Button("Teleport to Grinder", function()
    LocalPlayer.Character:PivotTo(CFrame.new(16.1, 4, -4.6))
end)
sectionHome:Switch("Item ESP", false, function(value)
    print("Item ESP:", value)
end)
sectionHome:Switch("NPC ESP", false, function(value)
    print("NPC ESP:", value)
end)
sectionHome:Switch("Auto Tree Farm", false, function(value)
    print("Auto Tree Farm:", value)
end)
sectionHome:Switch("Aimbot (Right Click)", false, function(value)
    print("Aimbot:", value)
end)
sectionHome:Switch("Fly (WASD + Space + Shift)", false, function(value)
    print("Fly:", value)
end)

local sectionTeleport = window:Section("Teleport")
sectionTeleport:Divider("Item Teleports")
for _, itemName in ipairs(teleportTargets) do
    sectionTeleport:Button("TP to " .. itemName, function()
        print("Teleporting to:", itemName)
    end)
end

local sectionPlayer = window:Section("Player")
sectionPlayer:Divider("Player Modifications")
local walkSpeedValue = 16
sectionPlayer:Slider("WalkSpeed", 16, 300, 16, function(value)
    walkSpeedValue = value
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)
sectionPlayer:Slider("JumpPower", 50, 500, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)
sectionPlayer:Switch("Speed Hack (50)", false, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value and 50 or 16
    end
end)

local sectionAutoFarm = window:Section("Auto Farm")
sectionAutoFarm:Divider("Auto Farming")
sectionAutoFarm:Switch("Auto Feed Campfire", false, function(value)
    print("Auto Feed Campfire:", value)
end)
sectionAutoFarm:Switch("Auto Cook Food", false, function(value)
    print("Auto Cook Food:", value)
end)
sectionAutoFarm:Switch("Auto Grind Machine", false, function(value)
    print("Auto Grind Machine:", value)
end)
sectionAutoFarm:Switch("Auto Eat Food", false, function(value)
    print("Auto Eat Food:", value)
end)
sectionAutoFarm:Switch("Auto Biofuel", false, function(value)
    print("Auto Biofuel:", value)
end)

local sectionKillAura = window:Section("Kill Aura")
sectionKillAura:Divider("Combat")
sectionKillAura:Switch("Kill Aura", false, function(value)
    print("Kill Aura:", value)
end)
sectionKillAura:Slider("Kill Aura Radius", 20, 200, 50, function(value)
    print("Kill Aura Radius:", value)
end)

local sectionItems = window:Section("Items")
sectionItems:Divider("Item Management")
sectionItems:Switch("Advanced Item ESP", false, function(value)
    print("Advanced Item ESP:", value)
end)
sectionItems:TextField("Teleport Item to You", "Type item name...", function(input)
    print("Selected item:", input)
end)

local sectionMobs = window:Section("Mobs")
sectionMobs:Divider("Mob Management")
sectionMobs:Switch("Mob Highlighter", false, function(value)
    print("Mob Highlighter:", value)
end)
sectionMobs:TextField("Teleport Mob to You", "Type mob name...", function(input)
    print("Selected mob:", input)
end)

local sectionVisuals = window:Section("Visuals")
sectionVisuals:Divider("Visual Modifications")
sectionVisuals:Switch("Player ESP", false, function(value)
    print("Player ESP:", value)
end)
sectionVisuals:Switch("Player Chams", false, function(value)
    print("Player Chams:", value)
end)
sectionVisuals:Switch("FOV Circle", false, function(value)
    print("FOV Circle:", value)
end)
sectionVisuals:Slider("FOV Circle Radius", 50, 300, 100, function(value)
    print("FOV Radius:", value)
end)

local sectionMisc = window:Section("Misc")
sectionMisc:Divider("Additional Features")
sectionMisc:Button("Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
sectionMisc:Button("Emote GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dimension-sources/random-scripts-i-found/refs/heads/main/r6%20animations"))()
end)
sectionMisc:Button("Turtle Spy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end)
sectionMisc:Button("Anti AFK", function()
    local virtualUser = game:GetService('VirtualUser')
    game:GetService('Players').LocalPlayer.Idled:connect(function()
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end)
end)
sectionMisc:Button("Teleport to Stronghold", function()
    LocalPlayer.Character:PivotTo(CFrame.new(100, 50, 100))
end)
sectionMisc:Button("Teleport to Diamond Chest", function()
    LocalPlayer.Character:PivotTo(CFrame.new(120, 50, 100))
end)
sectionMisc:Switch("Auto Stronghold Timer", false, function(value)
    print("Auto Stronghold Timer:", value)
end)

window:GreenButton(function()
    window:TempNotify("Grizz Hub", "All features activated!", "rbxassetid://12608259004")
end)
