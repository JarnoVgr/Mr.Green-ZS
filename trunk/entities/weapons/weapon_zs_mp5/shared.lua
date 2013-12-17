-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "mp5"			
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 12
	SWEP.ViewModelFlip = false
	SWEP.IconLetter = "x"
	SWEP.ViewModelFOV = 65
	killicon.AddFont("weapon_zs_mp5", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.MP5_Parent", rel = "", pos = Vector(0.063, 4.046, 12.883), angle = Angle(-165.982, 94.841, 0), size = Vector(0.671, 0.671, 0.671), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.881, 0.867, -6.048), angle = Angle(-79.633, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_mp5.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_mp5.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 24
SWEP.Primary.Delay			= 0.115
SWEP.Primary.DefaultClip	= 128
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.MaxAmmo			    = 250


SWEP.ConeMoving = 0.057
SWEP.Cone = 0.049
SWEP.ConeIron = 0.041
SWEP.ConeCrouching = 0.037
SWEP.ConeIronCrouching = 0.029

SWEP.WalkSpeed = 195
SWEP.MaxBulletDistance 		= 2300

--SWEP.IronSightsPos = Vector(4.72,-2,1.86)
--SWEP.IronSightsAng = Vector(1.2,-.15,0)
SWEP.IronSightsPos = Vector( -5.361, -1.5, 1.6 )
SWEP.IronSightsAng = Vector( 1.9, 0, 0 )


SWEP.OverridePos = Vector( 1.6, -2.623, 1.559 )
SWEP.OverrideAng = Vector( 0, 0, 0 )


--SWEP.IronSightsPos = Vector(1.6, -2.623, 1.559)
--SWEP.IronSightsAng = Vector(0, 0, 0)


