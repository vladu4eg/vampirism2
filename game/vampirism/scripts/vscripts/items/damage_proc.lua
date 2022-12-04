LinkLuaModifier("modifier_bonus_damage_proc", "items/damage_proc.lua",LUA_MODIFIER_MOTION_NONE)
local time = 5 
function DamageProc(event)
    local hero = event.caster
	if not hero:HasModifier("modifier_bonus_damage_proc") and not hero:HasModifier("modifiers_item_immunity_shield") 
        and not hero:HasModifier("modifier_potion_of_invulnerability") then
        hero:AddNewModifier(hero, event, "modifier_bonus_damage_proc", {Duration = event.Dur_time, Amount = event.Amount})
    end
    Timers:CreateTimer(4, function()
        if event.ability:GetName() == "item_lia_poleaxe_of_rage" then
            event.ability:SpendCharge()
        end
    end)
end

modifier_bonus_damage_proc = class({})

function modifier_bonus_damage_proc:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

function modifier_bonus_damage_proc:GetModifierDamageOutgoing_Percentage( params )
    return 2000 * self.count
end

function modifier_bonus_damage_proc:IsHidden()
    return true
end

function modifier_bonus_damage_proc:OnCreated( kv )
    self.count = 0
	self:StartIntervalThink(1)
	self:OnIntervalThink()
    
end

function modifier_bonus_damage_proc:OnIntervalThink()
	self.count = self.count + 1
    local caster = self:GetParent()
	local changeHp = 500000
	local reduction = caster:GetMaxHealth()*0.0001
    if caster:GetHealth()-changeHp > reduction then       --Проверка уровня хп после уменьшения
        caster:SetHealth(caster:GetHealth()-changeHp ) 
    else
      caster:SetHealth( reduction )
    end	
end