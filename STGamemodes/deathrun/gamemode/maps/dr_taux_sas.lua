--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	-- Fixes Taux's mangled spelling on the beginning text.
	if key == "message" and value == "Sassalization" then
		return "Sassilization"
	end

	-- Makes the trigger in the doorway leading to the death area disable the jumprope teleporter.
	if ent:GetClass() == "trigger_once" and value == "end5,Disable,,0,-1" then
		ent:SetKeyValue("end7", "Disable,,0,-1")
	end
end)

STGamemodes.KeyValues:AddChange( "t13a", "dmg", "1000" )