-- I hate derma :<. Every panel is like pain in the ass for me :/
function MakeWeps()
	if not MySelf then return end
	if pWeps then
		pWeps:Remove()
		pWeps = nil
	end

	local Window = vgui.Create("DFrame")
	local tall = h * 0.95
	Window:SetSize(640, tall)
	local wide = (w - 640) * 0.5
	local tall = (h - tall) * 0.5
	Window:SetPos(wide, tall)
	Window:SetTitle(" ")
	Window:SetSkin("ZSMG")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:MakePopup()
	Window:SetDeleteOnClose(false)
	Window:SetCursor("pointer")
	pWeps = Window
	
	local iClass = MySelf:GetHumanClass() or 1
	
	local label = vgui.Create("DLabel", Window)
	label:SetTextColor(COLOR_LIMEGREEN)
	label:SetFont("HUDFontSmallAA")
	label:SetText("Arsenal Upgrades Tree for class: "..HumanClasses[iClass].Name.."")
	label:SetPos(16, 22)
	surface.SetFont("HUDFontSmallAA")
	local texw, texh = surface.GetTextSize("Arsenal Upgrades Tree for class: "..HumanClasses[iClass].Name.."")
	label:SetSize(texw, texh)
	

	local tblRewards = RewardsTable[iClass]
	
	local ypos = 90
	
	local frags = MySelf:GetScore()
	
	for i=1,table.maxn(tblRewards) do -- Find the amount of kills that we need to get rewards
	local tab = tblRewards[i]
		if tab then
		
		local xpos = 50
		
			surface.SetFont("HUDFontSmallAA")
			local tw, th = surface.GetTextSize(i.." SP")
			local kills = vgui.Create("DLabel", Window)
			kills:SetFont("HUDFontSmallAA")
			kills:SetText(i.." SP")
			kills:SetSize(tw, th)
			kills:SetPos(xpos, th+ypos-13)
			
				if frags < i then
					kills:SetTextColor(COLOR_RED)
				else
					kills:SetTextColor(COLOR_LIMEGREEN)
				end
				xpos = xpos + 130
				
			for index,weapon in pairs(tab) do --  if there are multiple weapons then make more icons
			
				local wep = weapons.Get(weapon)
				
				local text = ""
				local wepname = wep.PrintName or "Invalid"
				text = text.."Name: "..wepname.."\n"
				local damage
				if wep.TotalDamage then
					damage = wep.TotalDamage or "Can't calculate damage yet"
				else
					if wep.Primary.Damage and wep.Primary.NumShots then
						damage = (wep.Primary.Damage * wep.Primary.NumShots) or "Can't calculate damage yet"
					else
					damage = "Can't calculate damage yet"
					end
				end
				text = text.."Damage: "..damage..""
				
				local icon = vgui.Create("SpawnIcon", Window)
				icon:SetSize(64, 64)
				icon:SetPos(xpos-32, ypos)
				icon:SetModel(wep.WorldModel or "models/error.mdl")
				icon:SetToolTip(text) -- Add info about selected weapon
				
				xpos = xpos + 80 -- Slide to the right
				
			end
			
			ypos = ypos + 120 -- Make a new row
		end
	end
end



