-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "ump"			
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 20
	SWEP.ViewModelFOV = 65
	SWEP.IconLetter = "q"
	killicon.AddFont("weapon_zs_ump", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.ump45_Parent", rel = "", pos = Vector(0.314, 6.164, -10.105), angle = Angle(15.684, -84.537, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23.194, 0.109, -6.411), angle = Angle(84.253, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_ump45.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_ump45.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil			= 9
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 28
SWEP.Primary.Delay			= 0.13
SWEP.Primary.DefaultClip	= 56
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )


SWEP.ConeMoving = 0.083
SWEP.Cone = 0.074
SWEP.ConeCrouching = 0.060

SWEP.MaxAmmo			    = 250

SWEP.WalkSpeed = 185
SWEP.MaxBulletDistance 		= 2240

SWEP.IronSightsPos = Vector(-8.721, -12.047, 4.039)
SWEP.IronSightsAng = Vector(-1.379, -0.276, -1.93)

SWEP.OverridePos = Vector(3.599, -4.591, 1.6)
SWEP.OverrideAng = Vector(0, 0, 1.888)

--SWEP.IronSightsPos = Vector(3.599, -4.591, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 1.888)