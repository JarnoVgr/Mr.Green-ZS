-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"

ENT.RicochetSounds = { Sound( "weapons/physcannon/energy_bounce1.wav" ), Sound( "weapons/physcannon/energy_bounce2.wav" ) }

-- Returns collision normal
function ENT:GetHitNormal()
	return self:GetDTVector( 0 )
end

-- Precache stuff
util.PrecacheModel( "models/props/cs_italy/orange.mdl" )
util.PrecacheSound( "npc/antlion_grub/squashed.wav" )
util.PrecacheSound( "vo/ravenholm/monk_death07.wav" )
util.PrecacheSound( "vo/npc/Alyx/uggh02.wav" )
