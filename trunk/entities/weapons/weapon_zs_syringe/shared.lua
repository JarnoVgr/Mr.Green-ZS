-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Old, see weapon_zs_medkit

if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.PrintName = "syringe"
end

if( CLIENT ) then
	SWEP.PrintName = "Medkit"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = true
	
	killicon.AddFont( "weapon_zs_syringe", "CSKillIcons", "F", Color(255, 80, 0, 255 ) )
	
	function SWEP:DrawHUD()
		-- MeleeWeaponDrawHUD()
	end
end

SWEP.Author			= "Deluvas"
SWEP.Instructions	= "Left click to heal others. Right click for self." 
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Info = "Left click to heal someone.\nRight click to heal yourself (stand still)."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel      = Model ( "models/weapons/v_healthkit.mdl" )
SWEP.WorldModel   = Model ( "models/weapons/w_package.mdl" )

SWEP.Primary.Delay			= 0.9 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 7	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50	
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"	

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= 50
SWEP.Secondary.DefaultClip	= 50
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

SWEP.NextHeal = 0
SWEP.WalkSpeed = 185

local ShootSound = Sound ("items/smallmedkit1.wav")
local FailSound = Sound ("items/medshotno1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType ( "physgun" )
end 

-- Call this function to update weapon slot and others
function SWEP:Equip ( NewOwner )
	if SERVER then
		gamemode.Call ( "OnWeaponEquip", NewOwner, self )
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	self.Owner:StopAllLuaAnimations()
	
	
	if SERVER then
	self.Owner.HealedForSP = self.Owner.HealedForSP or 0
		GAMEMODE:WeaponDeployed(self.Owner, self)
		return true
	end
end


SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.TimeNextThink = 0
SWEP.EmptyTableTimer = 5
function SWEP:Think()
	if not self.Owner or not self.Owner:Alive() or not self.Owner:IsPlayer() then return end
	local ply = self.Owner
	
	if self.TimeNextThink <= CurTime() then
		if SERVER then
			GAMEMODE:WeaponDeployed (self.Owner,self.Weapon)
		end
		self.TimeNextThink = CurTime() + 3
	end
	
	if self.EmptyTableTimer <= CurTime() then
		if SERVER then
			table.Empty (self.injured)
			table.Empty (self.infected)
			self.EmptyTableTimer = CurTime() + 45
		end
	end
		
	if SERVER then
		if (ply:KeyDown(IN_ATTACK) and self:CanPrimaryAttack()) or (ply:KeyDown(IN_ATTACK2) and self:CanSecondaryAttack()) then	
			self.fired = true
			self.lastfire = CurTime()
		else
			if self.lastfire < CurTime() - 0.3 and self.rechargetimer < CurTime() then
				self.Weapon:SetClip1( math.min( 50,self.Weapon:Clip1() + 1 ) )
				self.rechargetimer = CurTime() + 0.6
			end
			if self.fired then 
				self.fired = false
			end
		end
	end
	
	self:NextThink ( CurTime() + 0.02 )
	return true
end


function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then 
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self.Weapon:Clip1() <= 0 or self.Owner:GetVelocity():Length() > 0 or (self.Weapon:Clip1() <= 0 and self.Owner:GetVelocity():Length() > 0) then --Medic should not heal while moving
		self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		return false
	end
	return true
end


SWEP.SoundTimer = 0
SWEP.FailTimer = 0
SWEP.injured = {}
SWEP.infected = {}
	function SWEP:PrimaryAttack()
		if not self:CanPrimaryAttack() then return end
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 80 then

			local ent = self.Owner:GetEyeTrace().Entity
			
			if SERVER then
				if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then
					local current = ent:Health()
					local max = ent:GetMaxHealth()
					local healhp = 1 
					if current < max then
						self:TakePrimaryAmmo (1)
						
						-- Healing Nitwit
						self.Owner.HealingDone = self.Owner.HealingDone + 1
						self.Owner.HealedForSP = self.Owner.HealedForSP + 1
						
						if self.Owner.HealedForSP == 40 then
							skillpoints.AddSkillPoints(self.Owner,10)
							ent:FloatingTextEffect( 10, self.Owner )
							self.Owner.HealedForSP = 0
						end
						
						-- Medic healing achievments
						if self.Owner:GetHumanClass() == 1 then
							if self.Owner:GetTableScore("medic","level") == 0 and self.Owner:GetTableScore("medic","achlevel0_1") < 10000 then
								self.Owner:AddTableScore("medic","achlevel0_1",1)
							elseif self.Owner:GetTableScore("medic","level") == 1 and self.Owner:GetTableScore("medic","achlevel0_1") < 20000 then
								self.Owner:AddTableScore("medic","achlevel0_1",1)
							end
							healhp = 1 + (1 * ((HumanClasses[1].Coef[2]*(self.Owner:GetTableScore ("medic","level")+1)) / 100))
							
							self.Owner:CheckLevelUp()
						end
						
						log.PlayerOnPlayerAction( self.Owner, ent, "heal_other", {["amount"] = healhp})
						
						ent:SetHealth(math.min(max, ent:Health() + healhp))
						if self.SoundTimer <= CurTime() then
							self.Owner:EmitSound( ShootSound, 60, 100 )
							self.SoundTimer = CurTime() + 1
						end
						
						-- Medic injured achievments stuff
						if current < 35 and not table.HasValue (self.injured, ent:Name()) then
							table.insert (self.injured, ent:Name())
							if self.Owner:GetHumanClass() == 1 then
								if self.Owner:GetTableScore("medic","level") == 2 and self.Owner:GetTableScore("medic","achlevel2_1") < 500 then
									self.Owner:AddTableScore("medic","achlevel2_1",1)
								elseif self.Owner:GetTableScore("medic","level") == 3 and self.Owner:GetTableScore("medic","achlevel2_1") < 1000 then
									self.Owner:AddTableScore("medic","achlevel2_1",1)
								end
								
								self.Owner:CheckLevelUp()
							end
						end
						-- If player is infected
						if ent.IsInfected and not table.HasValue (self.infected, ent:Name()) then
							table.insert (self.infected, ent:Name())
							if self.Owner:GetHumanClass() == 1 then
								if self.Owner:GetTableScore("medic","level") == 4 and self.Owner:GetTableScore("medic","achlevel4_1") < 400 then
									self.Owner:AddTableScore("medic","achlevel4_1",1)
								elseif self.Owner:GetTableScore("medic","level") == 5 and self.Owner:GetTableScore("medic","achlevel4_1") < 900 then
									self.Owner:AddTableScore("medic","achlevel4_1",1)
								end
								
								self.Owner:CheckLevelUp()
							end
						end
						
					else
						if self.FailTimer <= CurTime() then
							self.Owner:EmitSound(FailSound, 60, 100)
							self.FailTimer = CurTime() + 1
						end
					end
				end 
			end
		else
			if SERVER then
				if self.FailTimer <= CurTime() then
					self.Owner:EmitSound(FailSound, 60, 100)
					self.FailTimer = CurTime() + 1
				end
			end
		end

	end

	function SWEP:SecondaryAttack()
		if not self:CanSecondaryAttack() then return end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
		local ent = self.Owner
		
		if SERVER then
			if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then
					local current = ent:Health()
					local max = ent:GetMaxHealth()
					if current < max then
						--if ent:GetHumanClass() == 1 then
							--if ent:GetTableScore("medic","level") == 0 and ent:GetTableScore("medic","achlevel0_1") < 10000 then
								--ent:AddTableScore("medic","achlevel0_1",1)
							--elseif ent:GetTableScore("medic","level") == 1 and ent:GetTableScore("medic","achlevel0_1") < 20000 then
								--ent:AddTableScore("medic","achlevel0_1",1)
							--end
							
							--ent:CheckLevelUp()
						--end
						self:TakePrimaryAmmo (1)
						
						log.PlayerAction( self.Owner, "heal_self", {["amount"] = 1})
						ent:SetHealth(math.min(max, ent:Health() + 1))
						
						if self.SoundTimer <= CurTime() then
							self.Owner:EmitSound( ShootSound, 60, 100 )
							self.SoundTimer = CurTime() + 1
						end
					else
						if self.FailTimer <= CurTime() then
							self.Owner:EmitSound(FailSound, 60, 100)
							self.FailTimer = CurTime() + 1
						end
					end
			end
		end
	end


if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "F", "Signs", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleText( "F", "Signs", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText( "F", "Signs", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
	
	function SWEP:ViewModelDrawn()
	local vm = self.Owner:GetViewModel()
    if not ValidEntity(vm) then return end
	pos,ang = vm:GetBonePosition(vm:LookupBone("breathe"))
	local pname, phealth
	pname = ""
	phealth = ""
	local eyeang = self.Owner:EyeAngles()

	
	
	pos = pos + ang:Right()*(-9) + ang:Forward()*3 + ang:Up() * 7
	ang = vm:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
    --ang:RotateAroundAxis(ang:Up(), 90)
	
	
	local trace = self.Owner:GetEyeTrace()
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 80 then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_HUMAN then
		pname = ent:Name()
		phealth = "Hp: "..ent:Health()..""
		end
	else
		pname = ""
		phealth = ""
	end
	cam.Start3D2D(pos,ang,0.045)
	draw.SimpleText(""..pname.."", "TARGETHP", 0, 0, Color (255,255,255,255), TEXT_ALIGN_CENTER)
	draw.SimpleText(""..phealth.."", "TARGETHP", 0, 19, Color (255,255,255,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
	end
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			table.Empty (self.injured)
			table.Empty (self.infected)
			self:Remove()
		end
	end
end
