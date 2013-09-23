-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "sg552"			
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

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_sg552.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_SG552.Single")
SWEP.Primary.Recoil			= 8
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 28
SWEP.storeclipsize			= 34
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.MaxAmmo			    = 250
SWEP.Secondary.Delay = 0.5

SWEP.WalkSpeed = 195

SWEP.ConeMoving = 0.080
SWEP.Cone = 0.072
SWEP.ConeIron = 0.062
SWEP.ConeCrouching = 0.063
SWEP.ConeIronCrouching = 0.043


SWEP.IronSightsPos = Vector(-7.881, -18.504, 2.599)
SWEP.IronSightsAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(6.635, -10.82, 2.678)
--SWEP.IronSightsAng = Vector(0, 0, 0)