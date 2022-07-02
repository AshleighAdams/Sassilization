--[[-------------------------------------------------------------------
		Achievements
---------------------------------------------------------------------]]
-- Award achievement to player who launches the nuke at the end of the map
hook.Add("PlayerUse", "LaunchNukeAchievement", function(ply, ent)
	if !ply:IsZombie() && ent.bNukeBtn && !ent.bLaunched then
		ent.bLaunched = true
		STAchievements:Award(ply, "Heavy Weapons Guy", true)
	end
end)

-- Specify which entity is the nuke button since there is no targetname on the func_button
hook.Add("EntityKeyValue", "SpecifyNukeButton", function(ent, k, v)
	if ent:GetClass() == "func_button" && k == "OnPressed" && v == "Com,Command,say ***Nuke in 10secs.***,0,1" then
		ent.bNukeBtn = true
	end
end)

--[[-------------------------------------------------------------------
		Map Fixes
---------------------------------------------------------------------]]
hook.Add("OnRoundChange", "RemoveBugsSecrets", function()
	-- Remove orange secrets
	local buttons = ents.FindByName("Orange*")
	for _, v in ipairs(buttons) do
		if IsValid(v) then
			v:Remove()
		end
	end
	
	-- Remove skybox teleports
	local buttons = ents.FindByName("SkyBox*")
	for _, v in ipairs(buttons) do
		if IsValid(v) then
			v:Remove()
		end
	end
end)