-- Haters gonna hate. Engineers gonna love. What the hell? D:

--Made by duby ;) Based off Necrossins turret.

AddCSLuaFile()


ENT.Type   = "anim"
ENT.PrintName           = "Aeigs2"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

-- Some precaching stuff
for i=1,3 do
	util.PrecacheSound("npc/turret_floor/shoot"..i..".wav")
end
for i=1,2 do
	util.PrecacheSound("physics/wood/wood_crate_break"..i..".wav")
end

-- Options
ENT.MaxHealth = 350
ENT.IgnoreClasses = {} -- Index of zombie's classes that turret should ignore
ENT.IgnoreDamage = {}

ENT.MinimumAimDot = 0.5

local function MyTrueVisible(posa, posb, filter)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, team.GetPlayers(TEAM_UNDEAD))
	if filter then
		filt[#filt + 1] = filter
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

-- Server part goes here

if SERVER then
	function ENT:Initialize()
		
		self._mOwner = self:GetTurretOwner()

		--self.Entity:SetModel("models/props_interiors/radiator01a.mdl")
		self.Entity:SetModel("models/props_debris/wood_board01a.mdl")
		self.Entity:SetModel("models/props_debris/wood_board06a.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS )
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	    self.Entity:SetAngles(Angle(0, 270, 270))
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
		end
		self:SetPlaybackRate(1) -- Normal speed for animations

		self:SetSequence(self:LookupSequence("deploy"))
		
		
		self:SetMaterial(MaterialToApply)
		
		
		-- Set few things
		self.Target = nil
		self.TargetPos = nil
		self.LastShootTime = 0
		self.NextSwitch = 0
		
		
		self:SetDTInt(1,self.MaxHealth) -- health
	
		table.insert(ActualTurrets,self)
	
	end

	function ENT:DefaultPos()
		return self:GetPos() + self:GetUp() * 55
	end

	function ENT:ShootPos()
		local attachid = self:LookupAttachment("eyes")
		if attachid then
			local attach = self:GetAttachment(attachid)
			if attach then return attach.Pos end
		end

		return self:DefaultPos()
	end

	function ENT:GetTargetPos(target)
		local boneid = target:GetHitBoxBone(HITGROUP_HEAD, 0)
		if boneid and boneid > 0 then
			local p, a = target:GetBonePosition(boneid)
			if p then
				return p
			end
		end

		return target:LocalToWorld(target:OBBCenter())
	end

	function ENT:GetLocalAnglesToTarget(target)
		return self:WorldToLocalAngles(self:GetAnglesToTarget(target))
	end

	function ENT:GetAnglesToPos(pos)
		return (pos - self:ShootPos()):Angle()
	end

	function ENT:GetAnglesToTarget(target)
		return self:GetAnglesToPos(self:GetTargetPos(target))
	end

	function ENT:GetLocalAnglesToPos(pos)
		return self:WorldToLocalAngles(self:GetAnglesToPos(pos))
	end

	function ENT:IsValidTarget(target)
		return target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and 
		self:GetForward():Dot(self:GetAnglesToTarget(target):Forward()) >= self.MinimumAimDot and MyTrueVisible(self:ShootPos(), self:GetTargetPos(target), self) and self:IsValidZombieClass(target)
	end

	function ENT:SearchForTarget()
		for _,ent in ipairs(self:GetCachedScan()) do
			if ent and ent:IsValid() and self:IsValidTarget(ent) then
				local dist = self:ShootPos():Distance( self:GetTargetPos(ent) )
				if dist <= self.SpotDistance then
					return ent
				end
			end
		end
	end

	function ENT:GetShootPos()
		return self:GetAttachment(self:LookupAttachment("eyes")).Pos
	end

	function ENT:GetShootDir()
		return self:GetAttachment(self:LookupAttachment("eyes")).Ang:Forward()
	end

	local TURRETOWNER
	local TURRET

	local damageisfalse = {damage = false, effect = true}

	local tempknockback
	function ENT:StartBulletKnockback()
		tempknockback = {}
	end

	function ENT:EndBulletKnockback()
		tempknockback = nil
	end

	function ENT:DoBulletKnockback()
		for ent, prevvel in pairs(tempknockback) do
			local curvel = ent:GetVelocity()
			ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.005 + prevvel)
		end
	end

	function GenericBulletCallback(attacker, tr, dmginfo)
		local ent = tr.Entity
		if ent:IsValid() then
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD and tempknockback then
					tempknockback[ent] = ent:GetVelocity()
				end
			else
				local phys = ent:GetPhysicsObject()
				if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					ent:SetPhysicsAttacker(attacker)
				end
			end
		end
	end

	local function BulletCallback(attacker, tr, dmginfo)
		local ent = tr.Entity
		if ent:IsValid() then
			ent:TakeSpecialDamage(dmginfo:GetDamage(), dmginfo:GetDamageType(), TURRETOWNER, TURRET, tr.HitPos)

			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end

		return damageisfalse
	end


	function ENT:TakeAmmo(amount)
		self:SetDTInt(0, math.Clamp(self:GetAmmo() - amount,0,self.MaxBullets))
	end

	function ENT:AddAmmo(amount)
		self:SetDTInt(0, math.Clamp(self:GetAmmo() + amount,0,self.MaxBullets))
	end

	function ENT:RechargeAmmo(amount,delay)
		local ct = CurTime()
		if self:GetAmmo() == self.MaxBullets then
			return
		end

		if self.LastShootTime < ct then
			self.NextRegenTime = self.NextRegenTime or ct + delay
			if ct > self.NextRegenTime then
				self:AddAmmo(amount)
				self.NextRegenTime = ct + delay
			end
		end
	end

	function ENT:Use(activator, caller)
		local ct = CurTime()
		if not IsValid(activator) then
			return
		end

		if activator:IsPlayer() and activator:IsHuman() and activator == self:GetTurretOwner() then
			self.Target = nil
			if self.NextSwitch < ct then
				if self:IsActive() then
					self:SetDTBool(0,false)
					self:EmitSound("NPC_FloorTurret.Die")
					self:SetSequence(self:LookupSequence("retract"))
				else
					self:SetDTBool(0,true)
					self:EmitSound("NPC_FloorTurret.Deploy")
					self:SetSequence(self:LookupSequence("deploy"))
				end
			self.NextSwitch = ct + 2
			end
		end
	end

	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsZombie() and not self:ShouldIgnoreDamage(dmginfo:GetAttacker()) then
			
			local dmg = dmginfo:GetDamage()
			
			self:SetDTInt(1,self:GetDTInt(1) - dmg)
			self:EmitSound("wood_furniture_break"..math.random(1,2)..".wav")
		
			if self:GetDTInt(1) <=0 then--self:GetNWInt("TurretHealth")
				self:Explode()
			end
		end
	end

	function ENT:SetControl(bl)
		local ct = CurTime()
		self.Entity:SetDTBool(2,bl)
		self.Entity.SwitchSound = self.Entity.SwitchSound or ct + 1.5
		if ct > self.Entity.SwitchSound then	
			self.Entity:EmitSound("npc/turret_floor/click1.wav")
			self.Entity.SwitchSound = ct + 1.5
		end
		
	end

	function ENT:Explode()
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,5)
		trace.filter = self.Entity
		trace.endpos = trace.start - Vector(0,0,50)
		local traceground = util.TraceLine(trace)
		
		util.Decal("Scorch",traceground.HitPos - traceground.HitNormal,traceground.HitPos + traceground.HitNormal)

		local Effect = EffectData()
		Effect:SetOrigin( self:GetPos() )
		Effect:SetStart( self:GetPos() )
		Effect:SetMagnitude( 300 )
		util.Effect("Explosion", Effect)
		self.Entity:Remove()

	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
end
-- Server part ends here

function ENT:GetScan()
	local scan = team.GetPlayers(TEAM_UNDEAD)
	return scan
end

ENT.NextCache = 0
function ENT:GetCachedScan()
	if CurTime() < self.NextCache and self.CachedFilter then return self.CachedFilter end

	self.CachedFilter = self:GetScan()
	self.NextCache = CurTime() + 1

	return self.CachedFilter
end



-- Since original function is screwed up - its time to make my own
function ENT:FindZombiesInCone(pos,distance,dotproduct)
	local enemies = {}

	for _,z in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
		local dist = pos:Distance( z:GetPos() )
		if z and z:Alive() and dist <= distance then
			table.insert(enemies,z)
		end
	end

	local Entities = {}
		
	for k, v in ipairs(enemies) do
		if v and v:IsPlayer() and v:IsZombie() and v:Alive() and (v:GetPos() - pos):GetNormal():DotProduct(self.Entity:GetAngles():Forward()) >= dotproduct and not v:IsFreeSpectating() then
			table.insert(Entities,v)
		end
	end

	return Entities
end

local tab = {mask = MASK_PLAYERSOLID_BRUSHONLY}

function ENT:IsZombieVisible(pos)

	tab.start = self:GetAttachment(self:LookupAttachment("eyes")).Pos-- self:GetPos() + Vector(0,0,55)--
	tab.endpos = pos
	-- tracedata.mask = MASK_PLAYERSOLID_BRUSHONLY
	tab.filter = self.Entity-- self:GetCachedScanFilter()-- -- , Humans

	local trace = util.TraceLine(tab)
	local visible = false
		local TargetVector = (pos - self:GetAttachment(self:LookupAttachment("eyes")).Pos):GetNormal()
		local ClampedPitch = self:WorldToLocalAngles(TargetVector:Angle()).p -- I need this to get more accurate aiming
		if not trace.Hit then
			if TargetVector:DotProduct(self.Entity:GetAngles():Forward()) >= 0.57 and (ClampedPitch <= 15 and ClampedPitch >= -16) then
					visible = true
			else
				visible = false
			end
		else 
			visible = false
		end

	local tracedata2 = {}
	tracedata2.start = self:GetPos() + Vector(0,0,50)
	tracedata2.endpos = pos
	tracedata2.filter = self.Entity-- , Humans
	local trace2 = util.TraceLine(tracedata2)

	if trace2.Hit and IsValid(trace2.Entity) and (trace2.Entity:GetClass() == "prop_door_rotating" 
		or trace2.Entity:GetClass() == "prop_physics" or trace2.Entity:GetClass() == "prop_physics_multiplayer") then
		if visible then
			visible = false
		end
	end

	self.Blocked = false

	if trace2.Hit and IsValid(trace2.Entity) and trace2.Entity:IsPlayer() and trace2.Entity:IsHuman() then
		self.Blocked = true
	end


	return visible
--return !(trace.Hit and not trace.HitNonWorld and (pos - self:GetAttachment(self:LookupAttachment("eyes")).Pos):Normalize():DotProduct(self.Entity:GetAngles():Forward()) >= 0.6)
end

function ENT:IsValidZombieClass(pl)
	if not IsValid(pl) then return end
	return not table.HasValue( self.IgnoreClasses, pl:GetZombieClass() )
end

function ENT:ShouldIgnoreDamage(pl)
	if not IsValid(pl) then return end
	return table.HasValue( self.IgnoreDamage, pl:GetZombieClass() )
end

function ENT:IsBlocked()
	return self.Blocked or false
end

function ENT:GetTurretOwner()
	return self:GetDTEntity(0)
	--return self:GetNWEntity("TurretOwner")
end

-- ENT.GetOwner = ENT.GetTurretOwner

function ENT:GetTurretName()
	return self:GetDTString(0)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:GetMaxAmmo()
	return self:GetDTInt(2)
end

function ENT:CanAttack()
	return self:GetAmmo() > 0
end

function ENT:IsActive()
	return self:GetDTBool(0)
end

function ENT:IsAttacking()
	return self:GetDTBool(1)
end

function ENT:IsControlled()
	return self:GetDTBool(2)
end

-- Client part starts here
if CLIENT then
	-- Small piece of code from IW
	local matLaser 		= Material( "sprites/bluelaser1" )
	local matLight 				= Material( "models/roller/rollermine_glow" )
	local colBeam				= Color( 50, 100, 210, 120 )
	local colLaser				= Color( 50, 100, 240, 120 )

	function ENT:Draw()
		self.Entity:DrawModel() 
		if not self.EndPos then
			return
		end
		
		if self:IsActive() then
		render.SetMaterial( matLaser )

		local TexOffset = CurTime() * 3

		local Distance = self.EndPos:Distance( self:GetAttachment(self:LookupAttachment("eyes")).Pos )
		
		if not self:IsAttacking() then
			if self:IsControlled() then
				render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(5,8), TexOffset, TexOffset+Distance/8, Color( 0, 255, 0 , 255 ))
				render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(3,5), TexOffset, TexOffset+Distance/8, Color( 0, 255, 0 , 255 ) )
			else
				render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(5,7), TexOffset, TexOffset+Distance/8, colBeam )
				render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(3,5), TexOffset, TexOffset+Distance/8, Color( 255, 255, 255 , 255 ) )
			end
		else
			render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(9,10), TexOffset, TexOffset+Distance/8, Color( 255, 0, 0 , 250 ))
			render.DrawBeam( self.EndPos, self:GetAttachment(self:LookupAttachment("light")).Pos, math.Rand(8,9), TexOffset, TexOffset+Distance/8, Color( 255, 0, 0 , 255 ) )
		end
		
		render.SetMaterial( matLight )
		
		local Size = math.Rand( 5, 8 )
		-- local Normal = (self:GetAttachment(self:LookupAttachment("eyes")).Pos-self.EndPos):GetNormal() * 0.1
		local Normal = self.FixNormal
		
		if not self:IsAttacking() then
			if self:IsControlled() then
				Size = math.Rand( 7, 10 )
				render.DrawQuadEasy( self.EndPos + Normal, Normal, Size, Size, Color( 0, 255, 0 , 255 ), 0 )
			else
				render.DrawQuadEasy( self.EndPos + Normal, Normal, Size, Size, colLaser, 0 )
			end
		else
			Size = math.Rand( 5, 8 )
			render.DrawQuadEasy( self.EndPos + Normal, Normal, Size, Size, Color( 255, 0, 0 , 250 ), 0 )
		end
		
		local Normal1 = ((self:GetAttachment(self:LookupAttachment("light")).Pos + self:GetAttachment(self:LookupAttachment("light")).Ang:Forward()*10)-self:GetAttachment(self:LookupAttachment("light")).Pos):GetNormal() * 0.1
		Size = math.Rand( 2, 4 )
		render.DrawQuadEasy( self:GetAttachment(self:LookupAttachment("light")).Pos, Normal1, Size, Size, Color( 255, 255, 255, 255 ), 0 )
		end
		
			if self:GetDTInt(1) < self.MaxHealth/2 then --self:GetNWInt("TurretHealth")

			self.SmokeTimer = self.SmokeTimer or (CurTime()+0.02)
			if ( self.SmokeTimer <= CurTime() ) then 
				self.SmokeTimer = CurTime() + 0.02
				local spawnang = self:GetAttachment(self:LookupAttachment("light")).Ang
				local spawnPos = self:GetAttachment(self:LookupAttachment("light")).Pos+ spawnang:Right()*-4+ spawnang:Up()*-10+Vector(math.random(0,8),math.random(0,8),math.random(0,8))
				local emitter = ParticleEmitter( spawnPos )
				local particle = emitter:Add( "particles/smokey", spawnPos )
				particle:SetVelocity( Vector(math.Rand(0,1)/3,math.Rand(0,1)/3,1):GetNormal()*math.Rand( 10, 20 ) )
				particle:SetDieTime( 0.7 )
				particle:SetStartAlpha( math.Rand( 100, 150 ) )
				particle:SetStartSize( math.Rand( 5, 10 ) )
				particle:SetEndSize( math.Rand( 15, 30 ) )
				particle:SetRoll( math.Rand( -0.2, 0.2 ) )
				local ran = math.random(0,30)
				particle:SetColor( 40+ran, 40+ran, 40+ran )
						
				emitter:Finish()
			end
		end


	end

	net.Receive("SendTurret", function( len )
		if not IsValid(MySelf) then
			return
		end
		
		local t = net.ReadEntity()	
		MySelf.Turret = t or nil
	end)
end
-- Client part ends here