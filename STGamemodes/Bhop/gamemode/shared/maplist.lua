--------------------
-- STBase
-- By Spacetech
--------------------

local MapList = {}

GM.MoneyScale = 0.6 
GM.MapWinMoney = {}

function GM:AddMap(Map, Money)
	self.MapWinMoney[Map] = math.Round(Money * self.MoneyScale)
	table.insert(MapList, Map)
end

GM:AddMap("bhop_3d_gm", 2500)
GM:AddMap("bhop_addict_v2", 20000)
GM:AddMap("bhop_adventure_final", 5000)
GM:AddMap("bhop_advi_new", 2200)
GM:AddMap("bhop_aquatic_v1", 3000)
GM:AddMap("bhop_arcane_v1_gm2", 10500)
GM:AddMap("bhop_areaportal_v1_gm", 8000)
GM:AddMap("bhop_austere_gm1", 5000)
GM:AddMap("bhop_awake", 6700)
GM:AddMap("bhop_badges_ausbhop", 10500)
GM:AddMap("bhop_bkz_goldbhop", 2000)
-- GM:AddMap("bhop_blackrockshooter", 4800) // Textures are terribly fucked up.
GM:AddMap("bhop_blue_gm", 2500)
GM:AddMap("bhop_blue_platforms", 1500)
GM:AddMap("bhop_caves_original", 2000)
GM:AddMap("bhop_ch4", 3000)
GM:AddMap("bhop_choice", 2000)
GM:AddMap("bhop_cleaned_v2", 2000)
GM:AddMap("bhop_cobblestone_gm", 2000)
GM:AddMap("bhop_cold", 5000)
GM:AddMap("bhop_colors", 2000)
GM:AddMap("bhop_combine", 3000)
GM:AddMap("bhop_danmark_gm", 5000)
-- GM:AddMap("bhop_depot", 3000) // Too hard.
GM:AddMap("bhop_dots_gm", 2400)
GM:AddMap("bhop_dust_v2", 6700)
GM:AddMap("bhop_eazy", 2000)
GM:AddMap("bhop_eazy_v2", 2400)
GM:AddMap("bhop_equilibre", 3000)
GM:AddMap("bhop_factory_v2_gm", 5000)
GM:AddMap("bhop_fairworld_beta1", 2000)
GM:AddMap("bhop_fishey_v3", 2000)
GM:AddMap("bhop_flash_b2_gm", 2000)
GM:AddMap("bhop_forgotten_tomb", 2000)
GM:AddMap("bhop_freakin", 4800)
GM:AddMap("bhop_frost_bite_v1a", 2000)
GM:AddMap("bhop_gloomy", 3000)
GM:AddMap("bhop_grandex_galaxy_v2", 6200)
GM:AddMap("bhop_green_fixx_gm", 2000)
GM:AddMap("bhop_greenglow", 3700)
GM:AddMap("bhop_greenhouse", 1500)
-- GM:AddMap("bhop_hive", 5000) // Too hard.
GM:AddMap("bhop_hmm_brighter_gm2", 2500)
GM:AddMap("bhop_impulse", 4000)
GM:AddMap("bhop_island_final_gm2", 2400)
GM:AddMap("bhop_ivy_final", 2000)
GM:AddMap("bhop_keksik", 2000)
GM:AddMap("bhop_larena", 5000)
GM:AddMap("bhop_legend_gm", 3000)
GM:AddMap("bhop_legenda_v2_gm", 1500)
GM:AddMap("bhop_mario_fxd", 1500)
GM:AddMap("bhop_measure_three", 2000)
GM:AddMap("bhop_messs_123", 5000)
GM:AddMap("bhop_metal_v2", 2000)
GM:AddMap("bhop_miku_v2", 3000)
GM:AddMap("bhop_militia_v2", 1500)
GM:AddMap("bhop_mine", 2500)
GM:AddMap("bhop_mist_3_gm", 2000)
GM:AddMap("bhop_monster_jam", 4500)
GM:AddMap("bhop_neon_v2", 2000)
GM:AddMap("bhop_noobhop_exg", 2000)
GM:AddMap("bhop_nuclear", 2000)
GM:AddMap("bhop_omn", 8000)
GM:AddMap("bhop_onetoone_gm", 2000)
GM:AddMap("bhop_overground_fix_gm3", 2500)
GM:AddMap("bhop_pinky", 2000)
GM:AddMap("bhop_rollin_v1", 2400)
GM:AddMap("bhop_rooster", 5300)
GM:AddMap("bhop_russkuimcz", 1500)
GM:AddMap("bhop_temple", 2000)
GM:AddMap("bhop_the_bulb", 2500)
GM:AddMap("bhop_tropic", 2400)
GM:AddMap("bhop_twisted", 5000)
GM:AddMap("bhop_unkn0wn_v2_gm", 5000)
GM:AddMap("bhop_wouit_v2_gm", 10500)
GM:AddMap("bhop_ytt_dust", 4200)

-----------------------------------------------------------------------------

if(CLIENT) then
	return
end

STGamemodes.Maps:SetMapRotation(MapList)

-- I forget why I have this..
-- for k,v in pairs(MapList) do
	-- if(v != "extend") then
		-- if(!file.Exists("../gamemodes/"..GM.Name.."/gamemode/Maps/"..v..".lua")) then
			-- Error("No Map File: ", v, "\n")
		-- end
	-- end
-- end
