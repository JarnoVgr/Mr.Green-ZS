include("shared.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = true
SWEP.BobScale = 2
SWEP.SwayScale = 1.5
SWEP.Slot = 0
SWEP.ShowViewModel = true

SWEP.IronsightsMultiplier = 0.6


function SWEP:TranslateFOV(fov)
	return GAMEMODE.FOVLerp * fov
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then
		return GAMEMODE.FOVLerp
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:GetIronsightsDeltaMultiplier()
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
end

local ghostlerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	local bIron = self:GetIronsights()

	if bIron ~= self.bLastIron then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

		if bIron then 
			self.SwayScale = 0.3
			self.BobScale = 0.1
		else 
			self.SwayScale = 2.0
			self.BobScale = 1.5
		end
	end

	local Mul = math.Clamp((CurTime() - (self.fIronTime or 0)) * 4, 0, 1)
	if not bIron then Mul = 1 - Mul end

	if Mul > 0 then
		local Offset = self.IronSightsPos
		if self.IronSightsAng then
			ang = Angle(ang.p, ang.y, ang.r)
			ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
			ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
			ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
		end

		pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
	end

	if ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	return pos, ang
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
end

function SWEP:DrawHUD()
	self:DrawCrosshair()
end

local OverrideIronSights = {}
function SWEP:CheckCustomIronSights()
	local class = self:GetClass()
	if OverrideIronSights[class] then
		if type(OverrideIronSights[class]) == "table" then
			self.IronSightsPos = OverrideIronSights[class].Pos
			self.IronSightsAng = OverrideIronSights[class].Ang
		end

		return
	end

	local filename = "ironsights/"..class..".txt"
	if file.Exists(filename, "DATA") then
		local pos = Vector(0, 0, 0)
		local ang = Vector(0, 0, 0)

		local tab = string.Explode(" ", file.Read(filename, "DATA"))
		pos.x = tonumber(tab[1]) or 0
		pos.y = tonumber(tab[2]) or 0
		pos.z = tonumber(tab[3]) or 0
		ang.x = tonumber(tab[4]) or 0
		ang.y = tonumber(tab[5]) or 0
		ang.z = tonumber(tab[6]) or 0

		OverrideIronSights[class] = {Pos = pos, Ang = ang}

		self.IronSightsPos = pos
		self.IronSightsAng = ang
	else
		OverrideIronSights[class] = true
	end
end
		
SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		--Init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				
			end 
		end

		--Prefer SWEP
		self.ViewModelFOV = self.ViewModelFOV or GetConVarNumber("zs_wepfov")
		
		if not self.Owner or not self.Owner:IsValid() or not self.Owner:IsPlayer() then
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
						// when the weapon is dropped
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

local scope = surface.GetTextureID( "zombiesurvival/scope/sniper_scope" )
function SWEP:DrawScope()
	surface.SetDrawColor( 0, 0, 0, 255 )
				
     local x = ScrW() / 2.0
	 local y = ScrH() / 2.0
	 local scope_size = ScrH()

	 -- crosshair
	 local gap = 80
	 local length = scope_size
	 surface.DrawLine( x - length, y, x - gap, y )
	 surface.DrawLine( x + length, y, x + gap, y )
	 surface.DrawLine( x, y - length, x, y - gap )
	 surface.DrawLine( x, y + length, x, y + gap )

	 gap = 0
	 length = 50
	 surface.DrawLine( x - length, y, x - gap, y )
	 surface.DrawLine( x + length, y, x + gap, y )
	 surface.DrawLine( x, y - length, x, y - gap )
	 surface.DrawLine( x, y + length, x, y + gap )


	 -- cover edges
	 local sh = scope_size / 2
	 local w = (x - sh) + 2
	 surface.DrawRect(0, 0, w, scope_size)
	 surface.DrawRect(x + sh - 2, 0, w, scope_size)

	 surface.SetDrawColor(255, 0, 0, 255)
	 surface.DrawLine(x, y, x + 1, y + 1)

	 -- scope
	 surface.SetTexture(scope)
	 surface.SetDrawColor(1, 1, 1, 255)
	 surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

	local dist = 0
	
	local tr = MySelf:GetEyeTrace()
	
	if tr.Hit then
		dist = math.Round(MySelf:GetShootPos():Distance(tr.HitPos))
		draw.SimpleTextOutlined("Distance: "..dist, "ChatFont",ScrW()/2+100,ScrH()/2,Color(255,255,255,255),TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,0.1, Color(0,0,0,255))
	end	
end
