-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
end

ENT.LineColor = Color ( 210, 0,0, 100 )
function ENT:Think()
    if ( not GAMEMODE:GetFighting() and GAMEMODE:GetWave() ~= 6 ) then
        self.LineColor = Color( 0, math.abs ( 200 * math.sin ( CurTime() * 3 ) ),0, 100 )
    end
    
    if ( MySelf:Team() == TEAM_HUMAN and MySelf:Alive() ) then
        effects.halo.Add( self:GetEntities(), self.LineColor, 1, 1, 1, true, true )
    end
end
