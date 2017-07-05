AddCSLuaFile()
 
if CLIENT then
        SWEP.PrintName = "Owen's Handgun"
        SWEP.Slot = 1
 
        killicon.AddFont( "weapon_zs_owens", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true 
SWEP.Type = "Pistol" 
SWEP.Weight = 1
SWEP.Primary.Sound  = Sound("Weapon_Pistol.NPC_Single")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 2
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots           = 2
SWEP.Primary.ClipSize           = 12
SWEP.Primary.Delay              = 0.19

SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo               = "pistol"

SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.04
 
SWEP.IronSightsPos = Vector(-5.85,10,2)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
 
SWEP.HoldType = "pistol"

SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = true


