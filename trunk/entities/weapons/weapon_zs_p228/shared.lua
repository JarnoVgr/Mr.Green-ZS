-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "P228"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 1
	SWEP.ViewModelFOV = 68
	SWEP.SlotPos = 1
	killicon.AddFont("weapon_zs_p228", "CSKillIcons", "a", Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.p228_Parent", rel = "", pos = Vector(0.002, 1.19, -2.61), angle = Angle(93.39, 90, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.209, 0.662, -1.331), angle = Angle(0, 0, -180), size = Vector(0.414, 0.414, 0.414), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_pist_p228.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_pist_p228.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil			= 2.25 * 2 -- 2.25
SWEP.Primary.Damage			= 90
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 18
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 80
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.14
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.09
SWEP.ConeMoving = 0.18
SWEP.ConeCrouching = 0.10
SWEP.ConeIron = 0.07
SWEP.ConeIronCrouching = 0.03

SWEP.MaxBulletDistance 		= 1800

SWEP.MaxAmmo			    = 130

SWEP.IronSightsPos = Vector(4.76,-2,2.955)
SWEP.IronSightsAng = Vector(-.6,0,0)

SWEP.OverridePos = Vector(1.6, -1.624, 1.559)
SWEP.OverrideAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(1.6, -1.624, 1.559)
--SWEP.IronSightsAng = Vector(0, 0, 0)