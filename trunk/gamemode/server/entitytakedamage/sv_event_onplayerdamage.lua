-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math

-- Player take damage
local function OnPlayerDamage( pl, attacker, inflictor, dmginfo )

	-- Player spawn protected
	if pl:HasSpawnProtection() then
		if dmginfo:IsExplosionDamage() then
				dmginfo:SetDamage(dmginfo:GetDamage()*2)
			else
				dmginfo:SetDamage( math.Clamp( dmginfo:GetDamage(), 0, 50 ) * ( 1 - pl:GetSpawnDamagePercent() ) )
		end
		if dmginfo:IsDamageNull() then return true end
	end
	
	-- Damage indicator
	GAMEMODE:DoDamageIndicator ( pl, inflictor, attacker, dmginfo )

	timer.Simple(0.5, function()
		--  Process upgrade codes and bonuses
		GAMEMODE:DoDamageUpgrades ( pl, attacker, inflictor, dmginfo )
		
		-- Process achievements
		GAMEMODE:DoDamageAchievements ( pl, attacker, inflictor, dmginfo )
	end)

	-- Play hurt sound
	pl:PlayPainSound()
	
	if pl:IsHuman() then
		pl:CheckSpeedChange()
	end
	
	-- Victim got hit
	pl.TookHit = true
end
hook.Add( "OnPlayerTakeDamage", "PlayerTakeDamage", OnPlayerDamage )