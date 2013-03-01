-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	print( "Custom Chat (based on iChat) loaded" )
	AddCSLuaFile( "sh_chat.lua" )
	--[[local files = file.Find( "../materials/ichat/smilies/*.*" )
	for k, v in pairs( files ) do
		resource.AddFile( "materials/ichat/smilies/"..v )
	end]]
else
	local TEXT_TYPE_NONE = 1
	local TEXT_TYPE_COLOR = 2
	local TEXT_TYPE_EMOTE = 3
	
	ICHAT = {}
	ICHAT.Lines = {}
	ICHAT.ChatOpen = false
	ICHAT.ChatEntry = nil
	
	ICHAT.Shorts = {}
	ICHAT.Shorts["[c=red]"] = "[c=255,0,0,255]"
	ICHAT.Shorts["[c=blue]"] = "[c=0,0,255,255]"
	ICHAT.Shorts["[c=black]"] = "[c=0,0,0,255]"
	ICHAT.Shorts["[c=white]"] = "[c=0,0,0,255]"
	ICHAT.Shorts["[c=green]"] = "[c=0,255,0,255]"
	--[[ICHAT.Shorts[":)"] = "[e=smile]"
	ICHAT.Shorts[":D"] = "[e=biggrin]"
	ICHAT.Shorts[":3"] = "[e=three]"
	ICHAT.Shorts[":downs:"] = "[e=downs]"
	ICHAT.Shorts[":dumb:"] = "[e=downs]"
	ICHAT.Shorts["._."] = "[e=downs]"
	ICHAT.Shorts[":eek:"] = "[e=eek]"
	ICHAT.Shorts[":o"] = "[e=eek]"
	ICHAT.Shorts[":O"] = "[e=eek]"
	ICHAT.Shorts[":geno:"] = "[e=geno]"
	ICHAT.Shorts["-.-"] = "[e=geno]"
	ICHAT.Shorts[":l"] = "[e=geno]"
	ICHAT.Shorts[":blush:"] = "[e=redface]"
	ICHAT.Shorts[":rolleye:"] = "[e=rolleye]"
	ICHAT.Shorts[";D"] = "[e=wink]"
	ICHAT.Shorts[";)"] = "[e=wink]"]]
	
	ICHAT.Emotes = {}
	--[[ICHAT.Emotes["smile"] = "ichat/smilies/smile"
	ICHAT.Emotes["biggrin"] = "ichat/smilies/biggrin"
	ICHAT.Emotes["three"] = "ichat/smilies/3"
	ICHAT.Emotes["downs"] = "ichat/smilies/downs"
	ICHAT.Emotes["eek"] = "ichat/smilies/eek"
	ICHAT.Emotes["geno"] = "ichat/smilies/geno"
	ICHAT.Emotes["redface"] = "ichat/smilies/redface"
	ICHAT.Emotes["rolleye"] = "ichat/smilies/rolleye"
	ICHAT.Emotes["wink"] = "ichat/smilies/wink"]]

	surface.CreateFont( "Arial", 12, 500, true, false, "ChatFont" )
	function ICHAT.CreateChatBox()
		local SCRH = ScrH()
		local SCRW = ScrW()

		ICHAT.ChatEntry = vgui.Create( "DTextEntry" )
		ICHAT.ChatEntry:SetPos( 35, SCRH - 140 )
		ICHAT.ChatEntry:SetSize( 500, 20 )
		ICHAT.ChatEntry:SetVisible( false )
		ICHAT.ChatEntry:SetEditable( false )
	end

	function ICHAT.OpenChatEntry()
		ICHAT.ChatOpen = true
		ICHAT.ChatEntry:SetVisible( true )
		gui.EnableScreenClicker( true )
		return true
	end
	hook.Add( "StartChat", "ICHATOpenChat", ICHAT.OpenChatEntry )

	function ICHAT.CloseChatEntry()
		ICHAT.ChatOpen = false
		ICHAT.ChatEntry:SetVisible( false )
		gui.EnableScreenClicker( false )
	end
	hook.Add( "FinishChat", "ICHATCloseChat", ICHAT.CloseChatEntry )

	function ICHAT.UpdateChatEntry( text )
		ICHAT.ChatEntry:SetText( text )
	end
	hook.Add( "ChatTextChanged", "ICHATUpdateChatEntry", ICHAT.UpdateChatEntry )

	function ICHAT.ChatMessage( plyInd, plyName, mText, mType )
		if mType == "chat" && !ICHAT.FilterChat then
			local col = team.GetColor( player.GetByID( plyInd ):Team() ) or Color( 200, 200, 200, 255 )
			for k, v in pairs( ICHAT.Shorts ) do mText = string.Replace( mText, k, v ) end
			ICHAT.ParseLine( "[c="..col.r..","..col.g..","..col.b..","..col.a.."]"..plyName.." :[/c]"..mText )
		elseif mType == "none" && !ICHAT.FilterNone then
			ICHAT.ParseLine( mText )
		elseif mType == "joinleave" && !ICHAT.FilterJoinLeave then
			ICHAT.ParseLine( "[c=200,200,200,255]"..mText.."[/c]" )
		end
	end
	hook.Add( "ChatText", "ICHATChatMessage", ICHAT.ChatMessage )
	
	function ICHAT.ParseLine( line )
		surface.SetFont( "ChatFont" )
		local lineValues = {}
		lineValues.Type = {}
		lineValues.Value = {}
		lineValues.Text = {}
		lineValues.Width = {}
		lineValues.Length = 0
		local toParse = line
		local id = 1
		local clStart, clEnd, clTag, clR, clG, clB, clA = string.find( toParse, "(%[c=(%d+),(%d+),(%d+),(%d+)%])" )
		local emStart, emEnd, emTag, em = string.find( toParse, "(%[e=(%a*)%])" )
		while toParse != "" do
			if clStart && emStart then //colours and emoticons
				if clStart < emStart then // colour tag first
					if clStart == 1 then // colour is at start
						local colEndStart, colEndEnd, colEnd = string.find( toParse, "(%[/c%])" )
						if colEndStart then colEndStart = colEndStart - 1 else colEndStart =  string.len( toParse ) end
						colEndEnd = colEndEnd or string.len( toParse )
						local text = string.sub( toParse, clEnd+1, colEndStart )
						local w, h = surface.GetTextSize( text )
						table.insert( lineValues.Type, id, TEXT_TYPE_COLOR )
						table.insert( lineValues.Value, id, Color( clR, clG, clB, clA ) )
						table.insert( lineValues.Text, id, text )
						table.insert( lineValues.Width, id, w )
						if colEndEnd then toParse = string.sub( toParse, colEndEnd+1 ) else toParse = "" end
					elseif clStart > 1 then // colour is not at start
						local text = string.sub( toParse, 1, clStart - 1 )
						local w, h = surface.GetTextSize( text )
						table.insert( lineValues.Width, id, w )
						table.insert( lineValues.Type, id, TEXT_TYPE_NONE )
						table.insert( lineValues.Text, id, text )
						toParse = string.sub( toParse, clStart, string.len( toParse ) )
					end
				elseif emStart < clStart then //emote first
					if emStart == 1 then // emote is at start
						for k, v in pairs( ICHAT.Emotes ) do
							if k == em then
								table.insert( lineValues.Value, id, v )
								break
							else
								table.insert( lineValues.Value, id, ICHAT.Emotes["happy"] )
								break
							end
						end
						table.insert( lineValues.Type, id, TEXT_TYPE_EMOTE )
						table.insert( lineValues.Text, id, text )
						table.insert( lineValues.Width, id, 18 )
						toParse = string.sub( toParse, emEnd+1 )
					elseif emStart > 1 then //emote is not at start
						local text = string.sub( toParse, 1, emStart - 1 )
						local w, h = surface.GetTextSize( text )
						table.insert( lineValues.Width, id, w )
						table.insert( lineValues.Type, id, TEXT_TYPE_NONE )
						table.insert( lineValues.Text, id, text )
						toParse = string.sub( toParse, emStart, string.len( toParse ) )
					end
				end
				clStart, clEnd, clTag, clR, clG, clB, clA = string.find( toParse, "(%[c=(%d+),(%d+),(%d+),(%d+)%])" )
				emStart, emEnd, emTag, em = string.find( toParse, "(%[e=([%a]*)%])" )
				id = id + 1
			elseif clStart && !emStart then //just colours
				if clStart == 1 then // colour is at start
					local colEndStart, colEndEnd, colEnd = string.find( toParse, "(%[/c%])" )
					if colEndStart then colEndStart = colEndStart - 1 else colEndStart = string.len( toParse ) end
					colEndEnd = colEndEnd or string.len( toParse )
					local text = string.sub( toParse, clEnd+1, colEndStart )
					local w, h = surface.GetTextSize( text )
					table.insert( lineValues.Type, id, TEXT_TYPE_COLOR )
					table.insert( lineValues.Value, id, Color( clR, clG, clB, clA ) )
					table.insert( lineValues.Text, id, text )
					table.insert( lineValues.Width, id, w )
					if colEndEnd then toParse = string.sub( toParse, colEndEnd+1 ) else toParse = "" end
				elseif clStart > 1 then // colour is not at start
					local text = string.sub( toParse, 1, clStart - 1 )
					local w, h = surface.GetTextSize( text )
					table.insert( lineValues.Width, id, w )
					table.insert( lineValues.Type, id, TEXT_TYPE_NONE )
					table.insert( lineValues.Text, id, text )
					toParse = string.sub( toParse, clStart, string.len( toParse ) )
				end
				clStart, clEnd, clTag, clR, clG, clB, clA = string.find( toParse, "(%[c=(%d+),(%d+),(%d+),(%d+)%])" )
				id = id + 1
			elseif emStart && !clStart then //just emotes
				if emStart == 1 then // emote is at start
					for k, v in pairs( ICHAT.Emotes ) do
						if k == em then
							lineValues.Value[ id ] = v
							break
						else
							lineValues.Value[ id ] = ICHAT.Emotes["happy"]
						end
					end
					table.insert( lineValues.Type, id, TEXT_TYPE_EMOTE )
					table.insert( lineValues.Width, id, 18 )
					toParse = string.sub( toParse, emEnd+1 )
				elseif emStart > 1 then //emote is not at start
					local text = string.sub( toParse, 1, emStart - 1 )
					local w, h = surface.GetTextSize( text )
					table.insert( lineValues.Width, id, w )
					table.insert( lineValues.Type, id, TEXT_TYPE_NONE )
					table.insert( lineValues.Text, id, text )
					toParse = string.sub( toParse, emStart, string.len( toParse ) )
				end
				emStart, emEnd, emTag, em = string.find( toParse, "(%[e=(%a*)%])" )
				id = id + 1
			else //no colours or emotes
				local w, h = surface.GetTextSize( toParse )
				table.insert( lineValues.Type, id, TEXT_TYPE_NONE )
				table.insert( lineValues.Text, id, toParse )
				table.insert( lineValues.Width, id, w )
				toParse = ""
				id = id + 1
			end
		end
		lineValues.Length = id
		table.insert( ICHAT.Lines, lineValues )
	end
	
	function ICHAT.DrawLine( x, y, line )
		local curX = x
		local curY = y
		local num = line.Length
		for i = 1, line.Length do
			local t = line.Type[i]
			local w = line.Width[i]
			local val = line.Value[i]
			local text = line.Text[i]
			if t == TEXT_TYPE_NONE then
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.SetTextPos( curX, curY )
				surface.DrawText( text )
			elseif t == TEXT_TYPE_COLOR then
				surface.SetTextColor( val )
				surface.SetTextPos( curX, curY )
				surface.DrawText( text )
			elseif t == TEXT_TYPE_EMOTE then
				surface.SetTexture( surface.GetTextureID(val) )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( curX + 1, curY, 16, 16 )
			end
			if w then curX = curX + w or curX end
		end
	end

	function ICHAT.DrawChat()
		local SCRH = ScrH()
		surface.SetFont( "ChatFont" )
		if ICHAT.ChatOpen then
			surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
			surface.DrawRect( 30, SCRH - 233, 510, 120 )
		end
		local _, lineHeight = surface.GetTextSize( "H" )
		local curX = 35
		local curY = SCRH - 228
		for i = 0, 4 do
			local line = ICHAT.Lines[#ICHAT.Lines-i]
			if line then
				curX = 35
				ICHAT.DrawLine( curX, curY, line )
				curY = curY + lineHeight + 2
			end
		end
	end
	hook.Add( "HUDPaint", "ICHATDrawChat", ICHAT.DrawChat )
	
	hook.Add( "Initialize", "ICHATInitialize", ICHAT.CreateChatBox )
end