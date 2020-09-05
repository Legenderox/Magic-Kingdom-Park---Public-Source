

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

--Events..
local QuestEventServer = ReplicatedStorage:WaitForChild("QuestEventServer")

--Collision Group--
local playerCollisionGroupName = "Players"
PhysicsService:CreateCollisionGroup(playerCollisionGroupName)
PhysicsService:CollisionGroupSetCollidable(playerCollisionGroupName, playerCollisionGroupName, false)



---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------

function SetCollisionGroup(Object)
	if Object:IsA("BasePart") then
    	PhysicsService:SetPartCollisionGroup(Object, playerCollisionGroupName)
 	end
end

function SetDescendantsCollisionGroup(Object)
	local Descendants = Object:GetDescendants()
	
	for i = 1, #Descendants do
		SetCollisionGroup(Descendants[i])
	end
	SetCollisionGroup(Object)
end




--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		SetDescendantsCollisionGroup(Character)
		
		Character.DescendantAdded:Connect(SetDescendantsCollisionGroup)
		
		--[[
		wait(10)
		print("RideTaken Seven Dwarfs Mine Train")
		QuestEventServer:Fire(Player, "RideTaken", "Seven Dwarfs Mine Train")
		wait(10)
		print("RideTaken Frozen Ever After")
		QuestEventServer:Fire(Player, "RideTaken", "Frozen Ever After")
		]]
	end)
end)






-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------

