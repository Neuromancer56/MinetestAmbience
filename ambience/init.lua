math.randomseed(3)
sound_playing = 0

minetest.register_globalstep(function(time)
		local time = minetest.env:get_timeofday()
	--	minetest.chat_send_all(time .. " " .. sound_playing)

		if sound_playing == 0 then
		sound_playing = time
		end

		if sound_playing > 1 and time < 0.05 then
		sound_playing = 0.05
		end
		
			--random wolves & owls at night
		if time > 0.8 or time < 0.2 then
				if math.random(10000) >9997 then
			 	minetest.sound_play("Wolves_Howling")
			end		 	
			if math.random(10000) >9997 then
			 	minetest.sound_play("horned_owl")
			end	
		end	
		if time > sound_playing then

			if time > 0.8 or time < 0.2 then
			sound_playing = time + 0.07
			minetest.sound_play("Crickets_At_NightCombo")
	
	 
			
			return true
			end	

				sound_playing = time + 0.1
				minetest.sound_play("bird")
				return true
		end
end)
