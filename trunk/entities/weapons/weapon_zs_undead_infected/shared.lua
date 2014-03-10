AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Infected"
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		-- ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-10.202, 19.533, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, -7.493, -45.569) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(5.802, 1.06, 0.335), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(52.678, 0, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(45.873, -0.348, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-59.774, -9.223, 18.572) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(10.701, -7.301, 42.666) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 9.659, 6.218) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-6.42, 28.499, 7.317) }
	}
end

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Duration = 1.75
SWEP.Primary.Delay = 0.74
SWEP.Primary.Damage = 25
SWEP.Primary.Reach = 50

SWEP.SwapAnims = false

function SWEP:StartPrimaryAttack()			
	--Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	--Set the thirdperson animation and emit zombie attack sound
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)
  
	--Emit sound
	if SERVER and #self.AttackSounds > 0 then
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]))
	end
end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombiegreen/hit_punch_0".. math.random(1, 8) ..".wav"))
	else
		self.Owner:EmitSound(Sound("npc/zombiegreen/claw_miss_"..math.random(1, 2)..".wav"))
	end
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT then
		self:RemoveArms()
	end
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	--Attack sounds
	for i = 20, 37 do
		table.insert(self.AttackSounds,Sound("npc/zombiegreen/rage_at_victim"..i..".wav"))
	end

	--Idle sounds
	for i = 1, 31 do
		table.insert(self.IdleSounds,Sound("mrgreen/undead/infected/idle"..i..".mp3"))
	end

	if CLIENT then
		self:MakeArms()
	end
end

if CLIENT then
	function SWEP:ViewModelDrawn()
		self.BaseClass.ViewModelDrawn(self)

		local vm = self.Owner:GetViewModel()
		if IsValid(self.Arms) and IsValid(vm) then			
			if self.Arms:GetModel() ~= self.Owner:GetModel() then
				self.Arms:SetModel(self.Owner:GetModel())
			end
			
			if not self.Arms.GetPlayerColor then
				self.Arms.GetPlayerColor = function()
					return Vector( GetConVarString( "cl_playercolor" ) )
				end
			end

		
			render.SetBlend(1) 
				self.Arms:SetParent(vm)
				
				self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
				
				for b, tbl in pairs(PlayerModelBones) do
					if tbl.ScaleDown then
						local bone = self.Arms:LookupBone(b)
						if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
							self.Arms:ManipulateBoneScale(bone, Vector(0.00001, 0.00001, 0.00001))
						end
					else
						if not tbl.Arm then
							local bone = self.Arms:LookupBone(b)
							if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
								self.Arms:ManipulateBoneScale(bone, Vector(1.5, 1.5, 1.5))
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
	end

	function SWEP:MakeArms()
		self.Arms = ClientsideModel("models/player/group01/male_04.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE) 
		
		if (ValidEntity(self.Arms)) and (ValidEntity(self)) then 
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
		if (ValidEntity(self.Arms)) then
			self.Arms:Remove()
		end
			self.Arms = nil
	end
end