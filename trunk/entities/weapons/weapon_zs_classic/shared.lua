AddCSLuaFile()
 
if CLIENT then
        SWEP.PrintName = "'Classic' Pistol"
        SWEP.Author = "NECROSSIN"
        SWEP.Slot = 1
        SWEP.SlotPos = 3
        SWEP.ViewModelFlip = false
        SWEP.ViewModelFOV = 50
       
        SWEP.OverrideAngle = {}
 
        killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end
 
SWEP.Base = "weapon_zs_base"
 
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true
 
SWEP.Weight                             = 5
 
SWEP.HoldType = "pistol"
 
SWEP.Primary.Sound  = Sound("Weapon_Pistol.NPC_Single")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil  = 1
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots           = 2
SWEP.Primary.ClipSize           = 12
SWEP.Primary.Delay                      = 0.16
SWEP.Primary.DefaultClip        = 60
SWEP.MaxAmmo                        = 160
SWEP.Primary.Automatic          = false
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


function SWEP:EmitFireSound()
self:EmitSound(self.Primary.Sound, 80, 70 + (1 - (self:Clip1() / self.Primary.ClipSize)) * 90)
end

function SWEP:ShootBullets(dmg, numbul, cone)
if self:Clip1() == 1 then
dmg = dmg * 3
else
dmg = dmg + dmg * (1 - self:Clip1() / self.Primary.ClipSize)
end

self.BaseClass.ShootBullets(self, dmg, numbul, cone)
end
