-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include("shared.lua")

function ENT:Initialize()
    hook.Add("PreDrawHalos", "CustDrawHalos".. tostring(self), function()
        if util.tobool(GetConVarNumber("_zs_drawcrateoutline")) then
            if (IsValid(MySelf) and MySelf:Team() == TEAM_HUMAN and MySelf:Alive()) then
                halo.Add(self:GetEntities(), self.LineColor, 1, 1, 1, true, true)
            end
        end
    end)
end

function ENT:OnRemove()
    hook.Remove( "PreDrawHalos", "CustDrawHalos".. tostring( self ) )
end

ENT.LineColor = Color(210, 0, 0, 100)
function ENT:Draw()
    local suppliesAvailable = false

    if (MySelf.NextSupplyTime or 0) <= ServerTime() then
        self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)
        suppliesAvailable = true
    elseif self.LineColor ~= Color(210, 0, 0, 100) then
        self.LineColor = Color(210, 0, 0, 100)
    end

    self:DrawModel()

    if not ValidEntity(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
        return
    end

    --Check for distance with local player
    local pos = self:GetPos() + Vector(0,0,45)
    if pos:Distance(MySelf:GetPos()) > 500 then
        return
    end
          
    local angle = (MySelf:GetPos() - pos):Angle()
    angle.p = 0
    angle.y = angle.y + 90
    angle.r = angle.r + 90

    cam.Start3D2D(pos,angle,0.26)

    if not suppliesAvailable then
    	--Reset cache for once it's active again
    	ResetBestAvailableWeaponsCache()

    	--Calculate time for next supply use possibility
        local timeLeft = math.Round(MySelf.NextSupplyTime - ServerTime())
        draw.SimpleTextOutlined("Weapons and Supplies in 0".. ToMinutesSeconds(timeLeft + 1), "ArialBoldFive", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
    else
    	draw.SimpleTextOutlined("Weapons and Supplies", "ArialBoldSeven", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

    	--Get list of available weapons the player will most likely receive
    	local suppliesList = GetBestAvailableWeapons()
    	local text = "Press E for ".. suppliesList
    	if not suppliesList or suppliesList == "" then
    		text = "Press E to use" 
    	end

        draw.SimpleTextOutlined(text, "ArialBoldFive", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

        draw.SimpleTextOutlined("Earn more SkillWeapons for different weapons", "ArialBoldFour", 0, 40, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
    end
 
    cam.End3D2D()
end
