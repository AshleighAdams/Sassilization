--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues = {}
STGamemodes.KeyValues.Enabled = false
STGamemodes.KeyValues.Entities = {}
STGamemodes.KeyValues.KeyValues = {}

function STGamemodes.KeyValues:AddChange( pos, keyvalue, value )
	table.insert( self.KeyValues, {pos, keyvalue, value} )
	self.Enabled = true
end

function STGamemodes.KeyValues:Run()
	gamemode.Call( "PostKeyValues" )
	if !self.Enabled then return end
	self.Entities = {}
	-- table.Empty(self.Entities)
	for k,v in pairs( self.KeyValues ) do
		local ent
		local Type = type(v[1])
		if Type == "string" then
			ent = ents.FindByName( v[1] )
		elseif Type == "Vector" then
			ent = ents.FindInSphere( v[1], 1 )[1]
		elseif Type == "number" then
			ent = ents.GetByIndex( v[1] )
		elseif Type == "Entity" then
			ent = v[1]
		end
		Type = type( ent )
		if Type == "table" then
			for k2,v2 in pairs( ent ) do
				table.insert( self.Entities, {v2, v[2], v[3]} )
			end
		else
			table.insert( self.Entities, {ent, v[2], v[3]} )
		end
	end
	for k,v in pairs( self.Entities ) do
		if !v[1]:IsValid() then return end
		if type(v[2]) == "function" then
			v[2](v[1])
		else
			v[1]:SetKeyValue( v[2], v[3] )
		end
	end
end