if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

local math = math
local util = util
local ents = ents
local table = table
local player = player
local pairs = pairs

ENT.Type   = "anim"
ENT.PrintName           = ""

util.PrecacheModel("models/props_pipes/destroyedpipes01d.mdl")

--Serverside-----------

if SERVER then

function ENT:Initialize()

if self.Entity:IsPipe() then
	self.Entity:SetModel("models/props_pipes/destroyedpipes01d.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS )
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion( false ) 
	end
else
	self:DrawShadow(false)
end
end

end

--Shared----------------

function ENT:GetRadius()
	-- return self:GetNWInt("GasRadius")
	return self:GetDTInt(0)
end

function ENT:IsPipe()
	--return self.Entity:GetNWBool("GasPipe")
	return self:GetDTBool(0)
end

function ENT:TrueVisible(posa, posb)
	local filt = {}-- ents.FindByClass("projectile_*")
	-- filt = table.Add(filt, ents.FindByClass("npc_*"))
	-- filt = table.Add(filt, ents.FindByClass("prop_*"))
	filt = table.Add(filt, {self})-- ents.FindByClass("zs_*")
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function ENT:Think()
	local ct = CurTime()
	--if not GAMESTART then return end
	if ( self.NextPoisonHeal or 0 ) > ct then return end
	local spawnang = self:GetAngles()
	local spawnPos = self:GetPos()+spawnang:Up()*-21+spawnang:Right()*15+Vector(0,0,41)-- +Vector(math.random(0,8),math.random(0,8),math.random(0,8))
	
	-- Apply cooldown
	if LASTHUMAN then
		self.NextPoisonHeal = ct + 3
	else
		self.NextPoisonHeal = ct + 2
	end
		local iZombies = GetZombieFocus( self.Entity, self:GetRadius() )
		
			--for i, Zombie in pairs( ents.FindInSphere( spawnPos, self:GetRadius() ) ) do
			for i, Zombie in ipairs( team.GetPlayers(TEAM_HUMAN) ) do
				if Zombie:IsPlayer() and Zombie:Alive() then
					-- self.iDistance = spawnPos:Distance( Zombie:GetPos() )
					local iDistance = spawnPos:Distance( Zombie:GetPos() )
					if iDistance <= self:GetRadius() and self:TrueVisible(spawnPos, Zombie:GetShootPos()) then
						if Zombie:IsZombie() and not Zombie:IsBossZombie() then
							-- Aura effect cooldown
							
							Zombie.InHealTime = ct + 0.5
							-- Heal
							if SERVER then
								Zombie.AuraTimeHeal = Zombie.AuraTimeHeal or 0
								if Zombie.AuraTimeHeal <= ct then
									local iMaxHealth = Zombie:GetMaximumHealth()
									--local HealHP = math.Clamp( Zombie:Health() + math.Clamp( iMaxHealth / ( iZombies * 8 ), iMaxHealth * 0.03, iMaxHealth * 0.1 ), 0, iMaxHealth )
									--if Zombie:IsPoisonZombie() then HealHP = HealHP/2 end
									if not (Zombie:IsStartingZombie() or Zombie:IsSteroidZombie() or Zombie:IsZombine() or Zombie:IsHeadcrab() or Zombie:IsPoisonCrab()) then
										Zombie:SetHealth( math.Clamp( Zombie:Health() + math.Clamp( iMaxHealth / ( iZombies * 8 ), iMaxHealth * 0.03, iMaxHealth * 0.1 ), 0, iMaxHealth ) )
									end

									Zombie.AuraTimeHeal = ct + 0.6
								end
							end
						else
							if SERVER and Zombie:IsHuman() and iDistance <= self:GetRadius() and self:TrueVisible(spawnPos, Zombie:GetShootPos()) and not Zombie:HasGasMask() then
								
								if not Zombie.PoisonToxicTime then Zombie.PoisonToxicTime = 0 end
								
								-- 1 second delay for damage
								if Zombie.PoisonToxicTime <= ct then
									--if Zombie:Health() > 10 then
										--Zombie:ViewPunch( Angle( math.random( -20, 20 ), math.random( -5, 5 ), 0 ) )
										--Zombie:EmitSound( "ambient/voices/cough"..math.random( 1,4 )..".wav" )
										--Zombie:EmitSound( "player/pl_pain"..math.random( 5,7 )..".wav" )

										--Zombie:SetHealth( math.Clamp( Zombie:Health() - math.Clamp( Zombie:Health() * math.Rand( 0.03, 0.4 ), 2, 12 ), 5, 100 ) )
									--end
									local fDistance = self:GetPos():Distance( Zombie:GetPos() )
									Zombie:TakeDamageOverTime( math.Rand(1,2), 1.5, math.Clamp( ( ( ( self:GetRadius() - fDistance ) / self:GetRadius() ) * 44 ) / 2, 0, 10 ), Zombie, nil )
									-- Damage cooldown
									Zombie.PoisonToxicTime = ct + math.Rand(1,3)
								end
							end
						end
					end
				end
			end
	self:NextThink(CurTime())
	return true
end


--Clientside------------

if CLIENT then
function ENT:Initialize()
	local spawnang = self:GetAngles()
	local spawnPos = self:GetPos()+spawnang:Up()*-21+spawnang:Right()*15+Vector(0,0,41)+Vector(math.random(0,8),math.random(0,8),math.random(0,8))
	self.Emitter = ParticleEmitter(spawnPos)
	self.Emitter:SetNearClip(60, 70)
	self.NextGas = 0
end

local function CollideCallback(particle, hitpos, hitnormal)
	particle:SetEndSize(8)
end


local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 180, 0, 220)
function ENT:Draw()
if self.Entity:IsPipe()then
	self.Entity:DrawModel()
end

		local spawnang = self:GetAngles()
		local spawnPos = self:GetPos()+spawnang:Up()*-21+spawnang:Right()*15+Vector(0,0,41)+Vector(math.random(0,8),math.random(0,8),math.random(0,8))
		local pos = spawnPos
		
		if self.Entity:IsPipe()then
		self.Timer = self.Timer or (CurTime()+0.05)
		if ( self.Timer <= CurTime() ) then 
			self.Timer = CurTime() + 0.05
			local emitter = ParticleEmitter( spawnPos )
			local particle = emitter:Add( "particles/smokey", spawnPos )
			particle:SetVelocity( Vector(math.Rand(0,1)/3,math.Rand(0,1)/3,1):GetNormal()*math.Rand( 10, 120 ) )
			particle:SetDieTime( math.Rand(0.5,1.4) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetStartSize( math.Rand( 1, 4 ) )
			particle:SetEndSize( math.Rand( 5, 10 ) )
			particle:SetRoll( math.Rand( -0.7, 0.7 ) )
			local ran = math.Rand(0,40)
			particle:SetColor(150+ran, 0, 0)
			particle:SetCollide(true)	
			particle:SetBounce( 1 )
			-- particle:SetLighting(true)
			emitter:Finish()
		end
		
		else
			-- local radius = self:GetRadius()
		-- 	render.SetMaterial(matGlow)
			-- render.DrawSprite(pos + Vector(0,0,-15)+Vector(0, 0, radius * 0.5), radius*0.7 + math.Rand(-10, 40), radius*0.7 + math.Rand(-10, 40), colGlow)
		end
		

		
		local radius = 5 --self:GetRadius()
		if CurTime() < self.NextGas then return end
		self.NextGas = CurTime() + math.Rand(0.1, 0.25)

		local particle = self.Emitter:Add("particles/smokey", pos + VectorRand():GetNormal() * math.Rand(8, radius + 32))
		particle:SetVelocity(VectorRand():GetNormal() * math.Rand(8, 32))
		particle:SetDieTime(math.Rand(1.2, 4))
		particle:SetStartAlpha(math.Rand(115, 145))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(1,4))
		particle:SetEndSize(math.Rand(5,10))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-2, 2))
		local ran = math.Rand(0,40)
		particle:SetColor(150+ran, 0, 0)
		particle:SetCollide(true)	
		particle:SetBounce( 0.25 )
		particle:SetCollideCallback(CollideCallback)
		-- particle:SetLighting(true)
	
end
end
