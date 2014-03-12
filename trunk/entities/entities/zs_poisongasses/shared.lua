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
