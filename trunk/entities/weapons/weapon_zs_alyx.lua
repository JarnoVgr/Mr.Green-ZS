AddCSLuaFile()
 
if CLIENT then
	SWEP.PrintName = "Alyx Gun"
	SWEP.ShowViewModel = false 	
		
SWEP.ViewModelBoneMods = {
	["v_weapon.FIVESEVEN_SLIDE"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.FIVESEVEN_PARENT"] = { scale = Vector(0.314, 0.314, 0.314), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.FIVESEVEN_CLIP"] = { scale = Vector(2.513, 2.513, 2.513), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	

	SWEP.VElements = {
		["AlyxGun"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.487, 2.026, -4.248), angle = Angle(169.296, -3.119, 5.383), size = Vector(1.075, 0.931, 0.977), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["1"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -4.676), angle = Angle(12.857, 180, -162.469), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
		
	killicon.AddFont( "weapon_zs_alyx", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
SWEP.Primary.Sound  = Sound("weapons/alyxgun/fire0".. math.random(1,2) ..".wav")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 1.2
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots           = 1
SWEP.Primary.ClipSize           = 15
SWEP.Primary.Delay                      = 0.15
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo                       = "alyxgun"

SWEP.UseHands = true

SWEP.Type = "Incendiary"
SWEP.Slot = 1
SWEP.Weight = 1
SWEP.ConeMax = 0.06
SWEP.ConeMin = 0.04
SWEP.IronSightsPos = Vector(-4.082, -8.763, 2.762)
SWEP.IronSightsAng = Vector(-1.519, -7.147, 0.679)
SWEP.TracerName = "AirboatGunTracer"
SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

function SWEP:OnDeploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	if self.Weapon.HadFirstDeploy then return end
end

SWEP.ShowWorldModel = false
