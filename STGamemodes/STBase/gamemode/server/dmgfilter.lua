--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.DamageFilter = {}
STGamemodes.DamageFilter.Enabled = false 
STGamemodes.DamageFilter.Areas = {}

function STGamemodes.DamageFilter:SetEnabled(bool)
	self.Enabled = bool or true 
end 

function STGamemodes.DamageFilter:Add( vec, distance, filter )
	if type(vec) != "Vector" then 
		return 
	elseif type(distance) != "number" then 
		return 
	end 

	table.insert(self.Areas, {vec, distance, filter})

	self:SetEnabled()
end 

function STGamemodes.DamageFilter:Check( ply, DmgInfo )
	if !self.Enabled or !ply:IsValid() or !ply:IsPlayer() or !ply:Alive() then return end 

	local Pos = ply:GetPos()
	for k,v in pairs(self.Areas) do 
		if Pos:Distance(v[1]) <= v[2] then 
			if type(v[3]) == "function" then 
				return v[3](ply, DmgInfo)
			else 
				if DmgInfo:GetDamageType() == v[3] then 
					DmgInfo:SetDamage(0)
					DmgInfo:ScaleDamage(0)
					return DmgInfo 
				end 
			end 
		end 
	end 
end 