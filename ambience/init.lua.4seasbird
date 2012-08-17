-- ***********************************************************************************
--													   ***********************************************
--					Ambience							**************************************************
--													   ***********************************************
-- ***********************************************************************************


BIRDS = true

-- ***********************************************************************************
--		BIRDS 			**************************************************
-- ***********************************************************************************
if BIRDS == true then
	local bird = {}
	bird.sounds = {}
	bird_sound = function(p)
				local wanted_sound = {name="bird", gain=0.6}
				bird.sounds[minetest.hash_node_position(p)] = {
					handle = minetest.sound_play(wanted_sound, {pos=p, loop=true}),
					name = wanted_sound.name, }
			end

	bird_stop = function(p)
				local sound = bird.sounds[minetest.hash_node_position(p)]
				if sound ~= nil then
					minetest.sound_stop(sound.handle)
					bird.sounds[minetest.hash_node_position(p)] = nil
				end
			end
	minetest.register_on_dignode(function(p, node)
		if node.name == "4seasons:bird" then
			bird_stop(p)

		end
	end)
	minetest.register_abm({
			nodenames = { "4seasons:leaves_spring",'default:leaves' },
			interval = NATURE_GROW_INTERVAL,
			chance = 200,
			action = function(pos, node, active_object_count, active_object_count_wider)
				local air = { x=pos.x, y=pos.y+1,z=pos.z }
				local is_air = minetest.env:get_node_or_nil(air)
				if is_air ~= nil and is_air.name == 'air' then
					minetest.env:add_node(air,{type="node",name='4seasons:bird'})
					bird_sound(air)
				end
			end
	})
	minetest.register_abm({
			nodenames = {'4seasons:bird' },
			interval = NATURE_GROW_INTERVAL,
			chance = 2,
			action = function(pos, node, active_object_count, active_object_count_wider)
				minetest.env:remove_node(pos)
				bird_stop(pos)
			end
	})
end


