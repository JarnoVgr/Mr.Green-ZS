-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Player take damage
local function OnPlayerDamage(pl, attacker, inflictor, dmginfo )
	local Time = CurTime()
	--Last time when the victim was hurt
	pl.LastHurt = Time
	
	--Set LastHit time
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker.LastHit = Time
	end

	-- Damage indicator
	GAMEMODE:DoDamageIndicator(pl, inflictor, attacker, dmginfo)

	--timer.Simple(0.5, function()
		--  Process upgrade codes and bonuses
		GAMEMODE:DoDamageUpgrades(pl, attacker, inflictor, dmginfo)
		
		-- Process achievements
		GAMEMODE:DoDamageAchievements(pl, attacker, inflictor, dmginfo)
	--end)

	-- Play hurt sound
	pl:PlayPainSound()

	
	if pl:IsHuman() then
		pl:CheckSpeedChange()
		if attacker:IsPlayer() and attacker:GetActiveWeapon():GetClass() == "weapon_zs_undead_ghoul" or attacker:IsPlayer() and attacker:GetActiveWeapon():GetClass() == "weapon_zs_undead_poisonzombie" then
			local protect = 0
			if pl:GetPerk("_poisonprotect") then
				protect = 4
			end	
			
			pl:TakeDamageOverTime(math.Clamp(dmginfo:GetDamage() * 0.2,1,2), 1.5, 5 - protect, attacker, attacker:GetActiveWeapon())
			
			if not pl.IsInfected then
				local Infect = EffectData()		
				Infect:SetEntity( pl )
				util.Effect( "infected_human", Infect, true)
			end
			
		end
		
	end
	-- Victim got hit
	pl.TookHit = true

	--Hit gore
	--local tr = pl:TraceLine(54, MASK_SHOT, team.GetPlayers(TEAM_HUMAN))
	--local pos = tr.HitPos
	--local norm = tr.HitNormal

	--local eff = EffectData()
	--eff:SetOrigin(pos)
	--eff:SetNormal(norm)
	--eff:SetScale(math.Rand(0.9,1.2))
	--eff:SetMagnitude(math.random(5,20))
	--util.Effect("bloodsplash", eff, true, true)
end
hook.Add("OnPlayerTakeDamage", "PlayerTakeDamage", OnPlayerDamage)