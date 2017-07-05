AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Scout"
	SWEP.Author	= "ClavusElite"
	SWEP.ViewModelFlip = false
	
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 65
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1.2
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 1.6

SWEP.Slot = 2
SWEP.Weight	= 1
SWEP.Type = "Rifle"
SWEP.ConeMax = 0.04
SWEP.ConeMin = 0.01

SWEP.Secondary.Delay = 0.5

SWEP.IronSightsPos = Vector(-6.68, -19.292, 3.359)
SWEP.IronSightsAng = Vector(0, 0, 0)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.145, -3.422, -0.694), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.944), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.6, 0.638, -4.731), angle = Angle(-11.266, 0, 0), size = Vector(0.768, 0.768, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

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


function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	
	util.PrecacheModel(self.ViewModel)
end