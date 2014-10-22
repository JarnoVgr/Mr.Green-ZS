-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--- Manage everything related to chat!
include("cl_chatbox.lua")

--[==[---------------------------------------------------------
           Called when the chat box is opened
---------------------------------------------------------]==]
--[[function GM:StartChat(isTeamChat)
	print("Well hello")
end]]

--[==[---------------------------------------------------------
           Called when the chat box is closed
---------------------------------------------------------]==]
function GM:FinishChat()
	print("Well bye")
end

--[==[---------------------------------------------------------
	Called whenever the content of the 
            user's chat input box is changed.
---------------------------------------------------------]==]
function GM:ChatTextChanged ( text )
end

--[==[---------------------------------------------------------
             Used for console messages
---------------------------------------------------------]==]
function GM:ChatText ( plyInd, plyName, mText, mType )
end

--[==[---------------------------------------------------------
   Called when you press TAB on chatbox active
---------------------------------------------------------]==]
function GM:OnChatTab ( str )
 	local LastWord
	for word in string.gmatch( str, "%a+" ) do
	     LastWord = word
	end
 
	if (LastWord == nil) then
		return str
	end
 
	playerlist = player.GetAll()
 
	for k, v in pairs(playerlist) do
		local nickname = v:Nick()
 
		if string.len(LastWord) < string.len(nickname) and string.find( string.lower(nickname), string.lower(LastWord) ) == 1 then
			str = string.sub( str, 1, (string.len(LastWord) * -1) - 1)
			str = str .. nickname
			return str
		end
	end
 
	return str
end
