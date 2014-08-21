AddCSLuaFile()
 
if CLIENT then
        SWEP.PrintName = "Alyx Gun"
        SWEP.Author = "Duby"
        SWEP.Slot = 1
        SWEP.SlotPos = 3
        SWEP.ViewModelFlip = false
        SWEP.ViewModelFOV = 45
       
        SWEP.OverrideAngle = {}
		
		SWEP.ShowViewModel = false 
SWEP.VElements = {
      --  ["pistol"] = { type = "Model", model = "models/weapons/c_pistol.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(26.249, 1.776, 5.823), angle = Angle(1.692, 162.576, 79.93), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	 
	["1"] = { type = "Model", model = "models/weapons/v_alyxgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-20.261, 5.714, -8.832), angle = Angle(-1.17, -1.17, 180), size = Vector(5.037, 5.037, 5.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }  
	  
}

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -4.676), angle = Angle(12.857, 180, -162.469), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
		
		
        killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(0, 0, 150, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
 
SWEP.Weight                             = 5
 
SWEP.HoldType = "pistol"
 
SWEP.Primary.Sound  = Sound("weapons/alyxgun/fire01.wav")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 2
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots           = 1
SWEP.Primary.ClipSize           = 15
SWEP.Primary.Delay                      = 0.3
SWEP.Primary.DefaultClip        = 30
SWEP.Primary.Automatic = false
SWEP.MaxAmmo                        = 160
SWEP.Primary.Ammo                       = "pistol"
SWEP.WalkSpeed = 200
 
SWEP.Cone = 0.045
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.75
SWEP.ConeIron = SWEP.Cone *0.8
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
--SWEP.ConeIronMoving = SWEP.Moving *0.80
 
SWEP.IronSightsPos = Vector(-3.2,-1,1)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
 
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
--SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
--SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
["v_weapon.Glock_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Parent"] = { scale = Vector(0.287, 0.287, 0.287), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Clip"] = { scale = Vector(3, 3, 3), pos = Vector(-0.672, -0.664, -0.24), angle = Angle(3.359, -10.171, 0) }
}