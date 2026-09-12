-- SCRIPT HUB | RAGE STYLE
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EppaniyHub"

-- Главный контейнер
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 360, 0, 300)
mainContainer.Position = UDim2.new(0.35, 0, 0.3, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Draggable = true

-- Фрейм (содержимое)
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

-- Заголовок (ПОВЕРХ фрейма)
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
title.Text = "📦 SCRIPT HUB \\// 🤙 EPANNIY HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.ZIndex = 11

-- Кнопка свернуть
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

-- Контент
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame", contentFrame)
scrollFrame.Size = UDim2.new(0.94, 0, 1, -10)
scrollFrame.Position = UDim2.new(0.03, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BorderSizePixel = 0

-- Скрипты
local scripts = {
    {name = "💥 Epanniy Fling", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EpanniyFling.lua"},
    {name = "✈ Eppaniy Fly", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EppaniyFly.lua"},
    {name = "🎵 Eppaniy Music", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EppaniyMusic.lua"},
    {name = "🔪 MM2 Script #1", url = "https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader"},
    {name = "🚪 DOORS Script #1", url = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Loader.luau"},
    {name = "🚪 DOORS Script #2", url = "https://www.msdoors.xyz/script"},
    {name = "♾", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
}

local function buildUI()
    local yPos = 5
    for _, scriptData in ipairs(scripts) do
        local btn = Instance.new("TextButton", scrollFrame)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.Text = scriptData.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)
        btn.AutoButtonColor = true

        btn.MouseButton1Click:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
            task.wait(0.1)
            btn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)

            local success, err = pcall(function()
                loadstring(game:HttpGet(scriptData.url))()
            end)
            if not success then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "❌ Error",
                    Text = "Failed to load: " .. scriptData.name,
                    Duration = 3
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "✅ Loaded",
                    Text = scriptData.name .. " executed!",
                    Duration = 2
                })
            end
        end)

        yPos = yPos + 45
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

buildUI()

-- Сворачивание
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "─"
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 360, 0, 35)
    else
        mainContainer.Size = UDim2.new(0, 360, 0, 300)
    end
end)

print("EPANNIY SCRIPT HUB LOADED")
