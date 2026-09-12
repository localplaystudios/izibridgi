-- MUSIC PLAYER | RAGE STYLE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local plr = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EppaniyMusic"
gui.ResetOnSpawn = false

-- Main container
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 360, 0, 400)
mainContainer.Position = UDim2.new(0.35, 0, 0.25, 0)
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
title.Text = "🎵 EPPANIY MUSIC"
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

-- Content
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

-- Sound object
local sound = Instance.new("Sound", SoundService)
sound.Name = "EppaniyMusicSound"
sound.Volume = 0.5
sound.PlaybackSpeed = 1.0
sound.Looped = false

-- === SLIDER HELPER ===
local function createSlider(parent, yPos, labelText, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0.92, 0, 0, 42)
    container.Position = UDim2.new(0.04, 0, 0, yPos)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = labelText .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", container)
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Position = UDim2.new(0, 0, 0, 24)
    track.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
    track.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner", track)
    trackCorner.CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 4)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
    knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    knob.ZIndex = 2

    local dragging = false

    local function setValue(alpha)
        alpha = math.clamp(alpha, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, -7, 0.5, -7)
        local val = minVal + (maxVal - minVal) * alpha
        label.Text = labelText .. ": " .. string.format("%.2f", val)
        callback(val)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local trackAbsPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            setValue((mouseX - trackAbsPos) / trackSize)
        end
    end)

    return {setValue = setValue, container = container, label = label}
end

-- === URL INPUT ===
local urlBox = Instance.new("TextBox", contentFrame)
urlBox.Size = UDim2.new(0.92, 0, 0, 32)
urlBox.Position = UDim2.new(0.04, 0, 0, 5)
urlBox.PlaceholderText = "Paste audio link (rbxassetid or URL)"
urlBox.ClearTextOnFocus = false
urlBox.Font = Enum.Font.Gotham
urlBox.TextSize = 13
urlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
urlBox.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
urlBox.Text = ""
urlBox.TextXAlignment = Enum.TextXAlignment.Left
local urlCorner = Instance.new("UICorner", urlBox)
urlCorner.CornerRadius = UDim.new(0, 8)

-- === SLIDERS ===
local slidersY = 45
local volumeSlider = createSlider(contentFrame, slidersY, "Volume", 0, 2, 0.5, function(v)
    sound.Volume = v
end)

local pitchSlider = createSlider(contentFrame, slidersY + 47, "Pitch", 0.1, 5, 1.0, function(v)
    sound.PlaybackSpeed = v
end)

local timePosSlider = createSlider(contentFrame, slidersY + 94, "Position (sec)", 0, 300, 0, function(v)
    if sound.IsPlaying or sound.TimeLength > 0 then
        sound.TimePosition = math.clamp(v, 0, sound.TimeLength)
    end
end)

-- === CONTROL BUTTONS ===
local btnY = slidersY + 145

local playBtn = Instance.new("TextButton", contentFrame)
playBtn.Size = UDim2.new(0.29, 0, 0, 38)
playBtn.Position = UDim2.new(0.04, 0, 0, btnY)
playBtn.Text = "▶ PLAY"
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 14
playBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local pCorner = Instance.new("UICorner", playBtn)
pCorner.CornerRadius = UDim.new(0, 8)

local pauseBtn = Instance.new("TextButton", contentFrame)
pauseBtn.Size = UDim2.new(0.29, 0, 0, 38)
pauseBtn.Position = UDim2.new(0.355, 0, 0, btnY)
pauseBtn.Text = "⏸ PAUSE"
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.TextSize = 14
pauseBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 0)
pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local paCorner = Instance.new("UICorner", pauseBtn)
paCorner.CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton", contentFrame)
stopBtn.Size = UDim2.new(0.29, 0, 0, 38)
stopBtn.Position = UDim2.new(0.67, 0, 0, btnY)
stopBtn.Text = "⏹ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local stCorner = Instance.new("UICorner", stopBtn)
stCorner.CornerRadius = UDim.new(0, 8)

-- Second row
local btnY2 = btnY + 46

local loopBtn = Instance.new("TextButton", contentFrame)
loopBtn.Size = UDim2.new(0.44, 0, 0, 32)
loopBtn.Position = UDim2.new(0.04, 0, 0, btnY2)
loopBtn.Text = "🔁 LOOP: OFF"
loopBtn.Font = Enum.Font.GothamBold
loopBtn.TextSize = 13
loopBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local lCorner = Instance.new("UICorner", loopBtn)
lCorner.CornerRadius = UDim.new(0, 8)

local resumeBtn = Instance.new("TextButton", contentFrame)
resumeBtn.Size = UDim2.new(0.44, 0, 0, 32)
resumeBtn.Position = UDim2.new(0.52, 0, 0, btnY2)
resumeBtn.Text = "⏯ RESUME"
resumeBtn.Font = Enum.Font.GothamBold
resumeBtn.TextSize = 13
resumeBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
resumeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local rCorner = Instance.new("UICorner", resumeBtn)
rCorner.CornerRadius = UDim.new(0, 8)

-- Third row
local btnY3 = btnY2 + 40

local destroyBtn = Instance.new("TextButton", contentFrame)
destroyBtn.Size = UDim2.new(0.92, 0, 0, 32)
destroyBtn.Position = UDim2.new(0.04, 0, 0, btnY3)
destroyBtn.Text = "🗑 DESTROY (unload sound + gui)"
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 13
destroyBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 40)
destroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local dCorner = Instance.new("UICorner", destroyBtn)
dCorner.CornerRadius = UDim.new(0, 8)

-- Status
local statusLabel = Instance.new("TextLabel", contentFrame)
statusLabel.Size = UDim2.new(0.92, 0, 0, 20)
statusLabel.Position = UDim2.new(0.04, 0, 0, btnY3 + 38)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- === LOGIC ===
local function parseAsset(input)
    input = input:gsub("%s+", "")
    if input == "" then return nil end
    local id = input:match("rbxassetid://(%d+)") or input:match("id=(%d+)") or input:match("^(%d+)$")
    if id then
        return "rbxassetid://" .. id
    end
    return input
end

playBtn.MouseButton1Click:Connect(function()
    local parsed = parseAsset(urlBox.Text)
    if not parsed then
        statusLabel.Text = "❌ Enter a link"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    sound:Stop()
    sound.SoundId = parsed
    sound:Play()
    statusLabel.Text = "▶ Playing"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end)

pauseBtn.MouseButton1Click:Connect(function()
    sound:Pause()
    statusLabel.Text = "⏸ Paused"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
end)

resumeBtn.MouseButton1Click:Connect(function()
    sound:Resume()
    statusLabel.Text = "▶ Playing"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end)

stopBtn.MouseButton1Click:Connect(function()
    sound:Stop()
    statusLabel.Text = "⏹ Stopped"
    statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
end)

loopBtn.MouseButton1Click:Connect(function()
    sound.Looped = not sound.Looped
    loopBtn.Text = sound.Looped and "🔁 LOOP: ON" or "🔁 LOOP: OFF"
    loopBtn.BackgroundColor3 = sound.Looped and Color3.fromRGB(80, 30, 120) or Color3.fromRGB(50, 25, 65)
end)

destroyBtn.MouseButton1Click:Connect(function()
    sound:Destroy()
    gui:Destroy()
end)

-- Time position updater
RunService.Heartbeat:Connect(function()
    if sound.IsPlaying then
        statusLabel.Text = string.format("▶ %02d:%02d / %02d:%02d",
            math.floor(sound.TimePosition / 60), math.floor(sound.TimePosition % 60),
            math.floor(sound.TimeLength / 60), math.floor(sound.TimeLength % 60))
    end
end)

-- Minimize
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "─"
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 360, 0, 35)
    else
        mainContainer.Size = UDim2.new(0, 360, 0, 400)
    end
end)

print("EPANNIY MUSIC PLAYER LOADED")
