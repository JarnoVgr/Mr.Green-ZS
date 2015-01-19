-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Process game achievements 
function GM:DoDamageAchievements ( ent, attacker, inflictor, dmginfo )

	-- More accurate
	local damage = dmginfo:GetDamage()
	
	-- if there's no inflictor, make it the active weapon	
	if ( inflictor == attacker ) then
		if inflictor:IsPlayer() then inflictor = attacker:GetActiveWeapon() else inflictor = attacker end
	end
	
	if attacker:IsPlayer() and attacker:Team() ~= ent:Team() then
		--attacker:PrintMessage (HUD_PRINTTALK, "Damage done: "..dmginfo:GetDamage().." by "..inflictor:GetClass().."")
		
		-- Add damage to the damage counter
		attacker.DamageDealt[ attacker:Team() ] = attacker.DamageDealt[ attacker:Team() ] + damage
		
		-- Check damage original achievements
		if attacker:Team() == TEAM_UNDEAD then
			attacker:AddToCounter( "humansdamaged",damage )
			local dam = attacker:GetCounter( "humansdamaged" )
			if dam >= 10000 then
				attacker:UnlockAchievement( "humanitysdamnation" )
				if dam >= 100000 then
					attacker:UnlockAchievement( "humanitysworstnightmare" )
				end
			end
		end
		
		-- A shitload of class achivements
		if attacker:IsPlayer() and not attacker:IsBot() and attacker:Team() == TEAM_HUMAN then		
			-- Save the damage to the file and unlock some more damage achievements
			attacker:AddToCounter( "undeaddamaged",damage )
			local dam = attacker:GetCounter("undeaddamaged")
			if dam >= 100000 then
				attacker:UnlockAchievement("lightbringer")
				if dam >= 1000000 then
					attacker:UnlockAchievement("mankindsanswer")
				end
			end
		end
	end
end