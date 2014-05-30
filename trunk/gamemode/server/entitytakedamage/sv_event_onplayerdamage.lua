-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Player take damage
local function OnPlayerDamage( pl, attacker, inflictor, dmginfo )

	-- Player spawn protected
	if pl:HasSpawnProtection() then
		if dmginfo:IsExplosionDamage() then
			dmginfo:SetDamage(dmginfo:GetDamage()*2)
		else
		--	dmginfo:SetDamage( math.Clamp( dmginfo:GetDamage(), 0, 50 ) * ( 1 - pl:GetSpawnDamagePercent() ) )
			dmginfo:SetDamage( math.Clamp( dmginfo:GetDamage(), 0, 50 ) * ( 1.5 - pl:GetSpawnDamagePercent() ) )
		end
		
		if dmginfo:IsDamageNull() then
			return true
		end
	end
	
	-- Damage indicator
	GAMEMODE:DoDamageIndicator ( pl, inflictor, attacker, dmginfo )

	--timer.Simple(0.5, function()
		--  Process upgrade codes and bonuses
		GAMEMODE:DoDamageUpgrades ( pl, attacker, inflictor, dmginfo )
		
		-- Process achievements
		GAMEMODE:DoDamageAchievements ( pl, attacker, inflictor, dmginfo )
	--end)

	-- Play hurt sound
	pl:PlayPainSound()
	
	if pl:IsHuman() then
		pl:CheckSpeedChange()
	end
	
	
	
	--if self:GetPerk("_horsehealth") then
	
	--	end
	
	-- Victim got hit
	pl.TookHit = true
	
	
	
	
	
	
	
	--Duby:Hey you know I love to code with silly stuff. Well I gave horse health a revamp!! :O 
	--Duby: Please do not fuck with the medkit or anything as you will literally fuck the balance of the server!! >:(
		if pl:HasBought("horse") then
	local HealthRegen = {}
HealthRegen.Amount = 1
HealthRegen.GiveDelay = 1
HealthRegen.MaxRegen= 30

hook.Add( "Think", "RegenHealth", function()



--if pl:HasBought("horse") then
	for k,v in pairs( player.GetAll() ) do
		if v:Alive()  and v:Health() < HealthRegen.MaxRegen and ( !v.lastregen or v.lastregen < CurTime() - HealthRegen.GiveDelay ) then
		
			v.lastregen = CurTime()
			v:SetHealth( v:Health() + HealthRegen.Amount )
			
		end
	end
	
--end
	
end )
				end
	
end
hook.Add( "OnPlayerTakeDamage", "PlayerTakeDamage", OnPlayerDamage )



