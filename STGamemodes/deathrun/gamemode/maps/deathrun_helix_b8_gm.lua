--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("OnRoundChange", "EntityParenter", function()
	STGamemodes.KeyValues:AddChange( "Medic", "parentname", "ttrwwetr" )
end)

hook.Add("OnRoundChange", "EntityDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(-2866.2, 2080.7, 1405), 1568)) do
		v:Remove()
	end
end)

-- Second stage keypad button fix.
STGamemodes.KeyValues:AddChange( 708, "OnPressed", "ww1,Break,,0,1" )
--[[ STGamemodes.KeyValues:AddChange( 708, "wait", "0" )
STGamemodes.KeyValues:AddChange( 708, "spawnflags", "1025" ) ]]

STGamemodes.Buttons:SetupLinkedButtons(16)