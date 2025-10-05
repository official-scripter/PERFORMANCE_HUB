-- PERFORMANCE HUB (BETA v2) by Gonzales Official

local KEY = "555"
local DISCORD_LINK = "https://discord.gg/mnXcbBjNQ7"

local function makeDraggable(frame)
    local UIS = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            UIS.InputChanged:Connect(function(inp)
                if dragging and inp == input then
                    local delta = inp.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
end

if game.CoreGui:FindFirstChild("PerformanceHub") then
    game.CoreGui.PerformanceHub:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "PerformanceHub"
sg.ResetOnSpawn = false
sg.Parent = syn and syn.protect_gui and syn.protect_gui(game.CoreGui) or game.CoreGui

-- Main Frame
local hub = Instance.new("Frame")
hub.Name = "MainHub"
hub.Size = UDim2.new(0, 380, 0, 220)
hub.Position = UDim2.new(0.5, -190, 0.5, -110)
hub.BackgroundColor3 = Color3.fromRGB(25, 120, 185)
hub.BorderSizePixel = 0
hub.Parent = sg

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = Color3.fromRGB(0, 220, 150)
header.BorderSizePixel = 0
header.Parent = hub

local title = Instance.new("TextLabel")
title.Text = "PERFORMANCE HUB (BETA v2)"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 32)
title.Position = UDim2.new(0, 0, 0, 0)
title.Parent = header

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 24
minimize.Size = UDim2.new(0, 32, 0, 32)
minimize.Position = UDim2.new(1, -64, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(18, 150, 180)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BorderSizePixel = 0
minimize.Parent = header

-- Close Button
local close = Instance.new("TextButton")
close.Text = "*"
close.Font = Enum.Font.GothamBold
close.TextSize = 24
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -32, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
close.TextColor3 = Color3.new(1,1,1)
close.BorderSizePixel = 0
close.Parent = header

-- Key System UI
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, 0, 1, -32)
keyFrame.Position = UDim2.new(0, 0, 0, 32)
keyFrame.BackgroundTransparency = 1
keyFrame.Parent = hub

-- Enter Key (left)
local enterKey = Instance.new("TextButton")
enterKey.Text = "Enter Key"
enterKey.Font = Enum.Font.GothamBold
enterKey.TextSize = 16
enterKey.Size = UDim2.new(0, 90, 0, 40)
enterKey.Position = UDim2.new(0, 8, 0.2, 0)
enterKey.BackgroundColor3 = Color3.fromRGB(40,210,180)
enterKey.TextColor3 = Color3.new(1,1,1)
enterKey.BorderSizePixel = 0
enterKey.Parent = keyFrame

-- Key Box (center)
local keyBox = Instance.new("TextBox")
keyBox.PlaceholderText = "Enter Key"
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18
keyBox.Size = UDim2.new(0, 140, 0, 40)
keyBox.Position = UDim2.new(0, 106, 0.2, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(240,240,240)
keyBox.TextColor3 = Color3.fromRGB(0,0,0)
keyBox.BorderSizePixel = 0
keyBox.Parent = keyFrame

-- Get Key (right)
local getKey = Instance.new("TextButton")
getKey.Text = "Get Key"
getKey.Font = Enum.Font.GothamBold
getKey.TextSize = 16
getKey.Size = UDim2.new(0, 90, 0, 40)
getKey.Position = UDim2.new(0, 256, 0.2, 0)
getKey.BackgroundColor3 = Color3.fromRGB(40,120,210)
getKey.TextColor3 = Color3.new(1,1,1)
getKey.BorderSizePixel = 0
getKey.Parent = keyFrame

-- Bottom Credit
local credit = Instance.new("TextLabel")
credit.Text = "By: Gonzales Official"
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.TextColor3 = Color3.new(1,1,1)
credit.BackgroundTransparency = 1
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.Parent = hub

-- Minimized tab (hidden by default)
local minimized = Instance.new("TextButton")
minimized.Name = "MinimizedTab"
minimized.Text = ""
minimized.Size = UDim2.new(0, 148, 0, 8)
minimized.Position = UDim2.new(0.5, -74, 0, 0)
minimized.BackgroundColor3 = Color3.fromRGB(0, 220, 150)
minimized.BorderSizePixel = 0
minimized.AutoButtonColor = false
minimized.Visible = false
minimized.Parent = sg

local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 1, 0)
line.BackgroundColor3 = Color3.fromRGB(25, 120, 185)
line.BorderSizePixel = 0
line.Parent = minimized

-- Minimize/Restore logic
local function minimizeHub()
    hub.Visible = false
    minimized.Visible = true
end
local function restoreHub()
    hub.Visible = true
    minimized.Visible = false
end

minimize.MouseButton1Click:Connect(minimizeHub)
minimized.MouseButton1Click:Connect(restoreHub)
close.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

getKey.MouseButton1Click:Connect(function()
    if syn and syn.open_url then
        syn.open_url(DISCORD_LINK)
    elseif Krnl and Krnl.Beta and Krnl.Beta.openUrl then
        Krnl.Beta.openUrl(DISCORD_LINK)
    elseif getrenv and getrenv().LaunchWebsite then
        getrenv().LaunchWebsite(DISCORD_LINK)
    elseif request and request({Url=DISCORD_LINK,Method="GET"}) then
        -- Some rare executors support this, triggers browser open
    else
        setclipboard(DISCORD_LINK)
        getKey.Text = "Copied!"
        wait(1)
        getKey.Text = "Get Key"
    end
end)

-- Optimization functions for all devices
local function antiLag()
    pcall(function()
        settings().Rendering.QualityLevel = "Level01"
    end)
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v.Visible = false
        end
    end
    if game.Lighting:FindFirstChildOfClass("BlurEffect") then
        game.Lighting:FindFirstChildOfClass("BlurEffect").Enabled = false
    end
    if game.Lighting:FindFirstChildOfClass("SunRaysEffect") then
        game.Lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = false
    end
    game.Lighting.Brightness = 1
end

local function antiOverheat()
    if setfpscap then setfpscap(30) end
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") and v.Name:lower():find("ambient") then
            v:Stop()
        end
    end
end

local function boostFPS()
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 100000
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v.Transparency = 1
        end
    end
end

enterKey.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyFrame.Visible = false

        -- Small Movable Tab with bottom credit
        local tab = Instance.new("Frame")
        tab.Name = "MovableTab"
        tab.Size = UDim2.new(0, 190, 0, 60)
        tab.Position = UDim2.new(0, 30, 0, 80)
        tab.BackgroundColor3 = Color3.fromRGB(0, 220, 150)
        tab.BorderSizePixel = 0
        tab.Parent = sg

        makeDraggable(tab)

        local tabHeader = Instance.new("Frame")
        tabHeader.Size = UDim2.new(1, 0, 0, 12)
        tabHeader.BackgroundColor3 = Color3.fromRGB(25, 120, 185)
        tabHeader.BorderSizePixel = 0
        tabHeader.Parent = tab

        -- Button order: Anti-Lag, Anti-Overheat, Boost FPS
        local buttonColors = {
            Color3.fromRGB(60, 180, 220),
            Color3.fromRGB(50, 210, 140),
            Color3.fromRGB(70, 140, 210),
        }
        local buttonTexts = {"Anti-Lag", "Anti-Overheat", "Boost FPS"}
        local buttonFuncs = {antiLag, antiOverheat, boostFPS}

        for i=1,3 do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 55, 0, 28)
            btn.Position = UDim2.new(0, 10 + (i-1)*60, 0, 16)
            btn.BackgroundColor3 = buttonColors[i]
            btn.Text = buttonTexts[i]
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BorderSizePixel = 0
            btn.Parent = tab

            btn.MouseButton1Click:Connect(function()
                btn.Text = "Done!"
                pcall(buttonFuncs[i])
                wait(0.8)
                btn.Text = buttonTexts[i]
            end)
        end

        -- Bottom credit (always pinned to bottom)
        local tabCredit = Instance.new("TextLabel")
        tabCredit.Text = "By: Gonzales Official"
        tabCredit.Font = Enum.Font.Gotham
        tabCredit.TextSize = 13
        tabCredit.TextColor3 = Color3.new(1,1,1)
        tabCredit.BackgroundTransparency = 1
        tabCredit.Size = UDim2.new(1, 0, 0, 15)
        tabCredit.Position = UDim2.new(0, 0, 1, -15)
        tabCredit.Parent = tab

        hub.Visible = false
        minimized.Visible = false
    else
        keyBox.Text = ""
        keyBox.PlaceholderText = "Wrong Key!"
    end
end)

makeDraggable(hub)
