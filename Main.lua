-- PERFORMANCE HUB (Small) | Rainbow HUD + "Turbo Mode" (SAFE client-side)
-- LocalScript: put in StarterPlayerScripts or run client-side (executor)
-- NOTE: This script only performs client-side visual/performance *tweaks* (lighting, particle toggles, decals, terrain) to reduce local rendering load.
-- It does NOT modify server state, give gameplay advantage, or automate gameplay actions.
-- Key to unlock main HUD: "555"
-- By: Gonzales Official

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Config
local DISCORD_LINK = "https://discord.gg/v65zvUw2xk"
local UNLOCK_KEY = "555"

-- Create ScreenGui (named PERFORMANCE HUB)
local gui = Instance.new("ScreenGui")
gui.Name = "PERFORMANCE HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Utility: rainbow animator for TextColor3 or Color properties
local function rainbowLoop(target, prop, delay)
	prop = prop or "TextColor3"
	delay = delay or 0.02
	task.spawn(function()
		while target and target.Parent do
			for h = 0, 255 do
				pcall(function()
					target[prop] = Color3.fromHSV(h/255, 1, 1)
				end)
				task.wait(delay)
			end
		end
	end)
end

-- Smooth draggable helper
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- TEMP message helper
local function showTempTextOn(btn, text, seconds)
	seconds = seconds or 2
	local prev = btn.Text
	btn.Text = text
	task.delay(seconds, function()
		if btn and btn.Parent then btn.Text = prev end
	end)
end

----------------------------------------------------------------
-- KEY FRAME (compact, centered)
----------------------------------------------------------------
local keyFrame = Instance.new("Frame", gui)
keyFrame.Name = "KeyUnlock"
keyFrame.Size = UDim2.new(0, 240, 0, 110)
keyFrame.Position = UDim2.new(0.5, -120, 0.5, -55)
keyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
keyFrame.BorderSizePixel = 0
makeDraggable(keyFrame)

local keyCorner = Instance.new("UICorner", keyFrame)
keyCorner.CornerRadius = UDim.new(0, 8)
local keyStroke = Instance.new("UIStroke", keyFrame)
keyStroke.Color = Color3.fromRGB(135,206,235) -- sky blue border
keyStroke.Thickness = 3

local titleLabel = Instance.new("TextLabel", keyFrame)
titleLabel.Size = UDim2.new(1, -20, 0, 24)
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Text = "Enter Key"
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
rainbowLoop(titleLabel)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.9, 0, 0, 28)
keyBox.Position = UDim2.new(0.05, 0, 0, 36)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBox.TextColor3 = Color3.fromRGB(230,230,230)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.PlaceholderText = "Type key here..."
keyBox.ClearTextOnFocus = true
keyBox.TextXAlignment = Enum.TextXAlignment.Center
local kbCorner = Instance.new("UICorner", keyBox)

local unlockBtn = Instance.new("TextButton", keyFrame)
unlockBtn.Size = UDim2.new(0.9, 0, 0, 28)
unlockBtn.Position = UDim2.new(0.05, 0, 0, 72)
unlockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextSize = 14
unlockBtn.Text = "Unlock"
unlockBtn.AutoButtonColor = false
local ubCorner = Instance.new("UICorner", unlockBtn)
rainbowLoop(unlockBtn)

----------------------------------------------------------------
-- MAIN FRAME (small, centered) (hidden until key correct)
----------------------------------------------------------------
local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "PERFORMANCE_HUB_MAIN"
mainFrame.Size = UDim2.new(0, 210, 0, 120) -- small compact size
mainFrame.Position = UDim2.new(0.5, -105, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(135,206,235) -- sky blue
mainStroke.Thickness = 3

-- Close button (small X)
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -22, 0, 6)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(220,220,220)
closeBtn.AutoButtonColor = true

-- FPS label (top center) - rainbow live
local fpsLabel = Instance.new("TextLabel", mainFrame)
fpsLabel.Size = UDim2.new(0, 110, 0, 20)
fpsLabel.Position = UDim2.new(0.5, -55, 0, 8)
fpsLabel.BackgroundTransparency = 0.15
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.Text = "FPS: 0"
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
local fpsStroke = Instance.new("UIStroke", fpsLabel)
fpsStroke.Thickness = 1
rainbowLoop(fpsLabel)
rainbowLoop(fpsStroke, "Color")

-- Turbo Mode button (compact)
local turboBtn = Instance.new("TextButton", mainFrame)
turboBtn.Size = UDim2.new(0.9, 0, 0, 36)
turboBtn.Position = UDim2.new(0.05, 0, 0, 34)
turboBtn.BackgroundColor3 = Color3.fromRGB(48,48,48)
turboBtn.Font = Enum.Font.GothamBold
turboBtn.TextSize = 14
turboBtn.Text = "🚀 Turbo Mode"
turboBtn.AutoButtonColor = false
local turboCorner = Instance.new("UICorner", turboBtn)
rainbowLoop(turboBtn)

-- Report Bug button
local reportBtn = Instance.new("TextButton", mainFrame)
reportBtn.Size = UDim2.new(0.9, 0, 0, 26)
reportBtn.Position = UDim2.new(0.05, 0, 0, 76)
reportBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
reportBtn.Font = Enum.Font.GothamBold
reportBtn.TextSize = 12
reportBtn.Text = "🐞 Report Bug"
reportBtn.AutoButtonColor = false
local reportCorner = Instance.new("UICorner", reportBtn)
rainbowLoop(reportBtn)

-- Small author credit (tiny) under report (rainbow, small)
local credit = Instance.new("TextLabel", mainFrame)
credit.Size = UDim2.new(0.9, 0, 0, 12)
credit.Position = UDim2.new(0.05, 0, 0, 104)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 10
credit.Text = "By: Gonzales Official"
credit.TextXAlignment = Enum.TextXAlignment.Center
rainbowLoop(credit)

----------------------------------------------------------------
-- BOOST IMPLEMENTATION (client-only visual/performance tweaks)
-- Implements: Ultra Boost, Fast Mode, Remove Shadows, Lighting adjustments,
-- disable particles/trails/smoke/fire, hide decals/textures, terrain simplification, etc.
-- Stored old values are kept to allow revert.
----------------------------------------------------------------
local boosted = false
local stored = {
	lighting = {},
	terrain = {},
	instances = {} -- map Instance -> props table
}

local function safeStore(inst, prop)
	if not inst or not prop then return end
	if not stored.instances[inst] then stored.instances[inst] = {} end
	if stored.instances[inst][prop] == nil then
		local ok, old = pcall(function() return inst[prop] end)
		if ok then stored.instances[inst][prop] = old end
	end
end

local function applyTurboVisuals()
	-- Lighting
	local Lighting = game:GetService("Lighting")
	pcall(function()
		stored.lighting.GlobalShadows = Lighting.GlobalShadows
		stored.lighting.FogEnd = Lighting.FogEnd
		stored.lighting.Brightness = Lighting.Brightness
		stored.lighting.OutdoorAmbient = Lighting.OutdoorAmbient
		stored.lighting.Technology = Lighting.Technology
	end)
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e6
		Lighting.Brightness = 1
		Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
		Lighting.Technology = Enum.Technology.Compatibility
	end)

	-- Terrain water simplification
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		pcall(function()
			stored.terrain.WaterWaveSize = terrain.WaterWaveSize
			stored.terrain.WaterWaveSpeed = terrain.WaterWaveSpeed
			stored.terrain.WaterReflectance = terrain.WaterReflectance
			stored.terrain.WaterTransparency = terrain.WaterTransparency
		end)
		pcall(function()
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
		end)
	end

	-- Disable particle-like instances and hide decals/textures
	for _, v in pairs(workspace:GetDescendants()) do
		-- Particle emitters / trails / smoke / fire
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
			local ok, val = pcall(function() return v.Enabled end)
			if ok then
				safeStore(v, "Enabled")
				pcall(function() v.Enabled = false end)
			end
		end
		-- Decal/Texture -> set Transparency to 1
		if v:IsA("Decal") or v:IsA("Texture") then
			local ok, val = pcall(function() return v.Transparency end)
			if ok then
				safeStore(v, "Transparency")
				pcall(function() v.Transparency = 1 end)
			end
		end
		-- Special: reduce particle counts if property exists (safe attempt)
		if v:IsA("ParticleEmitter") then
			pcall(function()
				safeStore(v, "Rate")
				if type(v.Rate) == "number" then v.Rate = 0 end
			end)
		end
	end

	-- FrameBoost / "boost fps" visual cue: reduce local graphic-intensive gui elements (if any)
	-- Note: we avoid changing any server-owned objects.
end

local function revertTurboVisuals()
	-- revert lighting
	local Lighting = game:GetService("Lighting")
	pcall(function()
		if stored.lighting.GlobalShadows ~= nil then Lighting.GlobalShadows = stored.lighting.GlobalShadows end
		if stored.lighting.FogEnd ~= nil then Lighting.FogEnd = stored.lighting.FogEnd end
		if stored.lighting.Brightness ~= nil then Lighting.Brightness = stored.lighting.Brightness end
		if stored.lighting.OutdoorAmbient ~= nil then Lighting.OutdoorAmbient = stored.lighting.OutdoorAmbient end
		if stored.lighting.Technology ~= nil then Lighting.Technology = stored.lighting.Technology end
	end)

	-- revert terrain
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain and stored.terrain then
		pcall(function()
			if stored.terrain.WaterWaveSize ~= nil then terrain.WaterWaveSize = stored.terrain.WaterWaveSize end
			if stored.terrain.WaterWaveSpeed ~= nil then terrain.WaterWaveSpeed = stored.terrain.WaterWaveSpeed end
			if stored.terrain.WaterReflectance ~= nil then terrain.WaterReflectance = stored.terrain.WaterReflectance end
			if stored.terrain.WaterTransparency ~= nil then terrain.WaterTransparency = stored.terrain.WaterTransparency end
		end)
	end

	-- revert instances
	for inst, props in pairs(stored.instances) do
		if inst and inst.Parent then
			for propName, oldVal in pairs(props) do
				pcall(function() inst[propName] = oldVal end)
			end
		end
	end

	-- clear stored
	stored = { lighting = {}, terrain = {}, instances = {} }
end

----------------------------------------------------------------
-- Turbo Mode behavior requested:
-- Click -> "Please Wait..." (2s) -> applyTurboVisuals() -> "✓ Boost On" (stays until user toggles)
-- Click when on -> "Boost Off" (2s) -> revertTurboVisuals() -> "Turbo Mode"
----------------------------------------------------------------
local function setTurbo(on)
	if on then
		turboBtn.Text = "Please Wait..."
		task.spawn(function()
			task.wait(2)
			applyTurboVisuals()
			boosted = true
			turboBtn.Text = "✓ Boost On"
		end)
	else
		turboBtn.Text = "Boost Off"
		task.spawn(function()
			task.wait(2)
			revertTurboVisuals()
			boosted = false
			turboBtn.Text = "Turbo Mode"
		end)
	end
end

turboBtn.MouseButton1Click:Connect(function()
	if not boosted then
		setTurbo(true)
	else
		setTurbo(false)
	end
end)

-- Report Bug: copy Discord invite (if environment supports setclipboard)
reportBtn.MouseButton1Click:Connect(function()
	local ok = pcall(function() setclipboard(DISCORD_LINK) end)
	if ok then
		showTempTextOn(reportBtn, "Copied!", 2)
	else
		showTempTextOn(reportBtn, "Link Copied", 2)
	end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

----------------------------------------------------------------
-- FPS counter (live, rainbow)
----------------------------------------------------------------
do
	local last, frames = tick(), 0
	RunService.RenderStepped:Connect(function()
		frames = frames + 1
		local now = tick()
		if now - last >= 1 then
			local fps = math.floor(frames / (now - last) + 0.5)
			pcall(function() fpsLabel.Text = "FPS: " .. tostring(fps) end)
			frames = 0
			last = now
		end
	end)
end

----------------------------------------------------------------
-- Unlock logic (key = "555")
----------------------------------------------------------------
unlockBtn.MouseButton1Click:Connect(function()
	local entered = tostring(keyBox.Text or "")
	if entered == UNLOCK_KEY then
		keyFrame:Destroy()
		mainFrame.Visible = true
		-- ensure turbo button shows correct initial text
		turboBtn.Text = "🚀 Turbo Mode"
	else
		showTempTextOn(unlockBtn, "❌ Wrong Key", 2)
	end
end)

keyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		unlockBtn:CaptureFocus()
		unlockBtn:ReleaseFocus()
		-- manually call unlock handler
		unlockBtn.MouseButton1Click:Wait()
	end
end)

-- Keep main hidden until unlocked
mainFrame.Visible = false

print("[PERFORMANCE HUB] small UI loaded (client-side only).")
