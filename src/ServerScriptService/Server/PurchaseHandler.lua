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

--Services--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Shortcutts--
local Event = ReplicatedStorage:WaitForChild("PurchaseEvent")

--modules--
local ItemConfig = ReplicatedStorage:WaitForChild("ItemConfig")
ItemConfig = require(ItemConfig)

-------------
--Functions--
-------------
function m.PurchaseItem(Player, ItemNameModule)
	local ItemName = require(ItemNameModule)
	local DataStore = Player:FindFirstChild("DataStore")
	local Magicoins = DataStore:FindFirstChild("Magicoins")
	
	local DS = nil
	local DescendantsDS = DataStore:GetDescendants()
	for i = 1, #DescendantsDS do
		if DescendantsDS[i].Name == ItemName then
			DS = DescendantsDS[i]
			break
		end
	end
	
	if DS then
		local Class = DS.Parent.Parent.Name
		local Price = ItemConfig.ItemPrices[Class][ItemName]
		
		if Magicoins.Value >= Price then
			Magicoins.Value = Magicoins.Value - Price
			DS.Value = true
			return {DS, "Transaction Approved"}
		else
			return {false, "Not enough funds"}
		end
	else
		warn(Player.. "'s Purchase did not find DS on server")
		return {false, "Ups... Something went wrong, try again later"}
	end
end

------------
--Triggers--
------------
Event.OnServerInvoke = function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "PurchaseItem" then
		return m.PurchaseItem(Player, Tuples[3])
	end
end




-----------
--StartUp--
-----------




return m
