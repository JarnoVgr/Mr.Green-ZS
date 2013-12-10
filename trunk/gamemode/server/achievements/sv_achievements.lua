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
	

--[=[  -- No more turrets :(
	-- turret damage
	if inflictor:IsPlayer() and inflictor:Team() == TEAM_HUMAN then
		if attacker:GetClass() == "turret" and attacker:GetOwner():IsValid() and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Alive() and attacker:GetOwner():Team() == TEAM_HUMAN then
			local pl = attacker:GetOwner()
			dmginfo:SetDamage ( damage + ( damage * ((pl:GetTableScore("engineer","level")+1)*HumanClasses[4].Coef[1] ) / 100 ) )
			
			-- Engineer Achievments stuff - turret damage
			if pl:GetHumanClass() == 4 then
				if pl:GetTableScore("engineer","level") == 2 and pl:GetTableScore("engineer","achlevel2_2") < 30000 then
					pl:AddTableScore("engineer","achlevel2_2", math.ceil ( damage ) )
				elseif pl:GetTableScore("engineer","level") == 3 and pl:GetTableScore("engineer","achlevel2_2") < 90000 then
					pl:AddTableScore("engineer","achlevel2_2", math.ceil ( damage ) )
				end
				
				pl:CheckLevelUp()
			end
		end
	end
]=]
	

	-- Last time when the victim was hurt
	ent.LastHurt = CurTime()
	
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