local night = {
	handler = {},
	frequency = 5,
	{name="horned_owl", length=3},
	{name="Wolves_Howling", length=11}
}

local night_frequent = {
	handler = {},
	frequency = 50,
	{name="Crickets_At_NightCombo", length=69}
}

local day = {
	handler = {},
	frequency = 5,
	{name="Best Cardinal Bird", length=4},
	{name="craw", length=3},
	{name="bluejay", length=18}
}

local day_frequent = {
	handler = {},
	frequency = 50,
	{name="robin2", length=43},
	{name="birdsongnl", length=72},
	{name="bird", length=30}
}

local cave = {
	handler = {},
	frequency = 5,
	{name="Bats_in_Cave", length=5}
}

local cave_frequent = {
	handler = {},
	frequency = 50,
	{name="drippingwater_drip_a", length=2},
	{name="drippingwater_drip_b", length=2},
	{name="drippingwater_drip_c", length=2},
	{name="Single_Water_Droplet", length=3},
	{name="Spooky_Water_Drops", length=7}
}

local play_music = minetest.setting_getbool("music") or false
local music = {
	handler = {},
	frequency = 1,
	{name="mtest", length=4*60+33, gain=0.3}
}

local is_daytime = function()
	return (minetest.env:get_timeofday() > 0.2 or  minetest.env:get_timeofday() < 0.8)
end

local get_ambience = function(player)
	if player:getpos().y < 0 then
		if music then
			return {cave=cave, cave_frequent=cave_frequent, music=music}
		else
			return {cave=cave, cave_frequent=cave_frequent}
		end
	end
	if is_daytime() then
		if music then
			return {day=day, day_frequent=day_frequent, music=music}
		else
			return {day=day, day_frequent=day_frequent}
		end
	else
		if music then
			return {night=night, night_frequent=night_frequent, music=music}
		else
			return {night=night, night_frequent=night_frequent}
		end
	end
end

-- start playing the sound, set the handler and delete the handler after sound is played
local play_sound = function(player, list, number)
	local player_name = player:get_player_name()
	if list.handler[player_name] == nil then
		local gain = 1.0
		if list[number].gain ~= nil then
			gain = list[number].gain
		end
		local handler = minetest.sound_play(list[number].name, {to_player=player_name, gain=gain})
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
	if still_playing.music == nil then
		local list = music
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
	
	for _,player in ipairs(minetest.get_connected_players()) do
		local ambiences = get_ambience(player)
		stop_sound(ambiences, player)
		for _,ambience in pairs(ambiences) do
			if math.random(1, 100) <= ambience.frequency then
				play_sound(player, ambience, math.random(1, #ambience))
			end
		end
	end
end)
