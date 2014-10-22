-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function VoiceInit()
	timer.Create( "voice_question",40,1,VoiceToQuestion )
end
hook.Add( "Initialize","VoiceInit",VoiceInit)

function VoiceToQuestion()
	local humans = team.GetPlayers(TEAM_HUMAN)
	if (#humans > 1) then
		local ply = humans[math.random(1,#humans)]
		if IsRealisticToVoice(ply) then
			ply:VoiceQuestion()
			
			-- Find any nearby players that can respond to your
			-- random chatter.
			local found = ents.FindInSphere(ply:GetPos(), 150)
			pos_zombies = {}
			pos_humans = {}
			
			for k, v in pairs(found) do
				if v:IsPlayer() and v ~= ply and v:Alive() then
					if v:Team() == TEAM_HUMAN then
						table.insert(pos_humans, v)
					elseif v:Team() == TEAM_UNDEAD then
						table.insert(pos_zombies, v)
					end
				end
			end
			
			if (#pos_zombies <= 0 and #pos_humans > 0) then -- no undead in the area
				local hum = pos_humans[math.random(1,#pos_humans)]
				timer.Simple(4,function() VoiceToAnswer(hum) end)
			end
		end
	end

	timer.Adjust("voice_question",30+math.random(1,10)-math.min(#humans,20),1,VoiceToQuestion)
	timer.Start("voice_question")
end

function VoiceToAnswer( ply )
	if not IsRealisticToVoice( ply ) then return end
	ply:VoiceAnswer()
end

function VoiceToPush( ply )
	if not IsRealisticToVoice( ply ) then return end
	ply:VoicePush()
end

function VoiceToKillCheer( ply )
	if not IsRealisticToVoice( ply ) then return end
	ply:VoiceKillCheer()
end

-- To avoid akward situations, we check if it would be realitic for
-- this person to start chatting
function IsRealisticToVoice( ply )
	return IsValid(ply) and
			ply:Alive() and
				ply:Health() > 40 and 
					ply:Team() == TEAM_HUMAN and 
						ply.LastVoice <= CurTime()-5 and 
							ply.LastHurt <= CurTime()-10
end
