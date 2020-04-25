func checkIfDashed():
	if Input.is_action_pressed("dash"):
		return true
	else:
		return false

func setSlowtime():
	Engine.time_scale = 0.5
	
func setNormaltime():
	Engine.time_scale = 1
