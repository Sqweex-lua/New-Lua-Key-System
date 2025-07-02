-- [НАСТРОЙКИ]
local githubUser = "Sqweex-lua"        -- GitHub имя
local repoName = "New-Lua-Key-System"  -- Название репозитория
local branch = "main"                -- Ветка
local keyFile = "key.txt"            -- Имя файла с ключом
local scriptFile = "ss.lua"        -- Главный скрипт

-- [СОЗДАЁМ GUI]
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KeySystem"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 130)
frame.Position = UDim2.new(0.5, -150, 0.5, -65)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0

-- RGB ОБВОДКА
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.Transparency = 0
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    uiStroke.Color = Color3.fromHSV(hue / 360, 1, 1)
end)

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🔑 Enter Key to Unlock DeltaWare"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

-- ПОЛЕ ВВОДА
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9, 0, 0, 35)
input.Position = UDim2.new(0.05, 0, 0.4, 0)
input.PlaceholderText = "Enter your key here..."
input.Font = Enum.Font.SourceSansBold
input.TextScaled = true
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
input.BorderSizePixel = 0

-- КНОПКА ПОДТВЕРЖДЕНИЯ
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 30)
btn.Position = UDim2.new(0.05, 0, 0.75, 0)
btn.Text = "✅ Submit"
btn.Font = Enum.Font.Gotham
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btn.BorderSizePixel = 0

-- [КНОПКА: проверка ключа и загрузка]
btn.MouseButton1Click:Connect(function()
    local entered = string.lower(input.Text or ""):gsub("%s+", "")
    local keyURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", githubUser, repoName, branch, keyFile)
    local trueKey = string.lower(game:HttpGet(keyURL)):gsub("%s+", "")

    if entered == trueKey then
        gui:Destroy()
        local scriptURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", githubUser, repoName, branch, scriptFile)
        loadstring(game:HttpGet(scriptURL))()
    else
        btn.Text = "❌ Invalid Key"
        btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        wait(1)
        btn.Text = "✅ Submit"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)
