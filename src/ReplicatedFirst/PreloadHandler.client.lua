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
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

--Shortcutts--

local Camera = workspace.CurrentCamera
local Atmosphere = game.Lighting:WaitForChild("Atmosphere")
local dofmenu = game.Lighting:WaitForChild("dofmenu")

--------------------------------------------------------------------------------------------------
--Functions---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
local function MenuSetup()
	Atmosphere.Density = 1
	dofmenu.Enabled = true
	
	repeat wait() until Camera.CameraSubject ~= nil
	Camera.CameraSubject = nil
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.FieldOfView = 45
	Camera.CFrame = CFrame.new(0,1000,0)
	
	
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
	
	repeat wait() until workspace:FindFirstChild("MenuCamBrick")
	local MenuCamBrick = workspace:FindFirstChild("MenuCamBrick")
	Camera.CFrame = MenuCamBrick.CFrame
end

local function PreloadCastle()
	local Castle = workspace:WaitForChild("Castle")
	ContentProvider:PreloadAsync({Castle})
end

local function PreloadWorkspace()
	ContentProvider:PreloadAsync({workspace, game.Players.LocalPlayer.PlayerGui})
end



-------------------------------------------------------------------------------------------------
--Triggers---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
--StartUp---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
MenuSetup()
spawn(function()
	PreloadCastle()
	wait(2)
	TweenService:Create(Atmosphere,TweenInfo.new(3, Enum.EasingStyle.Quart),{Density=0}):Play()
end)
PreloadWorkspace()

local Player = game.Players.LocalPlayer
local Menu = Player.PlayerGui:WaitForChild("Menu")
local Loaded = Menu:WaitForChild("MenuController"):WaitForChild("Loaded")
Loaded.Value = true