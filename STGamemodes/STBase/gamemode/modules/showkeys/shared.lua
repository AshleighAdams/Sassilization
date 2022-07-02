STGamemodes.ShowKeys = {}
STGamemodes.ShowKeys.Filter = {
	Default		= {IN_FORWARD,IN_BACK,IN_MOVELEFT,IN_MOVERIGHT,IN_JUMP,IN_DUCK},
	Deathrun	= {IN_FORWARD,IN_BACK,IN_MOVELEFT,IN_MOVERIGHT,IN_JUMP,IN_DUCK,IN_USE}
}

function STGamemodes.ShowKeys:GetFilter()
	local filter = self.Filter[GAMEMODE.Name]
	return filter and filter or self.Filter.Default
end