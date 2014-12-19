--Created by Duby 12/11/2014.
--This was added to keep the main cl_init.lua file a bit cleaner. We only using local functions and receiving net messages anyway. 


--Duby: This is for when the crate moves. We need some sounds. :) 

local function cratemove()
pl = LocalPlayer() 
if pl:Team() == TEAM_HUMAN then
surface.PlaySound("mrgreen/beep22.wav")	
pl:Message("The Supplies have been used up. Wait for the next drop off!", 2, "white")
end
if pl:Team() == TEAM_UNDEAD then
surface.PlaySound("player/zombies/b/scream.wav")	
pl:Message("Human supplies have moved", 2, "white")
end
end
usermessage.Hook ( "cratemove", cratemove )

local function cratemove2()
pl = LocalPlayer() 
if pl:Team() == TEAM_HUMAN then
surface.PlaySound("mrgreen/beep22.wav")	
pl:Message("Supplies have been dropped, go find them", 2, "white")
timer.Simple(2, function()
surface.PlaySound("mrgreen/supplycrates/thunder3.mp3")
end)
end
end
usermessage.Hook ( "spawn", cratemove2 )
