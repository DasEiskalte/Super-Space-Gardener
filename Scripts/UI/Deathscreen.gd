extends Node2D

#Waits for buttonPressed signal
func _on_ButtonCollision_pressed():
	#Changes Scene to Main-Scene
	get_tree().change_scene("res://Scenes/Level/Main.tscn")
