eclipse8 = eclipse8 or class({})

function eclipse8:GetTexture() return "Eclipse8" end -- get the icon from a different ability

function eclipse8:IsPermanent() return true end
function eclipse8:RemoveOnDeath() return false end
function eclipse8:IsHidden() return false end 	-- we can hide the modifier
function eclipse8:IsDebuff() return true end 	-- make it red or green

function eclipse8:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.05)
end

function eclipse8:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealth() > parent:GetMaxHealth() - self:GetStackCount() then
		parent:SetHealth(math.max(parent:GetMaxHealth() - self:GetStackCount(), 1))
	end
end

function eclipse8:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function eclipse8:OnDeath(event)
	-- for k,v in pairs(event) do print("OnDeath",k,v) end -- find out what event.__ to use
	if IsClient() then return end
	if event.unit~=self:GetParent() then return end -- only affect the own hero
	self:SetStackCount(0)
end

function eclipse8:OnTakeDamage(event)
	if IsClient() then return end
	local target=event.unit
	local attacker=event.attacker
	local hero=self:GetParent()
	if not (hero==target) then return end
	
	local damage = event.damage
	self:SetStackCount(self:GetStackCount() + math.floor(damage * (BUTTINGS.PCT_DAMAGE_PERMANENT)/100 ))
end