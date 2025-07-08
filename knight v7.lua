local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = {
    Protection = {
        Invincible = true,
        NoCooldowns = true,
        AntiStun = true
    },
    Movement = {
        Speed = 500,
        FlightHeight = 150,
        NoClip = true,
        TeleportToCursor = true
    },
    Combat = {
        AutoClick = true,
        HitRange = 50,
        SkillCombo = {"Z","X","C","V","F"},
        OneHitKO = true
    },
    Shop = {
        Swords = {
            Cutlass = false,
            Katana = false
        },
        FightingStyles = {
            BlackLeg = false,
            Electro = false
        },
        Races = {
            Ghoul = false,
            Cyborg = false
        }
    },
    Performance = {
        ReduceGraphics = true,
        TargetFPS = 30
    }
}

local function ProtectionSystem()
    game:GetService("RunService").Heartbeat:Connect(function()
        if Settings.Protection.Invincible then
            Humanoid.Health = Humanoid.MaxHealth
            for _,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

local function MovementSystem()
    Humanoid.WalkSpeed = Settings.Movement.Speed
    Humanoid.JumpPower = 150

    if Settings.Movement.TeleportToCursor then
        local mouse = Player:GetMouse()
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,5,0))
            end
        end)
    end
end

local function ShopSystem()
    local ShopRemote = ReplicatedStorage.Remotes.CommF_
    if Settings.Shop.Swords.Cutlass then ShopRemote:InvokeServer("BuyItem", "Cutlass") end
    if Settings.Shop.Swords.Katana then ShopRemote:InvokeServer("BuyItem", "Katana") end
    if Settings.Shop.FightingStyles.BlackLeg then ShopRemote:InvokeServer("BuyBlackLeg") end
    if Settings.Shop.FightingStyles.Electro then ShopRemote:InvokeServer("BuyElectro") end
    if Settings.Shop.Races.Ghoul then ShopRemote:InvokeServer("Ectoplasm", "Change", 1) end
    if Settings.Shop.Races.Cyborg then ShopRemote:InvokeServer("CyborgTrainer", "Buy") end
end

local function PerformanceOptimization()
    if Settings.Performance.ReduceGraphics then
        settings().Rendering.QualityLevel = 1
        game:GetService("RunService"):SetThrottleFPS(Settings.Performance.TargetFPS)
        Lighting.GlobalShadows = false
    end
end

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "KNIGHT SCRIPT V7",
    ConfigurationSaving = { Enabled = true }
})

local ProtectionTab = Window:CreateTab("Protection")
ProtectionTab:CreateToggle("Invincible", {
    Title = "Invincibility",
    Default = true,
    Callback = function(State) Settings.Protection.Invincible = State end
})

local MovementTab = Window:CreateTab("Movement")
MovementTab:CreateSlider("Speed", {
    Title = "Movement Speed",
    Default = 500,
    Min = 16,
    Max = 1000,
    Callback = function(Value)
        Settings.Movement.Speed = Value
        Humanoid.WalkSpeed = Value
    end
})

local ShopTab = Window:CreateTab("Shop")
ShopTab:CreateToggle("Cutlass", {
    Title = "Buy Cutlass",
    Default = false,
    Callback = function(State) Settings.Shop.Swords.Cutlass = State end
})

local PerfTab = Window:CreateTab("Performance")
PerfTab:CreateToggle("ReduceGraphics", {
    Title = "Performance Mode",
    Default = true,
    Callback = function(State) 
        Settings.Performance.ReduceGraphics = State
        PerformanceOptimization()
    end
})

ProtectionSystem()
MovementSystem()
PerformanceOptimization()