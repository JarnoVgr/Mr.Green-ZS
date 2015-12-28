-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Infernus' Cannon"			
	SWEP.Author	= "Pufulet"
	SWEP.Slot = 0
	SWEP.SlotPos = 6
	SWEP.ViewModelFlip = true
	SWEP.FlipYaw = true
	SWEP.IconLetter = "v"
	killicon.AddFont("weapon_zs_pyroshotgun", "CSKillIcons", SWEP.IconLetter, Color(255, 200, 200, 255 ))
	SWEP.ViewModelFOV = 65
	
	SWEP.VElements = {
		["Cannon1"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(80, 14.548, 17.7), angle = Angle(112.271, -88.583, 77.87), size = Vector(0.342, 0.342, 1.175), color = Color(255, 77, 0, 255), surpresslightning = false, material = "models/props_combine/cit_splode1", skin = 0, bodygroup = {} },
		["Cannon Ammo"] = { type = "Quad", bone = "square", rel = "", pos = Vector(0.002, 0.833, 3.446), angle = Angle(0.606, -180, 59.23), size = 0.05, draw_func = nil},
		["Cannon4"] = { type = "Model", model = "models/props_wasteland/prison_heater001a.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "Cannon3++", pos = Vector(-2.546, -0.327, 1.419), angle = Angle(88.028, -7.111, 85.428), size = Vector(0.097, 0.144, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Cannon3"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "Cannon2", pos = Vector(2.203, -1.782, 62.441), angle = Angle(-6.591, -12.094, -22.455), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Cannon3+"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "Cannon2", pos = Vector(0.509, -2.602, 62.764), angle = Angle(-6.591, -12.094, -22.455), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Cannon2"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "Cannon1", pos = Vector(0.219, 0.1, 14.114), angle = Angle(0.667, -10.792, -1.43), size = Vector(1.552, 1.552, 1.552), color = Color(255, 90, 0, 255), surpresslightning = false, material = "models/props_combine/stasisfield_beam", skin = 0, bodygroup = {} },
		["Cannon3++"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "ValveBiped.Bip01_L_UpperArm", rel = "Cannon2", pos = Vector(3.9, -1.134, 62.487), angle = Angle(-6.591, -12.094, -22.455), size = Vector(0.107, 0.107, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ViewModelBoneMods = {
		["Prong_B"] = { scale = Vector(0.726, 0.975, 0.675), pos = Vector(-0.119, -0.774, -3.922), angle = Angle(19.15, 23.16, 16.457) },
		["Prong_A"] = { scale = Vector(1, 1, 1), pos = Vector(-0.095, -0.269, -5.746), angle = Angle(1.789, 4.342, -32.467) },
		["Base"] = { scale = Vector(1, 1, 2.428), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1.044), pos = Vector(-6.865, -2.422, -0.065), angle = Angle(0, 0, 0) },
		["square"] = { scale = Vector(1, 1, 2.404), pos = Vector(0.093, -2.152, -13.171), angle = Angle(0, 0, 0) }
	}

end

SWEP.IronSightsPos = Vector(-5.2, -15.042, 2.96)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Base				= "weapon_zs_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "physgun"

SWEP.Primary.Sound 			= Sound("weapons/alyxgun/fire02.wav")
SWEP.Primary.Recoil			= 1.75
SWEP.Primary.Damage			= 6
SWEP.Primary.NumShots		= 10
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay			= 0.85
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "alyxgun"
SWEP.TracerName = "AirboatGunHeavyTracer"
SWEP.HumanClass = "pyro"


SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

function SWEP:EmitFireSound()
	self:TakePrimaryAmmo(3);
	self:EmitSound(self.Primary.Sound, 140, math.random(70,75))
end


function SWEP.BulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(1)
		e:SetMagnitude(1)
		e:SetScale(1)
	util.Effect("Sparks", e)

	GenericBulletCallback(attacker, tr, dmginfo)
end

SWEP.WalkSpeed = SPEED_HEAVY - 6

SWEP.Cone = 0.015
SWEP.ConeMoving = 0.0175
SWEP.ConeCrouching = 0.015
SWEP.ConeIron = 0.015
SWEP.ConeIronCrouching = 0.015
SWEP.ConeIronMoving = 0.015

SWEP.IronSightsPos = Vector(-6.361, -14.29, 2.519)
SWEP.IronSightsAng = Vector(0, 0, 0)