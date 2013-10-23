if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "AWP"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	SWEP.IconLetter = "r"
	killicon.AddFont("weapon_zs_awp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.HoldType = "ar2"

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"

SWEP.Weight				= 6

SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil			= 21
SWEP.Primary.Damage			= 360
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 4
SWEP.Primary.Delay			= 2
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 2

SWEP.IronSightsPos = Vector(-7.481, -11.891, 2.24)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.ConeMoving = 0.71
SWEP.Cone = 0.01
SWEP.ConeIron = 0.001
SWEP.ConeCrouching = 0.01
SWEP.ConeIronCrouching = 0.001

SWEP.WalkSpeed = 195



function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25
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
