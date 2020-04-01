extends Area2D



func _on_JumpArea_body_entered(body):
	#Checks the name of the Colliding object
	if body.name == "Player":
		print("Colliding")
		Global.isCollidingJumpPad = true
