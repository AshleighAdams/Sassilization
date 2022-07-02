--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if key == "OnStartTouch" and value == "end2_dust,Kill,,0,-1" then
		return "end3_dust,Kill,,0,-1"
	end
	if key == "OnStartTouch" and value == "end2_tele,Disable,,0,-1" then
		return "end3_tele,Disable,,0,-1"
	end
end)

-- Disables the benches' motion.
hook.Add("InitPostEntity", "InputCaller", function()
	for k,v in pairs(ents.FindByModel("models/props/de_train/lockerbench.mdl")) do
		v:Fire("DisableMotion")
	end
end)

--[[ -- Kills players if they try jumping on top of the stacked crates near the electric box.
STGamemodes.TouchEvents:Setup(Vector(-4434, -95, 128), Vector(-4368, -31, 194), function(ply)
	ply:Kill()
end) ]]

-- Kills players if they try jumping onto the wall on the revolving platforms laser trap thing.
STGamemodes.TouchEvents:Setup(Vector(-4488, 2688, 196), Vector(-4368, 2692, 256), function(ply)
	ply:Kill()
end)