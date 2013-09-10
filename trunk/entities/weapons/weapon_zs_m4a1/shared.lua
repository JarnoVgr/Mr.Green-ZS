-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "m4a1"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 8
	SWEP.IconLetter = "w"
	
	SWEP.IgnoreThumbs = true
	
	SWEP.OverrideTranslation = {}
	SWEP.OverrideTranslation["v_weapon.Right_Hand"] = Vector(-1.2,0,0)
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["v_weapon.Right_Arm"] = Angle(0,0,80)

	
	killicon.AddFont("weapon_zs_m4a1", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.m4_Parent", rel = "", pos = Vector(0.257, 3.138, -7.19), angle = Angle(0, 85.456, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6.818, 1.296, -5.288), angle = Angle(-81.126, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_m4a1.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_m4a1.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_M4A1.Single")
SWEP.Primary.Recoil			= 6
SWEP.Primary.Damage			= 18.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.ConeMoving = 0.080
SWEP.Cone = 0.073
SWEP.ConeCrouching = 0.063

SWEP.MaxAmmo			    = 250

SWEP.WalkSpeed = 180
SWEP.MaxBulletDistance 		= 2600

SWEP.IronSightsPos = Vector(-8.05, -5, 0.5)
SWEP.IronSightsAng = Vector(3, -4, -4)

SWEP.OverridePos = Vector(2.64, -3.379, 1)
SWEP.OverrideAng = Vector(0, 0, 3.144)

--SWEP.IronSightsPos = Vector(2.64, -3.379, 1)
--SWEP.IronSightsAng = Vector(0, 0, 3.144)
