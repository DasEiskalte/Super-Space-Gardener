extends Area2D

#Waits for enter Signal
func _on_FinishArea_body_entered(body):
	if body.name == "Player":
		#Checks the name of the Colliding object
		get_tree().change_scene("res://Scenes/UI/Winscreen.tscn")
