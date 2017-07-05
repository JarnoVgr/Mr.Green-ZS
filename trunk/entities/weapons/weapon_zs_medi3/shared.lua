AddCSLuaFile()

SWEP.Base = "weapon_zs_medi_base"

if CLIENT then
	SWEP.PrintName = "Medi 03"

	
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.943, 0.138), angle = Angle(0, 0, 0) },
	["v_weapon.AK47_Clip"] = { scale = Vector(0.148, 0.148, 0.148), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.AK47_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
	
	SWEP.VElements = {
	["MediShotgun5+"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.488, 5.625), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun"] = { type = "Model", model = "models/props_interiors/BathTub01a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.057, -5.785, -4.639), angle = Angle(-93.547, 89.041, -180), size = Vector(0.305, 0.052, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun7"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.071, -3.122, -16.664), angle = Angle(93.608, -112.109, -65.61), size = Vector(0.284, 0.704, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun6"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun5++"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.473, 6.349), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun6+"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5+", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun8"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.16, -4.476, 8.621), angle = Angle(-91.79, -4.442, -2.72), size = Vector(0.284, 0.284, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun11"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.178, -0.04, 1.784), angle = Angle(-57.126, -97.029, -4.822), size = Vector(0.393, 0.393, 0.393), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun10"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.408, -5.888, 1.615), angle = Angle(3.2, -101.379, -90.067), size = Vector(0.083, 0.071, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_wall/combine_innerwall001", skin = 0, bodygroup = {} },
	["MediShotgun6++"] = { type = "Model", model = "models/weapons/Shotgun_shell.mdl", bone = "v_weapon.AK47_Parent", rel = "MediShotgun5++", pos = Vector(-0.26, 0.096, 1.422), angle = Angle(-89.329, 0, 0), size = Vector(0.395, 0.395, 0.395), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun2"] = { type = "Model", model = "models/props_wasteland/cargo_container01.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.244, -4.051, -3.302), angle = Angle(-177.25, -91.707, -89.936), size = Vector(0.017, 0.067, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun9"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.372, -5.932, -1.864), angle = Angle(-0.176, -1.583, -3.095), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun3"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Clip", rel = "", pos = Vector(0.272, 5.165, -1.568), angle = Angle(-6.65, 2.308, -173.286), size = Vector(1.001, 0.773, 2.522), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_dropship/dropshipsheet", skin = 0, bodygroup = {} },
	["MediShotgun5"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.848, -5.488, 4.846), angle = Angle(14.109, -180, -89.084), size = Vector(0.204, 0.204, 0.204), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun10+"] = { type = "Model", model = "models/mechanics/solid_steel/box_beam_4.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(-0.487, -0.677, 6.355), angle = Angle(2.835, -105.53, -90.775), size = Vector(0.104, 0.105, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phxtended/metal", skin = 0, bodygroup = {} },
	["MediShotgun4"] = { type = "Model", model = "models/effects/medicyell.mdl", bone = "v_weapon.AK47_Clip", rel = "MediShotgun3", pos = Vector(-0.169, 2.052, 0.032), angle = Angle(0, 0, 0), size = Vector(0.245, 0.418, 0.254), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["MediShotgun"] = { type = "Model", model = "models/props_interiors/BathTub01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.678, 0.716, -6.923), angle = Angle(-8.863, 0.165, 0), size = Vector(0.305, 0.052, 0.052), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun7"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.917, 0.483, -5.985), angle = Angle(170.477, -1.127, -102.912), size = Vector(0.284, 0.704, 0.597), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun2"] = { type = "Model", model = "models/props_wasteland/cargo_container01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.362, 0.578, -5.661), angle = Angle(-3.414, -91.294, 171.38), size = Vector(0.017, 0.067, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalset_1-2", skin = 0, bodygroup = {} },
	["MediShotgun3"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.145, 0.828, -0.831), angle = Angle(-1.26, 87.049, 97.689), size = Vector(1.001, 0.773, 2.522), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/combine_dropship/dropshipsheet", skin = 0, bodygroup = {} },
	["MediShotgun9"] = { type = "Model", model = "models/props_trainstation/pole_448Connection002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MediShotgun", pos = Vector(2.19, 0.028, -0.091), angle = Angle(-1.089, -92.372, -88.423), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun11"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.977, 0.653, 0.344), angle = Angle(13.394, 0, 0), size = Vector(0.393, 0.393, 0.393), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["MediShotgun4"] = { type = "Model", model = "models/effects/medicyell.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "MediShotgun3", pos = Vector(-0.169, 2.052, 0.032), angle = Angle(0, 0, 0), size = Vector(0.245, 0.418, 0.254), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true

	SWEP.IconLetter = "d"
	killicon.AddFont( "weapon_zs_medi3", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
	
end

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 7
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.UseHands = true

SWEP.ConeMax = 0.14
SWEP.ConeMin = 0.1
SWEP.Type = "Medical"
SWEP.Weight = 4
SWEP.Slot = 3

SWEP.TracerName = "AR2Tracer"
SWEP.HoldType = "shotgun"

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 90, math.random(100,110))
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end

	if self:Clip1() < 2 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end
	self:TakePrimaryAmmo(1)
	return true
end