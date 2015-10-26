AddCSLuaFile()
--Made by Duby :P
if CLIENT then
	SWEP.PrintName = "Ghoul"
	SWEP.ViewModelFOV = 80


	--SWEP.FakeArms = true

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
	
	--[[
	SWEP.WElements = {
	
			--["bone1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-10, 6.98, 0), angle = Angle(80.311, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			
			["suit2.3"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.363, -6, 0.455), angle = Angle(5.113, 97.158, 82.841), size = Vector(0.435, 0.435, 0.435), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		--	["suit2.1"] = { type = "Model", model = "models/props_combine/combine_intmonitor003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.274, 5.364, -2.274), angle = Angle(9.204, -105.342, 91.023), size = Vector(0.209, 0.209, 0.209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2.1"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.274, 5.364, -2.274), angle = Angle(9.204, -105.342, 91.023), size = Vector(0.0209, 0.0209, 0.0209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, 5.455, 1.363), angle = Angle(0, 80.794, 82.841), size = Vector(0.72, 0.72, 0.72), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2.2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, 5.456, -4.092), angle = Angle(1.023, 80.794, 86.931), size = Vector(0.264, 0.264, 0.264), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["9"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-3.636, 1.557, -4.676), angle = Angle(0, -99.351, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["8"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-6.753, -10.91, -2.597), angle = Angle(0, 0, 0), size = Vector(0.031, 0.031, 0.031), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		}
	]]--
end


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.FakeArms = true

SWEP.Primary.Duration = 1.4
SWEP.Primary.Delay = 0.6
SWEP.Primary.Damage = 15
SWEP.Primary.Reach = 48
		SWEP.ShowViewModel = false
SWEP.SwapAnims = false
SWEP.Secondary.Duration = 2.3
SWEP.Secondary.Delay = 0.6

function SWEP:Move()
end

function SWEP:Think()
	self.BaseClass.Think(self)	
	
	if not IsValid(self.Owner) then
		return
	end
	

	if self.Owner:KeyReleased( IN_RELOAD  ) then
		if SERVER then
			local vecAim = self.Owner:GetAimVector()
			local posShoot = self.Owner:GetShootPos()
		
			local tr = util.TraceLine({start = posShoot, endpos = posShoot+300*vecAim, filter = self.Owner})
		
			local canPlaceCrate = false

			--Check if we really need to draw the crate
			if tr.HitPos and tr.HitWorld and tr.HitPos:Distance(self.Owner:GetPos()) <= 110 then
				--Check traceline position area
				local hTrace = util.TraceHull({start = tr.HitPos, endpos = tr.HitPos, mins = Vector(-28,-28,0), maxs = Vector(28,28,25)})

				if hTrace.Entity == NULL then
					canPlaceCrate = true
				end
			end

			if canPlaceCrate then
				--Check distance to Supply Crates
				for _, Ent in pairs(ents.FindByClass("game_spawner")) do
					if tr.HitPos:Distance(Ent:GetPos()) <= 300 then
						self.Owner:Message("Too close to another blood spawner.", 2)
						canPlaceCrate = false
						break
					end
				end
			end

			if self.Owner.HasBloodSpawner and canPlaceCrate then
				for _, Ent in pairs(ents.FindByClass("game_spawner")) do
					if Ent:GetPlacer():Name() == self.Owner:Name() then
						Ent:Explode()				
						break
					end
				end			
			end
						
			--Exit when cannot place
			if not canPlaceCrate then
				return
			end

			--Display animation
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			self.Owner.HasBloodSpawner = true
			self.Owner:EmitSound("npc/fast_zombie/leap1.wav", 100, math.Rand(70, 80))
			self.Owner:Kill()
			
			for k,v in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
				v:Message("A blood spawner has been created.", 2)
			end
			
			
			--Create entity
			local angles = vecAim:Angle()
			local ent = ents.Create("game_spawner")
			if (ent ~= nil and ent:IsValid()) then
				ent:SetPos(tr.HitPos)
				ent:SetAngles(Angle(0,angles.y,angles.r))
				ent:SetPlacer(self.Owner)
				ent:Spawn()
				ent:Activate()
				self.Owner.Crate = ent

			end
		end
	end	
end


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
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]),70,math.Rand(85, 90))
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

function SWEP:StartSecondaryAttack()
	local pl = self.Owner
		
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)		
		
	--Swap Anims
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims	
		
	pl:Daze(1.5);	
		
	if SERVER then
		pl:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
	end
end


function SWEP:PerformSecondaryAttack()
	local pl = self.Owner
	
	if CLIENT then
		return
	end
	
	local shootpos = pl:GetShootPos()
	local startpos = pl:GetPos()
	startpos.z = shootpos.z - 5
	local aimvec = pl:GetAimVector()
	aimvec.z = math.max(aimvec.z, -0.7)
	
	
	for i=1, 4 do
		local ent = ents.Create("projectile_poisonpuke")
		if ent:IsValid() then
			local heading = (aimvec + VectorRand() * 0.2):GetNormal()
			ent:SetPos(startpos + heading * 8)
			ent:SetOwner(pl)
			ent:Spawn()
			ent.TeamID = pl:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				--phys:SetVelocityInstantaneous(heading * math.Rand(310, 560))
				phys:SetVelocityInstantaneous(heading * math.Rand(380, 400))
			end
			ent:SetPhysicsAttacker(pl)
		end
	end

	pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))

	--pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end

function SWEP:Initialize()

	if CLIENT then
		self:MakeArms()
	end
	self.BaseClass.Initialize(self)

	--Attack sounds
	for i = 20, 37 do
		table.insert(self.AttackSounds,Sound("mrgreen/undead/infected/rage_at_victim"..i..".mp3"))
	end

	--Idle sounds
	for i = 1, 31 do
		table.insert(self.IdleSounds,Sound("mrgreen/undead/infected/idle"..i..".mp3"))
	end
end