--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team)
	if(!self or !self:IsValid()) then
		return
	end
	if(!Team) then
		return
	end
	local CurrentTeam = self:Team()
	if(CurrentTeam == Team) then
		return
	end

	if Team == TEAM_SPEC then gamemode.Call( "OnSpec", self ) end 
	
	self:KillTrail()
	self:SetTeam(Team)
	self:Spawn()
end

function STGamemodes.PlayerMeta:PayoutMsg()
	local WinMoney, NoSaveWinMoney = STGamemodes:GetWinAmts(self, true)
	self:ChatPrint("You will win "..tostring(WinMoney).." dough for saving or "..tostring(NoSaveWinMoney).." dough for nosaving")
end

function STGamemodes.PlayerMeta:GetSaveCount()
	if not self:IsValid() or not self.saveCount then return 0 end
	return self.saveCount
end

function STGamemodes.PlayerMeta:ResetSaveCount()
	if !self:IsValid() then return end
	self.saveCount = 0
end

function STGamemodes.PlayerMeta:IncrementSaveCount()
	if not self:IsValid() then return end
	if not self.saveCount then
		self.saveCount = 0
	end
	self.saveCount = self.saveCount + 1
end

//Possibly fake link to PlayerMeta's fail count related functions to use as Teleport counter instead of making new functions.