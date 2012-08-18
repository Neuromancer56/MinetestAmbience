local night = {"Crickets_At_NightCombo", "horned_owl", "Wolves_Howling"}
local day = {"bird"}
local cave = {}

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 10 then
		return
	end
	timer = 0
	if math.random(1, 100) > 5 then
		return
	end
	if  minetest.env:get_timeofday() < 0.2 or  minetest.env:get_timeofday() > 0.8 then
		for _,player in ipairs(minetest.get_connected_players()) do
			if player:getpos().y < 0 then
				--TODO uncommend this if cave sounds are added
				--minetest.sound_play(cave[math.random(1, #cave)], {to_player = player:get_player_name()})
			else
				minetest.sound_play(night[math.random(1, #night)], {to_player = player:get_player_name()})
			end
		end
	else
		for _,player in ipairs(minetest.get_connected_players()) do
			if player:getpos().y < 0 then
				--TODO uncommend this if cave sounds are added
				--minetest.sound_play(cave[math.random(1, #cave)], {to_player = player:get_player_name()})
			else
				minetest.sound_play(day[math.random(1, #day)], {to_player = player:get_player_name()})
			end
		end
	end
end)
