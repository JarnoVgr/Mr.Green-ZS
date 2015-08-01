-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- On player death
local function OnPlayerDeath( mVictim, mAttacker, mInflictor, dmginfo )
	-- Check original achievments
	if mAttacker:IsPlayer() then
		--Set next spawn
		if CurTime() <= WARMUPTIME then
			mVictim.NextSpawn = WARMUPTIME + 2
		else
			mVictim.NextSpawn = CurTime() + 2
		end
		mVictim:SendLua("MySelf.NextSpawn = ".. mVictim.NextSpawn)

		--Achievements
		--TODO: Check if we can do this at a later point (in a timer or so)
		GAMEMODE:DoAchievementsCheck(mVictim, mAttacker, mInflictor, dmginfo)
	end

	local headshot = false
	
	if mVictim:IsOnFire() then
	   mVictim:Extinguish()
	end	
	
	-- Only for player attackers
	if dmginfo:IsAttackerPlayer() then	
		if mVictim.DiedFromFlare and mVictim.DiedFromFlare > CurTime() then
			timer.Simple(0,function()
				if not IsValid(mVictim) then
					return
				end
				
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

		
		-- Melee kill
		if dmginfo:IsMeleeDamage() and not mInflictor.IsTurretDmg then
			if dmginfo:IsAttackerPlayer() then
				-- mAttacker:AddScore(1)
				if mAttacker:GetPerk("_berserker") then
					if mAttacker:GetPerk("_bloodmoney") then
						skillpoints.AddSkillPoints(mAttacker,3)
						
						else
						return
					end
				end	
			end
		end
		
		-- Headshot
		if mVictim:GetAttachment( 1 ) then 
			if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 15 then
					headshot = true
			end
		end
	end

	--Clear the weapons limit number
	for k,v in pairs ( mVictim.CurrentWeapons ) do
		mVictim.CurrentWeapons[k] = 0
	end
	
	--Make the player splash (gib) if damage is very big or if it's a chem zombie otherwise make the ragdolls.
	if mVictim:IsZombie() then
		if mVictim:Health() < -45 and not (dmginfo:IsMeleeDamage() or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage()) then
			-- Gib the player
			if ZombieClasses[ mVictim:GetZombieClass() ].CanGib then 
				mVictim:Gib( dmginfo ) 
				mVictim.Gibbed = true

				skillpoints.AddSkillPoints(mAttacker,5)
				mVictim:FloatingTextEffect( 5, mAttacker )
				
				-- New commando's reqs--------------------------------------
				
				---------------------------------------------------------------------
				
				if mVictim:GetZombieClass() == 1 and mAttacker:IsPlayer() and mAttacker:IsHuman() and (mInflictor:GetClass() == "weapon_zs_boomerstick" ) then
					mVictim:LegsGib()
				end

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
		--	mVictim:CreateRagdoll()
			if math.random(1,3) == 1 then
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
			else
				mVictim:Gib( dmginfo ) 
			end
		else		
			mVictim:CreateRagdoll()
			-- Left arm	
			if mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_left")).Pos )) < 11 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("LARM",dmginfo)
			-- Right arm
			elseif mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("Blood_right")).Pos )) < 11 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("RARM",dmginfo)
			-- Legs
			elseif mVictim:GetAttachment( mVictim:LookupAttachment("chest")) and (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( mVictim:LookupAttachment("chest")).Pos + Vector(0,0,-34) )) < 15 and not dmginfo:IsMeleeDamage() then
				mVictim:Dismember("RANDOMLEG",dmginfo)
			end
		end
	else
		if dmginfo:IsExplosionDamage() then
			mVictim:CreateRagdoll()
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

		end
	
	end
end
hook.Add( "OnPlayerDeath", "OnPlayerKilled", OnPlayerDeath )