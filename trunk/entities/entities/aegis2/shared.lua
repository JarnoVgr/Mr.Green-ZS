-- Haters gonna hate. Engineers gonna love. What the hell? D:

--Made by duby ;) Based off Necrossins turret.

AddCSLuaFile()


ENT.Type   = "anim"
ENT.PrintName           = "Aeigs2"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

-- Some precaching stuff


util.PrecacheSound("physics/wood/wood_crate_break1.wav")
for i=1,2 do
	util.PrecacheSound("physics/wood/wood_crate_break"..i..".wav")
end

-- Options
ENT.MaxHealth = 400
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
if CLIENT then
	function ENT:Initialize()
		hook.Add("PreDrawHalos", "AddAegis2Halos".. tostring(self), function()
			halo.Add( ents.FindByClass( "aegis2" ), Color( 0, 0, 225 ), 0.25, 0.25, 2)
		end)
	end
	
	function ENT:OnRemove()
		hook.Remove( "PreDrawHalos", "AddAegis2Halos".. tostring(self))
	end
elseif SERVER then
	function ENT:Initialize()
		
		self._mOwner = self:GetTurretOwner()
		self.Entity:SetModel("models/props_debris/wood_board07a.mdl")
		--self.Entity:SetModel("models/props_c17/oildrum001.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS )
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	    self.Entity:SetAngles(Angle(0,90,90))
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
		--return self:GetPos() + self:GetUp() * 70
	end

	function ENT:GetAnglesToPos(pos)
		return (pos - self:ShootPos()):Angle()
	end

	function ENT:GetLocalAnglesToPos(pos)
		return self:WorldToLocalAngles(self:GetAnglesToPos(pos))
	end

	function ENT:IsValidTarget(target)
		return target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and 
		self:GetForward():Dot(self:GetAnglesToTarget(target):Forward()) >= self.MinimumAimDot and MyTrueVisible(self:ShootPos(), self:GetTargetPos(target), self) and self:IsValidZombieClass(target)
	end


	local TURRETOWNER
	local TURRET

	local damageisfalse = {damage = false, effect = true}

	
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

function ENT:GetTurretOwner()
	return self:GetDTEntity(0)
	--return self:GetNWEntity("TurretOwner")
end