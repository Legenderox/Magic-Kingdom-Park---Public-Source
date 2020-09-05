

           --/\--
         --//  \\--
       --//	    \\-- 
     --//		  \\--
   --//				\\--
 --//Made by Legenderox\\--
--[[====================]]--

---------------------------------------------------------------------------------
--Variables----------------------------------------------------------------------
---------------------------------------------------------------------------------
local GroupID = 4064701 --Magic Kingdom Parks and Resorts

--Services--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Gui--
local OverheadGui = script.OverheadGui

--modules--
local ItemConfig = ReplicatedStorage:WaitForChild("ItemConfig")
ItemConfig = require(ItemConfig)

---------------------------------------------------------------------------------
--Functions----------------------------------------------------------------------
---------------------------------------------------------------------------------
function CloneGui(Player, EquippedEmblem)
	local Clone = OverheadGui:Clone()
	local Emblem = Clone:FindFirstChild("Emblem")
	local Name = Clone:FindFirstChild("Name")
	local Rank = Clone:FindFirstChild("Rank")
	
	pcall(function()
		Emblem.Image = ItemConfig.ItemIcons["Emblem"][EquippedEmblem.Value]
	end)
	Name.Text = Player.Name
	Rank.Text = Player:GetRoleInGroup(GroupID)
	
	Clone.Parent = Player.Character
end

function UppdateOverheadGui(Player, EquippedEmblem)
	local Clone = Player.Character:FindFirstChild("OverheadGui")
	if Clone then
		local Emblem = Clone:FindFirstChild("Emblem")
		local Name = Clone:FindFirstChild("Name")
		local Rank = Clone:FindFirstChild("Rank")
	
		Emblem.Image = ItemConfig.ItemIcons["Emblem"][EquippedEmblem.Value]
		Name.Text = Player.Name
		Rank.Text = Player:GetRoleInGroup(GroupID)
	end
end


--------------------------------------------------------------------------------
--Triggers----------------------------------------------------------------------
--------------------------------------------------------------------------------
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		local DataStore = Player:WaitForChild("DataStore")
		local EquippedEmblem = DataStore.Equipped:WaitForChild("Emblem")
	
		CloneGui(Player, EquippedEmblem)
		EquippedEmblem.Changed:Connect(function()
			UppdateOverheadGui(Player, EquippedEmblem)
		end)
	end)
	
end)



-------------------------------------------------------------------------------
--StartUp----------------------------------------------------------------------
-------------------------------------------------------------------------------

