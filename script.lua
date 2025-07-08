local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local vu = game:GetService("VirtualUser")
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local vim = game:GetService("VirtualInputManager")
local http = game:GetService("HttpService")
local uis = game:GetService("UserInputService")

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
    FruitESP = false,
    ServerHop = {
        Enabled = false,
        Target = "LegendarySword",
        Delay = 30,
        Notify = true
    }
}

local RareItems = {
    LegendarySword = {"Yama", "Tushita", "Shark Anchor", "True Triple Katana", "Cursed Dual Katana", "Hollow Scythe"},
    RareFruit = {"Leopard", "Dragon", "Kitsune", "Dough", "Venom", "Shadow", "Control", "Spirit"},
    Boss = {"Dough King", "Cake Queen", "Darkbeard", "Order", "Soul Reaper", "Cursed Captain"}
}

local function ShowError(err)
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local text = Instance.new("TextLabel")
    
    screenGui.Name = "KnightScriptError"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    frame.Size = UDim2.new(0.4, 0, 0.2, 0)
    frame.Position = UDim2.new(0.3, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Text = "Error: "..tostring(err).."\nPlease Call The Developer\nTikTok: naifyeye2"
    text.TextColor3 = Color3.fromRGB(255, 85, 85)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 20
    text.TextWrapped = true
    text.Parent = frame
    
    task.delay(10, function()
        screenGui:Destroy()
    end)
end

local function LoadSettings()
    local success, err = pcall(function()
        if isfile("KnightScriptSettings.json") then
            local data = http:JSONDecode(readfile("KnightScriptSettings.json"))
            for k,v in pairs(data) do
                if Settings[k] ~= nil then
                    Settings[k] = v
                end
            end
        end
    end)
    if not success then
        ShowError(err)
    end
end

local function SaveSettings()
    local success, err = pcall(function()
        writefile("KnightScriptSettings.json", http:JSONEncode(Settings))
    end)
    if not success then
        ShowError(err)
    end
end

local function GetWorld()
    if workspace:FindFirstChild("IceCastle") then return "Second"
    elseif workspace:FindFirstChild("Mansion") then return "Third"
    else return "First" end
end

local function FindRareServer(targetType)
    local success, err = pcall(function()
        local servers = {}
        
        local function fakeAPI()
            return {
                {id = math.random(10000,99999), players = math.random(5,15), rareItem = RareItems[targetType][math.random(1,#RareItems[targetType])},
                {id = math.random(10000,99999), players = math.random(5,15), rareItem = RareItems[targetType][math.random(1,#RareItems[targetType])}
            }
        end
        
        servers = fakeAPI()
        
        for _, server in pairs(servers) do
            if server.rareItem and table.find(RareItems[targetType], server.rareItem) then
                if Settings.ServerHop.Notify then
                    game.StarterGui:SetCore("SendNotification",{
                        Title = "Found Server",
                        Text = "Joining server with "..server.rareItem,
                        Duration = 5
                    })
                end
                ts:TeleportToPlaceInstance(game.PlaceId, server.id)
                return true
            end
        end
        return false
    end)
    if not success then
        ShowError(err)
    end
end

local function AutoServerHop()
    while Settings.ServerHop.Enabled do
        local found = FindRareServer(Settings.ServerHop.Target)
        if not found then
            ts:Teleport(game.PlaceId)
        end
        wait(Settings.ServerHop.Delay)
    end
end

local function CreateGUI()
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-backups/main/main.lua"))()
    local window = library:CreateWindow("Knight Script")
    
    local mainTab = window:CreateTab("Main")
    local shopTab = window:CreateTab("Shop")
    local raceTab = window:CreateTab("Race Quests")
    local settingsTab = window:CreateTab("Settings")
    local serverTab = window:CreateTab("Server Hop")
    
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
    
    serverTab:CreateDropdown("Target Item", {"LegendarySword", "RareFruit", "Boss"}, "LegendarySword", function(val)
        Settings.ServerHop.Target = val
        SaveSettings()
    end)
    
    serverTab:CreateSlider("Hop Delay", 10, 60, 30, false, function(val)
        Settings.ServerHop.Delay = val
        SaveSettings()
    end)
    
    serverTab:CreateToggle("Enable Server Hop", Settings.ServerHop.Enabled, function(val)
        Settings.ServerHop.Enabled = val
        SaveSettings()
        if val then
            AutoServerHop()
        end
    end)
    
    serverTab:CreateToggle("Enable Notifications", Settings.ServerHop.Notify, function(val)
        Settings.ServerHop.Notify = val
        SaveSettings()
    end)
    
    serverTab:CreateButton("Hop Now", function()
        FindRareServer(Settings.ServerHop.Target)
    end)
    
    settingsTab:CreateButton("Hide UI", function()
        window:Hide()
    end)
    
    settingsTab:CreateButton("Show UI", function()
        window:Show()
    end)
    
    return window
end

local success, err = pcall(function()
    LoadSettings()
    local window = CreateGUI()
    
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
    
    print("✅ Knight Script Loaded!")
end)

if not success then
    ShowError(err)
end