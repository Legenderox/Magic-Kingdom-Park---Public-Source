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
m.ClosedPos = UDim2.new(-0.18, 0, 0.55, 0)
m.OpenPos = UDim2.new(0, 0, 0.55, 0)
m.OpenHoverImage = "http://www.roblox.com/asset/?id=4907422150"
m.ClosedHoverImage = "rbxassetid://4907421235"

local QuestCompletePopupSize = UDim2.new(3.105, 0,0.554, 0)
local UsedPopups = {
   --[Label] = true
}

--Shortcutts--
local Player = game.Players.LocalPlayer
repeat wait() until Player.Character
local Character = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestEvent = ReplicatedStorage:WaitForChild("QuestEvent")

--Gui--
local ScreenGui = script.Parent.Parent
local Frame = ScreenGui:WaitForChild("Quests")
local DailyQuests = Frame.ScrollingFrame:WaitForChild("Daily"):GetChildren()
local WeeklyQuests = Frame.ScrollingFrame:WaitForChild("Weekly"):GetChildren()
local ActivationButton = Frame:WaitForChild("QuestActivationButton")
local QuestCompletePopup = ActivationButton:WaitForChild("QuestComplete")

--Audio--
local AudioFolder = ScreenGui:WaitForChild("Audio")
local ClickAudio = AudioFolder:WaitForChild("Click")
local EquipAudio = AudioFolder:WaitForChild("Equip")
local MagicoinAudio = AudioFolder:WaitForChild("Magicoin")
local ItemPurchaseAudio = AudioFolder:WaitForChild("ItemPurchase")
local QuestCompleteAudio = AudioFolder:WaitForChild("QuestComplete")



-------------
--Functions--
-------------

function m.QuestCompleteEffect()
	QuestCompleteAudio:Play()
	QuestCompletePopup:TweenSize(QuestCompletePopupSize, Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 1.5)
	delay(1.5, function()
		QuestCompletePopup:TweenSize(UDim2.new(0,0,0,0), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 1.5)
		wait(1.5)
		QuestCompletePopup.Size = UDim2.new(0,0,0,0)
	end)
	
	for i = 1, 10 do
		QuestCompletePopup.TextColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
		wait(0.3)
	end
end

function m.CheckComplete(Label, NumCompleted, NumTotal)
	if NumCompleted == NumTotal then
		Label.Objective.Text = "Click to Claim!"
		
		if not UsedPopups[Label] then
			spawn(m.QuestCompleteEffect)
			UsedPopups[Label] = true
		end
		
		
		local Connection;
		Connection = Label.MouseButton1Down:Connect(function()
			Connection:Disconnect()
			QuestEvent:FireServer("QuestComplete", Label.Parent.Name, tonumber(Label.Name))
			Label.Objective.Text = "Complete!"
		end)
	end
end

function m.UppdateQuestLabels(Labels, CurrentQuests)
	for i = 1, #Labels do
		local Label = Labels[i]
		local Objective = Label:WaitForChild("Objective")
		local RewardAmount = Label:WaitForChild("RewardAmount")
		local Quest = CurrentQuests[Label.Parent.Name][i]
		
		if Quest then
			RewardAmount.Text = tostring(Quest["Reward"])
			Objective.Text = Quest["Description"]
		end
	end
	
	UsedPopups = {}
end

function m.UppdateProgress(Labels, CurrentQuests, PlayerProgress)
	for i = 1, #Labels do
		local Label = Labels[i]
		local Quest = CurrentQuests[Label.Parent.Name][i]
		
		if Quest then
			local NumTotal = #Quest["CheckList"]
			
			if PlayerProgress[Label.Parent.Name][i] then
				local NumCompleted = NumTotal - #PlayerProgress[Label.Parent.Name][i]	
				Label.Progress.Text = (tostring(NumCompleted).. "/".. tostring(NumTotal))
				m.CheckComplete(Label, NumCompleted, NumTotal, Quest)
			else
				Label.Progress.Text = (tostring(NumTotal).. "/".. tostring(NumTotal))
				Label.Objective.Text = "Complete!"
			end
		end
	end
	
	--[[ test stuff
	for k,v in pairs(PlayerProgress["Daily"]) do
		print("Quest number ".. k.. "'s checklist includes")
		for i = 1, #v do
			print(v[i])
		end
	end
	]]
end

function m.OnClientEvent(...)
	local Tuples = {...}
	local Key = Tuples[1]
	
	if Key == "UppdateDailyQuests" then
		m.UppdateQuestLabels(DailyQuests, Tuples[2])
	elseif Key == "UppdateWeeklyQuests" then
		m.UppdateQuestLabels(WeeklyQuests, Tuples[2])
	elseif Key == "UppdateProgress" then
		m.UppdateProgress(DailyQuests, Tuples[2], Tuples[3])
		m.UppdateProgress(WeeklyQuests, Tuples[2], Tuples[3])
	end
end

function m.ActivationClicked()
	if Frame.Position == m.ClosedPos then
		Frame:TweenPosition(m.OpenPos)
		ActivationButton.HoverImage = m.OpenHoverImage
	else
		Frame:TweenPosition(m.ClosedPos)
		ActivationButton.HoverImage = m.ClosedHoverImage
	end
end

------------
--Triggers--
------------
local QuestConenction = QuestEvent.OnClientEvent:Connect(m.OnClientEvent)

ActivationButton.MouseButton1Down:Connect(m.ActivationClicked)

Player.CharacterAdded:Connect(function()
	QuestConenction:Disconnect()
end)
-----------
--StartUp--
-----------

return m
