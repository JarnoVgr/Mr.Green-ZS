-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

ENT.PoisonExplodeSound = Sound( "ambient/levels/labs/electric_explosion1.wav" )
ENT.MaximumDist = 300

ENT.ClassFilter = { "prop_", "player", "world" }

-- Initialization
function ENT:Initialize()
	self:SetModel( "models/props/cs_italy/orange.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	
	-- Status stuff
	self.Sticked = false
	
	-- Failsafe
	self.DieTime = CurTime() + 10
	
	-- Physics stuff
	self.PhysObj = self:GetPhysicsObject()
	if self.PhysObj:IsValid() then
		self.PhysObj:Wake()
		self.PhysObj:SetMass( 3 )
		self.PhysObj:SetMaterial( "metal" )
	end
end

-- Sets fuse
function ENT:SetFuse( iNr )
	if iNr then
		self.Fuse = iNr
	end
end

-- Main think
function ENT:Think()
	if self.IsCountingDown then
		if ( self.TickTimer or 0 ) <= CurTime() then
			self:EmitSound( self.TickSound )
			self.TickTimer = CurTime() + 0.5
		end
	end

	-- Fail safe removal
	if self.DieTime <= CurTime() then
		self:Remove()
	end
end

-- Poison explosion
function ENT:Explode()
	local mOwner = self:GetOwner()

	-- Get players near
	local tbHumans = ents.FindHumansInSphere ( self:GetPos(), self.MaximumDist )
	
	-- Local stuff
	local vPos = self:GetPos()
	
	--  Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( vPos )
	shake:SetKeyValue( "amplitude", "800" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "280" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- Filter
	local Filter = { self, self:GetOwner() }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Get owner active weapon
	if IsValid( mOwner ) then
		self.mOwnerWeapon = mOwner:GetActiveWeapon()
	end
	
	-- Damage humans nearby
	for k,v in pairs ( tbHumans ) do
		if IsEntityVisible ( v, vPos, Filter ) then
			table.insert( Filter, v )
			local fDistance = self:GetPos():Distance( v:GetPos() )
			v:TakeDamageOverTime( math.Rand( 2, 3 ), 1, math.Clamp( ( ( ( self.MaximumDist - fDistance ) / self.MaximumDist ) * 30 ) / 2, 0, 12 ), mOwner, self.mOwnerWeapon or mOwner )
			-- Apply effect to human
			local Infect = EffectData()
				Infect:SetEntity( v )
			util.Effect( "infected_human", Infect, true )
		end
	end
	
	-- Effect
	local eData = EffectData()
		eData:SetOrigin( vPos )
	util.Effect( "Explosion", eData )
	
	-- Play some weird effect
	self:EmitSound( self.PoisonExplodeSound )
	
	-- Remove bomb
	self:Remove()
end

-- When it collides with something
function ENT:PhysicsCollide( Data, Phys ) 
	local HitEnt = Data.HitEntity
	if self.Sticked then return end
	
	-- Entity doesn't have phys
	if IsValid( HitEnt ) then
		if not IsValid( HitEnt:GetPhysicsObject() ) then 
			return 
		end 
		if string.find( HitEnt:GetClass(), "breakable_surf" ) then
			return
		end
	end
	
	-- Stop
	self.PhysObj:EnableMotion( false )
	self.PhysObj:SetVelocity( Vector( 0,0,0 ) )
	
	-- Stick it more
	local trace = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Data.OurOldVelocity:GetNormal() * 500, filter = self } )
	if trace.Hit then self:SetPos( trace.HitPos ) end
	
	-- Network hitnormal
	---
	-- TODO: Used by some sort of visual effect in cl_init
	-- Consider modifying the effect not to use this
	-- 
	self:SetDTVector( 0, Data.HitNormal )
	
	-- Parent
	if HitEnt ~= game.GetWorld() then
		if IsValid( HitEnt ) then
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			self:SetParent( HitEnt )
		end
	end
	
	-- Status
	self.Sticked, self.IsCountingDown = true, true
	
	-- Fuse
	local iTime = math.Rand( 2.25, 3 )
	if IsValid( HitEnt ) and ( HitEnt:IsPlayer() ) then iTime = math.Rand( 3.5, 5 ) end
	if self.Fuse then iTime = self.Fuse end
	
	-- EXPLODE!
	timer.Simple( iTime, function()
		if IsValid( self ) then
			self:Explode()
		end
	end )
end

-- Update PVS when needed
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
