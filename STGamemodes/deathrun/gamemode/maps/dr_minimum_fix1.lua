--------------------
-- STBase
-- By Spacetech
--------------------

-- Makes the buttons not reusable.
hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetClass() == "func_button" and key == "wait" then
		return "-1"
	end
end)

-- Fix for the black screen overlay.
hook.Add("OnRoundChange", "EntityDestroyer", function()
	ents.FindByName("overlay")[1]:Remove()
end)

STGamemodes.Buttons:SetupLinkedButtons(16)