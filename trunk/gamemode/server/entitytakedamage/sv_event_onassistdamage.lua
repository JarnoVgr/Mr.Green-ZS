-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
 
local math = math
local tostring = tostring

//Called to initialize an assist table for a victim and to add damage to it
local function AssistDamageAdd ( mVictim, mAttacker, mInflictor, dmginfo )

	//Only for player attackers
	if dmginfo:IsAttackerPlayer() then 
		 
		//Initialize the assist table 
		if not mVictim.Shooters then
			mVictim.Shooters = {}
			Debug ( "[ASSIST] Initializing Assist Table for "..tostring ( mVictim ) )
		end
		
		//So we can perform arithmetics on damage
		mVictim.Shooters[ mAttacker ] = mVictim.Shooters[ mAttacker ] or { Attacker = mAttacker, Team = mAttacker:Team(), Damage = 0 } 
		
		//Add damage to the victim table when somebody from opposite team damages him
		if ( mAttacker:Team() != mVictim:Team() ) then
			mVictim.Shooters[ mAttacker ].Damage = mVictim.Shooters[ mAttacker ].Damage + math.Round ( dmginfo:GetDamage() )
		end
	end
end
hook.Add( "OnPlayerTakeDamage", "AssistAddDamage", AssistDamageAdd )
 

 
