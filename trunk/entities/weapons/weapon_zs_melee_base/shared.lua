AddCSLuaFile()
AddCSLuaFile("cl_init.lua")

SWEP.ViewModel = "models/weapons/v_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

if CLIENT then
	SWEP.ShowViewModel = false
end

SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1
SWEP.ViewModelFOV = 60
SWEP.NextLeap = 0
SWEP.Breakthrough = false

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 65
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 0
SWEP.Berserker = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 200

SWEP.IsMelee = true

SWEP.HoldType = "melee"
SWEP.SwingHoldType = "grenade"

SWEP.DamageType = DMG_SLASH

SWEP.BloodDecal = "Blood"
SWEP.HitDecal = "Impact.Concrete"

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER

SWEP.SwingTime = 0
SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.SwingOffset = Vector(0, 0, 0)

function SWEP:Precache()
	for i=1,4 do
		util.PrecacheSound("weapons/melee/golf club/golf_hit-0"..i..".wav")
	end

	for i=2,4 do
		util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
	end
end

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	self:SetWeaponHoldType(self.HoldType)
	self:SetWeaponSwingHoldType(self.SwingHoldType)

	if CLIENT then
		--Set default FOV
		if self.ViewModelFOV then
			self.ViewModelDefaultFOV = self.ViewModelFOV
		end		
		--Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)

		self:CreateModels(self.VElements) --Create viewmodels
		self:CreateModels(self.WElements) --Create worldmodels
	end
end

function SWEP:SetWeaponSwingHoldType(t)
	local old = self.ActivityTranslate
	self:SetWeaponHoldType(t)
	local new = self.ActivityTranslate
	self.ActivityTranslate = old
	self.ActivityTranslateSwing = new
end

function SWEP:TranslateActivity(act)
	if self:GetSwingEnd() ~= 0 and self.ActivityTranslateSwing[act] ~= nil then
		return self.ActivityTranslateSwing[act]
	end

	if self.ActivityTranslate[act] ~= nil then
		return self.ActivityTranslate[act]
	end

	return -1
end

function SWEP:IsMelee()
	return true
end

function SWEP:PreDrawViewModel(vm, pl, weapon)
	if (!self.ShowViewModel) then
		render.SetBlend(0)
	end
end

function SWEP:PostDrawViewModel(vm, pl, weapon)
	render.SetBlend(1)
end


function SWEP:Deploy()
	if SERVER then
		GAMEMODE:WeaponDeployed(self.Owner, self)
	end
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	
	if self.Owner:GetPerk("_berserker") then
		if self.Owner:GetPerk("_breakthrough") then	
			self.Breakthrough = true
		end
		self.Berserker = true
	else
		self.Berserker = false
	end
	
	self:OnDeploy()
	
	self.Owner:StopAllLuaAnimations()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:OnDeploy()
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) then
		self.HadFirstDraw = false

		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)

			vm:SetMaterial("")
			vm:SetColor(Color(255,255,255,255))

			--vm:SetColor(Color(255,255,255,255))
			--vm:SetMaterial("")
		end
	end
end

function SWEP:Equip(NewOwner)
	if CLIENT then
		return
	end

	--Call this function to update weapon slot and others
	gamemode.Call("OnWeaponEquip", NewOwner, self)
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		self:StopSwinging()
		self:MeleeSwing()
	end
	
	if self.Leaping and self.Breakthrough then
		self.Owner:LagCompensation(true)

		local traces = self.Owner:PenetratingMeleeTrace(20, 20, nil, self.Owner:LocalToWorld(self.Owner:OBBCenter()))

		local hit = false
		for _, trace in ipairs(traces) do
			if not trace.Hit then
				continue
			end

			hit = true

			if not trace.HitWorld then
				local ent = trace.Entity
				if not ent or not ent:IsValid() then
					continue
				end

				--Break glass
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire( "break", "", 0 )
					hit = true
				end

				--Check for valid phys object
				local phys = ent:GetPhysicsObject()
				if not phys:IsValid() or not phys:IsMoveable() or ent.Nails then
					continue
				end

				if ent:IsPlayer() or ent:IsNPC() then
					local Velocity = self.Owner:GetForward() * 180
					Velocity.z = math.Clamp(Velocity.z,190,220)
					ent:SetVelocity(Velocity)
				else
					--Calculate velocity to push
					local Velocity = self.Owner:EyeAngles():Forward() * (100 * 3)
					Velocity.z = math.min(Velocity.z,1600)
					phys:ApplyForceCenter(Velocity)		
				end
				
				--Take damage
				ent:TakeDamage(self.MeleeDamage*0.4, self.Owner, self)
				self.Attacking = CurTime() + 1.25					
			end
		end

		if hit then
			if self.Owner.ViewPunch then
				self.Owner:ViewPunch(Angle(math.random(0, 70), math.random(0, 70), math.random(0, 70)))
			end

			if SERVER then
				self.Owner:EmitSound(Sound("physics/flesh/flesh_strider_impact_bullet1.wav"))
			end
						
			self.Leaping = false
			self.NextLeap = CurTime() + 3
		end
		
		--Always update leap status
		if (self.Owner:OnGround() or self.Owner:WaterLevel() >= 2) then
			self.Leaping = false
		end

		self.Owner:LagCompensation(false)
	end	
end

function SWEP:OnDrop()
	if CLIENT then
		self:OnRemove()
	end	
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return false
	end

	return not self:IsSwinging()
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
end

function SWEP:PlayStartSwingSound()
	--[=[local snd = "npc/combine_soldier/gear"..math.random(6)..".wav"
	self:EmitSound(snd, 60, math.Clamp((SoundDuration(snd) / self.SwingTime) * 100, 50, 240))]=]
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/golf club/golf_hit-0"..math.random(1, 4)..".wav")
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PlayHitFleshSound()

	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then
		return
	end

	if self.SwingTime == 0 then
		self:MeleeSwing()
	else
		self:StartSwinging()
	end
end

function SWEP:SecondaryAttack()
	if self.Berserker then
		
		if CurTime() < self.NextLeap or not self.Owner:OnGround() then
			return
		end	
		
		--Set flying velocity
		local Velocity = self.Owner:GetAngles():Forward() * 400
		
		Velocity.z = math.Clamp(Velocity.z, 150,260)

		self.Leaping = true
		
		--Leap cooldown
		self.NextLeap = CurTime() + 5
		
		if SERVER then
			self.Owner:EmitSound(Sound("vo/ravenholm/monk_pain0".. math.random(1,9) ..".wav"),70,math.random(80,100))
			self.Owner:EmitSound(Sound("weapons/physcannon/energy_sing_flyby".. math.random(1,2) ..".wav"),90,math.random(115,125))
		end
		
		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetLocalVelocity(Velocity)	
		
	end
end

function SWEP:Holster()
	if CLIENT then
		self:OnRemove()
	end

	return CurTime() >= self:GetSwingEnd()
end

function SWEP:StartSwinging()
	if self.StartSwingAnimation then
		self:SendWeaponAnim(self.StartSwingAnimation)
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	self:PlayStartSwingSound()
	
	local swingtime = self.SwingTime
		
	if self.Owner and self.Owner:GetPerk("_psychotic") then
		swingtime = math.Clamp(self.SwingTime*0.6,0,self.SwingTime)
	end

	self:SetSwingEnd(CurTime() + swingtime)
end

function SWEP:MeleeSwing()
	local owner = self.Owner

	--Viewpunch
	self.Owner:MeleeViewPunch(self.MeleeDamage*0.05)
	owner:SetAnimation(PLAYER_ATTACK1)
	local filter = owner:GetMeleeFilter()

	owner:LagCompensation(true)

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, filter)
	if tr.Hit then
		local damage = self.MeleeDamage

		local hitent = tr.Entity
		local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH
		
		if self.HitAnim then
			self.Weapon:SendWeaponAnim(self.HitAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()*2

		if hitflesh then
			util.Decal(self.BloodDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

			self:PlayHitFleshSound()

			if SERVER and not (hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == owner:Team()) then
				util.Blood(tr.HitPos, math.Rand(damage * 0.05, damage * 0.1), (tr.HitPos - owner:GetShootPos()):GetNormal(), math.Rand(damage * 3, damage * 6), true)
			end

		else
			self:PlayHitSound()	
			util.Decal(self.HitDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
		
		if self.OnMeleeHit and self:OnMeleeHit(hitent, hitflesh, tr) then
			owner:LagCompensation(false)
			return
		end

		if SERVER and hitent:IsValid() then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(damage)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self.Weapon)
				--dmginfo:SetDamageType(DMG_BULLET)
				dmginfo:SetDamageType(self.DamageType)
				dmginfo:SetDamageForce(self.MeleeDamage * 20 * owner:GetAimVector())
				if hitent:IsPlayer() then
				
					hitent:MeleeViewPunch(damage*0.05)
					hitent:Daze(0.5)	
					local Velocity = self.Owner:EyeAngles():Forward() * damage * 3 * (self.MeleeSize - 0.25)
					Velocity.x = Velocity.x * 0.4
					Velocity.y = Velocity.y * 0.4
					Velocity.z = Velocity.z * 1.12

					if owner:GetPerk("_oppressive") then
						Velocity.z = Velocity.z * 1.85
					end
					
					Velocity.z = math.Clamp(Velocity.z,0,220)
	
					hitent:SetLocalVelocity(Velocity)	
				end		
					
					hitent:TakeDamageInfo(dmginfo)				
				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(owner)
				end
			end
		end

		if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, tr) end

		if CLIENT then
			local tr2 = owner:DoubleTrace(self.MeleeRange, MASK_SHOT, self.MeleeSize, filter)
			if tr2.HitPos == tr.HitPos then
				owner:FireBullets({Num = 1, Src = owner:GetShootPos(), Dir = (tr2.HitPos - owner:GetShootPos()):GetNormal(), Spread = Vector(0, 0, 0), Tracer = 0, Force = self.MeleeDamage * 200, Damage = damage, HullSize = self.MeleeSize * 2})
			end
		end
	else
		if self.MissAnim then
			self.Weapon:SendWeaponAnim(self.MissAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(tr) end
	end

	owner:LagCompensation(false)
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat(0, swingend)
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat(0)
end

if CLIENT then	
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		--Make FOV movable
		if self.ViewModelDefaultFOV then
			local TargetFOV = self.ViewModelDefaultFOV + GetConVarNumber("zs_viewmodel_fov")
			if self.ViewModelFOV ~= TargetFOV then
				self.ViewModelFOV = TargetFOV
			end
		end
		
		if not IsValid(self.Owner) or not self.Owner:IsPlayer() then
			return
		end

		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then
			return
		end

		if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then 
			vm:SetColor(Color(255,255,255,1)) 
			self:DrawWorldModel()
			return
		end
				
		--vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
						
		if (!self.VElements) then
			return
		end
				
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			--we build a render order because sprites need to be drawn after models
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
								--//model:SetModelScale(v.size)
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

		if (!IsValid(self.Owner) && self.WElements) then
			self:DrawModel()	
		end
		
		if (!self.WElements) then
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
					--	// when the weapon is dropped
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
							--	//model:SetModelScale(v.size)
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
						
						--// Technically, if there exists an element with the same name as a bone
						--// you can get in an infinite loop. Let's just hope nobody's that stupid.
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
								ang.r = -ang.r --Fixes mirrored models
						end
				
				end
				
				return pos, ang
	end

   	function SWEP:CreateModels( tab )
		if (!tab) then return end

		--Create the clientside models here because Garry says we cant do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
				string.find(v.model, ".mdl") and file.Exists(v.model, "GAME") ) then
								
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
						--		// make sure we create a unique name based on the selected options
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
						
						--// !! WORKAROUND !! //
						--// We need to check all model names :/
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
					--	// !! ----------- !! //
						
						for k, v in pairs( loopthrough ) do
								local bone = vm:LookupBone(k)
								if (!bone) then continue end
								
							--	// !! WORKAROUND !! //
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
							--	// !! ----------- !! //
								
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
		local actualVM
		if not vm or not IsValid(vm) then
			actualVM = self.Owner:GetViewModel()
			if vm or not IsValid(vm) then
				return
			end
		else
			actualVM = vm
		end

		if (!actualVM:GetBoneCount()) then
			return
		end
		
		for i=0, actualVM:GetBoneCount() do
			actualVM:ManipulateBoneScale( i, Vector(1, 1, 1) )
			actualVM:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			actualVM:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
	end
end

