-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

ENT.PoisonExplodeSound = Sound( "ambient/levels/labs/electric_explosion1.wav" )
ENT.MaximumDist = 300

-- Initialization
function ENT:Initialize()
	self:SetModel( "models/props/cs_italy/orange.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	-- Failsafe
	self.DieTime = CurTime() + 10
	
	-- Can ricochet
	self.CanRicochet = false
	
	-- Ricochet time
	self.RicochetTimes = 0
	
	-- Physics stuff
	self.PhysObj = self:GetPhysicsObject()
	if self.PhysObj:IsValid() then
		self.PhysObj:Wake()
		self.PhysObj:SetMass( 3 )
		self.PhysObj:SetMaterial( "metal" )
	end
end

-- Main think
function ENT:Think()
	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

-- Ricochet function
function ENT:Ricochet( trace )
	if not trace then return false end

	-- Hit skybox, can't ricochet
	if trace.HitSky then return false end
	
	self.PhysObj:EnableMotion( true )
	local DotProduct = trace.HitNormal:Dot( trace.Normal * -1 )
	self.PhysObj:SetVelocity( 300 * ( ( 2 * trace.HitNormal * DotProduct ) + trace.Normal ) )
	
	-- Increment times
	self.RicochetTimes = self.RicochetTimes + 1
	self:EmitSound( table.Random( self.RicochetSounds ), 100, math.random( 110, 135 ) )
	
	return true
end

-- When it collides with something
function ENT:PhysicsCollide( Data, Phys ) 
	local HitEnt = Data.HitEntity
	
	-- Stop
	self.PhysObj:EnableMotion( false )
	self.PhysObj:SetVelocity( Vector( 0,0,0 ) )
	
	-- Stick it more
	local trace = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Data.OurOldVelocity:GetNormal() * 500, filter = self } )
	self:SetPos( trace.HitPos )
	
	-- Network hitnormal
	---
	-- TODO: Used by some sort of visual effect in cl_init
	-- Set everytime a spit bounces or hits something
	-- Consider modifying the effect not to use this
	-- 
	self:SetDTVector( 0, Data.HitNormal )
	
	-- Some fancy effect
	local eData = EffectData()
		eData:SetOrigin( trace.HitPos )
		eData:SetNormal( Data.HitNormal )
	util.Effect( "poisonheadcrab_spit_hit", eData, true, true )
	
	-- See if it hit a human
	if IsValid( HitEnt ) and ( HitEnt:IsPlayer() ) and ( HitEnt:IsHuman() ) then
		HitEnt:EmitSound( "vo/ravenholm/monk_death07.wav", 100, math.random( 90, 110 ) )
		
		local Damage = 20 - ( self.RicochetTimes * 1.5 )
		--HitEnt:TakeDamageOverTime( 1, 1, 2, 0, 12 ), mOwner, self.mOwnerWeapon or mOwner )
		if HitEnt:GetPerk("_poisonprotect") then
			Damage = math.ceil(Damage - Damage*0.8)
		end
		
		-- Take damage
		if IsValid( self:GetOwner() ) then
			HitEnt:TakeDamage( Damage, self:GetOwner(), self:GetOwner():GetActiveWeapon() )
		end
		
		self:Remove()
		return
	end
	
	-- First time check chance
	if math.random( 1, 2 ) == 1 and self.RicochetTimes == 0 then
		self.CanRicochet = true
	end
	
	-- Ricochet if possible
	if ( self.RicochetTimes < 3 ) and ( self.CanRicochet ) then
		if not self:Ricochet( trace ) then self:Remove() end
	else
		self:Remove()
		return
	end
	self:NextThink(CurTime())

end

-- On removal
function ENT:OnRemove()
	self:EmitSound( "npc/antlion_grub/squashed.wav", 100, math.random( 90, 110 ) )
end

-- Update PVS when needed
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
