-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local ents = ents

local meta = FindMetaTable ("Entity")
if not meta then return end

--[==[meta.OldSetColor = meta.SetColor

function meta:SetColor(...)
	
	if arg and type(arg[1]) == "table" then
		meta:OldSetColor(...)
		return
	end
	
	if arg then
		local col = Color(arg[1] or 255,arg[2] or 255, arg[3], or 255, arg[4] or 255)
		meta:OldSetColor(col)
	end
	
end

meta.OldGetColor = meta.GetColor

/*function meta:GetColor()
	local col = meta:OldGetColor()
	
	return col.r,col.g,col.b,col.a
end]==]

if SERVER then
	util.AddNetworkString( "UpdateModelScale" )
elseif CLIENT then
	net.Receive( "UpdateModelScale", function( len )

		local scale = net.ReadDouble()
		local ent = net.ReadEntity()
		
		if not IsValid(LocalPlayer()) then return end
		
		if IsValid(ent) then
			ent:SetModelScale(scale,0)
		end

	end)
end

meta.OldSetModelScale = meta.SetModelScale

function meta:SetModelScale(sz,time)
	
	if SERVER then
		if self:IsPlayer() then
			net.Start("UpdateModelScale")
				net.WriteDouble(sz)
				net.WriteEntity(self)
			net.Broadcast()
		else
			self:OldSetModelScale(sz,time)
		end
	else
		self:OldSetModelScale(sz,time)
	end
	
end

-- Check if the entity is on the ground
--[==[function meta:IsOnGround()
	local trLine = util.TraceLine( { start = self:LocalToWorld( self:OBBMins() ), endpos = self:LocalToWorld( self:OBBMins() ) - Vector( 0,0,1000 ), filter = ents.GetAll() } )
	
	-- Is on the ground
	if trLine.HitWorld then 
		if self:LocalToWorld( self:OBBMins() ):Distance( trLine.HitPos ) < 20 then
			return true
		end
		
		-- Started as solid
		if trLine.StartSolid then
			return true
		end
	end
	
	return false
end]==]

function meta:TakeSpecialDamage(damage, damagetype, attacker, inflictor, hitpos)
	attacker = attacker or self
	if not attacker:IsValid() then attacker = self end
	inflictor = inflictor or attacker
	if not inflictor:IsValid() then inflictor = attacker end
	
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(damage)
	dmginfo:SetAttacker(attacker)
	dmginfo:SetInflictor(inflictor)
	dmginfo:SetDamagePosition(hitpos or self:NearestPoint(inflictor:NearestPoint(self:LocalToWorld(self:OBBCenter()))))
	dmginfo:SetDamageType(damagetype)
	
	-- local dmginfo = GAMEMODE:EntityTakeDamage( self, dmginfo )
	-- if dmginfo then
		self:TakeDamageInfo(dmginfo)
	-- end

	return dmginfo
end

function meta:TakeCustomDamage ( amount, attacker, bullettype, dmginfo, trTable )
	if not ValidEntity ( self ) then return false end
	
	if not dmginfo then dmginfo = DamageInfo() end
	
	-- Set some of the dmginfo vars 
	dmginfo:SetDamageType ( bullettype )
	dmginfo:SetDamageForce ( Vector (0,0,0) )
	dmginfo:SetDamage ( amount )
	dmginfo:SetAttacker ( attacker )
	
	-- Set damage position
	if trTable then dmginfo:SetDamagePosition( trTable.HitPos ) end
	
	--See if there is an inflictor if not set it to activate weapon
		if attacker:IsPlayer() and attacker:GetActiveWeapon():IsValid() then
			if IsValid(dmginfo:GetInflictor()) then
				if dmginfo:GetInflictor():GetClass() == "zs_turret" then
					-- dmginfo:SetInflictor( attacker:GetActiveWeapon() )
					-- dmginfo:GetInflictor().Inflictor = "zs_turret"
					dmginfo:GetInflictor().IsTurretDmg = true
				else
					dmginfo:SetInflictor( attacker:GetActiveWeapon() )
					dmginfo:GetInflictor().IsTurretDmg = false
				end
			else
					dmginfo:SetInflictor( attacker:GetActiveWeapon() )
					dmginfo:GetInflictor().IsTurretDmg = false
			end	
		end
	
	-- Dispatch attack
	if bullettype == DMG_SLASH then 
		dmginfo:SetDamage( 0 )
		self:DispatchTraceAttack( dmginfo, attacker:GetShootPos(), dmginfo:GetDamagePosition() )
		dmginfo:SetDamage( amount )
	end
	
	if bullettype == DMG_BULLET or bullettype == DMG_SLASH then
		local dmginfo = GAMEMODE:EntityTakeDamage( self,dmginfo )
		if dmginfo then	self:SetHealth( self:Health() - dmginfo:GetDamage() ) end
	end
end

function meta:GetHolder()
	for _, ent in pairs(ents.FindByClass("status_human_holding")) do
		if ent:GetObject() == self then
			local owner = ent:GetOwner()
			if owner:IsPlayer() and owner:Alive() then return owner, ent end
		end
	end
end

meta.BaseGetOwner = meta.GetOwner
-- hacky way to override some shit
function meta:GetOwner()
	if self._mOwner then
		return self._mOwner
	end
	return self:BaseGetOwner()
end

function meta:IsNailed()
if CLIENT then return end
	return self.Nails
end

if CLIENT then
	if not meta.TakeDamageInfo then
		meta.TakeDamageInfo = function() end
	end
	if not meta.SetPhysicsAttacker then
		meta.SetPhysicsAttacker = function() end
	end
end

function meta:CollisionRulesChanged()
	if not self.m_OldCollisionGroup then self.m_OldCollisionGroup = self:GetCollisionGroup() end
	self:SetCollisionGroup(self.m_OldCollisionGroup == COLLISION_GROUP_DEBRIS and COLLISION_GROUP_WORLD or COLLISION_GROUP_DEBRIS)
	self:SetCollisionGroup(self.m_OldCollisionGroup)
	self.m_OldCollisionGroup = nil
end

function meta:ResetBones(onlyscale)
	local v = Vector(1, 1, 1)
	if onlyscale then
		for i=0, self:GetBoneCount() - 1 do
			self:ManipulateBoneScale(i, v)
		end
	else
		local a = Angle(0, 0, 0)
		for i=0, self:GetBoneCount() - 1 do
			self:ManipulateBoneScale(i, v)
			self:ManipulateBoneAngles(i, a)
			self:ManipulateBonePosition(i, vector_origin)
		end
	end
end