-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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

local cam = cam
local render = render
local draw = draw

ENT.LineColor = Color(210, 0, 0, 100)
function ENT:Draw()
    self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)    
    self:DrawModel()

    if not ValidEntity(MySelf) then
        return
    end

    if MySelf:Team() ~= TEAM_HUMAN then
        self:DrawModel()
        return
    end

    --Draw some stuff
        
    local pos = self:GetPos() + Vector(0,0,45)

    --Check for distance with local player
    if pos:Distance(MySelf:GetPos()) > 500 then
        return
    end
          
    local angle = (MySelf:GetPos() - pos):Angle()
    angle.p = 0
    angle.y = angle.y + 90
    angle.r = angle.r + 90

    cam.Start3D2D(pos,angle,0.26)

    draw.SimpleTextOutlined("Weapons and Supplies", "ArialBoldSeven", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
    draw.SimpleTextOutlined("Press E to use", "ArialBoldFive", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
                
    cam.End3D2D()
end
