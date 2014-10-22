-- Small effect for detaching bones, and yeah it does the same work as in usual zs
--Stuff is redesigned and such

local math = math
local table = table
local pairs = pairs
local util = util
local string = string

function EFFECT:Init(data)
	self.ent = data:GetEntity()
	self.BoneType = data:GetScale()
	
	self.DieTime 		= CurTime() + 10
	self.NextDrip 		= 0
	self.RDieTime 		= CurTime() + 3
	
	-- self.ent:SetModel("models/zombie/classic_torso.mdl")
	
	if not IsValid(self.ent) then return end
	
	-- Correct model
	if HasTorsoTable(self.ent,self.BoneType) then
		-- self.ent:GetRagdollEntity():InvalidateBoneCache()
		-- self.ent:GetRagdollEntity():SetModel(GetTorsoTable(self.ent,self.BoneType).Model)
		-- self.ent:GetRagdollEntity():SetBodygroup(1,GetTorsoTable(self.ent,self.BoneType).BodyGroup)
		-- self.ent:GetRagdollEntity():SetupBones()
		
		self.Torso = ClientsideModel(GetTorsoTable(self.ent,self.BoneType).Model, RENDERGROUP_OPAQUE)
		self.Torso:SetPos(self.ent:GetRagdollEntity():GetPos())
		self.Torso:SetAngles(self.ent:GetRagdollEntity():GetAngles())
		self.Torso:SetParent(self.ent:GetRagdollEntity())
		self.Torso:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
		self.Torso:SetBodygroup(1,GetTorsoTable(self.ent,self.BoneType).BodyGroup)
		
		self.ent:GetRagdollEntity():SetNoDraw(true)
		
	end
	
	self.Emitter = ParticleEmitter(self.ent:GetPos())	
	
	for i=1, math.random(3, 17) do
		local particle = self.Emitter:Add("decals/blood_spray"..math.random(1,8), self.ent:GetPos()-Vector(0,0,10)+Vector(0,0,4)*i+VectorRand()*6)
		particle:SetVelocity(10 * Vector(0,0,1) + 28 * VectorRand() + 17*Vector(math.random(-10,10),math.random(-10,10),math.random(2,30)))
		particle:SetDieTime(math.random(4,8))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(200)
		particle:SetStartSize(math.Rand(16, 24))
		particle:SetEndSize(12)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-40, 40))
		particle:SetAirResistance(5)
		particle:SetBounce(0)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallback)
	end
	
end

local Bones = {}
Bones[1] = {Name = HEAD, BScale = {"ValveBiped.Bip01_Head1"}}
Bones[2] = {Name = DECAPITATION, BScale = {"ValveBiped.Bip01_Head1"}} 
Bones[3] = {Name = LARM, BScale = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand"}}
Bones[4] = {Name = RARM, BScale = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand"}}
Bones[5] = {Name = LLEG, BScale = {"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot"}}
Bones[6] = {Name = RLEG, BScale = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot"}}
Bones[7] = {Name = BOTHLEGS, BScale = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot"}}
Bones[8] = {Name = TORSO, BScale = {	
									-- "ValveBiped.Bip01_Pelvis",
									"ValveBiped.Bip01_Spine",
									"ValveBiped.Bip01_Spine1",
									"ValveBiped.Bip01_Spine2",
									"ValveBiped.Bip01_Spine4",
									"ValveBiped.Bip01_Neck1",
									"ValveBiped.Bip01_Head1",
									"ValveBiped.Bip01_R_Clavicle",
									"ValveBiped.Bip01_R_UpperArm",
									"ValveBiped.Bip01_R_Forearm",
									"ValveBiped.Bip01_R_Hand",
									"ValveBiped.Bip01_L_Clavicle",
									"ValveBiped.Bip01_L_UpperArm",
									"ValveBiped.Bip01_L_Forearm",
									"ValveBiped.Bip01_L_Hand"
								}}
Bones[9] = { BScale = {}, Combined = {1,3,5}}
Bones[10] = { BScale = {}, Combined = {1,4,6}}
Bones[11] = { BScale = {}, Combined = {3,7}}
Bones[12] = { BScale = {}, Combined = {1,3,7}}
Bones[13] = { BScale = {}, Combined = {1,4,7}}
Bones[14] = { BScale = {}, Combined = {1,3,7}}
-- small piece of code from old zs that let us use custom bones instead if  the bones above ^
local ZombiesBones = {}
	ZombiesBones["models/zombie/classic.mdl"] = {["ValveBiped.Bip01_Head1"]="ValveBiped.Bip01_Spine4"}
	ZombiesBones["models/zombie/poison.mdl"] = {["ValveBiped.Bip01_Head1"]="ValveBiped.Bip01_Spine4"}
	ZombiesBones["models/zombie/fast.mdl"] = {["ValveBiped.Bip01_Head1"]="ValveBiped.HC_BodyCube"}
	ZombiesBones["models/mrgreen/howler.mdl"] = {["ValveBiped.Bip01_Head1"]="ValveBiped.Bip01_Spine4"}
	ZombiesBones["models/zombie/zombie_soldier.mdl"] = {["ValveBiped.Bip01_Head1"]="ValveBiped.HC_Head_bone"}
	ZombiesBones["models/zombie/classic_torso.mdl"] = {["ValveBiped.Bip01_R_Thigh"]="ValveBiped.Bip01_Spine",["ValveBiped.Bip01_L_Thigh"]="ValveBiped.Bip01_Spine", ReverseBleedBone = true }
	--ZombiesBones["models/zombie/classic_legs.mdl"] = {["ValveBiped.Bip01_R_Thigh"]="ValveBiped.Bip01_Spine",["ValveBiped.Bip01_L_Thigh"]="ValveBiped.Bip01_Spine", ReverseBleedBone = true }

-- A bit tricky stuff
-- Actually its a nice table so we can replace zombies that were teared apart with actual models
local TorsoTable = {}
	TorsoTable["models/zombie/classic.mdl"] = { [8] = { Model = "models/zombie/classic_legs.mdl",BleedBone = "ValveBiped.Bip01_Pelvis", BodyGroup = 1}, 
												[7] = { Model = "models/zombie/classic_torso.mdl", BodyGroup = 1}
												}
	TorsoTable["models/zombie/fast.mdl"] =	{ 	[8] = { Model = "models/gibs/fast_zombie_legs.mdl",BleedBone = "ValveBiped.Bip01_Pelvis", BodyGroup = 1}, 
												[7] = { Model = "models/gibs/fast_zombie_torso.mdl",BleedBone = "ValveBiped.Bip01_Spine2", BodyGroup = 1}
												}

--  'e' is player, 'num' is self.BoneType
function HasTorsoTable(e,num)
	if e:IsPlayer() then
		local rag = e:GetRagdollEntity()
		if rag and IsValid(rag) then
			if TorsoTable[rag:GetModel()] then
				if TorsoTable[rag:GetModel()][num] then
					return true
				end
			end
		end
	end
	return false
end

function GetTorsoTable(e,num)

	if not HasTorsoTable(e,num) then 
		return {} 
	end
	
	return TorsoTable[e:GetRagdollEntity():GetModel()][num] or {}
	
end

local function BuildNewBonePositions(self)

		if not Bones[self.DType] then return end

		local keys = {}
		if Bones[self.DType].Combined then
			for _,n in pairs(Bones[self.DType].Combined) do
				table.insert(keys,n)
			end
		end
		table.insert(keys,self.DType)
		
		for meh,key in pairs(keys) do
			for _, bonetoscale in pairs(Bones[key].BScale) do
				local mdl = string.lower(self:GetModel())
				if ZombiesBones[mdl] and ZombiesBones[mdl][bonetoscale] then
					bonetoscale = ZombiesBones[mdl][bonetoscale]
				end
				local Bone = self:LookupBone(bonetoscale)
					if Bone then
						self:ManipulateBoneScale(Bone,Vector(0.0001, 0.0001, 0.0001))
						-- local mMatrix = self:GetBoneMatrix(Bone)
						-- if mMatrix then
						-- 	mMatrix:Scale(Vector(0.0001, 0.0001, 0.0001))
						-- 	self:SetBoneMatrix(Bone, mMatrix)
						-- end
					end
			end
		end
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
if not particle.HitAlready then
		particle.HitAlready = true
	if math.random(1, 10) == 3 then
		sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
	end
		local rand = math.random(1,3)
		if rand == 1 then
			util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		elseif rand == 2 then
			util.Decal("Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal("YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
		end
	particle:SetDieTime(0)
end	
end

function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
	local pos = hitpos + hitnormal

	if math.random(1, 10) == 3 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 50, math.random(95, 105))
	end
	
	if hitnormal.z < -0.5 then
		local effectdata = EffectData()
			effectdata:SetOrigin( hitpos )
			effectdata:SetNormal( hitnormal )
		util.Effect( "bloodsplash", effectdata )
	else
		util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
	end

	particle:SetDieTime(0)
	end
end

local function CollideCallbackSimple(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
	local pos = hitpos + hitnormal

	if math.random(1, 10) == 3 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 50, math.random(95, 105))
	end
	-- sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 60, math.random(95, 105))
	util.Decal("Blood", hitpos + hitnormal, hitpos - hitnormal)
	
	particle:SetDieTime(0)
	end
end

function EFFECT:Think()
if not IsValid(self.ent) then return end
	if self.ent:IsPlayer() then
	local Rag = self.ent:GetRagdollEntity()
		if Rag and IsValid(Rag) then
			self.Ragdoll = Rag
			self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
			self.Entity:SetPos(self.Ragdoll:GetPos())
		end
		if Rag and IsValid(Rag) then
			self.Ragdoll = Rag
			Rag.DType = self.BoneType or 0 -- store integer for scaling in ragdoll instead of effect
			--Rag.Emitter = ParticleEmitter(Rag:GetPos()) -- update position for our particle emitters
			--Rag.BuildBonePositions = BuildNewBonePositions -- add modified info about bones			
				if not self.Hit then
					self.Hit = true
					self.RDieTime = CurTime() + math.Rand(5, 7)
				end
		else
			if self.Torso and IsValid(self.Torso) then
				SafeRemoveEntity(self.Torso)
			end
		end
	end
	
	return CurTime() <= self.DieTime
end

function EFFECT:Render()
	
	local rendRag = self.ent:GetRagdollEntity()
	local fCurTime = CurTime()
	self.NextBDrip = self.NextBDrip or 0
	if rendRag and IsValid(rendRag) then
	
	rendRag.DType = self.BoneType or 0
	
	BuildNewBonePositions(rendRag)
	
	if self.Torso and IsValid(self.Torso) then
	
		rendRag:SetColor(Color(0,0,0,1))
		self.Torso:SetParent(rendRag)
		
	end
	
		if self.NextBDrip <= fCurTime then
		self.NextBDrip = fCurTime + 0.045
			local emitter = ParticleEmitter(rendRag:GetPos())
			
			local bone = Bones[self.BoneType].BScale[1] or "ValveBiped.Bip01_Head1"
			
			if Bones[self.BoneType].Combined then
				bone = Bones[table.Random(Bones[self.BoneType].Combined)].BScale[1] or "ValveBiped.Bip01_Head1"
			end
			
			
			local mdl = string.lower(rendRag:GetModel())
			
			if HasTorsoTable(self.ent,self.BoneType) then
				mdl = GetTorsoTable(self.ent,self.BoneType).Model
			end
			
			if ZombiesBones[mdl] and ZombiesBones[mdl][bone] then
				bone = ZombiesBones[mdl][bone]
			end
			
			if HasTorsoTable(self.ent,self.BoneType) then
				if GetTorsoTable(self.ent,self.BoneType).BleedBone then
					bone = GetTorsoTable(self.ent,self.BoneType).BleedBone
				end
			end
			
			local iBone = rendRag:LookupBone(bone)
			
			if HasTorsoTable(self.ent,self.BoneType) then
				if self.Torso and IsValid(self.Torso) then
					iBone = self.Torso:LookupBone(bone)
				end
			end
			
				if iBone then
					local delta = math.max(0, self.RDieTime - fCurTime)
						if 0 < delta then
							local vBonePos, aBoneAng = rendRag:GetBonePosition(iBone)
							if vBonePos and aBoneAng then
								emitter:SetPos(vBonePos)
								
								local vForward = aBoneAng:Forward()
								if ZombiesBones[mdl] and ZombiesBones[mdl].ReverseBleedBone then
									vForward = vForward * -1
								end
								
								for i=1, math.random(0, 3) do
									local particle = emitter:Add("decals/blood_spray"..math.random(1,8), vBonePos)
									local force = math.min(1.5, delta) * math.Rand(175, 400)
									
									particle:SetVelocity(force * vForward + 0.35 * force * VectorRand())
									particle:SetDieTime(math.Rand(2.25, 3))
									particle:SetStartAlpha(240)
									particle:SetEndAlpha(0)
									particle:SetStartSize(math.random(1, 8))
									particle:SetEndSize(0)
									particle:SetRoll(math.Rand(0, 360))
									particle:SetRollDelta(math.Rand(-40, 40))
									particle:SetColor(255, 0, 0)
									particle:SetAirResistance(5)
									particle:SetBounce(0)
									particle:SetGravity(Vector(0, 0, -600))
									particle:SetCollide(true)
									particle:SetCollideCallback(CollideCallbackSmall)
									particle:SetLighting(true)
								end
								
								local particle = emitter:Add("decals/blood_spray"..math.random(1,8), vBonePos)
								local vel = rendRag:GetVelocity()
								particle:SetVelocity(vel)
								particle:SetDieTime(math.Rand(0.5, 0.75))
								particle:SetStartAlpha(240)
								particle:SetEndAlpha(0)
								particle:SetStartSize(math.random(6, 12))
								particle:SetEndSize(0)
								particle:SetRoll(math.Rand(0, 360))
								local vellength = vel:Length() * 0.45
								particle:SetRollDelta(math.Rand(-vellength, vellength))
								particle:SetColor(255, 0, 0)
								particle:SetAirResistance(20)
								particle:SetLighting(true)
								
								
							end
						end
					end
		end
	end
	
end
