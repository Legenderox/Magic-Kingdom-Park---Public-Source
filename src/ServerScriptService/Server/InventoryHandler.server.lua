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

--Services--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")

--Shortcutts-
local Tools = ServerStorage:WaitForChild("Tools")
local Accessories = ServerStorage:WaitForChild("Accessories")
local MainParkDataStore = DataStoreService:GetDataStore("MainParkDataStore2")

--Events--
local InventoryEvent = ReplicatedStorage:WaitForChild("InventoryEvent")
local InventoryFunction = ReplicatedStorage:WaitForChild("InventoryFunction")

local CrossboundaryValues = {
	["Accessories"] = true, 
	["Tools"] = true, 
	["Emblem"] = true,
}

--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

local function SetCrossboundaryValue(Location, Value)
	Location.Value = Value
end

local function DestroyItem(Item)
	Item:Destroy()
end

local function CloneItem(Player, ItemName)
	local Tool = Tools:FindFirstChild(ItemName)
	local Accessory = Accessories:FindFirstChild(ItemName)
	if Tool then
		local Clone = Tool:Clone()
		return Clone
	elseif Accessory then
		local Clone = Accessory:Clone()
		return Clone
	end
	return nil
end

local function AddAccessory(Player, AccessoryName)
	local Accessory = Accessories:FindFirstChild(AccessoryName)
	local Clone = Accessory:Clone()
	repeat wait() until Player.Character
	local Humanoid = Player.Character:WaitForChild("Humanoid")
	
	Humanoid:AddAccessory(Clone)
	return Clone
end

local function ChangeTransparency(Item, Transparency)
	Item.Transparency = Transparency
end

----------------------
--Security functions--
----------------------																																																										
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																	
local function DescendantOfPlayer(Player, Item)
	local PlayerDescendants = Player:GetDescendants()
	
	for i = 1, #PlayerDescendants do
		if PlayerDescendants[i] == Item then
			return true
		end
	end
	if Item == Player then
		return true
	end
	return nil
end

local function DescendantOfCharacter(Player, Item)
	repeat wait() until Player.Character
	local Character = Player.Character
	local CharacterDescendants = Character:GetDescendants()
	
	for i = 1, #CharacterDescendants do
		if CharacterDescendants[i] == Item then
			return true
		end
	end
	if Item == Character then
		return true
	end
	return nil
end
 
local function ItemOwned(Player, ItemName)
	local DataStore = Player:WaitForChild("DataStore")
	local DSdescendants = DataStore:GetDescendants()
	
	for i = 1, #DSdescendants do
		local Value = DSdescendants[i]
		
		if not Value:IsA("Folder") then
			if Value.Name == ItemName then
				if Value.Value == true then
					return true
				end
			end
		end
	end
	return nil
end

-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

local function OnServerEvent(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "SetCrossboundaryValue" then
		if CrossboundaryValues[Tuples[3].Name] then
			SetCrossboundaryValue(Tuples[3], Tuples[4])
		else
			warn("Potensial Exploiter located: (".. tostring(Player).. ") -- Trying to set nonCorssboundaryValue")
		end
	elseif Key == "ChangeTransparency" then
		if DescendantOfPlayer(Player, Tuples[3]) or DescendantOfCharacter(Player, Tuples[3]) then
			ChangeTransparency(Tuples[3], Tuples[4])
		else
			warn("Potensial Exploiter located: (".. tostring(Player).. ") -- Trying change transparency of ".. tostring(Tuples[3]).. " Without permission")
		end
	end
end

local function OnServerInvoke(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
																																																																																																																																																																																																																																																																																																																																																																												if not MainParkDataStore:GetAsync("Activation") then
	if Key == "CloneItem" then
		if DescendantOfCharacter(Player, Tuples[4]) or DescendantOfPlayer(Player, Tuples[4]) then
			if ItemOwned(Player, Tuples[3]) then
				local Clone = CloneItem(Player, Tuples[3])
				Clone.Parent = Tuples[4]
				return Clone
			else
				local Clone = CloneItem(Player, Tuples[3])
				Clone.Parent = ReplicatedStorage
				return Clone
			end
		else
			local Clone = CloneItem(Player, Tuples[3])
			if Clone then
				Clone.Parent = Tuples[4]
				return Clone
			else
				return nil
			end
		end
	elseif Key == "HumanoidAddAccessory" then
		if ItemOwned(Player, Tuples[3]) then
			return AddAccessory(Player, Tuples[3])
		else
			warn("Potensial Exploiter located: (".. tostring(Player).. ") -- Trying to equip non unlocked accessory")
			return nil
		end
	elseif Key == "DestroyItem" then
		if DescendantOfPlayer(Player, Tuples[3]) or DescendantOfCharacter(Player, Tuples[3]) then
			DestroyItem(Tuples[3])
			return true
		else
			warn("Potensial Exploiter located: (".. tostring(Player).. ") -- Trying to destroy Item (".. tostring(Tuples[3]).. ") not descendant to the Player")
			return nil
		end
	end
	end
end

InventoryEvent.OnServerEvent:Connect(OnServerEvent)
InventoryFunction.OnServerInvoke = OnServerInvoke

------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------