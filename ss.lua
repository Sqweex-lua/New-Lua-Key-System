local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library//main/Library", true))()

local window = library:AddWindow("t.me/clientpython", {
	main_color = Color3.fromRGB(41, 74, 122), -- Color
	min_size = Vector2.new(250, 250), -- Size of the gui
	can_resize = true, -- true or false
})

local Main = window:AddTab("Main") -- Name of tab
Main:Show() -- shows the tab

local Misc = window:AddTab("Misc") -- Name of tab
Misc:Show() -- shows the tab

local Guis = window:AddTab("Guis") -- Name of tab
Guis:Show() -- shows the tab

Main:AddButton("Chams", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and not part:FindFirstChild("ChamsHighlight") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ChamsHighlight"
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                    box.Color3 = Color3.new(1, 0, 0) -- Красный
                    box.Transparency = 0.5
                    box.Parent = part
                end
            end
        end
    end
end)

Main:AddButton("Enable ESP", function()
    local player = game.Players.LocalPlayer

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local head = otherPlayer.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESPLabel") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "t.me/clientpython"
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.AlwaysOnTop = true
                billboard.StudsOffset = Vector3.new(0, 2, 0)

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Parent = billboard
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = Color3.new(1, 0, 0) -- Красный
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextScaled = true

                nameLabel.Text = otherPlayer.Name

                billboard.Parent = head

                -- Обновление расстояния
                game:GetService("RunService").RenderStepped:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((head.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                        nameLabel.Text = string.format("%s [%sm]", otherPlayer.Name, dist)
                    end
                end)
            end
        end
    end
end)

local hvhActive = false
local hvhConnection
local strafeDirection = 1

Misc:AddButton("HvH Mode", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    hvhActive = not hvhActive

    if hvhActive then
        if humanoid then humanoid.WalkSpeed = 75 end

        -- Крутилка
        hvhConnection = game:GetService("RunService").RenderStepped:Connect(function()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            player.Character:TranslateBy(Vector3.new(strafeDirection * 0.5, 0, 0))
            strafeDirection = -strafeDirection
        end)

        -- RGB Trail
-- В блоке включения HvH
local leg = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg") or hrp
local trail = Instance.new("Trail")
trail.Name = "HvHFootTrail"
trail.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
}
trail.Lifetime = 0.6
trail.Attachment0 = Instance.new("Attachment", leg)
trail.Attachment1 = Instance.new("Attachment", leg)
trail.Parent = leg


        -- 3 лицо
        game.Workspace.CurrentCamera.CameraSubject = humanoid
        game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    else
        if humanoid then humanoid.WalkSpeed = 16 end
        if hvhConnection then hvhConnection:Disconnect() end

        local trail = hrp:FindFirstChild("HvHTrail")
        if trail then trail:Destroy() end
    end
end)

local hatExists = false
local hue = 0
local colorConnection

Guis:AddButton("China Hat", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    if not hatExists then
        -- Создаём старую версию шапки
        local hat = Instance.new("Part")
        hat.Name = "ChinaHatRGB"
        hat.Anchored = false
        hat.CanCollide = false
        hat.Size = Vector3.new(4, 0.3, 4)
        hat.Shape = Enum.PartType.Block
        hat.Transparency = 0.4
        hat.Material = Enum.Material.Neon
        hat.Parent = head

        -- Mesh плоского конуса
        local mesh = Instance.new("SpecialMesh", hat)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1033714"
        mesh.Scale = Vector3.new(2, 1, 2)

        -- Позиционирование шапки над головой
        hat.CFrame = head.CFrame * CFrame.new(0, 1, 0)
        local weld = Instance.new("WeldConstraint", hat)
        weld.Part0 = hat
        weld.Part1 = head

        -- RGB-анимация
        colorConnection = game:GetService("RunService").RenderStepped:Connect(function()
            hue = (hue + 1) % 360
            hat.Color = Color3.fromHSV(hue / 360, 1, 1)
        end)

        hatExists = true
    else
        -- Удаление шапки
        if colorConnection then colorConnection:Disconnect() end
        local oldHat = head:FindFirstChild("ChinaHatRGB")
        if oldHat then oldHat:Destroy() end
        hatExists = false
    end
end)

Main:AddButton("Glow Chams", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Neon
                    part.Color = Color3.fromRGB(255, 0, 255)
                    part.Transparency = 0.3
                end
            end
        end
    end
end)

Main:AddButton("Outline Chams RGB", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("OutlineRGB")
            if not highlight then
                local hl = Instance.new("Highlight")
                hl.Name = "OutlineRGB"
                hl.FillTransparency = 1
                hl.OutlineTransparency = 0
                hl.Parent = player.Character

                local hue = 0
                game:GetService("RunService").RenderStepped:Connect(function()
                    if hl and hl.Parent then
                        hue = (hue + 1) % 360
                        hl.OutlineColor = Color3.fromHSV(hue / 360, 1, 1)
                    end
                end)
            end
        end
    end
end)

Guis:AddButton("Toggle Watermark", function()
    local coreGui = game:GetService("CoreGui")
    local existing = coreGui:FindFirstChild("DeltaWareWatermark")

    if existing then
        existing:Destroy()
        return
    end

    local screenGui = Instance.new("ScreenGui", coreGui)
    screenGui.Name = "DeltaWareWatermark"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.Size = UDim2.new(0, 170, 0, 40)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "⚡ DeltaWare ⚡"
    text.Font = Enum.Font.NotoSans
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextScaled = true
    text.TextStrokeTransparency = 0.7
end)

Misc:AddButton("Rtx"), function() 
    loadstring(game:HttpGet("https://rawscripts.net/raw/Just-a-baseplate.-Script-de-RTX-43523"))()
end) 