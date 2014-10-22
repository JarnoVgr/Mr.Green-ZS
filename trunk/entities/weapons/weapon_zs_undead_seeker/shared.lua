-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.PrintName = "weapon"
end

if CLIENT then
	
	
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	
	
	SWEP.ShowViewModel = true
	
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.899, 0.899, 0.899), pos = Vector(0, 0, 0), angle = Angle(0, -19.962, -12.825) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.551, 6.58, -41.668) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.705, 1.25, 0.705), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.663, 4.375, 48.555) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.705, 1.25, 0.705), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1.549, 1.549, 1.549), pos = Vector(0.012, 2.7, -2.363), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.899, 0.899, 0.899), pos = Vector(0, 0, 0), angle = Angle(0, -19.92, 26.055) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1.549, 1.549, 1.549), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(23.111, 0.048, 1.35), angle = Angle(0, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(23.305, 0.048, -1.05), angle = Angle(180, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["body2"] = { type = "Model", model = "models/Humans/Charple02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(4.162, -1.362, 0.55), angle = Angle(-13.912, -180, -1.675), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cleaver"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-16.514, 3.124, 34), angle = Angle(-67.575, -152.163, 24.312), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12.744, -0.601, -0.758), angle = Angle(-157.594, 90.811, -98.482), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-9.219, -4.031, 50), angle = Angle(-4.95, 95.3, -5.7), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.112, -0.732, -0.639), angle = Angle(-100.482, 105.314, -69.044), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body1"] = { type = "Model", model = "models/Humans/Charple03.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-44, 0, 23.875), angle = Angle(67.311, 0.119, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.PrintName = "Seeker"
SWEP.DrawAmmo = false
SWEP.ShowWorldModel = true
SWEP.CSMuzzleFlashes = false
SWEP.DrawCrosshair = true

SWEP.Base = "weapon_zs_undead_base"

SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model("models/weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/props_junk/meathook001a.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DistanceCheck = 88

SWEP.SwapAnims = false





function SWEP:Reload()
	return false
end

function SWEP:OnDeploy()
	if SERVER then
		self:SetAttacking(false)
		self.GrowlSound = CreateSound( self.Owner, "npc/ichthyosaur/water_breath.wav" ) 
	end
end

function SWEP:SetAttacking(bl)
	self:SetDTBool(0,bl)
end

function SWEP:IsAttacking()
	return self:GetDTBool(0) or false
end

function SWEP:Think()
		if self and self.Weapon then
			if IsValid(self.Owner) then
				if SERVER then
					-- self.GrowlSound:PlayEx(0.4, 100) 
				end
				if self:IsAttacking() then
					self.Owner:SetColor(Color(255,255,255,255))
				else
					self.Owner:SetColor(Color(255,255,255,1))
				end
				if CLIENT then
					if self.WElements then
						for k,v in pairs(self.WElements) do
							if self:IsAttacking() then
								-- v.color = Color(255,255,255,255)
							else
								-- v.color = Color(255,255,255,0)
							end
						end
					end
				end
			end
		end
end

-- Primary attack
SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextAttack then return end
	
	self.Weapon:SetNextPrimaryFire ( CurTime() + 3 )
	
	-- Make things easier
	local pl = self.Owner
	self.PreHit = nil
	
	-- Trace filter
	local trFilter = self.Owner-- team.GetPlayers( TEAM_ZOMBIE )
		
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	 
	if SERVER then
		GAMEMODE:SetPlayerSpeed( self.Owner, 50 )
		-- self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
		self:SetAttacking(true)
	end 
		-- timer.Simple ( 0.4, function( pl )
		-- 	if not IsValid ( pl ) then return end
			self.Owner:DoAnimationEvent( CUSTOM_PRIMARY )
		
		-- end,pl)
	timer.Simple ( 1.3, function()
		if not IsValid ( pl ) then return end
		
		-- Conditions
		if not pl:Alive() then return end
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		if self and self.Weapon then self:SetAttacking(false) end
	end)
	if SERVER then if math.random(3) == 1 then self.Owner:EmitSound("player/zombies/seeker/screamclose.wav", 140, math.random( 80, 100 ) ) end end
	 
	-- Trace an object
	local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
	if trace.Hit and IsValid ( trace.Entity ) and not trace.Entity:IsPlayer() then
		self.PreHit = trace.Entity
	end
	
	-- Delayed attack function (claw mechanism)
	if SERVER then timer.Simple ( 0.7, function() self.DoPrimaryAttack(trace, pl, self.PreHit) end ) end
	-- timer.Simple ( 0.55, function()
	-- 		if not IsValid ( pl ) then return end
	-- 		if not IsValid ( self.Weapon ) then return end
			
			if self.SwapAnims then self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER ) else self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) end
			self.SwapAnims = not self.SwapAnims
	-- 	end)	
				
	--  Set the next swing attack for cooldown
	self.NextAttack = CurTime() + 3
	self.NextHit = CurTime() + 0.7
end

-- Primary attack function
function SWEP:DoPrimaryAttack ( trace, pl, victim )
	if not IsValid ( self.Owner ) then return end
	local mOwner = self.Owner
	
	-- Trace filter
	local trFilter = self.Owner-- team.GetPlayers( TEAM_UNDEAD )
	
	-- Calculate damage done
	local Damage = math.random( 50, 60 )

	local TraceHit, HullHit = false, false
	
	-- Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * 5000
	
	-- Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 29 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 20,20,20 ) } )
	
	local tr
	if not IsValid ( victim ) then	
		tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = IsValid ( victim )
	HullHit = IsValid ( trHull.Entity )
	
	if SERVER then 
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, math.random( 70, 80 ) ) end
	
	-- Punch the prop / damage the player if the pretrace is valid
	if IsValid ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		-- Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
		
		
		-- Take damage
		victim:TakeDamage ( math.Clamp( Damage, 1, 99 ), self.Owner, self )
		
		if victim:IsPlayer() and victim:IsZombie() then
			victim:TakeDamage ( Damage/4, victim, self )
		end

		-- Claw sound
		if victim:IsPlayer() then
			victim:EmitSound("player/zombies/seeker/melee_0"..math.random(1,3)..".wav",100, math.random( 90, 110 ))
			if SERVER then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			-- Play the hit sound
			pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
		end
				
		-- Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			-- Apply force to prop and make the physics attacker myself
			phys:ApplyForceCenter( Velocity )
			victim:SetPhysicsAttacker( pl )
		end
	end
	
	-- -- Verify tracehull entity
	if HullHit and not TraceHit then
		local ent = trHull.Entity
		if not IsValid(ent) then return end
		local phys = ent:GetPhysicsObject()
		
		-- Do a trace so that the tracehull won't push or damage objects over a wall or something
		local vStart, vEnd = self.Owner:GetShootPos(), ent:LocalToWorld ( ent:OBBCenter() )
		local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
		if ent ~= ExploitTrace.Entity then return end
		
		-- Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
	
		
		-- From behind
		if ent:IsPlayer() then
			ent:EmitSound("player/zombies/seeker/melee_0"..math.random(1,3)..".wav",100, math.random( 90, 110 ))
			if self.Owner then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			-- Play the hit sound
			pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
		end
		
		-- Take damage
		ent:TakeDamage ( math.Clamp( Damage, 1, 99 ), self.Owner, self )
		
		if ent:IsPlayer() and ent:IsZombie() then
			ent:TakeDamage ( Damage/4, ent, self )
		end
	
		-- Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end

end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end

	if SERVER then 
	
	local humans = team.GetPlayers(TEAM_HUMAN)
	
		if #humans > 0 then
		
		local guy = humans[math.random(1,#humans)]
		
			if guy and IsValid(guy) and guy:Alive() then
				guy:EmitSound( table.Random ( ZombieClasses[12].IdleSounds ),math.random( 140, 160 ),math.random( 60, 90 )  )
			end
		end
	end

	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:_OnRemove()
	if SERVER then
		self.GrowlSound:Stop()
	end
	if CLIENT then
		if self and self.Owner and IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				vm:SetMaterial("")
			end
		end
	end
end

function SWEP:Reload()
	return false
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
	
		
	
		self.ViewModelFOV = GetConVarNumber("zs_wepfov") or self.ViewModelFOV
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		
		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then return end
			
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(255,255,255,255)
		else
			--  we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(255,255,255,1) 
		end
		
		if self:IsAttacking() then
			vm:SetColor(255,255,255,255) 
		else
			vm:SetColor(255,255,255,100) 
		end
		
		if self.VElements then
			for k,v in pairs(self.VElements) do
				if self:IsAttacking() then
					v.color = Color(255,255,255,255)
				else
					v.color = Color(255,255,255,100)
				end
			end
		end

		
		if vm:GetMaterial() == "" then
			vm:SetMaterial("Models/Charple/Charple1_sheet")
		end
		
		if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end
		
		if (not self.VElements) then return end
		
		if (not self.vRenderOrder) then
			
			--  we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (not v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (not v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (not pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
			
		-- if not self:IsAttacking() then return end
		
		if self.WElements then
			for k,v in pairs(self.WElements) do
				if self:IsAttacking() then
					v.color = Color(255,255,255,255)
				else
					v.color = Color(255,255,255,1)
				end
			end
		end
		
		if (not self.WElements) then return end
		
		if (not self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			if self.Owner.KnockedDown and IsValid(self.Owner:GetRagdollEntity()) then
				bone_ent = self.Owner:GetRagdollEntity()
			else
				bone_ent = self.Owner
			end
		else
			--  when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (not v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (not pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
	
		if (tab.rel and tab.rel ~= "") then
			
			local v = basetab[tab.rel]
			
			if (not v) then return end
			
			--  Technically, if there exists an element with the same name as a bone
			--  you can get in an infinite loop. Let's just hope nobody's that stupid.
		pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (not pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		ang:RotateAroundAxis(ang:Up(), v.angle.y)
		ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

		--	if (not bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
		--	local m = ent:GetBoneMatrix(bone)
		--	if (m) then
		--		pos, ang = m:GetTranslation(), m:GetAngle()
		--	end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --  Fixes mirrored models
			end
		
	end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (not tab) then return end

		--  Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and 
					string.find(v.model, "models/player/Charple01.mdl") and file.Exists ("../"..v.model) ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) 
				and file.Exists ("../materials/"..v.sprite..".vmt")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--  make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	-- function SWEP:OnRemove()
	-- 	self:RemoveModels()		
	-- end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

end