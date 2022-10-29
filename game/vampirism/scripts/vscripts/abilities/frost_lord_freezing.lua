frost_lord_freezing = class({})
LinkLuaModifier("modifier_frost_lord_freezing","abilities/modifier_frost_lord_freezing.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_lord_freezing_debuff","abilities/modifier_frost_lord_freezing_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function frost_lord_freezing:GetIntrinsicModifierName()
	return "modifier_frost_lord_freezing"
end

