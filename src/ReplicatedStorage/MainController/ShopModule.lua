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
local OpenPage = ""
local OpenColor = Color3.fromRGB(85, 255, 127)
local ClosedColor = Color3.fromRGB(0, 150, 225)

--Shortcutts--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

--Gui--
local ScreenGui = script.Parent.Parent
local ShopFrame = ScreenGui.Pages:WaitForChild("Shop")
local ShopSlots = ShopFrame.Slots:GetChildren()
local PageSelects = ShopFrame:WaitForChild("PageSelect")

--Tables--
m.MarketPlaceIDs = {
	["Gamepasses"] = {9808936, 9808963, 9832002, 9840919},
	["Magicoins"] = {980951871, 994770067, 994769967, 995354408, 995354576},
}


-------------
--Functions--
-------------
function m.ResetSlots(Slots)
	for i = 1, #Slots do
		local Slot = Slots[i]
		Slot.Visible = false
		Slot.Name = ""
	end
end

function m.GetAvailableSlot(Slots)
	for i = 1, #Slots do
		local Slot = Slots[i]
		if Slot.Name == "" then
			return Slot
		end
	end
	return nil
end

function m.FillSlots(Slots, InfoType)
	local IDs = m.MarketPlaceIDs[OpenPage]
	for i = 1, #IDs do
		local success, errormessage = pcall(function()
			local ProductID = IDs[i]
			local ProductInfo = MarketplaceService:GetProductInfo(ProductID, InfoType)
			
			local Slot = m.GetAvailableSlot(Slots)
			local ItemName = Slot.ItemName
			local ItemImage = Slot.ItemImage

			
			ItemName.Text = ProductInfo.Name
			ItemImage.Image = ("rbxassetid://"..ProductInfo.IconImageAssetId)
			
			if OpenPage == "Gamepasses" and m.DoesPlayerHavePass(ProductID) then
				Slot.Text = "Owned"
				Slot.Name = "Owned"
			else
				if ProductInfo.PriceInRobux then
					Slot.Text = (ProductInfo.PriceInRobux.. " R$")
				else
					Slot.Text = "0 R$"
				end
				
				Slot.Name = ProductID
			end
			
			Slot.Visible = true
		end)
		
		if not success then
			warn("The gamepass ".. tostring(IDs[i]).. " failed to load into the shop, error code: ".. errormessage)
		end
	end
end

function m.DoesPlayerHavePass(gamePassID)
	local hasPass = false
 
	-- Check if the player already owns the game pass
	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, gamePassID)
	end)
 
	-- If there's an error, issue a warning and exit the function
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return nil
	end
 
	if hasPass == true then
		return true
	else
		return nil
	end
end

function m.OpenPage(Name)
	local PrevPage = PageSelects:FindFirstChild(OpenPage)
	local NewPage = PageSelects:FindFirstChild(Name)
	if PrevPage then
		PrevPage.Color.ImageColor3 = ClosedColor
	end
	OpenPage = Name	
	NewPage.Color.ImageColor3 = OpenColor
	
	if Name == "Gamepasses" then --Handling Gamepasses
		m.ResetSlots(ShopSlots)
		m.FillSlots(ShopSlots, Enum.InfoType.GamePass)
	else --Handling Developer products
		m.ResetSlots(ShopSlots)
		m.FillSlots(ShopSlots, Enum.InfoType.Product)
	end
end


function m:PromtPurchase(ID)
	if OpenPage == "Gamepasses" then
		MarketplaceService:PromptGamePassPurchase(Player, ID)
	else
		MarketplaceService:PromptProductPurchase(Player, ID)
	end
end

------------
--Triggers--
------------
local PageSelectButtons = PageSelects:GetChildren()
for i = 1, #PageSelectButtons do
	local Button = PageSelectButtons[i]
	Button.MouseButton1Down:Connect(function()
		if OpenPage ~= Button.Name then
			m.OpenPage(Button.Name)
		end
	end)
end

for i = 1, #ShopSlots do
	local Slot = ShopSlots[i]
	Slot.MouseButton1Down:Connect(function()
		if not (Slot.Name == "") and not (Slot.Name == "Owned") then
			m:PromtPurchase(Slot.Name)
		end
	end)
end

-----------
--StartUp--
-----------
m.OpenPage("Gamepasses")

return m
