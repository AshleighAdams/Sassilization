--------------------
-- STBase
-- By Spacetech
--------------------

local FakeModels = {
	"Zombie",
	"Eli",
	"Riot",
	"Urban",
	""
}
for i=1,4 do table.insert(FakeModels, "Hostage ".. tostring(i)) end 
for i=1,12 do table.insert(FakeModels, "Male ".. tostring(i)) table.insert(FakeModels, "Female ".. tostring(i)) end 

local FakeHats = {
	"American Hat",
	"Cowboy Hat",
	"Party Hat2",
	"Cake Hat",
	"Cheese Hat",
	""
}

local FakeTrails = {
	"Angry",
	"Happy",
	"Star",
	"Coffee",
	"Fire",
	"Musical Notes",
	"Burger",
	""
}

---------------------------------------

STGamemodes.FakeName = {}
STGamemodes.FakeName.List = {}
STGamemodes.FakeName.Col = Color(0, 190, 255, 255)
-- STGamemodes.FakeName.Filename = "fakenames.txt"

function STGamemodes.FakeName:CanFakeName(ply)
	return ply:IsMod()
end

function STGamemodes.FakeName:Load()
	if !self.Filename then 
		if STGamemodes.ServerDirectory then 
			self.Filename = STGamemodes.ServerDirectory .."/fakenames.txt" 
		else 
			timer.Simple( 0.1, function() self.Load(self) end )
			return 
		end 
	end 

	if(!file.Exists(self.Filename,"")) then
		file.Write(self.Filename, "")
		return
	end

	local Read = file.Read(self.Filename) or ""
	for k,v in pairs(string.Explode("\n", Read)) do
		local Sep = string.Explode("|", v)
		if(Sep[1] and Sep[1] != "" and Sep[2] and Sep[2] != "" and Sep[3] and Sep[3] != "") then
			print(tobool(string.Trim(Sep[3])))
			self.List[string.Trim(Sep[1])] = {Name=string.Trim(Sep[2]), VIP=tobool(string.Trim(Sep[3]))}
		end
	end
end

function STGamemodes.FakeName:Save()
	if !self.Filename then 
		if STGamemodes.ServerDirectory then 
			self.Filename = STGamemodes.ServerDirectory .."/fakenames.txt" 
		else 
			timer.Simple(0.1, function() self:Save() end) 
			return 
		end 
	end 

	local Buffer = ""
	for k,v in pairs(self.List) do
		Buffer = Buffer..k.."|"..v.Name.."|".. tostring(v.VIP) .."\n"
	end
	file.Write(self.Filename, Buffer)
end

function STGamemodes.FakeName:Update(SteamID, Name, VIP)
	if Name and (VIP == true or VIP == false) then 
		self.List[SteamID] = {Name=Name, VIP=VIP}
	else 
		self.List[SteamID] = nil 
	end 
	self:Save()
end

function STGamemodes.FakeName:CheckFake(ply)
	if(!self:CanFakeName(ply)) then
		return false
	end
	if(self.List[ply:SteamID()] and self:CanUseName(ply, self.List[ply:SteamID()].Name)) then
		self:SetName(ply, self.List[ply:SteamID()].Name, true, self.List[ply:SteamID()].VIP)
		return true
	else
		self:Update(ply:SteamID())
	end
	return false
end

function STGamemodes.FakeName:CanUseName(ply, Name)
	if(!Name) then
		return false
	end

	if type(Name) == "table" then 
		if(!Name.Name or !Name.VIP) then 
			return false 
		end 
	end 
	
	-- local Target = STGamemodes.FindByPartial(Name)
	-- if(type(Target) == "string") then
	-- 	return true
	-- elseif(IsValid(Target)) then
	-- 	return ply == Target
	-- end
	return true
end

function STGamemodes.FakeName:SetName(ply, Name, HideMessage, VIP)
	if(!Name) then
		return
	end
	-- if(string.lower(Name) == string.lower(ply:GetName())) then
	-- 	if(ply:IsFake()) then
	-- 		self:Unfake(ply)
	-- 	end
	-- 	return
	-- end

	if (Name:len() < 2 or Name:len() > 32) then
		ply:ChatPrint("Your name can only contain 2-32 characters.")
		return
	end

	if(!ply:IsFake()) then
		if(!HideMessage) then
			STGamemodes:PrintAll(ply:GetName().." has left the server")
		end 
	end	

	if VIP then
		ply:SetNWString("Rank", "vip")
	else 
		ply:SetNWString("Rank", "guest")
	end
	
	ply.FakeModel = table.Random(FakeModels)
	ply.FakeHat = table.Random(FakeHats)
	ply.FakeTrail = table.Random(FakeTrails)

	ply:SetNWString("FakeName", Name)
	ply:SetNWInt("FakeDough", math.random(2000, 25000))
	STGamemodes:CustomChat("[FAKENAME]", ply:GetName().." is now "..Name, self.Col, self.Col, function(ply) return self:CanFakeName(ply) end)
	self:Update(ply:SteamID(), Name, VIP)
end

function STGamemodes.FakeName:Unfake(ply)
	ply.FakeModel = nil 
	ply.FakeHat = nil 
	ply.FakeTrail = nil 

	ply:SetNWInt("FakeDough", -1)
	ply:SetNWString("FakeName", "")
	ply:SetNWString("Rank", ply.Rank)
	STGamemodes:PrintAll(ply:GetName().." has entered the server")
	STGamemodes:CustomChat("[FAKENAME]", ply:GetName().." is now back to normal", self.Col, self.Col, function(ply) return self:CanFakeName(ply) end)
	self:Update(ply:SteamID())
end

function STGamemodes.FakeName:Command(ply, cmd, args)
	if(!self:CanFakeName(ply)) then
		return
	end
	
	local VIP = tonumber(args[1])
	if VIP and VIP == 1 then 
		VIP = true 
		table.remove(args, 1)
	else
		if VIP == 0 then table.remove(args, 1) end 
		VIP = false 
	end 

	local Name = string.Trim(table.concat(args, " "))
	if(Name == "") then
		if(ply:IsFake()) then
			self:Unfake(ply)
		end
	elseif(self:CanUseName(ply, Name)) then
		self:SetName(ply, Name, nil, VIP)
	else
		ply:ChatPrint("You can't use that name!")
	end
end

concommand.Add("st_fakename", function(ply, cmd, args)
	STGamemodes.FakeName:Command(ply, cmd, args)
end)
