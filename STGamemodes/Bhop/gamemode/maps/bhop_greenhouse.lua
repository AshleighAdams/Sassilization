--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(15738.71875, -3564.4375, 129.5625))

-- Disables the flower pots' motion.
hook.Add("InitPostEntity", "InputCaller", function()
	for k,v in pairs(ents.FindByClass("prop_physics")) do
		v:Fire("DisableMotion")
	end
end)