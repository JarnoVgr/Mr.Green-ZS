-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"

ENT.TickSound = Sound( "weapons/stunstick/spark2.wav" )

//Returns collision normal
function ENT:GetHitNormal()
	return self:GetDTVector( 0 )
end

