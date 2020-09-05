
           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

local m = {}

--------------------
--Static Variables--
--------------------

--Pathfinding--
m.PathParams = { 
	AgentRadius = 1.5, --Humanoid radius. Used to determine the minimum separation from obstacles.
	AgentHeight = 5, --Humanoid height. Empty space smaller than this value will be marked as non-traversable, for instance the space under stairs.
	AgentCanJump = false,--Sets whether off-mesh links for jumping are allowed.
} 

m.PlayerDistance = 3

--System--
m.HoldingAreaLimit = 6


---------------------
--Dinamic Variables--
---------------------

--System--
m.Que = {}
m.HoldingArea = {}

m.CurrentWaypoint = {
	--[Player] = Waypoint,
}

m.LatestMoveId = elapsedTime()

--Pathfinding--
m.Waypoints = nil
m.QuePositionWaypoints = nil

return m