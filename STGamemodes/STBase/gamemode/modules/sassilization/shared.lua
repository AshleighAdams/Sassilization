--------------------
-- STBase
-- By Spacetech
--------------------

local IsAdmin = STGamemodes.PlayerMeta.IsAdmin
local IsSuperAdmin = STGamemodes.PlayerMeta.IsSuperAdmin

function STGamemodes:NumberToRank(Number)
	local Number = tonumber(Number)
	if(Number >= 1000) then
		return "owner"
	elseif(Number >= 500) then
		return "super"
	elseif(Number >= 400) then
		return "devmin"
	elseif(Number >= 100) then
		return "admin"
	elseif(Number >= 50) then
		return "mod"
	elseif(Number >= 10) then
		return "dev"
	elseif(Number >= 2) then 
		return "beta tester"
	elseif(Number >= 1) then
		return "vip"
	end
	return "guest"
end

function STGamemodes.PlayerMeta:GetRank()
	if(self and self:IsValid()) then
		if(game.SinglePlayer()) then
			return "space"
		end
		if(SERVER) then
			return tostring(self.Rank) or "guest"
		else
			return self:GetNWString("Rank", "guest")
		end
	end
	return ""
end

-- What have we here!?
function STGamemodes.PlayerMeta:IsReal()
	if(SERVER and TranqUsers and TranqUsers[self:SteamID()]) then
		return false
	end
	return true
end

function STGamemodes.PlayerMeta:IsMapper() 
	if !SERVER then return false end 

	return (self.Mapper and STGamemodes.GateKeeper.DevMode) 
end 

function STGamemodes.PlayerMeta:IsSuperAdmin()
	if(!self:IsReal()) then
		return
	end
	
	local Rank = self:GetRank()
	if(Rank == "super" or Rank == "owner" or Rank == "space" or Rank == "epic" or Rank == "devmin" or self.Spacetech) then
		return true
	end
	
	if(IsSuperAdmin) then
		return IsSuperAdmin(self)
	end
	
	return false
end

function STGamemodes.PlayerMeta:IsAdmin()
	if(!self:IsReal()) then
		return
	end
	
	local Rank = self:GetRank()
	if(Rank == "admin" or Rank == "ftw" or Rank == "goat" or Rank == "bhop" or self:IsSuperAdmin()) then
		return true
	end
	
	if(IsAdmin) then
		return IsAdmin(self)
	end
	
	return false
end

function STGamemodes.PlayerMeta:IsMod()
	if(!self:IsReal()) then
		return
	end
	local Rank = self:GetRank()
	if(Rank == "mod" or self:IsAdmin()) then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:IsRadio()
	if(!self:IsReal()) then
		return
	end
	local Rank = self:GetRank()
	if(Rank == "radio") then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:IsDev()
	if(!self:IsReal()) then
		return
	end
	
	if(self:GetRank() == "dev" or self:IsMod()) then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:IsBetaTester() 
	if(!self:IsReal()) then
		return
	end
	
	if(self:GetRank() == "beta tester" or self:IsDev()) then
		return true
	end
	return false 
end 

function STGamemodes.PlayerMeta:IsVIP()
	if(!self:IsReal()) then
		return
	end
	
	local Rank = self:GetRank()
	if(Rank == "vip" or self:IsBetaTester()) then
		return true
	end
	return false
end

function STGamemodes.PlayerMeta:GetMoney()
	if(SERVER) then
		return self.Dough or 0
	end
	if(self:GetNWInt("FakeDough", -1) > 0) then
		return self:GetNWInt("FakeDough", -1)
	end
	return self:GetNWInt("Dough", 0)
end

function STGamemodes.GetPrefix(ply)
	if(ply:IsSuperAdmin()) then
		return "(SUPER)"
	elseif(ply:IsAdmin()) then
		return "(ADMIN)"
	elseif(ply:IsMod()) then 
		return "(MOD)"
	end
	return "(DEV)"
end