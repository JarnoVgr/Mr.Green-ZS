-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

function ENT:Initialize()
    hook.Add("PreDrawHalos", "PreDrawHalos".. tostring(self), function()
        if util.tobool(GetConVarNumber("_zs_drawcrateoutline")) then
            if (IsValid(MySelf) and MySelf:Team() == TEAM_HUMAN and MySelf:Alive()) then
                halo.Render({ 
                    Ents = self:GetEntities(),  
                    Color = self.LineColor, 
                    BlurX = 1, 
                    BlurY = 1, 
                    DrawPasses = 1,
                    Additive = true, 
                    IgnoreZ = true 
                })
            end   
        end   
    end)
end

function ENT:OnRemove()
    hook.Remove( "PreDrawHalos", "PreDrawHalos"..tostring( self ) )
end

ENT.LineColor = Color(210, 0, 0, 100)
function ENT:Draw()
    self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)    
    self:DrawModel()
end