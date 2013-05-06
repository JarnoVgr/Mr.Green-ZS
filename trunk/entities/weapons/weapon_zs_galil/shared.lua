-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Galil"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "v"
	killicon.AddFont("weapon_zs_galil", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.galil", rel = "", pos = Vector(-0.075, 0.296, -7.994), angle = Angle(8.277, 94.233, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(26.448, 0, -5.019), angle = Angle(84.732, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_rif_galil.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_galil.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_Galil.Single")
SWEP.Primary.Recoil			= 1.5 * 4.5 -- 1.5
SWEP.Primary.Unrecoil		= 16
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 26
SWEP.storeclipsize			= 30
SWEP.MaxAmmo			    = 250
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.04
SWEP.ConeMoving				= 0.08
SWEP.ConeCrouching			= 0.02
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.WalkSpeed = 175
SWEP.MaxBulletDistance 		= 2750 

SWEP.Cone = 0.05
SWEP.ConeMoving = 0.14
SWEP.ConeCrouching = 0.04
SWEP.ConeIron = 0.04
SWEP.ConeIronCrouching = 0.03

SWEP.IronSightsPos = Vector(-5.15,-3,2.37)
SWEP.IronSightsAng = Vector(-.4,0,0)

SWEP.OverridePos = Vector(-2, -3.541, 1.519)
SWEP.OverrideAng = Vector( 0,0,0 )

--SWEP.IronSightsPos = Vector(-2, -3.541, 1.519)
--SWEP.IronSightsAng = Vector(0, 0, 0)