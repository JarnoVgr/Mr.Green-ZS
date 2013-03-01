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

if not DESTRUCTIBLE_PROPS then return end

EntityDamageTable = EntityDamageTable or {}
local MAX_ENT_HEALTH = 13000

//Entities affected by this module
destructList = { "prop_physics", "prop_physics_multiplayer" }

local function DoPhysBoxDestructible ( ent, attacker, inflictor, dmginfo )
	//Physbox damage - mostly for doors - except the little planks
	local entclass = ent:GetClass()
	local OBBMin, OBBMax = ent:OBBMins(), ent:OBBMaxs()
	
	//fix the explosive damage
	/*if dmginfo:IsExplosionDamage() and attacker:IsPlayer() and attacker:IsHuman() then
		//force temporary protection from fire
		ent.FireProtection = CurTime() + 25
		dmginfo:SetDamage ( 0 )
		return true
	end*/
	
	if dmginfo:IsDamageType( DMG_BURN ) and ent.FireProtection and ent.FireProtection > CurTime() then
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	if ent.IsObjEntity then 		
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	if entclass == "func_physbox" then
	/*if (attacker:IsPlayer() and attacker:IsZombie() and attacker:HasBought("cadebuster")) or (attacker:GetOwner():IsPlayer() and attacker:GetOwner():HasBought("cadebuster") and attacker:GetOwner():IsZombie()) and ent.Nails then  

		dmginfo:ScaleDamage(1.5) 	

	end*/
	
	ent._LastAttackerIsHuman = false
	
	if ValidEntity( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and ValidEntity(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
		ent._LastAttackerIsHuman = true
	end
	
	
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and dmginfo:IsMeleeDamage() and ent.Nails then 
		dmginfo:ScaleDamage ( 0.25 )
	end
	
	if attacker:IsPlayer() and attacker:IsZombie() and attacker:IsZombine() then
		dmginfo:ScaleDamage(3)
	end
	
	if attacker:IsPlayer() and attacker:IsZombie() and attacker:IsBossZombie() then
		if attacker:GetZombieClass() == 12 then
			dmginfo:ScaleDamage ( 2 )
			//dmginfo:SetDamage(2800)
		else
			dmginfo:ScaleDamage ( 1.5 )
			//dmginfo:SetDamage(1600)
		end
	end
	
	
	local damage = dmginfo:GetDamage()
	
	
	
			if ent.Nails then//and not (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN)and dmginfo:IsMeleeDamage())
				for i=1, #ent.Nails do
					local nail = ent.Nails[i]
					if nail then
						if nail:IsValid() then
							nail:SetNailHealth(nail:GetNailHealth() - damage)
							if ent.PropHealth then
								--ent.PropHealth = math.Clamp(ent.PropHealth + damage,0,ent.PropMaxHealth)
							end
							--nail.Heal = nail.Heal - damage
							--ent:SetHealth(ent:Health() + damage)
							--ent.PropHealth = ent.PropHealth + damage
							dmginfo:SetDamage ( 0 )
							if nail:GetNailHealth() <= 0 then
								local findcons = nail.constraint
								local numcons = 0
								for _, theent in ipairs(ent.Nails) do//ents.FindByClass("nail")
									if theent.constraint == findcons then numcons = numcons + 1 end
								end
								if numcons == 1 then
									findcons:Remove()
								else
									nail:Remove()
								end
								
								local toworld = false
								if nail.toworld then
									toworld = true
								end
								
								if ValidEntity ( ent:GetPhysicsObject() ) and not ent:GetPhysicsObject():IsMoveable() then
									if nail.toworld then
										local unfreeze = false
										for num=1, #ent.Nails do
											local nl = ent.Nails[num]
											if nl.toworld then
												if nail != nl then
													unfreeze = false
													break
												else
													unfreeze = true
												end
											end
										end
										
										if unfreeze then
											
											ent:GetPhysicsObject():EnableMotion( true )
										end
									end
								end
								
								
								if toworld then
									
											table.remove(ent.Nails, i)
											
											if #ent.Nails <= 0 then
												ent.Nails = nil							
											end
								else
									for _, entity in ipairs(nail.Ents) do
										if entity.Nails then
											
											table.remove(entity.Nails, i)
											
											if #entity.Nails <= 0 then
												entity.Nails = nil							
											end
										end
									end
								end
								--table.remove(ent.Nails, i)
								
								--if #ent.Nails <= 0 then
								--	ent.Nails = nil							
								--end
							end
							return
						else
							table.remove(ent.Nails, i)
							i = i - 1
						end
					end
				end
			//dmginfo:SetDamage ( 0 )
			return true
			end
	
	//func_breakable stuff
	if entclass == "func_breakable" then
		local brit = math.Clamp( ent:Health() / ent:GetMaxHealth(), 0, 1 )
		local c = ent:GetColor()
		local r,g,b,a = c.r,c.g,c.b,c.a
		ent:SetColor( Color(255, 255 * brit, 255 * brit * 0.5, a) )
	end
	
	if ent.PropHealth then
		
		ent.PropHealth = ent.PropHealth - dmginfo:GetDamage() 
		--ent:SetHealth ( ent:Health() - dmginfo:GetDamage() )
		--local brit = math.Clamp ( ent:Health() / ent:GetMaxHealth(), 0, 1 )
		local brit = math.Clamp ( ent.PropHealth / ent.PropMaxHealth, 0, 1 )
		local c = ent:GetColor()
		local r,g,b,a = c.r,c.g,c.b,c.a
		ent:SetColor( Color(255, 255 * brit, 255 * brit * 0.5, a) )

		//if it's a door, delete the phys_hinge
		if ent.PropHealth <= 0 then
			local foundaxis = false
			local entname = ent:GetName()
			local allaxis = ents.FindByClass("phys_hinge")
			for _, axis in pairs(allaxis) do
				local keyvalues = axis:GetKeyValues()
				if keyvalues.attach1 == entname or keyvalues.attach2 == entname then
					foundaxis = true
					axis:Remove()
					ent.PropHealth = ent.PropHealth + 120
					--ent:SetHealth ( ent:Health() + 120 )
				end
			end

			if not foundaxis then
				ent:Fire( "break", "", 0 )
			end
		end
	end
	

	
		//if DESTROY_DOORS and TranslateMapTable[ game.GetMap() ] and not TranslateMapTable[ game.GetMap() ].EnableSolidDoors then	
				if entclass == "prop_door_rotating" then
					
					//check for locked doors
					//if ent:GetKeyValues().spawnflags and (tonumber(ent:GetKeyValues().spawnflags) == 2048 or tonumber(ent:GetKeyValues().spawnflags) == 10240 ) then 
					
					//tricky method from facepunch, 2048 is that we a looking for
					if ent:GetKeyValues().spawnflags and bit.band(tonumber(ent:GetKeyValues().spawnflags), 2048) == 2048 then
						//print("locked door")
					return end
					
					if (attacker:IsPlayer() and attacker:IsZombie() and attacker:HasBought("cadebuster")) or (attacker:GetOwner():IsPlayer() and attacker:GetOwner():HasBought("cadebuster") and attacker:GetOwner():IsZombie()) then  
					dmginfo:ScaleDamage(1.3) 	
					end
					
					ent.PropHealth = ent.PropHealth - dmginfo:GetDamage()
					--ent:SetHealth ( ent:Health() - dmginfo:GetDamage() )
					local brit = math.Clamp ( ent.PropHealth / ent.PropMaxHealth, 0, 1 )
					local c = ent:GetColor()
					local r,g,b,a = c.r,c.g,c.b,c.a
					ent:SetColor( Color(255, 255 * brit, 255 * brit * 0.5, a) )
					
					--if ent:Health() <= 0 then
					if ent.PropHealth <= 0 then
					local physprop = ents.Create("prop_physics_multiplayer")
						if physprop:IsValid() then
							physprop:SetPos(ent:GetPos())
							physprop:SetAngles(ent:GetAngles())
							physprop:SetSkin(ent:GetSkin())
							physprop:SetMaterial(ent:GetMaterial())
							physprop:SetModel(ent:GetModel())
							physprop:Spawn()
							physprop.PropDoor = true
							ent:Fire( "break", "", 0 )
							physprop:SetPhysicsAttacker(attacker)
							local phys = physprop:GetPhysicsObject()
							if phys:IsValid() then
								if attacker:IsValid() then
									phys:Wake()
								end
							end
						end
					end
				end
		//end	
	end
end
//hook.Add ( "OnPropTakeDamage", "PhysBoxDestructible", DoPhysBoxDestructible )

//Entity takes damage
local function DoDestructible ( ent, attacker, inflictor, dmginfo )
	//Physgun damage, block
	if dmginfo:IsPhysGunDamage() then
		dmginfo:SetDamage( 0 )
		return true
	end

	//Attacker is world, block
	if dmginfo:IsPhysDamage() then
		if dmginfo:IsAttackerWorld() then
			dmginfo:SetDamage( 0 ) 
			return true
		end
	end
	
	//fix the explosive damage
	/*if dmginfo:IsExplosionDamage() and attacker:IsPlayer() and attacker:IsHuman() then
		//force temporary protection from fire
		ent.FireProtection = CurTime() + 25
		dmginfo:SetDamage ( 0 )
		return true
	end*/
	
	if dmginfo:IsDamageType( DMG_BURN ) and ent.FireProtection and ent.FireProtection > CurTime() then
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	//Damage between props, block
	if dmginfo:IsPhysDamageBetweenProps( ent ) then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	//No damage for ammo crates
	if ent:GetClass() == "spawn_ammo" then
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	if ent.IsObjEntity then 		
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	if ValidEntity ( ent ) and ValidEntity ( ent:GetOwner() ) and ent:GetOwner():GetClass() == "spawn_ammo" then
		dmginfo:SetDamage ( 0 )
		return true
	end
	
	ent._LastAttackerIsHuman = false
	
	
	if ValidEntity( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and ValidEntity(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
		ent._LastAttackerIsHuman = true
	end
	
	
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and dmginfo:IsMeleeDamage() and ent.Nails then 
		dmginfo:ScaleDamage ( 0.25 )
	end
	
	if attacker:IsPlayer() and attacker:IsZombie() and attacker:IsZombine() then
		dmginfo:ScaleDamage(4)
	end
	
	if attacker:IsPlayer() and attacker:IsZombie() and attacker:IsBossZombie() then
		if attacker:GetZombieClass() == 12 then
			dmginfo:ScaleDamage ( 2 )
			//dmginfo:SetDamage(2800)
		else
			dmginfo:ScaleDamage ( 1.5 )
			//dmginfo:SetDamage(1600)
		end
	end	
	
	local damage = dmginfo:GetDamage()
	if ent.Nails then// and not (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN )and dmginfo:IsMeleeDamage()
		for i=1, #ent.Nails do
			local nail = ent.Nails[i]
			if nail then
				if nail:IsValid() then
					nail:SetNailHealth(nail:GetNailHealth() - damage)
					//nail.Heal = nail.Heal - damage
					dmginfo:SetDamage ( 0 )
					if ent.PropHealth then
						--ent.PropHealth = math.Clamp(ent.PropHealth + damage,0,ent.PropMaxHealth)
					end
					--ent:SetHealth(ent:Health() + damage)
					if nail:GetNailHealth() <= 0 then
						local findcons = nail.constraint
						local numcons = 0
						for _, theent in pairs(ent.Nails) do
							if theent.constraint == findcons then numcons = numcons + 1 end
						end
						if numcons == 1 then
							findcons:Remove()
						else
							nail:Remove()
						end
						
						local toworld = false
						if nail.toworld then
							toworld = true
						end
						
						if ValidEntity ( ent:GetPhysicsObject() ) and not ent:GetPhysicsObject():IsMoveable() then
							if nail.toworld then
								local unfreeze = false
								for num=1, #ent.Nails do
									local nl = ent.Nails[num]
									if nl.toworld then
										if nail != nl then
											unfreeze = false
											break
										else
											unfreeze = true
										end
									end
								end
								
								if unfreeze then
									
									ent:GetPhysicsObject():EnableMotion( true )
								end
							end
						end
						
						if toworld then
							
									table.remove(ent.Nails, i)
									
									if #ent.Nails <= 0 then
										ent.Nails = nil							
									end
						else
							for _, entity in pairs(nail.Ents) do
								if entity.Nails then
									
									table.remove(entity.Nails, i)
									
									if #entity.Nails <= 0 then
										entity.Nails = nil							
									end
								end
							end
						end
						--table.remove(ent.Nails, i)
						
						--if #ent.Nails <= 0 then
						--	ent.Nails = nil							
						--end
					end
					return
				else
					table.remove(ent.Nails, i)
					i = i - 1
				end
			end
		end
		
		return true
	end
	
	//only prop types in the list go through this!
	if not table.HasValue ( destructList, ent:GetClass() ) then return end
	
	//not applies to breakable props
	if ent.IsBreakable then return end
	
	if ent.PropHealth then
		
		//decr. health - hacky way around other types of dmg
		local Damage = dmginfo:GetDamage()
		dmginfo:SetDamage ( 0 )
		/*if (attacker:IsPlayer() and attacker:IsZombie() and attacker:HasBought("cadebuster")) or (attacker:GetOwner():IsPlayer() and attacker:GetOwner():HasBought("cadebuster") and attacker:GetOwner():IsZombie()) and (ent.IsBarricade or ent.Nails ) then 
			Damage = Damage*1.5 
		end*/
		--ent:SetHealth ( ent:Health() - Damage )
		ent.PropHealth = ent.PropHealth - Damage

		//Set it back the way it was
		dmginfo:SetDamage ( Damage )
		
		--print("Health = "..ent.PropHealth)
		--print("Max Health = "..ent.PropMaxHealth)
		
		//set the color based on how much health it has
		--local colmod = ent:Health() / ent:GetMaxHealth()
		local colmod = ent.PropHealth / ent.PropMaxHealth
		
		if ent.PropHealth > ent.PropMaxHealth then
			ent:SetColor( Color(255,255,255, 255) )
		else
			ent:SetColor( Color(255, colmod * 255, colmod * 255, 255) )
		end

		if ent.PropHealth < ent.PropMaxHealth * 0.65 then
			if not ent.IsBarricade and not ent.IsFrozen then
				if ValidEntity ( ent:GetPhysicsObject() ) then
					ent:GetPhysicsObject():EnableMotion( true )
				end
			end
			if ent.PropHealth < ent.PropMaxHealth*0.9 then
					if ent:IsConstrained() then
						constraint.RemoveAll( ent )
					end
			end

		end

		//Remove the entity if it has negative or 0 health
		if ent.PropHealth <= 0 then
			Debug ( "[DESTRUCTIBLE] Removing Entity "..tostring ( ent ).." with model "..tostring ( ent:GetModel() )..". Attacker is "..tostring ( dmginfo:GetAttacker() ) )
			local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos())
			util.Effect("Explosion", effectdata, true, true)
			ent:Remove()
		end
	end
end
hook.Add( "OnPropTakeDamage", "DoDestructible", DoDestructible )

/*---------------------------------------------------------
      Called when when an entity has been created
---------------------------------------------------------*/
/*hook.Add("OnEntityCreated", "EntityDamageTableOnEntityCreated", function( ent )
	timer.Simple( 0.01, function()
		if not ValidEntity ( ent ) then return end
		if not ValidEntity ( ent:GetPhysicsObject() ) then return end
		if ent:IsPlayer() then return end
		if ent.IsObjEntity then return end
		
		
		//Breakables
		if ent:Health() != 0 and not ent.IsBarricade then ent.IsBreakable = true end
		
		//set up health for phys-boxes
		if ent:GetClass() == "func_physbox" then
			local OBBMin, OBBMax = ent:OBBMins(), ent:OBBMaxs()
			
			//Set health
			//ent:SetHealth ( ent:BoundingRadius() * 30 )
			ent.PropHealth = ent:BoundingRadius() * 30 
			
			//Maximum health
			--ent:SetMaxHealth ( ent.PropHealth or ent:Health() )
			ent.PropMaxHealth = PropHealth or ent:Health() 
		end
		if ent:GetClass() == "prop_door_rotating" then
			--ent:SetHealth ( ent:BoundingRadius() * 57 )
			ent.PropHealth = ent:BoundingRadius() * 57 
			--ent:SetMaxHealth ( ent.PropHealth or ent:Health() )
			ent.PropMaxHealth = PropHealth or ent:Health() 
		end
		
		
		//only prop types in the list go through this!
		if not table.HasValue ( destructList, ent:GetClass() ) then return end
		if ent.IsBreakable then return end
		
		local Phys, Index = ent:GetPhysicsObject(), ent:EntIndex()
		
		//Set the health of the ent and save it 
		--ent:SetHealth ( math.min( ( Phys:GetMass() * MASS_SCALAR) * 1.5, MAX_ENT_HEALTH ) )
		ent.PropHealth = math.min( ( Phys:GetMass() * MASS_SCALAR) * 1.5, MAX_ENT_HEALTH ) 
		
		if ent.PropDoor then
			--ent:SetHealth(math.random(420,650))
			ent.PropHealth = math.random(420,650)
		end
			
		//Freeze it if its heavy enough for the sake of lag
		timer.Simple ( 2.5, function()
			if not ValidEntity ( ent ) then return end
			if ent:IsPlayer() then return end
			if not ValidEntity ( Phys ) then return end
			
			//check again
			if not table.HasValue ( destructList, ent:GetClass() ) then return end
		end)
			
		//Finally set it's default max health
		--ent:SetMaxHealth ( ent.PropHealth or ent:Health() )
		ent.PropMaxHealth = ent.PropHealth or ent:Health()
	end)
end)*/

Debug ( "[MODULE] Loaded Destructible Entities file." )