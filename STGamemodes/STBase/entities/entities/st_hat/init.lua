--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:DrawShadow(false)
end

/* Train
 function ENT:Initialize()
self:DrawShadow(false)
local mdl = self:GetModel()
if(!self.Offsets[mdl])then return end

local owner = self.Entity:GetOwner()
if(!owner)then return end

local attach = owner:GetAttachment(owner:LookupAttachment("anim_attachment_head"))
if(!attach)then return end

if attach then
local xOffset = self.Offsets[mdl].xOffset or 0
local yOffset = self.Offsets[mdl].yOffset or 0
local zOffset = self.Offsets[mdl].zOffset or 0

local pOffset = self.Offsets[mdl].pOffset or 0
local yOffset = self.Offsets[mdl].yOffset or 0
local rOffset = self.Offsets[mdl].rOffset or 0

local ang = attach.Ang
local pos = attach.Pos

local x = ang:Forward() * xOffset
        local y = ang:Up() * yOffset
        local z = ang:Right() * zOffset

pos = pos + x + y + z

ang:RotateAroundAxis(ang:Forward(), pOffset+270)  
        ang:RotateAroundAxis(ang:Right(), yOffset)  
        ang:RotateAroundAxis(ang:Up(), rOffset)  

self.Entity:SetAngles(ang)
self.Entity:SetPos(pos + x + y + z)
end
self.Entity:Fire("setparentattachmentmaintainoffset", "anim_attachment_head", 0.1)
end
*/

function ENT:SpawnHat(ply, Hat)
	self.Hat = Hat
	
	local HatInfo = STGamemodes.Hats[Hat]
	-- local HatPositions = STGamemodes.HatPositions[Hat]
	if(!HatInfo or !HatInfo[4] or !HatInfo[5]) then
		ErrorNoHalt(Hat.." - No Info / Position!")
		self:Remove()
		return
	end
	
	local Right = HatInfo[5]
	local AddAng = HatInfo[6]
	
	local BackupAngles = ply:EyeAngles()
	ply:SetEyeAngles(Angle(0, 0, 0))
	
	local Eyes = ply:LookupAttachment("anim_attachment_head")
	if(!Eyes or Eyes == 0) then
		self:Remove()
		return
	end
	
	local Attachment = ply:GetAttachment(Eyes)
	if(!Attachment) then
		self:Remove()
		return
	end
	
	self:SetModel(HatInfo[1])
	
	self:SetOwner(ply)
	
	local Add = Vector(0, 0, 0)
	if(string.find(string.lower(ply:GetModel()), "gman")) then
		Add = Vector(0, 0, 3.05)
		Right = Right + 0.5
	elseif Hat == "Waffle Hat" then 
		Add = Vector( 1.25, 0, 0 )
	end
	self:SetPos(Attachment.Pos + (Attachment.Ang:Up() * HatInfo[4]) + (Attachment.Ang:Right() * Right) + (Attachment.Ang:Forward() * (HatInfo[6] or 0)) + Add)
	
	local ang = Attachment.Ang;
	
	if(AddAng) then
		ang.p = ang.p + AddAng.p
		ang.y = ang.y + AddAng.y
		ang.r = ang.r + AddAng.r
	end
	
	local temp = ang.r
	ang.y = ang.y + 90
	ang.r = ang.p
	ang.p = ((temp - 90) * -1) - 10
	
	self:SetAngles(ang)
	
	self:Fire("setparentattachmentmaintainoffset", "anim_attachment_head", 0)
	
	self:SetParent(ply)
	
	ply:SetEyeAngles(BackupAngles)
end

function ENT:Think()
	if(!STValidEntity(self:GetOwner()) or !self:GetOwner():Alive()) then
		self:Remove()
		return
	end
	self:NextThink(CurTime() + 0.1)
	return true
end

