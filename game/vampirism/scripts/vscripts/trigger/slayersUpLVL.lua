function OnStartTouch(trigger)
    if trigger.activator:GetName() == "npc_dota_hero_templar_assassin" then
        table.insert(Slayers,trigger.activator )
    end
end

function OnEndTouch(trigger)
    if trigger.activator:GetName() == "npc_dota_hero_templar_assassin" then
        for key, value in pairs(Slayers) do
            if trigger.activator == value then
                table.remove(Slayers,key )
            end
        end
    end
end