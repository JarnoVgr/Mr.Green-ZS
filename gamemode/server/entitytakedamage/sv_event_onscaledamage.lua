-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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
	--Player not ready
	if not pl.Ready then
		dmginfo:SetDamage(0)
		return true
	--Check for friendly fire
	elseif dmginfo:IsPlayerFriendlyFire(pl) then
		dmginfo:SetDamage(0)
		return true	
	--Scale drown damage
	elseif dmginfo:IsDrownDamage() then
		pl.dmgNextDrown = pl.dmgNextDrown or 0

		if pl.dmgNextDrown > CurTime() then 
			dmginfo:SetDamage( 0 )
		else
			--10 damage per second
			dmginfo:SetDamage(pl:GetMaximumHealth() * 0.1)
			pl.dmgNextDrown = CurTime() + 1
		end

		return true
	--Scale damage for THE Gordon Freeman
	elseif attacker.IsFreeman and attacker:IsHuman() and dmginfo:IsMeleeDamage() then
		dmginfo:ScaleDamage(1.2)
	end
	
	--Physbox team-damage bug
	if dmginfo:IsAttackerPhysbox() then
		local mPhysAttacker = dmginfo:GetAttacker():GetPhysicsAttacker()
		if IsEntityValid(mPhysAttacker) and mPhysAttacker:IsPlayer() then
			-- Set attacker
			dmginfo:SetAttacker(mPhysAttacker)
			attacker = mPhysAttacker
		end
	end

	--Make humans invulnerable for AR2 grenades (used by the grenade launcher)
	if ((attacker:GetClass() == "grenade_ar2" or attacker:GetClass() == "weapon_zs_grenadelauncher") and pl:IsHuman()) then
		dmginfo:SetDamage(0)
		return true
	--Scale down own AR2 grenades (grenade launcher) shots
	elseif (attacker:GetClass() == "player" and pl:IsHuman() and attacker:IsHuman()) then
		dmginfo:ScaleDamage(0.05)
	--Scale down explosion damage if it's the owner
	elseif (attacker:GetClass() == "env_explosion" and pl:IsHuman() and pl == attacker:GetOwner()) then
		dmginfo:ScaleDamage(0.45)
	--Turret damage
	elseif attacker:GetClass() == "zs_turret" then
		if pl:IsHuman() then
			if pl == attacker:GetTurretOwner() then
				dmginfo:SetDamage(attacker.Damage/2)
			else
				dmginfo:SetDamage(0)
			end
		elseif pl:IsZombie() then
			dmginfo:SetDamage(attacker.Damage)
		end

		return true
	elseif attacker:GetClass() == "zs_miniturret" then
		if pl:IsHuman() then
			dmginfo:SetDamage(0)
		elseif pl:IsZombie() then
			dmginfo:SetDamage(attacker.Damage)
		end

		return true
	end
	
	--Self-inflicted phys damage
	if dmginfo:IsPhysHurtingSelf(pl) then
		dmginfo:SetDamage(0)

		return true
	end

	--remove unnesessary damage
	if dmginfo:IsPhysDamage() and not dmginfo:IsAttackerPlayer() and not dmginfo:IsInflictorPlayer() and dmginfo:GetAttacker().IsObjEntity then
		dmginfo:SetDamage(0)

		return true
	end

	-- No phys damage between humans and zombies
	if dmginfo:IsAttackerHuman() and pl:IsZombie() and dmginfo:IsPhysDamage() then
		dmginfo:SetDamage(0)

		return true
	end
	
	--Check for explosion damage immunity
	if dmginfo:IsExplosionDamage() and pl.NoExplosiveDamage and pl.NoExplosiveDamage >= CurTime() then
		dmginfo:ScaleDamage(0.5)
	end
		
	--Zombies with howler protection
	if dmginfo:IsAttackerHuman() and pl:IsZombie() and dmginfo:IsBulletDamage() and pl:HasHowlerProtection() then
		if math.random(3) == 3 then
			--Play metal sound
			WorldSound("physics/metal/metal_box_impact_bullet".. math.random(1, 3) ..".wav", pl:GetPos() + Vector(0, 0, 30), 80, math.random(90, 110))
				
			--Show spark effect
			local Spark = EffectData()
			Spark:SetOrigin(dmginfo:GetDamagePosition())
			Spark:SetMagnitude(50)
			Spark:SetNormal(-1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal())
			util.Effect("MetalSpark", Spark, nil, true)
		end
			
		dmginfo:SetDamage(0)
		return true
	end

	if pl:IsZombie() then
		--Scale headshot damage
		if (dmginfo:IsBulletDamage() or dmginfo:IsMeleeDamage()) and pl:GetAttachment(1) then 
			if (dmginfo:GetDamagePosition():Distance(pl:GetAttachment(1).Pos)) < 15 then
				if dmginfo:IsBulletDamage() then
					dmginfo:SetDamage(dmginfo:GetDamage() * 1.4)
				elseif dmginfo:IsMeleeDamage() then
					dmginfo:SetDamage(dmginfo:GetDamage() * 1.1)
				end
			end
		end

		--35% damage for zombine (armor)
		if pl:IsZombine() and pl:Health() <= math.Round(pl:GetMaximumHealth() * 0.75) and pl:Health() ~= 0 and pl.bCanSprint == false then
			pl.bCanSprint = true
			pl:SendLua("WraithScream()")
			pl:EmitSound(Sound("npc/zombine/zombine_charge"..math.random ( 1,2 )..".wav"))
		end

		--One boss
		if dmginfo:IsBulletDamage() and pl:GetZombieClass() == 11 and (dmginfo:GetDamagePosition():Distance( pl:GetAttachment( pl:LookupAttachment("head") ).Pos )) > 6.5 then
			if math.random(5) == 5 then
				WorldSound( "weapons/fx/rics/ric"..math.random(1,5)..".wav", pl:GetPos() + Vector( 0,0,30 ), 80, math.random( 90, 110 ) )

				local Spark = EffectData()
				Spark:SetOrigin( dmginfo:GetDamagePosition() )
				Spark:SetMagnitude( 50 )
				Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
				util.Effect( "MetalSpark", Spark, true, true )
			end

			dmginfo:ScaleDamage(0.07)
		end
	end
	
	--Fall damage
	if dmginfo:IsFallDamage() then
		dmginfo:SetDamage(0)
			
		--Fall damage for humans
		if not pl:IsHuman() then
			return true
		end
		
		local speed, div_factor = math.abs(pl:GetVelocity().z), 24
		local Damage = math.Clamp(speed / div_factor, 5, 90)
				
		--Shake camera
		if pl.ViewPunch then
			pl:ViewPunch(Angle(math.random(-45, 45),math.random (-15, 15), math.random(-10, 10)))
		end 
			
		if pl:GetPerk("_falldmg") then
			dmginfo:AddDamage( Damage*0.75 )
		-- if pl:HasBought("bootsofsteel")	and math.random(1,4) == 1 then
			-- dmginfo:SetDamage( 0 )
		else
			-- Add new damage
			dmginfo:AddDamage(Damage)
		end

		if pl:Alive() then
			pl:GiveStatus("knockdown",3)
		end
	end
	
	-- Clamp phys damage
	if pl:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and pl:Team() ~= dmginfo:GetAttacker():Team() then
		local Inflictor = dmginfo:GetInflictor()
		if Inflictor:GetClass() == "prop_physics" or Inflictor:GetClass() == "prop_physics_multiplayer" or Inflictor:GetClass() == "func_physbox" or Inflictor:GetClass() == "func_physbox_multiplayer" then-- if string.find ( Inflictor:GetClass(), "prop_physics" ) or string.find ( Inflictor:GetClass(), "physbox" ) then
			local MaximumVictimHealth = pl:GetMaximumHealth()
			local InitialDamage, NewDamage, Percentage = dmginfo:GetDamage(), dmginfo:GetDamage(), 0.45
				
			-- Phys damage cooldown -- so we don't hit it with great damage 2 times in one frame
			if pl.PhysCooldownDamage == nil then
				pl.PhysCooldownDamage = 0 
			end

			if pl.PhysCooldownDamage > CurTime() then
				return 0
			end
				
			if InitialDamage >= MaximumVictimHealth * Percentage then
				NewDamage = MaximumVictimHealth * Percentage
			end
				
			if InitialDamage < MaximumVictimHealth * Percentage then
				NewDamage = MaximumVictimHealth * Percentage
			end
				
			-- Next damage in the next frame
			pl.PhysCooldownDamage = CurTime() + 0.05
					
			-- Apply damage
			dmginfo:SetDamage(NewDamage)
				
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
	
	-- Zombies with howler prot have reduced damage by 80%
	if dmginfo:IsAttackerZombie() and pl:IsHuman() then
		if dmginfo:GetAttacker():HasHowlerProtection() then
			dmginfo:SetDamage( dmginfo:GetDamage() * 0.2 )
		end

		local effectdata = EffectData()
		effectdata:SetEntity(pl)
		effectdata:SetOrigin(dmginfo:GetDamagePosition())
		effectdata:SetMagnitude(5)
		effectdata:SetScale(0)
		util.Effect("bloodstream", effectdata, nil, true)
	end
	
	--Normal enraged zombies
	if dmginfo:IsAttackerHuman() and pl:IsZombie() and pl:IsZombieInRage() and dmginfo:IsBulletDamage() then
		-- Sometimes play metal sound, sometimes flesh ...
		local iRandom, fSound = math.random( 1, 2 ), "physics/flesh/flesh_impact_bullet"..math.random(1, 4)..".wav"
			
		-- Metal sound
		if iRandom == 1 then
			fSound = "physics/metal/metal_box_impact_bullet"..math.random(1, 3)..".wav"
			WorldSound(fSound, pl:GetPos() + Vector( 0,0,30 ), 80, math.random(90, 110))
		end
			
		-- Show spark effect
		if iRandom == 1 then
			local Spark = EffectData()
			Spark:SetOrigin( dmginfo:GetDamagePosition() )
			Spark:SetMagnitude( 50 )
			Spark:SetNormal( -1 * ( dmginfo:GetDamagePosition() - dmginfo:GetAttacker():GetPos() ):GetNormal()  )
			util.Effect( "MetalSpark", Spark, nil, true )
		end
			
		-- Reduce damage by 100% on random chance, else only 50%
		if iRandom == 1 then
			dmginfo:SetDamage(0)
			return true
		else
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.5)
		end
	end
	
	--Multi damage scale
	--[[if attacker:IsPlayer() then
		GAMEMODE:ScalePlayerMultiDamage( pl, attacker, inflictor, dmginfo )	
	end]]
	
	-- Identify our last attacker and inflictor
	pl:InsertLastDamage(dmginfo:GetPlayerAttacker(), dmginfo:GetInflictor())
end
hook.Add("ScalePlayersDamage", "ScalePlayersDamage", ScalePlayerDamage)

-- Multi-damage nerf
function GM:ScalePlayerMultiDamage(pl, attacker, inflictor, dmginfo)
	-- Damage caused by humans to zombos
	if attacker:IsHuman() and pl:IsZombie() then
		local vHumanPos = attacker:GetPos()
		
		-- Ents around attacker, damage
		local fDamage, fFinalDamage = dmginfo:GetDamage()
		
		-- Calcualte final damage
		if dmginfo:IsBulletDamage() then
			fFinalDamage = fDamage
			--fFinalDamage = fFinalDamage*1			
		elseif dmginfo:IsMeleeDamage() then
			fFinalDamage = fDamage*0.9
		else
			fFinalDamage = fDamage*0.9
		end
		-- Set the damage
		
		-- Just to be sure that its fine
		if not fFinalDamage then
			fFinalDamage = fDamage*0.9
		end
		
		--[[if LASTHUMAN then
			if attacker:HasBought("lastmanstand") then
				fFinalDamage = fFinalDamage * 1.2
			end
		end]]
		
		--[[if dmginfo:IsBulletDamage() then
			fFinalDamage = fFinalDamage * 1
		end]]
		
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
