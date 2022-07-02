--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Buttons = {}
STGamemodes.Buttons.Buttons = {}
STGamemodes.Buttons.Positions = {}

function STGamemodes.Buttons:AddUnclaimableButtons( Position, Radius )
	self.Positions[Position] = Radius
end

function STGamemodes.Buttons:RunNow()
	table.Empty( self.Buttons )
	for k,v in pairs( self.Positions ) do
		for _, ent in pairs(ents.FindInSphere( k, v )) do
			if ent:IsButton() and !table.HasValue( self.Buttons, ent ) then
				table.insert( self.Buttons, ent )
			end
		end
	end
	hook.Call('ButtonLinker',STGamemodes)
end

function STGamemodes.Buttons:CanClaimButton( button )
	return !table.HasValue( self.Buttons, button )
end

function STGamemodes.Buttons:TraverseButtonCheck(btn)
	if btn:CheckClaimed() then
		return false
	else
		for k,v in pairs(btn:GetChildNodes()) do
			if not self:TraverseButtonCheck(v) then
				return false
			end
		end
	end
	return true
end

function STGamemodes.Buttons:LinkButtons(args) --Recursive function that inefficiently (in my opinion) links a button as a group
	local argType = type(args)
	if argType == 'table' and table.maxn(args) >= 1 then
		if type(args[1])=='string' then
			local btns = {}
			for k,v in pairs(args) do --Get all entities sharing that name in the table of buttons.
				table.Add(btns, ents.FindByName(v))
			end
			self:LinkButtons(btns) --Call a recursion to startworking on the entities.
		elseif type(args[1]) == 'Entity' then
			for _,b in pairs(args) do
				if b:IsButton() then
					for k,v in pairs(args) do
						if v:IsButton() then
							b:LinkButton(v)
						end
					end
				end
			end
		elseif type(args[1]) == 'Vector' then
			local btns = ents.FindInBox(args[1],args[2]) --Get all 
			for _,btn in pairs(btns) do  -- Loop through all entities
				if btn:IsButton() then --If a button
					for k,v in pairs(btns) do --Loop through the list to link
						if v:IsButton() then --If its a button
							btn:LinkButton(v) --Link the button
						end
					end
				end
			end
		end
	elseif argType == 'number' then
		local btns = ents.FindByClass('func_button')
		table.Add(btns,ents.FindByClass('func_rot_button'))
		
		for _,b in pairs(btns) do
			for k,v in pairs(ents.FindInSphere(b:GetPos(),args)) do
				if v:IsValid() and v:IsButton() and v!=b then
					b:LinkButton(v)
				end
			end
		end
	end
end

--Takes a table of entity names, a table of 2 vectors, table of entities, or a number radius to link buttons with.
--Dist is the max distance between the player and any of the group's buttons before unclaiming it.
function STGamemodes.Buttons:SetupLinkedButtons(arg,dist) 
	STGamemodes.Buttons.LinkedDistanceOverride = dist or 256 --If passed an ovveride value then use it, else default to 256, this won't be necessary for most maps.
	hook.Add('ButtonLinker','LinkButtons '..tostring(arg),function()
		STGamemodes.Buttons:LinkButtons(arg)
	end)
	-- umsg.Start('STGamemodes.LinkedButtonDistOverride')
		-- umsg.Short(dist)
	-- umsg.End()
end

function STGamemodes.Buttons:CheckTree(root, ent) 
	-- if not root then return false end --If root node is false/nil then in itself is its root node
	if root == ent then
		return true
	end	
	
	for k,v in pairs(root:GetChildNodes()) do
		if self:CheckTree(v,ent) then
			return true
		end
	end
	
	return false
end
