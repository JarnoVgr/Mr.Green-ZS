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
	
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		local mul = 0.1 + ((attacker:GetRank() * 2) / 100 )
		if attacker:GetActiveWeapon().Primary.Ammo == "pistol" and attacker:GetPerk("_medic") then
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "ar2" and attacker:GetPerk("_commando") then
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "smg1" and attacker:GetPerk("_support2") or attacker:GetActiveWeapon().Primary.Ammo == "buckshot" and attacker:GetPerk("_support") then
			dmg = dmg + (dmg * mul)		
		elseif attacker:GetActiveWeapon().Primary.Ammo == "357" and attacker:GetPerk("_sharpshooter") then
			dmg = dmg + (dmg * mul)	
		elseif attacker:GetActiveWeapon().Primary.Ammo == "Battery" and attacker:GetPerk("_medic") then --mediguns
			dmg = dmg + (dmg * mul)
		elseif attacker:GetActiveWeapon().Primary.Ammo == "none" and attacker:GetPerk("_engineer") then
			dmg = dmg + (dmg * mul)					
		end		
	end
	
	dmginfo:SetDamage( dmg )	

	--[[if attacker:IsPlayer() and ent:IsPlayer() then
		if not ent:IsBot() and ent:IsPlayer() and ent:Team() == TEAM_HUMAN and ent:Alive() and ent:GetPerk("_enhkevlar") and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			dmginfo:SetDamage (damage - damage*0.25 ) 
		end
	end]]--
	
	--  more damage when attacking with melee weapons
	--if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetPerk("_freeman") and IsValid( inflictor ) then-- attacker:HasBought( "blessedfists" )
	--	if inflictor:IsWeapon() and inflictor:GetType() == "melee" and not inflictor.IsTurretDmg then
	--		dmginfo:SetDamage( damage * 1.2 )
	--	end
	--end
end

