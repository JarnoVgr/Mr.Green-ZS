-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg
local ents = ents
local tostring = tostring

BONUS_RESISTANCE = false

-- Scales player damage (called before others)
local function ScalePlayerDamage( pl, attacker, inflictor, dmginfo )
	
	local ct = CurTime()
	
	-- Player not ready
	if not pl.Ready then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	-- Scale fire damage
	if dmginfo:IsFireDamage() then
		pl.dmgNextFire = pl.dmgNextFire or 0
		if pl.dmgNextFire > ct then
			dmginfo:SetDamage( 0 )
			return true
		end
		
		--  5 damage per second
		--dmginfo:SetDamage( pl:GetMaximumHealth() * 0.05 )
		dmginfo:SetDamage( math.random(5,15) )
		pl.dmgNextFire = ct + 1
	end
			
	-- Scale drown damage
	if dmginfo:IsDrownDamage() then
		pl.dmgNextDrown = pl.dmgNextDrown or 0
		if pl.dmgNextDrown > ct then 
			dmginfo:SetDamage( 0 )
			return true
		end
		
		--  10 damage per second
		dmginfo:SetDamage( pl:GetMaximumHealth() * 0.1 )
		pl.dmgNextDrown = ct + 1
	end		
	
	-- Physbox team-damage bug
	if dmginfo:IsAttackerPhysbox() then
		local mPhysAttacker = dmginfo:GetAttacker():GetPhysicsAttacker()
		if IsEntityValid( mPhysAttacker ) and mPhysAttacker:IsPlayer() then
		
			-- Set attacker
			dmginfo:SetAttacker( mPhysAttacker )
			attacker = mPhysAttacker
		end
	end
	
	if attacker:GetClass() == "env_explosion" and pl:IsHuman() and pl == attacker:GetOwner() then
		dmginfo:ScaleDamage ( 0.45 )
	end
	
	if attacker:GetClass() == "zs_turret" then
		if pl:IsHuman() then 
			if pl == attacker:GetTurretOwner() then
				dmginfo:SetDamage( attacker.Damage/2 )
			else
				dmginfo:SetDamage( 0 )
			end
		elseif pl:IsZombie() then
			dmginfo:SetDamage( attacker.Damage )
		end
	return true		
	end
	
	if attacker:GetClass() == "zs_miniturret" then
		if pl:IsHuman() then 
			dmginfo:SetDamage( 0 )
		elseif pl:IsZombie() then
			dmginfo:SetDamage( attacker.Damage )
		end
	return true		
	end
	
	-- Self-inflicted phys damage
	if dmginfo:IsPhysHurtingSelf( pl ) then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	-- Damage by unowned props on player
	
	--[==[if dmginfo:IsPhysDamage() then
		if not dmginfo:IsAttackerPlayer() and not dmginfo:IsInflictorPlayer() then
			if string.find( tostring( dmginfo:GetAttacker():GetClass() ), "prop" ) then
				if dmginfo:GetAttacker():IsPickupEntity() or dmginfo:GetAttacker().Nails then
					--pl:EmitSound("vo/npc/male01/pardonme01.wav")
					dmginfo:SetDamage( 0 )
					return true
				end
			end
		end
	end]==]
	--remove unnesessary damage
	if dmginfo:IsPhysDamage() then
		if not dmginfo:IsAttackerPlayer() and not dmginfo:IsInflictorPlayer() then
				if dmginfo:GetAttacker().IsObjEntity then
					dmginfo:SetDamage( 0 )
					return true
				end
		end
	end
	
	--[=[
	if dmginfo:IsPhysDamage() then
		if not dmginfo:IsAttackerPlayer() and not dmginfo:IsInflictorPlayer() then
			local fVelocity, fVicVelocity = dmginfo:GetAttacker():GetVelocity():Length(), pl:GetVelocity():Length()
			
			-- Check for func_ or door_
			local Filter, bCrasherFound = { "func_", "door" }
			for k,v in pairs ( Filter ) do
				if string.find( tostring( dmginfo:GetAttacker():GetClass() ), v ) then
					if not dmginfo:IsAttackerPhysbox() then
						pl.dmgNextCrush = pl.dmgNextCrush or 0
						if pl.dmgNextCrush > CurTime() then
							dmginfo:SetDamage( 0 )
							return true
						end
						
						--  10% of maximum health per second
						dmginfo:SetDamage( pl:GetMaximumHealth() * 0.15 )
						pl.dmgNextCrush = CurTime() + 1
						bCrasherFound = true
					end
				end
			end				
			
			-- Block unwanted unowned prop dmg
			if not bCrasherFound then
				if fVelocity < 120 or dmginfo:GetAttacker():IsOnGround() then
					dmginfo:SetDamage( 0 )
					return true
				end
			end
		end
	end
	]=]
	-- No phys damage between humans and zombies
	if dmginfo:IsAttackerHuman() then
		if pl:IsZombie() then
			if dmginfo:IsPhysDamage() then
				dmginfo:SetDamage( 0 )
				return true
			end
		end
	end
	
	if dmginfo:IsExplosionDamage() then
		if pl.NoExplosiveDamage and pl.NoExplosiveDamage >= CurTime() then
			dmginfo:ScaleDamage( 0.5 )
		end		
	end
		
	-- Check for friendly fire
	if dmginfo:IsPlayerFriendlyFire( pl ) then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	-- Fix all zombie gun exploits in one go
	if dmginfo:IsAttackerPlayer() and dmginfo:GetAttacker():Team() ~= pl:Team() then
		if ( dmginfo:IsAttackerZombie() and dmginfo:IsBulletDamage() ) then
			dmginfo:SetDamage( 0 )
			return true
		end
	end
	
	-- Zombies with howler protection
	if dmginfo:IsAttackerHuman() and pl:IsZombie() then
					--[==[if math.random(1,3) == 1 then
						if dmginfo:IsBulletDamage() or dmginfo:IsMeleeDamage() then
							local effectdata = EffectData()
							effectdata:SetEntity(pl)
							effectdata:SetOrigin(dmginfo:GetDamagePosition())
							effectdata:SetMagnitude(math.random(3, 5))
							effectdata:SetScale(0)
							util.Effect("bloodstream", effectdata, true, true)
							-- effectdata:SetNormal(dmginfo:GetDamageForce())--effectdata:SetNormal(( pl:GetShootPos() - dmginfo:GetAttacker():GetShootPos() ):Normalize())
							-- util.Effect("bloodhit", effectdata, true, true )
						end
					end]==]
		if dmginfo:IsBulletDamage() and pl:HasHowlerProtection() then
			if math.random(3) == 3 then
				-- Play metal sound
				WorldSound( "physics/metal/metal_box_impact_bullet"..math.random( 1, 3 )..".wav", pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )
				
				-- Show spark effect
				local Spark = EffectData()
					Spark:SetOrigin( dmginfo:GetDamagePosition() )
					Spark:SetMagnitude( 50 )
					Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
				util.Effect( "MetalSpark", Spark, nil, true )
			end
			
			dmginfo:SetDamage( 0 )
			return true
		end
	end
	
	-- Triple headshot damage
	if pl:IsZombie() then
		-- print(dmginfo:GetDamageType())
		if pl:GetAttachment( 1 ) then 
			if (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( 1 ).Pos )) < 15 then
			if dmginfo:IsBulletDamage() then
				dmginfo:SetDamage ( dmginfo:GetDamage() * 2.0 )
			elseif dmginfo:IsMeleeDamage() then
				dmginfo:SetDamage ( dmginfo:GetDamage() * 1.5 )  -- 2.5
			else
				dmginfo:SetDamage ( dmginfo:GetDamage() * 1 )
			end
			--dmginfo:SetDamage ( 150 )  -- 2.5
			end
		end
	end
	
	--  -35% damage for zombine (armor)
	if pl:IsZombie() then
		if pl:IsZombine() then
			if (pl:Health() <= math.Round(pl:GetMaximumHealth() * 0.75)) and pl:Health() ~= 0 and pl.bCanSprint == false then
				pl.bCanSprint = true
				pl:SendLua( "WraithScream()" )
				pl:EmitSound( Sound ( "npc/zombine/zombine_charge"..math.random ( 1,2 )..".wav" ) )
			end
			if pl.bCanSprint then
				if dmginfo:IsBulletDamage()	then
					if (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( 1 ).Pos )) > 14 then
						if math.random(3) == 3 then
							WorldSound( "weapons/fx/rics/ric"..math.random(1,5)..".wav", pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )

							local Spark = EffectData()
								Spark:SetOrigin( dmginfo:GetDamagePosition() )
								Spark:SetMagnitude( 50 )
								Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
							util.Effect( "MetalSpark", Spark, nil, true )
						end
					end
				end	
				
				if not pl.HoldingGrenade then
					if pl:GetAttachment( 1 ) then 
						if (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( 1 ).Pos )) < 10 then	
							dmginfo:ScaleDamage ( 0.7 )
						else
							dmginfo:ScaleDamage ( 0.25 )
						end
					end		
				else
					if pl:GetAttachment( 1 ) then 
						if (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( 1 ).Pos )) < 10 then	
							dmginfo:ScaleDamage ( 0.8 )
						else
							dmginfo:ScaleDamage ( 0.2 )
						end
					end	
				end
				
			else
				dmginfo:ScaleDamage ( 0.8 )
			end
			
		end
	end
	
	-- starting zombies
	if pl:IsZombie() and not pl:IsZombine() then
		if pl:IsStartingZombie() and GAMEMODE:GetFighting() then
			if dmginfo:IsBulletDamage()	then
				if math.random(3) == 3 then
					WorldSound( "weapons/fx/rics/ric"..math.random(1,5)..".wav", pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )

					local Spark = EffectData()
						Spark:SetOrigin( dmginfo:GetDamagePosition() )
						Spark:SetMagnitude( 50 )
						Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
					util.Effect( "MetalSpark", Spark, nil, true )
				end
				dmginfo:ScaleDamage ( 0.85 )
			end
		end
	end
	-- one boss
	if pl:IsZombie() and pl:GetZombieClass() == 11 then
		if dmginfo:IsBulletDamage()	then
			if (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( pl:LookupAttachment("head") ).Pos )) > 6.5 then
				if math.random(5) == 5 then
					WorldSound( "weapons/fx/rics/ric"..math.random(1,5)..".wav", pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )

					local Spark = EffectData()
						Spark:SetOrigin( dmginfo:GetDamagePosition() )
						Spark:SetMagnitude( 50 )
						Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
					util.Effect( "MetalSpark", Spark, true, true )
				end
				dmginfo:ScaleDamage ( 0.07 )
			end
		end
	end
	
	
	--  Fall damage
	if dmginfo:IsFallDamage() then
		dmginfo:SetDamage( 0 )
			
		-- Fall damage for humans
		if pl:IsHuman() then
			local speed, div_factor = math.abs( pl:GetVelocity().z ), 14
			local Damage = math.Clamp ( speed / div_factor, 5, 90 )
				
			-- Shake camera
			if pl.ViewPunch then pl:ViewPunch ( Angle ( math.random ( -45,45 ),math.random ( -15,15 ),math.random ( -10,10 ) ) ) end 
			
			if pl:GetPerk("_falldmg") then
				dmginfo:AddDamage( Damage*0.75 )
			-- if pl:HasBought("bootsofsteel")	and math.random(1,4) == 1 then
				-- dmginfo:SetDamage( 0 )
			else
				-- Add new damage
				dmginfo:AddDamage( Damage )
			end
			if pl:Alive() then
				pl:GiveStatus("knockdown",3)
			end
		else
			return true
		end
	end
	
	-- Clamp phys damage
	if dmginfo:GetAttacker():IsPlayer() then
		local Inflictor = dmginfo:GetInflictor()
		if Inflictor:GetClass() == "prop_physics" or Inflictor:GetClass() == "prop_physics_multiplayer" or Inflictor:GetClass() == "func_physbox" or Inflictor:GetClass() == "func_physbox_multiplayer" then-- if string.find ( Inflictor:GetClass(), "prop_physics" ) or string.find ( Inflictor:GetClass(), "physbox" ) then
			if pl:IsPlayer() and pl:Team() ~= dmginfo:GetAttacker():Team() then
				local MaximumVictimHealth = pl:GetMaximumHealth()
				local InitialDamage, NewDamage, Percentage = dmginfo:GetDamage(), dmginfo:GetDamage(), 0.45
				
				-- Phys damage cooldown -- so we don't hit it with great damage 2 times in one frame
				if pl.PhysCooldownDamage == nil then pl.PhysCooldownDamage = 0 end
				if pl.PhysCooldownDamage > ct then return 0 end
				
				if InitialDamage >= MaximumVictimHealth * Percentage then
					NewDamage = MaximumVictimHealth * Percentage
				end
				
				if InitialDamage < MaximumVictimHealth * Percentage then
					NewDamage = MaximumVictimHealth * Percentage
				end
				
				-- Next damage in the next frame
				pl.PhysCooldownDamage = ct + 0.05
					
				-- Apply damage
				dmginfo:SetDamage ( NewDamage )
				
				local phys = Inflictor:GetPhysicsObject()
				
				if phys:IsValid() then
					if phys:GetVelocity():Length() > 320 then
						if pl:Alive() then
							pl:GiveStatus("knockdown",math.Rand(2.1,3))
						end
					end
				end
			end
		end
	end
	
	-- Zombies with howler prot have reduced damage by 80%
	if dmginfo:IsAttackerZombie() and pl:IsHuman() then
		if dmginfo:GetAttacker():HasHowlerProtection() then
			dmginfo:SetDamage( dmginfo:GetDamage() * 0.2 )
		end
			local effectdata = EffectData()
			effectdata:SetEntity(pl)
			effectdata:SetOrigin(dmginfo:GetDamagePosition())
			-- effectdata:SetNormal(dmginfo:GetDamageForce())--effectdata:SetNormal(( pl:GetShootPos() - dmginfo:GetAttacker():GetShootPos() ):Normalize())
			-- util.Effect("bloodhit", effectdata)
			
			effectdata:SetMagnitude(5)
			effectdata:SetScale(0)
			util.Effect("bloodstream", effectdata, nil, true)
	end
	
	-- Normal enraged zombies
	if dmginfo:IsAttackerHuman() and pl:IsZombie() then
		if pl:IsZombieInRage() and dmginfo:IsBulletDamage() then
			
			-- Sometimes play metal sound, sometimes flesh ...
			local iRandom, fSound = math.random( 1, 2 ), "physics/flesh/flesh_impact_bullet"..math.random( 1, 4 )..".wav"
			
			-- Metal sound
			if iRandom == 1 then
				fSound = "physics/metal/metal_box_impact_bullet"..math.random( 1, 3 )..".wav"
				WorldSound( fSound, pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )
			end
			
			-- Show spark effect
			if Random == 1 then
				local Spark = EffectData()
					Spark:SetOrigin( dmginfo:GetDamagePosition() )
					Spark:SetMagnitude( 50 )
					Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
				util.Effect( "MetalSpark", Spark, nil, true )
			end
			
			-- Reduce damage by 100% on random chance, else only 50%
			if Random == 1 then dmginfo:SetDamage( 0 ) return true else dmginfo:SetDamage( dmginfo:GetDamage() * 0.5 ) end
		end
	end
	
	-- Multi damage scale
	GAMEMODE:ScalePlayerMultiDamage( pl, attacker, inflictor, dmginfo )	
	
	-- Identify our last attacker and inflictor
	pl:InsertLastDamage( dmginfo:GetPlayerAttacker(), dmginfo:GetInflictor() )
end
hook.Add( "ScalePlayersDamage", "ScalePlayersDamage", ScalePlayerDamage )

-- Multi-damage nerf
function GM:ScalePlayerMultiDamage( pl, attacker, inflictor, dmginfo )
	if not attacker:IsPlayer() then return end

	-- Damage caused by humans to zombos
	if attacker:IsHuman() and pl:IsZombie() then
		local vHumanPos = attacker:GetPos()
		
		-- Ents around attacker, damage
		local fDamage, fFinalDamage = dmginfo:GetDamage()
		
		-- Get nr of humans around attacker
		local iHumans = 0
		-- for k,v in pairs ( tbHumans ) do
			-- if v:IsPlayer() and v:IsHuman() and v:Alive() and v ~= attacker then
			-- 	iHumans = iHumans + 1
			-- end
		-- end
		
		-- Bullet force
		--[==[if dmginfo:IsBulletDamage() then
			
			-- Bullet force limit
			local iBulletLimit = 700
			
			-- Check distance
			local fDistance = attacker:GetPos():Distance( pl:GetPos() )
			fDamage = math.Clamp(( ( ( ( iBulletLimit / 2 - fDistance ) / ( iBulletLimit / 2 ) ) * 0.3 ) * fDamage ) + fDamage,dmginfo:GetDamage()*0.8,dmginfo:GetDamage()*1.1)
			
			-- Extend distance
			if fDistance > iBulletLimit * 0.5 then
				
				fDamage = ( ( 1 - math.Clamp( fDistance / ( iBulletLimit * 2 ), 0.1, 1 ) ) * dmginfo:GetDamage() )
			end
		end]==]

		-- Calcualte final damage
		if dmginfo:IsBulletDamage() then
			fFinalDamage = fDamage
			fFinalDamage = fFinalDamage*1			
		elseif dmginfo:IsMeleeDamage() then
			fFinalDamage = fDamage*0.9
		else
			fFinalDamage = fDamage*0.9
		end
		-- Set the damage
		if not fFinalDamage then fFinalDamage = fDamage*0.9 end -- just to be sure that its fine
		
		
		if LASTHUMAN then
			if attacker:HasBought("lastmanstand") then
				--fFinalDamage = fFinalDamage * 1.35
			end
		end
		
		if dmginfo:IsBulletDamage() then
			fFinalDamage =fFinalDamage*1
		end
		
		
		if attacker:HasSpawnProtection() and not LASTHUMAN then
			fFinalDamage = fFinalDamage + fFinalDamage*pl:GetSpawnDamagePercent()
		end
		
		local bonus = 0
		
		if BONUS_RESISTANCE then 
			bonus = BONUS_RESISTANCE_AMOUNT/100
		end
		
		-- horde resistance
		if not ARENA_MODE then
			fFinalDamage = fFinalDamage - fFinalDamage*(pl:GetHordePercent() + bonus)
		end
		
		dmginfo:SetDamage( fFinalDamage )
		
	end
	
	-- Damage caused by zombies to humans
	if attacker:IsZombie() and pl:IsHuman() then
		local vZombiePos = attacker:GetPos()
		
		-- Ents around the attacker
		local fDamage, fFinalDamage = dmginfo:GetDamage()
		
		-- Get zombo focus
		local iZombies = 0
		-- for k,v in pairs ( tbZombies ) do
		-- 	if v:IsPlayer() and v:IsZombie() and v:Alive() then
		-- 		iZombies = iZombies + 1
		-- 	end
		-- end
		
		-- Calculate final damage
		fFinalDamage = fDamage -- math.Clamp( fDamage - ( fDamage * ( math.Clamp( iZombies, 0, 9 ) / 10 ) ), 1, 250 )
				
		-- Set damage
		dmginfo:SetDamage( fFinalDamage )
		-- print( "Damage for "..tostring( attacker ).." is "..tostring( fFinalDamage )..".Original: "..tostring( fDamage ) )
	end
end
