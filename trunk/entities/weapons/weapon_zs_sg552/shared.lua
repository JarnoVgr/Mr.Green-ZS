-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "SG552"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 16
	SWEP.IconLetter = "A"
	killicon.AddFont("weapon_zs_sg552", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.ViewModelFOV = 60
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.sg552_Parent", rel = "", pos = Vector(-0.317, -1.795, 4.256), angle = Angle(-70.569, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(29.431, -0.04, -3.326), angle = Angle(97.809, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_sg552.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 24
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.MaxAmmo			    = 250
SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = SPEED_RIFLE

SWEP.Cone = 0.061
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.80
SWEP.ConeIron = SWEP.Cone *0.10
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.10
--SWEP.ConeIronMoving = SWEP.Moving *0.10


SWEP.IronSightsPos = Vector( -6, -8.504, 2.599 )
SWEP.IronSightsAng = Vector( 0, 2, 0 )



--SWEP.IronSightsPos = Vector(6.635, -10.82, 2.678)
--SWEP.IronSightsAng = Vector(0, 0, 0)