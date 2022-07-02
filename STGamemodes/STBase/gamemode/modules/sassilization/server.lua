--------------------
-- STBase
-- By Spacetech
--------------------
/*
STGamemodes.Mods = {
	-- "STEAM_0:0:21628567", // Pez
	//"STEAM_0:0:25549611", // Mozart
	"STEAM_0:0:11321986", //  ith - 
	"STEAM_0:0:17460709", //  Attacking Pants - 
	"STEAM_0:0:15556336", //  S!cojnr - 
	"STEAM_0:1:26310864", //  Yonsje - 
	"STEAM_0:0:7349560", //  Shooter - 
	"STEAM_0:1:19443305", //  Aced - 
	"STEAM_0:1:13579847", //  Comri3 - 
	"STEAM_0:1:14553378", //  Willstep -
}
*/

concommand.Add("st_moneyloaded", function(ply)
	ply.MoneyLoading = nil
end)

concommand.Add("st_playeronrank", function(ply)
	ply.RankLoading = nil
end)

local function CheckMoneyLoaded(ply)
	if(!STValidEntity(ply)) then
		return
	end
	if(!ply.MoneyLoading) then
		return
	end
	if(ply.RequestSuccess) then
		umsg.Start("MONEY.amount", ply)
			umsg.Long(ply.InitMoney)
		umsg.End()
	end
	timer.Simple(1, function() CheckMoneyLoaded(ply) end )
end

local function CheckPlayerOnRank(ply)
	if(!STValidEntity(ply)) then
		return
	end
	if(!ply.RankLoading) then
		return
	end
	umsg.Start("PlayerOnRank", ply)
		umsg.Bool(ply:IsVIP())
	umsg.End()
	timer.Simple(1, function() CheckPlayerOnRank(ply) end )
end

function GM:PlayerOnRank(ply, rank)
	if(!STValidEntity(ply)) then
		return
	end
	
	ply:SetMoney(ply.InitMoney)
	ply.InitSetMoney = true
	
	ply.MoneyLoading = true
	timer.Simple(1, function() CheckMoneyLoaded(ply) end )
	
	ply.RankLoading = true
	timer.Simple(1, function() CheckPlayerOnRank(ply) end )
	
	STGamemodes:PrintAll(ply:CName().." has entered the server")
	
	if(ply:IsAdmin()) then
		umsg.Start("activate_admin", ply)
		umsg.End()
	elseif(ply:IsMod()) then
		umsg.Start("activate_mod", ply)
		umsg.End()
	end
end

function GM:ShouldRank(ply, Rank, FakeRank)
	local Fake = STGamemodes.FakeName:CheckFake(ply)
	if(!Fake) then
		if(ply.Rank != "guest" or FakeRank) then
			ply:SetNWString("Rank", FakeRank or ply.Rank)
		end
	end
end 

function GM:GroupCheck(ply) 
	http.Fetch("<URL REPLACE>"..ply:SteamID(), function(c) 
		if ply:IsValid() then 
			if c and c != "" and (c == "1" or c == "0") and (string.find(c, "<html>") and string.find(c, "</html>")) then
				local Bool = tobool(c) 
				ply:SetNWBool("InGroup", Bool)
				if !Bool then 
					ply:ChatPrint("Join our group @ steamcommunity.com/groups/Sassilization") 
				end 
			end  
		end 
	end )
end 

STGamemodes.BotRanks = {
	-- "admin",
	-- "super",
	-- "dev",
	-- "mod",
	"vip",
	"guest",
}
function STGamemodes.PlayerMeta:PrecacheGetRank(Rank)
	local SteamID = self:SteamID()
	if(SteamID == "STEAM_0:0:7722759") then
		SPACETECH = self
		self.Spacetech = true
		-- self:SetNWString("Rank", "space")
	elseif(SteamID == "STEAM_0:0:25464234") then
		AARON = self
		self.Aaron = true
		self.DevMin = true
		gamemode.Call("ShouldRank", self, "devmin")
	end
	if(!tmysql) then
		ErrorNoHalt("tmysql: No PrecacheGetRank\n")
		return
	end
	tmysql.query("SELECT rank,money,username,password,money_temp,settings,playtime,playername,last_ip,playerid from sa_misc WHERE steamid=\'"..SteamID.."\'", function(Res, stat, err)
		if(!self or !self:IsValid()) then
			return
		end
		if(err != 0 or !stat) then
			timer.Simple(1, function()
				if(STValidEntity(self)) then
					self:PrecacheGetRank()
				end
			end)
			ErrorNoHalt("STGamemodes.PlayerMeta:PrecacheGetRank - "..self:SteamID().." - "..self:CName().." - "..tostring(err).." - "..tostring(stat).." - Timer Reloading")
			return
		end
		-- self:SetOnline(1)
		self.Rank = "guest"
		local FakeRank = false
		if(Res and Res[1] and Res[1][1]) then
			self.InitMoney = tonumber(Res[1][2])
			self.RankInt = Res[1][1]
			local Rank = STGamemodes:NumberToRank(Res[1][1])
			
			if(SteamID == "STEAM_0:0:12454744") then
				Rank = "epic"
				sass = self
				SASSAFRASS = self
				self.Sassafrass = true
			elseif(SteamID == "STEAM_0:0:145833") then
				COLD = self
				self.Cold = true
			elseif(SteamID == "STEAM_0:0:7722759") then
				Rank = "space"
				SPACETECH = self
				self.Spacetech = true
			elseif(SteamID == "STEAM_0:0:14782724") then
				UGLY = self
				self.Ugly = true
			elseif(SteamID == "STEAM_0:1:4556804") then
				AZUI = self
				self.Azui = true
			-- elseif(SteamID == "STEAM_0:0:14429753") then
			-- 	ECLIPSE = self
			-- 	self.Eclipse = true
			elseif(SteamID == "STEAM_0:1:15862026") then
				SAM = self
				self.Sam = true
				Rank = "super"
				FakeRank = "dev"
			elseif(SteamID == "STEAM_0:0:12607303") then
				BEN = self
				self.Ben = true
				Rank = "super"
				FakeRank = "dev"
			elseif(SteamID == "STEAM_0:1:9346397") then
				SNOIPA = self
				self.Snoipa = true
				Rank = "super"
				FakeRank = "dev"
			elseif(SteamID == "STEAM_0:0:25549611") then 
				MOZART = self 
				self.Mozart = true 
				self.GoodSuper = true 
			elseif(SteamID == "STEAM_0:0:8398971") then
				GIGGLES = self 
				self.Giggles = true 
				self.GoodSuper = true 
			elseif(SteamID == "STEAM_0:1:22006069") then
				ARCO = self
				self.Arco = true
				self.DevMin = true
			elseif(SteamID == "STEAM_0:0:25464234") then
				AARON = self
				self.Aaron = true
				self.DevMin = true
			elseif(SteamID == "STEAM_0:1:14416021") then
				DJDILL = self
				self.DJDill = true
				FakeRank = "radio"
			-- elseif(SteamID == "STEAM_0:1:4068069") then
			-- 	ROGUEOPS = self
			-- 	self.RogueOps = true
			-- 	FakeRank = "ftw"
			elseif(SteamID == "STEAM_0:0:16352676") then
				SCAPEGOAT = self
				self.Scapegost = true
				FakeRank = "goat"
			elseif(SteamID == "STEAM_0:1:28917624") then
				-- Secret
				FakeRank = "bhop"
			-- elseif(SteamID == "STEAM_0:0:5175965") then 
			-- 	-- TopShadow 
			-- 	FakeRank = "ftw"
			elseif(SteamID == "STEAM_0:0:14340930") then 
				ARCKY = self
				self.Arcky = true
				self.Mapper = true 
			elseif(SteamID == "STEAM_0:0:7699489") then
				SONIC = self
				self.Sonic = true
				self.Mapper = true
			elseif(SteamID == "STEAM_0:1:19343026") then
				BEATALEX = self
				self.BeatAlex = true
				self.Mapper = true
			elseif(self:IsBot()) then
				Bot = true
				Rank = table.Random(STGamemodes.BotRanks)
			end
			
			if(!Res[1][3] or Res[1][3] == "") then
				umsg.Start("Account.request.full", self)
				umsg.End()
			else
				self.account = Res[1][3]
				if(!Res[1][4] or Res[1][4] == "") then
					umsg.Start("Account.request.password", self)
						umsg.String(tmysql.escape(self.account))
					umsg.End()
				else
					self.password = Res[1][4]
				end
			end
			
			local moneytemp = Res[1][5]
			if(moneytemp) then
				moneytemp = tonumber(moneytemp)
				if(moneytemp > 0) then
					self.InitMoney = self.InitMoney + moneytemp
					tmysql.query("UPDATE sa_misc SET money = money + money_temp, money_temp = 0 WHERE steamid = \'"..SteamID.."\'")
				end
			end
			
			-- local Settings = Res[1][6]
			-- if(Settings) then
				-- Settings = tostring(Settings)
				-- if(Settings and string.Trim(Settings) != "") then
					-- Settings = Json.Decode(Settings)
					-- if(Settings and type(Settings) == "table") then
						-- local Gender = Settings["gender"]
						-- if(Gender) then
							-- if(Gender == "female") then
								-- FakeRank = "girl"
							-- end
						-- end
					-- end
				-- end
			-- end
			
			local Playtime = Res[1][7]
			if(Playtime) then
				Playtime = tonumber(Playtime)
				if(Playtime and Playtime > 0) then
					self.Playtime = Playtime
				end
			end
			
			local PlayerName = Res[1][8]
			if(PlayerName) then
				PlayerName = tostring(PlayerName)
				if(PlayerName and self:GetName() != PlayerName) then
					tmysql.query("UPDATE sa_misc SET playername=\'"..tmysql.escape(self:GetName()).."\' WHERE steamid = \'"..SteamID.."\'")
				end
			end
			
			local LastIP = Res[1][9]
			if(LastIP) then
				LastIP = tostring(LastIP)
				CurrentIP = string.Explode(":", self:IPAddress())[1]
				if(LastIP and CurrentIP != LastIP) then
					tmysql.query("UPDATE sa_misc SET last_ip=\'"..CurrentIP.."\' WHERE steamid = \'"..SteamID.."\'")
				end
			end


			local PlayerID = Res[1][10]
			if (PlayerID) then
				self.PlayerID = PlayerID
			else
				self.PlayerID = nil
			end			
			/*
			if(table.HasValue(STGamemodes.Mods, SteamID)) then
				Rank = "mod"
			end
			*/
			self.Rank = Rank
			gamemode.Call("GroupCheck", self)
			self:ChatPrint("Hello and welcome to Sassilization!  With the recent switch to Garry's Mod 13,") 
			self:ChatPrint("our gamemodes/servers have many bugs which we are working very hard to fix.") 
			self:ChatPrint("If you experience any of these bugs, please report it on the forums. We hope this") 
			self:ChatPrint("doesn't affect your time here at Sassilization too much.  Enjoy your stay!") 
			gamemode.Call("ShouldRank", self, self.Rank, FakeRank)
			
			-- self:ChatPrint("Your sassilization profile loaded successfully!")
		else
			self.Guest = true
			timer.Remove("SaveInfo."..SteamID)
			umsg.Start("Account.request.full", self)
			umsg.End()
			tmysql.query("INSERT INTO sa_misc (steamid,playername,money,online,settings) VALUES (\'"..SteamID.."\', \'"..tmysql.escape(self:GetName()).."\', "..tonumber(100)..",1, '[]')",1)
		end

		if(self.DevMin) then --For dev purpose. Leave.
			SPACETECH = self
			self.Spacetech = true
		end

		timer.Simple(0.1, function()
			if(IsValid(self)) then
				gamemode.Call("PlayerOnRank", self, self.Rank)
			end
		end)
	end)
end

function STGamemodes.PlayerMeta:CanUseMoney()
	if(!tmysql or self.Guest or !self.InitMoney) then
		return false
	end
	return true
end

function STGamemodes.PlayerMeta:SaveMoney()
	if(!self:CanUseMoney() or !self.InitSetMoney) then
		return
	end
	if(STGamemodes.EverFailed) then
		return
	end
	STGamemodes.Store:Debug(self, "GetMoney: "..tostring(self:GetMoney()).." - InitMoney: "..tostring(self.InitMoney), true)
	tmysql.query("UPDATE sa_misc SET money = money + "..tonumber(self:GetMoney() - self.InitMoney).." WHERE steamid = \'"..self:SteamID().."\'")
	self.InitMoney = self:GetMoney()
end

function STGamemodes.PlayerMeta:SetMoney(Amount, OrigAmount)
	if(!self:CanUseMoney()) then
		return
	end
	self.Dough = tonumber(Amount)
	self:SetNWInt("Dough", self.Dough)
	if self:IsFake() and OrigAmount then 
		self:SetNWInt("FakeDough", self:GetNWInt("FakeDough", 0) + OrigAmount ) 
	end 
	return true
end

function STGamemodes.PlayerMeta:GiveMoney(Amount, Message)
	if(!self:CanUseMoney()) then
		return
	end
	self:SetMoney(self:GetMoney() + tonumber(Amount), Amount)
	if(Message) then
		self:ChatPrint(string.format(Message, tostring(Amount)))
	end
	STAchievements:AddCount(self, "Pot of Dough", tonumber(Amount))
	return true
end

function STGamemodes.PlayerMeta:TakeMoney(Amount, Message)
	if(!self:CanUseMoney()) then
		return
	end
	self:SetMoney(self:GetMoney() - tonumber(Amount), -Amount)
	if(Message) then
		self:ChatPrint(string.format(Message, tostring(Amount)))
	end
	STAchievements:AddCount(self, "Doughful Loser", tonumber(Amount))
	return true
end

--------------------------------------------------------------------------------------------------------------------------------------

timer.Simple(5, function() require("cryptopp") end )

local function ValidAccount( pl, name, password )
	local messages = {}
	local length = string.len( name )
	if length < 4 then
		table.insert( messages, "Username is too short" )
	elseif length > 13 then
		table.insert( messages, "Username is too long" )
	end
	if string.len(string.gsub( name, "[%w_]", "" )) > 0 then
		table.insert( messages, "Username may only contain alphanumeric characters [a-z0-9] and '_'" )
	end
	length = string.len( password )
	if length < 4 then
		table.insert( messages, "Password is too short" )
	elseif length > 13 then
		table.insert( messages, "Password is too long" )
	end
	if string.len(string.gsub( password, "[%w_]", "" )) > 0 then
		table.insert( messages, "Password may only contain alphanumeric characters [a-z0-9] and '_'" )
	end
	if #messages > 0 then
		for _, msg in pairs( messages ) do
			pl:PrintMessage( HUD_PRINTCONSOLE, msg )
		end
		return false
	else
		return true
	end
end

function LinkAccount_cc( pl, command, args )
	if !(STValidEntity(pl) and pl:IsPlayer() and pl:SteamID()) then return end
	if pl.account then
		umsg.Start( "account.Close", pl )
		umsg.End()
		pl:PrintMessage( HUD_PRINTCONSOLE, "You have already created your account." )
		return
	end
	local steamid = pl:SteamID()
	local name = args[1]
	local pass = args[2]
	if !name or !pass then return end
	local succ = ValidAccount( pl, name, pass )
	if !succ then return end
	tmysql.query("SELECT * FROM sa_misc WHERE LOWER(username) = \'" .. string.lower(tmysql.escape(name)) .. "\'", function( usernames, status, error )
		if(!pl or !pl:IsValid()) then
			return
		end
		if error != 0 then Error( error ) end
		if usernames[1] and table.Count( usernames[1] ) > 0 then
			pl:SendLua( "Derma_Message( 'This username is already in use. Please choose another.' )" )
			pl:PrintMessage( HUD_PRINTCONSOLE, "Username is already taken" )
			return
		else
			tmysql.query("UPDATE sa_misc SET username = \'" .. tmysql.escape(name) .. "\', password = \'" .. crypto.sha1(crypto.md5(pass)) .. "\' WHERE steamid = \'" .. steamid .. "\'")
			pl:SendLua( "Account.Window:Close()" )
			umsg.Start( "account.Close", pl )
			umsg.End()
			
			pl:ConCommand("retry")
		end
	end )
end
concommand.Add( "linkaccount", LinkAccount_cc )

function SetPassword_cc( pl, command, args )
	if !(STValidEntity(pl) and pl:IsPlayer() and pl:SteamID()) then return end
	pl.lastPasswordSet = pl.lastPasswordSet or CurTime()
	if CurTime() > pl.lastPasswordSet then return end
	pl.lastPasswordSet = CurTime() + 5
	if !pl.account then
		umsg.Start( "account.Close", pl )
		umsg.End()
		pl:PrintMessage( HUD_PRINTCONSOLE, "You must have an account before you set your password." )
		return
	elseif args[1] != pl.account then
		umsg.Start( "account.Close", pl )
		umsg.End()
		pl:PrintMessage( HUD_PRINTCONSOLE, "Incorrect Syntax." )
		
	end
	local steamid = pl:SteamID()
	local pass = args[2]
	if !(pass and pass != "") then return end
	local succ = ValidAccount( pl, pl.account, pass )
	if !succ then return end
	tmysql.query("UPDATE sa_misc SET password = \'" ..string.lower(pass).."\' WHERE steamid = \'"..steamid.."\'")
	pl:SendLua( "Account.Window:Close()" )
	umsg.Start( "account.Close", pl )
	umsg.End()
end
concommand.Add( "setpassword", SetPassword_cc )

concommand.Add("st_lookupusername", function(ply, cmd, args)
	if(ply.LookupUsername) then
		ply:ChatPrint("You have already looked up your username. Rejoin if you must see it again!")
		return
	end
	ply.LookupUsername = true
	
	tmysql.query("SELECT username from sa_misc WHERE steamid=\'"..ply:SteamID().."\'", function(Res, stat, err)
		if(!ply or !ply:IsValid()) then
			return
		end
		if(err != 0 or !stat) then
			return
		end
		if(Res and Res[1] and Res[1][1]) then
			ply:ChatPrint("Your account username is '"..tostring(Res[1][1]).."'")
		end
	end)
end)

concommand.Add("st_resetpassword", function(ply, cmd, args)
	if(ply.ResetAccount) then
		ply:ChatPrint("Your account has been reset")
		return
	end
	ply.ResetAccount = true
	tmysql.query("UPDATE sa_misc SET password = '' WHERE steamid=\'"..ply:SteamID().."\'")
	
	ply:ChatPrint("You must rejoin the server to reset your password")
	ply:SendLua([[LocalPlayer():ConCommand("retry;")]])
end)
