----------------------
--Made by Legenderox--
----------------------


--Services--
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

--Shortcuts--
local Folder = ServerScriptService:WaitForChild("DataStore")

--default values table-
local DefaultValues = {
}

--Functions--
local function GetDS(Player)
	local Clone = Folder:Clone()
	local DS = DataStoreService:GetDataStore("MainParkDataStore2")
	local Data;
		
	local DataFetchSuccess, ErrorMessage = pcall(function()
		Data = DS:GetAsync(tostring(Player.UserId))
	end)
	
	if DataFetchSuccess then
		local CloneChildren = Clone:GetDescendants()
		for i = 1, #CloneChildren do
			local Value = CloneChildren[i]
			if Value.ClassName ~= "Folder" then
				if Data and Data[Value.Name] then
					Value.Value = Data[Value.Name]
				elseif DefaultValues[Value.Name] then
					print(Value.Name)
					Value.Value = DefaultValues[Value.Name]
				else
					if Value.ClassName == "NumberValue" then
						Value.Value = 0
					elseif Value.ClassName == "BoolValue" then
						Value.Value = false
					elseif Value.ClassName == "StringValue" then
						Value.Value = ""
					else
						Value.Value = nil
					end
				end
			end
		end
	end
	
	return Clone
end

local function SetDS(Player)
	local Data = {}
	local DataStore = DataStoreService:GetDataStore("MainParkDataStore2")
	local DataStoreFolder = Player:FindFirstChild("DataStore")
	if DataStoreFolder then
		local FolderChildren = DataStoreFolder:GetDescendants()
		for i = 1, #FolderChildren do
			local DS = FolderChildren[i]
			if DS.ClassName ~= "Folder" then
				Data[DS.Name] = DS.Value
			end
		end
	end
	
	local DataWriteSuccess, ErrorMessage = pcall(function()
		DataStore:SetAsync(tostring(Player.UserId),Data)
	end)
		
	if DataWriteSuccess then
		print(tostring(Player).. "'s DataStoreFolder data is DataStored")
	else
		local Retry = 0
		
		while Retry < 6 do
			wait(60)
			local Succeded, Error = pcall(function()
				DataStore:SetAsync(tostring(Player.UserId),Data)	
			end)
			if Succeded then 
				print(tostring(Player).. "'s DataStoreFolder data is DataStored")
				break 
			end
			Retry = Retry + 1
		end
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	--//Loading DataStores\\--
	local Clone = GetDS(Player)
	Clone.Parent = Player
	print(tostring(Player).. "'s DataStoreFolder has loaded")
end)

game.Players.PlayerRemoving:Connect(function(Player)
	SetDS(Player)
end)

game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end
	local Players = game.Players:GetPlayers()
	for _, Player in pairs(Players) do
		SetDS(Player)
	end
end)
