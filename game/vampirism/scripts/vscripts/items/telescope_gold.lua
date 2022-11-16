
local time = 60 
function OnTelescope(event)
	time = 60 
	Timers:CreateTimer(time, function()
	    local hero = event.caster
        if hero and time then
            PlayerResource:ModifyLumber(hero,1000)
	        PlayerResource:ModifyGold(hero,50)
        end	
        return time
	end)
end

function OnUnequip(event)
	time = nil
end
