
/mob/living/carbon/key_down(_key, client/user)
	user.keys_held[_key] = world.time
	if(!user.keys_held["Shift"])
		switch(_key)
			if("R", "Southwest") // Southwest is End
				toggle_throw_mode()
				return
			if("1")
				a_intent_change(I_HELP)
				return
			if("2")
				a_intent_change(I_DISARM)
				return
			if("3")
				a_intent_change(I_GRAB)
				return
			if("4")
				a_intent_change(I_HURT)
				return
	return ..()
