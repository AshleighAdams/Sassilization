--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Killers = {}
STGamemodes.Killers.Killers = {}

function STGamemodes.Killers:Add(Class, Text)
	local Class = string.Trim(string.lower(Class))
	self.Killers[Class] = Text
	if(CLIENT) then
		language.Add(Class, Text)
		killicon.AddAlias(Class, "default")
	end
end

STGamemodes.Killers:Add("weapon_scythe", "Scythe")
STGamemodes.Killers:Add("weapon_sass_smg", "SassSMG")

STGamemodes.Killers:Add("worldspawn", "The World")

STGamemodes.Killers:Add("func_door", "Door")
STGamemodes.Killers:Add("func_rotating", "Rotating Death Spinner")
STGamemodes.Killers:Add("func_door_rotating", "Rotating Death Spinner")

STGamemodes.Killers:Add("func_movelinear", "Moving Platform")
STGamemodes.Killers:Add("func_breakable", "Spotaneously Combusted")

STGamemodes.Killers:Add("trigger_hurt", "Mystic Force")
STGamemodes.Killers:Add("point_hurt", "Mystic Force")

STGamemodes.Killers:Add("env_fire", "Fire")
STGamemodes.Killers:Add("env_beam", "Beam of Death")
STGamemodes.Killers:Add("env_explosion", "Explosion")
STGamemodes.Killers:Add("env_laser", "Laser of Death")
STGamemodes.Killers:Add("prop_combine_ball", "Balls of Combine")

STGamemodes.Killers:Add("func_physbox", "Deadly Physbox")
STGamemodes.Killers:Add("prop_physics_override", "Deadly Prop")
STGamemodes.Killers:Add("prop_physics_respawnable", "Deadly Prop")
STGamemodes.Killers:Add("prop_physics_multiplayer", "Deadly Prop")
STGamemodes.Killers:Add("func_physbox_multiplayer", "Deadly Physbox")

STGamemodes.Killers:Add("trigger_waterydeath", "Leeches")
STGamemodes.Killers:Add("trigger_physics_trap", "A TRAP!")
STGamemodes.Killers:Add("point_tesla", "Painful Tesla")
