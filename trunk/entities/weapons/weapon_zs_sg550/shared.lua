AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "SG550"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	SWEP.ViewModelFOV = 60	
	SWEP.IconLetter = "o"
	killicon.AddFont("weapon_zs_sg550", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.HoldType = "ar2"

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.Primary.Sound = Sound("Weapon_SG550.Single")
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.ReloadDelay	= 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo			= "357"

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 20

SWEP.Cone = 0.04
SWEP.ConeMoving = SWEP.Cone *1.5
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.1
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.1
--SWEP.ConeIronMoving = SWEP.Moving *0.1

SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = SPEED_RIFLE

SWEP.IronSightsPos = Vector(-7.441, -15.039, 1.559)
SWEP.IronSightsAng = Vector(0, 0, 0)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(-0.463, -4.711, 5.598), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 1.391), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.965, 0.953, -5.652), angle = Angle(-9.205, 0, 0), size = Vector(0.5, 0.5, 1.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end


function SWEP:IsScoped()
	if IsValid(self:GetOwner()) and self:GetOwner():GetPerk("_ironaim") then
		return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.05 <= CurTime()
	end
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