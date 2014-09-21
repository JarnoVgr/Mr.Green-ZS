-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Python' Magnum"
	SWEP.Author	= "Pufulet"
	SWEP.Slot = 1
	SWEP.SlotPos = 7
	SWEP.ViewModelFlip = false

	SWEP.ViewModelBoneMods = {
		["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.WElements = {
		--["scope"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(-5, 0, -2), angle = Angle(0, 0, 0), size = Vector(0.3, 0.029, 0.029), color = Color(255, 226, 161, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/XQM/cylinderx2huge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.026, 0.8, -4.676), angle = Angle(-3.507, 0, 0), size = Vector(0.119, 0.023, 0.023), color = Color(255, 255, 220, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
		["scopeholder+"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_Head1", rel = "scope", pos = Vector(3.635, 0, 1), angle = Angle(90, 0, 0), size = Vector(0.029, 0.019, 0.019), color = Color(255, 255, 200, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		["mirror+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(-6.6, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.125, 0.125, 0.125), color = Color(255, 255, 255, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} },
		["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "barrel", pos = Vector(-6.753, 0.15, 0.518), angle = Angle(0, 0, 0), size = Vector(0.079, 0.05, 0.05), color = Color(255, 233, 170, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		["scopeholder"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_Head1", rel = "scope", pos = Vector(-3.636, 0, 1), angle = Angle(90, 104, 0), size = Vector(0.029, 0.019, 0.019), color = Color(255, 255, 200, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		--["mirror"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "scope", pos = Vector(6.599, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.125, 0.125, 0.125), color = Color(255, 255, 255, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} }
	}

	SWEP.VElements = {
		["bullet2+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0.6, -1.101, -2.901), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["scopeholder+"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "scopeholder", pos = Vector(0, -3, 0), angle = Angle(0, 0, 0), size = Vector(0.021, 0.009, 0.009), color = Color(255, 255, 220, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/XQM/cylinderx2huge.mdl", bone = "Python", rel = "", pos = Vector(0, -0.801, 9.6), angle = Angle(90, -19.871, 0), size = Vector(0.119, 0.025, 0.025), color = Color(255, 255, 210, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 1, bodygroup = {} },
		["bullet2++++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -0.801, -2.901), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		--["scope"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "Python", rel = "", pos = Vector(0, -2.597, -5), angle = Angle(0, 0, 0), size = Vector(0.109, 0.109, 0.109), color = Color(200, 200, 200, 220), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "Python", rel = "", pos = Vector(0, -2.597, 0.518), angle = Angle(90, 0, 0), size = Vector(0.25, 0.023, 0.023), color = Color(190, 220, 150, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 1, bodygroup = {} },
		["scopeholder"] = { type = "Model", model = "models/XQM/deg360.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "barrel", pos = Vector(1.2, 0.8, 0), angle = Angle(0, 90, 0), size = Vector(0.021, 0.009, 0.009), color = Color(255, 255, 220, 255), surpresslightning = false, material = "models/xqm/cellshadedcamo_diffuse", skin = 0, bodygroup = {} },
		["bullet2"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0.6, -1.8, -2.901), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bullet2++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.601, -1.8, -2.901), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cylinder"] = { type = "Model", model = "models/XQM/deg360single.mdl", bone = "Cylinder_release", rel = "", pos = Vector(0, -1.471, -2.8), angle = Angle(-90, 0, 0), size = Vector(0.043, 0.043, 0.043), color = Color(255, 255, 158, 255), surpresslightning = false, material = "models/xqm/deg360", skin = 0, bodygroup = {} },
		["bullet2+++"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "Cylinder_release", rel = "", pos = Vector(-0.601, -1.101, -2.901), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	killicon.AddFont( "weapon_zs_magnum", "HL2MPTypeDeath", ".",Color(255, 255, 255, 255 ) )
	SWEP.ViewModelFOV = 60
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel			= Model ( "models/weapons/c_357.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_357.mdl" )
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.HoldType = "revolver"
SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Delay			= 0.4
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.WalkSpeed = 190
SWEP.MaxBulletDistance 		= 200

SWEP.Cone = 0.050
SWEP.ConeMoving = SWEP.Cone *1.4
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.1
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1
--SWEP.ConeIronMoving = SWEP.Moving *0.1

SWEP.IronSightsPos = Vector( -4.8, 22, 0.21 )
SWEP.IronSightsAng = Vector( 0.5, -0.19, 0 )

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.15 <= CurTime()
end

if CLIENT then
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
end
	--GenericBulletCallback(attacker, tr, dmginfo)



