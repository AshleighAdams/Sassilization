--------------------
-- STBase
-- By Spacetech
--------------------

-- require("json")

STGamemodes.Store = {}
STGamemodes.Store.Items = {}
STGamemodes.Store.Players = {}
STGamemodes.Store.Categories = {}
STGamemodes.Store.LoadList = {}
STGamemodes.Store.TronSkins = {}
STGamemodes.Store.TronSkins["Blue"] = 0
STGamemodes.Store.TronSkins["Orange"] = 1
STGamemodes.Store.TronSkins["White"] = 2
STGamemodes.Store.TronSkins["Green"] = 3
STGamemodes.Store.TronSkins["Yellow"] = 4
STGamemodes.Store.TronSkins["Purple"] = 5
STGamemodes.Store.TronSkins["Magical Pixie Rainbow"] = 6
STGamemodes.Store.LilithSkins = {}
STGamemodes.Store.LilithSkins["Default"] = 0 
STGamemodes.Store.LilithSkins["Pheonix"] = 1 

function STGamemodes.Store:AddCategory(Name, Mat)
	self.Categories[Name] = {}
	self.Categories[Name].Mat = Mat
end

function STGamemodes.Store:AddItem(Name, Category, Description, Mat, Price, VIP)
	self.Items[Name] = {
		Category = Category,
		Description = Description,
		Mat = Mat,
		Price = Price,
		VIP = VIP or false
	}
	table.insert(self.Categories[Category], Name)
end

function STGamemodes.Store:GetItems()
	return table.Copy(self.Items or {})
end

function STGamemodes.Store:GetCategories()
	return table.Copy(self.Categories or {})
end

function STGamemodes.Store:GetCategoryItems(Cat)
	local Return = table.Copy(self.Categories[Cat])
	Return.Mat = nil
	return Return
end

function STGamemodes.Store:GetItem(Name)
	return table.Copy(self.Items[Name] or {}) or false
end

function STGamemodes.Store:GetCat(Name)
	local Item = self:GetItem(Name)
	if(Item) then
		return Item.Category
	end
	return false
end

function STGamemodes.Store:GetPrice(Name, ply)
	local Item = self:GetItem(Name)
	if(Item) then
		if((ply and ply:IsVIP()) or STGamemodes.VIP) then
			return math.Round(Item.Price * 0.7)
		else
			return Item.Price
		end
	end
	return false
end

function STGamemodes.Store:HasItem(ply, Name)
	local Item = self:GetItem(Name)
	if(!Item) then
		return false
	end
	local Cat = Item.Category
	if(SERVER) then
		if(self.Players[ply:SteamID()]) then
			if(self.Players[ply:SteamID()][Cat]) then
				if(self.Players[ply:SteamID()][Cat][Name]) then
					return true
				end
			end
		end
	else
		if(self.LocalItems[Cat]) then
			if(self.LocalItems[Cat][Name]) then
				return true
			end
		end
	end
	return false
end

function STGamemodes.Store:HasItemInCategory(ply, Cat, IgnorePrice)
	local Count = 0
	local MaxCount = 0
	for k,v in pairs(self:GetCategoryItems(Cat)) do
		local Price = self:GetPrice(v, ply)
		if((Price and Price > -1) or IgnorePrice) then
			if(self:HasItem(ply, v)) then
				Count = Count + 1
			end
			MaxCount = MaxCount + 1
		end
	end
	return Count, MaxCount
end

function STGamemodes.Store:CanBuyItem(ply, Name)
	if(ply.Guest) then
		return false, "Please wait until your profile loads"
	end
	if(!self:HasItem(ply, Name)) then
		if(self:ItemIsFree(ply, Name)) then
			return true
		end
		
		if (self:ItemIsVIP(Name) and !ply:IsVIP()) then
			return false, "Sorry, you must be a VIP to buy: "..Name
		end

		local Price = self:GetPrice(Name, ply)
		if(Price and Price > -1) then
			if(ply:GetMoney() >= Price) then
				return true
			end
		end
	end
	
	return false, "Sorry, you do not have enough dough to buy: "..Name
end

function STGamemodes.Store:ItemIsVIP(Name)
	local Item = self:GetItem(Name)
	if (Item) then
		return Item.VIP
	end
end

function STGamemodes.Store:CatItemIsFree(ply, Cat)
	for k,v in pairs(self:GetCategoryItems(Cat)) do
		if(self:ItemIsFree(ply, v)) then
			return true
		end
	end
	return false
end

function STGamemodes.Store:ItemIsFree(ply, Name, Buying)
	if(ply:IsVIP()) then
		local Cat = self:GetCat(Name)
		if(Cat == "Trails") then
			if(self:GetPrice(Name, ply) <= 30000) then
				-- local Count, MaxCount = STGamemodes.Store:HasItemInCategory(ply, "Trails")
				-- if(Count <= 0) then
					if(self:GetItemInfo(ply, "Trails", "Free")) then
						return false
					end
					if(SERVER and Buying) then
						self:SetItemInfo(ply, "Trails", "Free", true)
					end
					return true
				-- end
			end
		end
	end
	return false
end

function STGamemodes.Store:CanBuyCategoryItem(ply, Cat)
	for k,v in pairs(self:GetCategoryItems(Cat)) do
		if(self:CanBuyItem(ply, v)) then
			return true
		end
	end
	return false
end

function STGamemodes.Store:SetItemInfo(ply, Cat, Name, Set)
	local Table
	if(SERVER) then
		Table = self.Players[ply:SteamID()]
	else
		Table = self.LocalItems
	end
	if(Table) then
		if(!Table[Cat]) then
			Table[Cat] = {}
		end
		Table[Cat][Name] = Set
		if(SERVER) then
			self:SendCatItem(ply, Cat, Name)
			self:Save(ply)
		end
		return true
	end
	return false
end

function STGamemodes.Store:GetItemInfo(ply, Cat, Name)
	local Table
	if(SERVER) then
		Table = table.Copy(self.Players[ply:SteamID()] or {})
	else
		Table = table.Copy(self.LocalItems or {})
	end
	if(Table) then
		if(Table[Cat]) then
			if(Table[Cat][Name] != nil) then
				return Table[Cat][Name]
			end
		end
	end
	return nil
end

function STGamemodes.Store:CacheLoadList()
	for k,v in pairs(self.Items) do
		table.insert(self.LoadList, k)
	end
end

function STGamemodes.Store:GetLoadListID(Name)
	for k,v in pairs(self.LoadList) do
		if(v == Name) then
			return k
		end
	end
	return false
end

function STGamemodes.Store:GetLoadListName(ID)
	return self.LoadList[ID]
end

STGamemodes.Store:AddCategory("Hats", "store/Hats/Hats")
STGamemodes.Store:AddCategory("Trails", "store/Trails/Trails")
STGamemodes.Store:AddCategory("Player Models", "store/PModels/PModels")
STGamemodes.Store:AddCategory("Misc", "store/Misc/Misc")
STGamemodes.Store:AddCategory("Acts", "store/Acts/act_wave")

STGamemodes.Store:AddItem("Third Person Mode", "Misc", "You can play in a third person view", "store/Misc/ThirdPerson/ThirdPerson", 50000)
STGamemodes.Store:AddItem("Ghost Mode", "Misc", "You can continue playing after you die! Features noclip ghost mode and runner ghost mode!", "store/Misc/Ghost/Ghost", 75000)

STGamemodes.Acts = { "agree", "becon", "bow", "disagree", "forward", "group", "halt", "salute", "wave" }
for k,v in pairs( STGamemodes.Acts ) do
	STGamemodes.Store:AddItem( "Act ".. v, "Acts", "Ability to use the act '".. v .."'", "store/Acts/act_".. v, 3000 )
end

/*STGamemodes.Store:AddItem(
	"Bird Mode",
	"Misc",
	"After you die, you can spawn as a bird and harass other players!",
	"store/Misc/Bird/Bird",
	750000)*/

for k,v in pairs(STGamemodes.Hats) do
	STGamemodes.Store:AddItem(k, "Hats", false, v[1], v[3])
end

for k,v in pairs(STGamemodes.Trails) do
	STGamemodes.Store:AddItem(k, "Trails", false, v[1], v[2])
end

for k,v in pairs(STGamemodes.PlayerModels) do
	local Price = 30000
	local Vip = false
	local Lower = string.lower(v)
	if(string.find(Lower, "group")) then
		Price = 5000
	elseif(string.find(Lower, "hostage")) then
		Price = 10000
	elseif(string.find(Lower, "zombie") or string.find(string.lower(k), "zombie")) then
		Price = 20000
	elseif(k == "Kleiner" or k == "Charple") then
		Price = 50000
	elseif(k == "Barney") then
		Price = 75000
	elseif(k == "G-Man") then
		Price = 100000
	elseif(k == "Gordon") then
		Price = 200000
	elseif(k == "Shepard") then 
		Price = 300000
	elseif(k == "Spacesuit" or k == "Battle Droid") then
		Price = 400000
	elseif(k == "Neo Combine") then
		Price = 500000
	elseif(k == "Onyx Guard") then
		Price = 700000
		Vip = true
	elseif(k == "Sam") then
		Price = 750000
	elseif(k == "Lilith") then 
		Price = 800000 
		Vip = true
	elseif(k == "Zer0") then 
		Price = 900000 
		Vip = true
	elseif(k == "Tron") then
		Price = 1000000
	end
	if(k != "Breen") then
		STGamemodes.Store:AddItem(k, "Player Models", false, v, Price, Vip)
	end
end

STGamemodes.Store:CacheLoadList()
