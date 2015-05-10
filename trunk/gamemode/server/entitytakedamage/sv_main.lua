-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Include all files inside this folder
for k, sFile in pairs ( file.Find( "zombiesurvival/gamemode/server/entitytakedamage/*.lua","lsv" ) ) do
	if not string.find( sFile, "main" ) then
		include( sFile )
	end
end

-- Main damage event
function GM:EntityTakeDamage(ent, dmginfo)	
	local damage = dmginfo:GetDamage()
	
	--End on null damage or at intermission
	if dmginfo:IsDamageNull() or ENDROUND then 
		dmginfo:SetDamage(0)
		return 
	end

	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if not ent:IsPlayer() then
		--Scale damage for Cade Buster item
		if (attacker:IsPlayer() and attacker:IsZombie() and attacker:HasBought("cadebuster")) or (attacker:GetOwner():IsPlayer() and attacker:GetOwner():HasBought("cadebuster") and attacker:GetOwner():IsZombie()) then  
			damage = damage * 2
		end
		
		--Damage nails and check if a nail died
		if ent:DamageNails(attacker, inflictor, damage, dmginfo) then 
			--Nails are fine. Let's not damage the prop
			if attacker:IsHuman() then
		    	return true		
			else
				dmginfo:ScaleDamage(0.05)
			end
		else
			--Multiply once a nail dies
			dmginfo:ScaleDamage(1.5)
		end
		
		local entclass = ent:GetClass()
		-- A prop that was invulnerable and converted to vulnerable.
		if ent.PropHealth then
			ent._LastAttackerIsHuman = false
		
			if IsValid(attacker) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and IsValid(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
				ent._LastAttackerIsHuman = true
				
			if attacker:GetClass() == "env_explosion" then
				dmginfo:ScaleDamage(0)
			end				
				
			end
			
			if not ent.TotalHealth then
				ent.TotalHealth = ent.PropHealth
			end

			
			
			ent.PropHealth = ent.PropHealth - damage

			if ent.PropHealth <= 0 then
				local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos())
				util.Effect("Explosion", effectdata, true, true)
				ent:Fire("break")
			else
				local brit = math.Clamp(ent.PropHealth / ent.TotalHealth, 0, 1)
				local col = ent:GetColor()
				col.r = 255
				col.g = 255 * brit
				col.b = 255 * brit
				ent:SetColor(col)
			end
		elseif entclass == "func_door_rotating" then
			if ent:GetKeyValues().damagefilter == "invul" then
				return
			end

			if not ent.Heal then
				local br = ent:BoundingRadius()
				if br > 80 then
					return
				end

				local health = br * 35
				ent.Heal = health
				ent.TotalHeal = health
			end

			ent._LastAttackerIsHuman = false
		
			if IsValid( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and IsValid(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
				ent._LastAttackerIsHuman = true
			end

			if damage >= 20 and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
				ent:EmitSound(math.random(2) == 1 and "npc/zombie/zombie_pound_door.wav" or "ambient/materials/door_hit1.wav")
			end

			ent.Heal = ent.Heal - damage
			local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
			local col = ent:GetColor()
			col.r = 255
			col.g = 255 * brit
			col.b = 255 * brit
			ent:SetColor(col)

			if ent.Heal <= 0 then
				ent:EmitSound("Breakable.Metal")
				ent:Fire("open", "", 0) -- Trigger any area portals.
				ent:Fire("break", "", 0.05)
				ent:Fire("kill", "", 0.1)
			end
		elseif entclass == "prop_door_rotating" then
			if ent:GetKeyValues().damagefilter == "invul" or ent:HasSpawnFlags(2048) then
				return
			end

			ent.Heal = ent.Heal or ent:BoundingRadius() * 35
			ent.TotalHeal = ent.TotalHeal or ent.Heal

			if damage >= 20 and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
				ent:EmitSound("npc/zombie/zombie_pound_door.wav")
			end

			ent.Heal = ent.Heal - damage
			local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
			local col = ent:GetColor()
			col.r = 255
			col.g = 255 * brit
			col.b = 255 * brit
			ent:SetColor(col)

			if ent.Heal <= 0 then
				local physprop = ents.Create("prop_physics")
				if physprop:IsValid() then
					physprop:SetPos(ent:GetPos())
					physprop:SetAngles(ent:GetAngles())
					physprop:SetSkin(ent:GetSkin())
					physprop:SetMaterial(ent:GetMaterial())
					physprop:SetModel(ent:GetModel())
					physprop:Spawn()
					ent:Fire("break")
					physprop:SetPhysicsAttacker(attacker)
					if attacker:IsValid() then
						local phys = physprop:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetVelocityInstantaneous((physprop:NearestPoint(attacker:EyePos()) - attacker:EyePos()):GetNormalized() * math.Clamp(damage * 3, 40, 300))
						end
					end
					if physprop:GetMaxHealth() == 1 and physprop:Health() == 0 then
						local health = math.ceil((physprop:OBBMins():Length() + physprop:OBBMaxs():Length()) * 2)
						if health < 2000 then
							physprop.PropHealth = health
							physprop.TotalHealth = health
						end
					end
				end
			end
		elseif entclass == "func_physbox" then
			local holder, status = ent:GetHolder()
			if holder then status:Remove() end

			if ent:GetKeyValues().damagefilter == "invul" then return end
			
			if self:GetGameMode() == GAMEMODE_ARENA then return end

			ent.Heal = ent.Heal or ent:BoundingRadius() * 35
			ent.TotalHeal = ent.TotalHeal or ent.Heal

			ent._LastAttackerIsHuman = false
		
			if IsValid( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and IsValid(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
				ent._LastAttackerIsHuman = true
			end

			ent.Heal = ent.Heal - damage
			local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
			local col = ent:GetColor()
			col.r = 255
			col.g = 255 * brit
			col.b = 255 * brit
			ent:SetColor(col)

			if ent.Heal <= 0 then
				local foundaxis = false
				local entname = ent:GetName()
				local allaxis = ents.FindByClass("phys_hinge")
				for _, axis in pairs(allaxis) do
					local keyvalues = axis:GetKeyValues()
					if keyvalues.attach1 == entname or keyvalues.attach2 == entname then
						foundaxis = true
						axis:Remove()
						ent.Heal = ent.Heal + 120
					end
				end

				if not foundaxis then
					ent:Fire("break", "", 0)
				end
			end
		elseif entclass == "func_breakable" then
			if ent:GetKeyValues().damagefilter == "invul" then return end

			ent._LastAttackerIsHuman = false
		
			if IsValid( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and IsValid(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
				ent._LastAttackerIsHuman = true
			end

			local brit = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
			local col = ent:GetColor()
			col.r = 255
			col.g = 255 * brit
			col.b = 255 * brit
			ent:SetColor(col)
		end
	end
	
	--On player damaged
	if ent:IsPlayer() then
		--
		if damage > 0 then
			local holder, status = ent:GetHolder()
			if holder then
				status:Remove()
			end
		end

		--Scale player damage
		if gamemode.Call( "ScalePlayersDamage", ent, attacker, inflictor, dmginfo ) then 
			return 
		end
		
		--Human take damage
		--[[if ent:IsHuman() then
			if gamemode.Call( "OnHumanTakeDamage", ent, attacker, inflictor, dmginfo ) then 
				return 
			end
		end]]
		
		--Undead take damage
		--[[if ent:IsZombie() then 
			if gamemode.Call( "OnZombieTakeDamage", ent, attacker, inflictor, dmginfo ) then 
				return 
			end
		end]]
		
		--Spectator damage (rare)
		--[[if ent:IsSpectator() then
			if gamemode.Call( "OnSpectatorTakeDamage", ent, attacker, inflictor, dmginfo ) then 
				return 
			end
		else
			--Player take damage
			if gamemode.Call( "OnPlayerTakeDamage", ent, attacker, inflictor, dmginfo ) then 
				return 
			end
		end]]
		if not ent:IsSpectator() then
			if gamemode.Call( "OnPlayerTakeDamage", ent, attacker, inflictor, dmginfo ) then 
				return 
			end
		end
	end
	
	--Avoid console spam
	--[[if ent:IsPlayer() or attacker:IsPlayer() then
		Debug ( "[DAMAGE] "..tostring ( attacker ).."/"..tostring( dmginfo:GetAttacker() ).." hurt "..tostring( ent ).." with "..tostring( dmginfo:GetInflictor() ).."/"..tostring( inflictor ).." for "..tostring ( math.Round ( dmginfo:GetDamage() ) ).." damage. Type is "..tostring ( dmginfo:GetDamageType() )..". Target health is : "..tostring ( ent:Health() ) )
	end]]
end

function GM:SetupProps()
	if self:GetGameMode() == GAMEMODE_ARENA then
		return
	end
	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		local mdl = ent:GetModel()
		if mdl then
			mdl = string.lower(mdl)
			if ent:GetMaxHealth() == 1 and ent:Health() == 0 and ent:GetKeyValues().damagefilter ~= "invul" and ent:GetName() == "" then
				local health = math.min(2500, math.ceil((ent:OBBMins():Length() + ent:OBBMaxs():Length()) * 10))
				ent.PropHealth = health
				ent.TotalHealth = health
			else
				ent:SetHealth(math.ceil(ent:Health() * 3))
				ent:SetMaxHealth(ent:Health())		
			end
		end
	end
end

-- Disable 'crunch' sound for zombies on falldamage
function GM:OnPlayerHitGround ( ent )
	if IsEntityValid( ent ) then
		if not ent:IsHuman() then 
			return true 
		end
	end
end

Debug ( "[MODULE] Loaded Entity-Take-Damage file." )