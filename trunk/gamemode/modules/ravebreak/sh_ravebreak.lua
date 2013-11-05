AddCSLuaFile()

if CLIENT then
	--Ravebreak, admin only
	function RaveBreak(um)
		--Stop current sounds
		RunConsoleCommand("stopsound")

		--Delay sound to compensate lag
		timer.Simple(0.2, function()
			surface.PlaySound(RAVESOUND)
		end)
		
		--Start actual raving with a second delay
		timer.Simple(1,function()
			hook.Add("RenderScreenspaceEffects", "RaveDraw",RaveDraw)
		end)
	end
	usermessage.Hook("RaveBreak",RaveBreak)

	local lightCnt = 1
	local lastRaveUpdate = 0

	--Rave render
	function RaveDraw()
		local ang = MySelf:EyeAngles()
		ang.p = 30*math.sin((CurTime()%2*math.pi)*5)
		MySelf:SetEyeAngles( ang )
				
		if lastRaveUpdate < CurTime()-0.5 then
			lastRaveUpdate = CurTime()
			local last = lightCnt
			while (last == lightCnt) do
				lightCnt = math.random(1,#RaveColTab)
			end
		end

		DrawColorModify(RaveColTab[lightCnt])
	end

	--Rave end
	function RaveEnd(um)
		hook.Remove("RenderScreenspaceEffects", "RaveDraw")
	end
	usermessage.Hook("RaveEnd",RaveEnd)

	--Rave colours
	RaveColTab = {
		{
			[ "$pp_colour_addr" ] 		= 0.05,
			[ "$pp_colour_addg" ] 		= 0,
			[ "$pp_colour_addb" ] 		= 0.05,
			[ "$pp_colour_brightness" ] = 0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 10,
			[ "$pp_colour_mulg" ] 		= 0,
			[ "$pp_colour_mulb" ] 		= 10
		},
		{
			[ "$pp_colour_addr" ] 		= 0,
			[ "$pp_colour_addg" ] 		= 0,
			[ "$pp_colour_addb" ] 		= 0.05,
			[ "$pp_colour_brightness" ] = 0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 0,
			[ "$pp_colour_mulg" ] 		= 0,
			[ "$pp_colour_mulb" ] 		= 20
		},
		{
			[ "$pp_colour_addr" ] 		= 0,
			[ "$pp_colour_addg" ] 		= 0.05,
			[ "$pp_colour_addb" ] 		= 0,
			[ "$pp_colour_brightness" ] = 0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 0,
			[ "$pp_colour_mulg" ] 		= 20,
			[ "$pp_colour_mulb" ] 		= 0
		},
		{
			[ "$pp_colour_addr" ] 		= 0.05,
			[ "$pp_colour_addg" ] 		= 0,
			[ "$pp_colour_addb" ] 		= 0,
			[ "$pp_colour_brightness" ] = 0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 20,
			[ "$pp_colour_mulg" ] 		= 0,
			[ "$pp_colour_mulb" ] 		= 0
		},
		{
			[ "$pp_colour_addr" ] 		= 0.05,
			[ "$pp_colour_addg" ] 		= 0.05,
			[ "$pp_colour_addb" ] 		= 0,
			[ "$pp_colour_brightness" ] = 0.1,
			[ "$pp_colour_contrast" ] 	= 1,
			[ "$pp_colour_colour" ] 	= 0,
			[ "$pp_colour_mulr" ] 		= 10,
			[ "$pp_colour_mulg" ] 		= 10,
			[ "$pp_colour_mulb" ] 		= 0
		}
	}
elseif SERVER then

end