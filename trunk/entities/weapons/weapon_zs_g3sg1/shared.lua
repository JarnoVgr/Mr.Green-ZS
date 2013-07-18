if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "G3-SG1"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	
	SWEP.IconLetter = "i"
	killicon.AddFont("weapon_zs_g3sg1", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.HoldType = "ar2"

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.Primary.Sound = Sound("Weapon_G3SG1.Single")
SWEP.Primary.Recoil = 6.0
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.75

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo			= "357"

SWEP.Cone = 0.13
SWEP.ConeMoving = 0.19
SWEP.ConeCrouching = 0.08
SWEP.ConeIron = 0.03
SWEP.ConeIronCrouching = 0.015

SWEP.WalkSpeed = 170

SWEP.IronSightsPos = Vector(5.39, -5.816, 2.16)
SWEP.IronSightsAng = Vector(0, 0, 0)



function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.3
	--SWEP.MinFOV = GetConVarNumber("fov_desired") * 0.25
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

