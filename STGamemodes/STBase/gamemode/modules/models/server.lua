--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.ModelTable = {}

-- STGamemodes.ModelTable["STEAM_0:0:145833"] 		= "models/player/gman_high.mdl"
STGamemodes.ModelTable["STEAM_0:0:7722759"] 	= "models/player/breen.mdl"
-- STGamemodes.ModelTable["STEAM_0:1:15862026"] 	= "models/player/sam.mdl"
STGamemodes.ModelTable["STEAM_0:1:14671056"] 	= "models/player/classic.mdl"
STGamemodes.ModelTable["STEAM_0:1:11278927"] 	= "models/player/combine_soldier.mdl"

function STGamemodes:GenderCheck(ply, model)
	if !IsValid(ply) or !model then return end

	local Lower = string.lower(model)
	if(string.find(Lower, "female") != nil or string.find(Lower, "alyx") != nil or string.find(Lower, "mossman") != nil) then
		if(!ply.Female) then
			ply.Female = true
		end
	elseif string.find(Lower, "lilith") then 
		if(!ply.Female) then
			ply.Female = true
		end
	elseif(ply.Female) then
		ply.Female = false
	end
end

function STGamemodes:SetupPlayerModel(ply)
	if !IsValid(ply) then return end

	local Mod = STGamemodes.Store:GetItemInfo(ply, "Player Models", "Selected")
	
	local ModelTable = self.ModelTable[ply:SteamID()]
	if(ModelTable and !ply:IsFake()) then
		if(Mod and Mod == "Arctic") then
			self:GenderCheck(ply, ModelTable)
			ply:SetModel(ModelTable)
			return
		end
	end
	
	if(ply:Team() == TEAM_DEATH) then
		ply.Female = false
		ply:SetModel("models/player/death.mdl")
		return
	end

	if ply:IsFake() then 
		local mod = ply.FakeModel or ""
		if mod and mod != "" then 
			Mod = mod 
		else 
			Mod = false
			ply.CustomModel = false 
		end 
	end 
	
	if(Mod and STGamemodes.PlayerModels[Mod]) then
		ply.CustomModel = STGamemodes.PlayerModels[Mod]
	end
	
	if(ply.CustomModel) then
		ply:SetModel(ply.CustomModel)
		if Mod == "Tron" or Mod == "Lilith" then 
			local Skin = STGamemodes.Store:GetItemInfo(ply, "Player Models", Mod.."Skin")
			if Skin then 
				if Skin == 6 and !ply:IsDev() then Skin = 0 end 
				ply:SetSkin(tonumber(Skin))
			else 
				ply:SetSkin(0)
			end 
		end 
		self:GenderCheck(ply, ply.CustomModel)
		return
	end
	
	local ModelID = ply.ModelID or math.random(1, table.Count(CivModels))
	local CustomModel = string.lower(CivModels[ModelID])
	local PlayerModel = ply:GetModel()
	
	if(ply:IsAdmin() and !ply:IsFake()) then
		CustomModel = string.gsub(CustomModel, "group", "group03")
	else
		CustomModel = string.gsub(CustomModel, "group", "group01")
	end
	
	if(CustomModel and PlayerModel != CustomModel) then
		ply.ModelID = ModelID
		self:GenderCheck(ply, CustomModel)
		ply:SetModel(CustomModel)
	end
end
