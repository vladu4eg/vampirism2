modifier_max_attackspeed = class({})

------------------------------------------------------------------------------------

function modifier_max_attackspeed:IsPurgable()
	return false
end
function modifier_max_attackspeed:IsHidden()
	return true
end
function modifier_max_attackspeed:IsDebuff() return true end

function modifier_max_attackspeed:IsPurgeException()
	return false
end

function  modifier_max_attackspeed:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT
    }
    return funcs
end

function  modifier_max_attackspeed:GetModifierAttackSpeed_Limit()
	return 1
end
