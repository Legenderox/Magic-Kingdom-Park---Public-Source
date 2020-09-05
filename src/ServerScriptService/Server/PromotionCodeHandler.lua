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

--Services--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

--Shortcutts--
local Event = ReplicatedStorage:WaitForChild("CodesEvent")
local UsedCodesDS = DataStoreService:GetDataStore("UsedCodes")

--UsedCodes--
m.UsedCodes = {}

--[[
m.UsedCodes = {
	[Player] = {"20Magicoins", "MagicHat"}
}
]]
--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

------------------
--Code functions--
------------------

function m.AddMagicoins(Player, Amount)
	local DataStore = Player:WaitForChild("DataStore")
	local Magicoins = DataStore:FindFirstChild("Magicoins")
	
	Magicoins.Value = Magicoins.Value + Amount
end

function m.UnlockItem(Player, ItemName)
	local DataStore = Player:WaitForChild("DataStore")
	local Descendants = DataStore:GetDescendants()
	
	for i = 1, #Descendants do
		local Descendant = Descendants[i]
		if Descendant.Name == ItemName and Descendant.ClassName == "BoolValue" then
			Descendant.Value = true
			return Descendant
		end
	end
end

---------
--Codes--
---------

m.Codes = {
	["arsengirlgaming"] = function(Player)
		return m.AddMagicoins(Player, 35)
	end,
	["RELEASE"] = function(Player)
		return m.AddMagicoins(Player, 25)
	end,
	["ilovehotdogs"] = function(Player)
		return m.AddMagicoins(Player, 200)
	end,
}

------------------------------------

function m.EnterCode(Player, Code)
	if m.Codes[Code] then
		if not table.find(m.UsedCodes[Player], Code) then
			local ReturnValue = m.Codes[Code](Player)
			table.insert(m.UsedCodes[Player], Code)
			
			if ReturnValue then
				return {ReturnValue, "The Code worked! Enjoy the Magic!"}
			else
				return {false, "The Code worked! Enjoy the Magic!"}
			end
		else
			return {false, "You have already used this code"}
		end
	else
		return {false, "Invalid code"}
	end
end

function m.GetUsedCodesFromDS(Player)
	local Data;
		
	local DataFetchSuccess, ErrorMessage = pcall(function()
		Data = UsedCodesDS:GetAsync(tostring(Player.UserId))
	end)
	
	if DataFetchSuccess then
		if Data then
			m.UsedCodes[Player] = Data
		else
			m.UsedCodes[Player] = {}
		end
		print(tostring(Player).. "'s UsedCodes are loaded from DataStore")
	end
end

function m.StoreUsedCodesToDS(Player)
	local DataWriteSuccess, ErrorMessage = pcall(function()
		UsedCodesDS:SetAsync(tostring(Player.UserId), m.UsedCodes[Player])
	end)
		
	if DataWriteSuccess then
		print(tostring(Player).. "'s UsedCodes is DataStored")
	else
		local Retry = 0
		
		while Retry < 6 do
			wait(60)
			local Succeded, Error = pcall(function()
				UsedCodesDS:SetAsync(tostring(Player.UserId), m.UsedCodes[Player])	
			end)
			if Succeded then
				print(tostring(Player).. "'s UsedCodes is DataStored")
				break 
			end
			Retry = Retry + 1
		end
	end
end

-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Event.OnServerInvoke = function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "EnterCode" then
		return m.EnterCode(Player, Tuples[3])
	end
end

game.Players.PlayerAdded:Connect(m.GetUsedCodesFromDS)

game.Players.PlayerRemoving:Connect(m.StoreUsedCodesToDS)

game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end
	local Players = game.Players:GetPlayers()
	for _, Player in pairs(Players) do
		m.StoreUsedCodesToDS(Player)
	end
end)


------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

return m
