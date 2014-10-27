-- WAVES CLIENTSIDE

util.PrecacheSound("ambient/creatures/town_zombie_call1.wav")
util.PrecacheSound("ambient/atmosphere/cave_hit1.wav")

net.Receive("SetInf", function(len)
	INFLICTION = net.ReadFloat()
	local bIsInit = tobool(net.ReadBit())
		
	local UnlockedClass
	local amount = 0
	for i, tab in ipairs(ZombieClasses) do
		--Check for unlock
		if tab.Infliction <= INFLICTION and not tab.Unlocked and not tab.Hidden then
			tab.Unlocked = true
			UnlockedClass = tab.Name
			amount = amount + 1
		--Check if relock is needed
		elseif tab.Unlocked and tab.Infliction > INFLICTION then
			tab.Unlocked = false
		end
	end
	
	local msg = ""
	if amount == 1 then
		msg = UnlockedClass .." specie unlocked"
	elseif amount > 1 then
		msg = amount .." Undead species unlocked"
	end
	
	if msg ~= "" then
		GAMEMODE:Add3DMessage(140,msg,nil,"ArialBoldTwelve")
		surface.PlaySound(Sound("ambient/atmosphere/cave_hit1.wav"))
		--surface.PlaySound("ambient/creatures/town_zombie_call1.wav")
	end
end)

net.Receive("UnlockAllUndeadClasses", function(len)		
	local UnlockedClass
	local amount = 0
	for i, tab in ipairs(ZombieClasses) do
		--Check for unlock
		if not tab.Unlocked and not tab.Hidden then
			tab.Unlocked = true
			UnlockedClass = tab.Name
			amount = amount + 1
		end
	end
	
	local msg = ""
	if amount == 1 then
		msg = UnlockedClass .." specie unlocked"
	elseif amount > 1 then
		msg = amount .." Undead species unlocked"
	end
	
	if msg ~= "" then
		GAMEMODE:Add3DMessage(140,msg,nil,"ArialBoldTwelve")
		surface.PlaySound(Sound("ambient/atmosphere/cave_hit1.wav"))
		--surface.PlaySound("ambient/creatures/town_zombie_call1.wav")
	end
end)

function GM:GetLivingZombies()
	local tab = {}

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and 0.500001 <= pl:Health() and not pl:IsCrow() then
			table.insert(tab, pl)
		end
	end

	self.LivingZombies = #tab
	return tab
end

function GM:NumLivingZombies()
	return #self:GetLivingZombies()
end

net.Receive("SendPlayerXP", function(len)
	if not IsValid(MySelf) then
		return
	end
	
	local xp = net.ReadDouble()
	
	if not MySelf.DataTable then
		Debug("[STATS] Small clientside stats error. Ignore it.")
		return 0
	end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].xp = xp
	end
end)

net.Receive("SendPlayerRank", function(len)
	if not IsValid(MySelf) then
		return
	end
	
	local rank = net.ReadDouble()

	if not MySelf.DataTable then
		Debug("[STATS] Small clientside stats error. Ignore it.")
		return 0
	end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].rank = rank
	end
end)

net.Receive("SendPlayerPerk", function(len)
	if not IsValid(MySelf) then
		return
	end
	
	local pl = net.ReadEntity()
	local perk = net.ReadString()
	
	if not IsValid(pl) then
		return
	end
	
	pl.Perk = pl.Perk or {}
	
	if not pl.Perk or #pl.Perk > 2 then
		return
	end

	table.insert(pl.Perk,perk)
end)

net.Receive("SendSales", function(len)
	if not IsValid( MySelf ) then return end
	Debug("[SKILLSHOP] Received SendSales (net)")
	
	local amount = net.ReadDouble()

	local wep, disc
	for i=1, amount do
		wep = net.ReadString()
		disc = net.ReadDouble()
		if not GAMEMODE.HumanWeapons[wep] then
			Debug("[SKILLSHOP] Sales error. Requesting an update.")
			timer.Simple(1,function() RunConsoleCommand("mrgreen_fixdeadsales") end)
			break
		else
			GAMEMODE.WeaponsOnSale[wep] = disc
			GAMEMODE.HumanWeapons[wep].Price = math.ceil(GAMEMODE.HumanWeapons[wep].Price - GAMEMODE.HumanWeapons[wep].Price*(GAMEMODE.WeaponsOnSale[wep]/100))
		end
	end
end)

function IsOnSale(item)
	if GAMEMODE.WeaponsOnSale[item] then
		return true
	end
	
	return false
end