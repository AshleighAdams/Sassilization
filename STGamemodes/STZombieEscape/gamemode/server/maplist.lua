--------------------
-- STBase
-- By Spacetech
--------------------

ZEMAPTIMES = {}
local MapList = {}


function GM:AddMap( Map, SpawnDelay ) 
	table.insert(MapList, Map) 

	if SpawnDelay and SpawnDelay > 0 then 
		ZEMAPTIMES[Map] = SpawnDelay 
	end 
end 

GM:AddMap("ze_30_seconds__b21", 25)
GM:AddMap("ze_biohazard_2_rpd_v3a_004", 25)
GM:AddMap("ze_blackmesa_escape_e1", 25)
GM:AddMap("ze_death_star_escape_v4_3_gm1", 25)
GM:AddMap("ze_echo_boatescape_extended_gm", 20) -- spawns swapped?
GM:AddMap("ze_elevator_escape_jbg_gm", 20)
GM:AddMap("ze_ffvii_mako_reactor_v5_1_gm", 20) -- need to test difficulty detection
GM:AddMap("ze_Flying_World_v1_3_gm", 20)
GM:AddMap("ze_hell_escape_rc1", 15)
GM:AddMap("ze_icecap_escape_v5", 10)
GM:AddMap("ze_ice_hold_b2_gm", 30)
GM:AddMap("ze_lotr_helms_deep_v5_gm", 15) -- ladders are far too easy to break
GM:AddMap("ze_LOTR_Mines_of_Moria_v6_gm", 15)
GM:AddMap("ze_LOTR_Mount_Doom_v4_1_gm", 20)
GM:AddMap("ze_minecraft_v1_1_gm3", 15) -- missing models in pit Entity Indexes: 710, 711 http://i41.tinypic.com/2cdixcy.png
GM:AddMap("ze_moon_base_v1", 15)
GM:AddMap("ze_predator_ultimate_v3_gm", 15) -- need to test final boss
GM:AddMap("ze_rooftop_runaway2_v5", 20)
GM:AddMap("ze_sg1_missions_v2_1_gm", 15) -- zombie loses weapons if it jumps in the reactor?!
GM:AddMap("ze_sorrento_escape_v5_gm", 12)
GM:AddMap("ze_titanic_escape_v2_3_gm", 15)
GM:AddMap("ze_voodoo_islands_v8_2", 10)
GM:AddMap("ze_zombierig_ultimate_v1_2_gm", 15)

-- GM:AddMap("ze_resonance_cascade_v3_gm")
-- GM:AddMap("ze_trainescape_b3_gm") // Newest version in Gamebanana??

	
	--[[

	Maps that need to be patched with
	the CONTENTS_GRATE fix
	
	"ze_LOTR_Minas_Tirith_v2_2fix",


	Maps that crash

	"ze_jurassicpark_v2_FW_fix", -- bad inline model number 49, worldmodel not yet setup
	"ze_lotr_minas_tiret_v4",
	"ze_palm_island_nav72",


	Suggested Maps to add
	
	"ze_paper_escaper_v5_2_fix", -- http://www.gamebanana.com/csszm/maps/164614
	"ze_PotC_v3_4fix", -- http://www.gamebanana.com/csszm/maps/116036
	
	
	Where to find more maps:
	http://www.gamebanana.com/csszm/maps/cats/2471


	Notes:

		- Map names, including '.bsp' at the end, are limited by only 32 characters!
		Otherwise, fastdl will break!

		- All maps with *_gm have been patched

	]]

STGamemodes.Maps:SetMapRotation(MapList)
