-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function GM:DoAchievementsCheck ( pl, attacker, inflictor, dmginfo )

	if attacker:Team() == TEAM_UNDEAD and pl:SteamID() == "STEAM_0:1:19523408" and not dmginfo:IsSuicide(pl) then
		attacker:UnlockAchievement("pufulet")
	end
	
	if pl:IsBot() or attacker:IsBot() then return end

	if attacker:Team() == TEAM_UNDEAD and attacker ~= pl then
		local brains = attacker.BrainsEaten
		if brains >= 5 then
			attacker:UnlockAchievement("bloodseeker")
			if brains >= 8 then
				attacker:UnlockAchievement("meatseeker")
				if brains >= 12 then
					attacker:UnlockAchievement("feastseeker")
				end
			end
		end
			
		brains = attacker:GetScore("humanskilled")
		if brains >= 50 then
			attacker:UnlockAchievement("slayer")
			if brains >= 100 then
				attacker:UnlockAchievement("butcher")
				if brains >= 250 then
					attacker:UnlockAchievement("eredicator")
					if brains >= 1000 then
						attacker:UnlockAchievement("annihilator")
					end
				end
			end	
		end
			
		if dmginfo:IsPhysDamage() then
			attacker.PropKills = attacker.PropKills + 1
			attacker:UnlockAchievement("launchanddestroy")
			local propks = attacker.PropKills
			if propks >= 3 then
				attacker:UnlockAchievement("toolsofdestruction")
			end
		end
			
		if attacker:IsHeadcrab() or attacker:IsPoisonCrab() == 7 then -- (fast) headcrab kill
			attacker.HeadCrabKills = attacker.HeadCrabKills + 1
			local hcks = attacker.HeadCrabKills
			if hcks >= 2 then
				attacker:UnlockAchievement("headhumper")
				if hcks >= 4 then
					attacker:UnlockAchievement("headfucker")
				end
			end
		end

		if attacker.Class == 8 and not dmginfo:IsSuicide(pl) and dmginfo:IsExplosionDamage() then
			attacker.ZombineKills = attacker.ZombineKills + 1		
			local zks = attacker.ZombineKills		
			if zks >= 2 then
				attacker:UnlockAchievement("zombine")	
			end
		end
		
		if attacker.Class == 4 and not dmginfo:IsSuicide(pl) then
			attacker.GhastKills = attacker.GhastKills + 1		
			local gks = attacker.GhastKills
			if gks >= 2 then
				attacker:UnlockAchievement("ghast")	
			end
		end		
		
		if attacker.Class == 6 and not dmginfo:IsSuicide(pl) then
			attacker.HowlerKills = attacker.HowlerKills + 1		
			local gks = attacker.HowlerKills
			if gks >= 3 then
				attacker:UnlockAchievement("howler")	
			end
		end				
		
		if attacker.Class == 7 and not dmginfo:IsSuicide(pl) then -- poison headcrab kill
			attacker:UnlockAchievement("slowdeath")
		end
		
		if not attacker.TookHit then
			attacker:UnlockAchievement("ghost")
		end
			
		if pl.VoiceSet == "female" then
			attacker:UnlockAchievement("sexistzombie")
		end
			
		if pl:IsAdmin() then
			attacker:UnlockAchievement(">:(")
		end
	end
		
	if attacker:Team() == TEAM_HUMAN then
		--Score for this round
		local kills = attacker.ZombiesKilled
		if kills >= 20 then
			attacker:UnlockAchievement("private")
			if kills >= 40 then
				attacker:UnlockAchievement("corporal")
				if kills >= 60 then
					attacker:UnlockAchievement("sergeant")
					if kills >= 100 then
						attacker:UnlockAchievement("fuckingrambo")
					end
				end
			end
		end	
		
		--Total killed
		kills = attacker:GetScore("undeadkilled")
		if kills and kills >= 300 then
			attacker:UnlockAchievement("spartan")
			if kills >= 1000 then
				attacker:UnlockAchievement("angelofwar")
				if kills >= 10000 then
					attacker:UnlockAchievement("angelofhope")
				end
			end
		end	
		
		--TODO: Optimize this more
		if not dmginfo:IsSuicide(pl) then
			if pl.Class == 2 and not pl:OnGround() and pl:GetVelocity():Length() >= 1000 then -- kill a fast zombie in mid-air
				attacker:UnlockAchievement("marksman")
				-- skillpoints.AchieveSkillShot(attacker,pl,"deadflight")
			elseif pl.Class == 10 then
				attacker:UnlockAchievement("hate")
			elseif pl.Class == 11 then
				attacker:UnlockAchievement("bhkill")
			end
		end
		
		-- check for melee kills
		if dmginfo:IsMeleeDamage() then-- if meleekill then
			attacker.MeleeKills = attacker.MeleeKills + 1
			if attacker:Health() <= 10 then
				attacker:UnlockAchievement("laststand")
			end
			local meleeks = attacker.MeleeKills
			if meleeks >= 5 then
				attacker:UnlockAchievement("ninja")
				if meleeks >= 10 then
					attacker:UnlockAchievement("samurai")
				end
			end
		end
			
		if pl:IsAdmin() then
			attacker.ZombieAdminsKilled = attacker.ZombieAdminsKilled + 1
			if attacker.ZombieAdminsKilled >= 5 then
				attacker:UnlockAchievement(">>:o")
			end
		end
	end
		
	if pl.LastHumanTime then
		local length = CurTime() - pl.LastHumanTime
		if length >= 60 then
			pl:UnlockAchievement("runningmeatbag")
			if length >= 300 then
				pl:UnlockAchievement("hidinkitchencloset")
			end
		end
	end
end