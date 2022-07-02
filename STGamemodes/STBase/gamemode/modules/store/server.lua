--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Store.PlayersQueueLoad = {}
STGamemodes.Store.FileName = "Store/"..string.gsub(os.date("%x"), "/", "-")

local DelayTime = 0.15
local DelayTime2 = 0.018

-- hook.Add("PlayerInitialSpawn", "Store.PlayerInitialSpawn", function(ply)
	-- if(!STGamemodes.Store.Players[ply:SteamID()]) then
		-- STGamemodes.Store.Players[ply:SteamID()] = {}
	-- end
-- end)

function STGamemodes.Store:Log(ply, action, item, startdough, enddough)
	if(!AppendLog) then
		return
	end

	if !file.IsDir("Store", "DATA") then file.CreateDir("Store") end 

	AppendLog(self.FileName..".txt", "["..os.date("%X").."] "..ply:Name().." ("..ply:SteamID()..") "..action.." \""..item.."\" ("..STFormatNum(startdough).." - "..STFormatNum(enddough)..")\n")
end

function STGamemodes.Store:Debug(ply, event, override)
/*
	if(override) then
		AppendLog("../data/StoreDebug/"..string.gsub(ply:SteamID(), ":", ""), "("..os.date("%X")..") "..event.."\n\n")
	else
		AppendLog("../data/StoreDebug/"..string.gsub(ply:SteamID(), ":", ""), "("..os.date("%X")..") "..event.." | "..Json.Encode(self.Players[ply:SteamID()]).."\n\n")
	end
*/
end

local December = (tonumber(os.date('%m')) == 12)
function STGamemodes.Store:CheckFreeItems(ply)
	if(ply:IsVIP() and !self:HasItem(ply, "Antlers")) and December then
		if(self:SetItemInfo(ply, "Hats", "Antlers", true)) then
			umsg.Start("STGamemodes.Store.UserMessageItemFree", ply)
				umsg.String("Antler Hat")
			umsg.End()
		end
	end
	if((ply:GetRank() == "dev" or ply:GetRank() == "devmin") and !self:HasItem(ply, "Dev Hat")) then
		if(self:SetItemInfo(ply, "Hats", "Dev Hat", true)) then
			umsg.Start("STGamemodes.Store.UserMessageItemFree", ply)
				umsg.String("Dev Hat")
			umsg.End()
		end
	end
	if ply:SteamID() == "STEAM_0:0:145833" then 
		if !self:HasItem(ply, "Waffle Hat") then 
			self:SetItemInfo(ply, "Hats", "Waffle Hat", true)
		end 
	end 
end

function STGamemodes.Store:Load(ply)
	if(!tmysql) then
		return
	end
	
	if(ply.Guest) then
		umsg.Start("STGamemodes.Store.UserMessageItemEnd", ply)
		umsg.End()
		return
	end
	local SteamID = ply:SteamID()
	
	-- self:Debug(ply, "Money: "..tostring(ply:GetMoney()), true)
	
	tmysql.query("SELECT st_items from sa_misc WHERE steamid=\'"..SteamID.."\'", function(data, stat, err)
		if(!ply or !ply:IsValid()) then
			return
		end
		
		if(err != 0 or !stat) then
			timer.Simple(1, function()
				if(STValidEntity(ply)) then
					self:Load(ply)
				end
			end)
			ErrorNoHalt("STGamemodes.Store:Load - "..ply:SteamID().." - "..ply:CName().." - "..tostring(err).." - "..tostring(stat).." - Timer Reloading")
			return
		end
		
		if(!data[1] or !data[1][1]) then
			return
		end
		
		local Items = data[1][1]
		if(!Items or string.Trim(Items) == "" or Items == "NULL") then
			Items = {}
			-- self:Debug(ply, "No Item Load")
		else
			-- self:Debug(ply, "Load Decode"..Items, true)
			Items = Json.Decode(Items)
		end
		
		self.Players[SteamID] = Items or {}
		-- self:Debug(ply, "Load")
		
		self:SendAll(ply, SteamID)
	end)
end

function STGamemodes.Store:Save(ply)
	if(STGamemodes.EverFailed) then
		return
	end
	if(ply.Guest) then
		return
	end
	if(!self.Players[ply:SteamID()]) then
		return
	end
	-- self:Debug(ply, "Save - "..tostring(table.Count(self.Players[ply:SteamID()])), true)
	local Encode = Json.Encode(self.Players[ply:SteamID()])
	if(Encode) then
		-- self:Debug(ply, "UPDATE sa_misc SET st_items=\'"..tmysql.escape(Encode).."\' WHERE steamid=\'"..ply:SteamID().."\'", true)
		tmysql.query("UPDATE sa_misc SET st_items=\'"..tmysql.escape(Encode).."\' WHERE steamid=\'"..ply:SteamID().."\'", function(data, stat, err)
			if(err != 0 or !stat) then
				if(ply and ply:IsValid()) then
					ErrorNoHalt("STGamemodes.Store:Save - "..ply:SteamID().." - "..ply:CName().." - "..tostring(err).." - "..tostring(stat), "\n")
				end
			end
		end)
	else
		ErrorNoHalt("STGamemodes.Store:Save - Encode Failed - ("..ply:SteamID()..") - "..ply:CName(), "\n")
	end
end

function STGamemodes.Store:SendAll(ply, SteamID)
	local SteamID = SteamID or ply:SteamID()
	
	-- print("Loading: "..tostring(ply))
	
	if(STGamemodes.OnStoreInit) then
		STGamemodes:OnStoreInit(ply)
	else
		ply:ChatPrint("Store: Loading")
	end
	
	umsg.Start("STGamemodes.Store.UserMessageItemStart", ply)
	umsg.End()
	
	local Time = DelayTime
	
	self.PlayersQueueLoad[SteamID] = {}
	
	ply.MultiItemIDLoaded = false
	self:MultiSendItems(ply)
	
	for k,v in pairs(table.Copy(self.Players[SteamID])) do
		if(type(v) == "table") then
			self.PlayersQueueLoad[SteamID][k] = {}
			for k2,v2 in pairs(v) do
				if(!table.HasValue(self.LoadList, k2)) then
					self.PlayersQueueLoad[SteamID][k][k2] = CurTime() + Time
					timer.Simple(Time, function() self:SendCatItem(ply, k, k2) end )
					Time = Time + DelayTime2
				end
			end
		else
			self.PlayersQueueLoad[SteamID][k] = CurTime() + Time
			timer.Simple(Time, function() self:SendItem(ply, k) end )
		end
		Time = Time + DelayTime
	end
	
	local TimerName = "StoreLoading"..SteamID
	timer.Create(TimerName, DelayTime, 0, function() self:CheckLoaded(ply, TimerName) end )
end

function STGamemodes.Store:MultiSendItems(ply)
	-- umsg.Start("STGamemodes.Store.UserMessageMultiItemID", ply)
		-- for k,v in pairs(self.LoadList) do
			-- if(self:HasItem(ply, v)) then
				-- umsg.Char(1)
			-- else
				-- umsg.Char(0)
			-- end
		-- end
	-- umsg.End()
	for k,v in pairs( self.LoadList ) do
		umsg.Start("STGamemodes.Store.UserMessageMultiItemID", ply)
		umsg.String( self:GetCat( v ) )
		umsg.String( v )
		if(self:HasItem(ply, v)) then
			umsg.Bool( true )
		else
			umsg.Bool( false )
		end
		umsg.End()
	end

	--ply:ConCommand( "st_store_loaded MultiItemID" )

	-- Fix: FCVAR_SERVER_CAN_EXECUTE prevented server running command: st_store_loaded
	umsg.Start("STGamemodes.Store.UserMessageMultiItemIDLoaded", ply)
	umsg.End()
 
end

function STGamemodes.Store:SendItem(ply, Item)
	if(!ply or !ply:IsValid()) then
		return
	end
	local Info = self.Players[ply:SteamID()][Item]
	umsg.Start("STGamemodes.Store.UserMessageItem", ply)
		umsg.String(Item)
		umsg.String(Json.Encode(Info))
	umsg.End()
end

function STGamemodes.Store:SendCatItem(ply, Cat, Item, From)
	if(!ply or !ply:IsValid()) then
		return
	end
	-- if(!self.Players[ply:SteamID()] == nil) then
		-- ErrorNoHalt("SendCatItem Error 1: ", ply:SteamID(), "-", tostring(Cat), "-", tostring(Item), "\n")
	-- elseif(!self.Players[ply:SteamID()][Cat] == nil) then
		-- ErrorNoHalt("SendCatItem Error 2: ", ply:SteamID(), "-", tostring(Cat), "-", tostring(Item), "\n")
	-- elseif(self.Players[ply:SteamID()][Cat][Item] == nil) then
		-- ErrorNoHalt("SendCatItem Error 3: ", ply:SteamID(), "-", tostring(Cat), "-", tostring(Item), "\n")
		-- if(Item == "GhostModeEnabled" or Item == "ThirdPersonEnabled" or Item == "Selected") then
			-- return true
		-- end
	-- else
	local Info = self.Players[ply:SteamID()][Cat][Item]
	umsg.Start("STGamemodes.Store.UserMessageCatItem", ply)
		umsg.String(Cat)
		umsg.String(Item)
		umsg.String(Json.Encode(Info))
	umsg.End()
	-- end
end

function STGamemodes.Store:CheckLoaded(ply, TimerName)
	if(!ply or !ply:IsValid()) then
		timer.Remove(TimerName)
		return
	end
	
	if(!ply.MultiItemIDLoaded) then
		self:MultiSendItems(ply)
		return
	end
	
	for k,v in pairs(self.PlayersQueueLoad[ply:SteamID()]) do
		if(type(v) == "table") then
			for k2,v2 in pairs(v) do
				if(v2 != false) then
					if(v2 <= CurTime() - 1) then
						if(self:SendCatItem(ply, k, k2)) then
							self.PlayersQueueLoad[ply:SteamID()][k][k2] = false
						else
							self.PlayersQueueLoad[ply:SteamID()][k][k2] = CurTime() + 2
						end
					end
					return
				end
			end
		else
			if(v != false) then
				if(v <= CurTime() - 1) then
					self:SendItem(ply, k)
					self.PlayersQueueLoad[ply:SteamID()][k] = CurTime() + 2
				end
				return
			end
		end
	end
	
	self.PlayersQueueLoad[ply:SteamID()] = nil
	ply.FullyLoaded = true
	ply:ChatPrint("Store: Loaded Successfully!")
	-- print("Loaded Successfully!: "..tostring(ply))
	ply:SendLua([[STGamemodes.Store.Loading = false]])
	umsg.Start("STGamemodes.Store.UserMessageItemEnd", ply)
	umsg.End()
	
	timer.Remove(TimerName)
	
	if(STGamemodes.OnStoreLoad) then
		STGamemodes:OnStoreLoad(ply)
	end
	
	STAchievements:Load(ply)
	-- STGamemodes.Records:LoadPersonalRecord(ply)
	
	self:CheckFreeItems(ply)
end

function STGamemodes.Store:Think()
	self.NextLoadCheck = self.NextLoadCheck or CurTime()
	if(CurTime() > self.NextLoadCheck) then
		self.NextLoadCheck = CurTime() + 1
		for k,v in pairs(player.GetAll()) do
			if(STValidEntity(v) and !v.RankLoading and !v.RequestSuccess) then
				v.NextLoadRequest = v.NextLoadRequest or CurTime() + 1
				if(CurTime() >= v.NextLoadRequest) then
					v.NextLoadRequest = CurTime() + 1
					umsg.Start("STGamemodes.Store.UserMessageReqLoad", v)
					umsg.End()
				end
			end
		end
	end
end
hook.Add("Think", "STGamemodes.Store.Think", function() STGamemodes.Store:Think() end)

concommand.Add("st_store_requestload", function(ply)
	if(ply.RequestSuccess) then
		return
	end
	ply.RequestSuccess = true
	STGamemodes.Store:Load(ply)
end)

concommand.Add("st_store_loaded", function(ply, cmd, args)
	local Item = args[1]
	local Info = args[2]
	if(!Item) then
		return
	end
	if(!STGamemodes.Store.PlayersQueueLoad[ply:SteamID()]) then
		return
	end
	if(Item == "MultiItemID") then
		ply.MultiItemIDLoaded = true
		return
	end
	if(STGamemodes.Store.PlayersQueueLoad[ply:SteamID()][Item]) then
		if(Info) then
			if(STGamemodes.Store.PlayersQueueLoad[ply:SteamID()][Item][Info]) then
				STGamemodes.Store.PlayersQueueLoad[ply:SteamID()][Item][Info] = false
			end
		else
			STGamemodes.Store.PlayersQueueLoad[ply:SteamID()][Item] = false
		end
	end
end)

function STGamemodes.Store:BuyItem(ply, Name)
	if(self:HasItem(ply, Name)) then
		ply:ChatPrint("You already bought "..Name)
		return
	end

	local canBuy, message = self:CanBuyItem(ply, Name)
	if(canBuy) then
		local Item = self:GetItem(Name)
		local Cat = Item.Category
		
		-- self:Debug(ply, "Pre Bought "..Name)
		
		if !self.Players[ply:SteamID()] then self.Players[ply:SteamID()] = {} end 
		self.Players[ply:SteamID()][Cat] = self.Players[ply:SteamID()][Cat] or {}
		
		local Free = self:ItemIsFree(ply, Name, true)
		
		local StartDough = ply:GetMoney()

		if(Free) then
			ply:ChatPrint("You recieved "..Name.." for free!")
		else
			local Price = self:GetPrice(Name, ply)
			ply:TakeMoney(Price)
			ply:ChatPrint("You successfully bought "..Name.." for "..tostring(Price).." dough")
		end

		self:Log(ply, "bought", Name, StartDough, ply:GetMoney())
		
		self:SetItemInfo(ply, Cat, Name, true)
		
		---------------------------------------------------
		-- We do this client-side now
		
		-- if(Name == "Ghost Mode") then
		-- 	STGamemodes.Ghost:SetGhost(ply, true)
		-- end
		-- if(Name == "Third Person Mode") then
		-- 	STGamemodes.ThirdPerson:SetEnabled(ply, true)
		-- end
		---------------------------------------------------
		
		ply:SaveMoney()
		
		-- self:Debug(ply, "After Bought "..Name)
	else
		ply:ChatPrint(message)
	end
end

function STGamemodes.Store:SellItem(ply, Name)
	if(!self:HasItem(ply, Name)) then
		ply:ChatPrint("You don't own "..Name)
		return
	end

	local StartDough = ply:GetMoney()
	
	local Item = self:GetItem(Name)
	local Cat = Item.Category
	
	local Sell = math.Round(self:GetPrice(Name, ply) * 0.8)
	ply:GiveMoney(Sell)
	
	-- self:Debug(ply, "Pre Sell "..Name)
	
	ply:ChatPrint("You successfully sold "..Name.." for "..tostring(Sell).." dough")
	
	self:SetItemInfo(ply, Cat, Name, nil)
	
	if(self:GetItemInfo(ply, Cat, "Selected") == Name) then
		self:SetItemInfo(ply, Cat, "Selected", nil)
	end
	
	ply:SaveMoney()
	
	self:Log(ply, "sold", Name, StartDough, ply:GetMoney())
	-- self:Debug(ply, "After Sell "..Name)
end

concommand.Add("st_store_buy", function(ply, cmd, args)
	local Name = args[1]
	if(!Name) then
		return
	end
	if(!STGamemodes.Store:GetItem(Name)) then
		ply:ChatPrint("That's not a valid item!")
		return
	end
	STGamemodes.Store:BuyItem(ply, Name)
end)

concommand.Add("st_store_sell", function(ply, cmd, args)
	local Name = args[1]
	if(!Name) then
		return
	end
	if(!STGamemodes.Store:GetItem(Name)) then
		ply:ChatPrint("That's not a valid item!")
		return
	end
	STGamemodes.Store:SellItem(ply, Name)
end)

concommand.Add("st_store_hat", function(ply, cmd, args)
	local Name = args[1]
	if(!Name) then
		ply:RemoveHat()
		return
	end
	if(!STGamemodes.Hats[Name]) then
		return
	end
	if(!STGamemodes.Store:HasItem(ply, Name)) then
		return
	end
	--ply:ChatPrint("Your hat has been updated!")
	STGamemodes.Store:SetItemInfo(ply, "Hats", "Selected", Name)
end)

concommand.Add("st_store_trail", function(ply, cmd, args)
	local Name = args[1]
	local R = args[2]
	local G = args[3]
	local B = args[4]
	if(!Name or !R or !G or !B) then
		ply:RemoveTrail()
		return
	end
	local Mat = STGamemodes.Trails[Name]
	if(!Mat) then
		return
	end
	if(!STGamemodes.Store:HasItem(ply, Name)) then
		return
	end
	STGamemodes.Store:SetItemInfo(ply, "Trails", "Selected", Name)
	STGamemodes.Store:SetItemInfo(ply, "Trails", "Col", Color(R, G, B, 255))
	
	ply:CreateTrail(Mat[1], true)
end)

concommand.Add("st_store_playermodel", function(ply, cmd, args)
	local Name = args[1]
	if(!Name) then
		return
	end
	if(!STGamemodes.PlayerModels[Name]) then
		return
	end
	if(!STGamemodes.Store:HasItem(ply, Name)) then
		return
	end
	--ply:ChatPrint("Your player model has been updated!")
	STGamemodes.Store:SetItemInfo(ply, "Player Models", "Selected", Name)
end)

concommand.Add("st_store_ghost", function(ply, cmd, args)
	local Enable = args[1]
	if(Enable == nil) then
		return
	end
	if(!STGamemodes.Store:HasItem(ply, "Ghost Mode")) then
		return
	end
	Enable = tonumber(Enable)
	if(Enable == 1) then
		ply:ChatPrint("Ghost Mode: Enabled")
		STGamemodes.Ghost:SetGhost(ply, true)
	else
		ply:ChatPrint("Ghost Mode: Disabled")
		STGamemodes.Ghost:SetGhost(ply, false)
	end
end)

concommand.Add( "st_ghostmode" , function(ply, cmd, args) 
	if(!STGamemodes.Store:HasItem(ply, "Ghost Mode")) then
		return
	end

	local Enabled = STGamemodes.Store:GetItemInfo(ply, "Misc", "GhostModeEnabled")
	if Enabled then 
		STGamemodes.Ghost:SetGhost(ply, false)
		ply:ChatPrint( "Ghost Mode: Disabled" )
	else 
		STGamemodes.Ghost:SetGhost(ply, true)
		ply:ChatPrint( "Ghost Mode: Enabled" )
	end 
end )

concommand.Add("st_store_thirdperson", function(ply, cmd, args)
	local Enable = args[1]
	if(Enable == nil) then
		return
	end
	if(!STGamemodes.Store:HasItem(ply, "Third Person Mode")) then
		return
	end
	Enable = tonumber(Enable)
	if(Enable == 1) then
		ply:ChatPrint("Third Person Mode: Enabled")
		STGamemodes.ThirdPerson:SetEnabled(ply, true)
	else
		ply:ChatPrint("Third Person Mode: Disabled")
		STGamemodes.ThirdPerson:SetEnabled(ply, false)
	end
end)

concommand.Add("st_thirdperson", function(ply, cmd, args)
	if(!STGamemodes.Store:HasItem(ply, "Third Person Mode")) then
		return
	end
	local Enabled = STGamemodes.Store:GetItemInfo(ply, "Misc", "ThirdPersonEnabled")
	if(Enabled) then
		ply:ChatPrint("Third Person Mode: Disabled")
		STGamemodes.ThirdPerson:SetEnabled(ply, false)
	else
		ply:ChatPrint("Third Person Mode: Enabled")
		STGamemodes.ThirdPerson:SetEnabled(ply, true)
	end
end)

concommand.Add("st_tronskin", function(ply, cmd, args) 
	if !STGamemodes.Store:HasItem(ply, "Tron") then 
		ply:ChatPrint("You do not own tron") 
		return 
	end 

	local Skin = args[1]
	local SkinN = STGamemodes.Store.TronSkins[Skin]
	if SkinN == 6 and !ply:IsDev() then 
		ply:ChatPrint("(!) Staff Only Skin") 
		return 
	end 

	STGamemodes.Store:SetItemInfo(ply, "Player Models", "TronSkin", SkinN)
	STGamemodes.Store:SendCatItem(ply, "Player Models", "TronSkin")
	ply:ChatPrint("Tron Skin set to: ".. Skin)
end )

concommand.Add("st_lilithskin", function(ply, cmd, args) 
	if !STGamemodes.Store:HasItem(ply, "Lilith") then 
		ply:ChatPrint("You do not own Lilith") 
		return 
	end 

	local Skin = args[1]
	local SkinN = STGamemodes.Store.LilithSkins[Skin]

	STGamemodes.Store:SetItemInfo(ply, "Player Models", "LilithSkin", SkinN)
	STGamemodes.Store:SendCatItem(ply, "Player Models", "LilithSkin")
	ply:ChatPrint("Lilith Skin set to: ".. Skin)
end )

/*
	st_store_set "Spacetech" "Trails" "Waffle" "true"
*/
concommand.Add("st_store_set", function(ply, cmd, args)
	if(!ply:IsSuperAdmin()) then
		return
	end
	
	local Info = args[1]
	local Cat = args[2]
	local Key = args[3]
	local Value = args[4]
	
	if(!Info or !Cat or !Key) then
		return
	end
	
	local Target = STGamemodes.FindByPartial(Info)
	
	if(type(Target) == "string") then
		ply:PrintMessage(HUD_PRINTTALK, Target)
	else
		if(Value == "") then
			Value = nil
		end
		if(Value == "true") then
			Value = true
		elseif(Value == "false") then
			Value = false
		elseif(Value == "nil") then
			Value = nil
		end
		
		local Set = STGamemodes.Store:SetItemInfo(Target, Cat, Key, Value)
		if(Set) then
			ply:ChatPrint("Store: "..Target:Nick()..": Set Successfully")
		else
			ply:ChatPrint("Store: "..Target:Nick()..": Set Failed!")
		end
	end
end)
