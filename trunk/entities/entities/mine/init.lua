-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ActualMines = {}

function ENT:Initialize()
	self.Entity:SetModel("models/Weapons/w_package.mdl") 
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid (SOLID_NONE)
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Entity:SetTrigger( true )
	self.Entity.Frozen = true
	
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion( false )
	
	table.insert(ActualMines,self)
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name == "detonate" then
		self.Entity:EmitSound( self.WarningSound )
		timer.Simple( 0.5, function() self:Explode() end )
		function self.Think() end
		
		return true
	end
end

function ENT:Think()
	if not ValidEntity ( self ) then return end

	--[=[local e = ents.FindInSphere( self.Entity:GetPos(), 130 )
	for a,pl in pairs(e) do
		if pl:IsPlayer() and pl:Team() == TEAM_UNDEAD and pl:Alive() and not pl:IsCrow() then
			local trace = {}
			trace.start = self.Entity:GetPos()
			trace.endpos = pl:GetPos() + Vector ( 0,0,40 )
			trace.filter = self.Entity
			local tr = util.TraceLine( trace )
			
			-- Checks if there's a clear view of the player
			if tr.Entity:IsValid() and tr.Entity == pl then
				self.Entity:EmitSound( self.WarningSound )
				timer.Simple( 0.5, self.Explode , self )
				function self.Think() end
			end
		end
	end]=]
	
	-- In case the owner dies
	local Owner = self:GetOwner()
	if not ValidEntity ( Owner ) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
		local Effect = EffectData()
			Effect:SetOrigin( self:GetPos() )
			Effect:SetStart( self:GetPos() )
			Effect:SetMagnitude( 300 )
		util.Effect("Explosion", Effect)
		
		-- Remove it
		self.Entity:Remove()
	end
end

function ENT:Explode()
	-- BOOM!
	if not ValidEntity(self.Entity) then return end
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_4" )		
	Ent:SetPos( self.Entity:GetPos() )
	Ent:Spawn()
	Ent.Team = function() -- Correctly applies the whole 'no team damage' thing
		return TEAM_HUMAN
	end
	Ent.Inflictor = "weapon_zs_mine"
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	Ent:SetKeyValue( "iMagnitude", 300 ) --180 -- math.Clamp ( math.Round ( 250 * GetInfliction() ), 100, 350 )
	Ent:SetKeyValue( "iRadiusOverride", 300 )-- math.Clamp ( math.Round ( 250 * GetInfliction() ), 150, 350 )
	Ent:Fire("explode", "", 0)
	
	-- Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( self.Entity:GetPos() )
	shake:SetKeyValue( "amplitude", "800" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "300" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self:GetOwner() )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- timer.Simple(0,function (me)
		-- if not ValidEntity(self.Entity) then return end
		self:Remove()--  end,
		-- self)
end

function ENT:WallPlant(hitpos, forward)
	if (hitpos) then self.Entity:SetPos( hitpos + Vector(0,0,3) ) end
    self.Entity:SetAngles( forward:Angle() + Angle( -90, 0, 180 ) )
end

function ENT:PhysicsCollide( data, phys ) 
	if ( not data.HitEntity:IsWorld() ) then return end
	phys:EnableMotion( false )
	self:WallPlant( nil, data.HitNormal:GetNormal() * -1 )
end
