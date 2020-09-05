local m = {}

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
local PathfindingService = game:GetService("PathfindingService")

--Shortcutts--
local QueSystemFolder = workspace.QueSystem
local StartPoint = QueSystemFolder.StartPoint
local EndPoint = QueSystemFolder.EndPoint
local HoldingArea = QueSystemFolder.HoldingArea

--Modules--
local Config = require(script.Parent.Config)

-- path object
local Path = PathfindingService:CreatePath(Config.PathParams)
Path:ComputeAsync(StartPoint.Position, EndPoint.Position)
if Path.Status == Enum.PathStatus.Success then
	Config.Waypoints = Path:GetWaypoints()
else
	warn("Something went wrong while computing path")
end

---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------

function m.VisualizeWaypoints(Waypoints, BColor, Shape)
	for _, waypoint in pairs(Waypoints) do
		local part = Instance.new("Part")
		part.Shape = Shape
		part.Transparency = 0
		part.Material = "Neon"
		part.Size = Vector3.new(0.6, 0.6, 0.6)
		part.Position = waypoint.Position
		part.Anchored = true
		part.CanCollide = false
		part.BrickColor = BColor
		part.Parent = game.Workspace
	end
end

function m.CalculateQuePositionWaypoints()
	Config.QuePositionWaypoints = {}
	table.insert(Config.QuePositionWaypoints, Config.Waypoints[#Config.Waypoints])
	for i = #Config.Waypoints - 1, 1, -1 do
		local Waypoint = Config.Waypoints[i]
		local PrevWaypoint = Config.QuePositionWaypoints[#Config.QuePositionWaypoints]
		
		if (Waypoint.Position - PrevWaypoint.Position).magnitude >= Config.PlayerDistance then
			table.insert(Config.QuePositionWaypoints, Waypoint)
		end
	end
	
	print("The que can fit ".. tostring(#Config.QuePositionWaypoints).. " Players")
end

function m.MovePlayerToQuePosition(Player, QuePosition, MoveId)
	local Character = Player.Character
	local Humanoid = Character:FindFirstChild("Humanoid")
	
	local TargetWaypointNum = table.find(Config.Waypoints, Config.QuePositionWaypoints[QuePosition])
	if not Config.CurrentWaypoint[Player] then
		Config.CurrentWaypoint[Player] = 1
	end
	
	for i = Config.CurrentWaypoint[Player], TargetWaypointNum do
		if Config.LatestMoveId == MoveId then
			local Waypoint = Config.Waypoints[i]
			Humanoid:MoveTo(Waypoint.Position)
			Config.CurrentWaypoint[Player] = i
			Humanoid.MoveToFinished:Wait()
		else
			break
		end
	end
	
end

function m.UppdateQuePositions()
	local MoveId = elapsedTime()
	Config.LatestMoveId = MoveId
	
	for i = 1, #Config.Que do
		local Player = Config.Que[i]
		spawn(function()
			m.MovePlayerToQuePosition(Player, i, MoveId)
		end)
	end
end





--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------









-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------
m.CalculateQuePositionWaypoints()
m.VisualizeWaypoints(Config.Waypoints, BrickColor.new("Institutional white"), "Ball")


return m