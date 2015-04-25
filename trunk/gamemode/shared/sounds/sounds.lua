
-- Male pain / death sounds
VoiceSets = {}

VoiceSets["male"] = {}
VoiceSets["male"].PainSoundsLight = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

VoiceSets["male"].PainSoundsMed = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

VoiceSets["male"].PainSoundsHeavy = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

VoiceSets["male"].DeathSounds = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav"),
}

VoiceSets["male"].Frightened = {
Sound ( "vo/npc/male01/help01.wav" ),
Sound ( "vo/streetwar/sniper/male01/c17_09_help01.wav" ),
Sound ( "vo/streetwar/sniper/male01/c17_09_help02.wav" ),
Sound ( "ambient/voices/m_scream1.wav" ),
Sound ( "vo/k_lab/kl_ahhhh.wav" ),
Sound ( "vo/npc/male01/startle01.wav" ),
Sound ( "vo/npc/male01/startle02.wav" ),
}

-- Trigger sounds for chat. If someone says "zombie" in chat, it'll emit the corresponding sound
VoiceSets["male"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["leeroo"] = { Sound("mrgreen/leeroy.mp3") },
	["over 9000"] = { Sound("mrgreen/9000.wav") },
	["damnit"] = { Sound("mrgreen/goddamnit2.wav") },
	["this is sparta"] = { Sound("mrgreen/sparta.wav") },
	["open the door"] = { Sound("mrgreen/opendoor2.wav"), Sound("mrgreen/opendoor3.wav") },
	["ok"] = { Sound("vo/npc/male01/ok01.wav"), Sound("vo/npc/male01/ok02.wav") },
	["hack"] = { Sound("vo/npc/male01/hacks01.wav"), Sound("vo/npc/male01/hacks02.wav") },
	["headcrab"] = { Sound("vo/npc/male01/headcrabs01.wav"), Sound("vo/npc/male01/headcrabs02.wav") },
	["run"] = { Sound("vo/npc/male01/runforyourlife01.wav"), Sound("vo/npc/male01/runforyourlife02.wav") },
	["s go"] = { Sound("vo/npc/male01/letsgo01.wav"), Sound("vo/npc/male01/letsgo02.wav") },
	["help"] = { Sound("vo/npc/male01/help01.wav") },
	["nice"] = { Sound("vo/npc/male01/nice.wav") },
	["incoming"] = { Sound("vo/npc/male01/incoming02.wav") },
	["watch out"] = { Sound("vo/npc/male01/watchout.wav") },
	["get down"] = { Sound("vo/npc/male01/getdown02.wav") },
	["oh shi"] = { Sound("vo/npc/male01/uhoh.wav"), Sound("vo/npc/male01/ohno.wav") },
	["zombie"] = { Sound("vo/npc/male01/zombies01.wav"), Sound("vo/npc/male01/zombies02.wav") },
	["freeman"] = { Sound("vo/npc/male01/gordead_ques03a.wav"), Sound("vo/npc/male01/gordead_ques03b.wav") },
	["get out"] = { Sound("vo/npc/male01/gethellout.wav") },
	["pills"] = { Sound("mrgreen/pills/SpotPills01male.wav"), Sound("mrgreen/pills/SpotPills02male.wav"),Sound("mrgreen/pills/SpotPills03male.wav")  },
}

-- Random things they'll say now and then
VoiceSets["male"].QuestionSounds = {
Sound("vo/npc/male01/question04.wav"),
Sound("vo/npc/male01/question06.wav"),
Sound("vo/npc/male01/question02.wav"),
Sound("vo/npc/male01/question09.wav"),
Sound("vo/npc/male01/question11.wav"),
Sound("vo/npc/male01/question12.wav"),
Sound("vo/npc/male01/question17.wav"),
Sound("vo/npc/male01/question19.wav"),
Sound("vo/npc/male01/question20.wav"),
Sound("vo/npc/male01/question22.wav"),
Sound("vo/npc/male01/question26.wav"),
Sound("vo/npc/male01/question28.wav"),
Sound("vo/npc/male01/question29.wav"),
Sound("vo/npc/male01/question07.wav"),
Sound("vo/npc/male01/question01.wav"),
Sound("vo/npc/male01/question03.wav"),
Sound("vo/npc/male01/question05.wav"),
Sound("vo/npc/male01/question13.wav"),
Sound("vo/npc/male01/question07.wav"),
Sound("vo/npc/male01/question14.wav"),
Sound("vo/npc/male01/question18.wav"),
Sound("vo/npc/male01/question21.wav"),
Sound("vo/npc/male01/question25.wav"),
Sound("vo/npc/male01/question27.wav"),
Sound("vo/trainyard/cit_pacing.wav"),
Sound("vo/npc/male01/question30.wav")
}

VoiceSetsGhost = {}

VoiceSetsGhost.PainSounds = {
Sound("npc/barnacle/barnacle_pull1.wav"),
Sound("npc/barnacle/barnacle_pull2.wav"),
Sound("npc/barnacle/barnacle_pull3.wav"),
Sound("npc/barnacle/barnacle_pull4.wav")
}

VoiceSets["male"].AnswerSounds = {
Sound("vo/npc/male01/vanswer08.wav"),
Sound("vo/npc/male01/vanswer09.wav"),
Sound("vo/npc/male01/answer05.wav"),
Sound("vo/npc/male01/answer07.wav"),
Sound("vo/npc/male01/answer09.wav"),
Sound("vo/npc/male01/answer11.wav"),
Sound("vo/npc/male01/answer14.wav"),
Sound("vo/npc/male01/answer17.wav"),
Sound("vo/npc/male01/answer18.wav"),
Sound("vo/npc/male01/answer22.wav"),
Sound("vo/npc/male01/answer24.wav"),
Sound("vo/npc/male01/answer29.wav"),
Sound("vo/npc/male01/answer30.wav"),
Sound("vo/npc/male01/answer01.wav"),
Sound("vo/npc/male01/answer02.wav"),
Sound("vo/npc/male01/answer08.wav"),
Sound("vo/npc/male01/answer10.wav"),
Sound("vo/npc/male01/answer12.wav"),
Sound("vo/npc/male01/answer13.wav"),
Sound("vo/npc/male01/answer16.wav"),
Sound("vo/npc/male01/answer19.wav"),
Sound("vo/npc/male01/answer20.wav"),
Sound("vo/npc/male01/answer21.wav"),
Sound("vo/npc/male01/answer26.wav"),
Sound("vo/npc/male01/answer27.wav"),
Sound("vo/npc/male01/busy02wav")
}

VoiceSets["male"].PushSounds = {
Sound("vo/npc/male01/excuseme01.wav"),
Sound("vo/npc/male01/excuseme02.wav"),
Sound("vo/npc/male01/sorry01.wav"),
Sound("vo/npc/male01/sorry02.wav"),
Sound("vo/npc/male01/sorry03.wav"),
Sound("vo/npc/male01/pardonme01.wav"),
Sound("vo/npc/male01/pardonme02.wav")
}

VoiceSets["male"].KillCheer = {
Sound("vo/npc/male01/evenodds.wav"),
Sound("vo/npc/male01/gotone01.wav"),
Sound("vo/npc/male01/gotone02.wav")
}

VoiceSets["male"].Panic = {
Sound("vo/coast/odessa/male01/nlo_cubdeath01.wav"),
Sound("vo/coast/odessa/male01/nlo_cubdeath02.wav")
}

VoiceSets["male"].ReloadSounds = {
Sound("vo/npc/male01/coverwhilereload01.wav"),
Sound("vo/npc/male01/coverwhilereload02.wav"),
Sound("vo/npc/male01/gottareload01.wav"),
}

VoiceSets["male"].SupplySounds = {
Sound("vo/npc/male01/ammo04.wav"),
Sound("vo/npc/male01/ammo05.wav"),
Sound("vo/npc/male01/oneforme.wav"),
Sound("vo/npc/male01/yeah02.wav"),
}

VoiceSets["male"].WaveSounds = {
Sound("vo/npc/male01/headsup02.wav"),
Sound("vo/npc/male01/incoming02.wav"),
Sound("vo/npc/male01/watchout.wav"),
Sound("vo/npc/male01/zombies01.wav"),
Sound("vo/npc/male01/zombies02.wav"),
}

VoiceSets["male"].HealSounds = {
Sound("vo/npc/male01/health01.wav"),
Sound("vo/npc/male01/health02.wav"),
Sound("vo/npc/male01/health03.wav"),
Sound("vo/npc/male01/health04.wav"),
Sound("vo/npc/male01/health05.wav"),
}

-- WARNING!
-- Here goes insane precaching code
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
for _, set in pairs(VoiceSets["male"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				--print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

for _, tbl in pairs(VoiceSetsGhost) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- /

-- Female pain / death sounds
VoiceSets["female"] = {}
VoiceSets["female"].PainSoundsLight = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

VoiceSets["female"].PainSoundsMed = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

VoiceSets["female"].PainSoundsHeavy = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

VoiceSets["female"].DeathSounds = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav"),
}

VoiceSets["female"].Frightened = {
Sound ( "vo/canals/arrest_helpme.wav" ),
Sound ( "vo/npc/female01/help01.wav" ),
Sound ( "ambient/voices/f_scream1.wav" ),
}

VoiceSets["female"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["ok"] = { Sound("vo/npc/female01/ok01.wav"), Sound("vo/npc/female01/ok02.wav") },
	["hack"] = { Sound("vo/npc/female01/hacks01.wav"), Sound("vo/npc/female01/hacks02.wav") },
	["headcrab"] = { Sound("vo/npc/female01/headcrabs01.wav"), Sound("vo/npc/female01/headcrabs02.wav") },
	["incoming"] = { Sound("vo/npc/female01/incoming02.wav") },
	["help"] = { Sound("vo/npc/female01/help01.wav") },
	["s go"] = { Sound("vo/npc/female01/letsgo01.wav"), Sound("vo/npc/female01/letsgo02.wav") },
	["run"] = { Sound("vo/npc/female01/runforyourlife01.wav"), Sound("vo/npc/female01/runforyourlife02.wav") },
	["watch out"] = { Sound("vo/npc/female01/watchout.wav"), Sound("vo/npc/female01/headsup01.wav") },
	["nice"] = { Sound("vo/npc/female01/nice01.wav"), Sound("vo/npc/female01/nice02.wav") },
	["get down"] = { Sound("vo/npc/female01/getdown02.wav") },
	["oh shi"] = { Sound("vo/npc/female01/uhoh.wav"), Sound("vo/npc/female01/ohno.wav") },
	["zombie"] = { Sound("vo/npc/female01/zombies01.wav"), Sound("vo/npc/female01/zombies02.wav") },
	["get out"] = { Sound("vo/npc/female01/gethellout.wav") },
	["pills"] = { Sound("mrgreen/pills/SpotPills01female.wav"), Sound("mrgreen/pills/SpotPills02female.wav")  },
}

VoiceSets["female"].ReloadSounds = {
Sound("vo/npc/female01/coverwhilereload01.wav"),
Sound("vo/npc/female01/coverwhilereload02.wav"),
Sound("vo/npc/female01/gottareload01.wav"),
}

VoiceSets["female"].QuestionSounds = {
Sound("vo/npc/female01/vquestion02.wav"),
Sound("vo/npc/female01/question04.wav"),
Sound("vo/npc/female01/question06.wav"),
Sound("vo/npc/female01/question02.wav"),
Sound("vo/npc/female01/question09.wav"),
Sound("vo/npc/female01/question12.wav"),
Sound("vo/npc/female01/question17.wav"),
Sound("vo/npc/female01/question19.wav"),
Sound("vo/npc/female01/question20.wav"),
Sound("vo/npc/female01/question29.wav"),
Sound("vo/npc/female01/question30.wav")
}

VoiceSets["female"].AnswerSounds = {
Sound("vo/npc/female01/vanswer08.wav"),
Sound("vo/npc/female01/vanswer09.wav"),
Sound("vo/npc/female01/answer13.wav"),
Sound("vo/npc/female01/busy02.wav"),
Sound("vo/npc/female01/answer33.wav"),
Sound("vo/npc/female01/answer27.wav"),
Sound("vo/npc/female01/answer17.wav"),
Sound("vo/npc/female01/answer28.wav"),
Sound("vo/npc/female01/answer22.wav"),
Sound("vo/npc/female01/answer24.wav")
}

VoiceSets["female"].PushSounds = {
Sound("vo/npc/female01/excuseme01.wav"),
Sound("vo/npc/female01/excuseme02.wav"),
Sound("vo/npc/female01/sorry01.wav"),
Sound("vo/npc/female01/sorry02.wav"),
Sound("vo/npc/female01/sorry03.wav")
}

VoiceSets["female"].KillCheer = {
Sound("vo/npc/male01/gotone01.wav"),
Sound("vo/npc/male01/gotone02.wav")
}

VoiceSets["female"].SupplySounds = {
Sound("vo/npc/female01/ammo04.wav"),
Sound("vo/npc/female01/ammo05.wav"),
Sound("vo/npc/female01/yeah02.wav"),
}

VoiceSets["female"].Panic = {
Sound("vo/coast/odessa/female01/nlo_cubdeath01.wav"),
Sound("vo/coast/odessa/female01/nlo_cubdeath02.wav")
}

VoiceSets["female"].WaveSounds = {
Sound("vo/npc/female01/headsup01.wav"),
Sound("vo/npc/female01/headsup02.wav"),
Sound("vo/npc/female01/incoming02.wav"),
Sound("vo/npc/female01/watchout.wav"),
Sound("vo/npc/female01/zombies01.wav"),
Sound("vo/npc/female01/zombies02.wav"),
}

VoiceSets["female"].HealSounds = {
Sound("vo/npc/female01/health01.wav"),
Sound("vo/npc/female01/health02.wav"),
Sound("vo/npc/female01/health03.wav"),
Sound("vo/npc/female01/health04.wav"),
Sound("vo/npc/female01/health05.wav"),
}

-- Precache all sounds for female set
for _, set in pairs(VoiceSets["female"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				----print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

-- Combine sounds
VoiceSets["combine"] = {}
VoiceSets["combine"].PainSoundsLight = {
Sound("npc/combine_soldier/pain1.wav"),
Sound("npc/combine_soldier/pain2.wav"),
Sound("npc/combine_soldier/pain3.wav")
}

VoiceSets["combine"].PainSoundsMed = {
Sound("npc/metropolice/pain1.wav"),
Sound("npc/metropolice/pain2.wav")
}

VoiceSets["combine"].PainSoundsHeavy = {
Sound("npc/metropolice/pain3.wav"),
Sound("npc/metropolice/pain4.wav")
}

VoiceSets["combine"].DeathSounds = {
Sound("npc/combine_soldier/die1.wav"),
Sound("npc/combine_soldier/die2.wav"),
Sound("npc/combine_soldier/die3.wav")
}

VoiceSets["combine"].ReloadSounds = {
Sound("npc/combine_soldier/vo/coverme.wav"),
Sound("npc/combine_soldier/vo/targetmyradial.wav"),
}

VoiceSets["combine"].ChatSounds = {
	["burp"] = { Sound("mrgreen/burp.wav") },
	["ok"] = { Sound("npc/metropolice/vo/affirmative.wav"), Sound("npc/metropolice/vo/ten4.wav") },
	["zombie"] = { Sound("npc/metropolice/vo/freenecrotics.wav"), Sound("npc/metropolice/vo/necrotics.wav") },
	["incoming"] = { Sound("npc/metropolice/vo/takecover.wav") },
	["headcrab"] = { Sound("npc/metropolice/vo/bugs.wav"), Sound("npc/metropolice/vo/bugsontheloose.wav") },
	["move"] = { Sound("npc/metropolice/vo/move.wav"), Sound("npc/metropolice/vo/moveit.wav") },
	["oh shi"] = { Sound("npc/metropolice/vo/shit.wav") },
	["help"] = { Sound("npc/metropolice/vo/help.wav") },
	["watch out"] = { Sound("npc/metropolice/vo/lookout.wav"), Sound("npc/metropolice/vo/watchit.wav") },
	["get down"] = { Sound("npc/metropolice/vo/getdown.wav") },
	["get out"] = { Sound("npc/metropolice/vo/nowgetoutofhere.wav"), Sound("npc/metropolice/vo/getoutofhere.wav") }
}

VoiceSets["combine"].QuestionSounds = {
Sound("npc/combine_soldier/vo/motioncheckallradials.wav"),
Sound("npc/combine_soldier/vo/hardenthatposition.wav"),
Sound("npc/combine_soldier/vo/confirmsectornotsterile.wav"),
Sound("npc/combine_soldier/vo/necroticsinbound.wav"),
Sound("npc/combine_soldier/vo/readyweapons.wav"),
Sound("npc/combine_soldier/vo/readyweaponshostilesinbound.wav"),
Sound("npc/combine_soldier/vo/weareinaninfestationzone.wav"),
Sound("npc/combine_soldier/vo/stayalert.wav")
}

VoiceSets["combine"].AnswerSounds = {
Sound("npc/combine_soldier/vo/affirmative.wav"),
Sound("npc/combine_soldier/vo/affirmative2.wav"),
Sound("npc/combine_soldier/vo/copy.wav"),
Sound("npc/combine_soldier/vo/copythat.wav")
}

VoiceSets["combine"].PushSounds = {
Sound("npc/combine_soldier/vo/contact.wav"),
Sound("npc/combine_soldier/vo/displace.wav"),
Sound("npc/combine_soldier/vo/displace2.wav")
}

VoiceSets["combine"].KillCheer = {
Sound("npc/combine_soldier/vo/contactconfirmprosecuting.wav"),
Sound("npc/combine_soldier/vo/payback.wav"),
Sound("npc/combine_soldier/vo/onedown.wav"),
Sound("npc/combine_soldier/vo/onecontained.wav")
}

VoiceSets["combine"].Frightened = {
Sound("npc/metropolice/vo/officerneedshelp.wav"),
Sound("npc/metropolice/vo/help.wav"),
Sound("npc/combine_soldier/vo/inbound.wav"),
Sound("npc/combine_soldier/vo/callhotpoint.wav")
}

VoiceSets["combine"].SupplySounds = {
Sound("npc/metropolice/vo/chuckle.wav"),
}

VoiceSets["combine"].WaveSounds = {
Sound("npc/metropolice/vo/freenecrotics.wav"),
Sound("npc/metropolice/vo/holdthisposition.wav"),
Sound("npc/metropolice/vo/holditrightthere.wav"),
Sound("npc/combine_soldier/vo/contactconfirmprosecuting.wav"),
Sound("npc/combine_soldier/vo/overwatchrequestreinforcement.wav"),
}

-- Aaaand precache sounds for combine voice set
for _, set in pairs(VoiceSets["combine"]) do
	for k, snd in pairs(set) do
		--Check if its another table
		if type( snd ) == "table" then
			for j, sndnew in pairs(snd) do
				--print("Precached "..tostring(sndnew))
				util.PrecacheSound( sndnew )
			end
		else
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
		end
	end
end

GameSounds = {}

GameSounds.WinMusic = {
	"music/HL2_song6.mp3",
	"music/HL1_song17.mp3",
	"music/HL2_song31.mp3"
}

GameSounds.LoseMusic = {
	"music/HL2_song7.mp3",
	"music/HL2_song32.mp3",
	"music/HL2_song33.mp3"
}

for _, tbl in pairs(GameSounds) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

Ambience = {}

Ambience.Human = {
	Sound ( "music/HL1_song20.mp3" ),
	Sound ( "music/HL1_song26.mp3" ),
	Sound ( "music/HL1_song3.mp3" ),
	Sound ( "music/HL1_song14.mp3" ),
	Sound ( "music/HL1_song5.mp3" ),
	Sound ( "music/HL1_song6.mp3" ),
	Sound ( "music/HL1_song9.mp3" ),
	Sound ( "music/HL2_song0.mp3" ),
	Sound ( "music/HL2_song1.mp3" ),
	Sound ( "music/HL2_song10.mp3" ),
	Sound ( "music/HL2_song13.mp3" ),
	Sound ( "music/HL2_song17.mp3" ),
	Sound ( "music/HL2_song19.mp3" ),
	Sound ( "music/Ravenholm_1.mp3" ),
	Sound ( "music/HL2_song30.mp3" ),
	Sound ( "music/HL2_song7.mp3" ),
	Sound ( "music/HL2_song19.mp3" ),
	Sound ( "music/HL2_song26_trainstation1.mp3" ),
	Sound ( "music/HL2_song27_trainstation2.mp3" ),
	Sound ( "music/HL2_song32.mp3" ),
}

Ambience.Zombie = {
	Sound ( "music/stingers/HL1_stinger_song16.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song27.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song7.mp3" ),
	Sound ( "music/stingers/HL1_stinger_song8.mp3" ),
	Sound ( "music/stingers/industrial_suspense1.wav" ),
	Sound ( "music/stingers/industrial_suspense2.wav" ),
}

for _, tbl in pairs(Ambience) do
	for k, snd in pairs(tbl) do
		--print("Precached "..tostring(snd))
		util.PrecacheSound( snd )
	end
end

--[[GameDeathHints = {
	"Use props to kill humans at a longer distance!!",
	"Stick together as a team to win the game!",
	"You usually get 3 greencoins for a human kill.",
	"Headcrabs are small.Use them wisely!",
	"Critially injured humans move slower!",
	"You usually get 1 greencoin for a zombie kill.",
	"You can select a zombie class by pressing F3.",
	"Try to stick as a team when you are human!",
	"More zombie classes are unlocked when roundtime passes!",
	"As zombie, you can redeem by eating 4 brains (8 points)!",
	"Death isn't endgame. You can redeem by eating 4 brains (8 points)!",
	"Try other zombie classes! (F3)",
	"If you are new or confused press f1 and have a read!",
	"If you are new or confused ask an admin! (Red titles)",
	"Do you have any idea's or questions? Visit the forums!",
	"Zombies have the dice as well, try your luck! !rtd",
}]]
