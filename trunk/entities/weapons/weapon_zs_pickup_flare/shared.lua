if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end
SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "grenade"

if ( CLIENT ) then
	SWEP.PrintName = "Rusty Flare"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_pickup_flare", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	SWEP.NoHUD = true
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true 
	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/Weapons/v_Grenade.mdl"
SWEP.WorldModel = "models/Items/Flare.mdl"



SWEP.Slot = 5
SWEP.SlotPos = 1 

//SWEP.Info = ""

SWEP.Primary.ClipSize =1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = 160

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -7.344, 0) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.6, -8.289, 23.444) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.437, 0), angle = Angle(0, 2.306, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 24.606, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -7.95, 0) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0.405, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.643, -2.5, 20.225) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -15.631, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -22.076, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.575, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.863, 2.855, -24.357) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -11.495, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -24.431, 0) }
	}


	self.VElements = {
		["flare"] = { type = "Model", model = "models/Items/Flare.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.308, -0.35, -1.32), angle = Angle(-32.688, -4.676, -82.695), size = Vector(0.736, 0.736, 0.736), color = Color(160, 160, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["flare"] = { type = "Model", model = "models/Items/Flare.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.474, 1.949, -0.838), angle = Angle(-37.957, -115.47, -71.583), size = Vector(0.744, 0.744, 0.744), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

function SWEP:OnDeploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	
	local owner = self.Owner
	if SERVER then
	local ent = ents.Create("projectile_flare")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetOwner(owner)
		ent:Spawn()
		ent:Activate()
		ent:EmitSound("WeaponFrag.Throw")
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocity((self.Owner:GetAimVector()+Vector(0,0,0.05)) * 700)
		end
	end
	
	self:SendWeaponAnim(ACT_VM_THROW)
	owner:SetAnimation(PLAYER_ATTACK1)	
		timer.Simple(0.1,function() 
			if self and self:IsValid() then
				DropWeapon(self.Owner)
			end
		end)
	end
end

	
function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
return false
end 


function SWEP:_OnDrop()
	if SERVER then	
		if self and self:IsValid() then
			self:Remove()
		end
	end
end