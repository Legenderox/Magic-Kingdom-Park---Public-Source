           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

-------------------------------------------------------------------------------
--Variables--------------------------------------------------------------------
-------------------------------------------------------------------------------

--Modules--
local PlayerManipulationModule = require(script.PlayerManipulationModule)
local Config = require(script.Config)
local PathfindingModule = require(script.PathfindingModule)

--Shortcutts--
local QueSystemFolder = workspace.QueSystem
local StartPoint = QueSystemFolder.StartPoint
local EndPoint = QueSystemFolder.EndPoint
local HoldingArea = QueSystemFolder.HoldingArea
local SpawnArea = QueSystemFolder.SpawnArea

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QueEvent = ReplicatedStorage.QueEvent

local GateStatus = workspace.StationGates.IsOpen --THIS NEEDS TO BE CHANGED ON REPLICATION!

---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------

local function TouchingPlayer(Part)
	local Character = Part.Parent
	local Player = game.Players:GetPlayerFromCharacter(Character)
	if Player then
		return Player
	end
	return nil
end

local function AddPlayerToQue(Player)
	table.insert(Config.Que, Player)
	Player.Character.PrimaryPart:SetNetworkOwner(nil)
	PathfindingModule.UppdateQuePositions()
	
	QueEvent:FireClient(Player, "QueEntered")
end

local function ExitQue(Player)
	local QueNum = table.find(Config.Que, Player)
	if QueNum then
		table.remove(Config.Que, QueNum)
		Player.Character.PrimaryPart:SetNetworkOwner(Player)
		PathfindingModule.UppdateQuePositions()
		Config.CurrentWaypoint[Player] = nil
		QueEvent:FireClient(Player, "QueExited")
	end
end

local function ClearHoldingArea()
	for i = 1, #Config.HoldingArea do
		local Player = Config.HoldingArea[i]
		local Humanoid = Player.Character.Humanoid
		if not Humanoid.Sit then
			Player.Character:SetPrimaryPartCFrame(SpawnArea.CFrame + Vector3.new(0,Player.Character.PrimaryPart.Size.Y,0))
		end
	end
	Config.HoldingArea = {}
end

local function GetPlayersInFront()
	local PlayersInFront = {}
	for i = 1, Config.HoldingAreaLimit do
		local Player = Config.Que[i]
		if Player then
			table.insert(PlayersInFront, Player)
		else
			break
		end
	end
	return PlayersInFront
end

local function NewRound()	
	local PlayersInFront = GetPlayersInFront()
	for i = 1, #PlayersInFront do
		local Player = PlayersInFront[i]
		ExitQue(Player)
		Player.Character:SetPrimaryPartCFrame(HoldingArea.CFrame + Vector3.new(0,Player.Character.PrimaryPart.Size.Y,0))
		table.insert(Config.HoldingArea, Player)
	end
end



--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		PlayerManipulationModule.SetDescendantsCollisionGroup(Character)
		
		Character.DescendantAdded:Connect(PlayerManipulationModule.SetDescendantsCollisionGroup)
	end)
end)

StartPoint.Touched:Connect(function(Part)
	local Player = TouchingPlayer(Part)
	local Humanoid = Player.Character:FindFirstChild("Humanoid")
	if Player and Humanoid and Humanoid.Health > 0 and not table.find(Config.Que, Player) then 
		AddPlayerToQue(Player)
	end
end)

QueEvent.OnServerEvent:Connect(function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "ExitQue" then
		ExitQue(Player)
		Player.Character:SetPrimaryPartCFrame(SpawnArea.CFrame + Vector3.new(0,Player.Character.PrimaryPart.Size.Y,0))
	end
end)

GateStatus.Changed:Connect(function()
	if GateStatus.Value == true then
		NewRound()
	else
		ClearHoldingArea()
	end
end)

-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------