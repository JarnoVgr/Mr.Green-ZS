if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "Scout"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	
	
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 13
SWEP.Primary.Damage			= 55
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1.8
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 1.5

SWEP.ConeMoving = 0.070
SWEP.Cone = 0.025
SWEP.ConeCrouching = 0.001

SWEP.WalkSpeed = 185

SWEP.MaxAmmo			    = 40

SWEP.Secondary.Delay = 0.5

SWEP.IronSightsPos = Vector(-6.68, -19.292, 3.359)
SWEP.IronSightsAng = Vector(0, 0, 0)

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


function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	
	util.PrecacheModel(self.ViewModel)
end