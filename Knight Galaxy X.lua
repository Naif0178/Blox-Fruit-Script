local SoundService = game:GetService("SoundService")
local IntroSound = Instance.new("Sound", SoundService)
IntroSound.SoundId = "rbxassetid://9127292332"
IntroSound.Volume = 5
IntroSound:Play()

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local SettingsFile = "KnightGalaxyXSettings.json"
local Settings = {}

if isfile(SettingsFile) then
    Settings = HttpService:JSONDecode(readfile(SettingsFile))
else
    Settings = {
        Protection = { InfinityDefense = true },
        Movement = { Speed = 500 },
        Combat = { AutoCombo = true, HitRange = 50 },
        ESP = { Enabled = true },
        Sniper = { AutoFruitSniper = true },
        Performance = { TargetFPS = 60 },
        Teleport = {}
    }
end

local function SaveSettings()
    writefile(SettingsFile, HttpService:JSONEncode(Settings))
end

local Window = Rayfield:CreateWindow({
    Name = "⚔️ Knight Galaxy X | 🛡️ Infinity Defense",
    LoadingTitle = "Knight Galaxy X Loading...",
    LoadingSubtitle = "🛡️ Royal Dev Final Release",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local ProtectionTab = Window:CreateTab("🛡️ Infinity Defense")
ProtectionTab:CreateToggle("InfinityDefense", {
    Title = "Activate Infinity Defense",
    Default = Settings.Protection.InfinityDefense,
    Callback = function(State)
        Settings.Protection.InfinityDefense = State
        SaveSettings()
    end
})

RunService.Heartbeat:Connect(function()
    if Settings.Protection.InfinityDefense then
        Humanoid.Health = Humanoid.MaxHealth
    end
end)

local MovementTab = Window:CreateTab("⚡ Movement")
MovementTab:CreateSlider("Speed", {
    Title = "Speed",
    Min = 16,
    Max = 2000,
    Default = Settings.Movement.Speed,
    Callback = function(Value)
        Settings.Movement.Speed = Value
        Humanoid.WalkSpeed = Value
        SaveSettings()
    end
})

local CombatTab = Window:CreateTab("🥷 Combat")
CombatTab:CreateToggle("AutoCombo", {
    Title = "Enable Auto Combo",
    Default = Settings.Combat.AutoCombo,
    Callback = function(State)
        Settings.Combat.AutoCombo = State
        SaveSettings()
    end
})

RunService.Heartbeat:Connect(function()
    if Settings.Combat.AutoCombo then
        for _, skill in pairs({"Z","X","C","V","F"}) do
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendKeyEvent(true, skill, false, game)
            task.wait(0.2)
        end
    end
end)

local ESPTab = Window:CreateTab("👁️ ESP")
ESPTab:CreateToggle("EnableESP", {
    Title = "Enable ESP",
    Default = Settings.ESP.Enabled,
    Callback = function(State)
        Settings.ESP.Enabled = State
        SaveSettings()
    end
})

RunService.RenderStepped:Connect(function()
    if Settings.ESP.Enabled then
        for _,v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character:FindFirstChild("KnightESP") then
                    local Billboard = Instance.new("BillboardGui", v.Character)
                    Billboard.Name = "KnightESP"
                    Billboard.Size = UDim2.new(0,200,0,50)
                    Billboard.Adornee = v.Character:FindFirstChild("Head")
                    Billboard.AlwaysOnTop = true
                    local Label = Instance.new("TextLabel", Billboard)
                    Label.Size = UDim2.new(1,0,1,0)
                    Label.BackgroundTransparency = 1
                    Label.Text = v.Name
                    Label.TextColor3 = Color3.new(1,0,0)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                end
            end
        end
    end
end)

local SniperTab = Window:CreateTab("🍏 Fruit Sniper")
SniperTab:CreateToggle("AutoFruitSniper", {
    Title = "Enable Auto Fruit Sniper",
    Default = Settings.Sniper.AutoFruitSniper,
    Callback = function(State)
        Settings.Sniper.AutoFruitSniper = State
        SaveSettings()
    end
})

RunService.Heartbeat:Connect(function()
    if Settings.Sniper.AutoFruitSniper then
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Handle") then
                HumanoidRootPart.CFrame = v.Handle.CFrame
                task.wait(0.5)
            end
        end
    end
end)

local TeleportTab = Window:CreateTab("🗺️ Teleport")
for _,v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
        TeleportTab:CreateButton({
            Name = "Teleport to "..v.Name,
            Callback = function()
                HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
            end
        })
    end
end

local SeaTab = Window:CreateTab("🌊 Sea Events & Bosses")
SeaTab:CreateButton({
    Name = "Teleport to Sea Event",
    Callback = function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name:find("Sea") then
                HumanoidRootPart.CFrame = v:GetModelCFrame()
            end
        end
    end
})

SeaTab:CreateButton({
    Name = "Teleport to Boss",
    Callback = function()
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                task.wait(1)
            end
        end
    end
})

local PerfTab = Window:CreateTab("🎮 Performance")
PerfTab:CreateSlider("FPS", {
    Title = "Target FPS",
    Min = 10,
    Max = 240,
    Default = Settings.Performance.TargetFPS,
    Callback = function(Value)
        Settings.Performance.TargetFPS = Value
        RunService:SetThrottleFPS(Value)
        SaveSettings()
    end
})

Rayfield:Notify({
    Title = "Knight Galaxy X Loaded",
    Content = "Infinity Defense + Ultimate Systems Activated. Welcome, Galaxy King ⚔️",
    Duration = 10,
    Image = "rbxassetid://15839123563"
})