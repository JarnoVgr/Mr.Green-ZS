local function sortByItemPricing(a, b)
	return a.Price > b.Price
end

local cachedBestAvailableWeaponsResult = {}

local function ResetBestAvailableWeaponsCache()
	if cachedBestAvailableWeaponsResult.score and cachedBestAvailableWeaponsResult.score > 0 then
		cachedBestAvailableWeaponsResult.score = -1
		cachedBestAvailableWeaponsResult.result = ""
	end
end
timer.Create("ResetBestAvailableWeaponsCache", 7, 0, ResetBestAvailableWeaponsCache)

function GetBestAvailableWeapons()
	if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
		return
	end

	if cachedBestAvailableWeaponsResult.score and cachedBestAvailableWeaponsResult.result and cachedBestAvailableWeaponsResult.score == MySelf:GetScore() then
		return cachedBestAvailableWeaponsResult.result
	end

	local result = ""

	local Available = { Pistol = {}, Automatic = {}, Melee = {} }
	
	--Calculate and add every available weapon to table
	for itemClass, item in pairs(GAMEMODE.HumanWeapons) do
		if item.Restricted or not item.Price then
			continue
		end

		--Workaround for not having key
		item.Class = itemClass
		
		if GetWeaponType(itemClass) == "pistol" then
			table.insert(Available.Pistol, item)
		elseif GetWeaponType(itemClass) == "rifle" or GetWeaponType(itemClass) == "smg" or GetWeaponType(itemClass) == "shotgun" then
			table.insert(Available.Automatic, item)
		elseif GetWeaponType(itemClass) == "melee" then
			table.insert(Available.Melee, item)
		end
	end

	table.sort(Available.Pistol,sortByItemPricing)
	table.sort(Available.Automatic,sortByItemPricing)
	table.sort(Available.Melee,sortByItemPricing)

	for tableKey, thisTable in pairs(Available) do
		local holdingItem

		--Change holdingItem depending on what table we're processing
		if tableKey == "Pistol" then
			holdingItem = MySelf:GetPistol()
		elseif tableKey == "Automatic" then
			holdingItem = MySelf:GetAutomatic()
		elseif tableKey == "Melee" then
			holdingItem = MySelf:GetMelee()
		end

		for k, item in pairs(thisTable) do
			--Skip when score is insufficient
			if (MySelf:GetScore() < item.Price)  then
				continue
			end			

			--Skip when we already have it
			if MySelf:HasWeapon(item.Class) or (holdingItem and IsValid(holdingItem) and ((GAMEMODE.HumanWeapons[holdingItem:GetClass()].Price or 0) >= item.Price)) then
				continue
			end

			--Get pretty name and check if it's valid
			local prettyName = GAMEMODE.HumanWeapons[item.Class].Name or false
			if not prettyName then
				continue
			end

			if result ~= "" then
				result = result ..", ".. prettyName
			else
				result = prettyName
			end

			--Stop here
			break
		end
	end

	--Cache results since we query this function a lot
	--[[cachedBestAvailableWeaponsResult.score = MySelf:GetScore()
	cachedBestAvailableWeaponsResult.result = result]]

	return result
end