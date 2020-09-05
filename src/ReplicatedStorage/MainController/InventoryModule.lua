local m = {}

           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

--------------------------------------------------------------------------------------------------
--Variables---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
repeat wait() until Player.Character
local Character = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

--Events--
local InventoryEvent = ReplicatedStorage:WaitForChild("InventoryEvent")
local InventoryFunction = ReplicatedStorage:WaitForChild("InventoryFunction")

--Gui--
local ScreenGui = script.Parent.Parent
local InventoryFrame = ScreenGui.Pages:WaitForChild("Inventory")
local InventorySlots = InventoryFrame.Slots:GetChildren()
local Details = InventoryFrame:WaitForChild("Details")
local Equip = Details:WaitForChild("Equip")
local PageSelects = InventoryFrame:WaitForChild("PageSelect")

--Modules--
local ItemConfig = ReplicatedStorage:WaitForChild("ItemConfig")
ItemConfig = require(ItemConfig)

--Audio--
local AudioFolder = ScreenGui:WaitForChild("Audio")
local ClickAudio = AudioFolder:WaitForChild("Click")
local EquipAudio = AudioFolder:WaitForChild("Equip")
local MagicoinAudio = AudioFolder:WaitForChild("Magicoin")
local ItemPurchaseAudio = AudioFolder:WaitForChild("ItemPurchase")
local QuestCompleteAudio = AudioFolder:WaitForChild("QuestComplete")

local Equipping = false
local OpenPage = ""
local OpenDetail = ""
local OpenColor = Color3.fromRGB(85, 255, 127)
local ClosedColor = Color3.fromRGB(170, 85, 255)

m.DefaultAccessories = {}

--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

------------------
--Slot functions--
------------------

function m.ResetSlots(Slots)
	for i = 1, #Slots do
		local Slot = Slots[i]
		local Rarity = Slot.Rarity
		local Equipped = Slot.Equipped
		
		Rarity.Visible = false
		Slot.Name = ""
		Slot.Image = ""
		Equipped.Visible = false
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

function m.SortSlots(Slots, ClassName)
	local DataStore = Player:WaitForChild("DataStore")
	local ClassFolder = DataStore:WaitForChild(ClassName)
	for i = 1, #ItemConfig.Rarities do
		local Rarity = ItemConfig.Rarities[i]
		local DSValues = ClassFolder:FindFirstChild(Rarity):GetChildren()
		for i = 1, #DSValues do
			local DS = DSValues[i]
			if DS.Value == true then
				local Slot = m.GetAvailableSlot(Slots)
				local RarityText = Slot.Rarity
				local RarityColor = RarityText.RarityColor
				local Image = ItemConfig.ItemIcons[ClassName][DS.Name]
				
				RarityText.Text = Rarity
				RarityText.Visible = true
				RarityColor.ImageColor3 = ItemConfig.RarityColors[Rarity]
				Slot.Image = Image
				Slot.Name = DS.Name
			end
		end
	end
end

function m.UppdateEquipped()
	local DataStore = Player:WaitForChild("DataStore")
	local EquippedFolder = DataStore:FindFirstChild("Equipped")
	local EquippedDS = EquippedFolder:FindFirstChild(OpenPage)
	local Slots = InventoryFrame.Slots:GetChildren()
	
	for i = 1, #Slots do
		local Slot = Slots[i]
		if Slot.Name == EquippedDS.Value and EquippedDS.Value ~= "" then
			Slot.Equipped.Visible = true
		else
			Slot.Equipped.Visible = false
		end
	end
end

------------------
--Page funcitons--
------------------,

function m.OpenPage(Name)
	local PrevPage = PageSelects:FindFirstChild(OpenPage)
	local NewPage = PageSelects:FindFirstChild(Name)
	if PrevPage then
		PrevPage.Color.ImageColor3 = ClosedColor
	end
	OpenPage = Name	
	NewPage.Color.ImageColor3 = OpenColor
	m.ResetSlots(InventorySlots)
	m.SortSlots(InventorySlots, Name)
	m.UppdateEquipped()
end

-------------------
--Detail function--
-------------------

function m.ResetDetail()
	local Children = Details:GetChildren()
	for i = 1, #Children do
		Children[i].Visible = false
	end
	OpenDetail = ""
end

function m.OpenDetail(Slot)
	local ItemImage = Details.ItemImage
	local RarityColor = Details.Rarity
	local ItemName = Details.ItemName
	local RarityName = Details.RarityName
	local Equipped = Slot.Equipped
	
	if Equipped.Visible == true then
		Equip.Text = "UnEquip"
	else
		Equip.Text = "Equip"
	end
	ItemName.Text = Slot.Name
	ItemImage.Image = Slot.Image
	RarityColor.ImageColor3 = Slot.Rarity.RarityColor.ImageColor3
	RarityName.Text = Slot.Rarity.Text
	RarityName.TextColor3 = Slot.Rarity.RarityColor.ImageColor3
		
	local Children = Details:GetChildren()
	for i = 1, #Children do
		Children[i].Visible = true
	end
		
	OpenDetail = Slot.Name
end

-------------
--Equipping--
-------------

function m.Equipping()
	local DataStore = Player:WaitForChild("DataStore")
	local EquippedFolder = DataStore:FindFirstChild("Equipped")
	local EquippedDS = EquippedFolder:FindFirstChild(OpenPage)
	local PrevEquippedSlot = InventoryFrame.Slots:FindFirstChild(EquippedDS.Value)
		
	if PrevEquippedSlot then
		PrevEquippedSlot.Equipped.Visible = false
	end
	InventoryEvent:FireServer("SetCrossboundaryValue", EquippedDS, OpenDetail)
	repeat wait() until EquippedDS.Value == OpenDetail	
	m.UppdateEquipped()
	m.OpenDetail(InventoryFrame.Slots:FindFirstChild(OpenDetail))
end

function m.UnEquipping()
	local DataStore = Player:WaitForChild("DataStore")
	local EquippedFolder = DataStore:FindFirstChild("Equipped")
	local EquippedDS = EquippedFolder:FindFirstChild(OpenPage)

	InventoryEvent:FireServer("SetCrossboundaryValue", EquippedDS, "")
	repeat wait() until EquippedDS.Value == ""	
	m.UppdateEquipped()
	m.OpenDetail(InventoryFrame.Slots:FindFirstChild(OpenDetail))
end

function m.EquipTool(ToolName)
	local PlayerOldTool = Player.Backpack:FindFirstChildOfClass("Tool")
	local CharOldTool = Character:FindFirstChildOfClass("Tool")
	
	local Tool = InventoryFunction:InvokeServer("CloneItem", ToolName, Player.Backpack)
	
	if CharOldTool then
		local Success = InventoryFunction:InvokeServer("DestroyItem", CharOldTool)
	elseif PlayerOldTool then
		local Success = InventoryFunction:InvokeServer("DestroyItem", PlayerOldTool)
	end
end

function m.UnEquipTool(ToolName)
	local ToolInBackpack = Player.Backpack:FindFirstChild(ToolName)
	local ToolInCharacter = Character:FindFirstChild(ToolName)
	
	if ToolInBackpack then
		local Success = InventoryFunction:InvokeServer("DestroyItem", ToolInBackpack)
	elseif ToolInCharacter then
		local Success = InventoryFunction:InvokeServer("DestroyItem", ToolInCharacter)
	end
end

function m.ReturnAttachmentToDefault(AttachmentName)
	local Accessories = Humanoid:GetAccessories()
	
	for i = 1, #Accessories do
		local Accessory = Accessories[i]

		local Handle = Accessory.Handle
		local Attachment = Handle:FindFirstChildOfClass("Attachment")
			
		if Attachment.Name == AttachmentName then
			if not m.DefaultAccessories[Attachment.Name] or not table.find(m.DefaultAccessories[Attachment.Name], Accessory) then
				local Success = InventoryFunction:InvokeServer("DestroyItem", Accessory)
			end			
		end
	end
	
	--returning attachmentname to default
	if m.DefaultAccessories[AttachmentName] then
		for i = 1, #m.DefaultAccessories[AttachmentName] do
			local DefaultAccessory = m.DefaultAccessories[AttachmentName][i]
			InventoryEvent:FireServer("ChangeTransparency", DefaultAccessory.Handle, 0)
			repeat wait() until DefaultAccessory.Handle.Transparency == 0
		end
	end
end

function m.ClearDefaultAccessoryOfType(AttachmentName)
	local AttachmentAccessories = m.DefaultAccessories[AttachmentName]
	
	if AttachmentAccessories then
		for i = 1, #AttachmentAccessories do
			local DefaultAccessory = AttachmentAccessories[i]
			local Handle = DefaultAccessory.Handle
			
			if Handle.Transparency == 0 then
				InventoryEvent:FireServer("ChangeTransparency", Handle, 1)
				repeat wait() until Handle.Transparency == 1
			end
		end
	end
end

function m.EquipAccessory(AccessoryName)
	local Accessory = InventoryFunction:InvokeServer("HumanoidAddAccessory", AccessoryName)
end

function m.DataStoreEquipping()
	local DataStore = Player:WaitForChild("DataStore")
	local EquippedFolder = DataStore:FindFirstChild("Equipped")
	local AccessoriesDS = EquippedFolder:FindFirstChild("Accessories")
	local ToolsDS = EquippedFolder:FindFirstChild("Tools")
	local EmblemDS = EquippedFolder:FindFirstChild("Emblem")
	
	if ToolsDS.Value ~= "" then
		m.EquipTool(ToolsDS.Value)
	end
	if AccessoriesDS.Value ~= "" then
		for i = 1, #ItemConfig.AccessoryAttachmentName[AccessoriesDS.Value] do
			m.ClearDefaultAccessoryOfType(ItemConfig.AccessoryAttachmentName[AccessoriesDS.Value][i])
		end
		m.EquipAccessory(AccessoriesDS.Value)
	end
end

function m.SaveDefaultAccessories()
	local Accessories = Humanoid:GetAccessories()
	for a = 1, #Accessories do
		pcall(function()
			local Accessory = Accessories[a]
			local Handle = Accessory:WaitForChild("Handle")
			for i = 1, 150 do
				local Attachment = Handle:FindFirstChildOfClass("Attachment")
				if Attachment then
					if m.DefaultAccessories[Attachment.Name] then
						table.insert(m.DefaultAccessories[Attachment.Name], Accessory)
					else
						m.DefaultAccessories[Attachment.Name] = {}
						table.insert(m.DefaultAccessories[Attachment.Name], Accessory)
					end
					break
				end
				wait()
			end
		end)
	end
	--[[
	for k,v in pairs(m.DefaultAccessories) do
		print("Default accessories with the attachment ".. k.. " Includes:")
		for i = 1, #v do
			print(tostring(v[i]))
		end
	end
	]]
end

-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

local PageSelectButtons = PageSelects:GetChildren()
for i = 1, #PageSelectButtons do
	local Button = PageSelectButtons[i]
	Button.MouseButton1Down:Connect(function()
		if OpenPage ~= Button.Name and not Equipping then
			m.OpenPage(Button.Name)
			m.ResetDetail()
		end
	end)
end

for i = 1, #InventorySlots do
	local Slot = InventorySlots[i]
	Slot.MouseButton1Down:Connect(function()
		if Slot.Name ~= "" and not Equipping then
			m.OpenDetail(Slot)
		end
	end)
end

Equip.MouseButton1Down:Connect(function()
	if OpenDetail ~= "" and not Equipping then
		local DataStore = Player:WaitForChild("DataStore")
		local EquippedFolder = DataStore:FindFirstChild("Equipped")
		local EquippedDS = EquippedFolder:FindFirstChild(OpenPage)
		
		Equipping = OpenDetail
		EquipAudio:Play()
		
		if Equip.Text == "Equip" then
			if OpenPage == "Tools" then
				m.Equipping()
				m.EquipTool(EquippedDS.Value)
			elseif OpenPage == "Accessories" then
				
				--ClearingPreviouse Attachments
				if EquippedDS.Value ~= "" then
					for i = 1, #ItemConfig.AccessoryAttachmentName[EquippedDS.Value] do
						m.ReturnAttachmentToDefault(ItemConfig.AccessoryAttachmentName[EquippedDS.Value][i])
					end
				end
				
				m.Equipping()
				
				--Clearing new attachments
				for i = 1, #ItemConfig.AccessoryAttachmentName[EquippedDS.Value] do
					m.ClearDefaultAccessoryOfType(ItemConfig.AccessoryAttachmentName[EquippedDS.Value][i])
				end
				m.EquipAccessory(EquippedDS.Value)
			else
				m.Equipping()
			end
		else
			if OpenPage == "Tools" then
				m.UnEquipTool(EquippedDS.Value)
			elseif OpenPage == "Accessories" then
				for i = 1, #ItemConfig.AccessoryAttachmentName[EquippedDS.Value] do
					m.ReturnAttachmentToDefault(ItemConfig.AccessoryAttachmentName[EquippedDS.Value][i])
				end
			end
			m.UnEquipping()
		end
		
		Equipping = nil
	end
end)

InventoryFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	if InventoryFrame.Visible == true then
		m.OpenPage(OpenPage)
	end
end)

------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
m.OpenPage("Accessories")
m.ResetDetail()
m.SaveDefaultAccessories()
m.DataStoreEquipping()

return m