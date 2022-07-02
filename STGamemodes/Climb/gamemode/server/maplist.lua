--------------------
-- STBase
-- By Spacetech
--------------------

local MapList = {}
GM.CurMap = game.GetMap()

function GM:AddMap(Map, Money, NoSaveMoney)	
	if self.CurMap == Map then
		if Money then 
			self.WinMoney = Money
			self.NoSaveWinMoney = NoSaveMoney
		end 
	end
	table.insert(MapList, Map)
end

GM:AddMap( "xc_7in1_gm", 7200, 10800 )
GM:AddMap( "xc_azteclimb", 6000, 12000 )
GM:AddMap( "xc_canyon", 5400, 11700 )
GM:AddMap( "xc_cliffez", 3600, 7800 )
GM:AddMap( "xc_cliff_of_kamoon", 2700, 4200 )
GM:AddMap( "xc_complex", 7500, 22000 )
GM:AddMap( "xc_dtt_anthologie3", 9600, 13200 )
GM:AddMap( "xc_dtt_hope", 9750, 11700 )
GM:AddMap( "xc_dtt_tixi", 6000, 11200 )
GM:AddMap( "xc_easyclimb", 5600, 15400 )
GM:AddMap( "xc_egypt", 9600, 36000 )
GM:AddMap( "xc_factory_gm", 3600, 5600 )
GM:AddMap( "xc_flow", 4500, 9000 )
GM:AddMap( "xc_galaxy", 3500, 7700 )
GM:AddMap( "xc_into_the_mainframe_v4", 20000, 100000 )
GM:AddMap( "xc_karo3_v2", 4000, 7500 )
GM:AddMap( "xc_marioclouds_gm", 7500, 13000 )
GM:AddMap( "xc_medium_vxx", 9000, 20000 )
GM:AddMap( "xc_nature", 2500, 5000 )
GM:AddMap( "xc_natureblock", 2500, 5000 )
GM:AddMap( "xc_obsidian", 7200, 10800 )
GM:AddMap( "xc_paris", 4800, 9600 )
GM:AddMap( "xc_peak", 4200, 8400 )
GM:AddMap( "xc_pharaoh_v2", 7700, 23800 )
GM:AddMap( "xc_piscine_v2", 3500, 7500 )
GM:AddMap( "xc_rat_bath_v3", 4500, 8500 )
-- GM:AddMap( "xc_rat_kit_v2", 4000, 7000 ) -- Displays error (WHY DOES THIS MAP NEVER WORK PROPERLY??)
GM:AddMap( "xc_sanctuary", 5000, 7500 )
GM:AddMap( "xc_sanctuary2", 15000, 21000 )
GM:AddMap( "xc_sewers", 4500, 6000 )
GM:AddMap( "xc_toonrun2_gm", 4200, 9100 )
GM:AddMap( "xc_toonrun3", 7000, 24500 )
GM:AddMap( "xc_water_light_blue", 5600, 7000 )
GM:AddMap( "xc_unknownposition", 3200, 7200 )
GM:AddMap( "xc_xand", 4900, 5600 )

if !GM.WinMoney then GM.WinMoney = 2000 end 
if !GM.NoSaveWinMoney then GM.NoSaveWinMoney = GM.WinMoney*3.5 end 

STGamemodes.Maps:SetMapRotation(MapList)

--[[ local MapList = {
	"xc_azteclimb",
	"xc_canyon",
	"xc_dtt_hope",
	"xc_cliffez",
	"xc_nature",
	"xc_peak",
	"xc_sewers",
	"xc_unknownposition",
	"xc_xand",
	"xc_complex",
	"xc_obsidian",
	"xc_paris",
	"xc_factory_b1_gm",
	"xc_cliff_of_kamoon",
	"xc_dtt_anthologie3",
	"xc_egypt",
	"xc_galaxy",
	"xc_flow",
	"xc_dtt_tixi",
	"xc_pharaoh_v2",
	"xc_sanctuary",
	"xc_sanctuary2",
	"xc_marioclouds_gm",
	"xc_toonrun2_gm",
	"xc_easyclimb",
	"xc_medium_vxx",
	"xc_natureblock",
	"xc_water_light_blue",
	"xc_toonrun3"
} ]]