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

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

--Gui--
local ScreenGui = script.Parent
local ScreenButtonsLabel = ScreenGui:WaitForChild("Buttons")
local ScreenButtons = ScreenButtonsLabel:GetChildren()
local Pages = ScreenGui:WaitForChild("Pages")
local MagicoinsLabel = ScreenGui.Magicoins
local Quests = ScreenGui:WaitForChild("Quests")

--DataStore--
local DataStore = Player:WaitForChild("DataStore")
local Magicoins = DataStore:FindFirstChild("Magicoins")

--Modules--
local MapModule = script:WaitForChild("MapModule")
local InventoryModule = script:WaitForChild("InventoryModule")
local ShopModule = script:WaitForChild("ShopModule")
local QuestModule = script:WaitForChild("QuestModule")
local ItemPurchaseModule = script:WaitForChild("ItemPurchaseModule")
local CodesModule = script:WaitForChild("CodesModule")
local AccountModule = script:WaitForChild("AccountModule")
AccountModule = require(AccountModule)
CodesModule = require(CodesModule)
ItemPurchaseModule = require(ItemPurchaseModule)
QuestModule = require(QuestModule)
ShopModule = require(ShopModule)
InventoryModule = require(InventoryModule)
MapModule = require(MapModule)

--Audio--
local AudioFolder = ScreenGui:WaitForChild("Audio")
local ClickAudio = AudioFolder:WaitForChild("Click")
local EquipAudio = AudioFolder:WaitForChild("Equip")
local MagicoinAudio = AudioFolder:WaitForChild("Magicoin")
local ItemPurchaseAudio = AudioFolder:WaitForChild("ItemPurchase")
local QuestCompleteAudio = AudioFolder:WaitForChild("QuestComplete")

local Open = false
local MinimumGuiSizes = { --The X value in Pixels
	[ScreenButtonsLabel] = 400,
}
local PrevMagicoins = Magicoins.Value

-------------
--Functions--
-------------

local function SizeHoverEffect(GUIs)
	local SizeIncrease = 1.1
	for i = 1, #GUIs do
		local Gui = GUIs[i]
		if Gui:IsA("GuiButton") then
			Gui.MouseEnter:Connect(function()
				Gui.Size = UDim2.new(Gui.Size.X.Scale * SizeIncrease, 0,Gui.Size.Y.Scale * SizeIncrease, 0)
			end)
			Gui.MouseLeave:Connect(function()
				Gui.Size = UDim2.new(Gui.Size.X.Scale / SizeIncrease, 0,Gui.Size.Y.Scale / SizeIncrease, 0)
			end)
		end
	end
end

local function ApplySizeHover()
	local Descendants = Pages:GetDescendants()
	local Buttons = {}
	for i = 1, #Descendants do
		if Descendants[i]:IsA("GuiButton") and Descendants[i].Name ~= "QuestActivationButton" then
			table.insert(Buttons, Descendants[i])
		end
	end
	Descendants = ScreenGui.Quests:GetDescendants()
	for i = 1, #Descendants do
		if Descendants[i]:IsA("GuiButton") and Descendants[i].Name ~= "QuestActivationButton" then
			table.insert(Buttons, Descendants[i])
		end
	end
	SizeHoverEffect(Buttons)
end

local function FitGuiSizes()
	for k,v in pairs(MinimumGuiSizes) do
		if k.AbsoluteSize.X < v then
			local ScreenSizeX = ScreenGui.AbsoluteSize.X
			local MinimumScaleX = v / ScreenSizeX
			
			k.Size = UDim2.new(MinimumScaleX, 0, 0, 0)
		end
	end
end

local function MouseTouching(Scope)
	local Touching = Player.PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
	for i = 1, #Touching do
		local Gui = Touching[i]
		for i = 1, #Scope do
			if Gui == Scope[i] then
				return Touching[i]
			end
		end
	end
	return nil
end

------------
--Triggers--
------------
--Page closing when clicking outside frame--
Mouse.Button1Down:Connect(function()
	local Scope = Pages:GetChildren()
	if not MouseTouching(Scope) then
		MapModule.OpenPageFromList("", Pages:GetChildren()) --Closes all pages
		Open = false
	end
end)

 
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		--Click soundEffect--
		local Touching = Player.PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
		for i = 1, #Touching do
			if Touching[i]:IsA("GuiButton") then
				ClickAudio:Play()
				break
			end
		end
	end
end)

Magicoins.Changed:Connect(function()
	if Magicoins.Value > PrevMagicoins then
		MagicoinAudio:Play()
	end
	MagicoinsLabel.Text = Magicoins.Value
	PrevMagicoins = Magicoins.Value
end)

local PageChildren = Pages:GetChildren()
for i = 1, #PageChildren do
	local Page = PageChildren[i]
	local Close = Page:FindFirstChild("Close")
	
	if Close then
		Close.MouseButton1Down:Connect(function()
			MapModule.OpenPageFromList("", Pages:GetChildren()) --Closes all pages
			Open = false
		end)
	end
end

for i = 1, #ScreenButtons do
	local Button = ScreenButtons[i]
	if Button:IsA("GuiButton") then
		Button.MouseButton1Down:Connect(function()
			if Open == false and not ItemPurchaseModule.PromptOpen then
				Open = true
				MapModule.OpenPageFromList(Button.Name, Pages:GetChildren())
			else
				Open = false
				MapModule.OpenPageFromList("", Pages:GetChildren()) --Closes all pages
			end
		end)
	end
end



-----------
--StartUp--
-----------
FitGuiSizes()
MagicoinsLabel.Text = Magicoins.Value
ApplySizeHover()
