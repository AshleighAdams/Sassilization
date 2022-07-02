--[[-------------------------------------------------------------------
		Achievements
---------------------------------------------------------------------]]
-- Award achievement to player who launches the nuke at the end of the map
hook.Add("PlayerUse", "LaunchNukeAchievement", function(ply, ent)
	if !ply:IsZombie() && ent:GetName() == "button995" && !ent.bLaunched then
		ent.bLaunched = true
		STAchievements:Award(ply, "Heavy Weapons Guy", true)
	end
end)