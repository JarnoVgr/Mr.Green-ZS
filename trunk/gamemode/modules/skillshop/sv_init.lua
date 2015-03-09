include("sh_init.lua")
include("sv_obj_player_extend.lua")

local WeaponsOnSale = {}
local ItemsOnSale = 0

local SaleChance = CreateConVar("zs_skillshop_sale_chance", "70", {}, "")
local MaxItems = CreateConVar("zs_skillshop_sale_maxitems", "6", {}, "")
local MinDiscountRange = CreateConVar("zs_skillshop_sale_mindiscount", "10", {}, "")
local MaxDiscountRange = CreateConVar("zs_skillshop_sale_maxdiscount", "25", {}, "")

local function SelectSales()	
	local salechance = 1 / (SaleChance:GetInt() / 100)
	
	if math.random(1, salechance) ~= 1 then
		return
	end
	
	print("[SKILLSHOP] Sale chance is: ".. SaleChance:GetInt() .."%")

	--Start clean
	WeaponsOnSale = {}
	ItemsOnSale = 0
	
	local ActualItems = math.random(1, MaxItems:GetInt())
	local TempWeps = {}
	
	--Filter weapons with price
	for wep,tab in pairs(GAMEMODE.HumanWeapons) do
		if tab.Price then
			table.insert(TempWeps, wep)
		end
	end
	
	print("[SKILLSHOP] There are ".. ActualItems .." item(s) on sale")
	
	--Add X random weapons
	while ItemsOnSale < ActualItems do
		local wep = table.Random(TempWeps)
		if not WeaponsOnSale[wep] then
			WeaponsOnSale[wep] = math.random(MinDiscountRange:GetInt(),  MaxDiscountRange:GetInt())
			ItemsOnSale = ItemsOnSale + 1
			--Change actual price 
			GAMEMODE.HumanWeapons[wep].Price = math.ceil(GAMEMODE.HumanWeapons[wep].Price - GAMEMODE.HumanWeapons[wep].Price*(WeaponsOnSale[wep]/100))
		end
	end
end
hook.Add("Initialize", "SkillShop-SelectSales", SelectSales)

util.AddNetworkString("SendSales")
local function SendSalesToClient(pl)
	if pl:IsBot() or ItemsOnSale == 0 then
		return
	end

	net.Start("SendSales")
	net.WriteInt(ItemsOnSale or 0, 8)
	for wep, tab in pairs(WeaponsOnSale) do
		net.WriteString(wep)
		net.WriteInt(WeaponsOnSale[wep], 8)
	end
	net.Send(pl)
end
hook.Add("PlayerReady", "SkillShop-SendSales", SendSalesToClient)

--Buy points with GCs
local BuyPointsAmount = GetConVar("zs_skillshop_buypoints_amount")
local BuyPointsCost = GetConVar("zs_skillshop_buypoints_cost")
concommand.Add("zs_skillshop_buypoints", function(pl, cmd, args)
	if not IsValid(pl) or not pl:CanBuyPointsWithCoins(BuyPointsCost:GetInt()) then
		return
	end

	pl:SetBoughtPointsWithCoins(true)
	skillpoints.AddSkillPoints(pl, BuyPointsAmount:GetInt())
	pl:TakeGreenCoins(BuyPointsCost:GetInt())
end)

--Receive shop status for damage reduction
util.AddNetworkString("PlayerSkillShopStatus")
net.Receive("PlayerSkillShopStatus", function(len, pl)
	if not IsValid(pl) then
		return
	end
	
	pl.IsSkillShopOpen = net.ReadBool()

	--Anti-exploit
	if not pl:IsNearCrate() then
		pl.IsSkillShopOpen = false
	end
end)

function ApplySkillShopItem(pl, com, args)
	if not args or #args <= 0 or not IsValid(pl) or not pl:IsNearCrate() then
		return
	end
	
	local item = args[1]
	
	local Automatic, Pistol, Melee = pl:GetAutomatic(), pl:GetPistol(), pl:GetMelee()
	
	if string.sub(item, 1, 6) == "weapon" then
		if not GAMEMODE.HumanWeapons[item] or not GAMEMODE.HumanWeapons[item].Price then
			return
		end

		--Sufficient points?
		if pl:GetScore() < GAMEMODE.HumanWeapons[item].Price then
			return
		end

		--Determine to check against what weapon
		local StrCategory = GetWeaponCategory(item)
		local CurrentWeapon = nil
		if StrCategory == "Automatic" and Automatic then
			CurrentWeapon = Automatic
		elseif StrCategory == "Pistol" and Pistol then
			CurrentWeapon = Pistol
		elseif StrCategory == "Melee" and Melee then
			CurrentWeapon = Melee
		end
		
		--Strip current weapon in same class
		--[[if CurrentWeapon then
			pl:StripWeapon(CurrentWeapon:GetClass())
		end]]

		--Drop current weapon in same class
		if CurrentWeapon then
			for i,j in pairs(pl:GetWeapons()) do
				if j:GetClass() == CurrentWeapon:GetClass() then
					pl:DropWeapon(j)
					break
				end
			end
		end

		pl:Give(item)
		skillpoints.TakeSkillPoints(pl, GAMEMODE.HumanWeapons[item].Price)

		pl:SelectWeapon(item)
	--Give ammo for current weapon
	elseif item == "current-ammo" then
		local Automatic, Pistol = pl:GetAutomatic(), pl:GetPistol()
	
		if not Automatic and not Pistol then
			return
		end

		local WeaponToFill = pl:GetActiveWeapon()

		--Determine ammo type to give
		if IsValid(WeaponToFill) and (GetWeaponCategory(WeaponToFill:GetClass()) == "Pistol" or GetWeaponCategory(WeaponToFill:GetClass()) == "Automatic") then
			item = WeaponToFill:GetPrimaryAmmoTypeString() or "pistol"
		else
			if pl:HasWeapon("weapon_zs_magnum") then
				item = "357"
			else
				item = "pistol"
			end
		end

		if not GAMEMODE.SkillShopAmmo[item] or not GAMEMODE.SkillShopAmmo[item].Price then
			return
		end

		--Sufficient points?
		if pl:GetScore() < GAMEMODE.SkillShopAmmo[item].Price then
			return
		end

		pl:GiveAmmo(math.Clamp(GAMEMODE.SkillShopAmmo[item].Amount, 1, 1000), item)
		skillpoints.TakeSkillPoints(pl, GAMEMODE.SkillShopAmmo[item].Price)
	else
		if not GAMEMODE.SkillShopAmmo[item] or not GAMEMODE.SkillShopAmmo[item].Price then
			return
		end
		
		--Sufficient points?
		if pl:GetScore() < GAMEMODE.SkillShopAmmo[item].Price then
			return
		end

		--Check for tools
		if GAMEMODE.SkillShopAmmo[item].Tool then
			for i,j in pairs (pl:GetWeapons()) do
				if j:GetClass() == GAMEMODE.SkillShopAmmo[item].Tool then
					j:SetClip1(j:Clip1() + GAMEMODE.SkillShopAmmo[item].Amount)
					skillpoints.TakeSkillPoints(pl, GAMEMODE.SkillShopAmmo[item].Price)

					pl:EmitSound("items/ammo_pickup.wav")
					break
				end
			end
		else
			pl:GiveAmmo(math.Clamp(GAMEMODE.SkillShopAmmo[item].Amount, 1, 1000), item)
			skillpoints.TakeSkillPoints(pl, GAMEMODE.SkillShopAmmo[item].Price)
		end
	end
end
concommand.Add("zs_skillshop_buy",ApplySkillShopItem)