function DebugPrint(...)
  local spew = Convars:GetInt('trollnelves2_spew') or -1
  if spew == -1 and TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('trollnelves2_spew') or -1
  if spew == -1 and TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


--[[Author: Noya
  Date: 09.08.2015.
  Hides all dem hats
]]
function HideWearables( event )
  local hero = event.caster
  local ability = event.ability

  hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

function CDOTA_Item:Use()
    local caster = self:GetOwner()
    if caster ~= nil and (caster:IsHero() or caster:HasInventory()) then
        local newCharges = self:GetCurrentCharges() - 1
        if newCharges > 0 then
            self:SetCurrentCharges(newCharges)
        else
            caster:RemoveItem(self)
        end
    end
end

function GetMoveToTreePosition( unit, target )
  local origin = unit:GetAbsOrigin()
  local building_pos = target:GetAbsOrigin()
  local distance = 120
  return building_pos + (origin - building_pos):Normalized() * distance
end

function CDOTA_BaseNPC:ManaBurn(hCaster, hAbility, fManaAmount, fDamagePerMana, iDamageType, bAffectedByManaLossReduction)
	if bAffectedByManaLossReduction then
		fManaAmount = fManaAmount * (100 - self:GetManaLossReductionPercentage()) * 0.01
	end

	local fCurrentMana = self:GetMana()
	if fCurrentMana < fManaAmount then
		fManaAmount = fCurrentMana
	end

	self:ReduceMana(fManaAmount)
	if fDamagePerMana and iDamageType then
		local fDamageToDeal = fManaAmount * fDamagePerMana
		ApplyDamage({ victim = self, attacker = hCaster, damage = fDamageToDeal, damage_type = iDamageType, ability = hAbility })
	end 
end

function CDOTA_BaseNPC:GetManaLossReductionPercentage()
	local mana_loss_reduction = 0
	local mana_loss_reduction_unique = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		if parent_modifier.GetCustomManaLossReductionPercentageUnique then
			mana_loss_reduction_unique = math.max(mana_loss_reduction_unique, parent_modifier:GetCustomManaLossReductionPercentageUnique())
		end

		if parent_modifier.GetCustomManaLossReductionPercentage then
			mana_loss_reduction = mana_loss_reduction + parent_modifier:GetCustomManaLossReductionPercentage()
		end
	end

	mana_loss_reduction = mana_loss_reduction + mana_loss_reduction_unique

	return mana_loss_reduction
end

function ConvertToTime( value )
  local value = tonumber( value )

if value <= 0 then
  return "00:00:00";
else
    hours = string.format( "%02.f", math.floor( value / 3600 ) );
    mins = string.format( "%02.f", math.floor( value / 60 - ( hours * 60 ) ) );
    secs = string.format( "%02.f", math.floor( value - hours * 3600 - mins * 60 ) );
    if math.floor( value / 3600 ) == 0 then
      return mins .. ":" .. secs
    end
    return hours .. ":" .. mins .. ":" .. secs
end
end

function DistanceBetweenPoints(v1,v2)
	return math.sqrt(math.pow(v2.x - v1.x,2) + math.pow(v2.y - v1.y,2) + math.pow(v2.z - v1.z,2))
end