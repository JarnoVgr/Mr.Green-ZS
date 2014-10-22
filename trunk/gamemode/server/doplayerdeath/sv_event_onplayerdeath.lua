-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- On player death
local function OnPlayerDeath( mVictim, mAttacker, mInflictor, dmginfo )
	-- Check original achievments
	if mAttacker:IsPlayer() then
		GAMEMODE:DoAchievementsCheck ( mVictim, mAttacker, mInflictor, dmginfo )
	end

	local headshot = false
	
	-- Only for player attackers
	if dmginfo:IsAttackerPlayer() then
	
		--Add bonus for prop-kills
		if dmginfo:IsPhysDamage() then
			if mVictim:IsHuman() and mAttacker:IsZombie() then
				mAttacker:AddScore(1)
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"propkill")
			end
		end
		
		if mVictim.DiedFromFlare and mVictim.DiedFromFlare > CurTime() then
			timer.Simple(0,function()
				if not IsValid(mVictim) then return end
				local rag = mVictim:GetRagdollEntity()
				if IsValid(rag) then
					rag:Ignite(9)
					rag:SetColor(Color(50,50,50,255))
				end
			end)
			local e = EffectData()
			e:SetEntity( mVictim )
			util.Effect( "fire_death", e, true, true )
			mVictim.DiedFromFlare = nil
		end
		
		if mVictim:IsHuman() and mAttacker:IsZombie() then
			if mAttacker:GetZombieClass() == 5 then
				mVictim:Dismember("HEAD",dmginfo)
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"screamtherapy")
				--[[if mVictim:GetHumanClass() == 3 then
					skillpoints.AchieveSkillShot(mAttacker,mVictim,"crime")
				end]]
			else
				if mAttacker:GetZombieClass() == 10 then
					mVictim:Dismember("SAWED",dmginfo)
				end
			end
		end
		
		if mVictim:IsZombie() and mAttacker:IsZombie() then
			if mAttacker:GetZombieClass() == 10 then
				mVictim:Dismember("SAWED",dmginfo)
			end
		end
		
		-- Melee kill
		if dmginfo:IsMeleeDamage() and not mInflictor.IsTurretDmg then
			if dmginfo:IsAttackerPlayer() then
				-- mAttacker:AddScore(1)
				skillpoints.AddSkillPoints(mAttacker,5)
				mVictim:FloatingTextEffect( 5, mAttacker )
			end
		end
		
		-- Headshot
		if mVictim:GetAttachment( 1 ) then 
			if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 15 then
				if not dmginfo:IsMeleeDamage() then
				
					--[[if not mInflictor.IsTurretDmg then
						mAttacker:AddScore(1)
					end]]
					
					--mVictim:EmitSound( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav" )
					
					headshot = true
				
					-- Effect
					--[[local effectdata = EffectData()
						effectdata:SetOrigin( mVictim:GetAttachment(1).Pos )
						effectdata:SetNormal( dmginfo:GetDamageForce():GetNormal() )
						effectdata:SetMagnitude( dmginfo:GetDamageForce():Length() * 3 )
						effectdata:SetEntity( mVictim )]]
					-- util.Effect( "headshot", effectdata, true, true )
					
					-- mVictim:Dismember("HEAD",dmginfo)

				elseif dmginfo:IsMeleeDamage() and (mInflictor:GetClass() == "weapon_zs_melee_axe" or mInflictor:GetClass() == "weapon_zs_melee_katana") and not mInflictor.IsTurretDmg then
					
					if math.random(1,3) == 1 --[=[or mAttacker:HasBought("homerun") and math.random(1,2) == 1 ]=]then
					-- Berserker's decapitation requirement -------------------------------------------------
						if mAttacker:IsHuman() and mVictim:IsZombie() and mAttacker:GetHumanClass() == 3 then
							if mAttacker:GetTableScore("berserker","level") == 4 then
								if mAttacker:GetTableScore("berserker","achlevel4_1") < 1337 then
								--mAttacker:AddTableScore ("berserker","achlevel4_1",1)
								end
							elseif mAttacker:GetTableScore("berserker","level") == 5 then
								if mAttacker:GetTableScore("berserker","achlevel4_1") < 4000 then
								--mAttacker:AddTableScore ("berserker","achlevel4_1",1)
								end
							end
						end
				-- -------------------------------------------------------------------------------------------------
				--[[skillpoints.AddSkillPoints(mAttacker,5)
				mAttacker:AddScore(1)
				mVictim:Dismember("DECAPITATION",dmginfo)
				skillpoints.AchieveSkillShot(mAttacker,mVictim,"decapitation")
				mAttacker:CheckLevelUp()]]
					end
				end
			end
		end
	end

	-- Clear the weapons limit number
	for k,v in pairs ( mVictim.CurrentWeapons ) do
		mVictim.CurrentWeapons[k] = 0
	end
	
	--  Make the player splash (gib) if damage is very big or if it's a chem zombie otherwise make the ragdolls.
	
	if mVictim:IsZombie() then
		if mVictim:Health() < -45 and not (dmginfo:IsMeleeDamage() or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage()) then
			-- Gib the player
			if ZombieClasses[ mVictim:GetZombieClass() ].CanGib then 
				mVictim:Gib( dmginfo ) 
				mVictim.Gibbed = true
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"meatshower")
				skillpoints.AddSkillPoints(mAttacker,5)
				mVictim:FloatingTextEffect( 5, mAttacker )
				
				-- New commando's reqs--------------------------------------
				
				---------------------------------------------------------------------
				
				if mVictim:GetZombieClass() == 1 and mAttacker:IsPlayer() and mAttacker:IsHuman() and (mInflictor:GetClass() == "weapon_zs_boomstick" or mInflictor:GetClass() == "weapon_zs_grenadelauncher") then
					mVictim:LegsGib()
					--skillpoints.AchieveSkillShot(mAttacker,mVictim,"pants")	
				end
				--[[else
					skillpoints.AchieveSkillShot(mAttacker,mVictim,"meatshower")
				end]]
			else
			-- Use dismemberment thing
			mVictim:CreateRagdoll()
				-- Left arm	
				if mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")).Pos )) < 12 and not dmginfo:IsMeleeDamage() then
					mVictim:Dismember("LARM",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
					
					
				---------------------------------------------------------------------
					
				-- Right arm
				elseif mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")).Pos )) < 12 and not dmginfo:IsMeleeDamage() then
					mVictim:Dismember("RARM",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
									-- New commando's reqs--------------------------------------
					
				---------------------------------------------------------------------
				-- Legs
				elseif mVictim:GetAttachment( mVictim:LookupAttachment("chest")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("chest")).Pos + Vector(0,0,-34) )) < 15 and not dmginfo:IsMeleeDamage() then
					mVictim:Dismember("RANDOMLEG",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"legssoff")
					
				
				---------------------------------------------------------------------
					
				end
			end
		elseif dmginfo:IsExplosionDamage() then
		local randonwound = math.random(1,4)
			if math.random(1,3) == 1 then
				mVictim:CreateRagdoll()
				if randonwound == 1 then
					mVictim:Dismember("LARM",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
				elseif randonwound == 2 then
					mVictim:Dismember("RARM",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
				elseif randonwound == 3 then
					mVictim:Dismember("RANDOMLEG",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"legssoff")
				else
					mVictim:Dismember("BOTHLEGS",dmginfo)
					-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"legssoff")
				end
			else
				mVictim:Gib( dmginfo ) 
			end
		else		
			mVictim:CreateRagdoll()
			-- Left arm	
			if mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")).Pos )) < 11 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("LARM",dmginfo)
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
			-- Right arm
			elseif mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")).Pos )) < 11 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("RARM",dmginfo)
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"handsoff")
			-- Legs
			elseif mVictim:GetAttachment( mVictim:LookupAttachment("chest")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("chest")).Pos + Vector(0,0,-34) )) < 15 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("RANDOMLEG",dmginfo)
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"legssoff")
			end
		end
	else
		if dmginfo:IsExplosionDamage() then
		local randonwound = math.random(1,4)
			mVictim:CreateRagdoll()
			
				if randonwound == 1 then
					mVictim:Dismember("LARM",dmginfo)
				elseif randonwound == 2 then
					mVictim:Dismember("RARM",dmginfo)
				elseif randonwound == 3 then
					mVictim:Dismember("RANDOMLEG",dmginfo)
				else
					mVictim:Dismember("BOTHLEGS",dmginfo)
				end

				mVictim:Gib( dmginfo ) 

		elseif dmginfo:IsFallDamage() then
			if math.random(1,2) == 1 then
				mVictim:CreateRagdoll()
				mVictim:Dismember("BOTHLEGS",dmginfo)
				mVictim:Gib( dmginfo ) 
			else
				mVictim:Gib( dmginfo ) 
			end
		else
			mVictim:CreateRagdoll()
		end
	end
	
	
		--  Logging
	if (mVictim:IsPlayer() and (mAttacker:IsPlayer() or mAttacker:IsWorld())) then
		
		local weapon_name = "world"
		if IsValid(mInflictor) then
			if (mInflictor.Inflictor) then
				weapon_name = mInflictor.Inflictor
			else
				weapon_name = mInflictor:GetClass()
			end
		end
		
		local properties = {}
		if (headshot) then
			properties["headshot"] = true
		end
		properties["victim_position"] = mVictim:GetPos()
		
		if (mVictim == mAttacker) then
			--log.PlayerSuicide( mVictim, weapon_name, properties )
		else
			if (mAttacker:IsPlayer()) then
				properties["attacker_position"] = mAttacker:GetPos()
			end
			
			--log.PlayerKill( mAttacker, mVictim, weapon_name, properties )
		end
	
	end
end
hook.Add( "OnPlayerDeath", "OnPlayerKilled", OnPlayerDeath )