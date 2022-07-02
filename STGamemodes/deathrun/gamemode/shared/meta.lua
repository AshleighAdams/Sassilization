--------------------
-- STBase
-- By Spacetech
--------------------

local Alive = STGamemodes.PlayerMeta.Alive

function STGamemodes.PlayerMeta:Alive()
	if(STValidEntity(self) and self:Team() == TEAM_DEAD) then
		return false
	end
	return Alive(self)
end

function STGamemodes.EntityMeta:IsButton()
	if self and self:IsValid() then
		return (self:GetClass() == "func_button" || self:GetClass() == "func_rot_button")
	else
		return false
	end
end

function STGamemodes.EntityMeta:GetClaimed() --Edited
	if self:IsLinkedButton() then
		self = self:GetRootNode()
	end
	
	return self.Claimer
end

function STGamemodes.EntityMeta:UnClaim() --Edited
	if self:IsLinkedButton() then
		self = self:GetRootNode()
	end
	
	if(SERVER) then
		if(self.Claimer) then
			self.Claimer = nil
			self:UpdateClaimed()
		else
			self.Claimer = nil
		end
	else
		self.Claimer = nil
	end
end

function STGamemodes.EntityMeta:CheckClaimed() --Edited
	
	local Claimer = self:GetClaimed()
	if(Claimer) then
		if(IsValid(Claimer)) then
			if(Claimer:Alive() and Claimer:GetPos():Distance(self:GetPos()) <= 256) then -- Button is still claimed
				return Claimer
			elseif Claimer:Alive() and self:IsLinkedButton() then --Special case for linked buttons, we have to be within 256 units of one of the group.
				if self:GetRootNode():CheckLinkedDistance(Claimer,256) <= 256 then --check distance between all nodes of a group, if its <= 256 it returns a number or true as numb
					return Claimer
				else
					Claimer:UnClaimButton() --Otherwise is unclaimed
				end
			else
				Claimer:UnClaimButton()
			end
		else
			self:UnClaim()
		end
	end
	return false
end

function STGamemodes.PlayerMeta:ClaimButton(Button) --Edited
	if SERVER and !STGamemodes.Buttons:CanClaimButton( Button ) then return end
	if Button:IsLinkedButton() then
		Button = Button:GetRootNode()
	end
	self:UnClaimButton()
	self.ClaimedButton = Button
	self.ClaimedButton.Claimer = self
	if(SERVER) then
		
		self.ClaimedButton:UpdateClaimed()
	end
end

function STGamemodes.PlayerMeta:UnClaimButton()
	if(self.ClaimedButton) then
		if(IsValid(self.ClaimedButton)) then
			self.ClaimedButton:UnClaim()
		end
		self.ClaimedButton = nil
		-- print("UnClaimButton")
	end
end

function STGamemodes.EntityMeta:IsLinkedButton()
	if self:GetChildNodes() or self:GetParentNode() then
		return true
	else
		return false
	end
end

function STGamemodes.EntityMeta:GetParentNode()
	return self.parent
end

function STGamemodes.EntityMeta:GetChildNodes()
	return self.linked
end

function STGamemodes.EntityMeta:GetRootNode()
	if self:GetParentNode() then
		return self:GetParentNode():GetRootNode()
	else
		return self
	end
end

function STGamemodes.EntityMeta:LinkedToTable() --Create a table of all from the root node.
	local btns = {}
	if self:IsButton() and self:IsLinkedButton() then
		for k,v in pairs(self:GetChildNodes()) do
			local res = v:LinkedToTable()
			table.Add(btns,res)
		end
		table.insert(btns,self)
	end
	return btns
end

function STGamemodes.EntityMeta:SetParentNode(ent)
	self:CreateLinkTable()
	self.parent = ent
end

function STGamemodes.EntityMeta:AddChildNode(ent)
	if not ent then return end
	self:CreateLinkTable()
	
	
	if not table.HasValue(self.linked,ent) and ent != self:GetRootNode() then --Don't allow a root node of a child to be added as a child, avoiding a graph structure.
		table.insert(self.linked,ent)
		ent:SetParentNode(self)
	end
end

function STGamemodes.EntityMeta:CheckLinkedDistance(ply,minDist)
	
	local dist = 2*minDist
	
	if self:GetChildNodes() then //Case for odd time the second button gets removed or no longer is a child node.
		for k,v in pairs(self:GetChildNodes()) do
			dist = math.min(dist,v:CheckLinkedDistance(ply,minDist))
			if dist <= minDist then
				return dist
			end
		end
	end
	if self and self:IsValid() then
		dist = self:GetPos():Distance(ply:GetPos())
	end
	
	return dist
end	

function STGamemodes.EntityMeta:CreateLinkTable() 
	if not self.linked then
		self.linked = {} --Children nodes.
	end
end

function STGamemodes.EntityMeta:CheckTree(node)
	if self == node then
		return true
	end
	
	for k,v in pairs(self:GetChildNodes()) do
		if self:CheckTree(v) then
			return true
		end
	end
	
	return false
end

function STGamemodes.EntityMeta:LinkButton(btn) 
	self:CreateLinkTable()
	-- print('Checking tree',self,btn)
	if STGamemodes:CheckTree(self:GetRootNode(),btn) then
		return
	end
	-- print('Past checking tree',self,btn)
	if not self:GetParentNode() and not btn:GetParentNode() then --Parent is nil when it isn't a parent so not parentnode being true, meaning it has no parent or is a root node
		self:AddChildNode(btn)
		
	elseif not self:GetParentNode() and btn:GetParentNode() then -- if self is a root parent and btn is not
		self:AddChildNode(btn:GetRootNode()) --Set btn's root node as a child of self, adding the tree.
		
	elseif self:GetParentNode() and not btn:GetParentNode() then -- if self is a child and btn is a root node.
		btn:AddChildNode(self:GetRootNode()) --if self is a child and btn is a root, set self's root node as child of btn.
		
	elseif self:GetParentNode() and btn:GetParentNode() then --if neither are a root node.
		self:AddChildNode(btn:GetRootNode()) 
		
	end
	
end


function STGamemodes:CheckTree(root, ent) 
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