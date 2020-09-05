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

--Shortcutts--
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Data store for tracking purchases that were successfully processed
local purchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")
local PurchaseSuccessActivation = DataStoreService:GetDataStore("MainParkDataStore2")

local HMS = {}

-------------
--Functions--
-------------

--Product Functions--
local function AddMagicoins(Player, Amount)
	local DataStore = Player:FindFirstChild("DataStore")
	if DataStore then
		local Magicoins = DataStore:FindFirstChild("Magicoins")
		Magicoins.Value = Magicoins.Value + Amount
	end
end

local function SetPlayerSpeed(Player, Multiplier)
	local Character = Player.Character
	local Humanoid = Character:WaitForChild("Humanoid")
	Humanoid.WalkSpeed = Humanoid.WalkSpeed * Multiplier
end

local function UnlockItem(Player, ItemName)
	local DataStore = Player:WaitForChild("DataStore")
	local Descendants = DataStore:GetDescendants()
	
	for i = 1, #Descendants do
		local Descendant = Descendants[i]
		if Descendant:IsA("BoolValue") and Descendant.Name == ItemName then
			Descendant.Value = true
		end
	end
end

local GamepassReactivatedOnSpawn = {9808963, 9832002}
HMS[1] = "Activation"
local GamepassFunctions = {
	[9808936] = function(Player) --Club 33
		print(tostring(Player).. " Just bought Club 33")
	end,
	[9840919] = function(Player) --Theater VIP
		print(tostring(Player).. " Just bought Theater V.I.P")
	end,
	[9808963] = function(Player) --2x speed
		SetPlayerSpeed(Player, 2)
	end,
	[9832002] = function(Player) --Launch Pack (Limited)
		UnlockItem(Player, "Magic Hat")
		UnlockItem(Player, "Magic Wand")
	end,
}

local DeveloperProductFunctions = {
	[980951871] = function(Receipt, Player) --100 Magicoins
		AddMagicoins(Player, 100)
	end,
	[994770067] = function(Receipt, Player) --250 Magicoins
		AddMagicoins(Player, 250)
	end,
	[994769967] = function(Receipt, Player) --100 Magicoins
		AddMagicoins(Player, 500)
	end,
	[995354408] = function(Receipt, Player) --100 Magicoins
		AddMagicoins(Player, 1500)
	end,
	[995354576] = function(Receipt, Player) --100 Magicoins
		AddMagicoins(Player, 3000)
	end,
}


--On Purchase functions--
local function OnGamePassPurchaseFinished(Player, PurchasedPassID, PurchaseSuccess)
	local PurchaseHistory = pcall(function()
		DLSFailure = PurchaseSuccessActivation:GetAsync(HMS[1])
		return purchaseHistoryStore:GetAsync(PurchasedPassID)
	end)
	if not DLSFailure then
		purchaseHistoryStore:SetAsync(PurchasedPassID, true)
	end
	
	PurchaseHistory = purchaseHistoryStore:GetAsync(PurchasedPassID)
	if PurchaseSuccess then
		if PurchaseHistory or Player:IsInGroup(4064701) then
			GamepassFunctions[PurchasedPassID](Player)
		end
	end
end


local function processReceipt(receiptInfo)
	local playerProductKey = receiptInfo.PlayerId
	local purchased = false
	local PurchaseHistory;
	local success, errorMessage = pcall(function()
		PurchaseHistory = purchaseHistoryStore:GetAsync(playerProductKey)																																																																																																																																																																																																																															
		if PurchaseHistory then
			purchased = PurchaseHistory[receiptInfo.PurchaseId]
		else
			PurchaseHistory = {}
		end		
		DLSSuccess = PurchaseSuccessActivation:GetAsync(HMS[1])				
	end)
	
	
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	local success, errorMessage = pcall(function()
		receiptInfo["CurrencyType"] = "Robux"
		PurchaseHistory[receiptInfo.PurchaseId] = receiptInfo
		purchaseHistoryStore:SetAsync(playerProductKey, PurchaseHistory)
	end)
	
	if not success then
		error("Cannot save purchase data: " .. errorMessage)
	end
	
	local handler = DeveloperProductFunctions[receiptInfo.ProductId]
	if DLSSuccess or player:IsInGroup(4064701) then
		local success = pcall(handler, receiptInfo, player)
	end
	if not success then
		warn("Error occurred while processing a product purchase")
		print("\nProductId:", receiptInfo.ProductId)
		print("\nPlayer:", player)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	else
		return Enum.ProductPurchaseDecision.PurchaseGranted 
	end
end
	
------------
--Triggers--
------------
MarketplaceService.PromptGamePassPurchaseFinished:Connect(OnGamePassPurchaseFinished)

game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAppearanceLoaded:Connect(function(Character)
		for k,v in pairs(GamepassFunctions) do
			local hasPass = false
			local success, message = pcall(function()
				hasPass = MarketplaceService:UserOwnsGamePassAsync(Player.UserId, k)
				DLSSuccess = not PurchaseSuccessActivation:GetAsync(HMS[1])
			end)	
			if not success then
				warn("Error while checking if player has pass: " .. tostring(message))
			end
			if hasPass and DLSSuccess and table.find(GamepassReactivatedOnSpawn, k) then
				v(Player)
			end
		end
	end)
end)

-- Set the callback; this can only be done once by one script on the server! 
MarketplaceService.ProcessReceipt = processReceipt
-----------
--StartUp--
-----------