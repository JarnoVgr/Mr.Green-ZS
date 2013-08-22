-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "FAMAS"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "t"
	killicon.AddFont("weapon_zs_famas", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.famas", rel = "", pos = Vector(0.041, -0.094, 0.859), angle = Angle(0, 93.305, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.312, -0.08, -2.339), angle = Angle(-90.025, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_famas.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_famas.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_FAMAS.Single")
SWEP.Primary.Recoil			= 6.5 -- 1.5 It's like butter on 1.5 :o
SWEP.Primary.Unrecoil		= 9
SWEP.Primary.Damage			= 21
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.MaxAmmo			    = 250
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.04
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.05
SWEP.ConeMoving = 0.08
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.04
SWEP.ConeIronCrouching = 0.02

SWEP.WalkSpeed = 185
SWEP.MaxBulletDistance 		= 2300

SWEP.IronSightsPos = Vector(-4,-3,1)
SWEP.IronSightsAng = Vector(3,.5,4)

SWEP.OverridePos = Vector(-1.56, -1.968, 1.44)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-1.56, -1.968, 1.44)
--SWEP.IronSightsAng = Vector(0, 0, 0)