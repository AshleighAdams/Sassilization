--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

hook.Add("OnRoundChange", "InputCaller", function()
	-- Makes the fog black for added spookyness.
	local fog = ents.FindByClass("env_fog_controller")[1]
	fog:Fire("SetColor", "0 0 0")
	fog:Fire("SetColorSecondary", "0 0 0")
	
	-- Disables sparks on the lasers so they don't cause lag.
	for k,v in pairs(ents.FindByClass("env_laser")) do
		v:SetKeyValue("spawnflags", "1")
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(32)