modifier_death_armor = class({})

function modifier_death_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }

    return funcs
end

function modifier_death_armor:GetModifierExtraHealthPercentage( params )
    self:GetParent():GetDeaths()
    if self:GetParent():GetDeaths() == 2 then
        return -50
    elseif self:GetParent():GetDeaths() > 2 then
        return -85
    end
end

function modifier_death_armor:IsHidden()
    return true
end