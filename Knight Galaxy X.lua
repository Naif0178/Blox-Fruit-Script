local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local Settings = {
    Protection = {InfinityDefense = true},
    Movement = {Speed = 500, TeleportToCursor = true},
    Combat = {AutoClick = true, HitRange = 50, SkillCombo = {"Z","X","C","V","F"}},
    AutoFarm = {Enabled = false, CurrentQuest = nil},
    Performance = {ReduceGraphics = true, TargetFPS = 30}
}

RunService.Heartbeat:Connect(function()
    if Settings.Protection.InfinityDefense then
        Humanoid.Health = Humanoid.MaxHealth
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Humanoid.WalkSpeed = Settings.Movement.Speed
Humanoid.JumpPower = 150

if Settings.Movement.TeleportToCursor then
    local mouse = Player:GetMouse()
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if mouse.Hit then
                HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,5,0))
            end
        end
    end)
end

spawn(function()
    while Settings.Combat.AutoClick do
        wait(0.1)
        for _, key in pairs(Settings.Combat.SkillCombo) do
            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        end
    end
end)

if Settings.Performance.ReduceGraphics then
    settings().Rendering.QualityLevel = 1
    RunService:SetThrottleFPS(Settings.Performance.TargetFPS)
    Lighting.GlobalShadows = false
end

local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "KnightGalaxyUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(10,10,10)
Title.Text = "Knight Galaxy v10"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold

local function createToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 10, 0, 50 + (#parent:GetChildren() - 2) * 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans

    local toggleButton = Instance.new("TextButton", toggleFrame)
    toggleButton.Size = UDim2.new(0.3, -10, 0.7, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0.15, 0)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.Font = Enum.Font.SourceSansBold

    toggleButton.MouseButton1Click:Connect(function()
        local state = toggleButton.Text == "OFF"
        toggleButton.Text = state and "ON" or "OFF"
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        callback(state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.Position = UDim2.new(0, 10, 0, 50 + (#parent:GetChildren() - 2) * 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans

    local slider = Instance.new("TextButton", sliderFrame)
    slider.Size = UDim2.new(1, -20, 0, 20)
    slider.Position = UDim2.new(0, 10, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(70,70,70)
    slider.Text = ""
    slider.AutoButtonColor = false

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            local value = math.floor(min + (pos / slider.AbsoluteSize.X) * (max - min))
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

createToggle(MainFrame, "Infinity Defense", Settings.Protection.InfinityDefense, function(state)
    Settings.Protection.InfinityDefense = state
end)

createSlider(MainFrame, "Walk Speed", 16, 1000, Settings.Movement.Speed, function(value)
    Settings.Movement.Speed = value
    Humanoid.WalkSpeed = value
end)

createToggle(MainFrame, "Auto Click Combat", Settings.Combat.AutoClick, function(state)
    Settings.Combat.AutoClick = state
end)

createToggle(MainFrame, "Teleport To Cursor", Settings.Movement.TeleportToCursor, function(state)
    Settings.Movement.TeleportToCursor = state
end)

createToggle(MainFrame, "Reduce Graphics", Settings.Performance.ReduceGraphics, function(state)
    Settings.Performance.ReduceGraphics = state
    if state then
        settings().Rendering.QualityLevel = 1
        RunService:SetThrottleFPS(Settings.Performance.TargetFPS)
        Lighting.GlobalShadows = false
    else
        settings().Rendering.QualityLevel = 10
        RunService:SetThrottleFPS(60)
        Lighting.GlobalShadows = true
    end
end)