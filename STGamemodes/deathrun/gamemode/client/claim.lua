--------------------
-- STBase
-- By Spacetech
--------------------

local Buttons = {}

usermessage.Hook("STGamemodes.ClaimButton", function(um)
	local amt = um:ReadShort()
	local btn = um:ReadEntity()
	if not btn or not btn:IsValid() then return end
	Buttons[btn] = true
	for i=2,amt do --For the amount of object sets sent, and will only trigger if there are a pair of grouped buttons at least.

		local Button = um:ReadEntity() --Get the entity
		Buttons[Button] = true --Set for it to loop through in OnHudPaint
		-- btn:LinkButton(Button) --Technically isn't necessary as EntityMeta:LinkedToTable returns then in a depth-first order from left first child to last child (left to right)
								  -- Though it may be a good idea to keep it just in case the table sent swapped 2 items places causing a child node of some parent to be the parents parent, while still being teh child. Thus causing a stack overflow (inf loop) within the code's logic.
		btn:AddChildNode(Button) --Adds it the an arbitrary root node.
	end
		local Claimed = um:ReadBool() --Get if it was claimed or not
		 
		if(Claimed) then --If claimed read the entity, and set the owner
			Owner = um:ReadEntity()
			Owner:ClaimButton(btn)
		else --If not, check if it was claimed, and if it was, remove the claim.
			local WasClaimed = btn:CheckClaimed()
			if(WasClaimed) then
				WasClaimed:UnClaimButton()
				-- if btn:IsLinkedButton() then
					-- for k,v in pairs(btn:GetChildNodes()) do
						-- //v.Claimer = nil --Undo the owner clientside
						-- v.linked = nil --Undo the table for now, though may not even have to in reality.
						-- v.parent = nil --Undo the parent, fixes a spammy bug clientside, everyones happy.
					-- end
				-- end
			end
		end
end)

local TagOffset = Vector(0, 0, 5)
local TagEnd = "'s Button"

function GM:OnHUDPaint()
	if(LocalPlayer():Team() != TEAM_DEATH) then
		return
	end
	surface.SetFont("TabLarge")
	local Pos = LocalPlayer():EyePos()
	for k,v in pairs(Buttons) do
		if(IsValid(k)) then
			local Distance = 900
			
			if  k:IsLinkedButton() then
				Distance = k:GetRootNode():CheckLinkedDistanceVec(Pos,640) --Do same check as on server regarding any node within the group.
			else
				Distance = k:GetPos():Distance(Pos)
			end
			
			if(Distance <= 640 ) then
				local Claimer = k:CheckClaimed()
				if(Claimer) then
					if not k:IsLinkedButton() then
						self:PaintTag(Claimer:CName()..TagEnd, (k:GetPos() + TagOffset):ToScreen(), math.Min((640 - Distance + 200) / 640, 1))
					else
						self:PaintTag(Claimer:CName()..TagEnd..' Group', (k:GetPos() + TagOffset):ToScreen(), math.Min((640 - Distance + 200) / 640, 1))
					end
				end
			end
		end
	end
end

function STGamemodes.EntityMeta:CheckLinkedDistanceVec(vec,minDist)
	
	local dist = 2*minDist
	
	if self:GetChildNodes() then //Case for odd time the second button gets removed or no longer is a child node.
		for k,v in pairs(self:GetChildNodes()) do
			dist = math.min(dist,v:CheckLinkedDistanceVec(vec,minDist))
			if dist <= minDist then
				return dist
			end
		end
	end
	if self and self:IsValid() then
		dist = self:GetPos():Distance(vec)
	end
	
	return dist
end	