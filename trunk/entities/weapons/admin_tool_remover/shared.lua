-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "Remover Tool"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 5
	SWEP.SlotPos = 5
	SWEP.Contact		= "clavuselite@greenservers.nl"
    SWEP.Purpose		= "Removes shit."
    SWEP.Instructions	= "Klik gewoon op de linker muisknop sufferd..."
end


SWEP.ViewModel			= Model ( "models/weapons/v_toolgun.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_toolgun.mdl" )

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.01

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Primary.Sound			= Sound("Weapon_357.Single")


local function RemoveEntity( ent )

	if (ent:IsValid()) then
		ent:Remove()
	end

end

//Hacky way to update weapon slot count
function SWEP:Equip ( NewOwner )
	if SERVER then
		local EntClass = self:GetClass()
		local PrintName = self.PrintName or "weapon"
		if NewOwner:IsPlayer() then
			if NewOwner:Team() == TEAM_HUMAN then
				local category = WeaponTypeToCategory[ self:GetType() ]
				NewOwner.CurrentWeapons[ category ] = NewOwner.CurrentWeapons[ category ] + 1
				WeaponPickupNotify ( NewOwner, PrintName )				
			end
		end
	end
end

local function DoRemoveEntity( Entity )

	if (!Entity) then return false end
	if (!Entity:IsValid()) then return false end
	if (Entity:IsPlayer()) then return false end

	// Nothing for the client to do here
	if ( CLIENT ) then return true end
	
	// Remove it properly in 1 second
	timer.Simple( 1, RemoveEntity, Entity )
	
	// Make it non solid
	Entity:SetNotSolid( true )
	Entity:SetMoveType( MOVETYPE_NONE )
	Entity:SetNoDraw( true )
	
	return true

end

/*---------------------------------------------------------
   Name:	LeftClick
   Desc:	Remove a single entity
---------------------------------------------------------*/  

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local hitpos = self.Owner:GetEyeTrace().Entity
	 
    if ( DoRemoveEntity( hitpos ) ) then
	
		--if ( !CLIENT ) then
		--	MsgAll( self:GetOwner():Nick(), " removed ", trace.Entity:GetClass(), "\n" )
		--end
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	end

	if CLIENT then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end


function SWEP:Holster( wep )
	return true
end 

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 