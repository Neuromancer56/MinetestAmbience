--PilzAdam, check out my post about creating a function to determine setting

local night = {
	handler = {},
	{name="horned_owl", length=3},
	{name="horned_owl", length=3},
	{name="horned_owl", length=3},
	{name="Wolves_Howling", length=11}
}

local night_frequent = {
	handler = {},
	{name="Crickets_At_NightCombo", length=69}
}

local day = {
	handler = {},
	{name="Best Cardinal Bird", length=4},
	{name="craw", length=3},
	{name="bluejay", length=18}
}

local day_frequent = {
	handler = {},
	{name="robin2", length=43},
	{name="birdsongnl", length=72},
	{name="bird", length=30}
}

local cave = {
	handler = {},
	{name="Bats_in_Cave", length=5}
}

local cave_frequent = {
	handler = {},
	{name="drippingwater_dripa", length=2},
	{name="drippingwater_dripb", length=2},
	{name="drippingwater_dripc", length=2},
	{name="Single_Water_Droplet", length=3},
	{name="Spooky_Water_Drops", length=7}
}

local is_daytime = function()
	local daytime
	if  minetest.env:get_timeofday() < 0.2 or  minetest.env:get_timeofday() > 0.8 then 
		daytime = true
	else
		daytime = false
	end
	return daytime
end

local setting = function (player_parm)
	local settinglist
	if player_parm:getpos().y < 0 then
		settinglist = cave
	else
		if is_daytime then
			settinglist = day
		else
			settinglist = night
		end	
	end
	return settinglist
end

local setting_frequent = function (setting_parm)
	local setting_frequent_list
	if setting_parm == cave then
		setting_frequent_list = cave_frequent
	elseif setting_parm == day then
		setting_frequent_list = day_frequent
	else
		setting_frequent_list = night_frequent
	end
	return setting_frequent_list
end
	
	

-- start playing the sound, set the handler and delete the handler after sound is played
local play_sound = function(player, list, number)
	local player_name = player:get_player_name()
	if list.handler[player_name] == nil then
		local handler = minetest.sound_play(list[number].name, {to_player=player_name})
		if handler ~= nil then
			list.handler[player_name] = handler
			minetest.after(list[number].length, function(args)
				local list = args[1]
				local player_name = args[2]
				if list.handler[player_name] ~= nil then
					minetest.sound_stop(list.handler[player_name])
					list.handler[player_name] = nil
				end
			end, {list, player_name})
		end
	end
end

-- stops all sounds that are not in still_playing
local stop_sound = function(still_playing, player)
	local player_name = player:get_player_name()
	if still_playing.cave == nil then
		local list = cave
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.cave_frequent == nil then
		local list = cave_frequent
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.night == nil then
		local list = night
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.night_frequent == nil then
		local list = night_frequent
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.day == nil then
		local list = day
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.day_frequent == nil then
		local list = day_frequent
		if list.handler[player_name] ~= nil then
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 5 then
		return
	end
	timer = 0
	
	-- normal sounds
	if math.random(1, 100) <= 5 then  --this 5 is what I am trying to change based on setting
		for _,player in ipairs(minetest.get_connected_players()) do
			player_setting = setting(player)
			stop_sound({cave=true, cave_frequent=true}, player)--big problem here
			play_sound(player, player_setting, math.random(1, #player_setting))
		end
	end

	-- frequent sounds
	if math.random(1, 100) <= 50 then
		for _,player in ipairs(minetest.get_connected_players()) do
			player_setting_frequent = setting_frequent(player)
			stop_sound({cave=true, cave_frequent=true}, player)--big problem here
			play_sound(player, player_setting_frequent, math.random(1, #player_setting_frequent))
		end
	end
end)