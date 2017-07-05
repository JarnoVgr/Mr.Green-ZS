-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "SG552"			
	SWEP.IconLetter = "A"
	killicon.AddFont("weapon_zs_sg552", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.sg552_Parent", rel = "", pos = Vector(-0.317, -1.795, 4.256), angle = Angle(-70.569, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(29.431, -0.04, -3.326), angle = Angle(97.809, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_sg552.mdl" )

SWEP.HoldType = "ar2"

SWEP.Type = "Assault Rifle"
SWEP.Slot = 2
SWEP.Weight = 3
SWEP.ConeMax = 0.13
SWEP.ConeMin = 0.06

SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 36
SWEP.Primary.Delay			= 0.125
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.MaxAmmo			    = 250
SWEP.Secondary.Delay = 0.5




SWEP.IronSightsPos = Vector( -6, -8.504, 2.599 )
SWEP.IronSightsAng = Vector( 0, 2, 0 )

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25
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
		self:DrawCrosshair()	
	end	
end


--SWEP.IronSightsPos = Vector(6.635, -10.82, 2.678)
--SWEP.IronSightsAng = Vector(0, 0, 0)