--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(246.76625061035, 2809.2946777344, 128.03125))

-- Disables the physics props' motion.
hook.Add("InitPostEntity", "InputCaller", function()
	for k,v in pairs(ents.FindByClass("prop_physics*")) do
		v:Fire("DisableMotion")
	end
end)

STGamemodes.KeyValues:AddChange( "end_house", "origin", "476 2896 176.8891" )