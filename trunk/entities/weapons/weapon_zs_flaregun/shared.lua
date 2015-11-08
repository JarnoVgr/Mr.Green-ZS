AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Flare Gun"			
	SWEP.Author	= "Braindawg"
	SWEP.Slot = 1
	SWEP.SlotPos = 6
	SWEP.ViewModelFOV = 60
	SWEP.IconLetter = "s"
	killicon.AddFont( "weapon_zs_flaregun", "HL2MPTypeDeath", ".",Color(255, 255, 100, 100 ) )
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
SWEP.ViewModelBoneMods = {
	["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Cylinder"] = { scale = Vector(0.167, 0.167, 0.167), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Python"] = { scale = Vector(0.259, 0.259, 0.259), pos = Vector(-0.883, -0.073, -0.338), angle = Angle(0, 4.433, 0) },
	["Bullet2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bullet1"] = { scale = Vector(0.112, 0.112, 0.112), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}	
	
SWEP.VElements = {
	["Flaregun5"] = { type = "Model", model = "models/hunter/blocks/cube05x05x05.mdl", bone = "Python", rel = "Flaregun3", pos = Vector(0.082, 1.61, 1.184), angle = Angle(-7.281, 0.252, 25.083), size = Vector(0.039, 0.194, 0.076), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun6"] = { type = "Model", model = "models/editor/spot_cone.mdl", bone = "Cylinder", rel = "Flaregun", pos = Vector(0.137, -0.004, 7.262), angle = Angle(90.512, -102.429, 41.974), size = Vector(0.152, 0.152, 0.152), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun4"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "Python", rel = "Flaregun2", pos = Vector(-0.03, 0.008, 0.097), angle = Angle(-180, -7.152, -0.341), size = Vector(0.579, 0.579, 0.211), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flare"] = { type = "Model", model = "models/Items/Flare.mdl", bone = "Bullet1", rel = "", pos = Vector(0.159, 0.657, 1.914), angle = Angle(-35.156, -125.04, -92.564), size = Vector(0.58, 0.58, 0.58), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flaregun3"] = { type = "Model", model = "models/props_c17/pulleyhook01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "Flaregun4", pos = Vector(0.331, 0.587, 2.687), angle = Angle(173.25, -2.083, -7.858), size = Vector(0.098, 0.098, 0.032), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun"] = { type = "Model", model = "models/hunter/tubes/tube1x1x4.mdl", bone = "Cylinder", rel = "", pos = Vector(0.097, -0.055, -1.325), angle = Angle(0, 0, 0), size = Vector(0.045, 0.045, 0.045), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun2"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "Python", rel = "", pos = Vector(0.166, -0.283, -1.573), angle = Angle(0, 0, 0), size = Vector(0.025, 0.025, 0.025), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["Flaregun5"] = { type = "Model", model = "models/hunter/blocks/cube05x05x05.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flaregun3", pos = Vector(0.493, 0.833, 0.588), angle = Angle(95.422, 0, 0), size = Vector(0.05, 0.125, 0.034), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun4"] = { type = "Model", model = "models/items/grenadeammo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flaregun2", pos = Vector(-0.03, 0.449, 0.097), angle = Angle(-180, -7.152, -0.341), size = Vector(0.579, 0.579, 0.211), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun2"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.438, 1.304, -4.025), angle = Angle(-4.042, -86.234, -90.67), size = Vector(0.009, 0.009, 0.009), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun3"] = { type = "Model", model = "models/props_c17/pulleyhook01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flaregun4", pos = Vector(0.331, 0.759, 3.214), angle = Angle(173.25, 0.57, -7.858), size = Vector(0.098, 0.098, 0.032), color = Color(0, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun"] = { type = "Model", model = "models/hunter/tubes/tube1x1x4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.561, 1.603, -3.333), angle = Angle(-94.149, -0.514, 0), size = Vector(0.045, 0.045, 0.045), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
	["Flaregun6"] = { type = "Model", model = "models/editor/spot_cone.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flaregun", pos = Vector(0.068, -0.164, 7.756), angle = Angle(90.512, -102.429, 41.974), size = Vector(0.152, 0.152, 0.152), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
}


end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel            = "models/weapons/c_357.mdl"
SWEP.WorldModel            = "models/weapons/w_357.mdl"

SWEP.UseHands = true
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.HoldType = "revolver"
SWEP.IronSightsHoldType = "pistol"
SWEP.Primary.Sound  = Sound("weapons/flaregun/fire.wav")
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.95
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 4
SWEP.MaxAmmo			    = 100
SWEP.Primary.Automatic		= true  
SWEP.Primary.Ammo			= "alyxgun"
SWEP.HumanClass = "pyro"
SWEP.Cone = 0.035
SWEP.ConeMoving = SWEP.Cone * 1.1
SWEP.ConeCrouching = SWEP.Cone * 0.95
SWEP.ConeIron = SWEP.Cone
SWEP.ConeIronCrouching = SWEP.ConeCrouching

SWEP.WalkSpeed = SPEED_PISTOL

SWEP.IronSightsPos = Vector(-4.56, -6.314, 1)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self:EmitSound("weapons/flaregun/fire.wav")
	self:ShootEffects(self)
	self:TakePrimaryAmmo(6)
	
	if not SERVER then
		return
	end
	
	local Forward = self.Owner:EyeAngles():Forward()
	local Right = self.Owner:EyeAngles():Right()
	local Up = self.Owner:EyeAngles():Up()
	
	local owner = self.Owner
	if SERVER then
	local ent = ents.Create("projectile_flare2")
	if ent:IsValid() then
		local position = self.Owner:EyePos()
		ent:SetPos(position)		
		position.z = position.z - 10
		ent:SetAngles(self.Owner:EyeAngles() * 10)
		ent:SetOwner(owner)
		ent:Spawn()
		ent:Activate()
		ent:EmitSound("WeaponFrag.Throw")
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocity((self.Owner:GetAimVector()+Vector(0,0,0.1)) * 2000)
		end
	end
		end
		self.NextPuff = self.NextPuff or 0
		
		
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end


SWEP.IronSightsPos = Vector(-4.59,25,0.65)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
