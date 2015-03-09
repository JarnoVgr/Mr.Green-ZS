include("sh_init.lua")
include("cl_obj_player_extend.lua")
include("cl_shop.lua")

local WeaponsOnSale = {}

function IsOnSale(item)
	if WeaponsOnSale[item] then
		return true
	end
	
	return false
end

function GetSale(item)
	return WeaponsOnSale[item] or false
end


--GM.WeaponsOnSale = WeaponsOnSale

net.Receive("SendSales", function(len)
	if not IsValid(MySelf) then
		return
	end

	Debug("[SKILLSHOP] Received SendSales")

	--Start clean
	WeaponsOnSale = {}
	
	local amount = net.ReadInt(8)

	local wep, disc
	for i=1, amount do
		wep = net.ReadString()
		disc = net.ReadInt(8)
		if not GAMEMODE.HumanWeapons[wep] then
			Debug("[SKILLSHOP] Sales error")
			break
		else
			WeaponsOnSale[wep] = disc

			--Update item pricing
			GAMEMODE.HumanWeapons[wep].Price = math.ceil(GAMEMODE.HumanWeapons[wep].Price - GAMEMODE.HumanWeapons[wep].Price * (WeaponsOnSale[wep] / 100))
		end
	end
end)

--Update buy status
net.Receive("BoughtPointsWithCoins", function(len)
	MySelf:SetBoughtPointsWithCoins(net.ReadBool())
end)