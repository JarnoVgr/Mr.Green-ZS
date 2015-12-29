-- Eat with skill!
-- Serverside functions goes here
-- TODO: Make it better 
AddCSLuaFile("cl_skillpoints.lua")
AddCSLuaFile("sh_skillpoints.lua")

include("sh_skillpoints.lua")


SKILLPOINTS = true
if not SKILLPOINTS then
	return
end

skillpoints = {}

function GM:CheckPlayerScore(pl)
	local score = pl:GetScore()
	if self.RetroUnlocks[score] then
		local reward = self.RetroUnlocks[score][math.random(1, #self.RetroUnlocks[score])]
		if string.sub(reward, 1, 1) == "_" then
			-- PowerupFunctions[reward](pl)
		elseif pl:HasWeapon(reward) then
			local hasall = true
			for _, anotherwep in pairs(self.Rewards[score]) do
				if not pl:HasWeapon(anotherwep) then
					pl:Give(anotherwep)
					local wep = pl:GetWeapon(anotherwep)
					if wep:IsValid() then
						pl.HighestAmmoType = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType)
					end
					hasall = false
					break
				end
			end
			if hasall then
				local wep = pl:GetWeapon(reward)
				if wep:IsValid() then
					local ammotype = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType or "pistol")
					pl:GiveAmmo(self.AmmoRegeneration[ammotype], ammotype, true)
				end
			end
		else
			pl:Give(reward)
			local wep = pl:GetWeapon(reward)
			if wep:IsValid() then
				pl.HighestAmmoType = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType)
			end
		end
	end
end

--Called in PlayerInitialSpawn
function skillpoints.SetupSkillPoints(pl)
	if not IsValid(pl) or not pl:IsPlayer() then
		return
	end

	if pl:IsBot() then
		--Used for testing purposes
		pl:SetScore(math.random(0, 600))
	else
		pl:SetScore(0)
	end
end

--Alias
skillpoints.Clean = skillpoints.SetupSkillPoints
util.AddNetworkString( "SPRequired" )

--Add nessesary amount of skill points
function skillpoints.AddSkillPoints(pl, amount)
	if not amount or amount == 0 or not IsValid(pl) or not pl:IsPlayer() then
		return false
	end

	pl.SPReceived = pl.SPReceived + amount
	pl:AddScore(amount)

	if skillpoints.GetSkillPoints(pl) >= pl.SPRequired then
	
		net.Start("SPRequired")
		net.WriteFloat(math.Round(pl.SPRequired + 50))
		net.WriteBit(false)
		net.Send(pl)
		skillpoints.TakeSkillPoints(pl,pl.SPRequired)
		pl.SPRequired = pl.SPRequired + 50
		
		pl:GiveAmmo( 20, "pistol" )	
		pl:GiveAmmo( 60, "ar2" )
		pl:GiveAmmo( 60, "SMG1" )	
		pl:GiveAmmo( 18, "buckshot" )		
		pl:GiveAmmo( 8, "XBowBolt" )
		pl:GiveAmmo( 16, "357" )
		pl:GiveAmmo( 40, "alyxgun" )			

		local item = "zs_ammobox"		
		local possibleWeapons = {}
		
		for wep,tab in pairs(GAMEMODE.HumanWeapons) do
			if tab.Tier and tab.HumanClass then
				if tab.HumanClass ~= pl:GetHumanWeaponClass() then continue end
				if tab.Tier ~= pl.Tier then continue end
				table.insert(possibleWeapons,wep)			
			end
		end		
		
		pl.Tier = pl.Tier + 1
		
		net.Start("tier")
		net.WriteFloat(pl.Tier)
		net.WriteBit(false)
		net.Send(pl)		
		item = table.Random(possibleWeapons)
		
		local weaponType = GetWeaponType(item)
		local ammoType = 0
		local ammoCount = 0
		
		if weaponType == "melee" then
		
			local Melee = pl:GetMelee()
			if (Melee) then		
				pl:StripWeapon(Melee:GetClass())
			end
			
			pl:Give(item)			
			pl:SelectWeapon(item)				
						
		elseif (weaponType == "smg" || weaponType == "rifle" || weaponType == "shotgun" || weaponType == "pistol") then
			
			local weapon = nil
			
			if (weaponType == "pistol") then
				weapon = pl:GetPistol()
			else
				weapon = pl:GetAutomatic()			
			end
			
			if (weapon) then
			    pl:SelectWeapon(weapon:GetClass())
				ammoType = pl:GetActiveWeapon().Primary.Ammo
				ammoCount = pl:GetAmmoCount(pl:GetActiveWeapon():GetPrimaryAmmoType())
				pl:StripWeapon(weapon:GetClass())
				
			end
			pl:Give(item)
			pl:SelectWeapon(item)	
			pl:GiveAmmo(ammoCount or 20, pl:GetActiveWeapon().Primary.Ammo or "pistol")			
			
		elseif item == "weapon_zs_turretplacer" then
		
			if (pl:HasWeapon(item)) then
				pl:GiveAmmo( 1, "SniperRound" )
				pl:Message("+1 turret", nil, 1, 2)				
			else
				pl:Give(item)			
			end
		
		else
			local itemToSpawn = ents.Create(item)	
			if IsValid(itemToSpawn) then
			
				if pl:Crouching() then
					itemToSpawn:SetPos(pl:GetPos()+Vector(0,0,20))			
				else
					itemToSpawn:SetPos(pl:GetPos()+Vector(0,0,32))			
				end
				itemToSpawn:Spawn()

				local phys = itemToSpawn:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:ApplyForceCenter(Vector(math.Rand(25, 175),math.Rand(25, 175),math.Rand(50, 375)))
					phys:SetAngles(Angle(math.Rand(0, 180),math.Rand(0, 180),math.Rand(0, 180)))
				end
			end
		end
		pl:EmitSound("items/gift_pickup.wav" )	
	end		
	return true
end

--Take nessesary amount of skill points
function skillpoints.TakeSkillPoints(pl, amount)
	if not amount or amount == 0 or not IsValid(pl) or not pl:IsPlayer() then
		return false
	end
	
	pl:AddScore(-1 * amount)
	return true
end

--Get
function skillpoints.GetSkillPoints(pl)
	if not IsValid(pl) or not pl:IsPlayer() then
		return false
	end
	
	return pl:GetScore()
end

--Use it when you want player to achieve skillshot
function skillpoints.AchieveSkillShot(pl, victim, name)
	if not IsValid(pl) or not pl:IsPlayer() or not IsValid(victim) or not victim:IsPlayer() then
		return
	end
	
	local Team
	
	if pl:IsHuman() then
		Team = "Humans"
	elseif pl:IsZombie() then
		Team = "Zombies"
	else
		return
	end
	
	if not SkillPointsTable[Team][name] then
		return
	end
	
	local Amount = SkillPointsTable[Team][name].Points
	--[[local Name = SkillPointsTable[Team][name].Name
	local Col = SkillPointsTable[Team][name].Color
	local Pos = victim:GetPos() + Vector(0,0,math.random(55,77))]]

	skillpoints.AddSkillPoints(pl, Amount)
end