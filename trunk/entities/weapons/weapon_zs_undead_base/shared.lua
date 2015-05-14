--Dummy base for tools and stuff

AddCSLuaFile()

if CLIENT then
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 80
	SWEP.ViewModelFlip = true
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
end

SWEP.Author = "Ywa"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 0
SWEP.Primary.Duration = -1
SWEP.Primary.Delay = 0
SWEP.Primary.Reach = 10
SWEP.Primary.Size = 1.5

SWEP.Secondary.Duration = -1
SWEP.Secondary.Damage = 0
SWEP.Secondary.Delay = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

--TODO: Check if properly set
SWEP.DeploySpeed = 1.1

--TODO: Check if needed
SWEP.Weight	= 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom	= false

SWEP.SwapAnims = false

SWEP.IdleSounds = {}
SWEP.AttackSounds = {}

function SWEP:Deploy()
	--Idle VOX sounds
	if SERVER then
		local that = self
		timer.Simple(1.5, function()
			if IsValid(that) and that.IdleVOX then
				that:IdleVOX()
			end
		end)
	end
end

function SWEP:Precache()
end

function SWEP:Initialize()
	if CLIENT then
		self:MakeArms()

		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		
		-- init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				-- Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	--Check if we have a primary attack
	if not self.Primary.Duration or self.Primary.Duration < 0 then
		return true
	end

	--Check if already attacking
	if self:IsInPrimaryAttack() or self:IsInSecondaryAttack() then
		return true
	end

	--Delay next attack
	if self.Primary.Next then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Next)
		--self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Next)
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Duration)
		--self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Duration)
	end

	--Start swinging
	self:StartPrimaryAttack()

	--Reset preTraces
	self.preTraces = {}

	--Set time before actual damaging
	if self.Primary.Delay > 0 then
		local traces = self.Owner:PenetratingMeleeTrace(self.Primary.Reach, self.Primary.Size, nil)
		for _, trace in ipairs(traces) do
			if not trace.Hit or trace.HitWorld then
				continue
			end

			local ent = trace.Entity
			if not ent or not ent:IsValid() then
				continue
			end
			
			local phys = ent:GetPhysicsObject()
			if not phys:IsValid() or ent:IsNPC() or not phys:IsMoveable() or ent:IsPlayer() or ent.Nails then
				continue
			end

			--It's a phys object. It's a proper preTrace
			table.insert(self.preTraces,trace)
		end

		self:SetPrimaryDelay(CurTime() + self.Primary.Delay)
	else
		self:PerformPrimaryAttack()
	end
	
	return true
end

function SWEP:StartPrimaryAttack()
end

function SWEP:PerformPrimaryAttack()	
	if CLIENT then
		return
	end
	
	self.Owner:LagCompensation(true)

	--Do actual traces
	local traces = self.Owner:PenetratingMeleeTrace(self.Primary.Reach, self.Primary.Size, nil)

	--Insert preTraces to normal traces
	local arePreTracesUsed = false
	for _,v in pairs(self.preTraces) do
		table.insert(traces, v)

		if not arePreTracesUsed then
			arePreTracesUsed = true
		end
	end

	--Init table
	local entsHit = {}
		
	local hit = false
	for _, trace in ipairs(traces) do
		if not trace.Hit then
			continue
		end

		if trace.HitWorld then
			hit = true
		else
			local ent = trace.Entity
			if not ent or not ent:IsValid() then
				continue
			end

			if arePreTracesUsed then
				--Check if we already hit this ent
				local hitTwice = false
				for _,v in pairs(entsHit) do
					if ent == v then
						hitTwice = true
						break
					end
				end

				--If we already hit this ent. Skip
				if hitTwice then
					continue
				end

				--Insert to hit table
				table.insert(entsHit, ent)
			end

			--Break glass
			if ent:GetClass() == "func_breakable_surf" then
				ent:Fire( "break", "", 0 )
				hit = true
			end

			local phys = ent:GetPhysicsObject()
			-- Case 2: It is a valid physics object
			if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() and not ent.Nails then
				
				local Velocity
				
				if self.Primary.Damage >= 20 and self.Primary.Damage != 29 then
					Velocity = self.Owner:EyeAngles():Forward() * math.Clamp(self.Primary.Damage * 1300, 5000, 50000)
				else
					Velocity = self.Owner:EyeAngles():Forward() * math.Clamp(self.Primary.Damage * 500, 5000, 50000)				
				end
				
				--Velocity.z = math.min(Velocity.z,1600)				
				--Apply force to prop and make the physics attacker myself
				phys:ApplyForceCenter(Velocity)
				ent:SetPhysicsAttacker(self.Owner)
				ent:TakeDamage(self.Primary.Damage, self.Owner, self)					
				hit = true

			elseif ent:IsPlayer() and ent:IsHuman() and not ent:IsWeapon() then		
				local Velocity = self.Owner:EyeAngles():Forward() * math.Clamp(self.Primary.Damage * 10, 10, 10000)	

				--util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

				if SERVER then
				
				local vel = ent:GetPos()
					vel.z = vel.z + 32
					util.Blood(vel, math.Rand(self.Primary.Damage * 0.2, self.Primary.Damage * 0.4), vel:GetNormal(), math.Rand(self.Primary.Damage * 0.7, self.Primary.Damage), true)
				end
			
				
				if ent:GetPerk("_medic") then
					--ent:TakeDamage(self.Primary.Damage() - (self.Primary.Damage()* (4*attacker:GetRank())/100), self.Owner, self)	
					
					ent:TakeDamage(self.Primary.Damage - (self.Primary.Damage* (5*ent:GetRank())/100), self.Owner, self)
					
				elseif ent:GetPerk("_sharpshooter") and ent.DataTable["ShopItems"][69] and math.random(1,5) == 1 then
					ent:TakeDamage(0, self.Owner, self)					
				else
					ent:TakeDamage(self.Primary.Damage, self.Owner, self)
				end
				
				if self.Primary.Damage > 20 then
					Velocity.z = math.Clamp(Velocity.z + self.Primary.Damage * 13, 230, 270)
					--ent:SetSpeed(ent:GetMaxSpeed()*0.5)
					ent:SetLocalVelocity(Velocity)					
				end
				
				if self.Owner:HasBought("vampire") and self.Owner:Health() + self.Primary.Damage * 0.5 < self.Owner:GetMaximumHealth() then	
					self.Owner:SetHealth(self.Owner:Health() + self.Primary.Damage * 0.5)	
				end	
				--Velocity.z = Velocity.z * 2.5									
				hit = true
				else
				ent:TakeDamage(self.Primary.Damage, self.Owner, self)
				--local mOwner = self.Owner
				hit = true				
			end
		end

		self:PrimaryAttackHit(trace, ent)
	end

	self.Owner:LagCompensation(false)

	self:PostPerformPrimaryAttack(hit)
end

function SWEP:PrimaryAttackHit(trace, ent)
end

function SWEP:PostPerformPrimaryAttack(hit)
end

function SWEP:SecondaryAttack()
	--Check if we have a secondary attack
	if not self.Secondary.Duration or self.Secondary.Duration < 0 then
		return true
	end

	--Check if already attacking
	if self:IsInPrimaryAttack() or self:IsInSecondaryAttack() then
		return true
	end

	--Delay next attack
	if self.Secondary.Next then
		--self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Next)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Next)
	else
		--self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Duration)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Duration)
	end

	--Delay leaping
	--self.Weapon:SetNextSecondaryFire(self:GetNextPrimaryFire() + 0.5)

	--Start swinging
	self:StartSecondaryAttack()

	--Set time before actual damaging
	if self.Secondary.Delay > 0 then
		self:SetSecondaryDelay(CurTime() + self.Secondary.Delay)
	else
		self:PerformSecondaryAttack()
	end
	
	return true
end

function SWEP:StartSecondaryAttack()
end

function SWEP:PerformSecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:StopPrimaryAttack()
	self:SetPrimaryDelay(0)
end

function SWEP:SetPrimaryDelay(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetPrimaryDelay()
	return self:GetDTFloat(0)
end

function SWEP:IsInPrimaryAttack()
	return self:GetNextPrimaryFire() > CurTime()
end

function SWEP:StopSecondaryAttack()
	self:SetSecondaryDelay(0)
end

function SWEP:SetSecondaryDelay(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetSecondaryDelay()
	return self:GetDTFloat(1)
end

function SWEP:IsInSecondaryAttack()
	return self:GetNextSecondaryFire() > CurTime()
end

function SWEP:CheckPrimaryAttack()
	local performTime = self:GetPrimaryDelay()
	if performTime == 0 or CurTime() < performTime then
		return
	end

	--Reset swing time
	self:StopPrimaryAttack()

	--Hit em baby
	self:PerformPrimaryAttack()
end

function SWEP:CheckSecondaryAttack()
	local performTime = self:GetSecondaryDelay()
	if performTime == 0 or CurTime() < performTime then
		return
	end

	--Reset swing time
	self:StopSecondaryAttack()

	--Hit em baby
	self:PerformSecondaryAttack()
end

function SWEP:Think()	
	self:CheckPrimaryAttack()
	self:CheckSecondaryAttack()
end

function SWEP:Holster()
	self:OnRemove()
	
	return true
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

function SWEP:OnRemove()
	if CLIENT then
		self:RemoveArms()
	end

    if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

function SWEP:Equip(NewOwner)
	if CLIENT then
		return
	end
end

function SWEP:PreDrawViewModel(vm, pl, weapon)
	--Init viewmodel visibility
	if (self.ShowViewModel == nil or self.ShowViewModel) then
		vm:SetColor(Color(255,255,255,255))

		vm:SetMaterial("")
	else
		-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
		vm:SetColor(Color(255,255,255,1))
		-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
		-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
		vm:SetMaterial("Debug/hsv") --Debug/hsv
	end
end

if CLIENT then
	--[[local lerp = 0
	function SWEP:GetViewModelPosition(pos, ang)
		lerp = math.Approach(lerp, 0, FrameTime() * ((lerp + 1) ^ 3))
		ang:RotateAroundAxis(ang:Right(), 64 * lerp)
		if lerp > 0 then
			pos = pos + -8 * lerp * ang:Up() + -12 * lerp * ang:Forward()
		end
		return pos, ang
	end]]

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then
			return
		end

--BEGIN ARMS
		if IsValid(self.Arms) then
			if self.Arms:GetModel() ~= self.Owner:GetModel() then
				self.Arms:SetModel(self.Owner:GetModel())
			end
			
			if not self.Arms.GetPlayerColor then
				self.Arms.GetPlayerColor = function() return Vector(GetConVarString("cl_playercolor")) end
			end

		
			render.SetBlend(1) 
				self.Arms:SetParent(vm)
				
				self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
				
				for b, tbl in pairs(PlayerModelBones) do
					if tbl.ScaleDown then
						local bone = self.Arms:LookupBone(b)
						if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
							self.Arms:ManipulateBoneScale( bone, Vector(0.00001, 0.00001, 0.00001) )
						end
					else
						if not tbl.Arm then
							local bone = self.Arms:LookupBone(b)
							if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
								self.Arms:ManipulateBoneScale( bone, Vector(1.5, 1.5, 1.5) )
							end
						end
					end
				end
				
				self.Arms:SetRenderOrigin( vm:GetPos()-vm:GetAngles():Forward()*20-vm:GetAngles():Up()*60 )-- self.Arms[1]:SetRenderOrigin( EyePos() )
				self.Arms:SetRenderAngles( vm:GetAngles() )
				
				self.Arms:SetupBones()	
				self.Arms:DrawModel()
				
				self.Arms:SetRenderOrigin()
				self.Arms:SetRenderAngles()
				
			render.SetBlend(1)
		end
-- END ARMS
		
		if (!self.VElements) then
			return
		end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
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
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
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
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

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
			bone_ent = self.Owner
		else
			--when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
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
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r -- Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		--Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
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
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
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
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function SWEP:DrawHUD()
		if self.Primary.Reach then
			GAMEMODE:DrawZombieCrosshair(self.Owner, self.Primary.Reach)
		end
	end
end

function SWEP:IdleVOX()
	--Next sund duration
	local fDuration = math.Rand( 1.6, 7 ) + 1.7

	--Cooldown for new sound
	local that = self
	timer.Simple(fDuration, function()
		if not IsValid(that) or not that.IdleVOX then
			return
		end
		
		that:IdleVOX()
	end)

	if not IsValid(self.Owner) or ENDROUND or not self.IdleSounds or #self.IdleSounds == 0 then
		return
	end

	--Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	--Not alive or attacking
	if not mOwner:Alive() or self:IsInPrimaryAttack() then
		return
	end
	
	--Emit idle sound
	local mSound = table.Random(self.IdleSounds)
	mOwner:EmitSound(Sound(mSound))
end

if CLIENT then
	function SWEP:MakeArms()
		if not self.FakeArms then
			return
		end

		self.Arms = ClientsideModel("models/player/group01/male_04.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE) 
		
		if (IsValid(self.Arms)) and (IsValid(self)) then 
			self.Arms:SetPos(self:GetPos())
			self.Arms:SetAngles(self:GetAngles())
			self.Arms:SetParent(self) 
			self.Arms:SetupBones()
			-- self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
			self.Arms:SetNoDraw(true) 
		else
			self.Arms = nil
		end	
	end

	function SWEP:RemoveArms()
		if (IsValid(self.Arms)) then
			self.Arms:Remove()
		end

		self.Arms = nil
	end
end