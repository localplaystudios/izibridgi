local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EpanniyFling"..math.random(1,9999999)

-- Main Container
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 340, 0, 360)
mainContainer.Position = UDim2.new(0.3, 0, 0.3, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Draggable = true

-- Frame
local frame = Instance.new("Frame", mainContainer)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
frame.ZIndex = 1
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 14)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 20))
})
gradient.Rotation = 45

-- Title
local titleFrame = Instance.new("Frame", mainContainer)
titleFrame.Size = UDim2.new(1, 0, 0, 35)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
titleFrame.ZIndex = 10
titleFrame.BackgroundTransparency = 0
local titleCorner = Instance.new("UICorner", titleFrame)
titleCorner.CornerRadius = UDim.new(0, 14)

local titleGrad = Instance.new("UIGradient", titleFrame)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 30, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 70))
})
titleGrad.Rotation = 90

local title = Instance.new("TextLabel", titleFrame)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "🤙 EPANNIY FLING"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.ZIndex = 11

-- Minimize button
local minimizeBtn = Instance.new("TextButton", titleFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.ZIndex = 11
local minCorner = Instance.new("UICorner", minimizeBtn)
minCorner.CornerRadius = UDim.new(0, 8)

local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "─"
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 340, 0, 35)
    else
        mainContainer.Size = UDim2.new(0, 340, 0, 360)
    end
end)

-- Content
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

-- === FLING SYSTEM (from KILASIK) ===
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight
local SelectedTargets = {}
local FlingActive = false
local flingThread = nil

-- Status label
local StatusLabel = Instance.new("TextLabel", contentFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Select targets"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Player list
local playerListFrame = Instance.new("Frame", contentFrame)
playerListFrame.Size = UDim2.new(1, -20, 0, 140)
playerListFrame.Position = UDim2.new(0, 10, 0, 35)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 40)
local listCorner = Instance.new("UICorner", playerListFrame)
listCorner.CornerRadius = UDim.new(0, 8)

local playerScroll = Instance.new("ScrollingFrame", playerListFrame)
playerScroll.Size = UDim2.new(1, -6, 1, -6)
playerScroll.Position = UDim2.new(0, 3, 0, 3)
playerScroll.BackgroundTransparency = 1
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.ScrollBarThickness = 6
playerScroll.BorderSizePixel = 0

local function UpdatePlayerList()
    for _, child in pairs(playerScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    local yPos = 5
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for _, player in ipairs(players) do
        if player ~= plr then
            local entry = Instance.new("Frame", playerScroll)
            entry.Size = UDim2.new(1, -10, 0, 28)
            entry.Position = UDim2.new(0, 5, 0, yPos)
            entry.BackgroundColor3 = Color3.fromRGB(45, 25, 55)
            local entryCorner = Instance.new("UICorner", entry)
            entryCorner.CornerRadius = UDim.new(0, 6)
            
            local checkmark = Instance.new("TextLabel", entry)
            checkmark.Size = UDim2.new(0, 25, 1, 0)
            checkmark.Position = UDim2.new(0, 5, 0, 0)
            checkmark.BackgroundTransparency = 1
            checkmark.Text = SelectedTargets[player.Name] and "✓" or ""
            checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
            checkmark.TextSize = 18
            checkmark.Font = Enum.Font.GothamBold
            checkmark.TextXAlignment = Enum.TextXAlignment.Center
            
            local nameLabel = Instance.new("TextLabel", entry)
            nameLabel.Size = UDim2.new(1, -35, 1, 0)
            nameLabel.Position = UDim2.new(0, 35, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local clickBtn = Instance.new("TextButton", entry)
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.ZIndex = 2
            
            clickBtn.MouseButton1Click:Connect(function()
                if SelectedTargets[player.Name] then
                    SelectedTargets[player.Name] = nil
                    checkmark.Text = ""
                else
                    SelectedTargets[player.Name] = player
                    checkmark.Text = "✅"
                end
                UpdateStatus()
            end)
            
            yPos = yPos + 33
        end
    end
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

local function UpdateStatus()
    local count = 0
    for _ in pairs(SelectedTargets) do count = count + 1 end
    if FlingActive then
        StatusLabel.Text = "Flinging " .. count .. " target(s)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        StatusLabel.Text = count .. " target(s) selected"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Select / Deselect All
local function ToggleAll(select)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            if select then
                SelectedTargets[player.Name] = player
            else
                SelectedTargets[player.Name] = nil
            end
        end
    end
    UpdatePlayerList()
    UpdateStatus()
end

-- === ANTI-FLING (отключает коллизию с игроками, НЕ с миром) ===
local antiFlingEnabled = false
local antiFlingConnections = {}
local antiFlingParts = {}

local function ToggleAntiFling(state)
    antiFlingEnabled = state
    if antiFlingEnabled then
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    table.insert(antiFlingParts, part)
                end
            end
        end
        
        antiFlingConnections.CharacterAdded = plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    table.insert(antiFlingParts, part)
                end
            end
        end)
        
        antiFlingConnections.DescendantAdded = plr.CharacterAdded:Connect(function(char)
            char.DescendantAdded:Connect(function(part)
                if antiFlingEnabled and part:IsA("BasePart") then
                    part.CanCollide = false
                    table.insert(antiFlingParts, part)
                end
            end)
        end)
    else
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        for _, conn in pairs(antiFlingConnections) do
            conn:Disconnect()
        end
        antiFlingConnections = {}
        antiFlingParts = {}
    end
end

-- === FLING FUNCTION (from KILASIK) ===
local function SkidFling(TargetPlayer)
    local Character = plr.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        if THumanoid and THumanoid.Sit then return end
        
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local Time = tick()
            local Angle = 0
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0,0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0))
                        task.wait()
                    end
                end
            until tick() > Time + 2 or not FlingActive
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        if getgenv().OldPos then
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    end
end

-- Start Fling
local function StartFling()
    if FlingActive then return end
    local count = 0
    for _ in pairs(SelectedTargets) do count = count + 1 end
    if count == 0 then return end
    
    FlingActive = true
    UpdateStatus()
    
    flingThread = spawn(function()
        while FlingActive do
            local validTargets = {}
            for name, player in pairs(SelectedTargets) do
                if player and player.Parent then
                    validTargets[name] = player
                else
                    SelectedTargets[name] = nil
                end
            end
            
            for _, player in pairs(validTargets) do
                if FlingActive then
                    SkidFling(player)
                    task.wait(0.1)
                else
                    break
                end
            end
            UpdateStatus()
            task.wait(0.5)
        end
    end)
end

-- Stop Fling
local function StopFling()
    FlingActive = false
    if flingThread then
        coroutine.close(flingThread)
        flingThread = nil
    end
    UpdateStatus()
end

-- === GUI BUTTONS ===
local btnY = 185

-- Start Button
local startBtn = Instance.new("TextButton", contentFrame)
startBtn.Size = UDim2.new(0.44, 0, 0, 40)
startBtn.Position = UDim2.new(0.05, 0, 0, btnY)
startBtn.Text = "▶ START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local sCorner = Instance.new("UICorner", startBtn)
sCorner.CornerRadius = UDim.new(0, 10)

startBtn.MouseButton1Click:Connect(StartFling)

-- Stop Button
local stopBtn = Instance.new("TextButton", contentFrame)
stopBtn.Size = UDim2.new(0.44, 0, 0, 40)
stopBtn.Position = UDim2.new(0.51, 0, 0, btnY)
stopBtn.Text = "⏹ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local stCorner = Instance.new("UICorner", stopBtn)
stCorner.CornerRadius = UDim.new(0, 10)

stopBtn.MouseButton1Click:Connect(StopFling)

-- Select All
local selAllBtn = Instance.new("TextButton", contentFrame)
selAllBtn.Size = UDim2.new(0.44, 0, 0, 32)
selAllBtn.Position = UDim2.new(0.05, 0, 0, btnY + 48)
selAllBtn.Text = "✅ SELECT ALL"
selAllBtn.Font = Enum.Font.Gotham
selAllBtn.TextSize = 13
selAllBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
selAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local saCorner = Instance.new("UICorner", selAllBtn)
saCorner.CornerRadius = UDim.new(0, 8)

selAllBtn.MouseButton1Click:Connect(function() ToggleAll(true) end)

-- Deselect All
local desAllBtn = Instance.new("TextButton", contentFrame)
desAllBtn.Size = UDim2.new(0.44, 0, 0, 32)
desAllBtn.Position = UDim2.new(0.51, 0, 0, btnY + 48)
desAllBtn.Text = "❌ DESELECT ALL"
desAllBtn.Font = Enum.Font.Gotham
desAllBtn.TextSize = 13
desAllBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
desAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local daCorner = Instance.new("UICorner", desAllBtn)
daCorner.CornerRadius = UDim.new(0, 8)

desAllBtn.MouseButton1Click:Connect(function() ToggleAll(false) end)

-- Anti-Fling Button
local antiFlingBtn = Instance.new("TextButton", contentFrame)
antiFlingBtn.Size = UDim2.new(0.92, 0, 0, 32)
antiFlingBtn.Position = UDim2.new(0.04, 0, 0, btnY + 88)
antiFlingBtn.Text = "🛡️ ANTI-FLING: OFF"
antiFlingBtn.Font = Enum.Font.GothamBold
antiFlingBtn.TextSize = 14
antiFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
antiFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local afCorner = Instance.new("UICorner", antiFlingBtn)
afCorner.CornerRadius = UDim.new(0, 10)

antiFlingBtn.MouseButton1Click:Connect(function()
    local newState = not antiFlingEnabled
    ToggleAntiFling(newState)
    antiFlingBtn.Text = newState and "🛡️ ANTI-FLING: ON" or "🛡️ ANTI-FLING: OFF"
    antiFlingBtn.BackgroundColor3 = newState and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(40, 20, 60)
end)

-- Noclip toggle
local noclipBtn = Instance.new("TextButton", contentFrame)
noclipBtn.Size = UDim2.new(0.92, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.04, 0, 0, btnY + 128)
noclipBtn.Text = "🚶 NOCLIP: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 14
noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local nocCorner = Instance.new("UICorner", noclipBtn)
nocCorner.CornerRadius = UDim.new(0, 10)

local noclipEnabled = false
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "🚶 NOCLIP: ON" or "🚶 NOCLIP: OFF"
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(40, 20, 60)
end)

-- Noclip logic (отключает коллизию со ВСЕМ, включая мир)
RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)


-- Initialize
UpdatePlayerList()
UpdateStatus()

-- Player join/leave
Players.PlayerAdded:Connect(function()
    UpdatePlayerList()
    UpdateStatus()
end)
Players.PlayerRemoving:Connect(function(player)
    SelectedTargets[player.Name] = nil
    UpdatePlayerList()
    UpdateStatus()
end)

print("EPANNIY FLING LOADED")
