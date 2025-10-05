-- PERFORMANCE HUB (Safe, client-side) 
-- Theme: Blue + Green
-- By: Gonzales Official
-- Place as a LocalScript in StarterPlayer -> StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ------------------------------------------------------------------
-- Config
local KEY_STRING = "555"
local DISCORD_LINK = "https://discord.gg/mnXcbBjNQ7"
local ANIM_TIME = 0.18
-- ------------------------------------------------------------------

-- Helper: safely pcall a function
local function safe(fn, ...)
    local ok, err = pcall(fn, ...)
    return ok, err
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerformanceHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Root (centered container)
local root = Instance.new("Frame")
root.Name = "Root"
root.Size = UDim2.new(0, 360, 0, 160)
root.Position = UDim2.new(0.5, -180, 0.5, -80)
root.BackgroundColor3 = Color3.fromRGB(18, 26, 40) -- dark blue base
root.BorderSizePixel = 0
root.AnchorPoint = Vector2.new(0,0)
root.Parent = screenGui

local rootCorner = Instance.new("UICorner", root)
rootCorner.CornerRadius = UDim.new(0, 10)

-- Top bar (title + - and X)
local topBar = Instance.new("Frame", root)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
topBar.BorderSizePixel = 0

local topCorner = Instance.new("UICorner", topBar)
topCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.02, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "PERFORMANCE HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(225, 238, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtext for hint (shows "Enter Key 555" before unlock)
local hint = Instance.new("TextLabel", topBar)
hint.Name = "Hint"
hint.Size = UDim2.new(0.28, -6, 1, 0)
hint.Position = UDim2.new(0.7, 6, 0, 0)
hint.BackgroundTransparency = 1
hint.Text = "Enter Key: 555"
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(160, 220, 180)
hint.TextXAlignment = Enum.TextXAlignment.Right

-- Minimize and Close buttons
local minBtn = Instance.new("TextButton", topBar)
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 28, 0, 22)
minBtn.Position = UDim2.new(1, -72, 0, 6)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
minBtn.TextColor3 = Color3.fromRGB(220, 230, 240)
minBtn.BorderSizePixel = 0

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(22, 110, 90) -- green-ish
closeBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
closeBtn.BorderSizePixel = 0

local topBarCorner = Instance.new("UICorner", minBtn)
topBarCorner.CornerRadius = UDim.new(0, 6)
local topBarCorner2 = Instance.new("UICorner", closeBtn)
topBarCorner2.CornerRadius = UDim.new(0, 6)

-- Content area (holds either key UI or main buttons)
local content = Instance.new("Frame", root)
content.Name = "Content"
content.Size = UDim2.new(1, -14, 1, -46)
content.Position = UDim2.new(0, 7, 0, 38)
content.BackgroundTransparency = 1

-- Key-entry area (left = textbox, right = get key)
local keyFrame = Instance.new("Frame", content)
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, 0, 0, 56)
keyFrame.Position = UDim2.new(0, 0, 0, 0)
keyFrame.BackgroundTransparency = 1

local leftBox = Instance.new("TextBox", keyFrame)
leftBox.Name = "KeyBox"
leftBox.Size = UDim2.new(0.62, -8, 0, 40)
leftBox.Position = UDim2.new(0, 4, 0, 8)
leftBox.PlaceholderText = "Enter Key"
leftBox.Text = ""
leftBox.Font = Enum.Font.Gotham
leftBox.TextSize = 16
leftBox.TextColor3 = Color3.fromRGB(240,240,240)
leftBox.BackgroundColor3 = Color3.fromRGB(15, 22, 36)
leftBox.BorderSizePixel = 0
leftBox.ClearTextOnFocus = false
local leftCorner = Instance.new("UICorner", leftBox)
leftCorner.CornerRadius = UDim.new(0, 8)

local getKeyBtn = Instance.new("TextButton", keyFrame)
getKeyBtn.Name = "GetKey"
getKeyBtn.Size = UDim2.new(0.34, -8, 0, 40)
getKeyBtn.Position = UDim2.new(0.66, 4, 0, 8)
getKeyBtn.Text = "Get Key"
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.TextSize = 14
getKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 52, 90) -- blue button
getKeyBtn.TextColor3 = Color3.fromRGB(200, 255, 200)
getKeyBtn.BorderSizePixel = 0
local getCorner = Instance.new("UICorner", getKeyBtn)
getCorner.CornerRadius = UDim.new(0, 8)

-- A small area to show copy/link info (initially hidden)
local linkNotice = Instance.new("TextLabel", keyFrame)
linkNotice.Name = "LinkNotice"
linkNotice.Size = UDim2.new(1, 0, 0, 18)
linkNotice.Position = UDim2.new(0, 0, 0, 50)
linkNotice.BackgroundTransparency = 1
linkNotice.Text = ""
linkNotice.Font = Enum.Font.Gotham
linkNotice.TextSize = 12
linkNotice.TextColor3 = Color3.fromRGB(200,220,200)
linkNotice.TextXAlignment = Enum.TextXAlignment.Left

-- Main buttons (hidden until unlocked)
local mainButtons = Instance.new("Frame", content)
mainButtons.Name = "MainButtons"
mainButtons.Size = UDim2.new(1, 0, 1, -64)
mainButtons.Position = UDim2.new(0, 0, 0, 56)
mainButtons.BackgroundTransparency = 1
mainButtons.Visible = false

local function makeMainButton(y, text)
    local b = Instance.new("TextButton", mainButtons)
    b.Size = UDim2.new(1, -10, 0, 36)
    b.Position = UDim2.new(0, 5, 0, (y-1) * 42)
    b.BackgroundColor3 = Color3.fromRGB(26, 44, 74)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(220, 245, 220)
    b.BorderSizePixel = 0
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    return b
end

local antiLagBtn = makeMainButton(1, "Anti-Lag (toggle)")
local boostFpsBtn = makeMainButton(2, "Boost FPS (toggle)")
local antiHeatBtn = makeMainButton(3, "Anti Overheat (toggle)")

-- Footer (By: Gonzales Official)
local footer = Instance.new("TextLabel", root)
footer.Name = "Footer"
footer.Size = UDim2.new(1, -12, 0, 18)
footer.Position = UDim2.new(0, 6, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "By: Gonzales Official"
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(190, 230, 200)
footer.TextXAlignment = Enum.TextXAlignment.Left

-- Thin top line used when minimized (initially hidden)
local topLine = Instance.new("Frame", screenGui)
topLine.Name = "TopMinLine"
topLine.Size = UDim2.new(1, 0, 0, 6)
topLine.Position = UDim2.new(0, 0, 0, 0)
topLine.BackgroundColor3 = Color3.fromRGB(20, 38, 70)
topLine.BorderSizePixel = 0
topLine.Visible = false
local topLineCorner = Instance.new("UICorner", topLine)
topLineCorner.CornerRadius = UDim.new(0, 4)

-- Small label on the line to indicate it's the minimized hub
local topLineLabel = Instance.new("TextLabel", topLine)
topLineLabel.Size = UDim2.new(0, 200, 1, 0)
topLineLabel.Position = UDim2.new(0.5, -100, 0, 0)
topLineLabel.BackgroundTransparency = 1
topLineLabel.Text = "PERFORMANCE HUB (click to restore)"
topLineLabel.Font = Enum.Font.Gotham
topLineLabel.TextColor3 = Color3.fromRGB(200, 235, 200)
topLineLabel.TextSize = 12

-- Make root draggable (custom dragging to ensure works on Roblox)
local dragging = false
local dragStart, startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = root.Position
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle functions: client-side only
local originals = {
    particles = {},
    decals = {},
    lighting = {
        GlobalShadows = Lighting.GlobalShadows,
        Brightness = Lighting.Brightness
    }
}

local function iterateWorkspace(fn)
    for _, o in ipairs(workspace:GetDescendants()) do
        pcall(function() fn(o) end)
    end
end

-- Anti-Lag
local antiLagOn = false
antiLagBtn.MouseButton1Click:Connect(function()
    antiLagOn = not antiLagOn
    if antiLagOn then
        iterateWorkspace(function(o)
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then
                if o.Enabled ~= nil then
                    originals.particles[o] = o.Enabled
                    pcall(function() o.Enabled = false end)
                end
            end
        end)
        antiLagBtn.Text = "Anti-Lag: ON"
    else
        for o, v in pairs(originals.particles) do
            pcall(function() if o then o.Enabled = v end end)
        end
        originals.particles = {}
        antiLagBtn.Text = "Anti-Lag (toggle)"
    end
end)

-- Boost FPS
local boostOn = false
boostFpsBtn.MouseButton1Click:Connect(function()
    boostOn = not boostOn
    if boostOn then
        iterateWorkspace(function(o)
            if o:IsA("Decal") or o:IsA("Texture") then
                originals.decals[o] = o.Transparency
                pcall(function() o.Transparency = 1 end)
            end
        end)
        originals.lighting.GlobalShadows = Lighting.GlobalShadows
        pcall(function() Lighting.GlobalShadows = false end)
        boostFpsBtn.Text = "Boost FPS: ON"
    else
        for o, v in pairs(originals.decals) do
            pcall(function() if o then o.Transparency = v end end)
        end
        originals.decals = {}
        pcall(function() Lighting.GlobalShadows = originals.lighting.GlobalShadows end)
        boostFpsBtn.Text = "Boost FPS (toggle)"
    end
end)

-- Anti Overheat
local heatOn = false
antiHeatBtn.MouseButton1Click:Connect(function()
    heatOn = not heatOn
    if heatOn then
        _G.PERFORMANCE_HUB_LOW_POWER = true
        originals.lighting.Brightness = Lighting.Brightness
        pcall(function() Lighting.Brightness = math.max(0, Lighting.Brightness - 1) end)
        antiHeatBtn.Text = "Anti Overheat: ON"
    else
        _G.PERFORMANCE_HUB_LOW_POWER = nil
        pcall(function() Lighting.Brightness = originals.lighting.Brightness end)
        antiHeatBtn.Text = "Anti Overheat (toggle)"
    end
end)

-- Unlock behavior
local unlocked = false
local function revealMain()
    unlocked = true
    -- hide key UI
    keyFrame.Visible = false
    -- show main buttons
    mainButtons.Visible = true
    -- hint update
    hint.Text = ""
    -- animate root to a smaller size (small tab)
    local targetSize = UDim2.new(0, 260, 0, 150)
    local tween = TweenService:Create(root, TweenInfo.new(ANIM_TIME, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
end

local function showInvalid()
    linkNotice.Text = "Invalid key — try again."
    delay(1.2, function()
        if linkNotice and linkNotice.Parent then
            linkNotice.Text = ""
        end
    end)
end

-- User pressed Enter in textbox or unlock click
local function tryUnlock()
    local txt = tostring(leftBox.Text or "")
    if txt == KEY_STRING then
        revealMain()
    else
        showInvalid()
    end
end

-- Enter key or unlock via pressing Return
leftBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        tryUnlock()
    end
end)

-- Unlock button
local unlockBtn = Instance.new("TextButton", keyFrame)
unlockBtn.Name = "UnlockBtn"
unlockBtn.Size = UDim2.new(0.12, -6, 0, 40)
unlockBtn.Position = UDim2.new(0.62, 4, 0, 8)
unlockBtn.Text = "OK"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextSize = 14
unlockBtn.BackgroundColor3 = Color3.fromRGB(24, 70, 50)
unlockBtn.TextColor3 = Color3.fromRGB(230, 250, 220)
unlockBtn.BorderSizePixel = 0
local unlockCorner = Instance.new("UICorner", unlockBtn)
unlockCorner.CornerRadius = UDim.new(0, 8)
unlockBtn.Visible = false

leftBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = tostring(leftBox.Text or "")
    if txt ~= "" then
        unlockBtn.Visible = true
    else
        unlockBtn.Visible = false
    end
end)

unlockBtn.MouseButton1Click:Connect(tryUnlock)

-- Get Key button opens small popup with link and copy option
getKeyBtn.MouseButton1Click:Connect(function()
    linkNotice.Text = "Discord: "..DISCORD_LINK.."  (Tap to copy)"
    linkNotice.TextXAlignment = Enum.TextXAlignment.Left
    safe(function() setclipboard(DISCORD_LINK) end)
end)

linkNotice.Active = true
linkNotice.MouseButton1Down:Connect(function()
    safe(function() setclipboard(DISCORD_LINK) end)
    linkNotice.Text = "Link copied to clipboard (if supported)."
    delay(1.5, function() if linkNotice.Parent then linkNotice.Text = "" end end)
end)

-- Minimize behavior: hide main content, show top line
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    if not unlocked then
        keyFrame.Visible = false
        topLine.Visible = true
        root.Visible = false
        minimized = true
        return
    end

    if not minimized then
        local t = TweenService:Create(root, TweenInfo.new(ANIM_TIME), {Position = UDim2.new(0.5, -130, 0, -200)})
        t:Play()
        t.Completed:Wait()
        root.Visible = false
        topLine.Visible = true
        minimized = true
    else
        root.Visible = true
        topLine.Visible = false
        minimized = false
    end
end)

topLine.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        root.Visible = true
        topLine.Visible = false
        minimized = false
    end
end)

-- Close behavior: destroy everything
closeBtn.MouseButton1Click:Connect(function()
    safe(function() screenGui:Destroy() end)
end)

-- For safety: show mainButtons only if unlocked
mainButtons.Visible = false
keyFrame.Visible = true

if RunService:IsClient() then
    print("[PERFORMANCE HUB] Loaded (client-only). Type the key or use the Get Key button.")
end
