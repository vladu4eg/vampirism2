modifier_books_damage = class({})

function modifier_books_damage:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end

function modifier_books_damage:IsHidden()
    return false
end

function modifier_books_damage:IsPurgable()
    return false
end

function modifier_books_damage:IsPermanent()
	return true
end

function modifier_books_damage:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_books_damage:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end