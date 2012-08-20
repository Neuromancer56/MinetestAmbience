local night = {
	handler = {},
	frequency = 10,
	{name="horned_owl", length=3},
	{name="Wolves_Howling", length=11}
}

local night_frequent = {
	handler = {},
	frequency = 25,
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
	frequency = 25,
	{name="robin2", length=16},
	{name="birdsongnl", length=12.5},
	{name="bird", length=30}
}

local cave = {
	handler = {},
	frequency = 5,
	{name="Bats_in_Cave", length=5}
}

local cave_frequent = {
	handler = {},
	frequency = 100,
	{name="drippingwater_drip_a", length=2},
	{name="drippingwater_drip_b", length=2},
	{name="drippingwater_drip_c", length=2},
	{name="Single_Water_Droplet", length=3},
	{name="Spooky_Water_Drops", length=7}
}

local water = {
	handler = {},
	frequency = 0,--dolphins dont fit into small lakes
	{name="dolphins", length=6},
	{name="dolphins_screaming", length=16.5}
}
	
local water_frequent = {
	handler = {},
	frequency = 100,
	on_stop = "drowning_gasp",
	{name="scuba1bubbles", length=11},
	{name="scuba1calm", length=10},
	{name="scuba1calm2", length=8.5},
	{name="scuba1interestingbubbles", length=11},
	{name="scuba1tubulentbubbles", length=10.5}
}

local play_music = minetest.setting_getbool("music") or false
local music = {
	handler = {},
	frequency = 1,
	{name="mtest", length=4*60+33, gain=0.3},
	{name="music_1", length=1*60+52, gain=0.3},
	{name="ambiance", length=19, gain=0.3},
	{name="dark_ambiance", length=46, gain=0.3},
	{name="eastern_feeling", length=3*60+51, gain=0.3}
}

local is_daytime = function()
	return (minetest.env:get_timeofday() > 0.2 and  minetest.env:get_timeofday() < 0.8)
end

local get_ambience = function(player)
	local pos = player:getpos()
	pos.y = pos.y+1.5
	local nodename = minetest.env:get_node(pos).name
	if string.find(nodename, "default:water") then
		if music then
			return {water=water, water_frequent=water_frequent, music=music}
		else
			return {water=water, water_frequent=water_frequent}
		end
	end
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
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.cave_frequent == nil then
		local list = cave_frequent
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.night == nil then
		local list = night
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.night_frequent == nil then
		local list = night_frequent
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.day == nil then
		local list = day
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.day_frequent == nil then
		local list = day_frequent
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.music == nil then
		local list = music
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.water == nil then
		local list = water
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
	if still_playing.water_frequent == nil then
		local list = water_frequent
		if list.handler[player_name] ~= nil then
			if list.on_stop ~= nil then
				minetest.sound_play(list.on_stop, {to_player=player:get_player_name()})
			end
			minetest.sound_stop(list.handler[player_name])
			list.handler[player_name] = nil
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 1 then
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
