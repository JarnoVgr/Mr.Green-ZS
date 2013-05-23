if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.PrintName = "Torch"
end

SWEP.HoldType = "slam"

if ( CLIENT ) then
	SWEP.PrintName = "Torch"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.Slot = 3
	SWEP.SlotPos = 2 
	
	killicon.AddFont("weapon_zs_tools_torch", "CSKillIcons", "E", Color(255, 255, 255, 255 ))
	-- function SWEP:DrawHUD()
	-- 	MeleeWeaponDrawHUD()
	-- end
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false	
	
end




SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/Weapons/v_Grenade.mdl"
SWEP.WorldModel = "models/Weapons/w_grenade.mdl"

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.Primary.ClipSize = 60
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "CombineCannon"
SWEP.Secondary.Delay = 0.15

SWEP.IdleAngle = Angle(7.105, -8.9, 1.98)
SWEP.ActiveAngle = Angle(0.893, 9.805, -4.725)

SWEP.TempAng = SWEP.IdleAngle

SWEP.WalkSpeed = 200

function SWEP:InitializeClientsideModels()
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.694, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.382, 0, 0) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		--["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(2.118, 3.861, 7.106), angle = Angle(7.105, -8.9, 1.98) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.788, 9.413, 7.656) }
	}
	

	self.VElements = {
		["valve"] = { type = "Model", model = "models/props_pipes/valvewheel002.mdl", bone = "ValveBiped.Bip01", rel = "att", pos = Vector(-0.125, 0.187, -3.281), angle = Angle(-95.838, -159.644, 1.031), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["att"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01", rel = "body", pos = Vector(-0.125, -0.064, 1.406), angle = Angle(0, -67.95, -180), size = Vector(0.375, 0.375, 0.375), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.224, 2.581, -1.195), angle = Angle(3.413, -94.12, 180), size = Vector(0.331, 0.331, 0.28), color = Color(125, 125, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.WElements = {
		["valve"] = { type = "Model", model = "models/props_pipes/valvewheel002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "att", pos = Vector(-0.125, 0.187, -3.281), angle = Angle(-95.838, -159.644, 1.031), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["att"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body", pos = Vector(-0.125, -0.064, 1.406), angle = Angle(0, -67.95, -180), size = Vector(0.375, 0.375, 0.375), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.017, 2.075, -1.231), angle = Angle(-10.108, -98.139, -152.969), size = Vector(0.331, 0.331, 0.28), color = Color(125, 125, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:OnDeploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	if SERVER then
		self.Owner._TorchScore = self.Owner._TorchScore or 0
	end
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then 
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		return false
	end
	return true
end

--Precache sounds
for i=1,6 do
	util.PrecacheSound("ambient/energy/spark"..i..".wav")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end

	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.12)	

	if SERVER then
		local tr = self.Owner:TraceLine(54, MASK_SHOT, team.GetPlayers(TEAM_HUMAN))
	
		local trent = tr.Entity
		if not IsEntityValid ( trent ) then
			return
		end
	
		if tr.Hit and not tr.HitWorld then
			if trent.Nails and #trent.Nails > 0 then
				local griefedprop = false
				
				if trent._LastAttackerIsHuman then
					griefedprop = true
				end
				
				for i=1, #trent.Nails do
					local nail = trent.Nails[i]
					
					if nail and nail:IsValid() then
						if nail:GetNailHealth() < nail:GetDTInt(1) then -- nail:GetNWInt("MaxNailHealth")
							self:TakePrimaryAmmo (1)
							
							if not griefedprop then
								self.Owner._TorchScore = self.Owner._TorchScore + 1
								
								if self.Owner._TorchScore == 30 then
									skillpoints.AddSkillPoints(self.Owner, 10)
									nail:FloatingTextEffect( 10, self.Owner )
									self.Owner:AddXP(5)
									self.Owner._TorchScore = 0
								end
							end
							
							--nail.Heal = math.Clamp(nail.Heal+2,1,nail:GetDTInt(1))
							nail:SetNailHealth(math.Clamp(nail:GetNailHealth()+4,1,nail:GetDTInt(1)))
							
							local pos = tr.HitPos
							local norm = tr.HitNormal-- (tr.HitPos - self.Owner:GetShootPos()):Normalize():Angle()
							
							local eff = EffectData()
							eff:SetOrigin( pos )
							eff:SetNormal( norm )
							eff:SetScale( math.Rand(0.9,1.2) )
							eff:SetMagnitude( math.random(10,40) )
							util.Effect( "StunstickImpact", eff, true, true )
							
							self.Owner:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))
							
							util.Decal("FadingScorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
							
							-- BREAKER!
							break
						end
					end
				end
			end
			
			--turret
			if trent:GetClass() == "zs_turret" then
				if trent:GetDTInt(1) < trent.MaxHealth then
				
					self:TakePrimaryAmmo(1)
					
					self.Owner._TorchScore = self.Owner._TorchScore + 1
								
					if self.Owner._TorchScore == 30 then
						skillpoints.AddSkillPoints(self.Owner, 10)
						trent:FloatingTextEffect( 10, self.Owner )
						self.Owner:AddXP(5)
						self.Owner._TorchScore = 0
					end
				
					trent:SetDTInt(1,trent:GetDTInt(1)+1)
					
					local pos = tr.HitPos
					local norm = tr.HitNormal-- (tr.HitPos - self.Owner:GetShootPos()):Normalize():Angle()
							
					local eff = EffectData()
					eff:SetOrigin(pos)
					eff:SetNormal(norm)
					eff:SetScale(math.Rand(0.9,1.2))
					eff:SetMagnitude(math.random(10,40))
					util.Effect("StunstickImpact", eff, true, true)
							
					self.Owner:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))
							
					util.Decal("FadingScorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
				end
			end
			
			if trent:IsPlayer() and trent:IsZombie() and trent:Alive()then
				self:TakePrimaryAmmo(1)
				
				trent:TakeDamage(2,self.Owner,self)
				
				if math.random(3) == 3 then
					trent:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav")
				end
			end
		end
	end
	
end
	
 function SWEP:Reload() 
	return false
 end  

function SWEP:SecondaryAttack()
	return false
end 

-- make everything easy
local function ApproachAngle(ang,to,time)
	ang.p = math.Approach(ang.p, to.p, time)
	ang.y = math.Approach(ang.y, to.y, time)
	ang.r = math.Approach(ang.r, to.r, time)
end

SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
function SWEP:Think()
	self.AppTo = self.IdleAngle
		
	if self.Owner:KeyDown(IN_ATTACK) and self:CanPrimaryAttack() then
		self.AppTo = self.ActiveAngle
	end
	
	-- ApproachAngle(self.TempAng,self.AppTo,FrameTime()*33)
	
	if CLIENT then
	
		-- ApproachAngle(self.ViewModelBoneMods["ValveBiped.Bip01_R_Clavicle"].angle,self.AppTo,FrameTime()*33)
		
	end
	
	local maxclip = 60
	
	if self.Owner and self.Owner:GetSuit() == "supportsuit" then
		maxclip = 80
		rtime = rtime - 0.25
	end
	
	if SERVER then
		if self.Owner:KeyDown(IN_ATTACK) and self:CanPrimaryAttack() then	
			self.fired = true
			self.lastfire = CurTime()
		else
			if self.lastfire < CurTime() - 0.3 and self.rechargetimer < CurTime() then
				self.Weapon:SetClip1( math.min( maxclip,self.Weapon:Clip1() + 1 ) )
				local rtime = 0.15
				if self.Owner:GetPerk("_trchregen") then
					rtime = 0.10
				end
				self.rechargetimer = CurTime() + rtime
			end
			if self.fired then 
				self.fired = false
			end
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() then
			return
		end
		if ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
		surface.SetFont("ArialBoldTen")
	
		for _,nail in pairs (ents.FindByClass("nail")) do
			if nail and nail:IsValid() then
				if nail:GetPos():Distance(EyePos()) <= 105 then
					draw.SimpleTextOutlined("HP: "..math.Round((nail:GetDTInt(0)/nail:GetDTInt(1))*100).."%", "ArialBoldFive", nail:GetPos():ToScreen().x, nail:GetPos():ToScreen().y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				end
			end
		end
	end
end