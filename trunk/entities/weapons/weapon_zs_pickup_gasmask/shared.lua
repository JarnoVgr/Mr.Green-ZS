if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "normal"

if ( CLIENT ) then
	SWEP.PrintName = "Gas Mask"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_pickup_gasmask", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	SWEP.NoHUD = true
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	
	-- SWEP.IgnoreThumbs = true

	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/v_hands.mdl"
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

SWEP.WalkSpeed = 200

function SWEP:InitializeClientsideModels()
	

	self.ViewModelBoneMods = {

	}



	self.VElements = {

	}
	
	self.WElements = {
	
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
				local can = ents.Create("pickup_gasmask")			
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