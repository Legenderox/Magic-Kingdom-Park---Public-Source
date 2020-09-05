local m = {}

           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

-------------
--Variables--
-------------

--ItemReceivedPrompt Variables--
local ItemReceivedPromptOpen = false
local ViewportPart = nil
local RX = 0
local RY = 0

local ViewportDistanceMultiplier = 2.5
local ViewportNeutralSpinSpeed = 0.5 --Degrees per frame
local LightRaySpinSpeed = 0.5
local ItemReceivedPromptTime = 4 -- seconds
local MaxBlur = 56

--Shortcutts--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryFunction = ReplicatedStorage:WaitForChild("InventoryFunction")

--Modules--
local ViewportModule = require(script.ViewportModule)
local ItemConfig = ReplicatedStorage:WaitForChild("ItemConfig")
ItemConfig = require(ItemConfig)

--ViewportCamera--
local ViewportCamera = Instance.new("Camera")
ViewportCamera.Parent = workspace

--gui--
local ScreenGui = script.Parent.Parent.Parent
local WarningPrompt = ScreenGui:WaitForChild("WarningPrompt")
local ItemReceivedPrompt = ScreenGui:WaitForChild("ItemReceivedPrompt")
local ViewportFrame = ItemReceivedPrompt:WaitForChild("ViewportFrame")
local LightRay1 = ItemReceivedPrompt:WaitForChild("LightRay1")
local LightRay2 = ItemReceivedPrompt:WaitForChild("LightRay2")
local NameLabel = ItemReceivedPrompt:WaitForChild("Name")
local RarityLabel = ItemReceivedPrompt:WaitForChild("Rarity")
local ImageReplacementFrame = ItemReceivedPrompt:WaitForChild("ImageReplacementFrame")

--Audio--
local AudioFolder = ScreenGui:WaitForChild("Audio")
local ClickAudio = AudioFolder:WaitForChild("Click")
local EquipAudio = AudioFolder:WaitForChild("Equip")
local MagicoinAudio = AudioFolder:WaitForChild("Magicoin")
local ItemPurchaseAudio = AudioFolder:WaitForChild("ItemPurchase")
local QuestCompleteAudio = AudioFolder:WaitForChild("QuestComplete")

--ViewportCamera--
local ViewportCamera = Instance.new("Camera")
ViewportCamera.Parent = workspace

--Blur--
local Blur = Instance.new("BlurEffect")
Blur.Parent = workspace.CurrentCamera
Blur.Size = 0

-------------
--Functions--
-------------

function m.PromptWarning(Message)
	WarningPrompt.Visible = false
	local MessageLabel = WarningPrompt.Message
	
	MessageLabel.Text = Message
	WarningPrompt.Visible = true
end

----------------------------------------------------------

function m.Flash(Frame)
	local FlashIncrease = 10 --Frames
	local FlashDecrease = 100 --Frames
	
	for i = 1, 0, -1/FlashIncrease do
		Frame.Transparency = i
		game:GetService("RunService").RenderStepped:Wait()
	end
	for i = 0, 1, 1/FlashDecrease do
		Frame.Transparency = i
		game:GetService("RunService").RenderStepped:Wait()
	end
end

function m.Blur()
	for i = 0, MaxBlur do
		Blur.Size = i
		game:GetService("RunService").RenderStepped:Wait()
	end
end

function m.DeBlur()
	for i = MaxBlur, 0, -1 do
		Blur.Size = i
		game:GetService("RunService").RenderStepped:Wait()
	end
end

function m.ItemReceivedPrompt(ItemDS)
	local Rarity = ItemDS.Parent.Name
	local ItemType = ItemDS.Parent.Parent.Name
	local ItemName = ItemDS.Name
	local ReplicatedItem = InventoryFunction:InvokeServer("CloneItem", ItemName, ReplicatedStorage)
	
	if ReplicatedItem and ReplicatedItem.Handle then
		ViewportPart = ReplicatedItem.Handle --has to be before Load ViewportFrame
		ImageReplacementFrame.Image = ""
		ViewportModule.LoadViewportFrame(ViewportCamera, ViewportFrame, ReplicatedItem.Handle) --Only Accepts baseparts
	else
		ViewportModule.ClearViewportFrame(ViewportFrame)
		ImageReplacementFrame.Image = ItemConfig.ItemIcons[ItemType][ItemName]
		ViewportPart = nil
	end
	
	NameLabel.Text = ItemName
	RarityLabel.Text = Rarity
	RarityLabel.TextColor3 = ItemConfig.RarityColors[Rarity]
	LightRay1.ImageColor3 = ItemConfig.RarityColors[Rarity]
	LightRay2.ImageColor3 = ItemConfig.RarityColors[Rarity]
	
	ItemReceivedPrompt.Visible = true
	ItemReceivedPromptOpen = true
	ItemPurchaseAudio:Play()
	
	spawn(m.Blur)
	m.Flash(ItemReceivedPrompt)
	
	delay(ItemReceivedPromptTime, function()
		ItemReceivedPrompt.Visible = false
		ItemReceivedPromptOpen = false
		m.DeBlur()
	end)
end

------------
--Triggers--
------------

game:GetService("RunService").RenderStepped:Connect(function()
	if ItemReceivedPromptOpen then
		LightRay1.Rotation = LightRay1.Rotation + LightRaySpinSpeed
		LightRay2.Rotation = LightRay2.Rotation - LightRaySpinSpeed
		RY = RY - 1
		
		if ViewportPart then
			ViewportModule.RunViewportFrame(ViewportPart, ViewportCamera, ViewportDistanceMultiplier, RX, RY)
		end
	end
end)

-----------
--StartUp--
-----------

return m