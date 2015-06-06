AddCSLuaFile()
 
if CLIENT then
        SWEP.PrintName = "Alyx Gun"
        SWEP.Author = "Duby"
        SWEP.Slot = 1
        SWEP.SlotPos = 3
        SWEP.OverrideAngle = {}
		SWEP.ShowViewModel = false 
		SWEP.ViewModelFOV = 60		
		
	SWEP.ViewModelBoneMods = {
	["v_weapon.FIVESEVEN_PARENT"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
	

SWEP.VElements = {
	["alyxgun"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.07, 1.671, -4.04), angle = Angle(176.841, 4.718, 3.109), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["1"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -4.676), angle = Angle(12.857, 180, -162.469), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
		
		
        killicon.AddFont( "weapon_zs_alyx", "HL2MPTypeDeath", "-", Color(255, 200, 200, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true

SWEP.Primary.Sound  = Sound("weapons/alyxgun/fire01.wav")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 1
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots           = 1
SWEP.Primary.ClipSize           = 15
SWEP.Primary.Delay                      = 0.11
SWEP.Primary.DefaultClip        = 75
SWEP.Primary.Automatic = true
SWEP.MaxAmmo                        = 160
SWEP.Primary.Ammo                       = "alyxgun"
SWEP.WalkSpeed = SPEED_PISTOL
SWEP.UseHands = true
SWEP.Cone = 0.055
SWEP.ConeMoving = SWEP.Cone *1.2
SWEP.ConeCrouching = SWEP.Cone *0.8
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.95

SWEP.IronSightsPos = Vector(-4.59,25,0.65)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
 
SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
--SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"
--SWEP.WorldModel = "models/weapons/w_pistol.mdl"
--SWEP.ShowViewModel = true

function SWEP:OnDeploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	if self.Weapon.HadFirstDeploy then return end

	if IsValid(self.Owner) and self.Owner:GetPerk("_alyxclip") then
		self.Weapon.HadFirstDeploy = true	
		self.Owner:GiveAmmo( self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
	end		
end


SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
["v_weapon.Glock_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Parent"] = { scale = Vector(0.287, 0.287, 0.287), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Clip"] = { scale = Vector(3, 3, 3), pos = Vector(-0.672, -0.664, -0.24), angle = Angle(3.359, -10.171, 0) }
}