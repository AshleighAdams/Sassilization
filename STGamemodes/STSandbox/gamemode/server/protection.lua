--------------------
-- STBase
-- By Spacetech
--------------------

Protection = {}
Protection.Time = 0.5

if(AdvDupe) then
	Protection.AdvCreateEntityFromTable = AdvDupe.CreateEntityFromTable
	Protection.AdvDupeGenericDuplicatorFunction = AdvDupe.GenericDuplicatorFunction
end

Protection.Hooks = {
	"PlayerSpawnRagdoll",
	"PlayerSpawnProp",
	"PlayerSpawnEffect",
	"PlayerSpawnSENT",
	"PlayerSpawnVehicle",
	"PlayerSpawnSWEP",
	"PlayerSpawnNPC"
}

Protection.VIPTools = {
}

Protection.BadTools = {
	"duplicator"
}

Protection.NoSkyTools = {
	"dynamite",
	"light",
	"balloon"
}

Protection.NoWorldTools = {
	"hydraulic",
	"pulley",
	"rope",
	"paint",
	"slider",
	"winch"
}

Protection.BannedProps = {
	// Explosives
	"models/props_c17/oildrum001_explosive.mdl",
	"models/props_junk/propane_tank001a.mdl",
	"models/props_junk/gascan001a.mdl",
	
	// PHX explosives
	"models/props_phx/misc/flakshell_big.mdl",
	"models/props_phx/ww2bomb.mdl",
	"models/props_phx/torpedo.mdl",
	"models/props_phx/mk-82.mdl",
	"models/props_phx/oildrum001_explosive.mdl",
	"models/props_phx/ball.mdl",
	
	// Big / Annoying
	"models/cranes/crane_frame.mdl",
	"models/props_buildings/building_002a.mdl",
	"models/props_buildings/collapsedbuilding02b.mdl",
	"models/props_buildings/collapsedbuilding02c.mdl",
	"models/props_buildings/project_building01.mdl",
	"models/props_buildings/project_building02.mdl",
	"models/props_buildings/project_building03.mdl",
	"models/props_buildings/project_destroyedbuildings01.mdl",
	"models/props_buildings/row_church_fullscale.mdl",
	"models/props_buildings/row_corner_1_fullscale.mdl",
	"models/props_buildings/row_res_1_fullscale.mdl",
	"models/props_buildings/row_res_2_ascend_fullscale.mdl",
	"models/props_buildings/row_res_2_fullscale.mdl",
	"models/props_buildings/watertower_001a.mdl",
	"models/props_buildings/watertower_002a.mdl",
	"models/props_canal/canal_bridge01.mdl",
	"models/props_canal/canal_bridge02.mdl",
	"models/props_canal/canal_bridge03a.mdl",
	"models/props_canal/canal_bridge03b.mdl",
	"models/props_combine/combine_citadel001.mdl",
	"models/props_combine/combineinnerwallcluster1024_001a.mdl",
	"models/props_combine/combineinnerwallcluster1024_002a.mdl",
	"models/props_combine/combineinnerwallcluster1024_003a.mdl",
	"models/props_wasteland/rockcliff_cluster01b.mdl",
	"models/props_wasteland/rockcliff_cluster02a.mdl",
	"models/props_wasteland/rockcliff_cluster02b.mdl",
	"models/props_wasteland/rockcliff_cluster02c.mdl",
	"models/props/de_nuke/storagetank.mdl",
	"models/props/de_train/biohazardtank.mdl",
	
	// PHX Big/ Annoying
	"models/props_phx/misc/big_ramp.mdl",
	"models/props_phx/misc/small_ramp.mdl",
	"models/props_phx/playfield.mdl",
	"models/props_phx/huge/tower.mdl",
	"models/props_phx/huge/evildisc_corp.mdl",
	
	// Misc
	"models/props_c17/utilitypole01d.mdl",
	
	// GMOW3 Big / Annoying
	"models/trailer1.mdl",
	"models/ramps/ramp1.mdl",
	"models/ramps/ramp2.mdl"
}

function Protection.PlayerSpawnPropBlockModel(ply, model)
	local FixedModel = string.gsub(model, "\\", "/")
 	for k,v in pairs(Protection.BannedProps) do
		if(v == FixedModel or string.find(v, FixedModel) or string.find(FixedModel, v)) then
			ply:ChatPrint("You can't spawn that prop!")
			return false
		end
 	end
end
hook.Add("PlayerSpawnProp", "Protection.PlayerSpawnPropBlockModel", Protection.PlayerSpawnPropBlockModel) 

function GM:CanTool(ply, tr, mode)
	local Mode = string.Trim(string.lower(mode))
	if(table.HasValue(Protection.BadTools, Mode)) then
		ply:ChatPrint("That tool has been disabled")
		return false
	end
	if(table.HasValue(Protection.VIPTools, Mode)) then
		if(!ply:IsVIP()) then
			ply:ChatPrint("Only VIP's can use that tool!")
			return false
		end
	end
	if(table.HasValue(Protection.NoSkyTools, Mode)) then
		if(tr.HitSky) then
			ply:ChatPrint("You can't use this tool on the sky!")
			return false
		end
	end
	if(table.HasValue(Protection.NoWorldTools, Mode)) then
		if(tr.HitWorld) then
			ply:ChatPrint("You can't use this tool on the world!")
			return false
		end
	end
	return self.BaseClass:CanTool(ply, tr, mode)
end

function Protection.Hook(ply, HookName)
	if(!ply.NextSpawn) then
		ply.NextSpawn = CurTime() - Protection.Time
	end
	if(ply.NextSpawn >= CurTime()) then
		ply.NextSpawn = CurTime() + Protection.Time
		return false
	end
	ply.NextSpawn = CurTime() + Protection.Time
end

if(AdvDupe) then
	function AdvDupe.CreateEntityFromTable(ply, ...)
		ply.NextSpawn = CurTime() - Protection.Time
		return Protection.AdvCreateEntityFromTable(ply, ...)
	end
	
	function AdvDupe.GenericDuplicatorFunction(Player, data, ID)
		if(!data) or (!data.Class) then return false end
		if(string.find(string.lower(data.Class), "weapon") == nil) then
			return Protection.AdvDupeGenericDuplicatorFunction(Player, data, ID)
		end
	end
end

for k,v in pairs(Protection.Hooks) do
	hook.Add(v, "Protection."..v, function(ply)
		local Work, Result = pcall(Protection.Hook, ply, v)
		if(!Work) then
			ErrorNoHalt("Protection Error In "..v..": "..Result.."\n")
		elseif(Result != nil) then
			return Result
		end
	end)
end
