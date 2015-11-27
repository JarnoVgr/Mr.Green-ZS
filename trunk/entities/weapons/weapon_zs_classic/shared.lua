AddCSLuaFile()
 
if CLIENT then
        SWEP.PrintName = "Pistol"
        SWEP.Author = "NECROSSIN"
        SWEP.Slot = 1
        SWEP.SlotPos = 3
        SWEP.ViewModelFOV = 60
       
        SWEP.OverrideAngle = {}
 
        killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
SWEP.HoldType = "pistol"
SWEP.Primary.Sound  = Sound("Weapon_Pistol.NPC_Single")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 1.4
SWEP.Primary.Damage = 9.5
SWEP.Primary.NumShots           = 2
SWEP.Primary.ClipSize           = 12
SWEP.Primary.Delay              = 0.16
SWEP.Primary.DefaultClip        = SWEP.Primary.ClipSize * 5
SWEP.MaxAmmo                    = 160
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo               = "pistol"
SWEP.WalkSpeed = SPEED_PISTOL
 
SWEP.Cone = 0.071
SWEP.ConeMoving = SWEP.Cone *1.2
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
--SWEP.ConeIronMoving = SWEP.Moving *0.80
 
SWEP.IronSightsPos = Vector(-5.85,10,2)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
 
SWEP.HumanClass = "medic" 
 
SWEP.VElements = {
        ["pistol"] = { type = "Model", model = "models/weapons/c_pistol.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(26.249, 1.776, 5.823), angle = Angle(1.692, 162.576, 79.93), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
["v_weapon.Glock_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Parent"] = { scale = Vector(0.287, 0.287, 0.287), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
["v_weapon.Glock_Clip"] = { scale = Vector(3, 3, 3), pos = Vector(-0.672, -0.664, -0.24), angle = Angle(3.359, -10.171, 0) }
}