AddCSLuaFile()

SWEP.Base = "weapon_zs_medi_base"

if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5
	SWEP.PrintName = "Medi 02"

	SWEP.Slot = 4
	SWEP.SlotPos = 0
		
	SWEP.VElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -1.558, -3.636), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["silencer1"] = { type = "Model", model = "models/gibs/manhack_gib03.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -5, 0.518), angle = Angle(90, -64.287, -31.559), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["silencer"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -1.558), angle = Angle(0, 153.117, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -12.988), angle = Angle(90, 52.597, 0), size = Vector(0.699, 0.899, 0.899), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/white_brushes", skin = 0, bodygroup = {} },
	["front+"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -3.401, -11.9), angle = Angle(90, -57.273, 0), size = Vector(0.699, 0.899, 0.899), color = Color(0, 249, 0, 255), surpresslightning = false, material = "phoenix_storms/smallwheel", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
	["front+"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.519, -5.901, 16.104), angle = Angle(80.649, 94.675, 92.337), size = Vector(0.6, 1, 1), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/smallwheel", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/items/crossbowrounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.519, -5.901, 16.104), angle = Angle(80.649, 90, 0.87), size = Vector(0.6, 1, 1), color = Color(0, 255, 0, 255), surpresslightning = false, material = "phoenix_storms/white_brushes", skin = 0, bodygroup = {} },
	["front+++"] = { type = "Model", model = "models/gibs/manhack_gib03.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.558, -4.676, 3.635), angle = Angle(-82.987, -29.222, -106.364), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front++++"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.7, -2.597, 6.752), angle = Angle(-5.844, 90, -180), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front++"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.5, -4.676, 6.752), angle = Angle(0, 0, 171.817), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}		

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	SWEP.IgnoreThumbs = true
	
	SWEP.IconLetter = "v"		
	killicon.AddFont( "weapon_zs_medigun", "CSKillIcons", SWEP.IconLetter, Color(120, 255, 255, 255 ) )
end

SWEP.ViewModel = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay = 0.13
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "Battery"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Heal = 5
SWEP.Secondary.HealDelay = 12
SWEP.UseHands = true
SWEP.Cone = 0.04
SWEP.ConeMoving = SWEP.Cone *1.12
SWEP.ConeCrouching = SWEP.Cone *0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
SWEP.HumanClass = "medic"
SWEP.WalkSpeed = SPEED_LIGHT
SWEP.HoldType = "smg"

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(130,135))
end
