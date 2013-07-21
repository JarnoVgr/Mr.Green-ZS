AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "NECROSSIN"
ENT.Purpose			= ""
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")

local player = player
local pairs = pairs

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Placer" );
end

util.PrecacheModel("models/Items/item_item_crate.mdl")
function ENT:Initialize()
	if SERVER then	
		self.Entity:SetModel("models/Items/item_item_crate.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion( false ) 
		end
	
		self.CrateHealth = 300
	end
	--self.CrateOwner = self:GetDTEntity(0)
	--self.CrateOwner = self:GetPlacer()
	self.AmmoDelay = 150
end	

function ENT:Think()
	local ct = CurTime()
	
	local humans = player.GetAll()
	--if SERVER then self:CheckOwner() end
	
	--Loop though all players
	for _, pl in ipairs(humans) do
		-- check if player got ammo
		if pl.GotSupplies == nil then -- whatever
			pl.GotSupplies = false
			pl.SupplyTime = ct + self.AmmoDelay -- make a timer for him
			pl.SupplyTimerActive = true
		end

		if pl.SupplyTimerActive == true then
			if pl.SupplyTime <= ct then
				pl.SupplyTimerActive = false
				pl.GotSupplies = false
			end
		end		
	end

	self:NextThink(ct+1)
	return true
end

if SERVER then
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsZombie() then
			self.CrateHealth = self.CrateHealth - dmginfo:GetDamage()
		
			if self.CrateHealth <=0 then
				self:Explode()
			end
		end
	end

	function ENT:CheckOwner()
		local Owner = self:GetPlacer()
		if not ValidEntity(Owner) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
			self:Explode()
		end
	end

	function ENT:Explode()
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,5)
		trace.filter = self.Entity
		trace.endpos = trace.start - Vector(0,0,50)
		local traceground = util.TraceLine(trace)
		
		util.Decal("Scorch",traceground.HitPos - traceground.HitNormal,traceground.HitPos + traceground.HitNormal)

		local Effect = EffectData()
		Effect:SetOrigin( self:GetPos() )
		Effect:SetStart( self:GetPos() )
		Effect:SetMagnitude( 300 )
		util.Effect("Explosion", Effect)

		self.Entity:Remove()

	end


	function ENT:Use(activator, caller)
		if not IsValid(activator) then return end
		
		if activator:IsPlayer() and activator:IsHuman() then
		
			activator.NextPop = activator.NextPop or 0
			
			if activator.NextPop > CurTime() then return end
			activator.NextPop = CurTime() + 1.5
			
			if activator.SupplyTimerActive == false then
				if activator.GotSupplies == false then
					activator.GotSupplies = true
					activator.SupplyTimerActive = true	
					activator:SendLua("MySelf.SupplyTimerActive = true")
					activator:SendLua("MySelf.GotSupplies = true")
					activator.SupplyTime = CurTime() + self.AmmoDelay
					activator:SendLua("MySelf.SupplyTime = CurTime() + "..self.AmmoDelay.."")
					
						local Automatic, Pistol = activator:GetAutomatic(), activator:GetPistol()
		
						if Automatic or Pistol then
						
							local WeaponToFill = activator:GetActiveWeapon()
							
							local AmmoType 
							
							if IsValid(WeaponToFill) and (GetWeaponCategory ( WeaponToFill:GetClass() ) == "Pistol" or GetWeaponCategory ( WeaponToFill:GetClass() ) == "Automatic") then
								AmmoType = WeaponToFill:GetPrimaryAmmoTypeString() or "pistol"
							else
								AmmoType = "pistol"
							end
								
							-- How much ammo to give
							local HowMuch = GAMEMODE.AmmoRegeneration[AmmoType] or 50
									
							-- 50% more ammunition at half-life and double for un-life
							if INFLICTION >= 0.7 then
								HowMuch = HowMuch * 1
							end
									
							-- Multiplier -- 30% less
							HowMuch = math.Round(HowMuch * 0.62)
							
							activator:GiveAmmo(HowMuch, AmmoType)
							
							local Owner = self:GetPlacer()
							if activator ~= Owner and (ValidEntity(Owner) and Owner:Alive() and Owner:Team() == TEAM_HUMAN) then
								skillpoints.AddSkillPoints(Owner,3)
								self:FloatingTextEffect( 3, Owner)
								Owner:AddXP(3)
							end
						
						-- activator:EmitSound("items/ammo_pickup.wav")
						end
				end
			elseif activator.SupplyTimerActive == true then
				activator:Message("You can't get ammo until crate will recharge it!",1,"white")
			end
		end
	end
end
	
if CLIENT then
	local cam = cam
	local render = render
	local draw = draw

	local matOutlineWhite = Material( "white_outline" )
	-- function ENT:Draw()
	-- 	self:DrawModel()
	-- end
	
	function ENT:Draw()
		if not ValidEntity(MySelf) then
			return
		end
		
		if MySelf:Team() ~= TEAM_HUMAN then
			self:DrawModel()
			return
		end
		
		local outline = false
		
		cam.Start3D ( EyePos(), EyeAngles() )
		
		render.ClearStencil()
		render.SetStencilEnable( true )
		
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilReferenceValue( 1 )
		
		outline = true
		
		render.SetStencilReferenceValue( 2 )
			
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		
		render.SetStencilEnable( false )
		cam.End3D()
		
		-- Choose the color
		local LineColor = Color ( 210, 0,0, 255 )
		if MySelf.SupplyTimerActive == false then
			LineColor = Color ( 0, math.abs ( 200 * math.sin ( CurTime() * 3 ) ),0, 255 )
		end
		
		-- Supress light for the parent
		render.SuppressEngineLighting( true )
		-- render.SetAmbientLight( 1, 1, 1 )
		render.SetColorModulation( 1, 1, 1 )
			   
		--  First Outline       
		self:SetModelScale( self:GetModelScale() * 1.03,0 )
		render.ModelMaterialOverride( matOutlineWhite )
		render.SetColorModulation( LineColor.r / 255, LineColor.g / 255, LineColor.b / 255 )
		if outline then
			cam.IgnoreZ(true)
		end
		self:DrawModel()
		if outline then
			cam.IgnoreZ(false)
		end
					   
		--Revert everything back to how it should be
		render.ModelMaterialOverride( nil )
		self:SetModelScale( 1,0 )
					   
		render.SuppressEngineLighting( false )

		render.SetColorModulation( 1, 1, 1 )
		
		self:DrawModel()
		
		
		--Draw some stuff
		
		local pos = self:GetPos() + Vector(0,0,45)

		--Check for distance with local player
	    if pos:Distance(MySelf:GetPos()) > 500 then
	        return
    	end
			
		local angle = (MySelf:GetPos() - pos):Angle()
		angle.p = 0
		angle.y = angle.y + 90
		angle.r = angle.r + 90

		cam.Start3D2D(pos,angle,0.26)

			local Owner = self:GetPlacer()
			if ValidEntity(Owner) and Owner:Alive() and Owner:Team() == TEAM_HUMAN then
				draw.SimpleTextOutlined( Owner:Name() .."'s Mobile Supplies", "ArialBoldSeven", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			else
				draw.SimpleTextOutlined( "Mobile Supplies", "ArialBoldSeven", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			end
			
			if MySelf.SupplyTimerActive == true then
				local time = math.Round(MySelf.SupplyTime - CurTime())
				draw.SimpleTextOutlined("0"..ToMinutesSeconds(time + 1), "ArialBoldFive", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			elseif MySelf.SupplyTimerActive == false then
				draw.SimpleTextOutlined("Press E to use", "ArialBoldFive", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				draw.SimpleTextOutlined("(Refill ammo for equipped gun)", "ArialBoldFour", 0, 40, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			end
				
		cam.End3D2D()

		
	end
end
