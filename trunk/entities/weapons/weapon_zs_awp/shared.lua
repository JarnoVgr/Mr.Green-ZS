AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "AWP"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 60	
	SWEP.IconLetter = "r"
	killicon.AddFont("weapon_zs_awp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.awm_parent", rel = "", pos = Vector(0, -3.925, 4.525), angle = Angle(-90, 90, 0), size = Vector(0.614, 0.614, 1.062), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.326, 0.935, -6.782), angle = Angle(-10.212, 0, 0), size = Vector(0.595, 0.595, 0.89), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.HoldType = "ar2"

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"
SWEP.Primary.Sound			= Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 1.375
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 2
SWEP.HumanClass = "sharpshooter"
SWEP.IronSightsPos = Vector(-7.481, -11.891, 2.24)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Cone = 0.036
SWEP.ConeMoving = SWEP.Cone *1.75
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.1
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1
--SWEP.ConeIronMoving = SWEP.Moving *0.1

SWEP.WalkSpeed = SPEED_RIFLE

function SWEP:IsScoped()
	if IsValid(self:GetOwner()) and self:GetOwner():GetPerk("_ironaim") then
		return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.05 <= CurTime()
	end
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
		self:DrawCrosshair()			
	end	
end
