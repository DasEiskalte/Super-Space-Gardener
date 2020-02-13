extends KinematicBody2D

export (int) var speed = 200
export (int) var speedSprint = 400
export (int) var gravity = 40
export (int) var jump = -6400

var velocity = Vector2()
var up = Vector2(0, -1)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	
	if Input.is_action_pressed('sprint'):
		velocity = velocity.normalized() * speedSprint
	else:
		velocity = velocity.normalized() * speed
		

func _physics_process(_delta):
	get_input()
	if !is_on_floor():
		velocity.y += gravity
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump
	velocity = move_and_slide(velocity, up)
