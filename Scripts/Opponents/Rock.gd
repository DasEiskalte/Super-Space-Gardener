extends Area2D


func _on_Area2D_body_entered(body):
	print("Entered")
	if "Player" in body.name:
		get_tree().change_scene("res://Scenes/UI/Deathscreen.tscn")

