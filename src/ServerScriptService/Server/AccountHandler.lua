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

--Shortcutts--
local Event = ReplicatedStorage:WaitForChild("AccountEvent")


--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function m:ReloadCharacter(Player)
	local oldpos= Player.Character.PrimaryPart.CFrame
	Player:LoadCharacter()
	repeat
		wait()
	until Player.Character ~= nil
	Player.Character:SetPrimaryPartCFrame(oldpos)
	ReplicatedStorage.showcam:FireClient(Player)
	Player.Character.Humanoid.DisplayDistanceType= Enum.HumanoidDisplayDistanceType.None
	Player.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	
end



-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

Event.OnServerInvoke = function(...)
	local Tuples = {...}
	local Player = Tuples[1]
	local Key = Tuples[2]
	
	if Key == "ReloadCharacter" then
		return m:ReloadCharacter(Player)
	end
end



------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
return m
