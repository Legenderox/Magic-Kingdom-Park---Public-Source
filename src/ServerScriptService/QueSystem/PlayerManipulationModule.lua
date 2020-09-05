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

--Services--
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Shortcutts--
local QueEvent = ReplicatedStorage.QueEvent

--Collision Group--
local playerCollisionGroupName = "Players"
PhysicsService:CreateCollisionGroup(playerCollisionGroupName)
PhysicsService:CollisionGroupSetCollidable(playerCollisionGroupName, playerCollisionGroupName, false)



---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------

function m.SetCollisionGroup(Object)
	if Object:IsA("BasePart") then
    	PhysicsService:SetPartCollisionGroup(Object, playerCollisionGroupName)
 	end
end

function m.SetDescendantsCollisionGroup(Object)
	local Descendants = Object:GetDescendants()
	
	for i = 1, #Descendants do
		m.SetCollisionGroup(Descendants[i])
	end
	m.SetCollisionGroup(Object)
end




--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------







-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------

return m
