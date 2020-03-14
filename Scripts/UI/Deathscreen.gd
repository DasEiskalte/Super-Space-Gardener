extends Node2D


func _on_ButtonCollision_pressed():
	get_tree().change_scene("res://Scenes/Level/Main.tscn")
