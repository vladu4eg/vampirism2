local msgs = {
	["#donate1"] = {
		StartTime = 100,
		Interval = 300,
		MaxCount = 18,
	},
	["#donate2"] = {
		StartTime = 200,
		Interval = 400,
		MaxCount = 18,
	},
	["#donate3"] = {
		StartTime = 300,
		Interval = 360,
		MaxCount = 18
	}

}

for msg, info in pairs( msgs ) do
	Timers:CreateTimer( function()
		GameRules:SendCustomMessage(msg, 0, 0)
		if info.MaxCount then
			info.MaxCount = info.MaxCount - 1
			if info.MaxCount <= 0 then
				return
			end
		end
		return info.Interval
	end, info.StartTime )
end