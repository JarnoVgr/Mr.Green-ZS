-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"

function ENT:GetHitNormal()
	return self:GetDTVector( 0 )
end