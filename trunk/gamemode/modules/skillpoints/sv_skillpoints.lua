-- Eat with skill!
-- Serverside functions goes here
-- TODO: Make it better 

AddCSLuaFile ( "cl_skillpoints.lua" )
AddCSLuaFile ( "sh_skillpoints.lua" )

include("sh_skillpoints.lua")


SKILLPOINTS = true
if not SKILLPOINTS then return end

skillpoints = {}

function GM:CheckPlayerScore(pl)
	local score = pl:Frags()
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

-- Called in PlayerInitialSpawn
function skillpoints.SetupSkillPoints(pl)

	if not IsEntityValid(pl) then return end
	
	pl.SkillPoints = 0
	
	--umsg.Start("skillpoints.UpdateSkillPoints", pl)
	--	umsg.Short(0)
	--umsg.End()
	
end

-- Add nessesary amount of skill points
function skillpoints.AddSkillPoints(pl, amount)
	if amount == nil or amount == 0 or not IsEntityValid(pl) or not pl:IsPlayer() then
		return
	end

	if GAMEMODE:IsRetroMode() then
		if amount > 1 then
			return
		end
	end
	
	pl:SetFrags(math.max(2048,pl:Frags()+amount))
	
	if GAMEMODE:IsRetroMode() then
		GAMEMODE:CheckPlayerScore(pl)
	end
end

-- Use it when you want player to achieve skillshot
function skillpoints.AchieveSkillShot(pl,victim, name)
	if not IsEntityValid(pl) then return end
	if not pl:IsPlayer() then return end -- Check it anyway, because I have a bad feeling that attacker can be not a player and such.
	
	if not IsEntityValid(victim) then return end
	if not victim:IsPlayer() then return end  -- Same here
	
	local Team
	
	if pl:IsHuman() then
		Team = "Humans"
	else
		Team = "Zombies"
	end
	
	if Team == nil then return end
	
	if not SkillPointsTable[Team][name] then return end
	
	local Amount = SkillPointsTable[Team][name].Points
	local Name = SkillPointsTable[Team][name].Name
	local Col = SkillPointsTable[Team][name].Color
	local Pos = victim:GetPos() + Vector(0,0,math.random(55,77))

	skillpoints.AddSkillPoints(pl, Amount)
end

-- Same as skillpoints.SetupSkillPoints :/
function skillpoints.Clean(pl)

	if not IsEntityValid(pl) then return end
	
	pl:SetFrags(0)
	
	pl.SkillPoints = 0
	
	--umsg.Start("skillpoints.UpdateSkillPoints", pl)
		--umsg.Short(0)
	--umsg.End()
	
end


