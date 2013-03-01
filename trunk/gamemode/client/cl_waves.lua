//WAVES CLIENTSIDE

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer

util.PrecacheSound("ambient/creatures/town_zombie_call1.wav")
util.PrecacheSound("ambient/atmosphere/cave_hit1.wav")

net.Receive( "recwavestart", function( len )
	
	local wave = net.ReadDouble()

	GAMEMODE:SetWave(wave)
	GAMEMODE:SetWaveEnd(net.ReadFloat())

	local UnlockedClass
	local amount = 0
	for i, tab in ipairs(ZombieClasses) do
		if tab.Wave <= wave and not tab.Unlocked then
			tab.Unlocked = true
			UnlockedClass = tab.Name
			amount = amount + 1
		end
	end

	--local msg = "<color=ltred><font=HUDFontAA>Wave "..wave.." has begun!"
	local msg = "Wave "..wave.." has begun!"
	if wave == NUM_WAVES then
		//msg = "<color=ltred><font=HUDFontAA>THE FINAL WAVE HAS BEGUN!"
		msg = "THE FINAL WAVE HAS BEGUN!"
	end

	local secmsg = ""
	if amount == 1 then
		//secmsg = "<color=green><font=HUDFontSmallAA>"..UnlockedClass.." unlocked!"
		secmsg = UnlockedClass.." unlocked!"
	elseif 1 < amount then
		secmsg = amount.." new zombies unlocked!"
		//secmsg = "<color=green><font=HUDFontSmallAA>"..amount.." new zombies unlocked!"
	end

	//GAMEMODE:SplitMessage(h * 0.6, msg, secmsg)
	GAMEMODE:Add3DMessage(140,msg,nil,"ArialBoldTwelve")
	
	if wave == BONUS_RESISTANCE_WAVE then
		GAMEMODE:Add3DMessage(140,"Undead became stronger!",nil,"ArialBoldTen")
	end
	
	//GAMEMODE:Add3DMessage(140,secmsg,nil,"ArialBoldTen")

	surface.PlaySound("ambient/creatures/town_zombie_call1.wav")

end)

usermessage.Hook("recwavestart", function(um)
	local wave = um:ReadShort()

	GAMEMODE:SetWave(wave)
	GAMEMODE:SetWaveEnd(um:ReadFloat())

	local UnlockedClass
	local amount = 0
	for i, tab in ipairs(ZombieClasses) do
		if tab.Wave <= wave and not tab.Unlocked then
			tab.Unlocked = true
			UnlockedClass = tab.Name
			amount = amount + 1
		end
	end

	--local msg = "<color=ltred><font=HUDFontAA>Wave "..wave.." has begun!"
	local msg = "Wave "..wave.." has begun!"
	if wave == NUM_WAVES then
		//msg = "<color=ltred><font=HUDFontAA>THE FINAL WAVE HAS BEGUN!"
		msg = "THE FINAL WAVE HAS BEGUN!"
	end

	local secmsg = ""
	if amount == 1 then
		//secmsg = "<color=green><font=HUDFontSmallAA>"..UnlockedClass.." unlocked!"
		secmsg = UnlockedClass.." unlocked!"
	elseif 1 < amount then
		secmsg = amount.." new zombies unlocked!"
		//secmsg = "<color=green><font=HUDFontSmallAA>"..amount.." new zombies unlocked!"
	end

	//GAMEMODE:SplitMessage(h * 0.6, msg, secmsg)
	GAMEMODE:Add3DMessage(140,msg,nil,"ArialBoldTwelve")
	GAMEMODE:Add3DMessage(140,secmsg,nil,"ArialBoldTen")

	surface.PlaySound("ambient/creatures/town_zombie_call1.wav")
end)

net.Receive( "recwaveend", function( len )
	
	local wave = net.ReadDouble()
	GAMEMODE:SetWaveStart(net.ReadFloat())

	if wave < NUM_WAVES then
		//GAMEMODE:SplitMessage(h * 0.7, "<color=ltred><font=HUDFontAA>Wave "..wave.." is over!", "<color=white><font=HUDFontSmallAA>The Undead have stopped rising... for now")
		GAMEMODE:Add3DMessage(140,"Wave "..wave.." is over!",nil,"ArialBoldTwelve")
		
		for i, tab in ipairs(ZombieClasses) do
			if tab.Wave <= math.Clamp(wave+1,wave,NUM_WAVES) and not tab.Unlocked then
				tab.Unlocked = true
			end
		end

		surface.PlaySound("ambient/atmosphere/cave_hit1.wav")
	end
	
end)

usermessage.Hook("recwaveend", function(um)
	local wave = um:ReadShort()
	GAMEMODE:SetWaveStart(um:ReadFloat())

	if wave < NUM_WAVES then
		//GAMEMODE:SplitMessage(h * 0.7, "<color=ltred><font=HUDFontAA>Wave "..wave.." is over!", "<color=white><font=HUDFontSmallAA>The Undead have stopped rising... for now")
		GAMEMODE:Add3DMessage(140,"Wave "..wave.." is over!",nil,"ArialBoldTwelve")
		
		for i, tab in ipairs(ZombieClasses) do
			if tab.Wave <= math.Clamp(wave+1,wave,NUM_WAVES) and not tab.Unlocked then
				tab.Unlocked = true
			end
		end

		surface.PlaySound("ambient/atmosphere/cave_hit1.wav")
	end
end)

usermessage.Hook("recranfirstzom", function(um)
	--GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>You have been randomly chosen to lead the Undead army!</font></color>")
end)

usermessage.Hook("recvolfirstzom", function(um)
	--GAMEMODE:SplitMessage(h * 0.7, "<color=red><font=HUDFontAA>You have volunteered to lead the Undead army!</font></color>")
end)

net.Receive( "SetInf", function( len )
	
	INFLICTION = net.ReadFloat()

	if not LASTHUMAN then
		if 0.75 <= INFLICTION and not UNLIFE then
			UNLIFE = true
			HALFLIFE = true
			--GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Un-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 75%</font></color>")
			GAMEMODE:SetUnlifeText()
		elseif INFLICTION >= 0.5 and not HALFLIFE then
			HALFLIFE = true
			--GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Half-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 50%</font></color>")
			GAMEMODE:SetHalflifeText()
		end
	end

end)

usermessage.Hook("SetInf", function(um)
	INFLICTION = um:ReadFloat()
	
	if not LASTHUMAN then
		if 0.75 <= INFLICTION and not UNLIFE then
			UNLIFE = true
			HALFLIFE = true
			--GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Un-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 75%</font></color>")
			GAMEMODE:SetUnlifeText()
		elseif INFLICTION >= 0.5 and not HALFLIFE then
			HALFLIFE = true
			--GAMEMODE:SplitMessage(h * 0.725, "<color=ltred><font=HUDFontAA>Half-Life</font></color>", "<color=ltred><font=HUDFontSmallAA>Horde locked above 50%</font></color>")
			GAMEMODE:SetHalflifeText()
		end
	end
end)

net.Receive( "SetInfInit", function( len )
	
	INFLICTION = net.ReadFloat()
	local wave = net.ReadDouble()
	GAMEMODE:SetWave(wave)

	for i, tab in ipairs(ZombieClasses) do
		if tab.Wave <= wave then
			tab.Unlocked = true
		end
	end

	if INFLICTION >= 0.75 then
		UNLIFE = true
		HALFLIFE = true
		--LoopUnlife()
	elseif INFLICTION >= 0.5 then
		HALFLIFE = true
	end

end)

usermessage.Hook("SetInfInit", function(um)
	INFLICTION = um:ReadFloat()
	local wave = um:ReadShort()
	GAMEMODE:SetWave(wave)

	for i, tab in ipairs(ZombieClasses) do
		if tab.Wave <= wave then
			tab.Unlocked = true
		end
	end

	if INFLICTION >= 0.75 then
		UNLIFE = true
		HALFLIFE = true
		--LoopUnlife()
	elseif INFLICTION >= 0.5 then
		HALFLIFE = true
	end
end)

net.Receive( "reczsgamestate", function( len )
	
	GAMEMODE:SetWave(net.ReadDouble())
	GAMEMODE:SetWaveStart(net.ReadFloat())
	GAMEMODE:SetWaveEnd(net.ReadFloat())

end)

usermessage.Hook("reczsgamestate", function(um)
	GAMEMODE:SetWave(um:ReadShort())
	GAMEMODE:SetWaveStart(um:ReadFloat())
	GAMEMODE:SetWaveEnd(um:ReadFloat())
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

net.Receive( "SendPlayerXP", function( len )
	
	if not IsValid( MySelf ) then return end
	
	local xp = net.ReadDouble()
	
	if not MySelf.DataTable then print("[STATS] Small clientside stats error. Ignore it.") return 0 end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].xp = xp
	end

end)

/*usermessage.Hook("SendPlayerXP", function(um)
	
	if not IsValid( MySelf ) then return end
	
	local xp = um:ReadLong()
	
	if not MySelf.DataTable then print("[STATS] Small clientside stats error. Ignore it.") return 0 end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].xp = xp
	end
	
end)
*/

net.Receive( "SendPlayerRank", function( len )
	
	if not IsValid( MySelf ) then return end
	
	local rank = net.ReadDouble()

	if not MySelf.DataTable then print("[STATS] Small clientside stats error. Ignore it.") return 0 end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].rank = rank
	end

end)

/*usermessage.Hook("SendPlayerRank", function(um)
	
	if not IsValid( MySelf ) then return end

	local rank = um:ReadLong()

	if not MySelf.DataTable then print("[STATS] Small clientside stats error. Ignore it.") return 0 end
	
	if MySelf.DataTable["ClassData"]["default"] then
		MySelf.DataTable["ClassData"]["default"].rank = rank
	end
	
end)*/

net.Receive( "SendPlayerPerk", function( len )
	
	if not IsValid( MySelf ) then return end
	
	local pl = net.ReadEntity()
	local perk = net.ReadString()
	
	if !IsValid(pl) then return end
	
	pl.Perk = pl.Perk or {}
	
	if not pl.Perk then return end
	
	if #pl.Perk > 2 then return end
	
	table.insert(pl.Perk,perk)

end)

/*usermessage.Hook("SendPlayerPerk", function(um)
	
	if not IsValid( MySelf ) then return end
	
	local pl = um:ReadEntity()
	local perk = um:ReadString()
	
	if not pl.Perk then pl.Perk = {} end
	
	if #pl.Perk > 2 then return end
	
	table.insert(pl.Perk,perk)
	//pl.Perk = perk
	
end)*/

net.Receive( "SendSales", function( len )
	
	if not IsValid( MySelf ) then return end
	print("Received!")
	
	local amount = net.ReadDouble()
	print("Am "..amount)
	local wep, disc
	for i=1, amount do
		wep = net.ReadString()
		disc = net.ReadDouble()
		if not GAMEMODE.HumanWeapons[wep] then
		//if wep == nil or disc == nil then
			print("Sales error. Requesting an update.")
			timer.Simple(1,function() RunConsoleCommand("mrgreen_fixdeadsales") end)
			break
		else
			print(wep.."   |   "..disc)
			GAMEMODE.WeaponsOnSale[wep] = disc
			GAMEMODE.HumanWeapons[wep].Price = math.ceil(GAMEMODE.HumanWeapons[wep].Price - GAMEMODE.HumanWeapons[wep].Price*(GAMEMODE.WeaponsOnSale[wep]/100))
		end
	end

end)

usermessage.Hook("SendSales", function(um)
	
	if not IsValid( MySelf ) then return end
	print("Received!")
	//GAMEMODE.WeaponsOnSale = GAMEMODE.WeaponsOnSale or {}
	
	local amount = um:ReadShort()
	print("Am "..amount)
	local wep, disc
	for i=1, amount do
		wep = um:ReadString()
		disc = um:ReadShort()
		if not GAMEMODE.HumanWeapons[wep] then
		//if wep == nil or disc == nil then
			print("Sales error. Requesting an update.")
			timer.Simple(1,function() RunConsoleCommand("mrgreen_fixdeadsales") end)
			break
		else
			print(wep.."   |   "..disc)
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

usermessage.Hook("SuperBossNotify", function(um)
	
	SUPER_BOSS = true
	
	for index, tbl in pairs(ZombieClasses) do
		if ZombieSuperBosses[index] then
			ZombieClasses[index] = ZombieSuperBosses[index]
		end
	end

end)

usermessage.Hook("Fun1", function(um)
	
	local pl = um:ReadEntity()
	local s = um:ReadShort()
	
	pl:SetModelScale(Vector(s,s,s))

end)
