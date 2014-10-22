-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Score translation table

local RewardsTable = {
	[5] = { "weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_fiveseven", "weapon_zs_magnum" },
	[15] = { "weapon_zs_tmp", "weapon_zs_mp5", "weapon_zs_p90", "weapon_zs_ump", "weapon_zs_smg" },
	[25] = { "weapon_zs_aug", "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1" },
	[35] = { "weapon_zs_famas", "weapon_zs_sg552", "weapon_zs_pulserifle" },
	[50] = { "weapon_zs_m249" },
	[75] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}
--[=[
local RewardsTable = {
	[5] = { "weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_fiveseven", "weapon_zs_magnum" },
	[15] = { "weapon_zs_tmp", "weapon_zs_mp5", "weapon_zs_p90", "weapon_zs_ump", "weapon_zs_smg" },
	[25] = { "weapon_zs_aug", "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1" },
	[35] = { "weapon_zs_famas", "weapon_zs_sg552", "weapon_zs_pulserifle" },
	[50] = { "weapon_zs_m249" },
	[75] = { "weapon_zs_shotgun", "weapon_zs_m1014" },
}]=]


--[==[-------------------------------------------------------------
      Checks players score and gives him new weapons
--------------------------------------------------------------]==]
function GM:CheckHumanScore ( pl )
	if not IsValid ( pl ) then return end
	if pl:Team() == TEAM_HUMAN then return end
	--if pl:Team() ~= TEAM_HUMAN then return end
	--local class = pl:GetHumanClass()
	local class = pl:TEAM_HUMAN() 
	-- There isn't any entry in the reward table
	--if RewardsTable[class][ pl:GetScore() ] == nil then return end
	
	if RewardsTable[class][ pl.SkillPoints ] == nil then return end
	
	-- Make things easier
	--local Score = pl:GetScore()
	local Score = pl:SkillPoints()

	local Reward = table.Random ( RewardsTable[class][Score] )
	
	-- Check and see what type of weapon is that
	local RewardType, Automatic, Pistol, Melee = GetWeaponType ( Reward ), pl:GetAutomatic(), pl:GetPistol(), pl:GetMelee()
	local strCategory, WeaponToStrip = WeaponTypeToCategory[ RewardType ]
	
	-- Old ammo count
	local iOldAmmo = 0
	
	-- Compare automatic strength with what you have
	if strCategory == "Automatic" then 
		if IsValid ( Automatic ) and Automatic:IsWeapon() then
			local AutomaticMax = pl:CompareMaxDPS ( Automatic:GetClass(), Reward )
			iOldAmmo = pl:GetAmmoCount ( Automatic:GetPrimaryAmmoType() )
			if AutomaticMax == Automatic:GetClass() then Reward = nil else WeaponToStrip = Automatic:GetClass() end
		end		
	end
		
	-- Compare pistol strength with what you have
	if strCategory == "Pistol" then
		if IsValid ( Pistol ) and Pistol:IsWeapon() then
			local PistolMax = pl:CompareMaxDPS ( Pistol:GetClass(), Reward )
			iOldAmmo = pl:GetAmmoCount ( Pistol:GetPrimaryAmmoType() )
			if PistolMax == Pistol:GetClass() then Reward = nil else WeaponToStrip = Pistol:GetClass() end
		end
	end		
	if strCategory == "Melee" then
		if IsValid ( Melee ) and Melee:IsWeapon() then
			local MeleeMax = pl:CompareMaxDPS ( Melee:GetClass(), Reward )
			if MeleeMax == Melee:GetClass() then Reward = nil else WeaponToStrip = Melee:GetClass() end
		end
	end	
	-- Strip the weakest weapon in the cat.
	if WeaponToStrip then pl:StripWeapon ( WeaponToStrip ) end 
		
	-- Give it and notify
	if Reward then
		pl:Give ( Reward ) 
		pl:PrintMessage ( HUD_PRINTTALK, "[DIRECTOR] You have been rewarded a(n) "..( GAMEMODE.HumanWeapons[Reward].Name or "better weapon" ).." !" )
		
		-- Grab some data
		local Automatic, Pistol, RwCategory, bSelect = pl:GetAutomatic(), pl:GetPistol(), GetWeaponCategory ( Reward ), false
		
		-- Automatic guns always selected -- also, if you have an automatic gun, get the old ammo count
		if RwCategory == "Automatic" then bSelect = true end
		
		-- Reward is a pistol. We don't want selecting pistol when we have a heavier gun like automatic -- and get old ammo count
		if RwCategory == "Pistol" then if Automatic == false then bSelect = true end end
		
		-- Give back old ammo if there is
		local RwEntity = pl:GetWeapon( Reward )
		if RwCategory ~= "Melee" and RwCategory ~= "Explosive" then
		if iOldAmmo ~= 0 and IsValid ( RwEntity ) then pl:GiveAmmo ( math.Clamp ( iOldAmmo * 0.5, 15, 150 ), RwEntity:GetPrimaryAmmoType() ) end
		end
		-- Sound to play 
		pl:EmitSound ( Sound ( "weapons/physcannon/physcannon_pickup.wav" ) )
		
		-- Select it (delay it for reload animation)
		if bSelect then timer.Simple ( 0, function() pl:SelectWeapon( Reward ) end ) end 
	end
	
	Debug ( "[DIRECTOR] Finished checking score for player "..tostring ( pl )..". Reward given is "..tostring ( Reward or "NONE" ) )
end

--[==[-------------------------------------------------------------
          Called from the client - delivers ammunition
--------------------------------------------------------------]==]
function RegenerateAmmo ( pl, cmd, args )
	if not IsValid ( pl ) then return end
	if pl:Team() ~= TEAM_HUMAN then return end
	
	-- Prevent it on endround
	if ENDROUND then return end
	
	-- Server side validation :>
	if pl.ServerCheckTime == nil then return end
	if CurTime() < pl.ServerCheckTime then return end
	
	-- Update the time check value
	pl.ServerCheckTime = math.Round ( CurTime() + AMMO_REGENERATE_RATE )
	
	-- No ranged weapons -> no ammo regeneration
	if pl:GetPistol() == false and pl:GetAutomatic() == false then pl:PrintMessage ( HUD_PRINTTALK, "[AMMO] You need a ranged weapon before you can regenerate ammunition!" ) return end
	
	-- Grab data
	local Infliction = GetInfliction()
	
	-- Give ammo only to automatic (first slot) and pistols -- if they want mines/barricade they go for crates
	local AmmoList, DebugList =  { "pistol", "ar2", "smg1", "buckshot", "xbowbolt", "357" }
	
	local Automatic, Pistol = pl:GetAutomatic(), pl:GetPistol()
	
	if Automatic or Pistol then
	
	local WeaponToFill = pl:GetActiveWeapon()
	
	local AmmoType 
	
	if IsValid(WeaponToFill) and (GetWeaponCategory ( WeaponToFill:GetClass() ) == "Pistol" or GetWeaponCategory ( WeaponToFill:GetClass() ) == "Automatic") then
		AmmoType = WeaponToFill:GetPrimaryAmmoTypeString() or "pistol"
	else
		if pl:HasWeapon("weapon_zs_magnum") then
			AmmoType = "357"
		else
			AmmoType = "pistol"
		end
	end
		
	-- How much ammo to give
	local HowMuch = GAMEMODE.AmmoRegeneration[AmmoType] or 50
			
	-- 50% more ammunition at half-life and double for un-life
	if Infliction >= 0.5 then HowMuch = HowMuch * 1.1 end		
	if UNLIFE then HowMuch = HowMuch * 1.3 end
			
	-- Multiplier -- 30% less
	HowMuch = math.Round ( HowMuch * 0.65 )
	
	pl:GiveAmmo ( HowMuch, AmmoType )
	
	--DebugList = ( DebugList or "" )..tostring ( v:GetClass() ).." - "..tostring ( HowMuch ).." / "
	
	end
	--[=[
	for k,v in pairs ( pl:GetWeapons() ) do
		if GetWeaponCategory ( v:GetClass() ) == "Pistol" or GetWeaponCategory ( v:GetClass() ) == "Automatic" then
			local AmmoType = v:GetPrimaryAmmoTypeString() or "pistol"
		
			-- How much ammo to give
			local HowMuch = GAMEMODE.AmmoRegeneration[AmmoType] or 50
			
			-- 50% more ammunition at half-life and double for un-life
			if Infliction >= 0.5 then HowMuch = HowMuch * 1.1 end		
			if UNLIFE then HowMuch = HowMuch * 1.3 end
			
			-- Multiplier -- 30% less
			HowMuch = math.Round ( HowMuch * 0.7 )
			
			-- Give the ammo
			if GetWeaponCategory ( pl:GetActiveWeapon():GetClass()) == GetWeaponCategory ( v:GetClass() ) then 
			pl:GiveAmmo ( HowMuch, AmmoType )
			break
			else
			pl:GiveAmmo ( HowMuch, "pistol" )
			break
			end
			DebugList = ( DebugList or "" )..tostring ( v:GetClass() ).." - "..tostring ( HowMuch ).." / "
			
		end
	end
	]=]
	
	-- Notify
	pl:PrintMessage ( HUD_PRINTTALK, "[AMMO] You have regenerated ammunition for your ranged weapons!" )
	
	Debug ( "Regenerated Ammo for "..tostring ( pl )..": "..tostring ( DebugList ) )
end
concommand.Add ( "zs_regenammo", RegenerateAmmo )

Debug ( "[DIRECTOR] Loaded Rewards Module" )