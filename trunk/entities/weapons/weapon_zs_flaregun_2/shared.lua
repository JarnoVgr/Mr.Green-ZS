AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Flare Boy'"			
	SWEP.Author	= "Braindawg"

	SWEP.IconLetter = "s"
	killicon.AddFont( "weapon_zs_flaregun_2", "HL2MPTypeDeath", ".",Color(255, 255, 255, 255 ) )
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
		
	  SWEP.ViewModelBoneMods = {
        ["Bullet3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["Cylinder"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.075), angle = Angle(0, 0, 0) },
        ["Bullet1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["Bullet4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["Bullet5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["Bullet2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
        ["Bullet6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
    }

    SWEP.VElements = {
        ["bullet1++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet3", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["bullet1+++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet4", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["glow+++++"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet2", rel = "bullet1+++++", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["bullet1"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet1", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
		["switch"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "", pos = Vector(0.4, -3.988, 9.18), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["glow+++"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet2", rel = "bullet1+++", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["switchr"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "", pos = Vector(-0.151, -4, 9), angle = Angle(0, -180, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["bullet1+++++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet6", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["bullet1+"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet2", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["glow+"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet2", rel = "bullet1+", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["glow"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet1", rel = "bullet1", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["glow++"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet2", rel = "bullet1++", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["bullet1++++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "Bullet5", rel = "", pos = Vector(0.006, 0.043, 0.349), angle = Angle(0, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["switchr++"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "switchr+", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["switch++"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "switch+", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["underbarrel"] = { type = "Model", model = "models/props_trainstation/payphone001a.mdl", bone = "Hand", rel = "", pos = Vector(0, -2.619, 9.157), angle = Angle(0, 90, 0), size = Vector(0.1, 0.043, 0.085), color = Color(200, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["glow++++"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Bullet2", rel = "bullet1++++", pos = Vector(0, 0, -0.406), size = { x = 1, y = 1 }, color = Color(213, 143, 96, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
        ["radiator"] = { type = "Model", model = "models/props_interiors/Radiator01a.mdl", bone = "Hand", rel = "", pos = Vector(0.087, -4.795, 4.731), angle = Angle(0, 0, 90), size = Vector(0.059, 0.079, 0.009), color = Color(200, 200, 210, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["switchr+"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "switchr", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["switch+"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "Hand", rel = "switch", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} }
    }
    
    SWEP.WElements = {
        ["bullet1++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 1.6, -3.681), angle = Angle(90, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["bullet1+++"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 0.363, -4.238), angle = Angle(90, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["bullet1"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 1.593, -4.182), angle = Angle(90, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["switch"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.225, 1.401, -4.449), angle = Angle(0, -90, -90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["switchr"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.225, 0.5, -4.449), angle = Angle(0, 90, 90), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["bullet1+"] = { type = "Model", model = "models/props_lab/jar01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 0.375, -3.583), angle = Angle(90, 0, 0), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_lab/Tank_Glass001", skin = 0, bodygroup = {} },
        ["switch+"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "switch", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["switch++"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "switch+", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["switchr++"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "switchr+", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["radiator"] = { type = "Model", model = "models/props_interiors/Radiator01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.25, 0.855, -5.301), angle = Angle(0, -90, 0), size = Vector(0.059, 0.079, 0.009), color = Color(200, 200, 210, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
        ["switchr+"] = { type = "Model", model = "models/props_lab/bindergraylabel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "switchr", pos = Vector(0, 0, -1.5), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 225, 210, 255), surpresslightning = false, material = "models/props_combine/metal_combinebridge001", skin = 0, bodygroup = {} },
        ["underbarrel"] = { type = "Model", model = "models/props_trainstation/payphone001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.656, 0.925, -3.089), angle = Angle(-90, 0, 0), size = Vector(0.1, 0.029, 0.085), color = Color(200, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.95
SWEP.MaxAmmo			    = 100
SWEP.Primary.Automatic		= true  
SWEP.Primary.Ammo			= "alyxgun"
SWEP.HumanClass = "pyro"


SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.03
SWEP.Type = "Incendiary"
SWEP.Weight = 2
SWEP.Slot = 1


SWEP.IronSightsPos = Vector(-4.59,25,0.65)
SWEP.IronSightsAng = Vector( 0, 0, 0 )
if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights+"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(0, -4.803, -3.602), angle = Angle(90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(0, -5.04, -3.01), angle = Angle(90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end


function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self:EmitSound("weapons/flaregun/fire.wav", 80, math.random(120,125))

		
	self:ShootEffects(self)
	self:TakePrimaryAmmo(1)
	
	if not SERVER then
		return
	end
	
	local Forward = self.Owner:EyeAngles():Forward()
	local Right = self.Owner:EyeAngles():Right()
	local Up = self.Owner:EyeAngles():Up()
	
	local owner = self.Owner
	if SERVER then
	local ent = ents.Create("projectile_mini_flare")
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
