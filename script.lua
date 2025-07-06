local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local vu = game:GetService("VirtualUser")
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local vim = game:GetService("VirtualInputManager")
local http = game:GetService("HttpService")

local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    AutoYamaTushita = false,
    AutoZoroSwords = false,
    AutoRaceQuests = false,
    AutoRaces = {Ghoul = false, Cyborg = false},
    AutoBuyRaceReroll = false,
    AutoFindTeachKey = false,
    FruitNotifier = false,
    PlayerESP = false,
    FruitESP = false
}

local function LoadSettings()
    if isfile("BloxFruitsSettings.json") then
        local success, data = pcall(function()
            return http:JSONDecode(readfile("BloxFruitsSettings.json"))
        end)
        if success then
            for k,v in pairs(data) do
                if Settings[k] ~= nil then
                    Settings[k] = v
                end
            end
        end
    end
end

local function SaveSettings()
    writefile("BloxFruitsSettings.json", http:JSONEncode(Settings))
end

local function GetWorld()
    if workspace:FindFirstChild("IceCastle") then return "Second"
    elseif workspace:FindFirstChild("Mansion") then return "Third"
    else return "First" end
end

local ShopItems = {
    ["First Sea"] = {
        {"Katana", 1200},
        {"Slingshot", 600},
        {"Black Cape", 1000}
    },
    ["Second Sea"] = {
        {"Shisui", 2000000},
        {"Saddi", 2000000},
        {"Wando", 2000000}
    },
    ["Third Sea"] = {
        {"Race Reroll", 3000},
        {"Dark Fragment", 1500},
        {"God's Chalice", 5000}
    }
}

local TempShops = {
    "El Admin's Shop",
    "Darkbeard's Shop",
    "Mysterious Samurai's Shop"
}

local function BuyItem(itemName)
    for _,shop in pairs(workspace:GetDescendants()) do
        if shop:IsA("Model") and (table.find(TempShops, shop.Name) or shop.Name:find("Shop")) then
            for _,item in pairs(shop:GetDescendants()) do
                if item.Name == itemName and item:FindFirstChildWhichIsA("ProximityPrompt") then
                    hrp.CFrame = item.CFrame + Vector3.new(0, 3, 0)
                    wait(1)
                    fireproximityprompt(item:FindFirstChildWhichIsA("ProximityPrompt"))
                    return true
                end
            end
        end
    end
    return false
end

local function BuyRaceReroll()
    if GetWorld() == "Third" then
        return BuyItem("Race Reroll")
    end
    return false
end

local function FindTeachKey()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Teach Key" and v:FindFirstChildWhichIsA("BasePart") then
            hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            wait(1)
            fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
            return true
        end
    end
    return false
end

local function GhoulQuest()
    if GetWorld() == "Third" then
        local npc = workspace:FindFirstChild("Experimentation NPC")
        if npc then
            hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            wait(1)
            fireproximityprompt(npc:FindFirstChildWhichIsA("ProximityPrompt"))
        end
        
        for _,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == "Cursed Captain" then
                hrp.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                repeat
                    vu:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                    wait(0.2)
                    vu:Button1Up(Vector2.new(), workspace.CurrentCamera.CFrame)
                until v.Humanoid.Health <= 0 or not v.Parent
            end
        end
    end
end

local function CyborgQuest()
    if GetWorld() == "Third" then
        local npc = workspace:FindFirstChild("Cyborg NPC")
        if npc then
            hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            wait(1)
            fireproximityprompt(npc:FindFirstChildWhichIsA("ProximityPrompt"))
        end
        
        for _,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == "Factory Staff" then
                hrp.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                repeat
                    vu:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                    wait(0.2)
                    vu:Button1Up(Vector2.new(), workspace.CurrentCamera.CFrame)
                until v.Humanoid.Health <= 0 or not v.Parent
            end
        end
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-backups/main/main.lua"))()
local window = library:CreateWindow("Blox Fruits Ultimate")
local mainTab = window:CreateTab("Main")
local shopTab = window:CreateTab("Shop")
local raceTab = window:CreateTab("Race Quests")
local settingsTab = window:CreateTab("Settings")

LoadSettings()

mainTab:CreateToggle("Auto Farm", Settings.AutoFarm, function(val)
    Settings.AutoFarm = val
    SaveSettings()
end)

mainTab:CreateToggle("Auto Quest", Settings.AutoQuest, function(val)
    Settings.AutoQuest = val
    SaveSettings()
end)

mainTab:CreateToggle("Fruit Notifier", Settings.FruitNotifier, function(val)
    Settings.FruitNotifier = val
    SaveSettings()
end)

local currentWorld = GetWorld()
shopTab:CreateLabel("Current World: "..currentWorld)

for _,item in pairs(ShopItems[currentWorld] or {}) do
    shopTab:CreateButton("Buy "..item[1].." ($"..tostring(item[2])..")", function()
        BuyItem(item[1])
    end)
end

shopTab:CreateToggle("Auto Buy Race Reroll", Settings.AutoBuyRaceReroll, function(val)
    Settings.AutoBuyRaceReroll = val
    SaveSettings()
end)

shopTab:CreateButton("Find Temporary Shops", function()
    for _,shopName in pairs(TempShops) do
        local shop = workspace:FindFirstChild(shopName)
        if shop then
            hrp.CFrame = shop.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Shop Found",
                Text = "Found "..shopName,
                Duration = 5
            })
            wait(3)
        end
    end
end)

raceTab:CreateToggle("Auto Ghoul Quest", Settings.AutoRaces.Ghoul, function(val)
    Settings.AutoRaces.Ghoul = val
    SaveSettings()
end)

raceTab:CreateToggle("Auto Cyborg Quest", Settings.AutoRaces.Cyborg, function(val)
    Settings.AutoRaces.Cyborg = val
    SaveSettings()
end)

raceTab:CreateToggle("Auto Find Teach Key", Settings.AutoFindTeachKey, function(val)
    Settings.AutoFindTeachKey = val
    SaveSettings()
end)

raceTab:CreateButton("Start Ghoul Quest", GhoulQuest)
raceTab:CreateButton("Start Cyborg Quest", CyborgQuest)
raceTab:CreateButton("Find Teach Key", FindTeachKey)

settingsTab:CreateButton("Save Current Settings", SaveSettings)
settingsTab:CreateButton("Load Settings", LoadSettings)

spawn(function()
    while wait(5) do
        if Settings.AutoBuyRaceReroll then
            BuyRaceReroll()
        end
        
        if Settings.AutoFindTeachKey then
            FindTeachKey()
        end
        
        if Settings.AutoRaces.Ghoul then
            GhoulQuest()
        end
        
        if Settings.AutoRaces.Cyborg then
            CyborgQuest()
        end
    end
end)

print("✅ Ultimate Blox Fruits Script Loaded!")