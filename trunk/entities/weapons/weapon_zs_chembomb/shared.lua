

if SERVER then
	AddCSLuaFile( "shared.lua" )
end
SWEP.Base = "weapon_zs_base_dummy"

SWEP.HoldType = "grenade"

if ( CLIENT ) then
	SWEP.PrintName = "Zombie repellent"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.ViewModelFOV = 30
	SWEP.NoHUD = true
	
	killicon.AddFont( "weapon_zs_pickup_flare", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false

end

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props_junk/propane_tank001a.mdl"

SWEP.Slot = 5
SWEP.SlotPos = 1 

SWEP.UseHands = true

SWEP.Author = "Duby"


SWEP.Primary.Delay = 0.01

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "Battery"

SWEP.WalkSpeed = 220

SWEP.NoMagazine = true

SWEP.HoldType = "grenade"

SWEP.NoDeployDelay = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.15


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
		["chem1"] = { type = "Model", model = "models/props_junk/garbage_plasticbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.8, 2.2, -0.9), angle = Angle(0.688, -4.676, 180.695), size = Vector(0.5, 0.5, 0.5), color = Color(160, 160, 160, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["chem1"] = { type = "Model", model = "models/props_junk/garbage_plasticbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.474, 1.949, -0.838), angle = Angle(-37.957, -115.47, 180.583), size = Vector(0.744, 0.744, 0.744), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:OnDeploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end
 
	self:EmitSound("physics/glass/glass_sheet_impact_soft1")--Need to add something else for this.
	self.BaseClass.ShootEffects(self)
	
	if (!SERVER) then return end
	
	self:SendWeaponAnim(ACT_VM_THROW)	
		timer.Simple(0.1,function() 
		end)
	
local owner = self.Owner
	if SERVER then
		local ent = ents.Create("projectile_zschemgrenade")
		if IsValid(ent) then
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 5)
				phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 800)
			end
		end
	end
	
	
	
	timer.Simple(0.1,function() --Remove the weapon once its been thrown. You are only allowed one of these!
			if self and self:IsValid() then
				DropWeapon(self.Owner)
			end
		end)
		
	end
	

function SWEP:_OnDrop() --If you drop it then you loose it :o
	if SERVER then	
		if self and self:IsValid() then
			self:Remove()
		end
	end
end	
	
function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
	return false
end 

function SWEP:OnDeploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()
end

function SWEP:SetNextCharge(tim)
	self:SetDTFloat(0, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(0)
end

if CLIENT then
	local texGradDown = surface.GetTextureID("VGUI/gradient_down")
	function SWEP:DrawHUD()
	
		local wid, hei = ScaleW(150), ScaleH(33)
		local space = 12+ScaleW(7)
		local x, y = ScrW() - wid - 12, ScrH() - ScaleH(73) - 12
		y = y + ScaleH(73)/2 - hei/2
		surface.SetFont("ssNewAmmoFont13")
		local tw, th = surface.GetTextSize("Zombie repellent")
		local texty = y + hei/2 
		
		 draw.SimpleText("Zombie repellent", "ssNewAmmoFont7", x+space, texty+10, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		 draw.SimpleText("Damages zombies ", "ssNewAmmoFont7", x+space, texty-10, Color(255,255,255,255), TEXT_ALIGN_LEFT)

		local charges = self:GetPrimaryAmmoCount()
		if charges > 0 then
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		else
			draw.SimpleTextOutlined(charges, "ssNewAmmoFont13", x-8, texty, COLOR_DARKRED, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		end
	end
end

function SWEP:Equip ( NewOwner ) --This may be pointless as you can't drop it. Remove this later after implementation.
	if CLIENT then return end
	
	if self.Weapon.FirstSpawn then
		self.Weapon.FirstSpawn = false
	else
		if self.Ammunition then
			self:TakePrimaryAmmo ( self:Clip1() - self.Ammunition )
		end
	
		NewOwner:RemoveAmmo ( 1500, self:GetPrimaryAmmoTypeString() )
		if self.Weapon.RemainingAmmunition then
			NewOwner:GiveAmmo( self.Weapon.RemainingAmmunition or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
		end
	end	
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end
