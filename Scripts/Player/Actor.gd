extends KinematicBody2D
class_name Actor

#Physic variables
const FLOOR_NORMAL: = Vector2.UP
export var speed: = Vector2(400.0, 500.0)
export var gravity: = 3500.0
var _velocity: = Vector2.ZERO

#Velocity
func _physics_process(delta: float) -> void:
	if _velocity.y < 1500:
		_velocity.y += gravity * delta
