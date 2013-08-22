if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "SG550"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	
	SWEP.IconLetter = "o"
	killicon.AddFont("weapon_zs_sg550", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.HoldType = "ar2"

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.Primary.Sound = Sound("Weapon_SG550.Single")
SWEP.Primary.Recoil = 5.0
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.35
SWEP.Primary.ReloadDelay	= 0.35

SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo			= "357"

SWEP.Cone = 0.04
SWEP.ConeMoving = 0.06
SWEP.ConeCrouching = 0.025
SWEP.ConeIron = 0.035
SWEP.ConeIronCrouching = 0.010

SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = 185

SWEP.IronSightsPos = Vector(-7.441, -15.039, 1.559)
SWEP.IronSightsAng = Vector(0, 0, 0)


function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.4
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