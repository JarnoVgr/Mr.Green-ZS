AddCSLuaFile()
 
if CLIENT then
	SWEP.PrintName = "Alyx Gun"
	SWEP.Author = "Braindawg"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ShowViewModel = false 
	SWEP.ViewModelFOV = 60		
		
	SWEP.ViewModelBoneMods = {
		["v_weapon.Glock_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Glock_Parent"] = { scale = Vector(0.287, 0.287, 0.287), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.FIVESEVEN_PARENT"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.5, 0, -0.5), angle = Angle(0, 0, 0) }
	}
	SWEP.VElements = {
		["Alyx Gun"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.706, 2.01, -4.006), angle = Angle(172.666, 1.973, 5.897), size = Vector(0.935, 0.935, 0.935), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["1"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -4.676), angle = Angle(12.857, 180, -162.469), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
		
	killicon.AddFont( "weapon_zs_alyx", "HL2MPTypeDeath", "-", Color(255, 200, 200, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
SWEP.Primary.Sound  = Sound("weapons/alyxgun/fire0".. math.random(1,2) ..".wav")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 1.2
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots           = 1
SWEP.Primary.ClipSize           = 15
SWEP.Primary.Delay                      = 0.15
SWEP.Primary.DefaultClip        = 15 * 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo                       = "alyxgun"
SWEP.WalkSpeed = SPEED_PISTOL
SWEP.UseHands = true
SWEP.Cone = 0.056
SWEP.ConeMoving = SWEP.Cone *1.2
SWEP.ConeCrouching = SWEP.Cone *0.8
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.85
SWEP.HumanClass = "pyro"
SWEP.IronSightsPos = Vector(-5.961, 0, 2.89)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.TracerName = "AirboatGunTracer"
SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

function SWEP:OnDeploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	if self.Weapon.HadFirstDeploy then return end
end

SWEP.ShowWorldModel = false
