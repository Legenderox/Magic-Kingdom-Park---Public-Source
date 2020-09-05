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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

--Gui--
local ScreenGui = script.Parent.Parent
local Map = ScreenGui:WaitForChild("Pages"):WaitForChild("Map")

local Pages = Map:WaitForChild("Pages")
local Details = Map:WaitForChild("Details")

local BackButton = Map:WaitForChild("Menu") --Called menu to open correct pagen when clicked

-------------
--Functions--
-------------
function m.OpenPageFromList(PageName, List)
	for i = 1, #List do
		local Page = List[i]
		if Page.Name == PageName then
			Page.Visible = true
		else
			Page.Visible = false
		end
	end
end

function m.PageSelect(Buttons, PageList)
	--Page opening--
	for i = 1, #Buttons do
		local Button = Buttons[i]
		if Button:IsA("GuiButton") then
			Button.MouseButton1Down:Connect(function()
				m.OpenPageFromList(Button.Name, PageList)
			end)
		end
	end
end

------------
--Triggers--
------------
local ButtonsThatOpenPages = Pages:GetDescendants()
m.PageSelect(ButtonsThatOpenPages, Pages:GetChildren())

--[[
local ButtonsThatOpenDetails = Pages.Attractions:GetChildren()
m.PageSelect(ButtonsThatOpenDetails, Details:GetChildren())
]]--

BackButton.MouseButton1Down:Connect(function()
	m.OpenPageFromList(BackButton.Name, Pages:GetChildren())
	m.OpenPageFromList("", Details:GetChildren()) --Closing all details
end)

-----------
--StartUp--
-----------

return m
