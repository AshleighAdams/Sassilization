/*---------------------------------------------------------
	Map Difficulty Levels
	
	Difficulty levels are saved by disabling
	func_brush entities (Enabled nodraw)
---------------------------------------------------------*/
GM.Difficulties = {}
function GM:AddDifficulty( name, targetname )
	table.insert( self.Difficulties, { Name = name, Target = targetname })
	return targetname
end

function GM:GetNextDifficulty()
	for k, tbl in pairs(self.Difficulties) do
		if tbl.Enabled then
			local nextDifficulty = tbl[k+1]
			if !nextDifficulty then
				nextDifficulty = tbl[1]
			end
			
			return nextDifficulty
		end
	end
end

function GM:EnableDifficulty(targetname)
	for _, tbl in pairs(self.Difficulties) do
		local ent = self:GetDifficultyEntity(tbl.Target)
		if tbl.Target == targetname then
			ent:Fire("Disable","",0)
			tbl.Enabled = true
		else
			ent:Fire("Enable","",0)
			tbl.Enabled = false
		end
	end
end

function GM:GetDifficultyEntity(targetname)
	local entities = ents.FindByName(targetname)
	if #entities > 0 then
		return entities[1]
	end
end

function GM:IsDifficultyEnabled(targetname)
	local ent = self:GetDifficultyEntity(targetname)
	if IsValid(ent) && ent:IsEffectActive(EF_NODRAW) then
		return true
	end
	
	return false	
end

function GM:CheckDifficultySettings()
	-- Update difficulty values
	for _, tbl in pairs(self.Difficulties) do
		tbl.Enabled = self:IsDifficultyEnabled(tbl.Target)
	end
	
	-- Force next difficulty level
	if self.NextDifficulty then
		self:EnableDifficulty(self.NextDifficulty)
	end
end
