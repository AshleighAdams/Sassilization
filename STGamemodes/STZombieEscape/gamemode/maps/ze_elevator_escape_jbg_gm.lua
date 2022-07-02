--[[-------------------------------------------------------------------
		Achievements
---------------------------------------------------------------------]]
-- Award achievement to player who launches the nuke at the end of the map
hook.Add("PlayerUse", "LaunchNukeAchievement", function(ply, ent)
	if !ply:IsZombie() && ent:GetName() == "start_destruct" && !ent.bLaunched then
		ent.bLaunched = true
		STAchievements:Award(ply, "Heavy Weapons Guy", true)
	end
end)

--[[-------------------------------------------------------------------
		Map Fixes
---------------------------------------------------------------------]]
GM:IgnoreMessages(
	{"MAP FIXED BY 5UNZ"} -- fuck this guy, credit for fixing a map, really?..
)