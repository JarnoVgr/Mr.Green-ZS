-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

SWEP.Author = "JetBoom"

SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 4

SWEP.Primary.ClipSize =2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "CombineCannon"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = 150

if CLIENT then killicon.AddFont( "weapon_zs_barricadekit", "HL2MPTypeDeath", "3", Color(255, 80, 0, 255 ) ) end


if CLIENT then
SWEP.VElements = {
	["panel1"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "base", pos = Vector(-2.388, 2.849, 10.538), angle = Angle(87.331, -1.125, -179.862), size = Vector(0.075, 0.075, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["panel2"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "base", pos = Vector(-2.283, -2.164, 10.3), angle = Angle(91.375, -180, -0.212), size = Vector(0.075, 0.075, 0.075), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["laser"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", bone = "base", pos = Vector(-0.519, -3.087, 19.462), angle = Angle(93.263, -81.488, -9.4), size = Vector(0.231, 0.231, 0.231), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["panelcore"] = { type = "Quad", bone = "base", pos = Vector(5.473, 0.37, 9.755), angle = Angle(173.38, -0.443, 0.245), size = 0.094, draw_func = nil}
}

SWEP.WElements = {
	["panelcore"] = { type = "Quad", pos = Vector(7.044, 5.552, -6.968), angle = Angle(2.687, 87.236, -75.652), size = 0.05, draw_func = nil},
	["panel2"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", pos = Vector(6.961, 2.082, -8.277), angle = Angle(-12.238, -2.306, 90.969), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["laser"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", pos = Vector(10.963, 1.475, -9.087), angle = Angle(-16.17, -2.356, -180), size = Vector(0.207, 0.207, 0.207), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["panel1"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", pos = Vector(7.724, 2.2, -5.513), angle = Angle(-16.326, -3.358, 92.337), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

end

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
	self:SetDeploySpeed(1.1)
	
	    if CLIENT then
     
        self:CreateModels(self.VElements) --  create viewmodels
        self:CreateModels(self.WElements) --  create worldmodels
         
        --  init view model bone build function
        self.BuildViewModelBones = function( s )
            if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBonescales then
                for k, v in pairs( self.ViewModelBonescales ) do
                    local bone = s:LookupBone(k)
                    if (not bone) then continue end
                    local m = s:GetBoneMatrix(bone)
                    if (not m) then continue end
                    m:Scale(v)
                    s:SetBoneMatrix(bone, m)
					end
				end
			end
         
			self.VElements["panelcore"].draw_func = function( weapon )    
			draw.SimpleText("Health:", "default", 0, -14, Color(255,0,0,255), TEXT_ALIGN_CENTER)
			draw.SimpleText(""..(250 + (250 * ((HumanClasses[4].Coef[1]*((self.Owner.DataTable["ClassData"]["engineer"].level)+1)) / 100))).."", "default", 0, 0, Color(255,0,0,255), TEXT_ALIGN_CENTER)
			end 
		end
	
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

-- Call this function to update weapon slot and others
function SWEP:Equip ( NewOwner )
	if SERVER then
		gamemode.Call ( "OnWeaponEquip", NewOwner, self )
	end
end

util.PrecacheSound("npc/dog/dog_servo12.wav")

function SWEP:OnRemove()
     
    --  other onremove code goes here
     
    if CLIENT then
        self:RemoveModels()
    end
     
end
     
 
if CLIENT then
 
    SWEP.vRenderOrder = nil
    function SWEP:ViewModelDrawn()
         
        local vm = self.Owner:GetViewModel()
        if not ValidEntity(vm) then return end
         
        if (not self.VElements) then return end
         
        if vm.BuildBonePositions ~= self.BuildViewModelBones then
            vm.BuildBonePositions = self.BuildViewModelBones
        end
 
        if (self.ShowViewModel == nil or self.ShowViewModel) then
            vm:SetColor(255,255,255,255)
        else
            --  we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
            vm:SetColor(255,255,255,1)
        end
         
        if (not self.vRenderOrder) then
             
            --  we build a render order because sprites need to be drawn after models
            self.vRenderOrder = {}
 
            for k, v in pairs( self.VElements ) do
                if (v.type == "Model") then
                    table.insert(self.vRenderOrder, 1, k)
                elseif (v.type == "Sprite" or v.type == "Quad") then
                    table.insert(self.vRenderOrder, k)
                end
            end
             
        end
 
        for k, name in ipairs( self.vRenderOrder ) do
         
            local v = self.VElements[name]
            if (not v) then self.vRenderOrder = nil break end
         
            local model = v.modelEnt
            local sprite = v.spriteMaterial
             
            if (not v.bone) then continue end
            local bone = vm:LookupBone(v.bone)
            if (not bone) then continue end
             
            local pos, ang = Vector(0,0,0), Angle(0,0,0)
            local m = vm:GetBoneMatrix(bone)
            if (m) then
                pos, ang = m:GetTranslation(), m:GetAngle()
            end
             
            if (self.ViewModelFlip) then
                ang.r = -ang.r --  Fixes mirrored models
            end
             
            if (v.type == "Model" and ValidEntity(model)) then
 
                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
 
                model:SetAngles(ang)
                model:SetModelScale(v.size)
                 
                if (v.material == "") then
                    model:SetMaterial("")
                elseif (model:GetMaterial() ~= v.material) then
                    model:SetMaterial( v.material )
                end
                 
                if (v.skin and v.skin ~= model:GetSkin()) then
                    model:SetSkin(v.skin)
                end
                 
                if (v.bodygroup) then
                    for k, v in pairs( v.bodygroup ) do
                        if (model:GetBodygroup(k) ~= v) then
                            model:SetBodygroup(k, v)
                        end
                    end
                end
                 
                if (v.surpresslightning) then
                    render.SuppressEngineLighting(true)
                end
                 
                render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
                render.SetBlend(v.color.a/255)
                model:DrawModel()
                render.SetBlend(1)
                render.SetColorModulation(1, 1, 1)
                 
                if (v.surpresslightning) then
                    render.SuppressEngineLighting(false)
                end
                 
            elseif (v.type == "Sprite" and sprite) then
                 
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                render.SetMaterial(sprite)
                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
                 
            elseif (v.type == "Quad" and v.draw_func) then
                 
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                 
                cam.Start3D2D(drawpos, ang, v.size)
                    v.draw_func( self )
                cam.End3D2D()
 
            end
             
        end
         
    end
 
    SWEP.wRenderOrder = nil
    function SWEP:DrawWorldModel()
         
        if (self.ShowWorldModel == nil or self.ShowWorldModel) then
            self:DrawModel()
        end
         
        if (not self.WElements) then return end
         
        if (not self.wRenderOrder) then
 
            self.wRenderOrder = {}
 
            for k, v in pairs( self.WElements ) do
                if (v.type == "Model") then
                    table.insert(self.wRenderOrder, 1, k)
                elseif (v.type == "Sprite" or v.type == "Quad") then
                    table.insert(self.wRenderOrder, k)
                end
            end
 
        end
         
        local opos, oang = self:GetPos(), self:GetAngles()
        local bone_ent
 
        if (ValidEntity(self.Owner)) then
            bone_ent = self.Owner
        else
            --  when the weapon is dropped
            bone_ent = self
        end
         
        local bone = bone_ent:LookupBone("ValveBiped.Bip01_R_Hand")
        if (bone) then
            local m = bone_ent:GetBoneMatrix(bone)
            if (m) then
                opos, oang = m:GetTranslation(), m:GetAngle()
            end
        end
         
        for k, name in pairs( self.wRenderOrder ) do
         
            local v = self.WElements[name]
            if (not v) then self.wRenderOrder = nil break end
         
            local model = v.modelEnt
            local sprite = v.spriteMaterial
 
            local pos, ang = Vector(opos.x, opos.y, opos.z), Angle(oang.p, oang.y, oang.r)
 
            if (v.type == "Model" and ValidEntity(model)) then
 
                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
 
                model:SetAngles(ang)
                model:SetModelScale(v.size)
                 
                if (v.material == "") then
                    model:SetMaterial("")
                elseif (model:GetMaterial() ~= v.material) then
                    model:SetMaterial( v.material )
                end
                 
                if (v.skin and v.skin ~= model:GetSkin()) then
                    model:SetSkin(v.skin)
                end
                 
                if (v.bodygroup) then
                    for k, v in pairs( v.bodygroup ) do
                        if (model:GetBodygroup(k) ~= v) then
                            model:SetBodygroup(k, v)
                        end
                    end
                end
                 
                if (v.surpresslightning) then
                    render.SuppressEngineLighting(true)
                end
                 
                render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
                render.SetBlend(v.color.a/255)
                model:DrawModel()
                render.SetBlend(1)
                render.SetColorModulation(1, 1, 1)
                 
                if (v.surpresslightning) then
                    render.SuppressEngineLighting(false)
                end
                 
            elseif (v.type == "Sprite" and sprite) then
                 
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                render.SetMaterial(sprite)
                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
                 
            elseif (v.type == "Quad" and v.draw_func) then
                 
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                 
                cam.Start3D2D(drawpos, ang, v.size)
                    v.draw_func( self )
                cam.End3D2D()
 
            end
             
        end
         
    end
 
    function SWEP:CreateModels( tab )
 
        if (not tab) then return end
 
        --  Create the clientside models here because Garry says we can't do it in the render hook
        for k, v in pairs( tab ) do
            if (v.type == "Model" and v.model and v.model ~= "" and (not ValidEntity(v.modelEnt) or v.createdModel ~= v.model) and
                    string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
                 
                v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
                if (ValidEntity(v.modelEnt)) then
                    v.modelEnt:SetPos(self:GetPos())
                    v.modelEnt:SetAngles(self:GetAngles())
                    v.modelEnt:SetParent(self)
                    v.modelEnt:SetNoDraw(true)
                    v.createdModel = v.model
                else
                    v.modelEnt = nil
                end
                 
            elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite)
                and file.Exists ("../materials/"..v.sprite..".vmt")) then
                 
                local name = v.sprite.."-"
                local params = { ["$basetexture"] = v.sprite }
                --  make sure we create a unique name based on the selected options
                local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
                for i, j in pairs( tocheck ) do
                    if (v[j]) then
                        params["$"..j] = 1
                        name = name.."1"
                    else
                        name = name.."0"
                    end
                end
 
                v.createdSprite = v.sprite
                v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
                 
            end
        end
         
    end
 
    function SWEP:RemoveModels()
        if (self.VElements) then
            for k, v in pairs( self.VElements ) do
                if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
            end
        end
        if (self.WElements) then
            for k, v in pairs( self.WElements ) do
                if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
            end
        end
        self.VElements = nil
        self.WElements = nil
    end
 
end

