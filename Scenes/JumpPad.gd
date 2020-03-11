extends StaticBody2D

func check_collision():
	if $RayCast2D.is_colliding() == true:
		return true
	else:
		return false
