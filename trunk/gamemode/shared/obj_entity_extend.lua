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

--[==[----------------------------------------------------------------]==]

if SERVER then
    util.AddNetworkString( "net_floating_text" )

    function meta:FloatingTextEffect( points, attacker )
        if IsValid( attacker ) and attacker:IsPlayer() then
            net.Start( "net_floating_text" )
                net.WriteInt( points, 32 )
                net.WriteEntity( self )
            net.Send( attacker )
        end
    end
end

if CLIENT then
    net.Receive( "net_floating_text", function( len )
        local points = net.ReadInt( 32 )
        local ent = net.ReadEntity()
        
        if ( IsValid( ent ) ) then
            ent:FloatingTextEffect( points )
        end
    end )

    function meta:FloatingTextEffect( points )
        local effect = EffectData()
        
        -- Top-center
        local pos = self:OBBCenter()
        pos.z = self:OBBMaxs().z
        
        effect:SetOrigin( self:LocalToWorld( pos ) )
        effect:SetMagnitude( math.Round( points ) or 0 )
        
        util.Effect( "effect_floating_text", effect, true, true )    
    end
end

--[==[----------------------------------------------------------------]==]

local matWireframe = Material( "models/wireframe" )
local matWhite = Material( "models/debug/debugwhite" )

function meta:RenderGlowEffect( color )
    if ( not color ) then
        color = Color( 1, 0.5, 1 )
    end
        
    -- Setup timing
    self.Seed = self.Seed or math.Rand( 0, 10 )
    local mytime = ( 1 + math.sin( CurTime() * 8 ) ) / 2

    -- Too far away
    if ( not ( EyePos():Distance(self:GetPos()) <= 1024 ) ) then
        return
    end
    
    local oldscale = self:GetModelScale()

    -- Render wireframe/debugwhite
    self:SetModelScale( oldscale * 1.01, 0 )
    
    render.SetColorModulation( color.r, color.g, color.b )
    render.SuppressEngineLighting(true)

    render.SetBlend(0.15 * mytime)
    render.ModelMaterialOverride( matWhite )
    self:DrawModel()

    render.SetBlend(0.4 * mytime)
    render.ModelMaterialOverride( matWireframe )
    self:DrawModel()

    render.ModelMaterialOverride(0)
    render.SuppressEngineLighting(false)
    render.SetBlend(1)
    render.SetColorModulation(1, 1, 1)
    
    self:SetModelScale( oldscale, 0 )
end

hook.Add( "PostDrawOpaqueRenderables", "RenderWeaponsGlow", function()
    if ( IsValid( MySelf ) and MySelf:IsHuman() and MySelf:Alive() ) then
        for k,v in pairs( ents.FindByClass( "weapon_*" ) ) do
        	--Check if it's in the world and not holden by a player
        	if not IsValid( v:GetOwner() ) then
            	v:RenderGlowEffect( Color( 0.1, 0.5, 1 ) )
            end
        end
    end
end )

--[==[----------------------------------------------------------------]==]
