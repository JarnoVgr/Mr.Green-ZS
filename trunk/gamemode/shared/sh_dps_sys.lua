-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- DPS System.

-- This function may cause temporal lag spike/freeze! It calculates dps for every weapon in the game. DEV COMMAND ONLY!
function GM:CalculateEveryWeaponDPS()
	if CLIENT then return end
	for k,v in pairs ( self.HumanWeapons ) do
		local weapon = ents.Create (k)
		weapon:SetPos ( Entity(1):GetPos() or Vector ( 0,0,0 ) )
		weapon:Spawn()
		print ([[ ["]]..k..[["] ]].." = "..weapon:GetDPS()..",")
		weapon:Remove()
	end
end

--[==[ --------------------------------------------------------Weapon MetaTable --------------------------------------------------------]==]
local meta = FindMetaTable("Weapon")

function meta:GetDPS()
	if not IsValid (self) then return 0 end
	local speed,damage,numshots
	
	if self.Primary then
		if self.Primary.Delay then
			speed = self.Primary.Delay or 1
		else
			speed = 1
		end
		if self.Primary.Damage then
			damage = self.Primary.Damage or 1
		else
			damage = 1
		end
		if self.Primary.NumShots then
			numshots = self.Primary.NumShots or 1
		else
			numshots = 1
		end
	else
		speed = 1
		damage = 1
		numshots = 1
	end
	
	return math.Round ( ( damage / speed ) * numshots )
end

--[==[ --------------------------------------------------------Player MetaTable --------------------------------------------------------]==]
local metapl = FindMetaTable ("Player")

function metapl:MinDPS ()
	if not IsValid(self) or not self:Alive() then
		return
	end

	local DPS_MIN = 99999 
	for _,weapon in pairs(self:GetWeapons()) do
		if IsValid(weapon) and weapon:IsWeapon() and not string.find(weapon:GetClass(), "admin") then
			local DPS_CURRENT = weapon:GetDPS()
			if DPS_CURRENT < DPS_MIN then
				DPS_MIN = DPS_CURRENT
			end
		end
	end
	
	return DPS_MIN or 0
end

function metapl:MinWeaponDPS ()
	if not IsValid(self) or not self:Alive() then
		return
	end
		
	local DPS_MIN = 99999 
	local DPS_WEAPON
	for _,weapon in pairs(self:GetWeapons()) do
		if IsValid(weapon) and weapon:IsWeapon() and not string.find(weapon:GetClass(), "admin") and not string.find(weapon:GetClass(), "punch") and not string.find(weapon:GetClass(), "syringe") and not string.find(weapon:GetClass(), "turret") and not string.find(weapon:GetClass(), "barricade") and not string.find(weapon:GetClass(), "mine") and not string.find(weapon:GetClass(), "hammer") then
			local DPS_CURRENT = weapon:GetDPS()
			if DPS_CURRENT < DPS_MIN then
				DPS_MIN = DPS_CURRENT
				DPS_WEAPON = weapon
			end
		end
	end
		
	if DPS_WEAPON:IsWeapon() then
		return DPS_WEAPON
	end
end

function metapl:MaxWeaponDPS ()
	if not IsValid(self) or not self:Alive() then
		return
	end
		
	local DPS_MAX = -9999 
	local DPS_WEAPON
	for _,weapon in pairs ( self:GetWeapons() ) do
		if weapon:IsValid() and weapon:IsWeapon() then
			local DPS_CURRENT = weapon:GetDPS()
			if DPS_CURRENT > DPS_MAX then
				DPS_MAX = DPS_CURRENT
				DPS_WEAPON = weapon
			end
		end
	end
		
	if DPS_WEAPON:IsWeapon() then
		return DPS_WEAPON
	end
end

if SERVER then
	function metapl:DropWeakestWeapon()
		if not IsValid(self) then
			return
		end
		
		--Grab data
		local minwep = self:MinWeaponDPS()
		
		--Drop the weapon from the right category
		self:DropWeapon(minwep)
	end
end