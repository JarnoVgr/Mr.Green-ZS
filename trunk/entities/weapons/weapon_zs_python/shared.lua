-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
     
AddCSLuaFile()
     
    if CLIENT then
            SWEP.PrintName = "'Python' Magnum"
            SWEP.Author     = "Pufulet"
            SWEP.ViewModelFlip = false
			SWEP.ViewModelFOV = 60
	 
    SWEP.ViewModelBoneMods = {
            ["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
            ["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
    }
           
    SWEP.VElements = {
            ["bullet3"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -0.801, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["handle"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "Python", rel = "", pos = Vector(0.449, 0.6, -2.401), angle = Angle(90, 180, 180), size = Vector(0.037, 0.037, 0.059), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["scope+"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "Python", rel = "scope", pos = Vector(-5.27, 0, 0), angle = Angle(-180, 180, 0), size = Vector(0.119, 0.029, 0.029), color = Color(220, 240, 200, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["bullet3++"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.561, -1.8, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["scopeholder"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_L_Finger1", rel = "scope", pos = Vector(-1.601, 0, -1.25), angle = Angle(0, 90, 0), size = Vector(0.064, 0.059, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["handle++"] = { type = "Model", model = "models/Gibs/wood_gib01d.mdl", bone = "Python", rel = "", pos = Vector(0.479, 0.699, -2.6), angle = Angle(-12, 90, 99.35), size = Vector(0.029, 0.029, 0.029), color = Color(255, 25, 25, 255), surpresslightning = false, material = "models/xqm/squaredmat", skin = 0, bodygroup = {} },
            ["cylinder+++"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 0.1), angle = Angle(-90, -180, 90), size = Vector(0.059, 0.09, 0.09), color = Color(238, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["mirror"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "Cylinder", rel = "scope+", pos = Vector(-2.6, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.016, 0.016, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} },
            ["handle+"] = { type = "Model", model = "models/Gibs/wood_gib01d.mdl", bone = "Python", rel = "", pos = Vector(0.479, 0.699, -2.201), angle = Angle(10.519, 90, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 25, 25, 255), surpresslightning = false, material = "models/xqm/squaredmat", skin = 0, bodygroup = {} },
            ["cylinder+++++"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 0.1), angle = Angle(-90, -180, 90), size = Vector(0.059, 0.09, 0.09), color = Color(226, 206, 92, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["scopeholder+"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_L_Finger1", rel = "scope", pos = Vector(-4, 0, -0.7), angle = Angle(0, 90, 0), size = Vector(0.05, 0.059, 0.079), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -1.425, -0.5), angle = Angle(90, 120, 0), size = Vector(0.1, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["cylinder++"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Bullet1", rel = "", pos = Vector(0, 0, 1.399), angle = Angle(90, -90, 0), size = Vector(0.059, 0.013, 0.013), color = Color(255, 255, 54, 255), surpresslightning = false, material = "models/xqm/2deg360_diffuse", skin = 0, bodygroup = {} },
            ["tube"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "Python", rel = "", pos = Vector(0, -0.63, 6), angle = Angle(90, 120, 0), size = Vector(0.2, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["bullet3+++"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.561, -1.101, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["cylinder++++"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Bullet2", rel = "", pos = Vector(0, 0, 1.399), angle = Angle(90, -90, 0), size = Vector(0.059, 0.013, 0.013), color = Color(255, 255, 54, 255), surpresslightning = false, material = "models/xqm/2deg360_diffuse", skin = 0, bodygroup = {} },
            ["scope"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "Python", rel = "", pos = Vector(0, -2.6, 3.25), angle = Angle(90, -94.676, 0), size = Vector(0.119, 0.028, 0.028), color = Color(220, 240, 200, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["cylinder+"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Cylinder", rel = "scope", pos = Vector(-2.35, 0, 0), angle = Angle(0, 0, -125.066), size = Vector(0.019, 0.032, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["bullet3+"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0.6, -1.101, -3), angle = Angle(180, 180, 90), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
     
    SWEP.WElements = {
            ["tube"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "cylinder", pos = Vector(5, -0.201, -1), angle = Angle(-5, 1, 180), size = Vector(0.23, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["scope++"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_Head1", rel = "cylinder", pos = Vector(4.849, -0.101, -2.901), angle = Angle(90, 0, 0), size = Vector(0.013, 0.013, 0.013), color = Color(204, 255, 193, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} },
            ["tube+"] = { type = "Model", model = "models/XQM/cylinderx1huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "tube", pos = Vector(5.099, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.019, 0.021, 0.021), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
            ["scopeholder+"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(2, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["scope+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_Head1", rel = "cylinder", pos = Vector(-4.801, 0.1, -2.26), angle = Angle(90, 0, 0), size = Vector(0.013, 0.013, 0.013), color = Color(204, 255, 193, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} },
            ["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1, -3.701), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
            ["scopeholder"] = { type = "Model", model = "models/props_c17/lampShade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-2, 0, 1), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
            ["scope"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_Head1", rel = "cylinder", pos = Vector(0, 0, -2.6), angle = Angle(-4, 1, 0), size = Vector(0.219, 0.025, 0.025), color = Color(204, 255, 193, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} }
    }
           -- killicon.AddFont( "weapon_zs_magnum", "HL2MPTypeDeath", ".",Color(255, 0, 0, 255 ) )
            SWEP.ViewModelFOV = 60
    end
     
    SWEP.Base = "weapon_zs_base"
    SWEP.Slot = 5
    SWEP.SlotPos = 1
    SWEP.Spawnable                  = true
    SWEP.AdminSpawnable             = true
    SWEP.ViewModel                  = Model ( "models/weapons/c_357.mdl" )
    SWEP.UseHands = true
    SWEP.WorldModel                 = Model ( "models/weapons/w_357.mdl" )
    SWEP.AutoSwitchTo               = false
    SWEP.AutoSwitchFrom             = false
    SWEP.HoldType = "revolver"
    SWEP.Primary.Sound                      = Sound( "Weapon_357.Single" )
    SWEP.Primary.Recoil                     = 2.5
    SWEP.Primary.Damage                     = 40
    SWEP.Primary.NumShots           = 1
    SWEP.Primary.ClipSize           = 2
    SWEP.Primary.Delay                      = 0.5
    SWEP.Primary.DefaultClip        = SWEP.Primary.ClipSize
    SWEP.Primary.Automatic          = false
    SWEP.Primary.Ammo                       = "357"
    SWEP.WalkSpeed = SPEED_PISTOL
    SWEP.MaxBulletDistance          = 2000
     
    SWEP.Cone = 0.06
    SWEP.ConeMoving = SWEP.Cone *1.4
    SWEP.ConeCrouching = SWEP.Cone *0.9
    SWEP.ConeIron = SWEP.Cone *0.2
    SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1
    SWEP.ConeIronMoving = SWEP.ConeMoving *0.1
     
    SWEP.IronSightsPos = Vector( -4.8, 22, 0.21 )
    SWEP.IronSightsAng = Vector( 0.5, -0.19, 0 )
     
    function SWEP:IsScoped()
            return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.15 <= CurTime()
    end
	

	function SWEP:OnDeploy()
		if self.Owner:GetPerk("_musket") then
			self.Primary.ClipSize = 4
		
		end
		--self:SendWeaponAnim(ACT_VM_IDLE)
	end
		
     
   --[[ if CLIENT then
            SWEP.IronsightsMultiplier = 0.50
     
            function SWEP:GetViewModelPosition(pos, ang)
                    if self:IsScoped() then
                            return pos + ang:Up() * 256
                    end
     
                    return self.BaseClass.GetViewModelPosition(self, pos, ang)
            end
     
            function SWEP:DrawHUD()
                    if self:IsScoped() then
                            self:DrawScope()
                    end
            end    
    end]]--
	
	if CLIENT then

	local texGradDown = surface.GetTextureID("VGUI/gradient_down")
	function SWEP:DrawHUD()
		self:DrawCrosshair()	
		local wid, hei = ScaleW(150), ScaleH(32)
		--local space = 12+ScaleW(7)
		local space = 12+ScaleW(-120)
		local x, y = ScrW() - wid - 12, ScrH() - ScaleH(73) - 12
		y = y + ScaleH(73)/2 - hei/2
		surface.SetFont("ssNewAmmoFont13")
		local tw, th = surface.GetTextSize("Magnum Python")
		local texty = y + hei/2 

		--local charges = self:GetPrimaryAmmoCount()
		--[[if charges > 0 then
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		else
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end]]--
		
		 if self:IsScoped() then
                            self:DrawScope()
                    end
		
	end
	
	SWEP.IronsightsMultiplier = 0.50
     
            function SWEP:GetViewModelPosition(pos, ang)
                    if self:IsScoped() then
                            return pos + ang:Up() * 256
                    end
     
                    return self.BaseClass.GetViewModelPosition(self, pos, ang)
            end
end