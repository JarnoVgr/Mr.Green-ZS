
GM.RetroMode = CreateConVar("zs_retromode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Tough as nails old school zs. Also has no nails."):GetBool()
cvars.AddChangeCallback("zs_retromode", function(cvar, oldvalue, newvalue)
	GAMEMODE.RetroMode = (tonumber(newvalue) == 1)
end)

GM.NightMode = CreateConVar("zs_nightmode", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Embrace the darkness."):GetBool()
cvars.AddChangeCallback("zs_nightmode", function(cvar, oldvalue, newvalue)
	GAMEMODE.NightMode = (tonumber(newvalue) == 1)
end)


--Donation address
DONATE_ADDRESS = "donate.to.mrgreen[at]gmail[dot]com"

--Log lua errors
timer.Simple ( 1, function() RunConsoleCommand ( "lua_log_sv", "1" ) end )

--Enable team voice
timer.Simple ( 1, function() RunConsoleCommand ( "sv_alltalk", "0" ) end )

--Disables greencoin add function for local use (testing)
USE_GREENCOINS = false

--Saves debug to file at every entry
TURBO_DEBUGGER = false

--Use zombie random points
USE_RANDOM_SPAWN = false -- :/

--Enable editor spawn mode
EDITOR_SPAWN_MODE = false

-- Can be combined with above. Activates use of gm_guardian. Meaning default collision with zombies, but still soft collisions with teammates
GM_GUARDIAN = false

--Custom debug system save to file interval
DEBUG_SAVE_FILE_TIME = 3

-- Whether to activate the destructible props system
DESTRUCTIBLE_PROPS = true

-- Mass of physics prop * MASS_SCALAR = prop health
MASS_SCALAR = 40

-- Zombie spawn toxic (spawnkill anti-measure)
TOXIC_SPAWN = true

-- Green coins per Euro. Don't change unless you want an angry mob on your ass
COINS_PER_EURO = 1000

-- Exchange rate coins for killing humans/zombies == Double GC for Holidays! (Halloween, Easter etc)
COINS_PER_ZOMBIE = 1
COINS_PER_HUMAN = 3


//----------------------------
MAX_ST_ZOMBIES = 2
ST_ZOMBIE_CHANCE = 6//3 //%

DOUBLE_XP = false

IgnorePhysToMult = {
	"models/props_wasteland/prison_padlock001a.mdl",
	"models/props_c17/tools_wrench01a.mdl",
	"models/props/cs_office/computer_keyboard.mdl",
	"models/props_c17/metalpot002a.mdl",
	"models/weapons/w_fryingpan.mdl",
	"models/weapons/w_pot.mdl",
	"models/props/cs_militia/axe.mdl",
	"models/props_junk/shovel01a.mdl",
	"models/weapons/w_knife_t.mdl",
	"models/weapons/w_knife_ct.mdl",
	"models/weapons/w_knife_t.mdl",
	"models/props_c17/metalpot001a.mdl",
	"models/props_interiors/pot02a.mdl",
}

PhysToMult = {	
	"models/props_c17/furniturecouch001a.mdl",
	"models/props_c17/furniturecouch002a.mdl",
	"models/props_c17/furniturewashingmachine001a.mdl",
	"models/props_c17/furnituretable001a.mdl",
	"models/props_c17/oildrum001.mdl",
	"models/props_c17/oildrum001_explosive.mdl",
	"models/props_c17/furnituredresser001a.mdl",
	"models/props_c17/furniturefridge001a.mdl",
	"models/props_combine/breenchair.mdl",
	"models/props_interiors/furniture_lamp01a.mdl",
	"models/props_junk/plasticcrate01a.mdl",
	"models/props_junk/trashbin01a.mdl",
	"models/props_lab/filecabinet02.mdl",
	"models/props_wasteland/kitchen_counter001c.mdl",
	"models/props_wasteland/kitchen_counter001b.mdl",
	"models/props_wasteland/laundry_cart002.mdl",
	"models/props_wasteland/laundry_cart001.mdl",
	"models/props_junk/trashdumpster01a.mdl",
	"models/props_wasteland/controlroom_filecabinet002a.mdl",
	"models/props_c17/display_cooler01a.mdl",
	"models/props_interiors/furniture_couch01a.mdl",
	"models/props_interiors/vendingmachinesoda01a.mdl",
	"models/props_vehicles/tire001c_car.mdl",
	"models/props_junk/metalbucket01a.mdl",
	"models/props_junk/metalgascan.mdl",
	"models/props_junk/plasticbucket001a.mdl",
	"models/props_junk/metalbucket02a.mdl",
	"models/props_junk/sawblade001a.mdl",
	"models/props_junk/ravenholmsign.mdl",
	"models/props_junk/propanecanister001a.mdl",
	"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props_wasteland/controlroom_desk001b.mdl",
	"models/props_wasteland/kitchen_shelf001a.mdl",
	"models/props_wasteland/kitchen_shelf002a.mdl",
	"models/props_c17/chair_office01a.mdl",
	"models/props_c17/chair_stool01a.mdl",
	"models/props_c17/briefcase001a.mdl",
	"models/props_c17/trappropeller_engine.mdl",
	"models/props_combine/breenclock.mdl",
	"models/props_interiors/pot01a.mdl",
	"models/props_junk/meathook001a.mdl",
	"models/props_junk/shoe001a.mdl",
	"models/props_lab/monitor01a.mdl",
	"models/props_interiors/furniture_couch02a.mdl",
	"models/props_c17/cashregister01a.mdl",
	"models/props_c17/tv_monitor01.mdl",
	"models/props_interiors/furniture_shelf01a.mdl",
	"models/props_lab/cactus.mdl",
	"models/props_junk/wood_crate002a.mdl",
	"models/props/cs_assault/washer_box.mdl",
	"models/props_junk/garbage_plasticbottle001a.mdl",
	"models/props_junk/garbage_plasticbottle002a.mdl",
	"models/props_c17/furniturebed001a.mdl",
	"models/props/cs_office/file_box.mdl",
	"models/props_junk/wood_crate001a.mdl",
	"models/props_junk/cardboard_box001b.mdl",
	"models/props_vehicles/car003a_physics.mdl",
	"models/props_junk/pushcart01a.mdl",
	"models/items/car_battery01.mdl",
	"models/props/cs_militia/caseofbeer01.mdl",
	"models/props_c17/furniturechair001a.mdl",
	"models/props_junk/popcan01a.mdl",
	"models/props/cs_office/paper_towels.mdl",
	"models/props/de_inferno/bed.mdl",
	"models/props_junk/garbage_metalcan001a.mdl",
	"models/props/cs_office/computer_monitor.mdl",
	"models/props/cs_office/table_coffee.mdl",
	"models/props/cs_office/table_coffee.mdl",
	"models/props/cs_office/bookshelf3.mdl",
	"models/props/cs_office/trash_can.mdl",
	"models/props_junk/cinderblock01a.mdl",
	"models/props_junk/wood_pallet001a.mdl",
	"models/props/de_inferno/claypot01.mdl",
	"models/props_interiors/furniture_vanity01a.mdl",
	"models/props_junk/garbage_milkcarton002a.mdl",
	"models/props_c17/furniturearmchair001a.mdl",
	"models/props_lab/monitor01b.mdl",
	"models/props_c17/furnituretable003a.mdl",
	"models/props_interiors/furniture_cabinetdrawer01a.mdl",
	"models/props_c17/frame002a.mdl",
	"models/props_c17/frame002a.mdl",
	"models/props_wasteland/kitchen_counter001d.mdl",
	"models/props_junk/bicycle01a.mdl",
	"models/props_vehicles/car002a_physics.mdl",
	"models/props_vehicles/car003a_physics.mdl",
	"models/props_lab/reciever01b.mdl",
	"models/props_junk/garbage_glassbottle002a.mdl",
	"models/props_lab/reciever01d.mdl",
	"models/props_junk/wood_pallet001a_chunka3.mdl",
	"models/props_c17/canister01a.mdl",
	"models/props_wasteland/cafeteria_table001a.mdl",
	"models/props_junk/propane_tank001a.mdl",
	"models/props_lab/harddrive02.mdl",
	"models/props_wasteland/prison_shelf002a.mdl",
	"models/props_junk/glassbottle01a.mdl",
	"models/props_c17/canister02a.mdl",
	"models/props_junk/cardboard_box004a.mdl",
	"models/props_vehicles/carparts_axel01a.mdl",
	"models/props_junk/gascan001a.mdl",
	"models/props_c17/shelfunit01a.mdl",
	"models/props_junk/garbage_glassbottle003a.mdl",
	"models/props_wasteland/controlroom_filecabinet001a.mdl",
	"models/props_wasteland/prison_heater001a.mdl",
	"models/props_wasteland/laundry_basket002.mdl",
	"models/props_wasteland/cafeteria_bench001a.mdl",
	"models/props_wasteland/wood_fence01a.mdl",
	"models/props_wasteland/prison_bedframe001b.mdl",
	"models/props_vehicles/carparts_tire01a.mdl",
	"models/props_vehicles/carparts_tire01a.mdl",
	"models/props_junk/garbage_glassbottle001a.mdl",
	"models/props_c17/furnituredrawer002a.mdl",
	"models/props_c17/furnituredrawer001a.mdl",
	"models/gibs/hgibs_spine.mdl",
	"models/gibs/hgibs.mdl",
	"models/gibs/hgibs_rib.mdl",
	"models/gibs/hgibs_scapula.mdl",
	"models/props_interiors/furniture_chair03a.mdl",
	"models/props_junk/cardboard_box003a.mdl",
	"models/props_junk/cardboard_box001a.mdl",
	"models/props_c17/chair02a.mdl",
	"models/props_junk/ibeam01a_cluster01.mdl",
	"models/props_interiors/radiator01a.mdl",
	"models/props_junk/watermelon01.mdl",
	"models/props_junk/wheebarrow01a.mdl",
	"models/props_interiors/refrigeratordoor01a.mdl",
	"models/props_lab/partsbin01.mdl",
	"models/props_junk/metal_paintcan001a.mdl",
	"models/props_wasteland/wheel01a.mdl",
	"models/props/cs_office/computer_mouse.mdl",
	"models/props/cs_office/computer_caseb.mdl",
	"models/props_c17/playground_carousel01.mdl",
	"models/props_wasteland/barricade002a.mdl",
	"models/props/de_inferno/flower_barrel.mdl",
	"models/props_c17/doll01.mdl",
	"models/props_junk/trafficcone001a.mdl",
	"models/props_c17/furnituretable002a.mdl",
	"models/props/cs_office/sofa_chair.mdl",
	"models/props/cs_office/sofa.mdl",
	"models/props/de_train/barrel.mdl",
	"models/props_junk/garbage_newspaper001a.mdl",
	"models/props_junk/cardboard_box002a.mdl",
	"models/props_c17/furnituretable002a.mdl",
	"models/props/de_tides/restaurant_table.mdl",
	"models/props/cs_office/shelves_metal.mdl",
	"models/props_c17/computer01_keyboard.mdl",
	"models/props_lab/monitor02.mdl",
	"models/props_lab/harddrive01.mdl",
	"models/props_wasteland/controlroom_desk001a.mdl",
	"models/props_lab/bindergraylabel01b.mdl",
	"models/props_lab/binderblue.mdl",
	"models/props_lab/reciever01a.mdl",
	"models/props_wasteland/barricade001a.mdl",
	"models/props_lab/jar01a.mdl",
	"models/props_junk/terracotta01.mdl",
	"models/props_c17/bench01a.mdl",
	"models/props_debris/wood_board04a.mdl",
	"models/props_junk/glassjug01.mdl",
	"models/props_wasteland/prison_heater001a.mdl",
	"models/props_junk/wood_crate001a_damaged.mdl",
	"models/props_junk/propanecanister001a.mdl",
	"models/props_c17/lamp001a.mdl",
	"models/props/cs_office/vending_machine.mdl",
	"models/props/de_tides/patio_chair2.mdl",
	"models/props/de_tides/vending_cart.mdl",
	"models/props/cs_italy/it_mkt_container1a.mdl",
	"models/props/cs_italy/it_mkt_container3a.mdl",
	"models/props_combine/breendesk.mdl",
	"models/props/cs_office/microwave.mdl",
	"models/props/cs_office/projector.mdl",
	"models/props/cs_office/tv_plasma.mdl",
	"models/props_lab/jar01b.mdl",
	"models/props_lab/hevplate.mdl",

}

for _,mdl in pairs(PhysToMult) do
	local newmdl = string.lower(mdl)
	PhysToMult[_] = newmdl
end
