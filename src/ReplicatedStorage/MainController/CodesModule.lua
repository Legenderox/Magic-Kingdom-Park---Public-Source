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

local MessageDelay = 3 --seconds

--Shortcutts--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Event = ReplicatedStorage:WaitForChild("CodesEvent")

--Gui--
local ScreenGui = script.Parent.Parent
local CodesPage = ScreenGui.Pages:WaitForChild("Codes")
local CodeInput = CodesPage:WaitForChild("CodeInput")
local Enter = CodesPage:WaitForChild("Enter")
local MessageLabel = CodesPage:WaitForChild("Message")

--Modules--
local PromptModule = require(script.Parent.ItemPurchaseModule.PromptModule)

--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function m.PromptMessage(Message)
	MessageLabel.Text = Message
	MessageLabel.Visible = true
	delay(MessageDelay, function()
		if MessageLabel.Text == Message then
			MessageLabel.Visible = false
		end
	end)
end

function m.EnterCode(Code)
	local successDS, ReturnMessage = table.unpack(Event:InvokeServer("EnterCode", Code))
	
	if successDS then
		PromptModule.ItemReceivedPrompt(successDS)
		CodesPage.Visible = false
	else
		m.PromptMessage(ReturnMessage)
	end
end




-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Enter.MouseButton1Down:Connect(function()
	local Code = CodeInput.Text
	m.EnterCode(Code)
end)


------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

return m
