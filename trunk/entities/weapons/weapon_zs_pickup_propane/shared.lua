if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "slam"

if ( CLIENT ) then
	SWEP.PrintName = "Dangerous Propane Tank"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_pickup_propane", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	SWEP.NoHUD = true
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true

	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/props_junk/propane_tank001a.mdl"



SWEP.Slot = 6
SWEP.SlotPos = 1 

-- SWEP.Info = ""

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
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.825, -4.937, 1.055) },
		["v_weapon.Left_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 19.631, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.136, 0), angle = Angle(5.625, 23.011, 15.069) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.824, 11.439, 14.48) },
		["v_weapon.Left_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.23, 0) },
		["v_weapon.Left_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(33.437, 15.512, -11.624) },
		["v_weapon.Left_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.519, -5.6, -18.063) },
		["v_weapon.Left_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.168, 0) },
		["v_weapon.c4"] = { scale = Vector(0.002, 0.002, 0.002), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-7.533, 13.887, -1.15), angle = Angle(59.956, -9.037, 76.563) }
	}



	self.VElements = {
		["propane"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-4.818, 0.207, 0), angle = Angle(-9.931, 97.073, -8.176), size = Vector(0.412, 0.412, 0.412), color = Color(255, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["propane"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.974, 3.256, 0), angle = Angle(180, -60.1, -31.519), size = Vector(0.5, 0.5, 0.5), color = Color(255, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

function SWEP:OnDeploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	
	if SERVER then	
	
		local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 64
				v = v + self.Owner:GetRight() * 8
				v = v + self.Owner:GetUp() * -3
		
		self.SpawnPos = v
		self.Dir = (self.Owner:GetAimVector()+Vector(0,0,0.5)) * 90
		
		self.UsedCan = true
	
		if self and self:IsValid() then
			DropWeapon(self.Owner)
		end
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
				
			if self.UsedCan then
				local can = ents.Create("pickup_propane")			
				can:SetPos(self.SpawnPos)
				can:Spawn()
				
				local Phys = can:GetPhysicsObject()
				if Phys:IsValid() then
					Phys:Wake()
					Phys:SetVelocity(self.Dir)
				end
			
			end
			
			self:Remove()
		end
	end
end