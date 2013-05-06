-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "SG552"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 16
	SWEP.IconLetter = "A"
	killicon.AddFont("weapon_zs_sg552", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "v_weapon.sg552_Parent", rel = "", pos = Vector(-0.013, 3.461, -6.693), angle = Angle(6.018, -86.378, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(29.431, -0.04, -3.326), angle = Angle(97.809, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_rif_sg552.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_sg552.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil			= 1.1 * 5 --1.1
SWEP.Primary.Unrecoil		= 9
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone			= 0.05 -- 0.05
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.MaxAmmo			    = 250
SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = 175

SWEP.Cone = 0.07
SWEP.ConeMoving = 0.10
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.05
SWEP.ConeIronCrouching = 0.04


SWEP.OverridePos = Vector(3.2, -6.394, 1.799)
SWEP.OverrideAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(6.635, -10.82, 2.678)
--SWEP.IronSightsAng = Vector(0, 0, 0)