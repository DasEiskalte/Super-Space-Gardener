extends Area2D

#Waits for enter signal
func _on_RockArea_body_entered(body):
	print("Entered")
	#Checks the name of the Colliding object
	if body.name == "Player":
		#Changes scene to Deathscreen
		get_tree().change_scene("res://Scenes/UI/Deathscreen.tscn")
