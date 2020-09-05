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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Shortcutts--
local Player = game.Players.LocalPlayer
repeat wait() until Player.Character
local Humanoid = Player.Character:WaitForChild("Humanoid")
local QueEvent = ReplicatedStorage.QueEvent
local Exit = script.Parent.Exit

repeat wait() until Player.PlayerScripts.PlayerModule.ControlModule
local MasterControll = require(Player.PlayerScripts.PlayerModule.ControlModule)

---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------
local function QueEntered()
	Exit.Visible = true
	MasterControll:Disable()
end

local function QueExited()
	Exit.Visible = false
	MasterControll:Enable()
end

Humanoid.HealthChanged:Connect(function(Health)
	if not Health or Health <= 0 then
		QueEvent:FireServer("ExitQue")
	end
end)



--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------
QueEvent.OnClientEvent:Connect(function(...)
	local Tuples = {...}
	local Key = Tuples[1]
	
	if Key == "QueEntered" then
		QueEntered()
	elseif Key == "QueExited" then
		QueExited()
	end
end)

Exit.MouseButton1Down:Connect(function()
	QueEvent:FireServer("ExitQue")
end)

Player.CharacterAdded:Connect(function()
	local Humanoid = Player.Character:WaitForChild("Humanoid")
	Humanoid.HealthChanged:Connect(function(Health)
		if not Health or Health <= 0 then
			QueEvent:FireServer("ExitQue")
		end
	end)
	QueExited()
end)


-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------
