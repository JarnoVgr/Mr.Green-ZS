-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "Igniter Tool"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 5
	SWEP.SlotPos = 6
	SWEP.Contact		= "clavuselite@greenservers.nl"
    SWEP.Purpose		= "Burns and blasts shit."
    SWEP.Instructions	= "Klik en watch em burn voor 5 secs. Rechtermuis voor exploderende watermeloen"
end


SWEP.ViewModel			= Model ( "models/weapons/v_toolgun.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_toolgun.mdl" )

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

SWEP.Primary.Recoil			= 2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.01
SWEP.Primary.Cone = 0
SWEP.ConeMoving	= 0
SWEP.ConeCrouching = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.04

SWEP.Primary.Sound			= Sound("Weapon_357.Single")

SWEP.Object		= Model ( "models/props_junk/watermelon01.mdl" )	-- Fire zhe exploding watermelon!
SWEP.ObjectExplode		= true			-- Should this thing explode? (Only works with breakables)
SWEP.ObjectForce		= 1000			-- Force multiplier (1000 works great)


local function IgnitePlayer( Entity )

	if (not Entity or CLIENT) then return false end
	if (not Entity:IsValid()) then return false end
	if (Entity:IsPlayer()) then
		Entity:Ignite( 5, 0)
    elseif (Entity:IsNPC()) then
		Entity:Ignite( 100, 0)
	else
		return false
	end
	
	return true

end

--[==[---------------------------------------------------------
   Name:	LeftClick
   Desc:	Remove a single entity
---------------------------------------------------------]==]  

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local hitpos = self.Owner:GetEyeTrace().Entity
	 
    if ( IgnitePlayer( hitpos ) ) then
	
		--if ( not CLIENT ) then
		--	MsgAll( self:GetOwner():Nick(), " removed ", trace.Entity:GetClass(), "\n" )
		--end
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	end

	if CLIENT then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

-- Hacky way to update weapon slot count
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


function SWEP:SecondaryAttack()		-- Called when we press secondary fire
	self.Weapon:SetNextSecondaryFire( self.Secondary.Delay )	-- Don't shoot again until the delay has expired
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	-- View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )			-- 3rd Person Animation
	self.Weapon:EmitSound(Sound(self.Primary.Sound))	-- Make shooty noises
	self.Owner:ViewPunch(Angle( -self.Primary.Recoil, 0, 0 ))
	if ( SERVER ) then
		object = ents.Create("prop_physics_multiplayer")
		object:SetKeyValue("physdamagescale","500")
		if (self.ObjectExplode) then 
			object:SetKeyValue("explodedamage","15")
			object:SetKeyValue("health","500")
			object:SetKeyValue("exploderadius","150")
			object:SetKeyValue("physdamagescale","1500")
			--object:SetColor(255,255,255,255)
		end
		object:SetModel(self.Object)
		object:SetOwner(self.Owner)
		object:SetPos(self.Owner:GetShootPos())
		object:SetAngles(self.Owner:GetAimVector())
		object:Spawn()
		local physobj = object:GetPhysicsObject()
		local force = self.ObjectForce * physobj:GetMass()
		physobj:SetVelocity(self.Owner:GetAimVector() * force)
		--undo.Create("Launched prop")
		--	undo.AddEntity(object)
		--	undo.SetPlayer(self.Owner)
		--undo.Finish()
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