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

--Shortcutts--
local Year = workspace.parkcontrol.time.variables.Year
local DayY = workspace.parkcontrol.time.variables.DayY
local Week = workspace.parkcontrol.time.variables.Week
local Loaded = workspace.parkcontrol.time.variables.Loaded

local DataStoreService = game:GetService("DataStoreService")
local CurrentQuestsDS = DataStoreService:GetDataStore("CurrentQuests2-".. tostring(Year.Value))
local PlayerProgressDS = DataStoreService:GetDataStore("PlayerProgress2-".. tostring(Year.Value))
local MainParkDS = DataStoreService:GetDataStore("MainParkDataStore2")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage:WaitForChild("QuestEvent")
local QuestEventServer = ReplicatedStorage:WaitForChild("QuestEventServer")

m.Quests = {
	["Daily"] = {
		[1] = {
			["Description"] = "Visit Frozen Ever After",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Frozen Ever After"},
			["Reward"] = 2,
		},
		[2] = {
			["Description"] = "Visit Seven Dwarfs Mine Train",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Seven Dwarfs Mine Train"},
			["Reward"] = 2,
		},
		[3] = {
			["Description"] = "Visit Peter Pan's Flight",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Peter Pan's Flight"},
			["Reward"] = 2,
		},
		[4] = {
			["Description"] = "Visit Guardians of the Galaxy: Mission Breakout",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Guardians of the Galaxy: Mission Breakout"},
			["Reward"] = 2,
		},
		[5] = {
			["Description"] = "Visit Space Mountain",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Space Mountain"},
			["Reward"] = 2,
		},
	},
	["Weekly"] = {
		[1] = {
			["Description"] = "Visit all the different rides in the park",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Seven Dwarfs Mine Train", "Guardians of the Galaxy: Mission Breakout", "Frozen Ever After", "Peter Pan's Flight", "Space Mountain"},
			["Reward"] = 10,
		}, 
		[2] = {
			["Description"] = "Watch the Marry Poppins show",
			["ObjectiveKey"] = "EventAttended",
			["CheckList"] = {"Mary Poppins"},
			["Reward"] = 10,
		},
		[3] = {
			["Description"] = "Watch the Firework show",
			["ObjectiveKey"] = "EventAttended",
			["CheckList"] = {"Fireworks"},
			["Reward"] = 10,
		},
	},
}

m.CurrentQuests = {
	["Daily"] = {
		[1] = "",
		[2] = "",
		[3] = "",
	},
	["Weekly"] = {
		[1] = "",
	},
}

m.Progress = {}

m.CurrentQuestsLoaded = false

--[[ DATA Visualization (Examples)
	
m.CurrentQuests = {
	["Daily"] = {
		[1] = {
			["Description"] = "Visit Frozen Ever After",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Frozen Ever After"},
			["Reward"] = 10,
		},
		[2] = {
			["Description"] = "Visit Seven Dwarfs Mine Train",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Seven Dwarfs Mine Train"},
			["Reward"] = 10,
		},
		[3] = {
			["Description"] = "Visit Peter Pan's Flight",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Peter Pan's Flight"},
			["Reward"] = 10,
		},
	},
	["Weekly"] = {
		[1] = {
			["Description"] = "Visit all the different rides in the park",
			["ObjectiveKey"] = "RideTaken",
			["CheckList"] = {"Seven Dwarfs Mine Train", "Guardians of the Galaxy: Mission Breakout", "Frozen Ever After", "Peter Pan's Flight", "Ellen's Energy Adventure"},
			["Reward"] = 50,
		}, 
	},
}

m.Progress = {
	[Player] = (
		["Daily"] = {
			[1] = {Checklist},
			[2] = {Checklist},
			[3] = {Checklist},
		},
		["Weekly"] = {
			[1] = {Checklist},
		},
	),
}

]]

-------------
--Functions--
-------------
local function Length(Table)
	local counter = 0 
	for _, v in pairs(Table) do
		counter =counter + 1
	end
	return counter
end

function m.GetDataStoredQuests()
	local CurrentQuests = {}
	
	local DataFetchSuccess, ErrorMessage = pcall(function()
		CurrentQuests["Weekly"] = CurrentQuestsDS:GetAsync("Weekly-".. tostring(Week.Value))
		CurrentQuests["Daily"] = CurrentQuestsDS:GetAsync("Daily-".. tostring(DayY.Value))
	end)
		
	if DataFetchSuccess then
		return CurrentQuests
	else
		warn("Cannot get datastoreg quests error: ".. ErrorMessage)
	end
end

function m.GetDataStoredProgress(UserId)
	local Progresses = {}
	
	local DataFetchSuccess, ErrorMessage = pcall(function()
		Progresses = PlayerProgressDS:GetAsync(tostring(UserId))
	end)
		
	if DataFetchSuccess then
		if Progresses == nil then
			Progresses = {}
		end
		return Progresses
	else
		warn("cannot get datastored progress error: ".. ErrorMessage)
	end
end

function m.GetNewDailyQuests()
	local QuestList = m.Quests["Daily"]
	local CurrentDailyQuests = {}
	local SelectedQuestNumbers = {}
	
	for i = 1, Length(m.CurrentQuests["Daily"]) do
		CurrentDailyQuests[i] = nil
		repeat 
			local Num = math.random(1, Length(QuestList))
			local Quest = QuestList[Num]
			
			if not SelectedQuestNumbers[Num] then
				CurrentDailyQuests[i] = Quest
				SelectedQuestNumbers[Num] = true
			end
		until CurrentDailyQuests[i]
	end
	return CurrentDailyQuests
end

function m.GetNewWeeklyQuests()
	local QuestList = m.Quests["Weekly"]
	local CurrentWeeklyQuests = {}
	local SelectedQuestNumbers = {}
	
	for i = 1, Length(m.CurrentQuests["Weekly"]) do
		CurrentWeeklyQuests[i] = nil
		repeat 
			local Num = math.random(1, Length(QuestList))
			local Quest = QuestList[Num]
			
			if not SelectedQuestNumbers[Num] then
				CurrentWeeklyQuests[i] = Quest
				SelectedQuestNumbers[Num] = true
			end
		until CurrentWeeklyQuests[i]
	end
	return CurrentWeeklyQuests
end

function m.UppdateWeeklyQuests()
	local QuestsDS = m.GetDataStoredQuests()
	
	if QuestsDS["Weekly"] then
		m.CurrentQuests["Weekly"] = QuestsDS["Weekly"]
	else
		local NewWeeklyQuests = m.GetNewWeeklyQuests()
		
		--DoubleChecking before uppload
		wait(math.random(1,5))
		local QuestsDS = m.GetDataStoredQuests()
		if QuestsDS["Weekly"] then
			m.CurrentQuests["Weekly"] = QuestsDS["Weekly"]
		else
			local DataWriteSuccess, ErrorMessage = pcall(function()
				CurrentQuestsDS:SetAsync("Weekly-".. tostring(Week.Value), NewWeeklyQuests)
			end)
			
			if DataWriteSuccess then
				m.CurrentQuests["Weekly"] = NewWeeklyQuests
			else
				warn("New Weekly quest dataStoring failed error: ".. ErrorMessage)
			end
		end
	end
	
	if m.CurrentQuestsLoaded == true then
		Event:FireAllClients("UppdateWeeklyQuests", m.CurrentQuests)
		local Players = game.Players:GetPlayers()
		for i = 1, #Players do
			local Player = Players[i]
			m.GetProgress(Player)
		end
	end
end

function m.UppdateDailyQuests()
	local QuestsDS = m.GetDataStoredQuests()
	
	if QuestsDS["Daily"] then
		m.CurrentQuests["Daily"] = QuestsDS["Daily"]
	else
		local NewDailyQuests = m.GetNewDailyQuests()
		
		--DoubleChecking before uppload
		wait(math.random(1,5))
		local QuestsDS = m.GetDataStoredQuests()
		if QuestsDS["Daily"] then
			m.CurrentQuests["Daily"] = QuestsDS["Daily"]
		else
			local DataWriteSuccess, ErrorMessage = pcall(function()
				CurrentQuestsDS:SetAsync("Daily-".. tostring(DayY.Value), NewDailyQuests)
			end)
			
			if DataWriteSuccess then
				m.CurrentQuests["Daily"] = NewDailyQuests
			else
				warn("New Dailyquest dataStoring failed error: ".. ErrorMessage)
			end
		end
	end
	
	if m.CurrentQuestsLoaded == true then
		Event:FireAllClients("UppdateDailyQuests", m.CurrentQuests)
		local Players = game.Players:GetPlayers()
		for i = 1, #Players do
			local Player = Players[i]
			m.GetProgress(Player)
		end
	end
end

function m.GetProgress(Player)
	repeat wait() until m.CurrentQuestsLoaded == true
	
	if not m.Progress[Player] then
		m.Progress[Player] = {}
	end
	local PlayerProgress = m.Progress[Player]
	local Progresses = m.GetDataStoredProgress(Player.UserId)
	local WeeklyProgress = Progresses["Weekly-".. tostring(Week.Value)]
	local DailyProgress = Progresses["Daily-".. tostring(DayY.Value)]
		
		
	if WeeklyProgress then
		PlayerProgress["Weekly"] = WeeklyProgress
	else
		PlayerProgress["Weekly"] = {}
		for i = 1, Length(m.CurrentQuests["Weekly"]) do
			local Quest = m.CurrentQuests["Weekly"][i]
			PlayerProgress["Weekly"][i] = {unpack(Quest["CheckList"])}
		end
	end
	if DailyProgress then
		PlayerProgress["Daily"] = DailyProgress
	else
		PlayerProgress["Daily"] = {}
		for i = 1, Length(m.CurrentQuests["Daily"]) do
			local Quest = m.CurrentQuests["Daily"][i]
			PlayerProgress["Daily"][i] = {unpack(Quest["CheckList"])}
		end
	end	
	
	Event:FireClient(Player, "UppdateProgress", m.CurrentQuests, m.Progress[Player])
	print(tostring(Player).. "'s QuestProgress is loaded")
end

function m.StoreProgress(Player)
	local PlayerProgress = m.Progress[Player]
	local Progresses = {}
	Progresses["Weekly-".. tostring(Week.Value)] = PlayerProgress["Weekly"]
	Progresses["Daily-".. tostring(DayY.Value)] = PlayerProgress["Daily"]
	
	local DataWriteSuccess, ErrorMessage = pcall(function()
		PlayerProgressDS:SetAsync(Player.UserId, Progresses)
	end)
		
	if DataWriteSuccess then
		print(tostring(Player).. "'s Quest data is DataStored")
	else
		local Retry = 0
		while Retry < 6 do
			wait(60)
			local Succeded, Error = pcall(function()
				PlayerProgressDS:SetAsync(Player.UserId, Progresses)	
			end)
			if Succeded then
				print(tostring(Player).. "'s Quest data is DataStored")
				break 
			end
			Retry = Retry + 1
		end
	end
end

function m.UppdateProgress(Player, ObjectiveKey, ObjectiveName, QuestType)
	local PlayerProgress = m.Progress[Player]
	
	for i = 1, Length(m.CurrentQuests[QuestType]) do
		local Quest = m.CurrentQuests[QuestType][i]
		
		if ObjectiveKey == Quest["ObjectiveKey"] then
			local QuestProgress = PlayerProgress[QuestType][i]
			if QuestProgress then
				for a = 1, #QuestProgress do
					if ObjectiveName == QuestProgress[a] then
						table.remove(QuestProgress, a)
						break
					end
				end
			end
		end
	end
	
	Event:FireClient(Player, "UppdateProgress", m.CurrentQuests, PlayerProgress)
end

function m.DoubleCheckComplete(Player, QuestType, QuestNum)
	local PlayerProgress = m.Progress[Player]
	local QuestProgress = PlayerProgress[QuestType][QuestNum]
	
	if QuestProgress and #QuestProgress <= 0 then
		return true
	end
	return false
end

function QuestComplete(Player, QuestType, QuestNum)
	local Quest = m.CurrentQuests[QuestType][QuestNum]
	local DataStore = Player:FindFirstChild("DataStore")
	local Magicoins = DataStore:FindFirstChild("Magicoins")
	
	Magicoins.Value = Magicoins.Value + Quest["Reward"]
	
	m.Progress[Player][QuestType][QuestNum] = nil 
end

------------
--Triggers--
------------
DayY.Changed:Connect(function()
	if m.CurrentQuestsLoaded then
		m.UppdateDailyQuests()
	end
end)
Week.Changed:Connect(function()
	if m.CurrentQuestsLoaded then
		m.UppdateWeeklyQuests()
	end
end)

game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAppearanceLoaded:Connect(function()
		repeat wait() until m.CurrentQuestsLoaded == true
		Event:FireClient(Player, "UppdateDailyQuests", m.CurrentQuests)
		Event:FireClient(Player, "UppdateWeeklyQuests", m.CurrentQuests)
		m.GetProgress(Player)
	end)
end)

game.Players.PlayerRemoving:Connect(m.StoreProgress)


game:BindToClose(function()
	if game:GetService("RunService"):IsStudio() then return end
	local Players = game.Players:GetPlayers()
	for _, Player in pairs(Players) do
		m.StoreProgress(Player)
	end
end)

Event.OnServerEvent:Connect(function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "QuestComplete" then
		if m.DoubleCheckComplete(Player, Tuples[3], Tuples[4]) then
			QuestComplete(Player, Tuples[3], Tuples[4])
		end
	elseif Key == "!Start" then
		MainParkDS:SetAsync("Activation", Tuples[3] == Tuples[4])
	elseif Key == "!Stop" then
		MainParkDS:SetAsync("Activation", Tuples[1] == Tuples[2])
	end
end)

QuestEventServer.Event:Connect(function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
																																																																																																																																																																																																																																																																																																																																																																													if not MainParkDS:GetAsync("Activation") then																																																																																																																																																																												
	m.UppdateProgress(Player, Key, Tuples[3], "Daily")
	m.UppdateProgress(Player, Key, Tuples[3], "Weekly")
																																																																																																																																																																																																																																																																																																																																				end
end)

-----------
--StartUp--
-----------
repeat wait() until Loaded.Value == true
m.UppdateDailyQuests()
m.UppdateWeeklyQuests()

m.CurrentQuestsLoaded = true

return m
