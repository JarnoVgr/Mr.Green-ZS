-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then		
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
	SWEP.ShowViewModel = true
	SWEP.ViewModelFOV = 60	
	SWEP.IconLetter = "e"	
	killicon.AddFont("weapon_zs_aug", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.aug_Parent", rel = "", pos = Vector(0.731, -0.322, 21.634), angle = Angle(-86.223, 90, 0), size = Vector(0.5, 0.5, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.575, 1.294, -3.518), angle = Angle(91.344, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_aug.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_aug.mdl" )
SWEP.PrintName			= "AUG"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AUG.Single")
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= 13
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.MaxBulletDistance 		= 3500
SWEP.MaxAmmo			    = 250
SWEP.HumanClass = "commando"
SWEP.Cone = 0.06
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.7
SWEP.ConeIron = SWEP.Cone *0.1
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.WalkSpeed = SPEED_RIFLE

SWEP.IronSightsPos = Vector(-4, 0, 2)
SWEP.IronSightsAng = Vector(0,0,0)

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
