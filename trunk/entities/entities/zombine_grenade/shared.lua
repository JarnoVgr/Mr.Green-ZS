-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

ENT.Type = "anim"

--  5 second fuse
ENT.BoomTime, ENT.Boom = 0, 5

-- Distance to blow
ENT.MaximumDist = 280

-- Pause for beep
ENT.BeepTime = 0

-- Precache our stuff
util.PrecacheModel ( "models/weapons/w_grenade.mdl" )

-- Returns grenade type
function ENT:GetType()
	return self:GetDTBool( 0 )
end

-- Sets grenade type
function ENT:SetType( iType )
	if iType == 1 then self:SetDTBool( 0, true ) else self:SetDTBool( 0, false ) end
end