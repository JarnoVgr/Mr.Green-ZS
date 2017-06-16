-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

ENT.PoisonExplodeSound = Sound( "ambient/levels/labs/electric_explosion1.wav" )
local table1 = { 1,2 }
function ENT:Initialize()

	-- Initialize physics and model
	self:SetModel( "models/weapons/w_grenade.mdl" )
	
	self:InitPhys()
	
	self:DrawShadow ( false )
	
	self.OwnerDied = false
	
	-- Time to boom
	self.BoomTime = CurTime() + 5
	self.ZombieOwner = self:GetOwner()
	
	-- Parent entity on zombie hand
	if not IsEntityValid ( self.ZombieOwner ) then return end
	
	local i = self.ZombieOwner:GetActiveWeapon():GetGrenadeType()
	
	if i == 0 then
		self:SetType(1)
	else
		self:SetType(i)
	end
	-- 1 explosive
	-- 2 poison
	-- Set grenade type (poison or damage)
	--self:SetType(table1[math.random(1,#table1)])
	-- Set position on hand
	self:SetPos ( self.ZombieOwner:GetPos() + Vector ( 0,0,40 ) )
end

function ENT:InitPhys()

	-- Init phys stuff
	self:PhysicsInit ( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER ) 
	
	-- Wake up
	local Phys = self:GetPhysicsObject()
	timer.Simple ( 0.02, function( ) if not IsEntityValid (  ) then return end if Phys:IsValid() then Phys:Wake() end if self.OwnerDied then Phys:ApplyForceCenter( VectorRand() * math.Rand( 50, 50 ) ) end end)
end

ENT.BeepDuration = 1
function ENT:Think()
	if not IsEntityValid ( self ) then return end
	
	-- No valid owner
	if not IsEntityValid ( self.ZombieOwner ) then return end
	
	-- Owner redeemed
	if self.ZombieOwner:IsHuman() then self:Remove() return end
	
	-- Owner died before nade xploded
	if not self.OwnerDied and (not self.ZombieOwner:Alive() or self.ZombieOwner:GetZombieClass() ~= 8) then
		self.OwnerDied = true
		self:SetParent()
		self:InitPhys()
	end
	
	-- Beep found
	if self.BeepTime <= CurTime() then
		self:EmitSound ( "weapons/grenade/tick1.wav" )
		
		self.BeepTime = CurTime() + self.BeepDuration
		self.BeepDuration = math.Clamp ( self.BeepDuration * 0.7, 0.2, 1 )
	end
	
	-- BOOM time
	if CurTime() < self.BoomTime then return end
	
	-- BOOM
	if self:GetType() then self:Explode() else self:PoisonExplode() end
end

-- Poison explosion
function ENT:PoisonExplode()
	if not IsValid( self.ZombieOwner ) then return end
	
	-- Not human anymore
	if not self.ZombieOwner:IsZombie() then return end
	
	-- Get players near
	local tbHumans = ents.FindHumansInSphere ( self:GetPos(), self.MaximumDist )
	
	-- Local stuff
	local vPos = self:GetPos()
	
	--  Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( vPos )
	shake:SetKeyValue( "amplitude", "800" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "250" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self.ZombieOwner )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- Kill owner
	if not self.OwnerDied then self.ZombieOwner:SetHealth ( 0 ) self.ZombieOwner:Kill() end
	
	-- Filter
	local Filter = { self, self.ZombieOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Get owner active weapon
	local mOwnerWeapon = self.ZombieOwner:GetActiveWeapon()
	
	-- Damage humans nearby
	for k,v in pairs ( tbHumans ) do
		if IsEntityVisible ( v, vPos + Vector ( 0,0,3 ), Filter ) then
			table.insert( Filter, v )
			local fDistance = self:GetPos():Distance( v:GetPos() )
			v:TakeDamageOverTime( math.Rand(3,4), 1.5, math.Clamp( ( ( ( self.MaximumDist - fDistance ) / self.MaximumDist ) * 30 ) / 2, 0, 22 ), self.ZombieOwner, mOwnerWeapon )
			
			-- Apply effect to human
			local Infect = EffectData()
				Infect:SetEntity( v )
			util.Effect( "infected_human", Infect, true )
		end
	end
	
	-- Effect
	local eData = EffectData()
		eData:SetOrigin( vPos )
		eData:SetScale( 1.2 )
	util.Effect( "Explosion", eData )
	
	-- Play some weird effect
	-- self:EmitSound( self.PoisonExplodeSound )
	
	local eData = EffectData()
		eData:SetOrigin( vPos )
	util.Effect( "chemzombieexplode", eData )
	
	
	-- Remove grenade
	self:Remove()
end

-- Kinetic explosion
function ENT:Explode()
	if not IsEntityValid ( self.ZombieOwner ) then return end
	
	-- Not human anymore
	if not self.ZombieOwner:IsZombie() then return end
	
	-- Get players near
	local tbHumans = ents.FindHumansInSphere ( self:GetPos(), self.MaximumDist )
	
	-- Local stuff
	local vPos = self:GetPos()
	
	--  Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( vPos )
	shake:SetKeyValue( "amplitude", "820" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "290" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self.ZombieOwner )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- Kill owner
	if not self.OwnerDied then self.ZombieOwner:SetHealth ( 0 ) self.ZombieOwner:Kill() end
	
	-- Filter
	local Filter = { self, self.ZombieOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Get owner active weapon
	local mOwnerWeapon = self.ZombieOwner:GetActiveWeapon()
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_4" )		
	Ent:SetPos( self.Entity:GetPos() )
	Ent:Spawn()
	Ent.Team = function() -- Correctly applies the whole 'no team damage' thing
		return TEAM_UNDEAD
	end
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	Ent:SetKeyValue( "iMagnitude", 120 )
	--Ent:SetKeyValue( "iRadiusOverride", math.Clamp ( math.Rand ( 50,120), 5, 130 )  )
	Ent:Fire("explode", "", 0)
	
	-- Damage humans nearby
	for k,v in pairs ( tbHumans ) do
		if IsEntityVisible ( v, vPos + Vector ( 0,0,3 ), Filter ) then
			table.insert( Filter, v )
			local fDistance = self:GetPos():Distance( v:GetPos() )
			
			if v:GetPerk("_blast") then
				v:TakeDamage (( self.MaximumDist - fDistance ) / self.MaximumDist * 14, self.ZombieOwner, mOwnerWeapon )
			else
				v:TakeDamage (( self.MaximumDist - fDistance ) / self.MaximumDist * 20, self.ZombieOwner, mOwnerWeapon )
			end			
		end
	end
	
	-- Effect
	local eData = EffectData()
		eData:SetOrigin( vPos )
		eData:SetScale( 1.2 )
	--util.Effect( "Explosion", eData )
	
	-- Remove grenade
	self:Remove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
