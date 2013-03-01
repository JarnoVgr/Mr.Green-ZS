-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ( "sh_weightspeed.lua" )
include ( "sh_weightspeed.lua" )

local function OnHealthEvent ( ent, dmginfo )
	if not ent:IsPlayer() then return end
	if not ent:IsHuman() then return end
	
	//Ignore null damage
	if dmginfo:GetDamage() == 0 then return end
	
	//print ( ent, damage, dmginfo:GetDamage() )

end
//hook.Add ( "EntityTakeDamage", "OnWeightHealth", OnHealthEvent )




