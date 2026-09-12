-- SCRIPT HUB | CATEGORIES EDITION
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EppaniyHub"

-- Main container
local mainContainer = Instance.new("Frame", gui)
mainContainer.Size = UDim2.new(0, 520, 0, 340)
mainContainer.Position = UDim2.new(0.3, 0, 0.3, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Draggable = true

-- Main frame
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

-- Title bar
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
title.Text = "📦 SCRIPT HUB \\// 🤙 EPANNIY HUB"
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

-- Content
local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

-- === СКРИПТЫ С КАТЕГОРИЯМИ ===
local scripts = {
    {name = "💥 Epanniy Fling",  category = "Branded Universal", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EpanniyFling.lua"},
    {name = "✈ Eppaniy Fly",     category = "Branded Universal", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EppaniyFly.lua"},
    {name = "🎵 Eppaniy Music",  category = "Branded Universal", url = "https://raw.githubusercontent.com/localplaystudios/izibridgi/refs/heads/main/EppaniyMusic.lua"},
    {name = "♾ Infinite Yield",  category = "Universal", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {name = "🔲 Dex Explorer ++",  category = "Universal", url = "https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"},
    {name = "🔪 MM2 Script #1",  category = "MM2", url = "https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader"},
    {name = "🚪 DOORS Script #1", category = "DOORS", url = "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Loader.luau"},
    {name = "🚪 DOORS Script #2", category = "DOORS", url = "https://www.msdoors.xyz/script"},
}

-- Собираем категории автоматически
local categories = {["All"] = true}
for _, s in ipairs(scripts) do
    if s.category then
        categories[s.category] = true
    end
end

-- Сортируем категории: All первая, остальные по алфавиту
local categoryList = {"All"}
for cat, _ in pairs(categories) do
    if cat ~= "All" then
        table.insert(categoryList, cat)
    end
end
table.sort(categoryList, function(a, b)
    if a == "All" then return true end
    if b == "All" then return false end
    return a:lower() < b:lower()
end)

-- === ЛЕВАЯ ЧАСТЬ — СПИСОК СКРИПТОВ ===
local scrollFrame = Instance.new("ScrollingFrame", contentFrame)
scrollFrame.Size = UDim2.new(0.72, 0, 1, -10)
scrollFrame.Position = UDim2.new(0.02, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BorderSizePixel = 0

-- === ПРАВАЯ ЧАСТЬ — КАТЕГОРИИ ===
local categoryPanel = Instance.new("Frame", contentFrame)
categoryPanel.Size = UDim2.new(0.24, 0, 1, -10)
categoryPanel.Position = UDim2.new(0.75, 0, 0, 0)
categoryPanel.BackgroundTransparency = 1

local categoryLabel = Instance.new("TextLabel", categoryPanel)
categoryLabel.Size = UDim2.new(1, 0, 0, 20)
categoryLabel.Position = UDim2.new(0, 0, 0, 0)
categoryLabel.BackgroundTransparency = 1
categoryLabel.Font = Enum.Font.GothamBold
categoryLabel.TextSize = 13
categoryLabel.Text = "CATEGORIES"
categoryLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
categoryLabel.TextXAlignment = Enum.TextXAlignment.Left

local catScroll = Instance.new("ScrollingFrame", categoryPanel)
catScroll.Size = UDim2.new(1, 0, 1, -25)
catScroll.Position = UDim2.new(0, 0, 0, 25)
catScroll.BackgroundTransparency = 1
catScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
catScroll.ScrollBarThickness = 4
catScroll.BorderSizePixel = 0

-- === ФУНКЦИЯ ПОСТРОЕНИЯ СПИСКА СКРИПТОВ ===
local function buildScriptList(filterCategory)
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local yPos = 5
    for _, scriptData in ipairs(scripts) do
        if filterCategory == "All" or scriptData.category == filterCategory then
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

            -- Показываем категорию рядом с именем
            local catTag = Instance.new("TextLabel", btn)
            catTag.Size = UDim2.new(0, 80, 1, 0)
            catTag.Position = UDim2.new(1, -85, 0, 0)
            catTag.BackgroundTransparency = 1
            catTag.Font = Enum.Font.Gotham
            catTag.TextSize = 11
            catTag.Text = scriptData.category or ""
            catTag.TextColor3 = Color3.fromRGB(180, 140, 220)
            catTag.TextXAlignment = Enum.TextXAlignment.Right

            btn.MouseButton1Click:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
                task.wait(0.1)
                btn.BackgroundColor3 = Color3.fromRGB(50, 25, 65)

                local success = pcall(function()
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
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- === ФУНКЦИЯ ПОСТРОЕНИЯ КАТЕГОРИЙ ===
local currentCategory = "All"
local catButtons = {}

local function highlightCategory(selected)
    for cat, btn in pairs(catButtons) do
        if cat == selected then
            btn.BackgroundColor3 = Color3.fromRGB(90, 40, 130)
            btn.TextColor3 = Color3.fromRGB(255, 220, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 20, 60)
            btn.TextColor3 = Color3.fromRGB(220, 200, 240)
        end
    end
end

local function buildCategories()
    local yPos = 0
    for _, catName in ipairs(categoryList) do
        local btn = Instance.new("TextButton", catScroll)
        btn.Size = UDim2.new(1, -5, 0, 32)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(45, 20, 60)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Text = catName
        btn.TextColor3 = Color3.fromRGB(220, 200, 240)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)
        btn.AutoButtonColor = true

        btn.MouseButton1Click:Connect(function()
            currentCategory = catName
            highlightCategory(catName)
            buildScriptList(catName)
        end)

        catButtons[catName] = btn
        yPos = yPos + 37
    end
    catScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

-- Инициализация
buildCategories()
highlightCategory("All")
buildScriptList("All")

-- Minimize
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "─"
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 520, 0, 35)
    else
        mainContainer.Size = UDim2.new(0, 520, 0, 340)
    end
end)

print("EPANNIY SCRIPT HUB (CATEGORIES) LOADED")
