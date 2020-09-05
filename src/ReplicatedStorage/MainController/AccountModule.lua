local m = {}

-------------
--Variables--
-------------
local TeleportService = game:GetService("TeleportService")
local staffroomposition = Vector3.new(-250.274, 12.711, -383.728)
local MinimumRank = 30

--Services--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Shortcutts--
local Event = ReplicatedStorage:WaitForChild("AccountEvent")
local Player = game.Players.LocalPlayer

--Gui--
local ScreenGui = script.Parent.Parent
local AccountPage = ScreenGui.Pages:WaitForChild("Account")
local TeleportButton = AccountPage.Default:WaitForChild("Teleport")
local UndressButton = AccountPage.Default:WaitForChild("Undress")

-------------
--Functions--
-------------

function m:TeleportToStaffRoom()
	if staffroomposition then
		game.Players.LocalPlayer.Character:MoveTo(staffroomposition)
	end
end

function m:CheckRank()
	local Rank;
	local Success = pcall(function()
		Rank = Player:GetRankInGroup(4064701)
	end)
	if Success then
		if (Rank >= MinimumRank) and game.PlaceId == 4983678402 then
			TeleportButton.Visible = true
			UndressButton.Visible = true
		else
			TeleportButton.Visible = false
			UndressButton.Visible = false
		end
	else
		TeleportService:Teleport(4983678402, Player)
	end
	

end




------------
--Triggers--
------------

TeleportButton.MouseButton1Down:Connect(function()
	if not Player.Character.castlecam.Value then
		m:TeleportToStaffRoom()
	end
end)

UndressButton.MouseButton1Down:Connect(function()
	if not Player.Character.castlecam.Value then
		Event:InvokeServer("ReloadCharacter")
	end
end)







-----------
--StartUp--
-----------
m:CheckRank()



return m
