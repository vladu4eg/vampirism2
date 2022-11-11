modifier_books_hp = class({})

function modifier_books_hp:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end

function modifier_books_hp:IsHidden()
    return false
end

function modifier_books_hp:IsPurgable()
    return false
end

function modifier_books_hp:IsPermanent()
	return true
end

function modifier_books_hp:DeclareFunctions()
	return { MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_books_hp:GetModifierHealthBonus()
	return self:GetStackCount()
end