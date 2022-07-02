--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(4025, -814, 48))
STGamemodes.Weapons:Add(Vector(5981, 471, 40))
STGamemodes.Weapons:Add(Vector(3813, -3244, 144))

STGamemodes.KeyValues:AddChange( "trp7", "movedistance", "250" )

hook.Add("EntityKeyValue", "KeyValueChanger", function(ent, key, value)
	if ent:GetName() == "trp7" and key == "movedistance" then
		return "250"
	end
end)

STGamemodes.Buttons:SetupLinkedButtons(16)