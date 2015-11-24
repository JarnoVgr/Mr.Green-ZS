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

local dmg = 0
local olddmg = 0
local mul = 0

-- Process shop upgrades and more
function GM:DoDamageUpgrades ( ent, attacker, inflictor, dmginfo )

	dmg = dmginfo:GetDamage()

	if attacker:IsPlayer() then		
		if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and ent:IsPlayer() then
				
				olddmg = dmginfo:GetDamage() 
				mul = 0

			if attacker:GetActiveWeapon().Primary.Ammo == "ar2" and attacker:GetPerk("Commando") then
							
				mul = 0.1 + ((attacker:GetRank() * 1) / 100 )
				
				if (attacker:GetPerk("commando_viper")) then
					mul = mul - 0.40
				end			
				
				dmg = dmg + (dmg * mul)
				
			elseif (attacker:GetActiveWeapon().Primary.Ammo == "smg1" and attacker:GetPerk("Support")) or (attacker:GetActiveWeapon().Primary.Ammo == "buckshot" and attacker:GetPerk("Support")) then
				mul = 0.1 + ((attacker:GetRank() * 1) / 100 )
				dmg = dmg + (dmg * mul)						
			elseif attacker:GetActiveWeapon().Primary.Ammo == "357" and attacker:GetPerk("Sharpshooter") then
				mul = 0.05 + ((attacker:GetRank() * 1) / 100 )
				dmg = dmg + (dmg * mul)	
			elseif (attacker:GetActiveWeapon().Primary.Ammo == "Battery" or attacker:GetActiveWeapon().Primary.Ammo == "pistol" or attacker:GetActiveWeapon():GetClass() == "weapon_zs_melee_stunstick")  and attacker:GetPerk("Medic") then --mediguns
				mul = 0.1 + ((attacker:GetRank() * 1) / 100 )
				dmg = dmg + (dmg * mul)
				
				if attacker:GetPerk("medic_stun") and attacker:GetActiveWeapon():GetClass() == "weapon_zs_melee_stunstick" then
					dmg = dmg + 6
					GAMEMODE:OnPlayerHowlered(ent, 2)			
				end
						
			elseif attacker:GetActiveWeapon().Primary.Ammo == "alyxgun" and attacker:GetPerk("Pyro") then
				mul = 0.1 + ((attacker:GetRank() * 1) / 100 )
				local burnchance = 100 - attacker:GetRank() * 1	
				local ignite = 1
				local burn = 6 + (6 * (0.05 + (3*(attacker:GetRank()*0.01))))		
				local scorch = 10 + (10 * (2*(attacker:GetRank()*0.01)))	
				
				if attacker.DataTable["ShopItems"][111] then
					burnchance = burnchance - 5
					ignite =  ignite + 1
					scorch = scorch + scorch *0.15
					
				end

				if ent:IsOnFire() then
					mul = mul + 0.1
				end				
				
				if attacker:GetActiveWeapon():GetClass() == "weapon_zs_pyroshotgun" then
					burnchance = burnchance - 12
				elseif attacker:GetActiveWeapon():GetClass() == "weapon_zs_pyrocannon" then
					burnchance = burnchance - 20
				end
				
				if attacker:GetPerk("pyro_burn") then
					burnchance = burnchance - 5
				end
				
				if math.random(1,burnchance) <= 12 then
					if attacker:GetPerk("pyro_hotpoints") then
						skillpoints.AddSkillPoints(attacker,3)
						ent:FloatingTextEffect(3, attacker)						
					end
										
					if attacker:GetPerk("pyro_burn") then
						burn = burn + 10
					end
					
					if attacker:GetPerk("pyro_backfire") then	
						attacker:GiveAmmo(6,"alyxgun")
					end
					
					dmg = dmg+scorch
					ent:TakeDamageOverTime(burn, 1, ignite , attacker, inflictor )					
					ent:Ignite(ignite,0)	
				end
				
				dmg = dmg + (dmg * mul)
				
			elseif  attacker:GetPerk("Engineer") then
				if attacker:GetActiveWeapon().Primary.Ammo == "none" then
					mul = 0.1 + ((attacker:GetRank() * 1) / 100 )

					if attacker:GetPerk("engineer_darkenergy") then
						mul = mul + 0.1
					end					
				end

				if attacker:GetPerk("engineer_combustion") and inflictor:GetClass() == "env_explosion" then
					ent:TakeDamageOverTime(7, 1, 4, attacker, inflictor )
					ent:Ignite(4,0)		
				end
				dmg = dmg + (dmg * mul)	
				
			elseif attacker:GetPerk("Berserker") then
				if not dmginfo:IsMeleeDamage() then
					dmg = dmg * 0.9
				else
					mul = 0.1
					if attacker:GetPerk("berserker_executioner") then
						if ent:Health() < ent:GetMaximumHealth()*0.3 then
							mul = mul + 0.3
						end
					end
					dmg = dmg + (dmg * mul)		
					
					if attacker:GetPerk("berserker_barbed") then
						ent:TakeDamageOverTime(dmg*0.2, 2, 3, attacker, inflictor )	
					end


					if attacker:GetPerk("berserker_battlecharge") then
						local bonus = attacker:GetVelocity().z * -1					
						dmg = math.Clamp((((bonus*dmg) * 0.005) + dmg),dmg,dmg*5) 
					end
					
					if attacker:GetPerk("berserker_vampire") then
						attacker:SetHealth(math.Clamp(attacker:Health() + dmg*0.065,0,attacker:GetMaximumHealth()))	
					else
						attacker:SetHealth(math.Clamp(attacker:Health() + dmg*0.05,0,attacker:GetMaximumHealth()))						
					end
					
				end
			end	
			
			if (!attacker:GetPerk("global_sp")) then
				skillpoints.AddSkillPoints(attacker,math.floor( ( ent:GetMaximumHealth() / 10 ) * ( dmg / ent:GetMaximumHealth() )))	
			end

			attacker:AddXP(math.Round(dmg*0.1))	
		elseif attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD and ent:IsPlayer() and ent:Team() == TEAM_HUMAN then
				
			if attacker:HasBought("vampire") and attacker:Health() + dmg * 0.5 < attacker:GetMaximumHealth() then	
				attacker:SetHealth(attacker:Health() + dmg * 0.5)	
			end		
		
			if ent:GetPerk("Sharpshooter") and ent.DataTable["ShopItems"][69] and math.random(1,5) == 1 then
				dmginfo:SetDamage(0)				
			elseif ent:GetPerk("Medic") then
				
				if (ent:GetPerk("medic_battlemedic")) then
					dmg = dmg - (dmg * 0.05)					
				end
				
				if (ent:GetPerk("medic_tanker") and ent.LastTimeHit + 3> CurTime()) then
					dmg = dmg * 0.5			
				end				
			
				dmg = dmg - (dmg * ((2*ent:GetRank())/100) + 0.1)	
				ent.LastTimeHit = CurTime()
			elseif ent:GetPerk("commando_kevlar") then
				dmg = dmg*0.8	
				
			elseif ent:GetPerk("berserker_enrage") then
				if (ent:Health() > 40 and (ent:Health() - dmg) < 40) then
					ent:SendLua("WraithScream()")
					ent:EmitSound(Sound("npc/fast_zombie/fz_scream1.wav"), 90, 85)
					ent:SetColor(Color(255,125,125))
				end
			elseif ent:GetPerk("berserker_porcupine") then
				attacker:TakeDamage(dmg*0.33, ent, ent:GetActiveWeapon())	
			end

			elseif ent:GetPerk("pyro_immolate") then
				attacker:Ignite(4,0)			
				dmginfo:SetAttacker(ent)
				attacker:TakeDamageOverTime(10, 1, 4 ,ent,ent)	
			elseif ent:GetPerk("Berserker") then
				dmg = dmg*0.9	
			end	
			
			if (dmg > 25 && !ent:GetPerk("Berserker")) then
				ent:Daze(dmg*0.06)	
			end
		end		

		if attacker.DamageOutput then
			attacker:ChatPrint("damage: " .. math.Round(dmg) .. " | multiplier: " .. (1 + mul) .. " | old damage: " .. math.Round(olddmg))
		end
		
	end

	dmginfo:SetDamage( dmg )
end

