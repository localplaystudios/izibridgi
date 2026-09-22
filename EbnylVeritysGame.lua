local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VeritysGameScript_" .. HttpService:GenerateGUID(false)

local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 420, 0, 260)
mainContainer.Position = UDim2.new(0.3, 0, 0.3, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Draggable = true

local frame = Instance.new("Frame", mainContainer)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
frame.ZIndex = 1
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 14)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 25, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 8, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 4, 18))
})
gradient.Rotation = 45

local titleFrame = Instance.new("Frame", mainContainer)
titleFrame.Size = UDim2.new(1, 0, 0, 35)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(70, 25, 100)
titleFrame.ZIndex = 10
local titleCorner = Instance.new("UICorner", titleFrame)
titleCorner.CornerRadius = UDim.new(0, 14)

local titleGrad = Instance.new("UIGradient", titleFrame)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 40, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 80))
})
titleGrad.Rotation = 90

local title = Instance.new("TextLabel", titleFrame)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Text = "🙂 EBNYL VERITY'S GAME"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.ZIndex = 11

local minimizeBtn = Instance.new("TextButton", titleFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.ZIndex = 11
local minCorner = Instance.new("UICorner", minimizeBtn)
minCorner.CornerRadius = UDim.new(0, 8)

local isMinimized = false

local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

-- === AUTO FLIPPITY LABEL ===
local sectionLabel = Instance.new("TextLabel", contentFrame)
sectionLabel.Size = UDim2.new(1, -20, 0, 22)
sectionLabel.Position = UDim2.new(0, 10, 0, 8)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextSize = 14
sectionLabel.Text = "Auto Flippity"
sectionLabel.TextColor3 = Color3.fromRGB(220, 190, 255)
sectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- === КНОПКА CLEAR PIPES ===
local clearBtn = Instance.new("TextButton", contentFrame)
clearBtn.Size = UDim2.new(1, -20, 0, 45)
clearBtn.Position = UDim2.new(0, 10, 0, 40)
clearBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 14
clearBtn.Text = "Clear Pipes: OFF"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local clearCorner = Instance.new("UICorner", clearBtn)
clearCorner.CornerRadius = UDim.new(0, 8)

-- === КНОПКА AUTO CLICKER ===
local clickerBtn = Instance.new("TextButton", contentFrame)
clickerBtn.Size = UDim2.new(1, -20, 0, 45)
clickerBtn.Position = UDim2.new(0, 10, 0, 95)
clickerBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
clickerBtn.Font = Enum.Font.GothamBold
clickerBtn.TextSize = 14
clickerBtn.Text = "Auto Clicker: OFF"
clickerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local clickerCorner = Instance.new("UICorner", clickerBtn)
clickerCorner.CornerRadius = UDim.new(0, 8)

-- === СТАТУС ===
local statusLabel = Instance.new("TextLabel", contentFrame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Text = "Status: idle"
statusLabel.TextColor3 = Color3.fromRGB(180, 160, 200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- === СОСТОЯНИЯ ===
local clearEnabled = false
local clearThread = nil

local clickerEnabled = false
local clickerConnection = nil

-- === CLEAR PIPES LOOP ===
local function clearPipesLoop()
    while clearEnabled do
        local pg = plr:FindFirstChild("PlayerGui")
        if pg then
            local fg = pg:FindFirstChild("FlappityGui")
            if fg then
                local panelObj = fg:FindFirstChild("Panel")
                if panelObj then
                    local board = panelObj:FindFirstChild("Board")
                    if board then
                        local pipes = board:FindFirstChild("Pipes")
                        if pipes then
                            pipes:ClearAllChildren()
                        end
                    end
                end
            end
        end
        task.wait()
    end
end

-- === AUTO CLICKER LOOP ===
local function autoClickerLoop()
    local pg = plr:FindFirstChild("PlayerGui")
    if not pg then return end
    local fg = pg:FindFirstChild("FlappityGui")
    if not fg then return end
    local panelObj = fg:FindFirstChild("Panel")
    if not panelObj then return end
    local board = panelObj:FindFirstChild("Board")
    if not board then return end

    local absPos = board.AbsolutePosition
    local absSize = board.AbsoluteSize
    local cx = absPos.X + absSize.X / 2
    local cy = absPos.Y + absSize.Y / 2

    -- 1) Виртуальный клик по координатам Board
    pcall(function()
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(cx, cy, 0, true, game, 0)
        task.wait(1)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(cx, cy, 0, false, game, 0)
    end)

    -- 2) Прямой вызов активации через firesignal (если есть GuiButton)
    for _, obj in ipairs(board:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Visible then
            pcall(function()
                if obj.MouseButton1Click then
                    obj.MouseButton1Click:Fire()
                end
            end)
        end
    end
end

-- === CLEAR PIPES BUTTON ===
clearBtn.MouseButton1Click:Connect(function()
    clearEnabled = not clearEnabled
    if clearEnabled then
        clearBtn.Text = "Clear Pipes: ON"
        clearBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 40)
        clearThread = task.spawn(clearPipesLoop)
        statusLabel.Text = "Status: clearing pipes..."
    else
        clearBtn.Text = "Clear Pipes: OFF"
        clearBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
        if clearThread then
            task.cancel(clearThread)
            clearThread = nil
        end
        statusLabel.Text = "Status: pipes stopped"
    end
end)

-- === AUTO CLICKER BUTTON ===
clickerBtn.MouseButton1Click:Connect(function()
    clickerEnabled = not clickerEnabled
    if clickerEnabled then
        clickerBtn.Text = "Auto Clicker: ON"
        clickerBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 40)
        clickerConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if clickerEnabled then
                autoClickerLoop()
            end
        end)
        statusLabel.Text = "Status: clicking..."
    else
        clickerBtn.Text = "Auto Clicker: OFF"
        clickerBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
        if clickerConnection then
            clickerConnection:Disconnect()
            clickerConnection = nil
        end
        statusLabel.Text = "Status: clicker stopped"
    end
end)

-- === MINIMIZE ===
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "─"
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 420, 0, 35)
    else
        mainContainer.Size = UDim2.new(0, 420, 0, 260)
    end
end)

print("Verity's Game Script Loaded!")
