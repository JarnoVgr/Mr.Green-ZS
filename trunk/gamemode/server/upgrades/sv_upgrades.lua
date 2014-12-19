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

	local damage = dmginfo:GetDamage()

	--[[if attacker:IsPlayer() and ent:IsPlayer() then
		if not ent:IsBot() and ent:IsPlayer() and ent:Team() == TEAM_HUMAN and ent:Alive() and ent:GetPerk("_enhkevlar") and attacker:IsPlayer() and attacker:Team() == TEAM_UNDEAD then
			dmginfo:SetDamage (damage - damage*0.25 ) 
		end
	end]]--
	
	--  more damage when attacking with melee weapons
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetPerk("_freeman") and IsValid( inflictor ) then-- attacker:HasBought( "blessedfists" )
		if inflictor:IsWeapon() and inflictor:GetType() == "melee" and not inflictor.IsTurretDmg then
			dmginfo:SetDamage( damage * 1.1 )
		end
	end
end

