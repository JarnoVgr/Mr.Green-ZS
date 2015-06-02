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

-- Process shop upgrades and more
function GM:DoDamageUpgrades ( ent, attacker, inflictor, dmginfo )

	local dmg = dmginfo:GetDamage()
	print(dmg)
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local mul = 0.1 + ((attacker:GetRank() * 2) / 100 )
		if attacker:GetActiveWeapon().Primary.Ammo == "pistol" and attacker:GetPerk("_medic") then
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "ar2" and attacker:GetPerk("_commando") then
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "smg1" and attacker:GetPerk("_support2") or attacker:GetActiveWeapon().Primary.Ammo == "buckshot" and attacker:GetPerk("_support2") then
			dmg = dmg + (dmg * mul)		
		elseif attacker:GetActiveWeapon().Primary.Ammo == "357" and attacker:GetPerk("_sharpshooter") then
			dmg = dmg + (dmg * mul)	
		elseif attacker:GetActiveWeapon().Primary.Ammo == "Battery" and attacker:GetPerk("_medic") then --mediguns
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "none" and attacker:GetPerk("_engineer") then
			dmg = dmg + (dmg * mul)					
			
		elseif dmginfo:IsMeleeDamage() and attacker:GetPerk("_berserker") then
			dmg = dmg + (dmg * mul)	

			if attacker:GetPerk("_headhunter") then
				dmg = dmg * 0.85			
			end	
		end
	elseif attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD and ent:IsPlayer() then
	
		if attacker:HasBought("vampire") and attacker:Health() + dmg * 0.5 < attacker:GetMaximumHealth() then	
			attacker:SetHealth(attacker:Health() + dmg * 0.5)	
		end		
	
		if ent:GetPerk("_sharpshooter") and ent.DataTable["ShopItems"][69] and math.random(1,5) == 1 then
			dmginfo:SetDamage(0)				
		elseif ent:GetPerk("_medic") then
			dmg = dmg - (dmg * ((3*ent:GetRank())/100) + 0.1)		
		end
	end

	dmginfo:SetDamage( dmg )	
	
	if attacker.DamageOutput then
		attacker:ChatPrint(math.Round(dmg))
	end

end

