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

local ActivationDistance = 50 --studds
local ViewportDistanceMultiplier = 3
local ViewportNeutralSpinSpeed = 0.5 --Degrees per frame

local PurchasableTarget = nil

m.PromptOpen = nil
local ViewportPart = nil
local PromptItemOwned = false
local ProcessingPurchase = false

local RX = 0
local RY = 0
local Click = false 
local OldMouseX = 0
local OldMouseY = 0

--Shortcutts--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local DataStore = Player:WaitForChild("DataStore")
local Event = ReplicatedStorage:WaitForChild("PurchaseEvent")

--Events--
local InventoryEvent = ReplicatedStorage:WaitForChild("InventoryEvent")
local InventoryFunction = ReplicatedStorage:WaitForChild("InventoryFunction")

--Gui--
local ScreenGui = script.Parent.Parent
local Frame = ScreenGui:WaitForChild("PurchasePrompt")
local Name = Frame:WaitForChild("Name")
local Price = Frame:WaitForChild("Price")
local RarityLabel = Frame:WaitForChild("Rarity")
local PurchaseButton = Frame:WaitForChild("Purchase")
local CloseButton = Frame:WaitForChild("Close")
local PreviewFrame = Frame:WaitForChild("ViewportFrame")
local ImageReplacementFrame = PreviewFrame:WaitForChild("ImageReplacement")
local WarningPrompt = ScreenGui:WaitForChild("WarningPrompt")

--Modules--
local PromptModule = require(script.PromptModule)
local ViewportModule = require(script.PromptModule.ViewportModule)
local ItemConfig = ReplicatedStorage:WaitForChild("ItemConfig")
ItemConfig = require(ItemConfig)

--ViewportCamera--
local ViewportCamera = Instance.new("Camera")
ViewportCamera.Parent = workspace



-------------
--Functions--
-------------

function m.LoadPrompt(TargetModule)
	local ItemName = require(TargetModule)
	local DS = nil
	local DescendantsDS = DataStore:GetDescendants()
	for i = 1, #DescendantsDS do
		if DescendantsDS[i].Name == ItemName then
			DS = DescendantsDS[i]
			break
		end
	end

	if DS then
		
		local Rarity = DS.Parent.Name
		local Class = DS.Parent.Parent.Name
		
		--Loading Viewport--
		
		local ReplicatedItem = InventoryFunction:InvokeServer("CloneItem", ItemName, ReplicatedStorage)
		if ReplicatedItem and ReplicatedItem.Handle then
			ViewportPart = ReplicatedItem.Handle --has to be before Load ViewportFrame
			ImageReplacementFrame.Image = ""
			ViewportModule.LoadViewportFrame(ViewportCamera, PreviewFrame, ReplicatedItem.Handle) --Only Accepts baseparts
		else
			ViewportModule.ClearViewportFrame(PreviewFrame)
			ImageReplacementFrame.Image = ItemConfig.ItemIcons[Class][ItemName]
			ViewportPart = nil
		end
		
		--Loading Text--
		Name.Text = ItemName
		RarityLabel.Text = Rarity
		RarityLabel.TextColor3 = ItemConfig.RarityColors[Rarity]
		Price.Text = tostring(ItemConfig.ItemPrices[Class][ItemName])

		--Checking ownership
		if DS.Value == true then
			PromptItemOwned = true
			PurchaseButton.Image = "http://www.roblox.com/asset/?id=4922941117"
			PurchaseButton.HoverImage = "http://www.roblox.com/asset/?id=4922941307"
		else
			PromptItemOwned = false
			PurchaseButton.Image = "http://www.roblox.com/asset/?id=4907408589"
			PurchaseButton.HoverImage = "http://www.roblox.com/asset/?id=4907433631"
		end
		
		m.PromptOpen = TargetModule
		return true
	else
		return nil
	end
	
end

------------
--Triggers--
------------
game:GetService("RunService").RenderStepped:Connect(function()
	if Mouse.Target then
		local PurchasableItemModule = Mouse.Target:FindFirstChild("PurchasableItem")
		local Distance = (Mouse.Target.Position - Camera.CFrame.Position).magnitude
		if PurchasableItemModule and PurchasableItemModule:IsA("ModuleScript") and Distance <= ActivationDistance then
			Mouse.Icon = "http://www.roblox.com/asset/?id=5111565293"
			PurchasableTarget = PurchasableItemModule
		else
			PurchasableTarget = nil
			Mouse.Icon = "" --Default
		end
	end
	
	if not Click then
		RY = RY - 1
	end
	if m.PromptOpen and ViewportPart then
		ViewportModule.RunViewportFrame(ViewportPart, ViewportCamera, ViewportDistanceMultiplier, RX, RY)
	end
end)

Mouse.Button1Down:Connect(function()
	Click = true
	if PurchasableTarget and not m.PromptOpen then
		if m.LoadPrompt(PurchasableTarget) then
			Frame.Visible = true
		end
	end
end)

Mouse.Button1Up:Connect(function()
	Click = false
end)

Mouse.Move:Connect(function()
	if m.PromptOpen and ViewportPart then
		if Click then
			local DifferenceX = OldMouseX - Mouse.X 
			local DifferenceY = OldMouseY - Mouse.Y 
			
			--Decimal--
			DifferenceX = DifferenceX/Camera.ViewportSize.X
			DifferenceY = DifferenceY/Camera.ViewportSize.Y
			
			--Degrees--
			local TurnDegreeX = DifferenceX*360
			local TurnDegreeY = DifferenceY*360
			
			RX = RX + TurnDegreeY
			RY = RY + TurnDegreeX
		end
	end
	
	OldMouseX = Mouse.X
	OldMouseY = Mouse.Y
end)

CloseButton.MouseButton1Down:Connect(function()
	Frame.Visible = false
	m.PromptOpen = nil
	ViewportPart = nil
end)

PurchaseButton.MouseButton1Down:Connect(function()
	if m.PromptOpen and not PromptItemOwned and not ProcessingPurchase then
		ProcessingPurchase = true
		local SuccessDS, ReturnMessage = table.unpack(Event:InvokeServer("PurchaseItem", m.PromptOpen)) 
		if SuccessDS then
			Frame.Visible = false
			ViewportPart = nil
			PromptModule.ItemReceivedPrompt(SuccessDS)
			m.PromptOpen = nil
		else
			PromptModule.PromptWarning(ReturnMessage)
			Frame.Visible = false
			m.PromptOpen = nil
			ViewportPart = nil
		end
		ProcessingPurchase = false
	end
end)

WarningPrompt.Close.MouseButton1Down:Connect(function()
	WarningPrompt.Visible = false
end)

-----------
--StartUp--
-----------

return m
